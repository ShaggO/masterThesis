%Computes if a matching pair of features, p1 and p2, are consistent with
%our robot data set. For a further description of the function and the
%parameters see RunMe.m and ReadMe.txt.
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
%function [CorrectMatch,IsEst]=IsMatchConsistent(Grid3D,Pts,Rad3D,StrLBoxPad,BackProjThresh,Cams,p1,p2)
function [CorrectMatch,IsEst]=IsMatchConsistent(Grid3D,Pts,Rad3D,StrLBoxPad,BackProjThresh,Cams,p1,p2)

[Mean,Var,IsEst]=Get3DGridEst(Grid3D,Pts,Rad3D,p1(1),p1(2));
if(IsEst)
    Var=Var+StrLBoxPad;
    Q=Mean*ones(1,8)+[Var(1)*[-1 1 -1 1 -1 1 -1 1];Var(2)*[-1 -1 1 1 -1 -1 1 1];Var(3)*[-1 -1 -1 -1 1 1 1 1]];
    q=Cams(:,:,2)*[Q;ones(1,8)];
    depth=mean(q(3,:));
    q(1,:)=q(1,:)./q(3,:);
    q(2,:)=q(2,:)./q(3,:);
    q(3,:)=q(3,:)./q(3,:);
    
    if(p2(1)>min(q(1,:)) & p2(1)<max(q(1,:)) & p2(2)>min(q(2,:)) & p2(2)<max(q(2,:)))
        if(IsPointCamGeoConsistent([p1 1]',[p2 1]',Cams,BackProjThresh))
            CorrectMatch=1;
        else
            CorrectMatch=-1;
        end
    else
        CorrectMatch=-1;
    end
else
    CorrectMatch=0;
end