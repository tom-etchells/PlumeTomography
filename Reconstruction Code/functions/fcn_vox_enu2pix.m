function voxelsPixLoc = fcn_vox_enu2pix(camera, images, voxels)
%FCN_VOX_GLOB2PIX Carve voxels.
%   voxelsPixLoc = FCN_VOX_GLOB2PIX(camera, images, voxels.ENU, targetLLA)
%
%   Transforms voxels from ENU to pixel coordinates for each image.

% pre-allocate structure containing voxel pixel coordinates for each image
voxelsPixLoc(1:length(images)) = struct('pixLoc', zeros(4, length(voxels)));

% create waitbar
waitString = sprintf('Voxel Global to Pixel Transformation\nImage Number: 0 of %i', length(images));
waitBarTransform = waitbar(0, waitString);

for i = 1:length(images)
    cam = images(i).camera;
    
    % update waitbar
    waitString = sprintf('Voxel Global to Pixel Transformation\nImage Number: %i of %i', i, length(images));
    waitbar(i / length(images), waitBarTransform, waitString);
    
    % rotate voxels from ENU to ECEF
    voxelsVectENU = (voxels(:, 1:3) - images(i).ENU);
    voxelsVectENU = voxelsVectENU';
    
    % rotate voxels from ecef to camera coordinates
    voxelsVectCam = images(i).cam2ecef' * voxelsVectENU;
    
    % apply scale factor to deal with blender camera coordinate system
    voxelsVectCam = voxelsVectCam .* images(i).camVectorScale;
    
    % divide through by z
    x = voxelsVectCam(1,:) ./ voxelsVectCam(3,:);
    y = voxelsVectCam(2,:) ./ voxelsVectCam(3,:);
    z = voxelsVectCam(3,:) ./ voxelsVectCam(3,:);
    
    % find radial distance
%     r2 = x.^2 + y.^2;
    
    % tangential and radial distortions for clarity
%     p = camera(cam).pTangential;
%     k = camera(cam).kRadial;
    
    % find tangential distortion
%     xTD = (2 * p(1) * x .* y) + (p(2) .* (r2 + 2 * x.^2));
%     yTD = (2 * p(2) * x .* y) + (p(1) .* (r2 + 2 * y.^2));
    
    % find radial distortion
%     xRD = x .* (1 + (k(1) * r2) + (k(2) * r2.^2));
%     yRD = y .* (1 + (k(1) * r2) + (k(2) * r2.^2));
    
    % find the distorted points
%     xDistorted = xTD + xRD;
%     yDistorted = yTD + yRD;
%     xDistorted = xRD;
%     yDistorted = yRD;
    
    % project distorted points back to 3D camera coordinates 3x1
%     camDistorted = [xDistorted; yDistorted; z];
    camDistorted = [x; y; z];
    
%     camDistorted = camDistorted .* images(i).camVectorScale;
    
    % distorted image plane coordinates
    voxelsPixLoc(i).pixLoc = round(camera(cam).intrinsic * camDistorted);
    voxelsPixLoc(i).pixLoc = voxelsPixLoc(i).pixLoc';
    
    % set z pixel value to zero, will be used as flag if in plume
    voxelsPixLoc(i).pixLoc(:, 3) = 0;
%     voxelsPixLoc(i).pixLoc(:, 4) = voxels(:, 4);
end

% close waitbar
close(waitBarTransform);
end
