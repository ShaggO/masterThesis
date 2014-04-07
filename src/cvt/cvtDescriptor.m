function [X,D] = cvtDescriptor(I,F,type,varargin)

P = SURFPoints(F(:,1:2),'Scale',F(:,3));
[D,X] = extractFeatures(I,P,'Method',type,varargin{:});
switch lower(type)
    case 'brisk'
        X = X.Location;
        D = single(D.Features);
    case 'freak'
        X = X.Location;
        D = single(D.Features);
    case 'surf'
        X = X.Location;
    case 'block'
        % already correct format
end

end