function S = dGaussScaleSpace(I, m, n, sigma)
%SCALESPACE Gaussian derivative scale space
% Input:
%   I       image
%   m       x derivative powers [i]
%   n       y derivative powers [i]
%   sigma   vector of scales    [1,j]
% Output:
%   S       scale space images  {i,j}[:,:]

S = cell(numel(m),numel(sigma));
for j = 1:numel(sigma)
    hsize = ceil(6*sigma(j));
    for i = 1:numel(m)
        J = imfilter(I,dGauss2d(m(i),n(i),hsize,sigma(j)), ...
            'replicate','conv');
        S{i,j} = imresize(J,1/sigma(j));
    end
end

% % Resize first?
% S = cell(numel(sigma),1);
% for i = 1:numel(sigma)
%     J = imresize(I,1/sigma(i));
%     S{i} = imfilter(J,f,'replicate','conv');
% end

end

