% Generates a quad tree of the projection of the structured light scan onto
% the KeyFrame, cf. RunMe.m and ReadMe.txt. This is used for faster
% operation, ie. a precipitation for Get3DGridEst. The input parameters
% are as follows:
% KeyFrame, the frame number of the Key frame, we always use frame 25 
% In3DPath, the bath or the structured light scans.
% ImRows, the number of rows of the Key frame.
% ImCols, the number of colomns of the KeyFrame.
% Rad3D, the size of the cells of the quad tree.
% cSet, the set number.
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
% function [Grid3D,Pts]=GenStrLightGrid_v2(KeyFrame,In3DPath,ImRows,ImCols,Rad3D,cSet)
function [Grid3D,Pts]=GenStrLightGrid_v2(KeyFrame,In3DPath,ImRows,ImCols,Rad3D,cSet)

KeyCam=GetCam(KeyFrame);

if(cSet<10)
    load([In3DPath 'Clean_Reconstruction_0' num2str(cSet)])
else
    load([In3DPath 'Clean_Reconstruction_' num2str(cSet)])
end

Pts=[pts3D_near(1:3,:) pts3D_far(1:3,:)];

pts=KeyCam*[Pts;ones(1,size(Pts,2))];
pts(1,:)=pts(1,:)./pts(3,:);
pts(2,:)=pts(2,:)./pts(3,:);
pts(3,:)=pts(3,:)./pts(3,:);

Pts=[pts(1,:);pts(2,:);Pts];

GridRow=ceil(ImRows/Rad3D);
GridCol=ceil(ImCols/Rad3D);
for cRow=1:GridRow,
    for cCol=1:GridCol,
        Grid3D{cCol,cRow}=[];
    end
end
for cPts=1:size(Pts,2),
    Q=Pts(:,cPts);
    if(Q(1)>0 & Q(1)<ImCols & Q(2)>0 & Q(2)<ImRows)
        Grid3D{ceil(Q(1)/Rad3D),ceil(Q(2)/Rad3D)}=...
            [Grid3D{ceil(Q(1)/Rad3D),ceil(Q(2)/Rad3D)}...
            cPts];
    end
end

