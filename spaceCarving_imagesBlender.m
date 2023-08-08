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


%% New Auto Run
% set data directory for satellite runs
% runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Space Carving\Space Carving Scripts\Data\LMSim\2023-04-27-thesisImages');
runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Space Carving\Data\blendElevationBound_40');

% set run name, can be a specific folder or just the prefix (diffusive_
% will run any data folder named diffusive_xxx)
runName = '\images_';

% find folders for run
runs = dir(strcat(runDir, runName, '*'));

unitSacale = 1000;

%% Run
for runNum = 1:length(runs) 
    %% Setup images
    dataDir = strcat(runDir, '\', runs(runNum).name);

    camNames = readmatrix(strcat(dataDir, '\camNames.csv'), 'OutputType', 'string');
    camPoses = readmatrix(strcat(dataDir, '\camPoses.csv'));

    % create image objects
    numImages = length(camNames);
    images(1:numImages) = class_images();

    % read images and set positions
    for i = 1:numImages
        images(i).name = camNames(i);
        images(i).camera = 1;

        % read and set binary / density
        img = im2gray(imread(strcat(dataDir, '\raw\', images(i).name, '.png')));
        img(img(:) == 1) = 0;
        images(i).binary = logical(img);

        % get img location
        images(i).ENU = camPoses((i * 4 - 3):(i * 4 - 1), 4)' * unitSacale;

        % get cam poses
        images(i).cam2ecef = camPoses((i * 4 - 3):(i * 4 - 1), 1:3);

        % set scale factort to deal with camera coordiate system mismatch
        images(i).camVectorScale = [1 -1 -1]';
    end
    
    
    % Camera values
    % cam2 = OBS/Purple
    % create camera object
    camera(1) = class_camera();

    camera(1).focalLength = 50e-3;

    camera(1).pixelSize = 17e-6;
    camera(1).resolution = [640, 512];

    % blender idealised
    fx = camera(1).focalLength / camera(1).pixelSize;
    fy = camera(1).focalLength / camera(1).pixelSize;
    cx = camera.resolution(1) / 2;
    cy = camera.resolution(2) / 2;
    skew = 0;
    camera(1).intrinsic = [fx skew cx; 0 fy cy; 0 0 1];

    % save results
    save(strcat(dataDir, '\camImages.mat'), 'camera', 'images')
end

%% Draw camera alignment
% initial figure set-up
figure();
hold on; grid on; box on; axis equal;
xlabel('X East')
ylabel('Y North')
view(3)
numImages = length(images);
% fcn_show_voxels(trueVoxels.resolution, trueVoxels.plume, [0.5 0.5 0.5], 1);
scatter3(0, 0, 0);

for i = 1:numImages
    distanceToTarget(i) = norm(images(i).ENU);
end
minDistanceToTarget = min(distanceToTarget);

for i = 1:numImages
    % draw cam positions for each camera
    scatter3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3))

    % get distance to target
    distanceToTarget = norm(images(i).ENU);

    % draw some label text for each image
%     text(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), images(i).name);
%     text(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), datestr(orbit.time(i)));

    % get cam boresight vector
    camVectorView = [0 0 1]';
    camVectorView = camVectorView .* [1 -1 -1]';
    % ray directions in ECEF
    rays(i).viewDir = images(i).cam2ecef * camVectorView;
    rays(i).viewDir = rays(i).viewDir ./ vecnorm(rays(i).viewDir);
    % plot ray direction
    quiver3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), rays(i).viewDir(1), rays(i).viewDir(2), rays(i).viewDir(3), distanceToTarget * .85, 'k');

    % get cam up vector
    camVectorUp = [0 1 0]';
    camVectorUp = camVectorUp .* [1 -1 -1]';
    % ray directions in ECEF
    rays(i).upDir = images(i).cam2ecef * camVectorUp;
    rays(i).upDir = rays(i).upDir ./ vecnorm(rays(i).upDir);
    % plot ray directions
    quiver3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), rays(i).upDir(1), rays(i).upDir(2), rays(i).upDir(3), minDistanceToTarget * .25, 'r');
end