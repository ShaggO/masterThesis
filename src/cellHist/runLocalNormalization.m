clc, clear all

H = rand(8,1,16,1);
% H(:,1,1,1) = 0.1;
C = createCellOffsets('square',[4 4],[1 1]);
L = createCellOffsets('square',[3 3],[1 1]);

Hnorm = localNormalization(H,C,L,'box',[2 2]);
reshape(sum(Hnorm,1),[4 4 1])
sum(Hnorm(:))