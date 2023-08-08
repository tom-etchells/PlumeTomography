%% Setup
clear variables
close all
clc
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


%% Run Setup
% set data directory for satellite runs
runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Space Carving\Data\along_cross_track');

% set run name, can be a specific folder or just the prefix (diffusive_
% will run any data folder named diffusive_xxx)
runName = '\simImages_';

% find folders for run
runs = dir(strcat(runDir, runName, '*'));


%% Run
for runNum = 1:length(runs) 
    %% Load Stuff
    % initial progress print
    fprintf('Starting run %i of %i\n', runNum, length(runs));

    % set dataDir to current run
    dataDir = strcat(runDir, '\', runs(runNum).name);
    
    % load simulated images and camera
    clear camera images scaleVoxels numImages
%     load((dataDir), 'camera', 'images', 'scaleVoxels', 'targetLLA', 'trueVoxels', 'scaleFactor')
    load(dataDir)
    numImages = length(images);
    

    %% Define accurate bounds
    % base bounds on true bounds for consistency
    xBoundFinal = scaleVoxels.xBound;
    yBoundFinal = scaleVoxels.yBound;
    zBoundFinal = scaleVoxels.zBound;
    
    
    %% Create and carve final set of voxels
    % base resolution on true resolution for consistency
    finalVoxelResolution = scaleVoxels.resolution;
    
    % create final voxels
    finalVoxels = class_voxels(finalVoxelResolution, xBoundFinal, yBoundFinal, zBoundFinal);
    fprintf('Number of final voxels = %i\n', finalVoxels.number);
    
    % final voxel probability threshold
    finalVoxels.probThreshold = 1;
    finalVoxels.imagePercentage = 1;
    
    % start timer
    tStart = tic;
    % carve final set of voxels, use all images
    finalVoxels.plume = fcn_carve_voxels(camera, images, finalVoxels, targetLLA);
    % stop timer and report time
    tFinal = toc(tStart);
    fprintf('Final voxel carving time: %.2f\n', tFinal);
    
    % cleanup workspace
    clear finalVolume finalNumber finalVoxelResolution xBoundFinal yBoundFinal zBoundFinal
    
    
    %% Save data
    saveName = strcat(runDir, sprintf('\\simVoxels_%ix_%s_elev_%02i_%02i.mat', scaleFactor, reportLLAName(1:6), elevationBound, numImages));
    % save voxel classes
    save(saveName, 'finalVoxels', 'scaleVoxels', 'trueVoxels');
    fprintf('%s\nFinal Voxels: %i\nTrue Voxels: %i\n\n', saveName, length(finalVoxels.plume), length(trueVoxels.plume));

    clear finalVoxels
    clear runImages
end

%% 
% for i = 1:length(results_00)
%     perror_00(i) = abs(results_00(i).finalVoxels(1) - results_00(i).trueVoxels(1)) / results_00(i).trueVoxels(1);
%     perror_10(i) = abs(results_10(i).finalVoxels(1) - results_10(i).trueVoxels(1)) / results_10(i).trueVoxels(1);
%     perror_20(i) = abs(results_20(i).finalVoxels(1) - results_20(i).trueVoxels(1)) / results_20(i).trueVoxels(1);
%     perror_30(i) = abs(results_30(i).finalVoxels(1) - results_30(i).trueVoxels(1)) / results_30(i).trueVoxels(1);
%     perror_40(i) = abs(results_40(i).finalVoxels(1) - results_40(i).trueVoxels(1)) / results_40(i).trueVoxels(1);
% end
