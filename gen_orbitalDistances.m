%% Setup
clear variables;
close all; clc;
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
% runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Data\sat_tomog\crossTrack');
runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Data\space_carving\off_track_angles');

% set run name, can be a specific folder or just the prefix (diffusive_
% will run any data folder named diffusive_xxx)
runName = '\simImages_100x_crs_';

% find folders for run
runs = dir(strcat(runDir, runName, '*'));
numRuns = length(runs);

for runNum = 1:numRuns
    %% Load Data
    dataDir = strcat(runDir, '\', runs(runNum).name);
    load(dataDir)

    for i = 1:length(images)
        distToTarget(runNum, i) = norm(images(i).ENU);
    end
    avgDistToTarget(runNum) = mean(distToTarget(runNum, :)) / 1000;
    minDistToTarget(runNum) = min(distToTarget(runNum, :)) / 1000;

end

%% Figure Off-Track angle and distance
figRMS = figure();
hold on; box on; grid on;
ylabel('Distance to Target [km]')

offAngle = [0 10 20 30 40 50 60 70];
plot(offAngle, minDistToTarget, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
plot(offAngle, avgDistToTarget, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'o', 'Color', 'k')
legend('Minimum Distance', 'Average Distance', 'Location', 'best')

xlabel('Cross-Track Angle [deg]')
% ylim([0.6 0.85])
xlim([0 70])


%% Figure Off-Track angle and distance
% figRMS = figure();
% hold on; box on; grid on;
% ylabel('Distance to Target [km]')
% 
% offAngle = [0 10 20 30 40 50 60 70];
% plot(offAngle, minDistToTarget, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
% plot(offAngle, avgDistToTarget, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'o', 'Color', 'k')
% legend('Minimum Distance', 'Average Distance', 'Location', 'best')
% 
% xlabel('Cross-Track Angle')
% % ylim([0.6 0.85])
% xlim([0 70])


%% Formatting
figure(figRMS)
ax = gca;

% ax.YAxis.Exponent = -2;
% ytickformat('%.2f')

set(gca, 'FontSize', 14, 'FontWeight', 'bold')


%% Export
% exportgraphics(figRMS, 'offTrack_orbitDistance.png', 'Resolution', 600)