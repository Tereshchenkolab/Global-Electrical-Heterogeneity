%
% GEH calculation code V.1.11
% Erick Andres Perez Alday, PhD, <perezald@ohsu.edu>
% Annabel Li-Pershing, BS, < lipershi@ohsu.edu>
% Muammar Kabir, PhD, < muammar.kabir@gmail.com >
% Larisa Tereshchenko, MD, PhD, < tereshch@ohsu.edu >
% Last update: February 14th, 2018

clear
clc
close all

warning('OFF');

% Input:
%      1. sampling frequency in HZ
%      2. matlab file containing the following:
%        - XYZ median beat
%        - index of QRS onset Vector Magnitudes
%        - index of R on Vector Magnitudes
%        - index of QRS offset Vector Magnitudes
%        - index of t onset on Vector Magnitudes
%        - index of t peak on Vector Magnitudes
%        - index of t offset on Vector Magnitudes
%        - index of origin point

% Output:
%      1. Excel inserted with calculated GEH parameters
%      2. Mat file containing the calculated GEH parameters
%      3. 3D fig file of GEH plot
%      4. 2D jpeg of AUC VM plot




%% =========================== File and user input =============================
% sampling frequency

% sampling frequency
prompt='What is the sampling frequency in Hz';
dlg_title='Sample Frequency';
fs_d = inputdlg(prompt,dlg_title,1);


% Amplitude resolution
prompt='What is the amplitude resolution in MicroVolts';
dlg_title='Amplitude';
amp_r = inputdlg(prompt,dlg_title,1);


fs=str2num(fs_d{1});
amp_r=str2num(amp_r{1});

% load mat files
[file_name,path_name] = uigetfile('*','Select file for GEH Analysis');
path_name_saving=path_name;

%% file import
file_ID          = strsplit(file_name,'.');
file_path        = fullfile(path_name,file_name);


matfile          = matfile(file_path)

%% ===================== load variables from .mat file ========================
XYZ_median      = matfile.XYZ_M*amp_r;
R_VM            = matfile.R_VM;
q_points_VM     = matfile.q_points_VM;
s_points_VM     = matfile.s_points_VM;
tp_points_VM    = matfile.tp_points_VM;
te_points_VM    = matfile.te_points_VM;
ts_points_VM    = matfile.ts_points_VM;
OriginPoint_idx = matfile.Opnt_Me(1,1);

%% ============================  initiate excel file ===========================
excel_file_name = 'All_Results.xls';
Results_folder = [path_name_saving, '/', 'Results', '/'];
if (exist(Results_folder,'file') ~= 7)
    mkdir (Results_folder);
end
% write title of the variables
if ~exist(strcat(Results_folder,excel_file_name))
    fid1 = fopen(strcat(Results_folder,excel_file_name),'a');
    fprintf(fid1,'ID \t');
    fprintf(fid1,'QRST Angle \t');
    fprintf(fid1,'Mean QRST Angle \t');
    fprintf(fid1,'QRS-SVG Angle \t');
    fprintf(fid1,'Mean QRS-SVG Angle \t');
    fprintf(fid1,'SVG-T Angle \t');
    fprintf(fid1,'Mean SVG-T Angle \t');
    fprintf(fid1,'Azimuth QRS \t');
    fprintf(fid1,'Mean Azimuth QRS \t');
    fprintf(fid1,'Azimuth T \t');
    fprintf(fid1,'Mean Azimuth T \t');
    fprintf(fid1,'Azimuth SVG \t');
    fprintf(fid1,'Mean Azimuth SVG \t');
    fprintf(fid1,'Elevation QRS \t');
    fprintf(fid1,'Mean Elevation QRS \t');
    fprintf(fid1,'Elevation T \t');
    fprintf(fid1,'Mean Elevation T \t');
    fprintf(fid1,'Elevation SVG \t');
    fprintf(fid1,'Mean Elevation SVG \t');
    fprintf(fid1,'QRS Magnitude \t');
    fprintf(fid1,'Mean QRS Magnitude \t');
    fprintf(fid1,'T Magnitude \t');
    fprintf(fid1,'Mean T Magnitude \t');
    fprintf(fid1,'SVG Magnitude \t');
    fprintf(fid1,'Mean SVG Magnitude \t');
    fprintf(fid1,'QT Interval \t');
    fprintf(fid1,'AUC of VectorMagnitude \t');
    fprintf(fid1,'Wilson VG \t');
    fprintf(fid1,'\n \n');
    fclose(fid1);
