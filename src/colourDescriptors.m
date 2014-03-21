function colourDesFunc = colourDescriptors(desFunc,colour)
%COLOURDESCRIPTORS desFunc assumes double precision RGB image input
% between 0 and 1

switch colour
    case 'gray'
        colourDesFunc = @(I,F) desFunc(rgb2gray(I),F);
    otherwise
        switch colour
            case 'rgb bin'
                colourDesFunc = @(I,F) rgbBin(I,F,desFunc);
            case 'rgb'
                colourDesFunc = @(I,F) rgb(I,F,desFunc);
            case 'opponent'
                colourDesFunc = @(I,F) opponent(I,F,desFunc);
            case 'gaussian opponent'
                colourDesFunc = @(I,F) gaussianOpponent(I,F,desFunc);
        end
end
end

function [X,D] = rgbBin(I,F,desFunc)
[X,DR] = desFunc(I(:,:,1),F);
[~,DG] = desFunc(I(:,:,2),F);
[~,DB] = desFunc(I(:,:,3),F);
D = (DR + DG + DB) / 3;
end

function [X,D] = rgb(I,F,desFunc)
[X,DR] = desFunc(I(:,:,1),F);
[~,DG] = desFunc(I(:,:,2),F);
[~,DB] = desFunc(I(:,:,3),F);
D = [DR DG DB];
end

function [X,D] = opponent(I,F,desFunc)
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
[X,DR] = desFunc((R-G)/sqrt(2),F);
[~,DG] = desFunc((R+G-2*B)/sqrt(6),F);
[~,DB] = desFunc((R+G+B)/sqrt(3),F);
D = [DR DG DB];
end

function [X,D] = gaussianOpponent(I,F,desFunc)
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
[X,DR] = desFunc(0.06 * R + 0.63 * G + 0.27 * B,F);
[~,DG] = desFunc(0.30 * R + 0.04 * G - 0.35 * B,F);
[~,DB] = desFunc(0.34 * R - 0.60 * G + 0.17 * B,F);
D = [DR DG DB];
end
