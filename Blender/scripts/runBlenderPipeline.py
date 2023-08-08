# %% Imports
import importlib
import sys
import os
import numpy as np

# make script path accessable from Blender python environment
scriptPath = os.path.dirname(os.path.realpath(__file__))
sys.path.append(scriptPath)

# script imports
import setCameras_circle
import setCameras_fuego
import setCameras_satellite
import setCameras_satellite_evenAngle
import setCameras_satellite_crossTrack
import setCameras_multi_satellite
import renderCameras
import getCamPoses
import getParticlePos
import getSmokePos

# import reloads required for some reason
importlib.reload(setCameras_circle)
importlib.reload(setCameras_fuego)
importlib.reload(setCameras_satellite)
importlib.reload(setCameras_satellite_evenAngle)
importlib.reload(setCameras_satellite_crossTrack)
importlib.reload(setCameras_multi_satellite)
importlib.reload(renderCameras)
importlib.reload(getCamPoses)
importlib.reload(getParticlePos)
importlib.reload(getSmokePos)


# %% Tomog SheppLogan Circle
# # set folder dir
# baseDir = "C:\\Users\\te14170\\OneDrive - University of Bristol\\PhD\\Projects\\3D Reconstruction\\Tomography Testing\\Data\\SatTomography\\singleSatCrossTrack_elev20_img15"

# # cameraCircleRadius = 100
# numCams = 4
# # focalLength = [25]
# # cameraElevationAngle = [25]
# offset = False

# cameraElevationAngle = [0, 15, 25]
# focalLength = [5, 10, 15, 20, 25, 50]

# for elev in cameraElevationAngle:
#     for f in focalLength:
#         # set run directory name
#         runDir = baseDir + "\\elev_{:02d}".format(elev) + "\\focalLength_{:02d}".format(f)

#         # setCameras_circle.run(numCams, cameraCircleRadius, elev, offset, f)
#         # renderCameras.run(runDir)
#         # getCamPoses.run(runDir)
#         # getSmokePos.run(runDir)

#         # # Use fuego specific camera set-up
#         # setCameras_fuego.run(numCams, focalLength)
#         # renderCameras.run(renderFolderName)
#         # # getCamPoses.run()
#         # # getSmokePos.run()


#  %% Satellite Tomog
# elevation angle bounds
baseDir = "C:\\Users\\te14170\\OneDrive - University of Bristol\\PhD\\Projects\\3D Reconstruction\\Thesis Scripts\\Data\\sat_tomog"
# baseDir = "C:\\Users\\te14170\\OneDrive - University of Bristol\\PhD\\Projects\\3D Reconstruction\\Thesis Scripts\\Data\\Test"

# run values
elevAngles = [10]
camNumbers = [15]
focalLengths = [50]

# elevAngles = [0, 10, 20, 30, 40]
# camNumbers = [3, 5, 9, 15, 31, 50]

# Cross Track, use elevAngles as cross track angles
# elevAngles = [0, 10, 20, 30, 40, 50, 60, 70]
# elevAngles = [70]

# focal length
focalLengths = [10, 15, 20, 30, 40, 50, 70]


for fl in focalLengths:
    for elev in elevAngles:
        for cam in camNumbers:
            # set run directory name
            # runDir = (
            #     baseDir + "\\crossTrack_{:02d}".format(v1) + "\\images_{:02d}".format(cam)
            # )
            runDir = baseDir + "\\focalLength\\focalLength_{:02d}".format(fl)

            # setCameras_satellite.run(cam, elev, fl)
            setCameras_satellite_evenAngle.run(cam, elev, fl)
            # setCameras_satellite_crossTrack.run(cam, elev, fl)
            renderCameras.run(runDir)
            getCamPoses.run(runDir)
            getSmokePos.run(runDir)


# # multi satellite run
# baseDir = "C:\\Users\\te14170\\OneDrive - University of Bristol\\PhD\\Projects\\3D Reconstruction\\Thesis Scripts\\Data\\sat_tomog\\multiSatellite"
# numSats = 2
# # crossTrack = [
# #     [0, 10],
# #     [0, 20],
# #     [0, 30],
# #     [0, 40],
# #     [0, 50],
# #     [0, 60],
# #     [0, 70],
# # ]
# focalLength = 50

# crossTrack = [[0, 50]]
# # multi-satellite
# for crossTrackSet in crossTrack:
#     # set run directory name
#     runDir = baseDir + "\\crossTrack_{:02d}".format(crossTrackSet[1])

#     setCameras_multi_satellite.run(numSats, crossTrackSet, focalLength)
#     # renderCameras.run(runDir)
#     # getCamPoses.run(runDir)
#     # getSmokePos.run(runDir)

# # # runDir = baseDir + "\\off_track_00"
# # # setCameras_multi_satellite.run(1, 0, 50)
# # # renderCameras.run(runDir)
# # # getCamPoses.run(runDir)
# # # getSmokePos.run(runDir)


#  %% Satellite SpaceCarving
# # set dir
# baseDir = "C:\\Users\\te14170\\OneDrive - University of Bristol\\PhD\\Projects\\3D Reconstruction\\\Thesis Scripts\\Space Carving\\Data"

# # run variables
# elevAngles = [0, 10, 20, 30, 40]
# camNumbers = [3, 5, 9, 15, 31, 50]
# focalLength = 50
# printFrame = 950

# # # testing variables
# # elevAngles = [10]
# # camNumbers = [5]

# # process each run
# for elev in elevAngles:
#     for cam in camNumbers:
#         # set run directory name
#         runDir = (
#             baseDir
#             + "\\blendElevationBound_{:02d}".format(elev)
#             + "\\images_{:02d}".format(cam)
#         )

#         setCameras_satellite.run(cam, elev, focalLength)
#         # renderCameras.run(runDir)
#         # getCamPoses.run(runDir)
#         # getParticlePos.run(runDir, printFrame)


# %% Finish
print("\nDone")
