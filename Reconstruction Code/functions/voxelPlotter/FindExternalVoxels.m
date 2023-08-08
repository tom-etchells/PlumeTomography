function [FV]=FindExternalVoxels(X, Y, Z, VoxelMat,Vox_Size,densityLimit)
% FindExternalVoxels scans VoxeLMat (a 3D matrix) and finds which voxels
% are external by checking if they have nieghbors from all 6 sides
% (TOP,BOTTOM,FRONT,BACK,LEFT,RIGHT). After finding if the voxel is
% external it finds which faces are external by calling FindExternalFaces
% function and generating an FV structure for visualization

%initializing variables
FV.vertices=zeros(8*size(VoxelMat,1)*size(VoxelMat,2)*size(VoxelMat,3),3);
FV.faces=zeros(6*size(VoxelMat,1)*size(VoxelMat,2)*size(VoxelMat,3),4);
FV.col=zeros(6*size(VoxelMat,1)*size(VoxelMat,2)*size(VoxelMat,3),1);
FaceIndex=1;
VertexIndex=0;
counter=1;
ExternalIndexes=zeros(size(VoxelMat,1)*size(VoxelMat,2)*size(VoxelMat,3),3);
PositionIndexes=zeros(size(VoxelMat,1)*size(VoxelMat,2)*size(VoxelMat,3),3);
% voxel_size=2^(Vox_Size-1)*[1 1 1];
voxel_size = Vox_Size*[1 1 1];
% h=waitbar(0,'loading voxels, please wait...');

for i=1:size(VoxelMat,1)
    for j=1:size(VoxelMat,2)
        for k=1:size(VoxelMat,3)
%             if VoxelMat(i,j,k)==1
            if VoxelMat(i,j,k)>0
%                 ExternalIndexes(counter,1:3)=[i j k] ;
% %                 ExternalIndexes(counter,1:3)=[j i k] ;
% %                 PositionIndexes(counter,1:3)=[Y(i, j, k) X(i, j, k) Z(i, j, k)] ;
%                 PositionIndexes(counter,1:3)=[X(i, j, k) Y(i, j, k) Z(i, j, k)] ;
%                 [FV,FaceIndex,VertexIndex]=FindExternalFaces(VoxelMat,ExternalIndexes,PositionIndexes,voxel_size,counter,FaceIndex,VertexIndex,Vox_Size,FV,densityLimit);
%                 counter=counter+1;
                if i==1 || j==1 || k==1 || i==size(VoxelMat,1) || j== size(VoxelMat,2) || k== size(VoxelMat,3)                 
                    ExternalIndexes(counter,1:3)=[i j k] ;
%                     ExternalIndexes(counter,1:3)=[j i k] ;
%                     PositionIndexes(counter,1:3)=[Y(i, j, k) X(i, j, k) Z(i, j, k)] ;
                    PositionIndexes(counter,1:3)=[X(i, j, k) Y(i, j, k) Z(i, j, k)] ;
                    [FV,FaceIndex,VertexIndex]=FindExternalFaces(VoxelMat,ExternalIndexes,PositionIndexes,voxel_size,counter,FaceIndex,VertexIndex,Vox_Size,FV,densityLimit);
                    counter=counter+1;
                elseif VoxelMat(i+1,j,k)==0 || VoxelMat(i-1,j,k)==0 || VoxelMat(i,j+1,k)==0 || VoxelMat(i,j-1,k)==0 || VoxelMat(i,j,k+1)==0 || VoxelMat(i,j,k-1)==0
                    ExternalIndexes(counter,1:3)=[i j k] ;
%                     ExternalIndexes(counter,1:3)=[j i k] ;
%                     PositionIndexes(counter,1:3)=[Y(i, j, k) X(i, j, k) Z(i, j, k)] ;
                    PositionIndexes(counter,1:3)=[X(i, j, k) Y(i, j, k) Z(i, j, k)] ;
                    [FV,FaceIndex,VertexIndex]=FindExternalFaces(VoxelMat,ExternalIndexes,PositionIndexes,voxel_size,counter,FaceIndex,VertexIndex,Vox_Size,FV,densityLimit);
                    counter=counter+1;
                elseif VoxelMat(i,j,k)>densityLimit
                    ExternalIndexes(counter,1:3)=[i j k] ;
%                     ExternalIndexes(counter,1:3)=[j i k] ;
%                     PositionIndexes(counter,1:3)=[Y(i, j, k) X(i, j, k) Z(i, j, k)] ;
                    PositionIndexes(counter,1:3)=[X(i, j, k) Y(i, j, k) Z(i, j, k)] ;
                    [FV,FaceIndex,VertexIndex]=FindExternalFaces(VoxelMat,ExternalIndexes,PositionIndexes,voxel_size,counter,FaceIndex,VertexIndex,Vox_Size,FV,densityLimit);
                    counter=counter+1;
                end
%                 end
            end
        end
    end 
%     waitbar(i/size(VoxelMat,1));
end

counter=counter-1;

