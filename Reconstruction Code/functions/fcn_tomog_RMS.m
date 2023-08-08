function [] = fcn_tomog_RMS(runDir, runs, runSettings, runFlags)
%fcn_blenderSheppLoganTomog Perform tomographic reconstruction.
%   [] = fcn_blenderSheppLoganTomog(runDir, runs, runSettings, runFlags)

for runNum = 1:length(runs)
    %% Load Stuff
    tStart = tic;
    fprintf('Starting run %i of %i\n', runNum, length(runs));


    % set dataDir to current run
    dataDir = strcat(runDir, '\', runs(runNum).name);

    % load simulated images and camera
    load(strcat(dataDir, '\camImages.mat'), 'camera', 'images')
    numImages = length(images);
    runs(runNum).numImages = numImages;
    % load tomogDataSolved
    load(strcat(dataDir, '\tomogDataSolved.mat'), 'lowDens', 'highDens', 'blendTruthVoxels', 'blendSolvedVoxels')

    finalVoxels = blendSolvedVoxels;
    trueVoxels = blendTruthVoxels;


    %% Setup
    % value for normalising the rmsne
    normValue = highDens - lowDens;
%     normValue = (max(trueVoxels.plume(:, 4)) - min(trueVoxels.plume(:, 4)));
    % tolerance, for when using density (tomogrpahy)
    tolerance = 1e-12;

    

    %% First Comparison
    % read number of voxels
    numTrue = length(trueVoxels.plume);
    numSim = length(finalVoxels.plume);
    maxVoxels = max([numTrue numSim]);
    
    % initialise values
    countOverlap = 0;
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
            countOverlap = countOverlap + 1;
            absoluteErrorOverlap(countOverlap) = abs((finalVoxels.plume(i, 4) - trueVoxels.plume(testVoxel, 4)));
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
    rmse(runNum) = sqrt((sum(absoluteErrorOverlap.^2) + sum(absoluteErrorSimOnly.^2) + sum(absoluteErrorTrueOnly.^2)) / (countOverlap + countSimOnly + countTrueOnly));
    rmsne(runNum) = rmse(runNum) / normValue;
    fprintf('Run %i rmsne: %f\n', runNum, rmsne(runNum));

    runs(runNum).absoluteErrorOverlap = absoluteErrorOverlap;
    runs(runNum).absoluteErrorSimOnly = absoluteErrorSimOnly;
    runs(runNum).absoluteErrorOverlapSecond = absoluteErrorOverlapSecond;
    runs(runNum).absoluteErrorTrueOnly = absoluteErrorTrueOnly;
    runs(runNum).rmse = rmse(runNum);
    runs(runNum).rmsne = rmsne(runNum);

    imageNumbers(runNum) = numImages;
    if runSettings.focalLengthCustom
        for i = 1:imageNumbers(runNum)
            distToTarget(runNum, i) = norm(images(i).ENU);
        end
        avgDistToTarget(runNum) = mean(distToTarget(runNum, :));
        minDistToTarget(runNum) = min(distToTarget(runNum, :));

        focalLength(runNum) = camera(1).focalLength;
        iFoV = 2 * atan(camera(1).pixelSize(1) / (2 * focalLength(runNum)));
        runs(runNum).SSD = 2 * avgDistToTarget(runNum) * tan(iFoV / 2);
        runs(runNum).SSDPercent = (runs(runNum).SSD / blendTruthVoxels.resolution) * 100;
    end

    if runSettings.rotAngle
        degreeOffset(runNum) = str2num(dataDir(end-3:end));
        orbitDistance = zeros(1, numImages);
        for i = 1:length(images)
            orbitDistance(i) = norm(images(i).ENU);
        end
        minOrbitDistance = min(orbitDistance);
        avgOrbitDistance = mean(orbitDistance);
        SSDOffsetMin(runNum) = 2 * minOrbitDistance * tan(deg2rad(degreeOffset(runNum)) / 2);
        SSDOffsetAvg(runNum) = 2 * avgOrbitDistance * tan(deg2rad(degreeOffset(runNum)) / 2);
        runs(runNum).SSDOffsetPercentMin = (SSDOffsetMin(runNum) / blendTruthVoxels.resolution) * 100;
        runs(runNum).SSDOffsetPercentAvg = (SSDOffsetAvg(runNum) / blendTruthVoxels.resolution) * 100;
    end

    if runFlags.drawErrorHist == 1
        %% Histogram
        figure
        histogram(absoluteErrorOverlap, 1000, 'Normalization', 'probability')
        title(runs(runNum).name)
        ylim([0 1])
    end

end

%% Save Data
save(strcat(runDir, '\runs.mat'), 'runs');
save(strcat(runDir, '\rms.mat'), 'rmse', 'rmsne', 'normValue');


%% Draw RMS
if runFlags.drawRMS == 1
    figRMS = figure();
    hold on
    box on; grid on;

    % image numbers
    if ~runSettings.focalLength && ~runSettings.rotAngle && ~runSettings.satRun
        plot(imageNumbers, rmsne, '-^k', 'LineWidth', 3, 'MarkerSize', 10, 'MarkerFaceColor', 'auto')
        xlabel('Number of Viewpoints')
%         xlim([3 10])
%         xticks([3 4 5 6 7 8 9 10])
%         ylim([0.009 0.011])
    end

    % SSD
    if runSettings.focalLength
        for i = 1:length(runs)
            SSDPercent(i) = runs(i).SSDPercent;
        end
        plot(SSDPercent, rmsne, '-^k', 'LineWidth', 3, 'MarkerSize', 10, 'MarkerFaceColor', 'auto')
        xlabel('SSD as % of Reconstruction Resolution')
%         ylim([0.0095 0.014])
    end

    % Cam Rotation
    if runSettings.rotAngle
        for i = 1:length(runs)
            SSDOffsetPercent(i) = runs(i).SSDOffsetPercent;
        end
        plot(SSDOffsetPercent, rmsne, '-^k', 'LineWidth', 3, 'MarkerSize', 10, 'MarkerFaceColor', 'auto')
        xlabel('Pointing Error as % of Reconstruction Resolution')
%         ylim([0.0095 0.016])
%         xlim([0 450])
    end

    % image numbers
    if runSettings.satRun
        plot(imageNumbers, rmsne, '-^k', 'LineWidth', 3, 'MarkerSize', 10, 'MarkerFaceColor', 'auto')
        xlabel('Number of Images')
%         xlim([3 10])
%         xticks([3 4 5 6 7 8 9 10])
%         ylim([0.009 0.011])
    end

    ylabel('RMS Percentage Error [%]')
    ax = gca;
%     ax.YAxis.Exponent = -2;
%     ytickformat('%.2f')

    if runFlags.exportRMS
        figRMS.Color = 'white';
        figRMS.CurrentAxes.FontSize = 40;
        figRMS.Position = [0 0 1440 1080];
        
        exportgraphics(figRMS, 'RMS_elev_00.png', 'Resolution', 600)
    end
end




%% Draw error voxels
if runFlags.drawErrorVoxels == 1
    errorVoxels = blendSolvedVoxels;
    errorVoxels.plume = errorVoxels.plume(absPercentError > 100, :);

    % initial figure set-up
    figError = figure();
    figure(figError);
    figError.Name = 'figBlend';
    hold on; grid on; box on; axis equal; axis tight;
    xlabel('X EAST')
    ylabel('Y NORTH')
        % SheppLogan
%         xlim([-5 5])
%         ylim([-5 5])
%         zlim([-5 5])

    % Sat Tomog
    xlim([-10000 10000])
    ylim([-10000 10000])
    zlim([-10000 10000])
    view(3)
%     xticklabels

    drawSettingsError.lowDens = lowDens;
    drawSettingsError.highDens = highDens;
    drawSettingsError.lowAlpha = 0.1;
    drawSettingsError.highAlpha = 1;
    drawSettingsError.lighting = 'gouraud';
    drawSettingsError.camlight = 'headlight';
    drawSettingsError.edgeAlpha = 0.1;
    drawSettingsError.xBounds(1) = min(errorVoxels.plume(:, 1));
    drawSettingsError.xBounds(2) = max(errorVoxels.plume(:, 1));

    % demPath = strcat(dataDir, '\DEM_ENU.csv');
    % blendPatch = fcn_drawVoxels(figBlend, drawSettingsBlend, fineVoxels, demPath);
    blendPatch = fcn_drawVoxels(figError, drawSettingsError, errorVoxels);
end
end