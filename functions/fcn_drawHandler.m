function [voxPatch, FV] = fcn_drawHandler(fig, drawSettings, voxels)
%fcn_drawHandler Handler to draw voxels using voxelPlotter
%   [] = drawVox(X, Y, Z, V, voxRes, limits, min, max, value)
%
%   limits = 3 x 2 matrix, each row corresponding to x, y, z

% set active figure
figure(fig)
hold on;

% initial draw with default sliders
[voxPatch, FV] = drawPatch(fig, drawSettings, voxels.plume, voxels.resolution, drawSettings.lowDens,...
                            drawSettings.xBounds(1), diff(drawSettings.xBounds) + voxels.resolution);

% set-up handles for plot sliders
densHandle = uicontrol(fig, 'Style', 'slider',...
                            'Position', [80,50,300,25],...
                            'Min', drawSettings.lowDens,...
                            'Max', drawSettings.highDens,...
                            'Value', drawSettings.lowDens);

xStep = voxels.resolution / (diff(drawSettings.xBounds) - voxels.resolution);
xSlicePosHandle = uicontrol(fig,	'Style', 'slider',...
                                	'Position', [80,100,145,25],...
                                    'Min', drawSettings.xBounds(1),...
                                    'Max', (drawSettings.xBounds(2) - voxels.resolution),...
                                    'Value', drawSettings.xBounds(1),...
                                    'SliderStep', [xStep, xStep * 10]);
                                
xSliceWidthHandle = uicontrol(fig,	'Style', 'slider',...
                                    'Position', [235,100,145,25],...
                                    'Min', voxels.resolution,...
                                    'Max', diff(drawSettings.xBounds) + voxels.resolution,...
                                    'Value', diff(drawSettings.xBounds) + voxels.resolution,...
                                    'SliderStep', [xStep, xStep * 10]);

% set-up callback functions for plot sliders
densCallBack = @(~, b) drawPatch(fig, drawSettings, voxels.plume, voxels.resolution, b.AffectedObject.Value, xSlicePosHandle.Value, xSliceWidthHandle.Value);
xSlicePosCallBack = @(~, b) drawPatch(fig, drawSettings, voxels.plume, voxels.resolution, densHandle.Value, b.AffectedObject.Value, xSliceWidthHandle.Value);
xSliceWidthCallBack = @(~, b) drawPatch(fig, drawSettings, voxels.plume, voxels.resolution, densHandle.Value, xSlicePosHandle.Value, b.AffectedObject.Value);

% set-up listeners for plot sliders
addlistener(densHandle, 'Value', 'PostSet', densCallBack);
addlistener(xSlicePosHandle, 'Value', 'PostSet', xSlicePosCallBack);
addlistener(xSliceWidthHandle, 'Value', 'PostSet', xSliceWidthCallBack);

end

function [voxPatch, FV] = drawPatch(fig, drawSettings, voxels, voxRes, densLimit, xSlicePos, xSliceWidth)
    % update density uicontrol text
    uicontrol(fig,	'Style', 'text',...
                    'Enable', 'inactive',...
                    'FontSize', 12,...
                    'String', strcat("Density > ", string(round(densLimit, 4))),...
                    'HorizontalAlignment', 'left',...
                    'Position', [80,25,150,25]);
    
    % get nearest x voxel position to the slider value
    xVoxelPositions = drawSettings.xBounds(1):voxRes:drawSettings.xBounds(2);
    xSlicePos = interp1(xVoxelPositions, xVoxelPositions, xSlicePos, 'nearest');
    % update xSlicePos uicontrol text
    uicontrol(fig,	'Style', 'text',...
                    'Enable', 'inactive',...
                    'FontSize', 12,...
                    'String', strcat("xSlicePos =  ", string(xSlicePos)),...
                    'HorizontalAlignment', 'left',...
                    'Position', [80,75,200,25]);
                
    xSliceWidth = round(xSliceWidth / voxRes) * voxRes;
    % update xSliceWidth uicontrol text
    uicontrol(fig,	'Style', 'text',...
                    'Enable', 'inactive',...
                    'FontSize', 12,...
                    'String', strcat("xSliceWidth =  ", string(xSliceWidth)),...
                    'HorizontalAlignment', 'left',...
                    'Position', [235,75,200,25]);

    [X, Y, Z, V] = makeMeshGrid(voxels, xSlicePos, xSliceWidth);

    FV = FindExternalVoxels(X, Y, Z, V, voxRes, densLimit);
    voxPatch = VoxelPlotter(fig, drawSettings, FV, densLimit);
end

function [X, Y, Z, V] = makeMeshGrid(voxels, xSlicePos, xSliceWidth)

    voxels = voxels(voxels(:, 1) > (xSlicePos - xSliceWidth) & voxels(:, 1) < (xSlicePos + xSliceWidth), :);
    
    x = unique(voxels(:,1));
    y = flip(unique(voxels(:,2)));
    z = unique(voxels(:,3));

    [X, Y, Z] = meshgrid(x, y, z);

    for ii = 1:size(voxels, 1)
        ix = (x == voxels(ii, 1));
        iy = (y == voxels(ii, 2));
        iz = (z == voxels(ii, 3));
        V(iy, ix, iz) = voxels(ii, 4);
    end
end