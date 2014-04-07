function F = cvtDetector(I,type,varargin)

switch type
    case 'brisk'
        P = detectBRISKFeatures(I,varargin{:});
        F = double([P.Location P.Scale/6]);
    case 'mser'
        R = detectMSERFeatures(I,varargin{:});
        F = double([R.Location, 1/8 * sqrt(R.Axes(:,1) .* R.Axes(:,2))]);
    case 'surf'
        P = detectSURFFeatures(I,varargin{:});
        F = double([P.Location P.Scale]);
end

end