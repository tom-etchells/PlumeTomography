# %% Imports
import bpy  # type: ignore pylint: disable=import-error
import numpy as np


# %% Get camera names and poses, output to Blender working dir
def run(runDir):
    # %% Set Output Directories
    # set file path to csv
    fileNamePoses = "camPoses.csv"
    filePathPoses = runDir + "\\" + fileNamePoses

    fileNameCamNames = "camNames.csv"
    filePathCamNames = runDir + "\\" + fileNameCamNames

    camNamesList = []

    # %% Read Camera Position
    # get all objects in Cameras collection
    cams = bpy.data.collections["Cameras"].objects
    with open(filePathPoses, "w") as f:
        for cam in cams:
            # add camera name to list
            camNamesList.append(cam.name)

            # save relevant extrinsic matrix, 'world' is the only one needed with current set up
            matrixWorld = np.array(cam.matrix_world)
            np.savetxt(f, matrixWorld, delimiter=",")

    # save the camera names list
    np.savetxt(filePathCamNames, camNamesList, delimiter=",", fmt="%s")