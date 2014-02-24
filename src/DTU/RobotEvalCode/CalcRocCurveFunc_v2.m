% Computes the receiver operator characteristic (ROC) curve, of a set of 
% matches, match, associated with an image pair of our robot data set. See 
% ReadMe.txt. It also computes the area under the ROC curve by calling
% ROCarea.
%
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011
%
%function [ROC,Area]=CalcRocCurveFunc_v2(match)
function [ROC,Area]=CalcRocCurveFunc_v2(match)

Scores=zeros(2,size(match.coord,1));
for i=1:size(Scores,2),
    if(match.CorrectMatch(i)==1)
        Scores(1,i)=match.distRatio(i);
    end
    if(match.CorrectMatch(i)==-1)
        Scores(2,i)=match.distRatio(i);
    end
end

tot=sum(Scores'>0)+1e-10;

ROC=zeros(2,100);
idx=1;
for i=0.01:0.01:1,
    % ratio of correct matches under score i
    ROC(1,idx)=sum(Scores(1,:)<i & Scores(1,:)>0 )/tot(1);
    % ratio of incorrect matches over score i
    ROC(2,idx)=sum(Scores(2,:)>i & Scores(2,:)>0 )/tot(2);
    idx=idx+1;
end

Area=ROCarea(ROC);