end


%% =============================================================================

% =========================== Variable Calculation ============-================
% calculation of Vector Magnitudes (Euclidian norm) using the origin point

for ii=1:length(XYZ_median (:,1))
	VecMag(ii)=norm([XYZ_median(OriginPoint_idx,1)-XYZ_median(ii,1),XYZ_median(OriginPoint_idx,2)-XYZ_median(ii,2),XYZ_median(OriginPoint_idx,3)-XYZ_median(ii,3)]);
end



% find R peak in median XYZ beat
[Rx_val, Rx]  = max(XYZ_median(1:500,1));
[Ry_val, Ry]  = max(XYZ_median(1:500,2));
[Rz_val, Rz]  = max(XYZ_median(1:500,3));

% define R peak and T peak as R axis and T axis
Raxis = XYZ_median(R_VM,:);
Taxis = XYZ_median(tp_points_VM(1),:);

% ========================== Calculate AUC on Vector Magnitude ===========================
spac_incr = 1000/fs; % spacing increment for trapz calculation
AUC_VM_QT=0;
AUC_VM_QT = trapz(abs(VecMag(q_points_VM(1,1):te_points_VM(1,1)))) * spac_incr;



% ======================= GEH Variable Calculation =============================
%  origin point
CP=XYZ_median(OriginPoint_idx,:);
% Y axis vector
Ynew=[0,1,0];
N_dat=length(q_points_VM(1,1):s_points_VM(1,1));


% QRS and T integration: VG calc
SumVGx=trapz(XYZ_median(q_points_VM(1,1):te_points_VM(1,1),1))*spac_incr;
SumVGy=trapz(XYZ_median(q_points_VM(1,1):te_points_VM(1,1),2))*spac_incr;
SumVGz=trapz(XYZ_median(q_points_VM(1,1):te_points_VM(1,1),3))*spac_incr;


% QRS and T mean vector
meanVxQ=trapz(XYZ_median(q_points_VM(1,1):s_points_VM(1,1),1))/N_dat;
meanVxT=trapz(XYZ_median(s_points_VM(1,1):te_points_VM(1,1),1))/N_dat;
meanVyQ=trapz(XYZ_median(q_points_VM(1,1):s_points_VM(1,1),2))/N_dat;
meanVyT=trapz(XYZ_median(s_points_VM(1,1):te_points_VM(1,1),2))/N_dat;
meanVzQ=trapz(XYZ_median(q_points_VM(1,1):s_points_VM(1,1),3))/N_dat;
meanVzT=trapz(XYZ_median(s_points_VM(1,1):te_points_VM(1,1),3))/N_dat;





% QRS and T mean vector based on mean
MEAN_QRSO=[meanVxQ meanVyQ meanVzQ];
MEAN_TO=[meanVxT meanVyT meanVzT];

% Q-S integral index length
si_len=length(q_points_VM(1,1):s_points_VM(1,1));


%% QT interval
timeM=((1:length(VecMag))/fs)*1000;
QT_interval=timeM(te_points_VM(1,1))-timeM(q_points_VM(1,1));


% QRS and T amplitude
QRS_amp=sqrt(Raxis(1)^2+Raxis(2)^2+Raxis(3)^2);
T_amp=sqrt(Taxis(1)^2+Taxis(2)^2+Taxis(3)^2);

% SVG vector calculation based on QRS-T, the two mean calculations of QRS-T

SVG_axis=sum([Taxis ; Raxis]);
SVG_axis_MO=sum([MEAN_TO;MEAN_QRSO]);





% Origin Point-P, Q-S and S-T vector calculation
qs3 = XYZ_median(q_points_VM(1,1):s_points_VM(1,1),3);
qs1 = XYZ_median(q_points_VM(1,1):s_points_VM(1,1),1);
qs2 = XYZ_median(q_points_VM(1,1):s_points_VM(1,1),2);
st3 = XYZ_median(s_points_VM(1,1):te_points_VM(1,1),3);
st1 = XYZ_median(s_points_VM(1,1):te_points_VM(1,1),1);
st2 = XYZ_median(s_points_VM(1,1):te_points_VM(1,1),2);



% ============================= Angle Claculation ==============================

% QRS-T angle
QRSTang=rad2deg(acos(dot(Raxis,Taxis)/(sqrt(Raxis(1)^2+Raxis(2)^2+Raxis(3)^2)*sqrt(Taxis(1)^2+Taxis(2)^2+Taxis(3)^2))));

