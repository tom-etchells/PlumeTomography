%% Setup
% clear variables;
close all;
% clc;
addpath classes
addpath functions


%% Setup figure
% figPlume = figure;
% figure(figPlume);
% hold on; grid on; box on; axis equal;
% xlabel('East'); ylabel('North');


%% Draw Plumes
figPlume = figure;
figure(figPlume);
hold on; grid on; box on; axis equal
xlabel('East [m]'); ylabel('North [m]'); zlabel('Up [m]');

% set active figure
% draw plume
% fcn_show_voxels(trueVoxels.resolution, trueVoxels.plume, [0.9 0.9 0.9], 1);
plot3(0, 0, 0, 'Color', [0.5 0.5 0.5], 'LineWidth', 10)
% plot3(0, 0, 0, 'Color', [0.9 0.5 0.9], 'LineWidth', 10)

% fcn_show_voxels(scaleVoxels.resolution, scaleVoxels.plume, [0.9 0.9 0.9], 1);
% fcn_show_voxels(finalVoxels.resolution, finalVoxels.plume, [0.9 0.5 0.9], 0.3);

fcn_show_voxels(trueVoxels.resolution, trueVoxels.plume, [0.9 0.9 0.9], 1);
fcn_show_voxels(finalVoxels.resolution, finalVoxels.plume, [0.9 0.5 0.9], 0.3);
lighting('gouraud')
camlight headlight;

% % values for matlab
% % basic figure
% view([130 30])
% 
% xlim([-5500 1000])
% ylim([-11000 100])
% zlim([-1500 4500])

% values for blender
% basic figure
view([-135 20])

xlim([-500 10000])
ylim([-3500 3500])
zlim([-100 7000])

% % scaled figure
% ax = gca;
% ax.CameraPosition = [images(1).ENU(:, 1), images(1).ENU(:, 2), images(1).ENU(:, 3)];

% % set cam up vector
% upECEF = images(1).cam2ecef * [0 1 0]';
% [upENU(1), upENU(2), upENU(3)] = ecef2enuv(upECEF(1), upECEF(2), upECEF(3), targetLLA(1), targetLLA(2));
% ax.CameraUpVector = -[upENU(1), upENU(2), upENU(3)];
% ax.CameraTarget = [0 0 0];

% legend('Ground Truth Input', 'Simulated Reconstruction', 'location', 'northeast');
% save
% figPlume.Color = 'white';
% figPlume.CurrentAxes.FontSize = 40;
% figPlume.Position = [0 0 1440 1080];
% % % saveas(figPlume, 'voxel_comp.fig')
% saveas(figPlume, 'voxel_comp.png')


%% Format
figure(figPlume)
ax = gca;

set(gca, 'FontSize', 14, 'FontWeight', 'bold')

%% Export
% exportgraphics(figPlume, 'satSC_MATLABPlume.png', 'Resolution', 600)