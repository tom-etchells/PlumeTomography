function [] = fcn_tomog_carve(runDir, runs, runSettings, runFlags)
%fcn_blenderSheppLoganCarve Perform initial space carving run to reduce search space.
%   [] = fcn_blenderSheppLoganCarve(runDir, runs, runSettings, runFlags)

for runNum = 1:length(runs)
    %% Load Stuff
    % initial progress print
    fprintf('Starting run %i of %i\n', runNum, length(runs));

    % set dataDir to current run
    dataDir = strcat(runDir, '\', runs(runNum).name);
    
    % load simulated images and camera
    clear camera images
    load(strcat(dataDir, '\camImages.mat'), 'camera', 'images')
    numImages = length(images);
    % load voxels
    clear finalVoxel
    
    
    %% Definal accurate bounds
    % SheppLogan voxel resoultion known
    finalVoxelResoultion = 0.3125;

    % known bounds so  just set slightly larger
    boundFinal(1, :) = [-5 5];
    boundFinal(2, :) = [-5 5];
    boundFinal(3, :) = [-5 5];

%     % SheppLogan voxel resoultion for satellite runs
%     finalVoxelResoultion = 625;
% 
%     % known bounds so  just set slightly larger, domain is now 20km x 20km
%     boundFinal(1, :) = [-10000 10000];
%     boundFinal(2, :) = [-10000 10000];
%     boundFinal(3, :) = [-10000 10000];
    
%     % Fuego Blender voxel resoultion known
%     finalVoxelResoultion = 12.5;
%     
%     % bounds
%     boundFinal(1, :) = [-100 700];
%     boundFinal(2, :) = [-400 400];
%     boundFinal(3, :) = [-100 700];
    
    
    %% Create and carve final set of voxels
    % create final voxels
    finalVoxels = class_voxels_tomog(finalVoxelResoultion, boundFinal(1, :), boundFinal(2, :), boundFinal(3, :));
    fprintf('Number of final voxels = %i\n', finalVoxels.number);
    
    % voxel in plume in this percentage of images
    finalVoxels.probThreshold = 4/4;
    % voxel present in this percentage of images
    finalVoxels.imagePercentage = 1/4;
    
    % start timer
    tStart = tic;
    % carve final set of voxels, use all images
    finalVoxels.plume = fcn_carve_voxels_blender(camera, images, finalVoxels);
    % stop timer and report time
    tFinal = toc(tStart);
    fprintf('Number of plume voxels = %i\n', length(finalVoxels.plume));
    fprintf('Final voxel carving time: %.2f\n\n', tFinal);
    
    % cleanup workspace
    clear finalVolume finalNumber finalVoxelResolution
    
    % save data
    save(strcat(dataDir, '\voxelsFinal.mat'), 'finalVoxels')
    
    
    %% Draw Final Voxels
    if runFlags.drawCarve
        % initial figure set-up
        figFinal = figure();
        figure(figFinal);
        thisRunName = split(dataDir, '\');
        thisRunName = thisRunName{end};
        figFinal.Name = strcat('figFinal ', thisRunName);
        title(figFinal.Name, 'interpreter', 'none');
        ax = figFinal.CurrentAxes;
        hold on; grid on; box on; axis equal; axis tight;
        xlabel('X EAST')
        ylabel('Y NORTH')
%         SheppLogan
%         xlim([-10 10])
%         ylim([-10 10])
%         zlim([-10 10])

        % Satellite
        xlim([-20000 20000])
        ylim([-20000 20000])
        zlim([-20000 20000])
        view(3)
        
        drawSettingsFinal.lowDens = 0;
        drawSettingsFinal.highDens = 1;
        drawSettingsFinal.lowAlpha = 0.1;
        drawSettingsFinal.highAlpha = 1;
        drawSettingsFinal.lighting = 'gouraud';
        drawSettingsFinal.camlight = 'headlight';
        drawSettingsFinal.edgeAlpha = 0.1;
        drawSettingsFinal.xBounds(1) = min(finalVoxels.plume(:, 1));
        drawSettingsFinal.xBounds(2) = max(finalVoxels.plume(:, 1));
        
        voxPatch = fcn_drawVoxels(figFinal, drawSettingsFinal, finalVoxels);
        
        for i = 1:numImages
            test(i).viewENU = images(i).cam2ecef * [0 0 1]';
            test(i).upENU = images(i).cam2ecef * [0 1 0]';
            scatter3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3))
            text(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), images(i).name);
            quiver3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), test(i).viewENU(1), test(i).viewENU(2), test(i).viewENU(3), 10)
            quiver3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), test(i).upENU(1), test(i).upENU(2), test(i).upENU(3), 5)
        end
    end
end
end
