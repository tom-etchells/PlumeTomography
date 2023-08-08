classdef class_camera
    %CLASS_CAMERA Camera properties
    %   Includes camera proprties such as focal length and resolution as
    %   well as camera intrinsic matrix and reference data.
    
    properties
        pixelSize = zeros(1, 2);
        focalLength = 0;
        sensor = 0;
        resolution = zeros(1, 2);
        intrinsic = zeros(3, 3);
        pTangential = zeros(1, 2);
        kRadial = zeros(1, 3);
        refDataScale = 0;
        refDataRotation = zeros(3, 3);
    end
end