% QRS-T mean vector angle
QRSTang_M=rad2deg(acos(dot(MEAN_QRSO,MEAN_TO)/(sqrt(MEAN_QRSO(1)^2+MEAN_QRSO(2)^2+MEAN_QRSO(3)^2)*sqrt(MEAN_TO(1)^2+MEAN_TO(2)^2+MEAN_TO(3)^2))));

% QRS SVG Angle: peak, mean in amplitude
QRSSVGang=rad2deg(acos(dot(Raxis,SVG_axis)/(sqrt(Raxis(1)^2+Raxis(2)^2+Raxis(3)^2)*sqrt(SVG_axis(1)^2+SVG_axis(2)^2+SVG_axis(3)^2))));
QRSSVGang_M=rad2deg(acos(dot(MEAN_QRSO,SVG_axis_MO)/(sqrt(SVG_axis_MO(1)^2+SVG_axis_MO(2)^2+SVG_axis_MO(3)^2)*sqrt(MEAN_QRSO(1)^2+MEAN_QRSO(2)^2+MEAN_QRSO(3)^2))));

% T SVG Angle: peak, mean in amplitude
SVGTang=rad2deg(acos(dot(SVG_axis,Taxis)/(sqrt(SVG_axis(1)^2+SVG_axis(2)^2+SVG_axis(3)^2)*sqrt(Taxis(1)^2+Taxis(2)^2+Taxis(3)^2))));
SVGTang_M=rad2deg(acos(dot(SVG_axis_MO,MEAN_TO)/(sqrt(MEAN_TO(1)^2+MEAN_TO(2)^2+MEAN_TO(3)^2)*sqrt(SVG_axis_MO(1)^2+SVG_axis_MO(2)^2+SVG_axis_MO(3)^2))));

% Azimuth of QRS: peak, mean in amplitude
AZ_OQ=(rad2deg(acos(Raxis(1)/sqrt(Raxis(1)^2+Raxis(3)^2))))*(((Raxis(3)<0)*-1)+((Raxis(3)>0)*1));
AZ_OQM=(rad2deg(acos( MEAN_QRSO(1)/sqrt(MEAN_QRSO(1)^2+MEAN_QRSO(3)^2))))*(((MEAN_QRSO(3)<0)*-1)+((MEAN_QRSO(3)>0)*1));

% Azimuth of T: peak, mean in amplitude
AZ_OT=(rad2deg(acos(Taxis(1)/sqrt(Taxis(1)^2+Taxis(3)^2))))*(((Taxis(3)<0)*-1)+((Taxis(3)>0)*1));
AZ_OTM=(rad2deg(acos(MEAN_TO(1)/sqrt(MEAN_TO(1)^2+MEAN_TO(3)^2))))*(((MEAN_TO(3)<0)*-1)+((MEAN_TO(3)>0)*1));

% Azimuth of SVG: peak, mean in amplitude
AZ_SVG=(rad2deg(acos(SVG_axis(1)/sqrt(SVG_axis(1)^2+SVG_axis(3)^2))))*(((SVG_axis(3)<0)*-1)+((SVG_axis(3)>0)*1));
AZ_SVG_M=(rad2deg(acos(SVG_axis_MO(1)/sqrt(SVG_axis_MO(1)^2+SVG_axis_MO(3)^2))))*(((SVG_axis_MO(3)<0)*-1)+((SVG_axis_MO(3)>0)*1));

% Elevation of QRS: peak, mean in amplitude
EL_OQ=(rad2deg(acos(dot(Raxis,Ynew)/(sqrt(Raxis(1)^2+Raxis(2)^2+Raxis(3)^2)*sqrt(Ynew(1)^2+Ynew(2)^2+Ynew(3)^2)))));
EL_OQM=(rad2deg(acos(dot(MEAN_QRSO,Ynew)/(sqrt(MEAN_QRSO(1)^2+MEAN_QRSO(2)^2+MEAN_QRSO(3)^2)*sqrt(Ynew(1)^2+Ynew(2)^2+Ynew(3)^2)))));

