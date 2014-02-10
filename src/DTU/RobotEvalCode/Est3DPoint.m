% Estimates a 3D point from features p and projective camera matrices Cams.
% This is done by first using the linear DLT method and then nonlinear
% optimization.
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
% function [X,fit]=Est3DPoint(Cams, p)
function [X,fit]=Est3DPoint(Cams, p)


X0=Est3DPointLinear(Cams,p);

nCams=size(Cams,3);
p=Normalize(p);

FuncData{1}      = Cams;
FuncData{2}      = p;
FuncData{3}      = nCams;

X=marquardt('Est3DPointObj',X0,[1, 1e-12,1e-12,1000],FuncData);

fit=Est3DPointObj(X,FuncData);
fit=fit'*fit/nCams;






