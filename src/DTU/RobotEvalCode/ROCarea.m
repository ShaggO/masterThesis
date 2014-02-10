% Computes the area under a receiver operator characteristic (ROC) curve.
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
%function Area=ROCarea(ROC)
function Area=ROCarea(ROC)

Area=0;
for i=2:size(ROC,2),
    a=ROC(1,i)-ROC(1,i-1);
    b=(ROC(2,i)+ROC(2,i-1))/2;
    Area=Area+a*b;
end