% Elevation of T: peak, mean in amplitude
EL_OT=(rad2deg(acos(dot(Taxis,Ynew)/(sqrt(Taxis(1)^2+Taxis(2)^2+Taxis(3)^2)*sqrt(Ynew(1)^2+Ynew(2)^2+Ynew(3)^2)))));
EL_OTM=(rad2deg(acos(dot(MEAN_TO,Ynew)/(sqrt(MEAN_TO(1)^2+MEAN_TO(2)^2+MEAN_TO(3)^2)*sqrt(Ynew(1)^2+Ynew(2)^2+Ynew(3)^2)))));

% Elevation of SVG: peak, mean in amplitude
EL_SVG=(rad2deg(acos(dot(SVG_axis,Ynew)/(sqrt(SVG_axis(1)^2+SVG_axis(2)^2+SVG_axis(3)^2)*sqrt(Ynew(1)^2+Ynew(2)^2+Ynew(3)^2)))));
EL_SVG_M=(rad2deg(acos(dot(SVG_axis_MO,Ynew)/(sqrt(SVG_axis_MO(1)^2+SVG_axis_MO(2)^2+SVG_axis_MO(3)^2)*sqrt(Ynew(1)^2+Ynew(2)^2+Ynew(3)^2)))));


% ========================== Magnitudes Calculation ============================
% Magnitude of QRS: peak, mean in amplitude
QRS_Mag=sqrt(Raxis(1)^2+Raxis(2)^2+Raxis(3)^2);
QRS_Mag_M=sqrt(MEAN_QRSO(1)^2+MEAN_QRSO(2)^2+MEAN_QRSO(3)^2);

% Magnitude of T: peak, mean in amplitude
T_Mag=sqrt(Taxis(1)^2+Taxis(2)^2+Taxis(3)^2);
T_Mag_M=sqrt(MEAN_TO(1)^2+MEAN_TO(2)^2+MEAN_TO(3)^2);

% Magnitude of SVG: peak, mean in amplitude
SVG_Mag=sqrt(SVG_axis(1)^2+SVG_axis(2)^2+SVG_axis(3)^2);
SVG_Mag_M=sqrt(SVG_axis_MO(1)^2+SVG_axis_MO(2)^2+SVG_axis_MO(3)^2);

% Magnitude of WVG: Wilson's Ventricular Gradient

WVG=sqrt((SumVGx^2) + (SumVGy^2) + (SumVGz^2));



%% =============================================================================
% ================================== Plotting ==================================





%% ============================ plot AUC on VegMag =============================



bLine_VM=ones(length(VecMag),1)*VecMag(OriginPoint_idx);
FT=[timeM(q_points_VM(1,1):te_points_VM(1,1)),fliplr(timeM(q_points_VM(1,1):te_points_VM(1,1)))];
F_VM=[VecMag(q_points_VM(1,1):te_points_VM(1,1))';fliplr(bLine_VM(q_points_VM(1,1):te_points_VM(1,1)))];



VM_AUC=figure('Name','AUC on VecMag','visible','on');

subplot(211)
v1=plot(timeM,VecMag,'k','DisplayName','Vector Magnitude');
hold on
fill(FT,F_VM,[0 0 0]+0.75)
hold off
xlabel('Time (ms)','FontSize',10);
ylabel('Amplitude (mV)','FontSize',10);
title('AUC of VectorMagnitude')
subplot(212)
x1=plot(timeM,XYZ_median(:,1),'DisplayName','X Lead');
hold on
x2=plot(timeM,XYZ_median(:,2),'DisplayName','Y Lead');
x3=plot(timeM,XYZ_median(:,3),'DisplayName','Z Lead');
xlabel('Time (ms)','FontSize',10);
ylabel('Amplitude (mV)','FontSize',10);

lgd = legend([v1 x1 x2 x3]);
hold off

%% =============================== GEH Plot ====================================

map_c=hsv;
map_c1=map_c(1:end-8,:);


Fig3D=figure('visible','on','outerposition',[0 0 1400 1000]);
ax3D = axes('Parent',Fig3D);
%% plotting GEH vectors and loops
hold on
p1 = plot3([CP(:,3) Raxis(3)],[CP(:,1) Raxis(1)],[CP(:,2) Raxis(2)],'r','LineWidth',2, 'DisplayName', 'Peak QRS');
p2 = plot3([CP(:,3) Taxis(3)],[CP(:,1) Taxis(1)],[CP(:,2) Taxis(2)],'g','LineWidth',2, 'DisplayName', 'Peak T');
p7 = plot3(CP(:,3),CP(:,1),CP(:,2),'m+','LineWidth',3,'DisplayName', 'Ori. point');
p3 = plot3([CP(:,3) MEAN_QRSO(3)],[CP(:,1) MEAN_QRSO(1)],[CP(:,2) MEAN_QRSO(2)],'r--','LineWidth',2,'DisplayName','Mean QRS');
p4 = plot3([CP(:,3) MEAN_TO(3)],[CP(:,1) MEAN_TO(1)],[CP(:,2) MEAN_TO(2)],'g--','LineWidth',2,'DisplayName','Mean T');
p5 = plot3([CP(:,3) SVG_axis(3)],[CP(:,1) SVG_axis(1)],[CP(:,2) SVG_axis(2)],'b','LineWidth',2, 'DisplayName', 'Peak SVG');
p6 = plot3([CP(:,3) SVG_axis_MO(3)],[CP(:,1) SVG_axis_MO(1)],[CP(:,2) SVG_axis_MO(2)],'b--','LineWidth',2,'DisplayName','Mean SVG');


% for plotting in patch function, need to decimate the last data point in the following 2 leads
qs1(end) = nan; qs2(end) = nan;
qrs_loop=patch(qs3,qs1,qs2,(1:spac_incr:spac_incr*length(qs1)),'EdgeColor','interp','DisplayName','QRS Loop');

% plot QRS loop point with the following
for c_ind = 1:5:length(qs1)
scatter3(qs3(c_ind),qs1(c_ind),qs2(c_ind),20,spac_incr*c_ind,'filled' );
end

% for plotting in patch function, need to decimate the last data point in the following 2 leads
st1(end) = nan; st2(end) = nan;
st_loop=patch(st3,st1,st2,(spac_incr*(length(qs1)+1):spac_incr:spac_incr*(length(qs1)+length(st1))),'EdgeColor','interp','DisplayName','T Loop');


% plot T loop with the following
%st_color = [(0.1:0.9/(length(st3)-1):1)',zeros(length(st3),1),flipud((0.1:0.9/(length(st3)-1):1)')];


