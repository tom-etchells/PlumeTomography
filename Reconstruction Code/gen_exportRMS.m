%% Setup
% clear variables;
% close all;
clc;
% addpath classes
% addpath(genpath('functions'))

% exportgraphics(figRMS, 'rmsne_satTomo_elevBound.png', 'Resolution', 600)

%% Satellite Space Carving Figures
figRMS = figure();
hold on; box on; grid on;
ylabel('RMSNE')

% % ELEV ANGLE RMS
% plot(camNumbers, elev_00_rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^')
% plot(camNumbers, elev_10_rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'o')
% plot(camNumbers, elev_20_rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'square')
% plot(camNumbers, elev_30_rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'diamond')
% plot(camNumbers, elev_40_rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'pentagram')
% xlabel('Number of Images')
% legend('0^{\circ} Bound', '10^{\circ} Bound', '20^{\circ} Bound', '30^{\circ} Bound', '40^{\circ} Bound', 'Location', 'northeast')
% ylim([0.6 0.85])

% % OFF-TRACK ANGLE RMS
% offAngle = [0 10 20 30 40 50 60 70];
% plot(offAngle, rmsne(1:8), 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
% xlabel('Cross-Track Angle [deg]')
% ylim([0.6 0.85])
% xlim([0 70])

% % ALING AND CROSS PLUME RMS
% camNumbers = [3 5 9 15 31 50];
% plot(camNumbers, rmsne(13:18), 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^')
% plot(camNumbers, rmsne(1:6), 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'o')
% plot(camNumbers, rmsne(7:12), 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'square')
% xlabel('Number of Images')
% legend('Track Along Plume', 'Track Across Plume', 'Track Perpendicular to Plume', 'Location', 'northeast')
% ylim([0.57 0.85])

% % ELEV ANGLE RMS BLENDER
% plot(camNumbers, blend_elev_00_rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^')
% plot(camNumbers, blend_elev_10_rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'o')
% plot(camNumbers, blend_elev_20_rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'square')
% plot(camNumbers, blend_elev_30_rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'diamond')
% plot(camNumbers, blend_elev_40_rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'pentagram')
% xlabel('Number of Images')
% legend('0^{\circ} Bound', '10^{\circ} Bound', '20^{\circ} Bound', '30^{\circ} Bound', '40^{\circ} Bound', 'Location', 'northeast')
% % ylim([0.6 0.85])


%% Idealised Tomography
% % CAM NUMBERS
% camNumbers = [3 4 5 6 7 8 9 10];
% plot(camNumbers, rmsne, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
% xlabel('Number of Images')
% xlim([3 10])
% % ylim([0.44 0.54])

% % % FOCLA LENGTH
% plot([runs.SSDPercent], rmsne_elev_00, 'LineWidth', 1.5)
% plot([runs.SSDPercent], rmsne_elev_05, 'LineWidth', 1.5)
% plot([runs.SSDPercent], rmsne_elev_10, 'LineWidth', 1.5)
% plot([runs.SSDPercent], rmsne_elev_15, 'LineWidth', 1.5)
% plot([runs.SSDPercent], rmsne_elev_20, 'LineWidth', 1.5)
% plot([runs.SSDPercent], rmsne_elev_25, 'LineWidth', 1.5)
% xlabel('SSD as % of Reconstruction Resolution')
% plot(46, 0.4966, 'LineWidth', 2, 'MarkerSize', 18, 'MarkerFaceColor', 'none', 'Marker', 'o', 'Color', 'r')
% text(5, 0.52, 'Fuego 2017 \downarrow', 'FontSize', 14)
% legend('0^{\circ} Pitch', '5^{\circ} Pitch', '10^{\circ} Pitch', '15^{\circ} Pitch', '20^{\circ} Pitch', '25^{\circ} Pitch', 'Location', 'northwest')
% % ylim([0.43 0.46])
% % xlim([0 170])

% % POINTING RMS
% SSD = [runs.SSDOffsetPercentAvg];
% rmse = [runs.rmsne];
% plot([runs.SSDOffsetPercentAvg], [runs.rmsne], 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
% % plot(SSD(1:end-1), rmse(1:end-1), 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
% % text(2, rmsne(1), '\leftarrow Single Satellite Run', 'FontSize', 14)
% % legend('Average orbital distance', 'Closest approach', 'Location', 'southeast')
% xlabel('Pointing Error as % or Reconstruction Resolution')
% ylim([0.25 0.55])
% % xlim([0 400])


%% Satellite Tomography
% % ELEV ANGLE RMS
% camNumbers = [3 5 9 15 31 50];
% plot(camNumbers, elev_00_rmsne_evenTime, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^')
% % plot(camNumbers, elev_10_rmsne_evenTime, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'o')
% % plot(camNumbers, elev_20_rmsne_evenTime, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'square')
% % plot(camNumbers, elev_30_rmsne_evenTime, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'diamond')
% % plot(camNumbers, elev_40_rmsne_evenTime, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'pentagram')
% xlabel('Number of Images')
% legend('0^{\circ} Bound', '10^{\circ} Bound', '20^{\circ} Bound', '30^{\circ} Bound', '40^{\circ} Bound', 'Location', 'northeast')
% % ylim([0.6 0.85])

% % % ELEV ANGLE RMS EVEN ANGLE DISTRIBUTION
% camNumbers = [3 5 9 15 31 50];
% plot(camNumbers, elev_00_rmsne_evenAngle, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^')
% plot(camNumbers, elev_10_rmsne_evenAngle, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'o')
% plot(camNumbers, elev_20_rmsne_evenAngle, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'square')
% plot(camNumbers, elev_30_rmsne_evenAngle, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'diamond')
% plot(camNumbers, elev_40_rmsne_evenAngle, 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'pentagram')
% xlabel('Number of Images')
% legend('0^{\circ} Bound', '10^{\circ} Bound', '20^{\circ} Bound', '30^{\circ} Bound', '40^{\circ} Bound', 'Location', 'northeast')
% % ylim([0.6 0.85])

% FOCLA LENGTH
% offAngle = [0 10 20 30 40 50 60 70];
plot([runs.SSDPercent], [runs.rmsne], 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
xlabel('SSD as % of Reconstruction Resolution')
% ylim([0.43 0.46])
% xlim([0 70])

% % POINTING RMS
% % offAngle = [0 10 20 30 40 50 60 70];
% plot([runs.SSDOffsetPercentAvg], [runs.rmsne], 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
% plot([runs.SSDOffsetPercentMin], [runs.rmsne], 'LineWidth', 1, 'LineStyle', '--', 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'o', 'Color', 'k')
% % text(2, rmsne(1), '\leftarrow Single Satellite Run', 'FontSize', 14)
% legend('Average orbital distance', 'Closest approach', 'Location', 'southeast')
% xlabel('Pointing Error as % or Reconstruction Resolution')
% % ylim([0.43 0.46])
% % xlim([0 70])

% % % CROSS-TRACK ANGLE RMS
% crossAngle = [0 10 20 30 40 50 60 70];
% plot(crossAngle, rmsne(1:8), 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
% xlabel('Cross-Track Imaging Angle [deg]')
% % ylim([0.43 0.46])
% xlim([0 70])

% % CROSS-TRACK MULTI SAT ANGLE RMS
% crossAngle = [0 10 20 30 40 50 60 70];
% hold on
% plot(crossAngle(1), rmsne(1), 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', 'o', 'Color', 'k')
% plot(crossAngle(2:end), rmsne(2:8), 'LineWidth', 1.5, 'MarkerSize', 8, 'MarkerFaceColor', [1 1 1], 'Marker', '^', 'Color', 'k')
% text(2, rmsne(1), '\leftarrow Single Satellite Run', 'FontSize', 14)
% xlabel('Cross-Track Angle Separation [deg]')
% % ylim([0.43 0.46])
% xlim([0 70])



%% Export Orbital Paths
% % initial figure set-up
% figRMS = figure();
% hold on; box on; grid on; axis equal;
% xlabel('X East [m]')
% ylabel('Y North [m]')
% view(2)
% 
% scaleFactor = 100;
% numImages = length(images);
% % point_crs = [];
% % point_sat = [];
% % point_fcr = [];
% for i = 1:numImages
% %     point_crs(i, :) = [images(i).ENU(1)/scaleFactor, images(i).ENU(2)/scaleFactor, images(i).ENU(3)/scaleFactor];
% %     point_sat(i, :) = [images(i).ENU(1)/scaleFactor, images(i).ENU(2)/scaleFactor, images(i).ENU(3)/scaleFactor];
% %     point_fcr(i, :) = [images(i).ENU(1)/scaleFactor, images(i).ENU(2)/scaleFactor, images(i).ENU(3)/scaleFactor];
% end
% 
% line(point_sat(:, 1), point_sat(:, 2), point_sat(:, 3), 'LineWidth', 2, 'Color', [0 0.4470 0.7410])
% line(point_crs(:, 1), point_crs(:, 2), point_crs(:, 3), 'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980])
% line(point_fcr(:, 1), point_fcr(:, 2), point_fcr(:, 3), 'LineWidth', 2, 'Color', [0.9290 0.6940 0.1250])
% 
% fcn_show_voxels(scaleVoxels.resolution, scaleVoxels.plume, [0.5 0.5 0.5], 1);
% 
% legend('Track Along Plume', 'Track Across Plume', 'Track Perpendicular to Plume', 'Location', 'southeast')
% xlim([-10000 10000])
% ylim([-15000 5000])
% xticks([-10000 -5000 0 5000 10000])
% yticks([-10000 -5000 0 5000])
% ax = gca;
% ax.XAxis.Exponent = 3;
% ax.YAxis.Exponent = 3;


%% Formatting
figure(figRMS)
ax = gca;

% ax.YAxis.Exponent = -2;
% ytickformat('%.2f')

set(gca, 'FontSize', 14, 'FontWeight', 'bold')


%% Export
% exportgraphics(figRMS, 'rmsne_satTomo_elevBound.png', 'Resolution', 600)

