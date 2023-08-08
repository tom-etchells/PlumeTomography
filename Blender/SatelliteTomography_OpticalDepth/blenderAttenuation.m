%% Setup
%clear variables; %close all; clc;
% addpath classes
% addpath(genpath('functions'))


%% Directory
if isfolder("D:\Users\Tom\OneDrive - University of Bristol")
    driveDir = 'D:\Users\Tom\OneDrive - University of Bristol';
elseif isfolder("C:\Users\Tom\OneDrive - University of Bristol")
    driveDir = 'C:\Users\Tom\OneDrive - University of Bristol';
elseif isfolder("C:\Users\te14170\OneDrive - University of Bristol")
    driveDir = 'C:\Users\te14170\OneDrive - University of Bristol';
else
    print('Folder not found, stopping.')
    return
end
dataDir = strcat(driveDir, '\PhD\Projects\Blender Simulation\SatelliteTomography_OpticalDepth');

%% Read images and get values
images = dir(strcat(dataDir, '\renders\dens01*.png'));
numImages = length(images);

centrePixel = [322, 256];
intensityValue = zeros(numImages, 1);
alphaValue = zeros(numImages, 1);
depthValue = zeros(numImages, 1);

for img = 1:numImages
    images(img).raw = imread(strcat(dataDir, '\renders\', images(img).name));
    [~, ~, images(img).alpha] = imread(strcat(dataDir, '\renders\', images(img).name));
    images(img).gray = rgb2gray(images(img).raw);

    intensityValue(img) = images(img).gray(centrePixel(2), centrePixel(1));
    alphaValue(img) = images(img).alpha(centrePixel(2), centrePixel(1));
    depthValue(img) = str2double(images(img).name(end-5:end-4));
end

% density 02 images
images02 = dir(strcat(dataDir, '\renders\dens02*.png'));
numImages = length(images02);

centrePixel = [322, 256];
intensityValue02 = zeros(numImages, 1);
alphaValue02 = zeros(numImages, 1);
depthValue02 = zeros(numImages, 1);

for img = 1:numImages
    images02(img).raw = imread(strcat(dataDir, '\renders\', images02(img).name));
    [~, ~, images02(img).alpha] = imread(strcat(dataDir, '\renders\', images02(img).name));
    images02(img).gray = rgb2gray(images02(img).raw);

    intensityValue02(img) = images02(img).gray(centrePixel(2), centrePixel(1));
    alphaValue02(img) = images02(img).alpha(centrePixel(2), centrePixel(1));
    depthValue02(img) = str2double(images02(img).name(end-5:end-4));
end

% density 0.5 images
images0_5 = dir(strcat(dataDir, '\renders\dens0.5*.png'));
numImages = length(images0_5);

centrePixel = [322, 256];
intensityValue0_5 = zeros(numImages, 1);
alphaValue0_5 = zeros(numImages, 1);
depthValue0_5 = zeros(numImages, 1);

for img = 1:numImages
    images0_5(img).raw = imread(strcat(dataDir, '\renders\', images0_5(img).name));
    [~, ~, images0_5(img).alpha] = imread(strcat(dataDir, '\renders\', images0_5(img).name));
    images0_5(img).gray = rgb2gray(images0_5(img).raw);

    intensityValue0_5(img) = images0_5(img).gray(centrePixel(2), centrePixel(1));
    alphaValue0_5(img) = images0_5(img).alpha(centrePixel(2), centrePixel(1));
    depthValue0_5(img) = str2double(images0_5(img).name(end-5:end-4));
end

% density 0.1 images
images0_1 = dir(strcat(dataDir, '\renders\dens0.1*.png'));
numImages = length(images0_1);

centrePixel = [322, 256];
intensityValue0_1 = zeros(numImages, 1);
alphaValue0_1 = zeros(numImages, 1);
depthValue0_1 = zeros(numImages, 1);

for img = 1:numImages
    images0_1(img).raw = imread(strcat(dataDir, '\renders\', images0_1(img).name));
    [~, ~, images0_1(img).alpha] = imread(strcat(dataDir, '\renders\', images0_1(img).name));
    images0_1(img).gray = rgb2gray(images0_1(img).raw);

    intensityValue0_1(img) = images0_1(img).gray(centrePixel(2), centrePixel(1));
    alphaValue0_1(img) = images0_1(img).alpha(centrePixel(2), centrePixel(1));
    depthValue0_1(img) = str2double(images0_1(img).name(end-5:end-4));
end

% density 03 images
images03 = dir(strcat(dataDir, '\renders\dens03*.png'));
numImages = length(images03);

centrePixel = [322, 256];
intensityValue03 = zeros(numImages, 1);
alphaValue03 = zeros(numImages, 1);
depthValue03 = zeros(numImages, 1);

for img = 1:numImages
    images03(img).raw = imread(strcat(dataDir, '\renders\', images03(img).name));
    [~, ~, images03(img).alpha] = imread(strcat(dataDir, '\renders\', images03(img).name));
    images03(img).gray = rgb2gray(images03(img).raw);

    intensityValue03(img) = images03(img).gray(centrePixel(2), centrePixel(1));
    alphaValue03(img) = images03(img).alpha(centrePixel(2), centrePixel(1));
    depthValue03(img) = str2double(images03(img).name(end-5:end-4));
end

%% Plot Images
figDepth = figure;
figure(figDepth);
hold on; grid on; box on;
xlabel('Depth'); ylabel('Transparency');

% plot(depthValue0_1, intensityValue0_1, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
plot(depthValue0_1, alphaValue0_1, '-s', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')

% plot(depthValue0_5, intensityValue0_5, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
plot(depthValue0_5, alphaValue0_5, '-s', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')

% plot(depthValue, intensityValue, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
plot(depthValue, alphaValue, '-s', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')

% plot(depthValue02, intensityValue02, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
plot(depthValue02, alphaValue02, '-s', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')

% plot(depthValue03, intensityValue03, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
plot(depthValue03, alphaValue03, '-s', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')

legend('dens 0.1', 'dens 0.5', 'dens 01', 'dens 02', 'dens 03', 'location', 'northeast');


%% Column Mass
% area value must be same as voxel area for reconstruction
% SheppLogan is 0.3125, Fuego is 12.5
% colMass01 = 0.3125^2 * depthValue * 1;
% colMass02 = 0.3125^2 * depthValue02 * 2;
% colMass03 = 0.3125^2 * depthValue03 * 3;
% colMass0_5 = 0.3125^2 * depthValue0_5 * 0.5;
% colMass0_1 = 0.3125^2 * depthValue0_1 * 0.1;

% colMass01 = 12.5^2 * depthValue * 1;
% colMass02 = 12.5^2 * depthValue02 * 2;
% colMass0_5 = 12.5^2 * depthValue0_5 * 0.5;
% colMass0_1 = 12.5^2 * depthValue0_1 * 0.1;


colMass01 = 625^2 * depthValue * 1 * 1000;
colMass02 = 625^2 * depthValue02 * 2 * 1000;
colMass03 = 625^2 * depthValue03 * 3 * 1000;
colMass0_5 = 625^2 * depthValue0_5 * 0.5 * 1000;
colMass0_1 = 625^2 * depthValue0_1 * 0.1 * 1000;

% figColMass = figure;
% figure(figColMass);
% hold on; grid on; box on;
% xlabel('Column Mass'); ylabel('Transparency');
% 
% % plot(colMass0_1, intensityValue0_1, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
% plot(colMass0_1, alphaValue0_1, '-s', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
% 
% % plot(colMass0_5, intensityValue0_5, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
% plot(colMass0_5, alphaValue0_5, '-s', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
% 
% % plot(colMass01, intensityValue, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
% plot(colMass01, alphaValue, '-s', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
% 
% % plot(colMass02, intensityValue02, '-o', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')
% plot(colMass02, alphaValue02, '-s', 'LineWidth', 2, 'MarkerSize', 5, 'MarkerFaceColor', 'auto')

legend('dens 0.1', 'dens 0.5', 'dens 01', 'dens 02', 'location', 'northeast');


%% Fit Curve
% allAlpha = [alphaValue0_1(1:end-1); alphaValue0_5; alphaValue; alphaValue02; alphaValue03];
allAlpha = [alphaValue0_1(1:end-1); alphaValue0_5; alphaValue; alphaValue02];
allIntensity = [intensityValue0_1(1:end-1); intensityValue0_5; intensityValue; intensityValue02; intensityValue03];
% allMass = [colMass0_1(1:end-1); colMass0_5; colMass01; colMass02; colMass03];
allMass = [colMass0_1(1:end-1); colMass0_5; colMass01; colMass02];

[allAlpha, I] = sort(allAlpha);
allMass = allMass(I);
% [allMass, I] = sort(allMass);
% allAlpha = allAlpha(I);

allTransparency = 255 - allAlpha;
allIntensity = allIntensity(I);

figure
myFit = fittype('b*exp(c*x)');
f0 = fit(allAlpha, allMass, myFit);
plot(f0, allAlpha, allMass)
ylim([0 6])


%% Export plot for Blender

figAlpha = figure();
plot(allTransparency, allMass, '-^', 'LineWidth', 3, 'MarkerSize', 10, 'MarkerFaceColor', 'auto')
xlabel('Pixel Transparency')
ylabel('Column Mass Loading')

xlim([0 255])
xticks([0 50 100 150 200 255])
box on; grid on;

% save
figAlpha.Color = 'white';
figAlpha.CurrentAxes.FontSize = 40;
figAlpha.Position = [0 0 1440 1080];
% % saveas(figPlume, 'voxel_comp.fig')
% % saveas(figData, 'voxel_comp.png')


%% Inverted
figAlpha = figure();
plot(allMass, allTransparency, '-^', 'Color', 'k', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerFaceColor', 'auto')
ylabel('Pixel Transparency')
xlabel('Column Mass Loading')

ylim([0 255])
yticks([0 50 100 150 200 255])
box on; grid on;

% % save
% figAlpha.Color = 'white';
% figAlpha.CurrentAxes.FontSize = 40;
% figAlpha.Position = [0 0 1440 1080];

figure(figAlpha)
set(gca, 'FontSize', 14, 'FontWeight', 'bold')

% export at 600 dpi
% exportgraphics(figAlpha, 'transferFunction_Blender.png', 'Resolution', 600)


%% Export Plot for Real World
BT = [251.8 237.3 227.7 221.4 217.9 215.6 214.5 213.8 213.1]';
OD = [0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5]';

% g = fittype('a+b*exp(c*x)');
% f0 = fit(BT, OD, g, 'StartPoint', [4; -0.1; -0.07481]);

figRealWorld = figure();
plot(BT, OD, '-o', 'LineWidth', 3, 'MarkerSize', 10, 'MarkerFaceColor', 'auto')
xlabel('Brightness Temperature at 11\mum (K)')
ylabel('Optical Depth')

% xlim([0 255])
% xticks([0 50 100 150 200 255])
box on; grid on;

% save
figRealWorld.Color = 'white';
figRealWorld.CurrentAxes.FontSize = 40;
figRealWorld.Position = [0 0 1440 1080];
% % saveas(figPlume, 'voxel_comp.fig')
% % saveas(figData, 'voxel_comp.png')

%% Real World Inverted
BT = [251.8 237.3 227.7 221.4 217.9 215.6 214.5 213.8 213.1]';
OD = [0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5]';

% g = fittype('a+b*exp(c*x)');
% f0 = fit(BT, OD, g, 'StartPoint', [4; -0.1; -0.07481]);

figRealWorld = figure();
plot(OD, BT, '-o', 'Color', 'k', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerFaceColor', 'auto')
ylabel('Brightness Temp. 11\mum [K]')
xlabel('Optical Depth')

% xlim([0 255])
% xticks([0 50 100 150 200 255])
box on; grid on;

% % save
% figRealWorld.Color = 'white';
% figRealWorld.CurrentAxes.FontSize = 40;
% figRealWorld.Position = [0 0 1440 1080];
% % % saveas(figPlume, 'voxel_comp.fig')
% % % saveas(figData, 'voxel_comp.png')

figure(figRealWorld)
set(gca, 'FontSize', 14, 'FontWeight', 'bold')

% export at 600 dpi
% exportgraphics(figRealWorld, 'transferFunction_RealWorld.png', 'Resolution', 600)
