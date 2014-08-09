clc, clear all

idxTP = [1 3 4 12 13 7 8 9 10 12];
idxFN = [1 2 4 5 6 7 8 9 10 11];
idxTN = [1 2 4 6 7 9 10 11 14 15];
idxFP = [1:9 11];
idxEP = [4 29 76 154 320 441 498 567 624 811];
idxEN1 = [50 3 11];
idxEN2 = [27 78 70];

test = load('results/inriaTestSvmGoFinal'); % settings

data = inriaData(10,1*10^5);
pos = data.loadCache('posTest');
neg = data.loadCache('negTestFull');

[probPos,probPosIdx] = sort(test.probPos);

[probNeg,probNegIdx] = sort(test.probNeg);
idxNeg = test.idxNeg(probNegIdx);
Xneg = test.Xneg(probNegIdx,:);

ItruePos = {pos(probPosIdx(end+1-idxTP)).image};
IfalseNeg = {pos(probPosIdx(idxFN)).image};

ItrueNeg = cell(1,numel(idxTN));
IfalsePos = cell(1,numel(idxFP));
for i = 1:numel(idxTN)
    ItrueNeg(i) = extractWindows(neg(idxNeg(idxTN(i))).image,Xneg(idxTN(i),:),[134 70]);
end
for i = 1:numel(idxFP)
    IfalsePos(i) = extractWindows(neg(idxNeg(end+1-idxFP(i))).image,Xneg(end+1-idxFP(i),:),[134 70]);
end

IexamplePos = {pos(idxEP).image};
idxBig = find(cellfun(@(x) size(x,1),{neg.image}) == 480);
IexampleNeg1 = {neg(idxBig(idxEN1)).image};
IexampleNeg2 = {neg(idxBig(idxEN2)).image};

%% Concatenate
border = 255*ones(134,5,3,'uint8');
truePos = cell2mat(interweave(ItruePos,repmat({border},1,numel(idxTP)-1)));
falseNeg = cell2mat(interweave(IfalseNeg,repmat({border},1,numel(idxFN)-1)));
trueNeg = cell2mat(interweave(ItrueNeg,repmat({border},1,numel(idxTN)-1)));
falsePos = cell2mat(interweave(IfalsePos,repmat({border},1,numel(idxFP)-1)));
examplePos = cell2mat(interweave(IexamplePos,repmat({border},1,numel(idxEP)-1)));
border = 255*ones(480,20,3,'uint8');
exampleNeg = cell2mat(interweave(IexampleNeg1,repmat({border},1,numel(idxEN1)-1)));
exampleNeg = [exampleNeg; 255*ones(20,size(exampleNeg,2),3,'uint8'); ...
    cell2mat(interweave(IexampleNeg2,repmat({border},1,numel(idxEN2)-1)))];

%% Figures
% figure
% imshow(truePos)
imwrite(truePos,'../report/img/objectDetectionTP.png')
imwrite(falseNeg,'../report/img/objectDetectionFN.png')
imwrite(trueNeg,'../report/img/objectDetectionTN.png')
imwrite(falsePos,'../report/img/objectDetectionFP.png')
imwrite(examplePos,'../report/img/inriaPositives.png')
imwrite(exampleNeg,'../report/img/inriaNegatives.png')

% I = rgb2gray(im2double(falseNeg));
% L = dGaussScaleSpace(I,kJetCoeffs(1),1,1,1);
% Theta = diffStructure('Theta',L,1); Theta = Theta{1};
% figure
% imshow(Theta,[])
