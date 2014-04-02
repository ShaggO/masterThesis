function [mFunc, mName] = parseMethod(m)
% Parses a method struct into a descriptor function and directory name

%% Parse detector arguments
p = inputParser;
addParameter(p,'cache',1);
switch m.detector
    case 'vl'
        methods = {'DoG','Hessian','HessianLaplace','HarrisLaplace',...
            'MultiscaleHessian','MultiscaleHarris'};
        addParameter(p,'Method',methods{1},okArg(methods));
        addParameter(p,'PeakThreshold',0);
        addParameter(p,'EdgeThreshold',10)
        r = parseResults(p,m.detectorArgs);

        detName = sprintf('vl-%s-%s-%s',lower(r.Method), ...
            num2str(r.PeakThreshold),num2str(r.EdgeThreshold));
        detFunc = @(I) vl_covdet(255*rgb2gray(single(I)),...
            'Method',r.Method,...
            'PeakThreshold',r.PeakThreshold,...
            'EdgeThreshold',r.EdgeThreshold)';
    case 'dog'
        % Single scale DoG detector
        addParameter(p,'sigma',1);
        addParameter(p,'k',2);
        addParameter(p,'threshold',0);
        r = parseResults(p,m.detectorArgs);
        
        detName = sprintf('dog-%s-%s-%s', ...
            num2str(r.sigma),num2str(r.k),num2str(r.threshold));
        detFunc = @(I) dogBlobDetector(rgb2gray(I),r.sigma,r.k,r.threshold);
    case ''
        detName = '';
    otherwise
        error('Unrecognized detector!')
end
detCache = r.cache;

%% Parse descriptor arguments
p = inputParser;
colours = {'gray','rgb bin','rgb','opponent','gaussian opponent', ...
            'c-colour','xyz','perceptual'};
addParameter(p,'cache',1);
addParameter(p,'debug',0);
addParameter(p,'colour',colours{1},okArg(colours));
switch m.descriptor
    case 'sift'
        r = parseResults(p,m.descriptorArgs);

        desName = ['sift-' r.colour];
        desFunc = @(I,F) siftDescriptors(I,F);
    case 'k-jet'
        domains = {'auto','spatial','fourier'};
        addParameter(p,'k',1);
        addParameter(p,'sigma',1);
        addOptional(p,'domain',domains{1},okArg(domains));
        r = parseResults(p,m.descriptorArgs);

        desName = [num2str(r.k) '-jet-' r.colour '-' num2str(r.sigma)];
        desFunc = @(I,F) kJetDescriptors(I,F,r.k,r.sigma,r.domain);
    case 'cellhist'
        bTypes = {'square','polar','concentric polar'};
        fTypes = {'gaussian','triangle','box'};
        addParameter(p,'contentType','go');
        addParameter(p,'magnitudeType','m');
        addParameter(p,'scaleBase',2);
        addParameter(p,'rescale',1);
        addParameter(p,'blockType',fTypes{1},okArg(bTypes));
        addParameter(p,'blockSize',[1 1]);
        addParameter(p,'blockSpacing',[1 1]);
        addParameter(p,'centerType','box',okArg(fTypes));
        addParameter(p,'centerSigma',[Inf Inf]);
        addParameter(p,'cellType',fTypes{1},okArg(fTypes));
        addParameter(p,'cellSigma',[3 3]);
        addParameter(p,'binType',fTypes{1},okArg(fTypes));
        addParameter(p,'binSigma',pi/8);
        addParameter(p,'binCount',8);
        r = parseResults(p,m.descriptorArgs);

        desName = sprintf(['cellhist' repmat('-%s',[1 15])],...
                    r.colour,...
                    r.contentType,...
                    r.magnitudeType,...
                    num2str(r.scaleBase),...
                    num2str(r.rescale),...
                    r.blockType,...
                    nums2str(r.blockSize),...
                    nums2str(r.blockSpacing),...
                    r.centerType,...
                    nums2str(r.centerSigma),...
                    r.cellType,...
                    nums2str(r.cellSigma),...
                    r.binType,...
                    nums2str(r.binSigma),...
                    nums2str(r.binCount));
        desFunc = @(I,F) cellHistDescriptors(I,F,r.contentType,r.magnitudeType,...
            r.scaleBase,r.rescale,r.blockType,r.blockSize,r.blockSpacing,...
            r.centerType,r.centerSigma,r.cellType,r.cellSigma,...
            r.binType,r.binSigma,r.binCount);
    otherwise
        error('Unrecognized descriptor!')
end
desFunc = colourDescriptors(desFunc,r.colour);
desCache = r.cache;

%% Combine names and functions
if isempty(detName)
    mName = desName;
    mFunc = desFunc;
else
    mName = [detName '_' desName];
    mFunc = @(I,resDir,imName) methodFunc(im2single(I),resDir,imName,detName,desName,detFunc,desFunc,detCache,desCache);
end

end

%% Local helper functions

% Test whether string is in set, ignoring case
function func = okArg(set)
func = @(s) any(validatestring(s,set));
end

% Return results of parsing
function r = parseResults(p,args)
parse(p,args{:});
r = p.Results;
end

% Local function that combines detector and descriptor.
% Assumes double precision image input between 0 and 1.
% Loading and saving of intermediate results is handled
% in this function.
function [X,D] = methodFunc(I,resDir,imName,detName,desName,detFunc,desFunc,detCache,desCache)
detDir = [resDir '/' detName];
desDir = [detDir '_' desName];
detPath = [detDir '/features_' imName];
desPath = [desDir '/descriptors_' imName];
if exist(desPath,'file') && desCache
    load(desPath);
    disp(['Loaded ' num2str(size(D,1)) ' ' num2str(size(D,2)) '-dimensional descriptors.'])
else
    if exist(detPath,'file') && detCache
        load(detPath);
        disp(['Loaded ' num2str(size(F,1)) ' features.']);
    else
        F = detFunc(I);

        if ~exist(detDir,'dir')
            mkdir(detDir);
        end
        save(detPath,'F');
        disp(['Detected ' num2str(size(F,1)) ' features.']);
    end

    [X,D] = desFunc(I,F);
    assert(~any(isnan(D(:))),'NaN present in descriptor.');

    if ~exist(desDir,'dir')
        mkdir(desDir);
    end
    save(desPath,'X','D');

    disp(['Computed ' num2str(size(D,1)) ' ' num2str(size(D,2)) '-dimensional descriptors.'])
end

end
