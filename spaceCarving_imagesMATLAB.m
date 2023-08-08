%% Setup
clear variables; close all; clc;
addpath classes
addpath functions


%% Load Stuff
% data dir 
% volcanoDir = 'C:\Users\te14170\OneDrive - University of Bristol\PhD\Projects\Space Carving\Drone Data\Data\LMSim';
% volcanoDir = 'C:\Users\Tom\OneDrive - University of Bristol\PhD\Projects\Space Carving\Space Carving Scripts\Data\LMSim';
% volcanoDir = 'D:\OneDrive - University of Bristol\PhD\Projects\Space Carving\Space Carving Scripts\Data\LMSim';
volcanoDir = 'C:\Users\te14170\OneDrive - University of Bristol\PhD\Projects\3D Reconstruction\Thesis Scripts\Data';
% load volcano coordinates
load(strcat(volcanoDir, '\targetLLA.mat'))


%% Set simulated camera properties
% create sim camera class
camera = class_camera;

% % Tau 2 50mm
camera.pixelSize = [17e-6, 17e-06];
camera.focalLength = 50e-3;
camera.resolution = [640, 512];

% Basler 75mm
% camera.pixelSize = [2.4e-6, 2.4e-06];
% camera.focalLength = 50e-3;
% camera.resolution = [5472, 3648];

% calculate intrinsic properties
fx = camera.focalLength / camera.pixelSize(1);
fy = camera.focalLength / camera.pixelSize(2);
cx = camera.resolution(1) / 2;
cy = camera.resolution(2) / 2;
% skew = refCamera.intrinsic(1, 2);
skew = 0;
camera.intrinsic = [fx skew cx; 0 fy cy; 0 0 1];

% cleanup workspace
clear fx fy cx cy skew


%% Get simulated image locations and elevations.
% prompt user for satellite LLA file
[reportLLAName, reportLLAPath] = uigetfile(strcat(volcanoDir, '\orbit_sim\*.csv'), 'Select Satellite LLA File');
% read orbit data
fileID = fopen(strcat(reportLLAPath, reportLLAName));
fgetl(fileID);
reportLLAData = textscan(fileID, '%s %f %f %f %f %f %f', 'Delimiter', ',');
fclose(fileID);

% get location times
reportTime = datetime(reportLLAData{1},'InputFormat','dd MMM yyyy HH:mm:ss.SSS');
% get locations
reportLLA = [reportLLAData{2} reportLLAData{3} reportLLAData{4}];

% observationTime = seconds(reportTime(end) - reportTime(1));
% imagePeriod = round(observationTime/numImages);

% prompt user for satellite AER file
[reportAERName, reportAERPath] = uigetfile(strcat(volcanoDir, '\orbit_sim\*.csv'), 'Select Satellite AER File');
% read orbit data
fileID = fopen(strcat(reportAERPath, reportAERName));
fgetl(fileID);
reportAERData = textscan(fileID, '%s %f %f %f %f %f %f', 'Delimiter', ',');
fclose(fileID);

% % elevationBound Runs
% numImages = [3 5 9 15 31 50];
% elevationBound = 10;

% numImages = [3 5 9 15 31 50];
numImages = 15;
elevationBound = 10;

numSets = length(numImages);

folderName = '\\sat_tomog\\crossTrack';


%% Loop Image Generation
for i = 1:numSets
    sim_images(numImages(i), elevationBound, camera, targetLLA, volcanoDir, reportTime, reportLLA, reportAERData, reportLLAName, reportAERName, folderName)
end


%% Draw camera alignment
fprintf("Orbit Spacing Time: ")
for i = 1:length(orbit.time)-1
    orbitSpacing(i) = orbit.time(i+1) - orbit.time(i);
    fprintf("%s ",orbitSpacing(i))
end
fprintf("\n")
fprintf("Orbit Spacing Elevation Angle: ")
for i = 1:length(orbit.elevation)-1
    orbitSpacingElevation(i) = abs(orbit.elevation(i+1) - orbit.elevation(i));
    fprintf("%f ",orbitSpacingElevation(i))
