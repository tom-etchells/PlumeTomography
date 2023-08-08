%% Setup
% clear variables; close all; clc;
addpath classes
addpath functions


%% Get Orbit Distance
for i = 1:length(images)
    distToTarget(i) = norm(images(i).ENU) / 1000;
end
% avgDistToTarget(runNum) = mean(distToTarget) / 1000;
% minDistToTarget(runNum) = min(distToTarget) / 1000;

%% Figure All Distances
% figRMS = figure();
% hold on; box on; grid on;
% ylabel('Distance to Target [km]')
% xlabel('Elevation Angle [deg]')
% plot(orbit.elevation(1:16), distToTarget(1:16), 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
% xlim([0 90])
% xticks([0 10 20 30 40 50 60 70 80 90])


%% Figure Orbit Elevation over Time
figRMS = figure();
hold on; box on; grid on;
ylabel('Elevation Angle [deg]')
xlabel('Orbit Time [s]')
orbitSeconds = zeros(1, length(orbit.time));
for i = 2:length(orbit.time)
    orbitSeconds(i) = seconds(orbit.time(i) - orbit.time(1));
end
plot(orbitSeconds, orbit.elevation, 'LineWidth', 1.5, 'Color', 'k')
xlim([0 max(orbitSeconds)])
ylim([0 90])
yticks([0 15 30 45 60 75 90])
% xticks([0 10 20 30 40 50 60 70 80 90])

%% Formatting
figure(figRMS)
ax = gca;

% ax.YAxis.Exponent = -2;
% ytickformat('%.2f')

set(gca, 'FontSize', 14, 'FontWeight', 'bold')


%% Export
% exportgraphics(figRMS, 'offTrack_orbitDistance.png', 'Resolution', 600)