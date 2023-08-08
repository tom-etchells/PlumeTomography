%% Setup
clear variables;
close all;
clc;
addpath classes
addpath(genpath('functions'))


%% Drive Directory
if isfolder("D:\Users\Tom\OneDrive - University of Bristol")
    driveDir = 'D:\Users\Tom\OneDrive - University of Bristol';
elseif isfolder("C:\Users\Tom\OneDrive - University of Bristol")
    driveDir = 'C:\Users\Tom\OneDrive - University of Bristol';
elseif isfolder("C:\Users\te14170\OneDrive - University of Bristol")
    driveDir = 'C:\Users\te14170\OneDrive - University of Bristol';
else
    print('Folder not found, stopping.')
    return
end


%% Set up loop
% handle subfolders of runs
folderDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Data\sat_tomog');

% set folder name
folderName = '\evenAngle_elev';

% find folders for run
folders = dir(strcat(folderDir, folderName, '*'));

% for each folder, find all subfolders which contain the actual data
for folderNum = 1:length(folders)
    fprintf('\nStarting folder  %i of %i: %s\n\n', folderNum, length(folders), folders(folderNum).name);

    % set data directory for satellite runs
    runDir = strcat(folderDir, '\', folders(folderNum).name);
    
    load(strcat(runDir, '\rms.mat'))
    runRMSNE(folderNum, :) = rmsne;
end

elev_00_rmsne_evenAngle = runRMSNE(1, :);
elev_10_rmsne_evenAngle = runRMSNE(2, :);
elev_20_rmsne_evenAngle = runRMSNE(3, :);
elev_30_rmsne_evenAngle = runRMSNE(4, :);
elev_40_rmsne_evenAngle = runRMSNE(5, :);
save('rmsne_evenAngle.mat', 'elev_00_rmsne_evenAngle', 'elev_10_rmsne_evenAngle', 'elev_20_rmsne_evenAngle', 'elev_30_rmsne_evenAngle', 'elev_40_rmsne_evenAngle')