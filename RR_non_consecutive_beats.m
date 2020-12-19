% BY Kazi Haq,PhD
% Tereshchenko Lab, KCVI, OHSU
% December 2020
% This code is to calculate RR interval 
% by mannual selection of beats where beats in the median beats
% were not consecutive.


clear all
close all
clc
warning('OFF');
% location of original .mat files generated from GEH code 
path_name='C:\your folder\';
% destination folder location of the reviewed files
review_folder='C:\your folder\';
m_files=strcat(path_name,'*.mat');
t_files    = dir(m_files);
no_files           = length(t_files);

 for loop_files = 1:no_files
     close all;
     Rpeaks=[];
     Beat_ANN=[];
     rr_int=[];
    filename=t_files(loop_files).name;
    file=strcat(path_name,filename);
    [pathstr, name0, ext] = fileparts(file);
    disp(strcat(path_name,name0));
    load(file);
    l_file=load(file);
    test=exist('XYZ_R');
    if(test==1)
    XYZ_R=l_file.XYZ_R;
    else
     XYZ_R=l_file.XYZ_O;
    end
     Rpeaks=l_file.Rpeaks; 
     Beat_ANN=l_file.Beat_ANN; 
     Label_beat=l_file.Label_beat;
      if length(Beat_ANN)<length(Rpeaks(:,1))
                min_d=length(Beat_ANN);
        else
                min_d=length(Rpeaks(:,1));
      end
       
    figure;
    plot(Rpeaks(:,1),XYZ_R(Rpeaks(:,1),1),'x','LineWidth',1,'MarkerEdgeColor','r')
    for ii=1:min_d
    text(Rpeaks(ii,1)-100,XYZ_R(Rpeaks(ii,1),1),Beat_ANN(ii),'FontSize',14);
    end
    hold on
    plot(XYZ_R(:,1),'b');
    point_value=ginput();
    % If different non-consecutive beats are chosen "number=1".
    % if only conseutive beats are chosen "number=2".
    xx=input('Number= ');
    if(xx==1)
        k=1;
        mm=1;
        for ll=1:length(point_value)/2
            rr_int(k)=point_value(mm+1,1)-point_value(mm,1);
            k=k+1;
            mm=mm+2;
        end
    RR_interval=2*round(mean(rr_int));
    end
    if(xx==2)
    RR_interval=2*round(abs(diff(point_value(:,1)))/2);
    end
    %Var1 =if the T is distorted on not
    Var1=input('yes/no= ','s');
    %output is saved as RR_interval and Var1 on the original files
    save(file,'-append','RR_interval','Var1');
    disp(RR_interval);
     movefile(file,review_folder);
 end