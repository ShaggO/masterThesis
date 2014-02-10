%Example script for the code in this folder, aimed at evaluating feature
%recall rate with our robot data. See ReadMe.txt
%
% Anders Dahl &
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Feb. 2012

clear all
close all
clc

tic

cSet=1;                     %The scene or set
cIm=30;                     %The image to compare to the key frame
load RecallRateSample.mat   %The matching data, which is what is to be evaluated, loading KeyPoints and Points
KeyFrame=25;                %The Key Frame, in all our experiments this is the one used.
In3DPath='CleanRecon_2009_11_16/';  %(relative) path of the structured light scans.
Rad3D=10;                   %Size of search cells in the structured light grid.
StrLBoxPad=3e-3;            %=3mm
BackProjThresh=5;           %pixels
ScaleMargin=2;              %Margin for change in scale, corrected for distance to the secen, in orer for a correspondance to be accepted. A value of 2 corresponds to an octave.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actual Evaluation Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Precomputes the quad tree of projected structured light points, for
% faster computaion later.
[Grid3D,Pts]=GenStrLightGrid_v2(KeyFrame,In3DPath,1200,1600,Rad3D,cSet);
%Get the projective camera matrices.
Cams=GetCamPair(KeyFrame,cIm);

%The histogram of how many consistent matches are possible for the features
%in the KeyFrame.
nCorrHist=zeros(1,10);
%The amount of features note taking part in the evaluatio, since they do
%not project to the structured light scan.
nNoEst=0;

for cP=1:size(KeyPoints,1)
    [idx,IsEst]=GetConsistentCorrespondences(Grid3D,Pts,Rad3D,StrLBoxPad,BackProjThresh,Cams,ScaleMargin,KeyPoints(cP,1:2),KeyPoints(cP,3),Points);
    if(IsEst)
        if(isempty(idx))
            nCorrHist(1)=nCorrHist(1)+1;
        else
            histIdx=min(length(idx),length(nCorrHist)-1)+1;
            nCorrHist(histIdx)=nCorrHist(histIdx)+1;
        end
    else
        nNoEst=nNoEst+1;
    end
end

RecallRate=sum(nCorrHist(2:end))/sum(nCorrHist)

toc