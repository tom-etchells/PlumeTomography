# %% Imports
import bpy  # type: ignore pylint: disable=import-error
import numpy as np


# %% Add empty cubes at particle locations, print locations
def run(runDir, printFrame):
    context = bpy.context
    # for obj in context.scene.objects:
    #    if obj.name[0:5] == "Empty":
    #        bpy.data.objects.remove(context.scene.objects[5])

    # set the active frame
    bpy.context.scene.frame_set(printFrame)

    # get the dependency graph and the evaluated object
    vent = bpy.data.objects["obj_Vent"]
    dg = context.evaluated_depsgraph_get()
    ob = vent.evaluated_get(dg)

    # assume context object has a ps, use active
    ps = ob.particle_systems.active

    # this is the instance object
    po = ps.settings.instance_object

    # # Set working directory to current folder
    # workindDir = bpy.path.abspath("//")

    locs = []

    for p in ps.particles:
        #    bpy.ops.object.empty_add(type="CUBE", radius=10, location=p.location)
        locs.append(p.location)

    fileName = "voxs.csv"
    workingDir = bpy.path.abspath("//")

    filePath = runDir + "\\" + fileName
    np.savetxt(
        filePath,
        locs,
        delimiter=",",
    )