end
fprintf("\n")
fprintf("Orbit Spacing Actual Angle: ")
for i = 1:length(images)-1
    orbitSpacingAngle(i) = rad2deg(acos(dot(images(i).ENU, images(i+1).ENU) / (norm(images(i).ENU) * norm(images(i+1).ENU))));
    fprintf("%f ",orbitSpacingAngle(i))
end
fprintf("\n")

% initial figure set-up
figure();
hold on; grid on; box on; axis equal;
xlabel('X East')
ylabel('Y North')
view(3)
numImages = length(images);
fcn_show_voxels(scaleVoxels.resolution, scaleVoxels.plume, [0.5 0.5 0.5], 1);
scatter3(0, 0, 0);

for i = 1:numImages
    distanceToTarget(i) = norm(images(i).ENU);
end
minDistanceToTarget = min(distanceToTarget);

for i = 1:numImages
    % draw cam positions for each camera
    scatter3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3))

    % get distance to target
    distanceToTarget = norm(images(i).ENU);

    % draw some label text for each image
%     text(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), images(i).name);
%     text(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), datestr(orbit.time(i)));

    % get cam boresight vector
    camVectorView = [0 0 1]';
%     camVectorView = camVectorView .* [1 -1 -1]';
    % ray directions in ECEF
    rays(i).viewDirECEF = images(i).cam2ecef * camVectorView;
    rays(i).viewDirECEF = rays(i).viewDirECEF ./ vecnorm(rays(i).viewDirECEF);
    % ray directions in ENU
    [rays(i).viewDir(1), rays(i).viewDir(2), rays(i).viewDir(3)] = ecef2enuv(rays(i).viewDirECEF(1), rays(i).viewDirECEF(2), rays(i).viewDirECEF(3), targetLLA(1), targetLLA(2));
    % plot ray direction
    quiver3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), rays(i).viewDir(1), rays(i).viewDir(2), rays(i).viewDir(3), distanceToTarget * .85, 'k');

    % get cam up vector
    camVectorUp = [0 1 0]';
%     camVectorUp = camVectorUp .* [1 -1 -1]';
    % ray directions in ECEF
    rays(i).upDirECEF = images(i).cam2ecef * camVectorUp;
    rays(i).upDirECEF = rays(i).upDirECEF ./ vecnorm(rays(i).upDirECEF);
    % ray directions in ENU
    [rays(i).upDir(1), rays(i).upDir(2), rays(i).upDir(3)] = ecef2enuv(rays(i).upDirECEF(1), rays(i).upDirECEF(2), rays(i).upDirECEF(3), targetLLA(1), targetLLA(2));
    % plot ray directions
    quiver3(images(i).ENU(1), images(i).ENU(2), images(i).ENU(3), rays(i).upDir(1), rays(i).upDir(2), rays(i).upDir(3), minDistanceToTarget * .25, 'r');
end

%% Functions
function sim_images(numImages, elevationBound, camera, targetLLA, volcanoDir, reportTime, reportLLA, reportAERData, reportLLAName, reportAERName, folderName)
    % get elevation
    reportElevation = [reportAERData{3}];
    reportAzimuth = [reportAERData{2}];
    % elevation angle must be >= bound (elevation = 90 - zenith)
    elevationIndex = find(reportElevation >= elevationBound);
    
    satRange = [reportAERData{4}];

%     % elevationRange = (90 - elevationBound) * 2;
%     imgAngles = reportElevation(elevationIndex);
%     angleDelta = ((90 - elevationBound) * 2) / numImages;
%     
%     for ii = 1:(numImages / 2)
%         testIndeciesFirst(ii) = find(round(imgAngles) == round(30 + ((ii-1) * angleDelta)), 1, 'first');
%         testIndeciesLast(ii) = find(round(imgAngles) == round(30 + ((ii-1) * angleDelta)), 1, 'last');
%     end
%     
%     testIndiciesFinal = [testIndeciesFirst flip(testIndeciesLast)];
%     finalAngles = imgAngles(testIndiciesFinal);
%     for ii = 1:length(finalAngles)
%         if ii < 25
%             locationIndex(ii) = find(reportElevation == finalAngles(ii), 1, 'first');
%         else
%             locationIndex(ii) = find(reportElevation == finalAngles(ii), 1, 'last');
%         end
%     end
%     find(reportElevation == imgAngles(1))

    %% Orbit Spacing
    % index of selected locations, including elevation bound, based on
    % linear spacing
