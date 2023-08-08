#  %% Imports
import bpy  # type: ignore pylint: disable=import-error
import os
import glob

# %% Render Cameras
def run(runDir):
    # remove all files from render directory
    renderDir = runDir + "\\raw"
    print("")
    for f in glob.glob(renderDir + "\\cam*.png"):
        print("Removing " + f)
        os.remove(f)

    print("")

    # get all objects in Cameras collection
    cams = bpy.data.collections["Cameras"].objects
    for cam in cams:
        # check if object is a camera and not template
        if cam.type == "CAMERA" and cam.name != "template":
            print("Rendering ", cam.name, " of ", len(cams))
            bpy.data.scenes["Scene"].camera = cam
            bpy.data.scenes["Scene"].render.filepath = renderDir + "\\" + cam.name
            bpy.ops.render.render(write_still=True)