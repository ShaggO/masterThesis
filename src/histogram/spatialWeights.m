function w = spatialWeights(coords,mu,type,sigma)
% SPATIALWEIGHTS Compute spatial weights using given weighting function
% Inputs:
%   coords  Spatial coordinates. One column per dimension one row per coodinate
%   mu      Center of weighting filter
%   type    Type of weighting filter
%   sigma   Sigma/width of filter

[f,~] = ndFilter(type,sigma);
w = f(abs(coords-repmat(mu, [size(coords,1) 1])));

end
