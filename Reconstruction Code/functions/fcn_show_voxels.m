function fcn_show_voxels(resolution, plume, voxelColor, voxelAlpha)
%FCN_SHOW_VOXELS Show voxels.
%   FCN_SHOW_VOXELS(resolution, plume)
%
%   Shows voxels from plume, requires resolution of voxels.

x = unique(plume(:,1));
y = unique(plume(:,2));
z = unique(plume(:,3));

% Expand the model by 1 step in x,y,z
x = [x(1) - resolution;  x;  x(end) + resolution];
y = [y(1) - resolution;  y;  y(end) + resolution];
z = [z(1) - resolution;  z;  z(end) + resolution];

% Set new mesh grid for expanded model
[X, Y, Z] = meshgrid(x, y, z);

% Create an empty voxel model
V = zeros(size(X));
N = numel(plume(:, 1));

% Set voxels inside to 1
for i=1:N
    ix = (x == plume(i,1));
    iy = (y == plume(i,2));
    iz = (z == plume(i,3));
%     V(iy,ix,iz) = plume(i,4);
    V(iy,ix,iz) = 1;
end

hold on;
voxelPatch = patch(isosurface(X, Y, Z, V, 0.5));
isonormals(X, Y, Z, V, voxelPatch)
if nargin == 4
    set(voxelPatch, 'FaceColor',  voxelColor, 'EdgeColor', 'none', 'FaceAlpha', voxelAlpha);
else
    set(voxelPatch, 'FaceColor',  [0.9  0.9  0.9], 'EdgeColor', 'none');
end
end