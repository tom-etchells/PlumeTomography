function rays = fcn_pix2rays(camera, images)
%FCN_VOX_GLOB2PIX Carve voxels.
%   voxelsPixLoc = FCN_VOX_GLOB2PIX(camera, images, voxels.ENU, targetLLA)
%
%   Transforms pixels to ENU coordinates for each image.

% create waitbar
waitString = sprintf('Voxel Global to Pixel Transformation\nImage Number: 0 of %i', length(images));
waitBarTransform = waitbar(0, waitString);

for i = 1:length(images)
    % update waitbar
    waitString = sprintf('Voxel Global to Pixel Transformation\nImage Number: %i of %i', i, length(images));
    waitbar(i / length(images), waitBarTransform, waitString);
    
    
    cam = images(i).camera;
    
    clear pixLoc camVector
    % find pixels that are in the plume
    [pixLoc(2, :), pixLoc(1, :)] = find(images(i).binary);
    
%     % testing
%     if i == 1
%         % test pixels, edges of plume 1
%         pixLoc = [300 198; 319, 198; 319, 208; 346, 184; 366, 192; 342, 216; 372, 222; 363, 232; 350, 231; 337 234; 336 245; 352, 250; 361, 250]';
%     elseif i == 3
%         % test pixels, edges of plume 3
%         pixLoc = [300 198; 354 235; 352 250; 348 255; 344 263; 340 265; 323 264; 334 238; 345 233; 326 252; 328 257]';
%     end
    
    % fill z with 1
    pixLoc(3, :) = 1;
    
    % get cam vectors for each pixel
    camVector = camera(cam).intrinsic \ pixLoc;
    camVector = camVector ./ vecnorm(camVector);
    camVector = camVector .* images(i).camVectorScale;

    
%   camVector = camVector(:, :) * camVector(3, :);
    
    % ray directions in ENU
    rays(i).rayDirs = images(i).cam2ecef * camVector;
    rays(i).rayDirs = rays(i).rayDirs ./ vecnorm(rays(i).rayDirs);
    for j = 1:length(pixLoc)
        % get ray burden from pixel, through transfer function -1.7322e-04 0.0212 -1.0264 24.4517 -0.7371
        % alpha
        x = double(images(i).alpha(pixLoc(2,j), pixLoc(1,j)));
        
        % SheppLogan, 0.3125
        rays(i).rayBurdens(j, :) = 0.08308 * exp(0.01492 * x);

%         % SheppLogan Satellite Scale, 625
%         rays(i).rayBurdens(j, :) = 3.195e+08 * exp(0.01515  * x);

%         rays(i).rayBurdens(j, :) = (5.247e-11 * x^5) + (-2.747e-08 * x^4) +  (5.161e-06 * x^3) + (-0.0003924 * x^2) +  (0.01535 * x) + -0.06472;
%         rays(i).rayBurdens(j, :) = (0.1437 * x^5) + (0.2741 * x^4) +  (-0.06254 * x^3) + (-0.08637 * x^2) +  (0.6502 * x) + 0.7763;
%         rays(i).rayBurdens(j, :) = (-1.7322e-04 * x^4) + (0.0212 * x^3) + (-1.0264 * x^2) + (24.4517 * x) + (-0.7371);

        % Blender Fuego, A = 12.5
%         rays(i).rayBurdens(j, :) = (8.3946e-08 * x^5) + (-4.3948e-05 * x^4) +  (0.0083 * x^3) + (-0.6279 * x^2) +  (24.5598 * x) + -103.5586;
 
        % intensity
%         x = double(images(i).density(pixLoc(2,j), pixLoc(1,j)));
%         rays(i).rayBurdens(j, :) = (5.3053e-07 * x^4) +  (-7.6289e-05 * x^3) + (0.0036 * x^2) +  (-0.0447 * x) + 0.1840;
%         rays(i).rayBurdens(j, :) = 0.007 * exp(0.0449 * x);
%         rays(i).rayBurdens(j, :) = (-5.9701e+03 * x^4) +  (8.0763e+03 * x^3) + (-4.0670e+03 * x^2) +  (931.5826 * x) + 0.0848;
%         rays(i).rayBurdens(j, :) = (-0.6564 * x^4) +  (8.6718 * x^3) + (-42.6459 * x^2) +  (95.3941 * x) + 0.0848;
%         rays(i).rayBurdens(j, :) = (-2.3321e-07 * x^4) +  (1.2619e-04 * x^3) + (-0.0254 * x^2) +  (2.3290 * x) + 0.0848;
%         rays(i).rayBurdens(j, :) = double(images(i).density(pixLoc(2,j), pixLoc(1,j)));
    end
end

% close waitbar
close(waitBarTransform);
end
