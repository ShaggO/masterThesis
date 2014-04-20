% Computes the area under a receiver operator characteristic (ROC) curve.
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
%function Area=ROCarea(ROC)
function Area=ROCarea(ROC,type)

if nargin < 2
    type = 'roc';
end

switch type
    case 'roc'
        ROC = [ROC [1; 1]];
    case 'pr'
        ROC = flipud(ROC);
        ROC(2,:) = 1 - ROC(2,:);
end

Area=0;
for i=2:size(ROC,2),
    a=ROC(1,i)-ROC(1,i-1);
    b=(ROC(2,i)+ROC(2,i-1))/2;
    Area=Area+a*b;
end