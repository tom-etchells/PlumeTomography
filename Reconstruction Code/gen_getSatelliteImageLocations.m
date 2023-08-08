%% Setup
clear variables
close all
clc
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


%% Run Setup
% set data directory for satellite runs
runDir = strcat(driveDir, '\PhD\Projects\3D Reconstruction\Thesis Scripts\Space Carving\Data\');


%% Get simulated image locations and elevations.
% prompt user for satellite LLA file
[reportLLAName, reportLLAPath] = uigetfile(strcat(runDir, '\orbit_sim\*.csv'), 'Select Satellite LLA File');
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
[reportAERName, reportAERPath] = uigetfile(strcat(runDir, '\orbit_sim\*.csv'), 'Select Satellite AER File');
% read orbit data
fileID = fopen(strcat(reportAERPath, reportAERName));
fgetl(fileID);
reportAERData = textscan(fileID, '%s %f %f %f %f %f %f', 'Delimiter', ',');
fclose(fileID);


%% Orbit location settings
% % elevationBound Runs
% numImages = [3 5 9 15 31 50];
% elevationBound = 10;

numImages = [3 5 9 15 31 50];
elevationBound = [10];

numSets = length(numImages);

folderName = '\\Sat Tomography\\orbit_spacing';