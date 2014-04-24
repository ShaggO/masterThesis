function P = scaleSpaceFeatures(F, scales, rescale)
%SCALESPACEFEATURES Computes the scale space coordinates, index, and
%relative size of given features

if size(F,1) == 0
    P = zeros(0,4);
    return
end

% Find closest scale for each feature
[~,P(:,3)] = min(abs(repmat(log(scales),[size(F,1) 1]) - ...
    repmat(log(F(:,3)),[1 size(scales,2)])),[],2);
Pscale = scales(P(:,3));

if rescale > 0
    P(:,1:2) = (F(:,1:2)-1) * rescale ./ repmat(Pscale(:),[1 2]) + 1;
    P(:,4) = 1;
else
    P(:,1:2) = F(:,1:2);
    P(:,4) = Pscale;
end
    
end