for c_ind = 1:5:length(st3)
scatter3(st3(c_ind),st1(c_ind),st2(c_ind),20,spac_incr*(length(qs1)+c_ind),'filled');
end

% plot the projected lines to show SVG is the sum of QRS and T vectors
plot3([Raxis(3) SVG_axis(3)], [Raxis(1) SVG_axis(1)],[Raxis(2) SVG_axis(2)],'--','Color', [0.8 0.8 0.8],'LineWidth',2);
plot3([Taxis(3) SVG_axis(3)], [Taxis(1) SVG_axis(1)],[Taxis(2) SVG_axis(2)],'--','Color', [0.8 0.8 0.8],'LineWidth',2);

map_c=hsv;
map_c1=map_c(1:end-8,:);
caxis([0 2*(length(qs1)+length(st1))]);
colormap(map_c1)
colorbar

% uncomment this block for text annotation

% text attachment
%text(mean([CP(:,3) Raxis(3)]),mean([CP(:,1) Raxis(1)]),mean([CP(:,2) Raxis(2)]), '\leftarrow  QRS', 'FontSize', 18,'HorizontalAlignment','left');
%text( Taxis(3),Taxis(1),Taxis(2), '\leftarrow T', 'FontSize', 18, 'HorizontalAlignment','left');
%text(mean([CP(:,3) SVG_axis(3)]),mean([CP(:,1) SVG_axis(1)]),mean([CP(:,2) SVG_axis(2)]),'\leftarrow SVG', 'FontSize', 18, 'HorizontalAlignment','left');
%text(qs3(round(length(qs3)*3/4)),qs1(round(length(qs1)*3/4)),qs2(round(length(qs2)*3/4)),' \leftarrow QRS Loop', 'FontSize', 18, 'HorizontalAlignment','left');
%text(st3(round(length(st3)*3/5)),st1(round(length(st1)*3/5)),st2(round(length(st2)*3/5)),'\leftarrow T Loop', 'FontSize', 18, 'HorizontalAlignment','left');


set(gca,'YDir','reverse')
set(gca,'ZDir','reverse')


%% =========================== Additional Graphic ==============================

% ================= smiley face ==================
% location reference at the center of smiley face and coordinate
x_face = 400;
y_face = -400;
z_face = -400;
r_face = 150;
r_smiley = 110;
THK = 10; % thickness of face
d_eye = 75; % distance from the center of circle
h_eye = -50; % height from the center of the circle
x_coor = 400;
y_coor = -400;
z_coor = -200;
l_arrow = 150;
r_ctr = 10;

