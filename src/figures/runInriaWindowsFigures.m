clc, clear all

idxTP = [1 3 4 5 8 11 13 15 17 19];
idxFN = [1 3 4 5 6 7 13 15 16 18];
idxTN = [1 2 4 5 7 8 9 16 17 23];
idxFP = [1 4 7 8 10 14 20 21 22 23];
idxEP = [4 29 76 154 320 441 498 567 624 811];
idxEN = [1 42 50 105 160];

test = load('results/inriaTestSvmGoSiFinal'); % settings

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
IexampleNeg = {neg(idxEN).image};

%% Concatenate
border = 255*ones(134,5,3,'uint8');
truePos = cell2mat(interweave(ItruePos,repmat({border},1,numel(idxTP)-1)));
falseNeg = cell2mat(interweave(IfalseNeg,repmat({border},1,numel(idxFN)-1)));
trueNeg = cell2mat(interweave(ItrueNeg,repmat({border},1,numel(idxTN)-1)));
falsePos = cell2mat(interweave(IfalsePos,repmat({border},1,numel(idxFP)-1)));
examplePos = cell2mat(interweave(IexamplePos,repmat({border},1,numel(idxEP)-1)));
border = 255*ones(240,10,3,'uint8');
exampleNeg = cell2mat(interweave(IexampleNeg,repmat({border},1,numel(idxEN)-1)));

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