function voxelsPixLoc = fcn_vox_glob2pix(camera, images, voxels, targetLLA)
%FCN_VOX_GLOB2PIX Carve voxels.
%   voxelsPixLoc = FCN_VOX_GLOB2PIX(camera, images, voxels.ENU, targetLLA)
%
%   Transforms voxels from ENU to pixel coordinates for each image.

% pre-allocate structure containing voxel pixel coordinates for each image
voxelsPixLoc(1:length(images)) = struct('pixLoc', zeros(3, length(voxels)));

% create waitbar
waitString = sprintf('Voxel Global to Pixel Transformation\nImage Number: 0 of %i', length(images));
waitBarTransform = waitbar(0, waitString);

for i = 1:length(images)
    % update waitbar
    waitString = sprintf('Voxel Global to Pixel Transformation\nImage Number: %i of %i', i, length(images));
    waitbar(i / length(images), waitBarTransform, waitString);
    
    % rotate voxels from ENU to ECEF
    voxelsVectENU = (voxels - images(i).ENU);
    voxelsVectENU = voxelsVectENU';
    [voxelsVectECEF(1,:), voxelsVectECEF(2,:), voxelsVectECEF(3,:)] = enu2ecefv(voxelsVectENU(1,:), voxelsVectENU(2,:), voxelsVectENU(3,:), targetLLA(1), targetLLA(2));
    
    % rotate voxels from ecef to camera coordinates
%     voxelsVectCam = 1/camera.refDataScale * images(i).cam2ecef' * voxelsVectECEF;
    voxelsVectCam = images(i).cam2ecef' * voxelsVectECEF;
    
    % divide through by z
    x = voxelsVectCam(1,:) ./ voxelsVectCam(3,:);
    y = voxelsVectCam(2,:) ./ voxelsVectCam(3,:);
    z = voxelsVectCam(3,:) ./ voxelsVectCam(3,:);
    
    % find radial distance
    r2 = x.^2 + y.^2;
    
    % tangential and radial distortions for clarity
    p = camera.pTangential;
    k = camera.kRadial;
    
    % find tangential distortion
    xTD = (2 * p(1) * x .* y) + (p(2) .* (r2 + 2 * x.^2));
    yTD = (2 * p(2) * x .* y) + (p(1) .* (r2 + 2 * y.^2));
    
    % find radial distortion
    xRD = x .* (1 + (k(1) * r2) + (k(2) * r2.^2) + (k(3) * r2.^3));
    yRD = y .* (1 + (k(1) * r2) + (k(2) * r2.^2) + (k(3) * r2.^3));
    
    % find the distorted points
    xDistorted = xTD + xRD;
    yDistorted = yTD + yRD;
    
    % project distorted points back to 3D camera coordinates 3x1
    camDistorted = [xDistorted; yDistorted; z];
    
    % distorted image plane coordinates
    voxelsPixLoc(i).pixLoc = round(camera.intrinsic * camDistorted);
    voxelsPixLoc(i).pixLoc = voxelsPixLoc(i).pixLoc';
    
    % set z pixel value to zero, will be used as flag if in plume
    voxelsPixLoc(i).pixLoc(:, 3) = 0;
end

% close waitbar
close(waitBarTransform);
end
