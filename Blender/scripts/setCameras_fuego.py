# %% Imports
import bpy  # type: ignore pylint: disable=import-error

# import numpy as np


# %% Set camera positions evenly in a circle based of input radius and number of cameras
def run(numCams, focalLength):
    # %% Camera Positions
    camPos = [[-5960.86773830264, -4659.52833820186, -2629.49647379370 + 10]]
    camPos.append([5122.12511275675, -5084.78386315536, -2615.09479545739 + 10])
    camPos.append([8140.11037857390, 4614.59303566193, -2298.87127871624 + 10])
    camPos.append([-7711.55938548568, 2983.93383949203, -2357.36198111236 + 10])

    #  %% Delete Old Cameras
    # get all objects in 'Cameras' collection
    cams = bpy.data.collections["Cameras"].objects
    for cam in cams:
        # check if object is a camera and make sure it is not template
        if cam.type == "CAMERA" and cam.name != "template":
            # remove the object
            bpy.data.objects.remove(cam)

    #  %% Create New cameras
    # get template camera
    camTemplate = bpy.data.objects["template"]

    for camNum in range(numCams):

        # duplicate template, set relecant info,
        newCam = camTemplate.copy()
        newCam.name = "cam{:0>2d}".format(camNum + 1)
        newCam.location = (camPos[camNum][0], camPos[camNum][1], camPos[camNum][2])

        # change the lens focalLength
        newCam.data.lens = focalLength

        # link to 'Cameras' collection
        bpy.data.collections["Cameras"].objects.link(newCam)
