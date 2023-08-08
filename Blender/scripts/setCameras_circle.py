# %% Imports
import bpy  # type: ignore pylint: disable=import-error
import numpy as np


# %% Polar to Cartesian Function
def pol2cart(rho, phi):
    x = rho * np.cos(phi)
    y = rho * np.sin(phi)
    return (x, y)


# %% Set camera positions evenly in a circle based of input radius and number of cameras
def run(numCams, rho, elevation, offset, focalLength):
    # %% Set Camera Position Variables
    # rho = 100
    phi = 0
    newRho = rho * np.cos(np.deg2rad(elevation))
    z = -rho * np.sin(np.deg2rad(elevation))

    # numCams = 6
    angleDelta = (2 * np.pi) / numCams

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
        # get location of new camera
        x, y = pol2cart(newRho, phi)

        # camera offsets for even numbers of total cameras, move first half
        if offset & ((numCams % 2 == 0) & (camNum + 1 <= (numCams / 2))):
            # get location of new camera
            x, y = pol2cart(newRho, phi + (angleDelta / 2))

        # duplicate template, set relecant info,
        newCam = camTemplate.copy()
        newCam.name = "cam{:0>2d}".format(camNum + 1)
        newCam.location = (x, y, z)

        # change the lens focalLength
        newCam.data.lens = focalLength

        # link to 'Cameras' collection
        bpy.data.collections["Cameras"].objects.link(newCam)

        # iterate phi for next camera
        phi = phi + angleDelta
