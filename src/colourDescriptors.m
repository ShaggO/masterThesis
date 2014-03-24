function colourDesFunc = colourDescriptors(desFunc,colour)
%COLOURDESCRIPTORS desFunc assumes double precision RGB image input
% between 0 and 1

switch colour
    case 'gray'
        colourDesFunc = @(I,F) desFunc(rgb2gray(I),F);
    case 'rgb bin'
        colourDesFunc = @(I,F) desAverage(I,F,desFunc);
    case 'rgb'
        colourDesFunc = @(I,F) desConcat(I,F,desFunc);
    case 'opponent'
        colourDesFunc = @(I,F) ...
            desConcat(colourTransform(I,'opponent'),F,desFunc);
    case 'gaussian opponent'
        colourDesFunc = @(I,F) ...
            desConcat(colourTransform(I,'gaussian opponent'),F,desFunc);
    case 'xyz'
        colourDesFunc = @(I,F) ...
            desConcat(colourTransform(I,'xyz'),F,desFunc);
    case 'perceptual'
        colourDesFunc = @(I,F) ...
            desConcat(colourTransform(I,'perceptual'),F,desFunc);
end
end

function [X,D] = desAverage(I,F,desFunc)
[X,D1] = desFunc(I(:,:,1),F);
[~,D2] = desFunc(I(:,:,2),F);
[~,D3] = desFunc(I(:,:,3),F);
D = (D1 + D2 + D3) / 3;
end

function [X,D] = desConcat(I,F,desFunc)
[X,D1] = desFunc(I(:,:,1),F);
[~,D2] = desFunc(I(:,:,2),F);
[~,D3] = desFunc(I(:,:,3),F);
D = [D1 D2 D3];
end
