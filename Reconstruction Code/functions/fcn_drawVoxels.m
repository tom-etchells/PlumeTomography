function [voxPatch] = fcn_drawVoxels(fig, drawSettings, voxels, demPath)
%% Draw
% initial figure set-up
figure(fig);
% ax = fig.CurrentAxes;

voxPatch = fcn_drawHandler(fig, drawSettings, voxels);

% set lighting
lighting(drawSettings.lighting);
camlight(drawSettings.camlight);

% % draw bounds
% count = 1;
% for ii = 1:2
%     for jj = 1:2
%         for kk = 1:2
%             bound.vert(count, :) = [voxels.xBound(ii), voxels.yBound(jj), voxels.zBound(kk)];
%             count = count + 1;
%         end
%     end
% end
% bound.face = [1 2 4 3; 1 2 6 5; 5 6 8 7; 7 8 4 3; 1 3 7 5; 2 4 8 6];
% patch('Faces',bound.face,'Vertices',bound.vert, 'FaceAlpha', 0)


%% DEM if given Dir for it
if nargin == 4
    dem = csvread(demPath);
    dem = dem(dem(:, 3) > -3000, :);

    DT = delaunayTriangulation(dem(:,1), dem(:,2));
    T = DT.ConnectivityList ;

    % Interpolate the scattered data
    F = scatteredInterpolant(dem(:,1), dem(:,2), dem(:,3), 'linear');
    % trisurf(T, DT.Points(:,1), DT.Points(:,2), F(DT.Points(:,1),DT.Points(:,2)) );
    trisurf(T, DT.Points(:,1), DT.Points(:,2), F(DT.Points(:,1),DT.Points(:,2)), 'FaceColor', [0.8 0.8 0.8], 'LineStyle', 'none');
end
end