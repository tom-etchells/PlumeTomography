function [] = fcn_tomog_images(runDir, runs, runSettings, runFlags)
%fcn_blenderSheppLoganCam Read camera postions and image data.
%   [] = fcn_blenderSheppLoganCam(runDir, runs, runSettings, runFlags)

for runNum = 1:length(runs)
    %% Setup and Read
    % set dataDir to current run
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

        % read alpha
        [~, ~, images(i).alpha] = imread(strcat(dataDir, '\raw\', images(i).name, '.png'));

        % read and set binary / density
        img = rgb2gray(imread(strcat(dataDir, '\raw\', images(i).name, '.png')));
        images(i).density = img;
        images(i).binary = logical(img);

        % get img location
        images(i).ENU = camPoses((i * 4 - 3):(i * 4 - 1), 4)' * runSettings.unitScale;

        % get cam poses
        images(i).cam2ecef = camPoses((i * 4 - 3):(i * 4 - 1), 1:3);

        % camera rotation for sensitivity analysis
        if runSettings.rotAngle
            rotAngle = deg2rad(str2num(dataDir(end-3:end)));
            if runSettings.satRun
                images(i).cam2ecef = eul2rotm([0 rotAngle 0]) * images(i).cam2ecef;
            else
                images(i).cam2ecef = eul2rotm([rotAngle 0 0]) * images(i).cam2ecef;
            end
        end

        % set scale factort to deal with camera coordiate system mismatch
        images(i).camVectorScale = [1 -1 -1]';
    end

    %% Camera values
    % cam2 = OBS/Purple
    % create camera object
    camera(1) = class_camera();

    if runSettings.focalLengthCustom
        % focal length sensitivity analysis
        camera(1).focalLength = str2num(dataDir(end-1:end)) * 1e-3;
    else
        % focal length for satellite runs
        camera(1).focalLength = runSettings.focalLength;
    end

    camera(1).pixelSize = runSettings.pixelSize;
    camera(1).resolution = [644, 512];
    % camera(1).kRadial = [-0.1962, -0.0280];

    % blender idealised
    fx = camera(1).focalLength / camera(1).pixelSize;
    fy = camera(1).focalLength / camera(1).pixelSize;
    cx = camera(1).resolution(1)/2;
    cy = camera(1).resolution(2)/2;
    skew = 0;
    camera(1).intrinsic = [fx skew cx; 0 fy cy; 0 0 1];

    % save results
    save(strcat(dataDir, '\camImages.mat'), 'camera', 'images')

    %% Test camera alignment
    % Draw camera positions
    if runFlags.drawCameraPosAll
        % initial figure set-up
        figdrawCameraPos = figure();
        figure(figdrawCameraPos);
        thisRunName = split(dataDir, '\');
        thisRunName = thisRunName{end};
        figdrawCameraPos.Name = strcat('camPos_ ', thisRunName);
        title(figdrawCameraPos.Name, 'interpreter', 'none');
        ax = figdrawCameraPos.CurrentAxes;
        hold on; grid on; box on; axis equal;
        xlabel('X East')
        ylabel('Y North')
        view(3)
    
        scatter3(0, 0, 0);
        for i = 1:numImages
            % get cam positions for each camera
            scatter3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3))
    %         text(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), images(i).name);
    
            distanceToTarget = norm(images(i).ENU);
    
            cam = images(i).camera;
            % get cam boresight vector
            camVectorView = [0 0 1]';
            camVectorView = camVectorView .* [1 -1 -1]';
            % ray directions in ENU
            rays(i).viewDir = images(i).cam2ecef * camVectorView;
            rays(i).viewDir = rays(i).viewDir ./ vecnorm(rays(i).viewDir);
            quiver3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), rays(i).viewDir(1), rays(i).viewDir(2), rays(i).viewDir(3), distanceToTarget * .75, 'k');
    
            % get cam up vector
            camVectorUp = [0 1 0]';
            camVectorUp = camVectorUp .* [1 -1 -1]';
            % ray directions in ENU
            rays(i).upDir = images(i).cam2ecef * camVectorUp;
            rays(i).upDir = rays(i).upDir ./ vecnorm(rays(i).upDir);
            quiver3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), rays(i).upDir(1), rays(i).upDir(2), rays(i).upDir(3), distanceToTarget * .25, 'r');
        end
    end
end

%% Test camera alignment
% Draw camera positions
if runFlags.drawCameraPos && ~runFlags.drawCameraPosAll
    % initial figure set-up
    figdrawCameraPos = figure();
    figure(figdrawCameraPos);
    thisRunName = split(dataDir, '\');
    thisRunName = thisRunName{end};
    figdrawCameraPos.Name = strcat('camPos_ ', thisRunName);
    title(figdrawCameraPos.Name, 'interpreter', 'none');
    ax = figdrawCameraPos.CurrentAxes;
    hold on; grid on; box on; axis equal;
    xlabel('X East')
    ylabel('Y North')
    view(3)

    scatter3(0, 0, 0);
    for i = 1:numImages
        % get cam positions for each camera
        scatter3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3))
%         text(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), images(i).name);

        distanceToTarget = norm(images(i).ENU);

        cam = images(i).camera;
        % get cam boresight vector
        camVectorView = [0 0 1]';
        camVectorView = camVectorView .* [1 -1 -1]';
        % ray directions in ENU
        rays(i).viewDir = images(i).cam2ecef * camVectorView;
        rays(i).viewDir = rays(i).viewDir ./ vecnorm(rays(i).viewDir);
        quiver3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), rays(i).viewDir(1), rays(i).viewDir(2), rays(i).viewDir(3), distanceToTarget * .75, 'k');

        % get cam up vector
        camVectorUp = [0 1 0]';
        camVectorUp = camVectorUp .* [1 -1 -1]';
        % ray directions in ENU
        rays(i).upDir = images(i).cam2ecef * camVectorUp;
        rays(i).upDir = rays(i).upDir ./ vecnorm(rays(i).upDir);
        quiver3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), rays(i).upDir(1), rays(i).upDir(2), rays(i).upDir(3), distanceToTarget * .25, 'r');
    end
end

end