% change x y z above to move the smiley face
[x, y, z] = cylinder(150);
surf(z*THK+x_face, x+y_face,y+z_face, 'EdgeColor','none','FaceColor','y');
theta = -pi:0.05:pi;
x_circle = r_face*cos(theta);
y_circle = r_face*sin(theta);
% ================== front face ====================
fill3(zeros(1,length(x_circle))+x_face,x_circle+y_face,y_circle+z_face,'y')
% ================== back face =====================
fill3(zeros(1,length(x_circle))+x_face+THK,x_circle+y_face,y_circle+z_face,[0.5 0.5 0.5])
% =================== make eyes ====================
[x_sphere, y_sphere, z_sphere] = sphere; % unit sphere
 surf(x_sphere*5+x_face, y_sphere*THK+y_face+d_eye,z_sphere*THK+z_face+h_eye, 'EdgeColor', 'none', 'FaceColor', 'k')
 surf(x_sphere*5+x_face, y_sphere*THK+y_face-d_eye,z_sphere*THK+z_face+h_eye, 'EdgeColor', 'none', 'FaceColor', 'k')

% ==================== make nose ====================
t_cone = 0:0.005:0.5;
cone_clr = [255 171 0]./255;
cone_len = -40;
[x_cone, y_cone,z_cone] = cylinder(t_cone);
surf(-z_cone*cone_len+x_face+cone_len,x_cone*2*cone_len+y_face,y_cone*2*cone_len+z_face,'EdgeColor', 'none', 'FaceColor', [255 171 0]./255)

% ==================== make smile ====================
theta_smile = pi*0.2:0.05:pi*0.8;
x_smiley = r_smiley*cos(theta_smile);
y_smiley = r_smiley*sin(theta_smile);
 plot3(ones(1,length(x_smiley))+x_face-THK, x_smiley+y_face, y_smiley+z_face+10, 'k', 'LineWidth', 6)

% ===================== coordinate ====================
% coordinate center
surf(x_sphere*r_ctr+x_coor, y_sphere*r_ctr+y_coor, z_sphere*r_ctr+z_coor, 'EdgeColor', 'none', 'FaceColor', 'k');
% arrows
l = mArrow3([x_coor,y_coor,z_coor], [x_coor,y_coor+l_arrow,z_coor], 'color', 'r', 'stemWidth', 3);
text(x_coor,y_coor+l_arrow,z_coor, '\bf Left', 'FontSize', 6, 'HorizontalAlignment','right');
f = mArrow3([x_coor,y_coor,z_coor], [x_coor+l_arrow,y_coor,z_coor], 'color', 'b', 'stemWidth', 3);
text(x_coor+l_arrow+10,y_coor,z_coor, '\bf Posterior', 'FontSize', 6, 'HorizontalAlignment','left');
d = mArrow3([x_coor,y_coor,z_coor], [x_coor,y_coor,z_coor+l_arrow+20], 'color', 'g', 'stemWidth', 3);
text(x_coor,y_coor,z_coor+l_arrow+15, '\bf Inferior', 'FontSize', 6, 'HorizontalAlignment','center');

% ============================== plot properties ===============================
axis equal
grid on
box on
xlabel('Z (mV)','FontSize',20);
ylabel('X (mV)','FontSize',20);
zlabel('Y (mV)','FontSize',20);
zTickLabel = ax3D.XTick;
zTick = cellfun(@str2num, ax3D.XTickLabel);
set(gca,'XTick',zTick );
set(gca,'XTickLabel',zTickLabel);
view(290,60);

% plot legend and file ID
hold off


lgd = legend([p1 p3 p2 p4 p5 p6 p7 qrs_loop st_loop],'location','bestoutside');
title(lgd,file_ID{1});

%% =============================================================================

