classdef class_voxels
    %CLASS_VOXELS Voxel data.
    %   Includes original voxel ENU locations and the reduced set of voxels
    %   that have been found to be in the plume, along with the voxel
    %   properties such as number, total volume, resolution, probability
    %   threshold.
    
    properties
        resolution = 0;
        probThreshold = 0;
        imagePercentage = 0;
        number = 0;
        xBound = [0 0];
        yBound = [0 0];
        zBound = [0 0];
        ENU;
        ECEF;
        LLA;
        ECI;
        plume;
    end
    
    methods
        function obj = class_voxels(resolution, xBoundInput, yBoundInput, zBoundInput)
            %CLASS_VOXELS Construct an instance of this class
            %   voxels = CLASS_VOXELS(resolution, xBoundInput, yBoundInput, zBoundInput)
            %   
            %   Creates the voxels grid alligned to multiples of voxel
            %   resoultion

            % size of each voxel
            obj.resolution = resolution;
            
            % bounds
            obj.xBound = xBoundInput;
            obj.yBound = yBoundInput;
            obj.zBound = zBoundInput;
            
            % snap voxels to grid, multiples of resolution, halfres offset
            % from bounds
            halfRes = resolution / 2;
            xVoxLimit(1) = floor(xBoundInput(1) / resolution) * resolution + halfRes;
            xVoxLimit(2) = ceil(xBoundInput(2) / resolution) * resolution - halfRes;
            
            yVoxLimit(1) = floor(yBoundInput(1) / resolution) * resolution + halfRes;
            yVoxLimit(2) = ceil(yBoundInput(2) / resolution) * resolution - halfRes;
            
            zVoxLimit(1) = floor(zBoundInput(1) / resolution) * resolution + halfRes;
            zVoxLimit(2) = ceil(zBoundInput(2) / resolution) * resolution - halfRes;

            % define voxel points spacing in x, y, and z axes
            x = (xVoxLimit(1):resolution:xVoxLimit(2));
            y = (yVoxLimit(1):resolution:yVoxLimit(2));
            z = (zVoxLimit(1):resolution:zVoxLimit(2));
            
            % create meshgrid of voxel points
            [X, Y, Z] = meshgrid(x, y, z);
            
            % put voxels into array, set each voxel to 1
            obj.ENU = [X(:) Y(:) Z(:)];
            
            % number of actual voxels created
            obj.number = length(obj.ENU);
        end
    end
end

