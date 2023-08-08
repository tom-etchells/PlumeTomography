function [] = fcn_tomog_tomog(runDir, runs, runSettings, runFlags)
%fcn_blenderSheppLoganTomog Perform tomographic reconstruction.
%   [] = fcn_blenderSheppLoganTomog(runDir, runs, runSettings, runFlags)


for runNum = 1:length(runs)
    %% Load Stuff
    tStart = tic;
    fprintf('Starting run %i of %i\n', runNum, length(runs));

    % set dataDir to current run
    dataDir = strcat(runDir, '\', runs(runNum).name);

    % load simulated images and camera
    clear camera images
    load(strcat(dataDir, '\camImages.mat'), 'camera', 'images')
    numImages = length(images);
    % load voxels
    clear finalVoxels blendSolvedVoxels blendTruthVoxels
    load(strcat(dataDir, '\voxelsFinal.mat'), 'finalVoxels')

%     load(strcat(dataDir, '\voxelsFine.mat'), 'fineVoxels')
%     finalVoxels = fineVoxels;

    %% Draw initial figure for rays
    if runFlags.drawRays
        % initial figure set-up
        figFinal = figure();
        figure(figFinal);
        figFinal.Name = 'figFinal';
        hold on; grid on; box on; axis equal; axis tight;
        xlabel('X EAST')
        ylabel('Y NORTH')
        xlim([-10 10])
        ylim([-10 10])
        zlim([-10 10])
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


    %% Tomographic Reconstruction
    % potentially skip initial reconstruction calculations, load
    % tomogDataSolved
    if runSettings.skipTomogCalc
        load(strcat(dataDir, '\tomogDataSolved.mat'), 'lowDens', 'highDens', 'blendTruthVoxels', 'blendSolvedVoxels')
    else
        % else we are doing the tomographic reconstruction

        % setup ray caluclations
        voxRes = finalVoxels.resolution;

        % bounding box for ray intersection (old voxel class)
        grid3D.minBound = [finalVoxels.xBound(1)-voxRes/2, finalVoxels.yBound(1)-voxRes/2, finalVoxels.zBound(1)-voxRes/2]';
        grid3D.maxBound = [finalVoxels.xBound(2)+voxRes/2, finalVoxels.yBound(2)+voxRes/2, finalVoxels.zBound(2)+voxRes/2]';

        % number of voxels in each direction (old voxel class)
        grid3D.nx = diff(finalVoxels.xBound) / voxRes + 1;
        grid3D.ny = diff(finalVoxels.yBound) / voxRes + 1;
        grid3D.nz = diff(finalVoxels.zBound) / voxRes + 1;

        % get ray directions for each pixel
        rays = fcn_pix2rays(camera, images);

        % get total number of rays
        totalRays = 0;
        for i = 1:numImages
            totalRays = totalRays + length(rays(i).rayDirs);
        end

        % preallocate projMatrix, based on max assumed voxel intersections
        maxVoxelsThroughPlume = max([grid3D.nx grid3D.ny grid3D.nz]);
        nz = totalRays * maxVoxelsThroughPlume;
        projMatrix = spalloc(totalRays, length(finalVoxels.plume), nz);
        rayBurden = zeros(totalRays, 1);

        count = 1;
        test = [];
        % start timer
        tStart = tic;
        fprintf(1,'Ray Tracing Progress\nImage %02i\nRay = %03.0f%%\n', 0, 0);

        % to par, count has to be replaced with something like rayNum +
        % length(rays(img).rayDirs) for each previous img, probably a for
        % loop counting the number of rays in the previous image
        for img = 1:numImages
            % update progress string
            waitProg = 0;
            fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b%02i\nRay = %03.0f%%\n', img, waitProg);
            numRays = length(rays(img).rayDirs);

            for rayNum = 1:numRays
%                 update progress string
                if round(rayNum / numRays * 100) > round((rayNum - 1) / numRays * 100)
                    waitProg = 100 * (rayNum / numRays);
                    fprintf('\b\b\b\b\b%03.0f%%\n', waitProg);
                end

                % verbose mode
                verbose = 0;

                % get intersections
                if runFlags.drawRays
                    intersects = amanatidesWooAlgorithm(figBlend, images(img).ENU', rays(img).rayDirs(:, rayNum), grid3D, verbose, runFlags.drawRays);
                else
                    intersects = amanatidesWooAlgorithm(0, images(img).ENU', rays(img).rayDirs(:, rayNum), grid3D, verbose, runFlags.drawRays);
                end

                % remove any zero length intersects
                intersects(intersects(:, 4) == 0, :) = [];

                if intersects ~= 0
                    % offset negative bounds by one voxel (old voxel class)
                    coordOffset = [finalVoxels.xBound(1) - voxRes, finalVoxels.yBound(1) - voxRes, finalVoxels.zBound(1) - voxRes];

                    % multiply intersection position by voxel resolution and add to offset
                    % bounds, gives actual position of intersection
                    interCoords = coordOffset + (intersects(:, 1:3) .* [voxRes voxRes voxRes]);
                    interCoords(:, 4) = intersects(:, 4);

                    [~, intersectsVoxelIndex, interPlumeIndex] = intersect(interCoords(:, 1:3), finalVoxels.plume(:, 1:3), 'rows');

                    % build projection matrix and ray burdens
                    projMatrix(count, interPlumeIndex) = interCoords(intersectsVoxelIndex, 4) ./ finalVoxels.resolution;
                    rayBurden(count, 1) = rays(img).rayBurdens(rayNum, 1);
                    
                    count = count+1;
                end
            end
        end

        % stop timer and report time
        tTrace = toc(tStart);
        fprintf('Finished Ray Tracing\n');
        fprintf('Final Ray Tracing Time: %.2f\n\n', tTrace);

        % remove rays with no plume voxel intersections
        rayBurden = rayBurden(any(projMatrix,2),:);
        projMatrix = projMatrix(any(projMatrix,2),:);

        % solve tomographic reconstruction equation
        numVoxels = length(finalVoxels.plume);

        if runSettings.satRun
            % bounds, gives okay results, Satellite Tomog, 1000^3 and then x10 again?
            lowDens = 1.5e8;
            highDens = 4e8;
        else
            % bounds, gives okay results SheppLogan
            lowDens = 0.015;
            highDens = 0.05;
        end

        % start timer
        tStart = tic;
        fprintf('Starting Tomographic Solver...\n');

        % final voxel densities
        voxDensity = lsqlin(projMatrix, rayBurden, [], [], [], [], ones(numVoxels, 1) * lowDens, ones(numVoxels, 1) * highDens);

        % stop timer and report time
        tSolve = toc(tStart);
        fprintf('Finished Tomographic Solver...\n');
        fprintf('Final Solver Time: %.2f\n\n', tSolve);

        % set voxel densities into voxel object
        blendSolvedVoxels = finalVoxels;
        blendSolvedVoxels.plume(:, 4) = voxDensity;

        % read groundtruth data
        dens = readmatrix(strcat(dataDir, '\density.csv'));
        verts = readmatrix(strcat(dataDir, '\verts.csv')) * runSettings.unitScale;

        % get divisions, this needs to be an int, should always be square..?
        domainDivisions = uint8(length(dens)^(1/3));
        % reshape and order V to match convention
        V = permute(reshape(dens, domainDivisions, domainDivisions, domainDivisions), [2 1 3]);

        % get bounds and voxel size (step)
        domainBounds = [min(verts); max(verts)];
        step = diff(domainBounds) / double(domainDivisions);

        volume = step(1) * step(2) * step(3);
        V = V .* volume;

        % make meshgrid
        x = (domainBounds(1, 1) + (step(1) / 2)):step:domainBounds(2, 1);
        y = (domainBounds(1, 2) + (step(2) / 2)):step:domainBounds(2, 2);
        z = (domainBounds(1, 3) + (step(3) / 2)):step:domainBounds(2, 3);
        [X, Y, Z] = meshgrid(x, y, z);

        blendTruthVoxels = class_voxels(step(1), domainBounds(:, 1), domainBounds(:, 2), domainBounds(:, 3));
        numVoxels = numel(X);
        count = 1;
        for i = 1:numVoxels
            if V(i) > 0.0001
                blendTruthVoxels.plume(count, :) = [X(i), Y(i), Z(i), V(i)];
                count = count + 1;
            end
        end

        % save data
        save(strcat(dataDir, '\tomogDataSolved.mat'), 'lowDens', 'highDens', 'blendTruthVoxels', 'blendSolvedVoxels');

        % cleanup workspace
        clear projMatrix rayBurden rays idxA idxB
    end

    %% Draw Results
    if runFlags.drawGroundTruth
        % initial figure set-up
        figBlendTruth = figure();
        figure(figBlendTruth);
        figBlendTruth.Name = 'groundTruth';
        title(figBlendTruth.Name, 'interpreter', 'none');
        hold on; grid on; box on; axis equal; axis tight;
        xlabel('X EAST')
        ylabel('Y NORTH')
        % SheppLogan
%         xlim([-5 5])
%         ylim([-5 5])
%         zlim([-5 5])

%         % Sat Tomog
        xlim([-9000 9000])
        ylim([-9000 9000])
        zlim([-9000 9000])
        view(3)
        view([-50 20])
        set(gca,'XTickLabels',[], 'YTickLabels', [], 'ZTickLabels', [], 'Title', [], 'XLabel', [], 'YLabel', [])

        % draw settings
        drawSettingsBlendTruth.lowDens = min(blendTruthVoxels.plume(:, 4));%0.001;
        drawSettingsBlendTruth.highDens = max(blendTruthVoxels.plume(:, 4));
        drawSettingsBlendTruth.lowAlpha = 0.1;
        drawSettingsBlendTruth.highAlpha = 1;
        drawSettingsBlendTruth.lighting = 'gouraud';
        drawSettingsBlendTruth.camlight = 'headlight';
        drawSettingsBlendTruth.edgeAlpha = 0;
        drawSettingsBlendTruth.xBounds(1) = min(blendTruthVoxels.plume(:, 1));
        drawSettingsBlendTruth.xBounds(2) = max(blendTruthVoxels.plume(:, 1));

        colorbar;
        caxis([drawSettingsBlendTruth.lowDens drawSettingsBlendTruth.highDens])
        % caxis([0.001 0.1])

        % draw data
        voxPatch = fcn_drawVoxels(figBlendTruth, drawSettingsBlendTruth, blendTruthVoxels);
    end

    if runFlags.drawTomog
        % initial figure set-up
        figBlendSolved = figure();
        figure(figBlendSolved);
        thisRunName = split(dataDir, '\');
        thisRunName = thisRunName{end};
        figBlendSolved.Name = strcat('solved ', thisRunName);
        title(figBlendSolved.Name, 'interpreter', 'none');
        ax = figBlendSolved.CurrentAxes;
        hold on; grid on; box on; axis equal; axis tight;
        xlabel('X EAST')
        ylabel('Y NORTH')
        % SheppLogan
%         xlim([-5 5])
%         ylim([-5 5])
%         zlim([-5 5])

        % Sat Tomog
        xlim([-9000 9000])
        ylim([-9000 9000])
        zlim([-9000 9000])
        view(3)
        view([-50 20])
        set(gca,'XTickLabels',[], 'YTickLabels', [], 'ZTickLabels', [], 'Title', [], 'XLabel', [], 'YLabel', [])

        drawSettingsBlendSolved.lowDens = lowDens;
        drawSettingsBlendSolved.highDens = highDens;
        drawSettingsBlendSolved.lowAlpha = 0.1;
        drawSettingsBlendSolved.highAlpha = 1;
        drawSettingsBlendSolved.lighting = 'gouraud';
        drawSettingsBlendSolved.camlight = 'headlight';
        drawSettingsBlendSolved.edgeAlpha = 0;
        drawSettingsBlendSolved.xBounds(1) = min(blendSolvedVoxels.plume(:, 1));
        drawSettingsBlendSolved.xBounds(2) = max(blendSolvedVoxels.plume(:, 1));

        colorbar('southoutside');
        caxis([drawSettingsBlendSolved.lowDens drawSettingsBlendSolved.highDens])
        % caxis([0.001 0.1])

        % draw data
        blendTomogPatch = fcn_drawVoxels(figBlendSolved, drawSettingsBlendSolved, blendSolvedVoxels);
    end
end
end
