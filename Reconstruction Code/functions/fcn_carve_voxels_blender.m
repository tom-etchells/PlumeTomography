function plume = fcn_carve_voxels_blender(camera, images, voxels)
%FCN_CARVE_VOXELS Carve voxels.
%   plume = FCN_CARVE_VOXELS(camera, images, voxels, targetLLA)
%
%   Transforms voxels from ENU to pixel coordinates for each image, checks
%   if voxel is visable in image, checkis if it appears in plume, performs
%   probability and connectivity checks, returns all voxels in plume.

%% Transform voxels
% enu2pix voxel transformation
voxelsPixLoc = fcn_vox_enu2pix(camera, images, voxels.ENU);


%% Carve voxels
% initialise array counting number of images each voxel appears in
voxelsNumInImages = zeros(length(voxels.ENU), 1);
% initialise array counting how many times each voxel appears in a plume
voxelsNumInPlumes = zeros(length(voxels.ENU), 1);
% initialise logical array storing if a voxel is in the plume or not
plumeVoxID = false(length(voxels.ENU), 1);

% create waitbar
waitString = sprintf('Voxel Carving\nImage Number: 0 of %i', length(images));
waitBarCarve = waitbar(0, waitString);

% for each image
for i = 1:length(images)
    cam = images(i).camera;

    % update waitbar
    waitString = sprintf('Voxel Carving\nImage Number: %i of %i', i, length(images));
    waitbar(i / length(images), waitBarCarve, waitString);

    % for each voxel
    for j = 1:length(voxels.ENU)
        % check if voxel is visable in current image 
        % resolution(1) is width, equal to columns and x pixels 
        inX = voxelsPixLoc(i).pixLoc(j, 1) <= camera(cam).resolution(1) && voxelsPixLoc(i).pixLoc(j, 1) > 0;
        % resolution(2) is height, equal to rows and y pixels
        inY = voxelsPixLoc(i).pixLoc(j, 2) <= camera(cam).resolution(2) && voxelsPixLoc(i).pixLoc(j, 2) > 0;
        
        % if the voxel does appear in the image
        if inX && inY
            % keep count of how many images this voxel appears in
            voxelsNumInImages(j) = voxelsNumInImages(j) + 1;
            
            % check if the corresponding pixel in the binary image is white
            % pixLoc(j, 2) is y pixel value, equal to row of binary image
            if images(i).binary(voxelsPixLoc(i).pixLoc(j, 2), voxelsPixLoc(i).pixLoc(j, 1)) == 1
                % if it is white then voxel is in the plume in this image
                voxelsNumInPlumes(j) = voxelsNumInPlumes(j) + 1;
            end
        end
    end
end

% perform probability check, how many images the voxel appears in the
% plume divided by how many images can see the voxel
voxelsPlumeProb = voxelsNumInPlumes ./ voxelsNumInImages;

% perform image percentage check, how many images can see the voxel divided
% by total number of images
voxelsImagePercentage = voxelsNumInImages ./ length(images);

for j = 1:length(voxels.ENU)
    % find index (row) of voxels with plume probability greater than
    % threshold and the voxel is seen by more than imagePercentage of cameras
    plumeVoxID(j) = (voxelsPlumeProb(j) >= voxels.probThreshold) && (voxelsImagePercentage(j) >= voxels.imagePercentage);
end

% final carved plume, only keeping voxels (rows) that meet the requirements
% above
plume = zeros(length(voxels.ENU(plumeVoxID, :)), 4);
plume(:, 1:3) = voxels.ENU(plumeVoxID, :);
plume(:, 4) = 1;

% close waitbar
close(waitBarCarve)
end
