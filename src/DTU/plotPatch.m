function plotPatch(I,P,pSize,color)
% Plot patch on current figure
% Inputs
%   I       Image to extract patch from
%   P       Center of patch
%   pSize   Patch size
%   color   Color for marking the patch center

% Compute cut out offsets and coordinates
offsetMin = -floor(pSize/2);
offsetMax = offsetMin + pSize;
cutoutX = max(floor(P(1)) + offsetMin(1),1) : min(floor(P(1)) + offsetMax(1),size(I,2));
cutoutY = max(floor(P(2)) + offsetMin(2),1) : min(floor(P(2)) + offsetMax(2),size(I,1));

% compute point coordinates in cut out
Pnew = -offsetMin + (P - floor(P))

% Correct when upper and/or left part is thresholdet to be within the image
Pnew = Pnew - ([cutoutX(end) cutoutY(end)]-1 < pSize) .* (pSize - [cutoutX(end) cutoutY(end)]+1);

% Show image and point
imshow(I(cutoutY,cutoutX,:));
hold on;
plot(Pnew(1)+1,Pnew(2)+1,['x' color],'MarkerSize',15);

end
