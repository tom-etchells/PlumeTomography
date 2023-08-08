function [vol_handle]=VoxelPlotter(fig, drawSettings, FV, densityLimit)
% set correct figure
figure(fig);

% clear axes of current figure
delete(findobj('tag', fig.Name));

% set each face alpha
faceAlpha = ones(length(FV.col), 1);
for i = 1:length(faceAlpha)
    if FV.col(i) < densityLimit
        faceAlpha(i) = drawSettings.lowAlpha;
    else
        faceAlpha(i) = drawSettings.highAlpha;
    end
end

% actually draw the patch
vol_handle = patch( 'Faces', FV.faces, 'Vertices', FV.vertices,...
                    'FaceVertexCData', FV.col, 'FaceColor', 'flat',...
                    'FaceVertexAlphaData', faceAlpha, 'FaceAlpha', 'flat',...
                    'EdgeAlpha', drawSettings.edgeAlpha, 'AlphaDataMapping', 'none', 'Tag', fig.Name);

% re-set lighting
ax = fig.CurrentAxes;
lighting(ax, drawSettings.lighting)

end
