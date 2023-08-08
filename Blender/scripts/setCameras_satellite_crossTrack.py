# %% Imports
import bpy  # type: ignore pylint: disable=import-error


# %% Precalculated satellite locations
def satPos(crossTrack):
    positions = []
    if crossTrack == 0:
        positions.append([346.285465, -1622.225828, 293.203709])
        positions.append([220.728876, -1032.990336, 415.560429])
        positions.append([147.909130, -690.031426, 461.382452])
        positions.append([103.582748, -480.277862, 480.427937])
        positions.append([70.317932, -322.525289, 490.309511])
        positions.append([44.985305, -202.353244, 495.291023])
        positions.append([22.879956, -97.000199, 497.850812])
        positions.append([2.442822, 0.764222, 498.718550])
        positions.append([-19.579737, 106.196734, 498.028672])
        positions.append([-41.529925, 211.515780, 495.655439])
        positions.append([-66.446549, 331.856552, 490.882378])
        positions.append([-99.110150, 489.588589, 481.288545])
        positions.append([-143.863433, 707.135136, 461.820665])
        positions.append([-212.217087, 1043.221046, 417.407932])
        positions.append([-330.272767, 1633.964376, 296.165255])
    if crossTrack == 10:
        positions.append([425.487943, -1599.209488, 294.214652])
        positions.append([310.628394, -1061.950287, 407.532616])
        positions.append([242.164546, -741.810366, 453.193568])
        positions.append([195.799786, -524.759231, 475.088336])
        positions.append([162.239696, -367.308621, 486.437092])
        positions.append([136.667828, -247.141080, 492.547952])
        positions.append([112.672831, -134.373037, 496.281114])
        positions.append([80.682264, 15.929043, 498.249958])
        positions.append([48.888910, 166.285953, 496.782227])
        positions.append([24.961399, 279.046956, 493.426956])
        positions.append([-1.944312, 406.794917, 487.286214])
        positions.append([-35.072523, 564.349788, 476.282593])
        positions.append([-79.024674, 774.103397, 455.724913])
        positions.append([-148.742386, 1109.495348, 408.692839])
        positions.append([-259.049347, 1647.751406, 295.941189])
    if crossTrack == 20:
        positions.append([526.993216, -1568.217795, 294.373407])
        positions.append([405.278723, -1001.161261, 411.870613])
        positions.append([332.938267, -665.964068, 457.299703])
        positions.append([287.586396, -456.453141, 476.843047])
        positions.append([251.944994, -291.516788, 487.481081])
        positions.append([225.950568, -171.375049, 492.612765])
        positions.append([201.653370, -58.770084, 495.422170])
        positions.append([178.815196, 46.492182, 496.305284])
        positions.append([157.777408, 144.144291, 495.612408])
        positions.append([133.440281, 256.815467, 493.010209])
        positions.append([105.899005, 384.468842, 487.722733])
        positions.append([71.927314, 541.917750, 477.771005])
        positions.append([25.278095, 758.912123, 457.815601])
        positions.append([-46.475133, 1094.230731, 412.616890])
        positions.append([-166.925991, 1661.469330, 295.501431])
    if crossTrack == 30:
        positions.append([628.476145, -1536.936620, 292.913470])
        positions.append([510.899453, -992.082764, 406.089821])
        positions.append([441.170580, -672.031374, 450.566129])
        positions.append([392.079794, -447.763872, 472.248328])
        positions.append([357.571358, -290.327657, 482.843819])
        positions.append([327.986946, -155.409101, 488.902894])
        positions.append([303.190586, -42.773173, 491.835089])
        positions.append([280.089492, 62.285545, 492.823513])
        positions.append([255.286002, 174.865720, 492.015493])
        positions.append([230.513372, 287.435653, 489.272194])
        positions.append([200.665086, 422.462994, 483.430775])
        positions.append([166.026955, 579.735990, 473.100432])
        positions.append([116.543478, 804.045108, 451.775407])
        positions.append([44.496697, 1131.277961, 406.613973])
        positions.append([-73.226334, 1668.207810, 295.516801])
    if crossTrack == 40:
        positions.append([748.805452, -1482.513412, 292.892416])
        positions.append([640.147925, -981.934632, 396.612232])
        positions.append([571.351578, -669.617006, 441.150877])
        positions.append([521.721270, -445.582926, 463.743320])
        positions.append([484.914653, -280.949621, 475.427242])
        positions.append([454.806007, -146.046669, 481.891802])
        positions.append([426.165329, -18.654554, 485.449437])
        positions.append([400.860813, 93.914651, 486.524924])
        positions.append([375.537146, 206.375792, 485.665685])
        positions.append([346.770802, 333.807420, 482.355408])
        positions.append([316.248347, 468.541828, 476.151848])
        positions.append([278.853278, 633.186481, 464.782372])
        positions.append([228.004355, 856.876823, 442.615343])
        positions.append([155.327236, 1176.041249, 397.433944])
        positions.append([43.112293, 1668.135897, 295.796916])
    if crossTrack == 50:
        positions.append([898.264567, -1397.241540, 292.978219])
        positions.append([801.438861, -955.485879, 383.263200])
        positions.append([736.845551, -665.762674, 425.645355])
        positions.append([686.287402, -442.035830, 449.438491])
        positions.append([647.216588, -270.150537, 462.462572])
        positions.append([614.546805, -127.947944, 469.821681])
        positions.append([583.556726, 6.883261, 473.924748])
        positions.append([554.164401, 134.157118, 475.245578])
        positions.append([526.274300, 253.943415, 474.232059])
        positions.append([494.934540, 388.662414, 470.452101])
        positions.append([459.887858, 538.115324, 463.004580])
        positions.append([419.508255, 709.769744, 450.192415])
        positions.append([368.527165, 925.600871, 427.580131])
        positions.append([298.185483, 1221.724812, 384.629009])
        positions.append([194.627257, 1654.124144, 296.564251])
    if crossTrack == 60:
        positions.append([1093.326465, -1249.984283, 293.305368])
        positions.append([1012.865967, -888.873168, 364.059565])
        positions.append([953.807797, -629.187892, 402.188983])
        positions.append([905.542330, -420.687083, 425.221646])
        positions.append([863.643100, -241.642957, 439.637291])
        positions.append([828.317296, -92.221379, 447.897878])
        positions.append([794.511045, 49.836841, 452.568779])
        positions.append([762.281068, 184.341449, 454.137849])
        positions.append([727.983298, 326.297402, 452.787157])
        positions.append([693.394544, 468.053279, 448.356324])
        positions.append([656.949890, 617.249505, 440.322144])
        positions.append([612.825291, 795.743305, 426.193157])
        positions.append([561.139571, 1003.463110, 403.469003])
        positions.append([494.318270, 1269.059503, 364.465729])
        positions.append([404.907817, 1620.083326, 295.417270])
    if crossTrack == 70:
        positions.append([1376.983717, -925.305636, 294.221070])
        positions.append([1320.438542, -681.450636, 335.253416])
        positions.append([1272.834152, -481.207355, 362.035373])
        positions.append([1229.726931, -302.856335, 380.654282])
        positions.append([1191.394640, -146.417364, 392.943590])
        positions.append([1154.445409, 2.485380, 401.146303])
        positions.append([1118.840944, 144.119948, 405.796540])
        positions.append([1082.727929, 285.629176, 407.388069])
        positions.append([1048.319913, 419.641938, 406.029656])
        positions.append([1011.554510, 560.861818, 401.619449])
        positions.append([972.576952, 709.332726, 393.636683])
        positions.append([929.277244, 872.235226, 380.931632])
        positions.append([881.521912, 1049.494002, 362.377035])
        positions.append([827.430210, 1247.975853, 335.663130])
        positions.append([762.793388, 1481.959099, 295.995716])

    return positions


# %% Set camera positions for satellite, using precalculated locations
def run(numCams, crossTrack, focalLength):
    # %% Camera Positions
    print(numCams)
    camPos = satPos(crossTrack)

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
