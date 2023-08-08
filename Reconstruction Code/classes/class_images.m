classdef class_images
    %CLASS_IMAGES Image data and locations
    %   Includes original image, binary image, image location in LLA, ECEF,
    %   and ENU, image extrinsic matrix, and image ecef2cam rotation
    %   matrix.
    
    properties
        name;
        binary;
        density;
        alpha;
        camera = 1;
        LLA = zeros(1, 3);
        ECEF = zeros(1, 3);
        ECI = zeros(1, 3);
        ENU = zeros(1, 3);
        extrinsic = zeros(3, 3);
        cam2ecef = zeros(3, 3);
        camVectorScale = [1; 1; 1];
    end
    
    methods
        function obj = lla2enu(obj, targetLLA)
            %LLA2ENU Image locations lla2enu
            %   images = lla2enu(images, targetLLA)   
            %
            %   Transform image locations from LLA to ENU, given target
            %   coordinates in LLA

            for i = 1:length(obj)
                % transform camera locations from LLA to ECEF
                obj(i).ECEF = lla2ecef(obj(i).LLA);
                
                % transform camera locations from ECEF to ENU
                [obj(i).ENU(1), obj(i).ENU(2), obj(i).ENU(3)] = ecef2enu(obj(i).ECEF(1), obj(i).ECEF(2), obj(i).ECEF(3), targetLLA(1), targetLLA(2), targetLLA(3), wgs84Ellipsoid);
            end
        end
    end
end