%     locationIndex = round(linspace(min(elevationIndex), max(elevationIndex), numImages));

%     % even angle interpolation
%     elevationAngles = reportElevation(elevationIndex);
%     midPoint = find(elevationAngles == max(elevationAngles));
%     queryPoints = linspace(elevationBound, 180-elevationBound, numImages);
%     newElevationAngles = vertcat(elevationAngles(1:midPoint(1)), abs(elevationAngles(midPoint(1)+1:end) - 180));
%     interpPoints = interp1(newElevationAngles, 1:length(newElevationAngles), queryPoints, "nearest", "extrap");
%     locationIndex = elevationIndex(interpPoints);

    imageLocationsLLA = reportLLA(elevationIndex, :);
    imageLocationsLLA(:, 3) = imageLocationsLLA(:, 3) * 1e3;
    imagECEF = lla2ecef(imageLocationsLLA);
    [imageLocations(:, 1), imageLocations(:, 2), imageLocations(:, 3)] = ecef2enu(imagECEF(:, 1), imagECEF(:, 2), imagECEF(:, 3), targetLLA(1), targetLLA(2), targetLLA(3), wgs84Ellipsoid);

    imgStart = imageLocations(1, :);
    imgEnd = imageLocations(end, :);
    totalAngle = rad2deg(acos(dot(imgStart, imgEnd) / (norm(imgStart) * norm(imgEnd))));
%     totalAngle = 180 - (elevationBound * 2);
    angleSep = totalAngle / (numImages - 1);
    
    angleBtwLoc = 0;
    for i = 1:length(elevationIndex)-1
        imgStart = imageLocations(i, :);
        imgEnd = imageLocations(i + 1, :);
        angleBtwLoc(i) = rad2deg(acos(dot(imgStart, imgEnd) / (norm(imgStart) * norm(imgEnd))));
    end
    avgAngleSep = sum(angleBtwLoc) / (numImages - 1);


    imgStart = imageLocations(1, :);
    pointIndex(1) = 1;
    count = 1;
    angleOverflow = 0;
    for i = 2:length(elevationIndex)-1
        currImage = imageLocations(i, :);
        angleDiff = rad2deg(acos(dot(imgStart, currImage) / (norm(imgStart) * norm(currImage)))) + angleOverflow; 
        if angleDiff >= avgAngleSep
            angleOverflow = angleDiff - avgAngleSep;
            count = count +1;
            imgStart = imageLocations(i, :);
            pointIndex(count) = (i);
        end
    end
    pointIndex(count+1) = length(elevationIndex);
    locationIndex = elevationIndex(pointIndex);
    
    % even angle interpolation
    elevationAngles = reportElevation(elevationIndex);
    midPoint = find(elevationAngles == max(elevationAngles), 1);
