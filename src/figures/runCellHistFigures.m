clc, clear all

load('cellHistExample')

S = {L(1:3:end).none};
I = visualizeScaleSpaces(S,1); % todo: draw features

figure
imshow(I,[0 1])