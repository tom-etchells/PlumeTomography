# %% Imports
import bpy  # type: ignore pylint: disable=import-error
import math


# %% Remove old frustrums
scene = bpy.context.scene
# get all objects in 'Frustrums' collection
frusturms = bpy.data.collections["Frustrums"].objects
for f in frusturms:
    # check if object is a mesh and make sure it is not template
    if f.type == "MESH" and f.name != "frustrumTemplate":
        # remove the object
        bpy.data.objects.remove(f)


# %% Create new frustrums from frustrum template
frustrumTemplate = bpy.data.objects["frustrumTemplate"]
numCams = len(bpy.data.collections["Cameras"].objects)
for f in range(numCams):
    # duplicate template
    frustrum = frustrumTemplate.copy()
    frustrum.name = "frustrum{:0>2d}".format(f + 1)

    # new frustrum constraints, set to relevant camera
    frustrum.constraints["Copy Location"].target = bpy.data.objects[
        "cam{:0>2d}".format(f + 1)
    ]
    frustrum.constraints["Copy Rotation"].target = bpy.data.objects[
        "cam{:0>2d}".format(f + 1)
    ]

    # link to 'Frustrums' collection
    bpy.data.collections["Frustrums"].objects.link(frustrum)
