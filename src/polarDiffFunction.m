function V = polarDiffFunction(f,P1,P2,maximize)
%POLARDIST Applies a function to the angular and radial distance between
%polar points
% Input:
%   f           function
%   P1          [:,2,...]
%   P2          [:,2,...]
%   maximize    0 = min, 1 = max

D1 = abs(P2-P1);
D1(:,1,:) = min(D1(:,1,:), 2*pi - D1(:,1,:));
D2 = zeros(size(P1));
D2(:,2,:) = P1(:,2,:)+P2(:,2,:);

if maximize
    V = max(f(D1),f(D2));
else
    V = min(f(D1),f(D2));
end

end