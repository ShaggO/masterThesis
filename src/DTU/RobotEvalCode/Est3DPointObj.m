% The objective function for nonlinear 3D point estimation
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
% function [f,J]=Est3DPointObj(X,FuncData)
function [f,J]=Est3DPointObj(X,FuncData)

Cams    =   FuncData{1};
p       =   FuncData{2};
nCams   =   FuncData{3};

f=zeros(2*nCams,1);
J=zeros(2*nCams,4);

for cCam=1:nCams,
    q=Cams(:,:,cCam)*X;
    f(cCam)         = q(1)/q(3) - p(1,cCam)/p(3,cCam);
    f(cCam+nCams)   = q(2)/q(3) - p(2,cCam)/p(3,cCam);
    J(cCam,:)       = ( Cams(1,:,cCam)*q(3) - Cams(3,:,cCam)*q(1) )/(q(3)*q(3));
    J(cCam+nCams,:) = ( Cams(2,:,cCam)*q(3) - Cams(3,:,cCam)*q(2) )/(q(3)*q(3));
end

