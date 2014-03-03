function match = evalCorrespondence(match)

KeyFrame=25;            %The Key Frame, in all our experiments this is the one used. 
In3DPath='CleanRecon_2009_11_16/';  %(relative) path of the structured light scans.
Rad3D=10;               %Size of search cells in the structured light grid.
StrLBoxPad=3e-3;        %=3mm
BackProjThresh=5;       %pixels

ScaleMargin=2;              %Margin for change in scale, corrected for distance to the secen, in orer for a correspondance to be accepted. A value of 2 corresponds to an octave.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actual Evaluation Loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Precomputes the quad tree of projected structured light points, for
% faster computaion later.
[Grid3D,Pts]=GenStrLightGrid_v2(KeyFrame,In3DPath,1200,1600,Rad3D,match.setNum);
%Get the projective camera matrices.
Cams=GetCamPair(KeyFrame,match.imNum);
match.CorrectMatch = zeros(size(match.coord,1),1);
for i=1:size(match.coord,1)
    %Get the coordinates of the matched pair from the match structure.
    p2=match.coord(i,:);
    p1=match.coordKey(match.matchIdx(i,1),:);

    %Determine if the match is consistent.
    [CorrectMatch,IsEst]=IsMatchConsistent(Grid3D,Pts,Rad3D,StrLBoxPad,BackProjThresh,Cams,p1,p2);
    match.CorrectMatch(i)=CorrectMatch;
end

%Compute the ROC-curve and the area under it.
[match.ROC,match.Area]=CalcRocCurveFunc_v2(match);

disp(['AUC = ' num2str(match.Area)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Actual Evaluation Loop (Recall)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Precomputes the quad tree of projected structured light points, for
% % faster computaion later.
% [Grid3D,Pts]=GenStrLightGrid_v2(KeyFrame,In3DPath,1200,1600,Rad3D,match.setNum);
% %Get the projective camera matrices.
% Cams=GetCamPair(KeyFrame,match.imNum);
% 
% %The histogram of how many consistent matches are possible for the features
% %in the KeyFrame.
% nCorrHist=zeros(1,10);
% %The amount of features note taking part in the evaluatio, since they do
% %not project to the structured light scan.
% nNoEst=0;
% 
% for cP=1:size(match.coordKey,1)
%     [idx,IsEst]=GetConsistentCorrespondences(Grid3D,Pts,Rad3D,StrLBoxPad,BackProjThresh,Cams,ScaleMargin,match.coordKey(cP,1:2),1/0.16,[match.coord repmat(1/0.16,[size(match.coord,1) 1])]);
%     if(IsEst)
%         if(isempty(idx))
%             nCorrHist(1)=nCorrHist(1)+1;
%         else
%             histIdx=min(length(idx),length(nCorrHist)-1)+1;
%             nCorrHist(histIdx)=nCorrHist(histIdx)+1;
%         end
%     else
%         nNoEst=nNoEst+1;
%     end
% end
% 
% match.RecallRate=sum(nCorrHist(2:end))/sum(nCorrHist);
% 
% disp(['RecallRate = ' num2str(match.RecallRate)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot for Visual Verification/QC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plotImages = 0;
if plotImages
im1=imread(dtuImagePath(match.setNum,match.imNum,match.liNum));
im2=imread(dtuImagePath(match.setNum,KeyFrame,match.liNum));
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
end

end

