%% Setup
clear variables;
close all;
clc;
addpath classes
addpath(genpath('functions'))


%% Drive Directory
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


%% Set up loop
% % set data directory
% runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Tomography Testing\Data\SatTomography\singleSat_numImages_elev\numImages_elev00');
% 
% % set run name, can be a specific folder or just the prefix (diffusive_
% % will run any data folder named diffusive_xxx)
% runName = '\images_';


% set data directory for satellite runs
% runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Data\tomog\Copy_of_diffusive_camOffset');
runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Data\sat_tomog\evenTime_elev10');

% set run name, can be a specific folder or just the prefix (diffusive_
% will run any data folder named diffusive_xxx)
runName = '\images_05';
% runName = '\images_';

% find folders for run
runs = dir(strcat(runDir, runName, '*'));


%% Run Settings
% custom rotation angle setting based on run name
runSettings.rotAngle =      0;

% custom focal length based on run name, or hard coded focal length
runSettings.focalLengthCustom = 0;
runSettings.focalLength = 25e-3; % 50e-3;
runSettings.pixelSize = 25e-6; % 17e-6;

% skip tomographic calculations and load saved data
runSettings.skipTomogCalc = 1;

% is the run a satellite run, and what scale factor to use
runSettings.satRun = 0;
runSettings.unitScale = 1;


%% Set up Drawing and Exporting Flags
% flags to turn off or on drawing and rendering of certain things
runFlags.drawCameraPos =    1;
runFlags.drawCameraPosAll = 0;
runFlags.drawCarve =        0;
runFlags.drawRays =         0;
runFlags.drawGroundTruth =  1;
runFlags.drawTomog =        1;
runFlags.drawErrorHist =    0;
runFlags.drawRMS =          0;
runFlags.drawErrorVoxels =  0;

runFlags.exportRMS =        0;


% -----------------------------------
% MAKE SURE TO CHECK UNIT SCALE set runSettings.unitScale to 1000 for sat
% MAKE SURE TO CHECK FOCAL LENGTH SETTINGS IN fcn_blenderSheppLoganCam.m
% MAKE SURE TO CHECK VOXEL RESOLUTION AND BOUNDS IN fcn_blenderSheppLoganCarve.m 
%   I made this both 1000x and also then 2x so 0.3125 to 625
% MAKE SURE TO CHECK TRANSFER FUNCTION IN fcn_pix2enu_fuego.m
% MAKE SURE TO CHECK DRAWING BOUNDS IN Carve and Tomog and RMS
% -----------------------------------


%% Run Camera Setup
% fcn_tomog_images(runDir, runs, runSettings, runFlags);

%% Run Carving
% fcn_tomog_carve(runDir, runs, runSettings, runFlags);

%% Run Tomography
fcn_tomog_tomog(runDir, runs, runSettings, runFlags);

%% Run RMS Error Calculation
% fcn_tomog_RMS(runDir, runs, runSettings, runFlags);