%     queryPoints = linspace(elevationBound, (max(elevationAngles) * 2) - elevationBound, numImages);
    newElevationAngles = vertcat(elevationAngles(1:midPoint), abs(elevationAngles(midPoint+1:end) - (max(elevationAngles) * 2)));
    % deal with duplicate elevation angles (should really remove them at
    % the beginning, but oh well
    for i = 1:length(newElevationAngles)-1
        if newElevationAngles(i + 1) == newElevationAngles(i)
            newElevationAngles(i + 1) = newElevationAngles(i + 1) + 0.0001;
        end
    end
    queryPoints = linspace(newElevationAngles(1), newElevationAngles(end), numImages);
    interpPoints = interp1(newElevationAngles, 1:length(newElevationAngles), queryPoints, "nearest", "extrap");
%     locationIndex = elevationIndex(interpPoints);

    % create image class
    images(1:numImages) = class_images;
    % get LLA of selected locations
    for i = 1:numImages
        images(i).binary = false(camera.resolution(2), camera.resolution(1));
        images(i).LLA = [reportLLA(locationIndex(i), 1), reportLLA(locationIndex(i), 2), reportLLA(locationIndex(i), 3) * 1e3];

        % also save report time and elevation
        orbit.time(i) = reportTime(locationIndex(i));
        orbit.elevation(i) = reportElevation(locationIndex(i));
    end    

    % transform sim image locations from LLA to ENU
    images = lla2enu(images, targetLLA);

    % cleanup workspace
    clear fileID ans numLocations imagePeriod locationIndex elevationIndex
    clear reportLLAPath reportLLAData reportTime reportLLA  reportAERPath reportAERData reportElevation


%     for i = 1:numImages
%         fprintf('%15f, %15f, %15f\n', images(i).ENU /1000)
%         tempImagesENU(i, :) = images(i).ENU /1000;
%     end

    %% Sim image rotation matrices
    simTargetENU = [0 0 0];

    % set camera vectors
    camVectorView = [0 0 1];
    camVectorUp = [0 1 0];

    % pre-allocate sim vectors structure
    simVectors(1:length(images)) = struct('viewENU', zeros(1, 3), 'upENU', zeros(1, 3), 'viewECEF', zeros(1, 3), 'upECEF', zeros(1, 3));

    % for each simulated image, find cam2ecef rotation matrix
    for i = 1:length(images)
        % sim image camera view vector in ENU coords, position to target
        simVectors(i).viewENU = simTargetENU - images(i).ENU;
        simVectors(i).viewENU = simVectors(i).viewENU / norm(simVectors(i).viewENU);

        % sim image camera view vector in ECEF coords
        [simVectors(i).viewECEF(1), simVectors(i).viewECEF(2), simVectors(i).viewECEF(3)] = enu2ecefv(simVectors(i).viewENU(1), simVectors(i).viewENU(2), simVectors(i).viewENU(3), targetLLA(1), targetLLA(2));

        % sim image camera up vector in ENU coords, first find the velocity
        % vector of the orbit (vector to next image location)
        if i + 1 <= length(images)
            velocityVectorENU = (images(i + 1).ENU - images(i).ENU);
        else
            velocityVectorENU = -(images(i - 1).ENU - images(i).ENU);
        end
        velocityVectorENU = velocityVectorENU / norm(velocityVectorENU);
        % vector normal to view vector and velocity vector, equivalent to
        % 'side' vector
        sideVectorENU = cross(simVectors(i).viewENU, velocityVectorENU);
        sideVectorENU = sideVectorENU / norm(sideVectorENU);

        % up vector is normal to side vector and view vector, in the same plane
        % as the velocity vector
        simVectors(i).upENU = cross(sideVectorENU, simVectors(i).viewENU);
        simVectors(i).upENU = simVectors(i).upENU / norm(simVectors(i).upENU);

        % sim image camera up vector in ECEF coords
        [simVectors(i).upECEF(1), simVectors(i).upECEF(2), simVectors(i).upECEF(3)] = enu2ecefv(simVectors(i).upENU(1), simVectors(i).upENU(2), simVectors(i).upENU(3), targetLLA(1), targetLLA(2));

        % sim image camera view vector in cam coords
        a1 = camVectorView;
        % sim image camera view vector in ecef coords
        b1 = simVectors(i).viewECEF;
        % rotation matrix for sim image camera view vector
        simRotmView = fcn_axis_angle_rotation(a1, b1);
        % rotate sim image camera up vector from cam coords to intermediate
        camVectorUpTemp = simRotmView * camVectorUp';

        % new sim image camera up vector in intermediate coords
        a2 = camVectorUpTemp;
        % sim image camera up vector in ecef coords
        b2 = simVectors(i).upECEF;
        % rotation matrix for sim image camera up vector
        simRotmUp = fcn_axis_angle_rotation(a2, b2);
        % final rotation matrix, rotates to allign camera view and up vectors
        images(i).cam2ecef = simRotmUp * simRotmView;
    end
    
    % cleanup workspace
    clear camVectorView camVectorUp camVectorUpTemp velocityVectorENU sideVectorENU a1 b1 a2 b2 simRotmView simRotmUp% simVectors
    
    
    %% Load Voxels
    % load voxels
    load(strcat(volcanoDir, '\trueVoxels.mat'))

    % voxel plume scale factor
    scaleFactor = 100;

    % rename final voxels
    trueVoxels = finalVoxels;
    scaleVoxels = trueVoxels;

    % scale voxels
    scaleVoxels.resolution = trueVoxels.resolution * scaleFactor;
    scaleVoxels.xBound = trueVoxels.xBound * scaleFactor;
    scaleVoxels.yBound = trueVoxels.yBound * scaleFactor;
    scaleVoxels.zBound = trueVoxels.zBound * scaleFactor;
    scaleVoxels.ENU = trueVoxels.ENU * scaleFactor;
    scaleVoxels.plume = trueVoxels.plume * scaleFactor;

    % cleanup workspace
    clear voxelFile coarseVoxels interVoxels finalVoxels


    %% Create simulated images
    % get pixel locations of final plume
    voxelsPixLoc = fcn_vox_glob2pix(camera, images, scaleVoxels.plume, targetLLA);

    % create waitbar
    waitString = sprintf('Creating Simulated Images\nImage Number: 0 of %i', length(images));
    waitBarSim = waitbar(0, waitString);

    % for each image create binary off plume
    for i = 1:length(images)
        % update waitbar
        waitString = sprintf('Creating Simulated Images\nImage Number: %i of %i', i, length(images));
        waitbar(i / length(images), waitBarSim, waitString);

        % for each voxel
        for j = 1:length(scaleVoxels.plume)
            % check if voxel is visable in current image 
            % resolution(1) is width, equal to columns and x pixels 
            inX = voxelsPixLoc(i).pixLoc(j, 1) <= camera.resolution(1) && voxelsPixLoc(i).pixLoc(j, 1) > 0;
            % resolution(2) is height, equal to rows and y pixels
            inY = voxelsPixLoc(i).pixLoc(j, 2) <= camera.resolution(2) && voxelsPixLoc(i).pixLoc(j, 2) > 0;

            % if the voxel does appear in the image, set to one as we already
            % know it is a plume voxel
            if inX && inY
                images(i).binary(voxelsPixLoc(i).pixLoc(j, 2), voxelsPixLoc(i).pixLoc(j, 1)) = 1;
            end
        end
        % fill image if voxels were too large/pixels too small
        images(i).binary = imclose(images(i).binary, strel('disk', 5));
    end
    
%     imshow(images(round(i/2)).binary)
    
    saveName = strcat(folderName, sprintf('\\simImages_%ix_%s_elev_%02i_%02i',scaleFactor, reportLLAName(1:6), elevationBound, numImages));

    % save sim camera, images, and volcano target
%     uisave({'camera', 'images', 'orbit', 'trueVoxels', 'scaleVoxels', 'scaleFactor', 'targetLLA', 'reportLLAName', 'reportAERName', 'elevationBound'}, strcat(volcanoDir, saveName))
    save(strcat(volcanoDir, saveName), 'camera', 'images', 'orbit', 'trueVoxels', 'scaleVoxels', 'scaleFactor', 'targetLLA', 'reportLLAName', 'reportAERName', 'elevationBound')

    % close waitbar
    close(waitBarSim)

    % cleanup workspace
    clear inX inY voxelsPixLoc se waitBarSim waitString
end


function rotm = fcn_axis_angle_rotation(a, b)
%FCN_AXIS_ANGLE_ROTATION find axis-angle rotation matrix
%   rotm = FCN_AXIS_ANGLE_ROTATION(a, b)
%   a = starting vector
%   b = destination vector
%   rotm = rotation matrix from a to b

% skew symmetric cross product matrix function
ssc = @(v) [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];

% cross product of two vectors, gives axis of rotation
v = cross(a, b);
% rotation matrix, see https://math.stackexchange.com/questions/180418/calculate-rotation-matrix-to-align-vector-a-to-vector-b-in-3d
rotm = eye(3) + ssc(v) + ssc(v)^2 * ((1 - dot(a, b)) / norm(v)^2);
end
