%% Setup
clear variables; close all; clc;

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
runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Space Carving\Data\blendElevationBound_00');

% set run name, can be a specific folder or just the prefix (diffusive_
% will run any data folder named diffusive_xxx)
runName = '\images_03';

% find folders for run
runs = dir(strcat(runDir, runName, '*'));

for runNum = 1:length(runs) 
    %% Read ground-truth
    % set dataDir to current run
    dataDir = strcat(runDir, '\', runs(runNum).name);

    vox = readmatrix(strcat(dataDir, '\voxs.csv'));
    vox = vox * 1000;
    trueVoxelResoultion = 100;
    % as rounding to half resolution grid, the grid is not 0 100 200 etc,
    % always floor and then always add half res
    vox2 = floor(vox / trueVoxelResoultion) * trueVoxelResoultion + (trueVoxelResoultion / 2);
    
    boundFine(1, :) = [-1500 11000];
    boundFine(2, :) = [-2500 2500];
    boundFine(3, :) = [-100 8000];
    trueVoxels = class_voxels(trueVoxelResoultion, boundFine(1, :), boundFine(2, :), boundFine(3, :));
    trueVoxels.plume = unique(vox2, 'row');
    trueVoxels.plume(:, 4) = 1;


    %% Fill Voxel Plume
    newVoxels = trueVoxels;
    vox = trueVoxels.plume;
    % for each x slice of the voxels
    for xSlice = min(vox(:, 1)):trueVoxelResoultion:max(vox(:, 1))-2*trueVoxelResoultion
        y = vox(vox(:, 1) == xSlice, 2);
        z = vox(vox(:, 1) == xSlice, 3);
        xHull = convhull(y, z);
        xHullPoints = [y(xHull) z(xHull)];
        currentVoxels = vox(vox(:, 1) == xSlice, :);

        allVoxels = trueVoxels.ENU(trueVoxels.ENU(:, 1) == xSlice, :);
        filledVoxels = inpolygon(allVoxels(:, 2), allVoxels(:, 3), y, z);
        filledVoxels = allVoxels(filledVoxels, :);
        filledVoxels(:, 4) = 1;
        newVoxels.plume = [newVoxels.plume; filledVoxels];
    end
    newVoxels.plume = unique(newVoxels.plume, 'row');
%%
    newVoxels2 = newVoxels;
    vox = newVoxels2.plume;
    % for each x slice of the voxels
    for zSlice = min(vox(:, 3))+2*trueVoxelResoultion:trueVoxelResoultion:max(vox(:, 3))
        x = vox(vox(:, 3) == zSlice, 1);
        y = vox(vox(:, 3) == zSlice, 2);
        zHull = convhull(x, y);
        zHullPoints = [x(zHull) y(zHull)];
        currentVoxels = vox(vox(:, 3) == zSlice, :);

        allVoxels = trueVoxels.ENU(trueVoxels.ENU(:, 3) == zSlice, :);
        filledVoxels = inpolygon(allVoxels(:, 1), allVoxels(:, 2), x, y);
        filledVoxels = allVoxels(filledVoxels, :);
        filledVoxels(:, 4) = 1;
        newVoxels2.plume = [newVoxels2.plume; filledVoxels];
    end
    newVoxels2.plume = unique(newVoxels2.plume, 'row');

%     trueVoxels = newVoxels;
%     save('trueVoxels.mat', 'trueVoxels')

    %% Draw Plumes
    figPlume = figure;
    figure(figPlume);
    hold on; grid on; box on; axis equal; axis tight;
    xlabel('East [m]'); ylabel('North [m]'); zlabel('Up [m]');
    
    % set active figure
    figure(figPlume);

    fcn_show_voxels(trueVoxels.resolution, trueVoxels.plume, [0.9 0.9 0.9], 1);
    lighting('gouraud')
    camlight headlight;
    view([200 25])
     %% Draw Plumes
    figPlumeNew = figure;
    figure(figPlumeNew);
    hold on; grid on; box on; axis equal; axis tight;
    xlabel('East [m]'); ylabel('North [m]'); zlabel('Up [m]');
    
    % set active figure
    figure(figPlumeNew);

    fcn_show_voxels(newVoxels.resolution, newVoxels.plume, [0.9 0.9 0.9], 1);
    lighting('gouraud')
    camlight headlight;
    view([200 25])
    %% Draw Plumes
    figPlumeNew2 = figure;
    figure(figPlumeNew2);
    hold on; grid on; box on; axis equal; axis tight;
    xlabel('East [m]'); ylabel('North [m]'); zlabel('Up [m]');
    
    % set active figure
    figure(figPlumeNew2);
    fcn_show_voxels(trueVoxels.resolution, trueVoxels.plume, [0.9 0.9 0.9], 1);
    fcn_show_voxels(newVoxels2.resolution, newVoxels2.plume, [0.9 0.5 0.9], 0.25);
    lighting('gouraud')
    camlight headlight;
    view([200 25])
end