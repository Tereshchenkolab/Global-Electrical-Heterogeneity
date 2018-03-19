clear 
clc
close all
warning('OFF');

tic

% load mat files
[file_name,path_name] = uigetfile('*','Select file for Kors transformation');
path_name_saving=path_name;

%% file import
file_ID          = strsplit(file_name,'.');
file_path        = fullfile(path_name,file_name);


matfile          = matfile(file_path)


%% ===================== load variables from .mat file ========================
ECG12Lead      = matfile.ECG12Lead;

XYZ_O=kors(ECG12Lead);

save(file_path,'-append','XYZ_O');


%% =============================== 12 Lead Plot ====================================

    ECG12L = figure('visible','on');
    ax(1)=subplot(3,4,1);plot(ECG12Lead(:,1));ylabel('Lead I');
    ax(2)=subplot(3,4,2);plot(ECG12Lead(:,2));ylabel('Lead II');
    ax(3)=subplot(3,4,3);plot(ECG12Lead(:,3));ylabel('Lead III');
    ax(4)=subplot(3,4,4);plot(ECG12Lead(:,4));ylabel('Lead aVR');
    ax(5)=subplot(3,4,5);plot(ECG12Lead(:,5));ylabel('Lead aVL');
    ax(6)=subplot(3,4,6);plot(ECG12Lead(:,6));ylabel('Lead aVF');
    ax(7)=subplot(3,4,7);plot(ECG12Lead(:,7));ylabel('Lead V1');
    ax(8)=subplot(3,4,8);plot(ECG12Lead(:,8));ylabel('Lead V2');
    ax(9)=subplot(3,4,9);plot(ECG12Lead(:,9));ylabel('Lead V3');
    ax(10)=subplot(3,4,10);plot(ECG12Lead(:,10));ylabel('Lead V4');
    ax(11)=subplot(3,4,11);plot(ECG12Lead(:,11));ylabel('Lead V5');
    ax(12)=subplot(3,4,12);plot(ECG12Lead(:,12));ylabel('Lead V6');
    linkaxes(ax,'x');
%    saveas(ECG12L,strcat(images_folder,name0,'_12Lead'),'fig');


%% =============================== XYZ Leads Plot ====================================
    
    ECG3L = figure('visible','on');
    subplot(3,1,1);plot(XYZ_O(:,1));ylabel('Lead X');
    subplot(3,1,2);plot(XYZ_O(:,2));ylabel('Lead Y');
    subplot(3,1,3);plot(XYZ_O(:,3));ylabel('Lead Z');
%    saveas(ECG3L,strcat(images_folder,name0,'_3Lead'),'fig');


%% ============================ Function - Kors Matrix ============================

function transform_k = kors(leads12) %data in columns 12 leads
korsMatrix = [0.38, -0.07, 0, 0, 0, 0, -0.13, 0.05, -0.01, 0.14, 0.06,0.54;
              -0.07, 0.93, 0, 0, 0, 0, 0.06, -0.02, -0.05, 0.06, -0.17, 0.13;
              0.11, -0.23, 0, 0, 0, 0, -0.43, -0.06,-0.14,-0.20,-0.11,0.31];
transform_k = leads12 * korsMatrix';
end

