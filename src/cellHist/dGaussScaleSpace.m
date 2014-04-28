function [L,Isizes] = dGaussScaleSpace(I, d, scales, rescale, chain, pixelDiff)
%SCALESPACE Gaussian derivative scale space
% Input:
%   I           image
%   d(:,1)      x derivative powers [i]
%   d(:,2)      y derivative powers [i]
%   scales      vector of scales    [1,j]
%   rescale     if >0, rescale according to this scale
% Output:
%   S           scale space images  [j].i[:,:]
%   sizes       size of each image  [j,2]

if nargin < 5
    chain = 1;
    pixelDiff = 1;
end

% attempt to load scale spaces
hash = num2str(imageHash(I(:)));
load('paths.mat')
sPath = [dtuResults '/scaleSpaces/' hash '.mat'];
[loaded,file] = loadIfExist(sPath,'file');
if loaded
    [b,idx] = ismember(round(100*scales),round(100*file.scales));
    if ~all(b)
        disp('Incompatible scale space file. (all scales not present)')
    	disp('Needed:');
    	disp(scales);
    	disp('Present:');
    	disp(file.scales);
    elseif rescale ~= file.rescale
    	disp('Incompatible scale space file. (rescale not equal)');
    	disp(['Input rescale: ' num2str(rescale) ', file rescale: ' num2str(file.rescale)]);
    elseif ~all(ismember(d,file.d,'rows'))
        disp('Incompatible scale space file. (all derivatives not present)');
        disp('Needed:');
        disp(d);
        disp('Present:');
        disp(file.d);
    else
        disp('Loaded scale space file.')
        L = file.S(idx);
        Isizes = file.Isizes(idx,:);
        return
    end
end

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
temp = {cell(numel(scales),1)};
structArgs = interweave(fd,repmat(temp,[size(d,1) 1]));
L = struct(structArgs{:});
Isizes = zeros([numel(scales) 2]);

if chain
    if pixelDiff
        % chain gauss filters and derive by pixel differencing iteratively
        for j = 1:numel(scales)
            if j == 1
                s = scales(j);
            else
                s = sqrt(scales(j)^2 - scales(j-1)^2);
            end
            hsize = 2*ceil(3*s)+1;
            I = imfilter(I,dGauss2d(0,0,hsize,s),'conv');
            for i = 1:size(d,1)
                if all(d(i,:) == 0)
                    dI = I;
                else
                    dI = imfilter(I,-d2d(d(i,1),d(i,2)),'conv');
                end
                if rescale > 0
                    L(j).(fd{i}) = imresize(dI,rescale/scales(j));
                else
                    L(j).(fd{i}) = dI;
                end
            end
            Isizes(j,:) = size(L(j).(fd{1}));
        end
    else
        % derive gauss filters and chain gausses iteratively
        for i = 1:size(d,1)
            Ii = I;
            for j = 1:numel(scales)
                if j == 1
                    s = scales(j);
                    m = d(i,1); n = d(i,2);
                else
                    s = sqrt(scales(j)^2 - scales(j-1)^2);
                    m = 0; n = 0;
                end
                hsize = 2*ceil(3*s)+1;
                Ii = imfilter(Ii,dGauss2d(m,n,hsize,s),'conv');
                if rescale > 0
                    L(j).(fd{i}) = imresize(Ii,rescale/scales(j));
                else
                    L(j).(fd{i}) = Ii;
                end
                Isizes(j,:) = size(L(j).(fd{1}));
            end
        end
    end
else
    % old code
    for j = 1:numel(scales)
        hsize = 2*ceil(3*scales(j))+1;
        for i = 1:size(d,1)
            L(j).(fd{i}) = imfilter(I,dGauss2d(d(i,1),d(i,2),hsize,scales(j)), ...
                'conv');
            if rescale > 0
                L(j).(fd{i}) = imresize(L(j).(fd{i}),rescale/scales(j));
            end
        end
        Isizes(j,:) = size(L(j).(fd{1}));
    end
end

% % Resize first?
% S = cell(numel(sigma),1);
% for i = 1:numel(sigma)
%     J = imresize(I,1/sigma(i));
%     S{i} = imfilter(J,f,'replicate','conv');
% end

end
