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
% runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Data\space_carving\off_track_angles');
runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Data\sat_tomog\crossTrack');

% set run name, can be a specific folder or just the prefix (diffusive_
% will run any data folder named diffusive_xxx)
runName = '\simImages_';

% find folders for run
runs = dir(strcat(runDir, runName, '*'));
numRuns = length(runs);


%% Print Image Numbers
% for runNum = 1:numRuns
%     % set data dir
%     dataDir = strcat(runDir, '\', runs(runNum).name);
%     % load simulated image locations
%     clear images
%     load(dataDir, 'images')
% 
%     % print header
%     fprintf('if numCams == %i:\n',length(images))
%     % print each location
%     for i = 1:length(images)
%         imagesENU(i, :) = images(i).ENU / 1000;
%         fprintf('\tpositions.append([%f, %f, %f])\n', imagesENU(i, 1), imagesENU(i, 2), imagesENU(i, 3))
%     end
% end

%% Print Cross Track
crossTrackAngle = [0 10 20 30 40 50 60 70];
for runNum = 1:numRuns
    % set data dir
    dataDir = strcat(runDir, '\', runs(runNum).name);
    % load simulated image locations
    clear images
    load(dataDir, 'images')

    % print header
    fprintf('if crossTrack == %i:\n',crossTrackAngle(runNum))
    % print each location
    for i = 1:length(images)
        imagesENU(i, :) = images(i).ENU / 1000;
        fprintf('\tpositions.append([%f, %f, %f])\n', imagesENU(i, 1), imagesENU(i, 2), imagesENU(i, 3))
    end
end

%% Print For MultiSat
% for runNum = 1:numRuns
%     % set data dir
%     dataDir = strcat(runDir, '\', runs(runNum).name);
%     % load simulated image locations
%     clear images
%     load(dataDir, 'images')
% 
%     % print header
% %     fprintf('if offTrack == %i:\n', str2num(runs(runNum).name(20:21)))
%     fprintf('if numCams == %i:\n', length(images))
%     % print each location
%     for i = 1:length(images)
%         imagesENU(i, :) = images(i).ENU / 1000;
%         fprintf('\tpositions.append([%f, %f, %f])\n', imagesENU(i, 1), imagesENU(i, 2), imagesENU(i, 3))
%     end
% end