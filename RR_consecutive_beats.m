% BY Kazi Haq,PhD
% Tereshchenko Lab, KCVI, OHSU.
% December 2020 
% This code is to calculate RR intervals where at least 3 consecutive
% represntative beats were taken into account . The other with PVC/PAC
% moves to "Review_folder". 
clear all
close all
clc
warning('OFF');
% %location of original .mat files generated from GEH code 
path_name='C:\your folder\';
% location of the folder to move PVC/PAC files
review_folder='C:\your folder\';
m_files=strcat(path_name,'*.mat');
t_files    = dir(m_files);
no_files           = length(t_files);

 parfor loop_no = 1:no_files
     
    filename=t_files(loop_no).name;
    file=strcat(path_name,filename);
    [pathstr, name0, ext] = fileparts(file);
   
    disp(strcat(path_name,name0));

    matfile=load(file);
    Beat_ANN=[];
	Beat_ANN=matfile.Beat_ANN;
    Label_beat=matfile.Label_beat;
    Rpeaks=matfile.Rpeaks;
    
RR_Int=[];
n=1;
Rx=Rpeaks(:,1);
check=0;
if((Label_beat=='NV') & (Label_beat~='SV') & (Label_beat~='NA'))
 movefile(file,review_folder);
else   
    
for i=2:length(Rpeaks(:,1))-3
if(Beat_ANN(i)==Label_beat & Beat_ANN(i+1)==Label_beat & Beat_ANN(i+2)==Label_beat)
if(i==2 | Beat_ANN(i-1)~=Label_beat)
RR_Int(n)=Rx(i+1)-Rx(i);
RR_Int(n+1)=Rx(i+2)-Rx(i+1);
n=n+2;
else
 RR_Int(n)=Rx(i+2)-Rx(i+1);
 n=n+1;
end
check=1;
end
end
if(check==1)
RR_interval=2*mean(RR_Int);
% save_mat_f(file,RR_interval);
else
movefile(file,review_folder)
end


end
 end

 function save_mat_f(file,RR_interval)
    save(file,'-append','RR_interval');
 end