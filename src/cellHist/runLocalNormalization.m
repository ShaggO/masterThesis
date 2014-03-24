clc, clear all

M = ones(16,1);
C = createCellOffsets('square',[4 4],[1 1]);
L = createCellOffsets('square',[4 4],[1 1]);

Mnorm = localNormalization(M,C,L,'gaussian',[2 2]);
reshape(Mnorm,[4 4])