%% ==================== Write Calculated Variables to Excel ====================
fid1 = fopen(strcat(Results_folder,excel_file_name),'a');
fprintf(fid1,'%s \t',file_ID{1});
fprintf(fid1,'%f \t',QRSTang);
fprintf(fid1,'%f \t',QRSTang_M);
fprintf(fid1,'%f \t',QRSSVGang);
fprintf(fid1,'%f \t',QRSSVGang_M);
fprintf(fid1,'%f \t',SVGTang);
fprintf(fid1,'%f \t',SVGTang_M);
fprintf(fid1,'%f \t',AZ_OQ);
fprintf(fid1,'%f \t',AZ_OQM);
fprintf(fid1,'%f \t',AZ_OT);
fprintf(fid1,'%f \t',AZ_OTM);
fprintf(fid1,'%f \t',AZ_SVG);
fprintf(fid1,'%f \t',AZ_SVG_M);
fprintf(fid1,'%f \t',EL_OQ);
fprintf(fid1,'%f \t',EL_OQM);
fprintf(fid1,'%f \t',EL_OT);
fprintf(fid1,'%f \t',EL_OTM);
fprintf(fid1,'%f \t',EL_SVG);
fprintf(fid1,'%f \t',EL_SVG_M);
fprintf(fid1,'%f \t',QRS_Mag);
fprintf(fid1,'%f \t',QRS_Mag_M);
fprintf(fid1,'%f \t',T_Mag);
fprintf(fid1,'%f \t',T_Mag_M);
fprintf(fid1,'%f \t',SVG_Mag);
fprintf(fid1,'%f \t',SVG_Mag_M);
fprintf(fid1,'%f \t',QT_interval);
fprintf(fid1,'%f \t',AUC_VM_QT);
fprintf(fid1,'%f \t',WVG);
fprintf(fid1,'\n');
fclose(fid1);

%% =============================================================================

%% ======================== Save Plot to Image folder ==========================
Images_folder = [Results_folder 'All Figures' '/'];
if (exist(Images_folder) == 0)
  mkdir (Images_folder);
end

filepath = [Images_folder  strcat(file_ID{1},'_VM_AUC_QT.jpg')];
saveas(VM_AUC, filepath, 'jpg');

filepath = [Images_folder  strcat(file_ID{1},'_3D.fig')];
saveas(Fig3D, filepath, 'fig');
filepath = [Images_folder  strcat(file_ID{1},'_3D.jpg')];
saveas(Fig3D, filepath, 'jpg');


%% =============================================================================

%% ================== Write Calculated Variables to .mat file ==================
Mat_folder = [Results_folder 'Mat Files' '/'];
if (exist(Mat_folder) == 0)
mkdir (Mat_folder);
end

% Save to a new MAT file
save(strcat(Mat_folder,'/',file_ID{1},'.mat'), 'CP','AZ_OQ', 'AZ_OQM', 'AZ_OT', 'AZ_OTM', 'AZ_SVG', 'AZ_SVG_M', ...
    'EL_OQ', 'EL_OQM','EL_OT', 'EL_OTM', 'EL_SVG', 'EL_SVG_M', 'MEAN_QRSO', 'MEAN_TO', ...
    'QRSTang', 'QRSTang_M', 'QRSSVGang', 'QRSSVGang_M', 'SVGTang', 'SVGTang_M','SVG_axis', 'SVG_axis_MO', 'SVG_Mag', 'SVG_Mag_M', 'Taxis');

%% =============================================================================

