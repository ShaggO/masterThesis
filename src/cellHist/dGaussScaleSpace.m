function S = dGaussScaleSpace(I, d, sigma, rescale)
%SCALESPACE Gaussian derivative scale space
% Input:
%   I           image
%   d(:,1)      x derivative powers [i]
%   d(:,2)      y derivative powers [i]
%   sigma       vector of scales    [1,j]
%   rescale     if >0, rescale according to this scale
% Output:
%   S       scale space images  {i,j}[:,:]

% compute fieldnames
fd = cell(size(d,1),1);
for i = 1:size(d,1)
    if d(i,1) == 0 && d(i,2) == 0
        fd{i} = 'none';
    else
        fd{i} = [repmat('x',[1 d(i,1)]) repmat('y',[1 d(i,2)])];
    end
end
% Initialize structure of derivatives
temp = {cell(numel(sigma),1)};
structArgs = interweave(fd,repmat(temp,[size(d,1) 1]));
S = struct(structArgs{:});

for j = 1:numel(sigma)
    hsize = ceil(6*sigma(j));
    for i = 1:size(d,1)
        S(j).(fd{i}) = imfilter(I,dGauss2d(d(i,1),d(i,2),hsize,sigma(j)), ...
            'replicate','conv');
        if rescale > 0
            S(j).(fd{i}) = imresize(S(j).(fd{i}),rescale/sigma(j));
        end
    end
end

% % Resize first?
% S = cell(numel(sigma),1);
% for i = 1:numel(sigma)
%     J = imresize(I,1/sigma(i));
%     S{i} = imfilter(J,f,'replicate','conv');
% end

end

