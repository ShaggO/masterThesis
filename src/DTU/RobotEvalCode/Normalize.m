%Normalizes a set of homogeneous coordinates to inhomogeneous coordinates,
%ie. that last element is set to one. The input matrix X is assume to have
%one observation pr. row.
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
%function Xn=Normalize(X)
function Xn=Normalize(X)

Xn=zeros(size(X));

for i=1:size(X,1)
    Xn(i,:)=X(i,:)./X(end,:);
end
