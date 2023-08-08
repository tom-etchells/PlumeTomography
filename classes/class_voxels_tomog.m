classdef class_voxels_tomog
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
        function obj = class_voxels_tomog(resolution, xBoundInput, yBoundInput, zBoundInput)
            %CLASS_VOXELS Construct an instance of this class
            %   voxels = CLASS_VOXELS(resolution, xBoundInput, yBoundInput, zBoundInput)
            %   
            %   Creates the voxels grid alligned to multiples of voxel
            %   resoultion

            % size of each voxel
            obj.resolution = resolution;
            
            % snap bounds to grid, multiples of resolution
            halfRes = resolution / 2;
            obj.xBound(1) = floor(xBoundInput(1) / resolution) * resolution - halfRes;
            obj.xBound(2) = ceil(xBoundInput(2) / resolution) * resolution + halfRes;
            
            obj.yBound(1) = floor(yBoundInput(1) / resolution) * resolution - halfRes;
            obj.yBound(2) = ceil(yBoundInput(2) / resolution) * resolution + halfRes;
            
            obj.zBound(1) = floor(zBoundInput(1) / resolution) * resolution - halfRes;
            obj.zBound(2) = ceil(zBoundInput(2) / resolution) * resolution + halfRes;
            
            % define voxel points spacing in x, y, and z axes
            x = (obj.xBound(1):obj.resolution:obj.xBound(2));
            y = (obj.yBound(1):obj.resolution:obj.yBound(2));
            z = (obj.zBound(1):obj.resolution:obj.zBound(2));
            
            % create meshgrid of voxel points
            [X, Y, Z] = meshgrid(x, y, z);
            
            % put voxels into array, set each voxel to 1
            obj.ENU = [X(:) Y(:) Z(:)];
            
            % number of actual voxels created
            obj.number = length(obj.ENU);
        end
    end
end

