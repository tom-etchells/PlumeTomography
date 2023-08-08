%% Setup
clear variables; close all; clc;
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


%% Set Up Loop
% set data directory for satellite runs
runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Space Carving\Data\blendElevationBound_40');

% set run name, can be a specific folder or just the prefix (diffusive_
% will run any data folder named diffusive_xxx)
runName = '\images_';

% find folders for run
runs = dir(strcat(runDir, runName, '*'));
numRuns = length(runs);

% save name
saveName = '\results.mat';

% value for normalising the rmsne
normValue = 1;
% tolerance, for when using density (tomogrpahy)
tolerance = 1e-12;

%% Run Loop
for runNum = 1:numRuns
    %% Load Data
    fprintf('Starting run %i of %i\n', runNum, numRuns);

%     % load MATLAB voxels, rename sacleVoxels if needed
%     dataDir = strcat(runDir, '\', runs(runNum).name);
%     load(dataDir)
%     
%     % dumb renaming
%     trueVoxels = scaleVoxels;
%     trueVoxels.plume(:, 4) = 1;
%     finalVoxels.plume(:, 4) = 1; 

    % set dataDir to current run, load blender voxels
    dataDir = strcat(runDir, '\', runs(runNum).name);
    load(strcat(dataDir, '\voxelsFinal.mat'), 'finalVoxels')
    load(strcat(runDir, '\trueVoxels.mat'))
    finalVoxels.plume(:, 4) = 1; 
    

    %% First Comparison
    % read number of voxels
    numTrue = length(trueVoxels.plume);
    numSim = length(finalVoxels.plume);
    maxVoxels = max([numTrue numSim]);
    
    % initialise values
    countOvelap = 0;
    countSimOnly = 0;
    absoluteErrorOverlap = 0;
    absoluteErrorSimOnly = 0;
    
    % start timer
    tStartFirst = tic;
    for i = 1:length(finalVoxels.plume)
        testVoxel = abs(finalVoxels.plume(i, 1) - trueVoxels.plume(:, 1)) < tolerance &...
                    abs(finalVoxels.plume(i, 2) - trueVoxels.plume(:, 2)) < tolerance &...
                    abs(finalVoxels.plume(i, 3) - trueVoxels.plume(:, 3)) < tolerance;
        if find(testVoxel)
            countOvelap = countOvelap + 1;
            absoluteErrorOverlap(countOvelap) = abs((finalVoxels.plume(i, 4) - trueVoxels.plume(testVoxel, 4)));
        else
            countSimOnly = countSimOnly + 1;
            absoluteErrorSimOnly(countSimOnly) = abs(finalVoxels.plume(i, 4));
        end
    end
    % stop timer and report time
    tFinalFirst = toc(tStartFirst);
    fprintf('First Voxel Comparison Time: %.2f\n', tFinalFirst);
    
    
    %% Second Comparison
    countOvelapSecond = 0;
    countTrueOnly = 0;
    absoluteErrorOverlapSecond = 0;
    absoluteErrorTrueOnly = 0;
    
    % start timer
    tStartSecond = tic;
    for i = 1:length(trueVoxels.plume)
        testVoxel =  abs(trueVoxels.plume(i, 1) - finalVoxels.plume(:, 1)) < tolerance &...
                abs(trueVoxels.plume(i, 2) - finalVoxels.plume(:, 2)) < tolerance &...
                abs(trueVoxels.plume(i, 3) - finalVoxels.plume(:, 3)) < tolerance;
        if find(testVoxel)
            countOvelapSecond = countOvelapSecond + 1;
            absoluteErrorOverlapSecond(countOvelapSecond) = abs((finalVoxels.plume(testVoxel, 4) - trueVoxels.plume(i, 4)));
        else
            countTrueOnly = countTrueOnly + 1;
            absoluteErrorTrueOnly(countTrueOnly) = abs(trueVoxels.plume(i, 4));
        end
    end
    % stop timer and report time
    tFinalSecond = toc(tStartSecond);
    fprintf('Second Voxel Comparison Time: %.2f\n', tFinalSecond);

    if countOverlap ~= countOvelapSecond
        fprintf('\nSecond Voxel Comparison had a differnt number of overlapping pixels!\n')
    end


    %% Evaluation Metric
    % RMSE and RMSNE
    rmse(runNum) = sqrt((sum(absoluteErrorOverlap.^2) + sum(absoluteErrorSimOnly.^2) + sum(absoluteErrorTrueOnly.^2)) / (countOvelap + countSimOnly + countTrueOnly));
    rmsne(runNum) = rmse(runNum) / normValue;
    fprintf('Run %i rmsne: %f\n', runNum, rmsne(runNum));
end

%% Save Data
save(strcat(runDir, saveName), 'rmse', 'rmsne', 'normValue')

