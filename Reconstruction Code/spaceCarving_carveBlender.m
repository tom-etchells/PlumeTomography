%% Setup
clear variables; close all; clc;
addpath classes
addpath functions


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


%% New Auto Run
% set data directory for satellite runs
% runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Space Carving\Space Carving Scripts\Data\LMSim\2023-04-27-thesisImages');
runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Space Carving\Data\blendElevationBound_30');

% set run name, can be a specific folder or just the prefix (diffusive_
% will run any data folder named diffusive_xxx)
runName = '\images_';

% find folders for run
runs = dir(strcat(runDir, runName, '*'));


%% Run
for runNum = 1:length(runs) 
    %% Read Data
    % set dataDir to current run
    dataDir = strcat(runDir, '\', runs(runNum).name);

    % initial progress print
    fprintf('Starting run %i of %i\n', runNum, length(runs));

    % load simulated images and camera
    clear camera images scaleVoxels numImages
%     load((dataDir), 'camera', 'images', 'scaleVoxels', 'targetLLA', 'trueVoxels', 'scaleFactor')
    load(strcat(dataDir, '\camImages.mat'))
    numImages = length(images);

    % load groundtruth
    load(strcat(runDir, '\trueVoxels.mat'))
    

    %% Define accurate bounds
    % base bounds on true bounds for consistency
    xBoundFinal = trueVoxels.xBound;
    yBoundFinal = trueVoxels.yBound;
    zBoundFinal = trueVoxels.zBound;
    
    
    %% Create and carve final set of voxels
    % base resolution on true resolution for consistency
    finalVoxelResolution = trueVoxels.resolution;
    
    % create final voxels
    finalVoxels = class_voxels(finalVoxelResolution, xBoundFinal, yBoundFinal, zBoundFinal);
    fprintf('Number of final voxels = %i\n', finalVoxels.number);
    
    % final voxel probability threshold
    finalVoxels.probThreshold = 1;
    finalVoxels.imagePercentage = 1;
    
    % start timer
    tStart = tic;
    % carve final set of voxels, use all images
    finalVoxels.plume = fcn_carve_voxels_blender(camera, images, finalVoxels);
    % stop timer and report time
    tFinal = toc(tStart);
    fprintf('Final voxel carving time: %.2f\n', tFinal);
    
    % cleanup workspace
    clear finalVolume finalNumber finalVoxelResolution xBoundFinal yBoundFinal zBoundFinal
    
    
    %% Save data
    save(strcat(dataDir, '\voxelsFinal.mat'), 'finalVoxels', 'trueVoxels');
    % save voxel classes
    fprintf('\nFinal Voxels: %i\nTrue Voxels: %i\n\n', length(finalVoxels.plume), length(trueVoxels.plume));

    clear fineVoxels

end