[numVerts, ~] = max([find(FV.vertices(:, 1), 1, 'last') find(FV.vertices(:, 2), 1, 'last') find(FV.vertices(:, 3), 1, 'last')]);
FV.vertices=FV.vertices(1:numVerts,:);
% FV.vertices=FV.vertices(any(FV.vertices,2),:);
FV.faces=FV.faces(any(FV.faces,2),:);
FV.col=FV.col(any(FV.col,2),:);
% close(h) ;
end

function [FV,FaceIndex,VertexIndex]=FindExternalFaces(VoxelMat,ExternalIndexes,PositionIndexes,voxel_size,i,FaceIndex,VertexIndex,LOD,FV,densityLimit)
faces=[1 2 3 4; 2 6 7 3 ; 6 5 8 7; 5 1 4 8; 4 3 7 8 ; 1 2 6 5];
% FV.vertices(VertexIndex+1:VertexIndex+8,:)= ...
%     [2^(LOD-1) * (PositionIndexes(i,1)-1) + 0.5 + [0 voxel_size(1) voxel_size(1) 0 0 voxel_size(1) voxel_size(1) 0]; ...
%      2^(LOD-1) * (PositionIndexes(i,2)-1) + 0.5 + [0 0 0 0 voxel_size(2) voxel_size(2) voxel_size(2) voxel_size(2)]; ...
%      2^(LOD-1) * (PositionIndexes(i,3)-1) + 0.5 + [0 0 voxel_size(3) voxel_size(3) 0 0 voxel_size(3) voxel_size(3)]]';
 FV.vertices(VertexIndex+1:VertexIndex+8,:)= ...
     [  (PositionIndexes(i,1)) - voxel_size(1)/2 + [0 voxel_size(1) voxel_size(1) 0 0 voxel_size(1) voxel_size(1) 0]; ...
        (PositionIndexes(i,2)) - voxel_size(2)/2 + [0 0 0 0 voxel_size(2) voxel_size(2) voxel_size(2) voxel_size(2)]; ...
     	(PositionIndexes(i,3)) - voxel_size(3)/2 + [0 0 voxel_size(3) voxel_size(3) 0 0 voxel_size(3) voxel_size(3)]]';
if ExternalIndexes(i,2)~=1
    if VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2)-1,ExternalIndexes(i,3))<densityLimit
        %No -X neighbor
        FV.faces(FaceIndex,:)=faces(4,:)+VertexIndex;
        FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
        FaceIndex=FaceIndex+1;
    end
else
    % Bounding Box -X
    FV.faces(FaceIndex,:)=faces(4,:)+VertexIndex;
    FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
    FaceIndex=FaceIndex+1;
end

if ExternalIndexes(i,1)~=size(VoxelMat,1)
    if VoxelMat(ExternalIndexes(i,1)+1,ExternalIndexes(i,2),ExternalIndexes(i,3))<densityLimit
        %No -Y neighbor
        FV.faces(FaceIndex,:)=faces(1,:)+VertexIndex;
        FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
        FaceIndex=FaceIndex+1;
    end
else
    % Bounding Box -Y
    FV.faces(FaceIndex,:)=faces(1,:)+VertexIndex;
    FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
    FaceIndex=FaceIndex+1;
end

if ExternalIndexes(i,2)~=size(VoxelMat,2)
    if VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2)+1,ExternalIndexes(i,3))<densityLimit
        % No +X neighbor
        FV.faces(FaceIndex,:)=faces(2,:)+VertexIndex;
        FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
        FaceIndex=FaceIndex+1;
    end
else
    % Bounding Box +X
    FV.faces(FaceIndex,:)=faces(2,:)+VertexIndex;
    FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
    FaceIndex=FaceIndex+1;
end

if ExternalIndexes(i,1)~=1
    if VoxelMat(ExternalIndexes(i,1)-1,ExternalIndexes(i,2),ExternalIndexes(i,3))<densityLimit
        %No +Y neighbor
        FV.faces(FaceIndex,:)=faces(3,:)+VertexIndex;
        FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
        FaceIndex=FaceIndex+1;
    end
else
    % Bounding Box +Y
    FV.faces(FaceIndex,:)=faces(3,:)+VertexIndex;
    FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
    FaceIndex=FaceIndex+1;
end

if ExternalIndexes(i,3)~=size(VoxelMat,3)
    if VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3)+1)<densityLimit
        %No +Z neighbor
        FV.faces(FaceIndex,:)=faces(5,:)+VertexIndex;
        FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
        FaceIndex=FaceIndex+1;
    end
else
    % Bounding Box +Z
    FV.faces(FaceIndex,:)=faces(5,:)+VertexIndex;
    FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
    FaceIndex=FaceIndex+1;
end

if ExternalIndexes(i,3)~=1
    if VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3)-1)<densityLimit
        %No Bottom -Z
        FV.faces(FaceIndex,:)=faces(6,:)+VertexIndex;
        FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
        FaceIndex=FaceIndex+1;
    end
else
    % Bounding Box -Z
    FV.faces(FaceIndex,:)=faces(6,:)+VertexIndex;
    FV.col(FaceIndex,1) = VoxelMat(ExternalIndexes(i,1),ExternalIndexes(i,2),ExternalIndexes(i,3));
    FaceIndex=FaceIndex+1;
end
VertexIndex=VertexIndex+8;
end

