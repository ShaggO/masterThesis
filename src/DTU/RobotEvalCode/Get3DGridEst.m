% For a feature in the KeyFrame of our robot data set with coordinate
% (cCol,cRow), this function computes the following for the 3D points of 
% the structured light scan that project to within Rad3D:
% the Mean, boundingbox, Var, and if any 3D points exist, IsEst. The input
% additional parameters, Grid3D and Pts, are computed via 
% GenStrLightGrid_v2.
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
% function [Mean,Var,IsEst]=Get3DGridEst(Grid3D,Pts,Rad3D,cCol,cRow)
function [Mean,Var,IsEst]=Get3DGridEst(Grid3D,Pts,Rad3D,cCol,cRow)

cGCol=ceil(cCol/Rad3D);
cGRow=ceil(cRow/Rad3D);

if(cGCol<1 | cGCol>size(Grid3D,1) | cGRow<1 | cGRow>size(Grid3D,2))
    IsEst=false;
    Mean=[];
    Var=[];
    return;
end

P=[];
for i=-1:1
    for j=-1:1
        if((cGCol+i)>0 & (cGCol+i)<=size(Grid3D,1) & (cGRow+j)>0 & (cGRow+j)<=size(Grid3D,2))
            P=[P Pts(:,Grid3D{cGCol+i,cGRow+j})];
        end
    end
end

P2=P;
P=[];
for i=1:size(P2,2),
    if(norm([P2(1,i)-cCol P2(2,i)-cRow])<=Rad3D)
        P=[P P2(3:5,i)];
    end
end

if(isempty(P))
    IsEst=false;
    Mean=[];
    Var=[];
    return
end


IsEst=true;

if(size(P,2)==1)
    Mean=P;
    Var=zeros(3,1);
    return;
end

Mean=mean(P')';
P=abs(P-Mean*ones(1,size(P,2)));
Var=max(P')';