%% ============================ Additional function ============================
    function h = mArrow3(p1,p2,varargin)
    %mArrow3 - plot a 3D arrow as patch object (cylinder+cone)
    %
    % syntax:   h = mArrow3(p1,p2)
    %           h = mArrow3(p1,p2,'propertyName',propertyValue,...)
    %
    % with:     p1:         starting point
    %           p2:         end point
    %           properties: 'color':      color according to MATLAB specification
    %                                     (see MATLAB help item 'ColorSpec')
    %                       'stemWidth':  width of the line
    %                       'tipWidth':   width of the cone
    %
    %           Additionally, you can specify any patch object properties. (For
    %           example, you can make the arrow semitransparent by using
    %           'facealpha'.)
    %
    % example1: h = mArrow3([0 0 0],[1 1 1])
    %           (Draws an arrow from [0 0 0] to [1 1 1] with default properties.)
    %
    % example2: h = mArrow3([0 0 0],[1 1 1],'color','red','stemWidth',0.02,'facealpha',0.5)
    %           (Draws a red semitransparent arrow with a stem width of 0.02 units.)
    %
    % hint:     use light to achieve 3D impression
    % Author: Georg Stillfried

    propertyNames = {'edgeColor'};
    propertyValues = {'none'};

    %% evaluate property specifications
    for argno = 1:2:nargin-2
        switch varargin{argno}
            case 'color'
                propertyNames = {propertyNames{:},'facecolor'};
                propertyValues = {propertyValues{:},varargin{argno+1}};
            case 'stemWidth'
                if isreal(varargin{argno+1})
                    stemWidth = varargin{argno+1};
                else
                    warning('mArrow3:stemWidth','stemWidth must be a real number');
                end
            case 'tipWidth'
                if isreal(varargin{argno+1})
                    tipWidth = varargin{argno+1};
                else
                    warning('mArrow3:tipWidth','tipWidth must be a real number');
                end
            otherwise
                propertyNames = {propertyNames{:},varargin{argno}};
                propertyValues = {propertyValues{:},varargin{argno+1}};
        end
    end

    %% default parameters
    if ~exist('stemWidth','var')
        ax = axis;
        if numel(ax)==4
            stemWidth = norm(ax([2 4])-ax([1 3]))/300;
        elseif numel(ax)==6
            stemWidth = norm(ax([2 4 6])-ax([1 3 5]))/300;
        end
    end
    if ~exist('tipWidth','var')
        tipWidth = 3*stemWidth;
    end
    tipAngle = 22.5/180*pi;
    tipLength = tipWidth/tan(tipAngle/2);
    ppsc = 50;  % (points per small circle)
    ppbc = 250; % (points per big circle)

    %% ensure column vectors
    p1 = p1(:);
    p2 = p2(:);

    %% basic lengths and vectors
    x = (p2-p1)/norm(p2-p1); % (unit vector in arrow direction)
    y = cross(x,[0;0;1]);    % (y and z are unit vectors orthogonal to arrow)
    if norm(y)<0.1
        y = cross(x,[0;1;0]);
    end
    y = y/norm(y);
    z = cross(x,y);
    z = z/norm(z);

    %% basic angles
    theta = 0:2*pi/ppsc:2*pi; % (list of angles from 0 to 2*pi for small circle)
    sintheta = sin(theta);
    costheta = cos(theta);
    upsilon = 0:2*pi/ppbc:2*pi; % (list of angles from 0 to 2*pi for big circle)
    sinupsilon = sin(upsilon);
    cosupsilon = cos(upsilon);

    %% initialize face matrix
    f = NaN([ppsc+ppbc+2 ppbc+1]);

    %% normal arrow
    if norm(p2-p1)>tipLength
        % vertices of the first stem circle
        for idx = 1:ppsc+1
            v(idx,:) = p1 + stemWidth*(sintheta(idx)*y + costheta(idx)*z);
        end
        % vertices of the second stem circle
        p3 = p2-tipLength*x;
        for idx = 1:ppsc+1
            v(ppsc+1+idx,:) = p3 + stemWidth*(sintheta(idx)*y + costheta(idx)*z);
        end
        % vertices of the tip circle
        for idx = 1:ppbc+1
            v(2*ppsc+2+idx,:) = p3 + tipWidth*(sinupsilon(idx)*y + cosupsilon(idx)*z);
        end
        % vertex of the tiptip
        v(2*ppsc+ppbc+4,:) = p2;

        % face of the stem circle
        f(1,1:ppsc+1) = 1:ppsc+1;
        % faces of the stem cylinder
        for idx = 1:ppsc
            f(1+idx,1:4) = [idx idx+1 ppsc+1+idx+1 ppsc+1+idx];
        end
        % face of the tip circle
        f(ppsc+2,:) = 2*ppsc+3:(2*ppsc+3)+ppbc;
        % faces of the tip cone
        for idx = 1:ppbc
            f(ppsc+2+idx,1:3) = [2*ppsc+2+idx 2*ppsc+2+idx+1 2*ppsc+ppbc+4];
        end

    %% only cone v
    else
        tipWidth = 2*sin(tipAngle/2)*norm(p2-p1);
        % vertices of the tip circle
        for idx = 1:ppbc+1
            v(idx,:) = p1 + tipWidth*(sinupsilon(idx)*y + cosupsilon(idx)*z);
        end
        % vertex of the tiptip
        v(ppbc+2,:) = p2;
        % face of the tip circle
        f(1,:) = 1:ppbc+1;
        % faces of the tip cone
        for idx = 1:ppbc
            f(1+idx,1:3) = [idx idx+1 ppbc+2];
        end
    end

    %% draw
    fv.faces = f;
    fv.vertices = v;
    h = patch(fv);
    for propno = 1:numel(propertyNames)
        try
            set(h,propertyNames{propno},propertyValues{propno});
        catch
            disp(lasterr)
        end
    end
end
