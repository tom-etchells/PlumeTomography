# %% Imports
import bpy  # type: ignore pylint: disable=import-error
import bmesh  # type: ignore pylint: disable=import-error
import numpy as np
import csv


# %% Write Smoke to File Function
def write_smoke_to_file(smoke_obj, frame, printFrame, runDir):
    # get settings of smoke object
    smoke_domain_mod = smoke_obj.modifiers[0]
    settings = smoke_domain_mod.domain_settings

    # get density and verticies of domain
    dens = np.array(settings.density_grid)
    verts = np.array([smoke_obj.matrix_world @ v.co for v in smoke_obj.data.vertices])

    if frame == printFrame:
        print("Extracting Ground Truth from Frame ", frame)
        # save vertecies
        fileName = "verts.csv"
        filePath = runDir + "\\" + fileName
        np.savetxt(
            filePath,
            verts,
            delimiter=",",
        )
        # save density
        fileName = "density.csv"
        filePath = runDir + "\\" + fileName
        np.savetxt(
            filePath,
            dens,
            delimiter=",",
        )


# %% Write Smoke to File, MATLAB format
def run(runDir):
    # get the smoke domain object
    domain = bpy.data.objects["Smoke Domain"]

    # specific frame to print to MATLAB (may want multiple frmaes later?)
    printFrame = 5

    # get smoke position etc., for every voxel at every frame
    for frame in range(printFrame - 1, printFrame + 1):
        # set the active frame
        bpy.context.scene.frame_set(frame)

        # get dependancy graph and then smoke object
        depsgraph = bpy.context.evaluated_depsgraph_get()
        smoke_obj = domain.evaluated_get(depsgraph)

        # write to file
        write_smoke_to_file(smoke_obj, frame, printFrame, runDir)
