%Example script for the code in this folder, aimed at evaluating feature
%correspondances of our robot data. See ReadMe.txt
%
% Anders Dahl &
% Henrik Aanæs
% DTU Informatics
% Technical University of Denmark
% haa@imm.dtu.dk
% Dec. 2011

clear all
close all
clc

tic

cSet=1;                 %The scene or set
cIm=30;                 %The image to compare to the key frame
load har_sift030.mat    %The matching data, which is what is to be evaluated
KeyFrame=25;            %The Key Frame, in all our experiments this is the one used. 
In3DPath='CleanRecon_2009_11_16/';  %(relative) path of the structured light scans.
Rad3D=10;               %Size of search cells in the structured light grid.
StrLBoxPad=3e-3;        %=3mm
BackProjThresh=5;       %pixels

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actual Evaluation Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Precomputes the quad tree of projected structured light points, for
% faster computaion later.
[Grid3D,Pts]=GenStrLightGrid_v2(KeyFrame,In3DPath,1200,1600,Rad3D,cSet);
%Get the projective camera matrices.
Cams=GetCamPair(KeyFrame,cIm);
for i=1:size(match.coord,1),
    %Get the coordinates of the matched pair from the match structure.
    p2=match.coord(i,:);
    p1=match.coordKey(match.matchIdx(i,1),:);

    %Determine if the match is consistent.
    [CorrectMatch,IsEst]=IsMatchConsistent(Grid3D,Pts,Rad3D,StrLBoxPad,BackProjThresh,Cams,p1,p2);
    match.CorrectMatch(i)=CorrectMatch;
end

%Compute the ROC-curve and the area under it.
[ROC,Area]=CalcRocCurveFunc_v2(match);

Area

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot for Visual Verification/QC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

im1=imread('Img030_diffuse.ppm');
im2=imread('Img025_diffuse.ppm');
Pad=ones(1200,100,3)*255;

figure(1)
imagesc([im1 Pad im2])
offset=size(im1,2)+size(Pad,2);
hold on
for i=1:size(match.coord,1)
    if(match.CorrectMatch(i)==1)
        p2=match.coord(i,:);
        p1=match.coordKey(match.matchIdx(i,1),:);
        plot([p2(1) p1(1)+offset],[p2(2) p1(2)],'o-')
    end
end
hold off


figure(2)
imagesc([im1 Pad im2])
offset=size(im1,2)+size(Pad,2);
hold on
for i=1:size(match.coord,1)
    if(match.CorrectMatch(i)==-1)
        p2=match.coord(i,:);
        p1=match.coordKey(match.matchIdx(i,1),:);
        plot([p2(1) p1(1)+offset],[p2(2) p1(2)],'ro-')
    end
end
hold off


toc



