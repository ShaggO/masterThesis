% The DLT algorithm for 3D point estimation.
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
% function X=Est3DPointLinear(Cams, p)
function X=Est3DPointLinear(Cams, p)

nCams=size(Cams,3);
B=zeros(2*nCams,4);
p=Normalize(p);

for cCam=1:nCams,
    B(cCam,:)       = Cams(3,:,cCam)*p(1,cCam)-Cams(1,:,cCam);
    B(cCam+nCams,:) = Cams(3,:,cCam)*p(2,cCam)-Cams(2,:,cCam);
end

[u,s,v]=svd(B);
if(abs(v(4,4))>1e-8)
    X=v(:,4)/v(4,4);
else
    X=v(:,4);
end
   
