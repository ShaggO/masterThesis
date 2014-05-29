function [L,Isizes] = dGaussScaleSpace(I,d,scales,rescale,smooth)
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
Isizes = zeros([numel(scales) 2],'single');

% chain gauss filters and derive by pixel differencing iteratively
for j = 1:numel(scales)
    if smooth
        if j == 1
            s = scales(j);
        else
            s = sqrt(scales(j)^2 - scales(j-1)^2);
        end
        hsize = 2*ceil(3*s)+1;
        filter = dGauss2d(0,0,double(hsize),double(s));
        I = imfilter(I,filter,'conv');
        % I = conv2(I,filter,'same');
    end
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

end