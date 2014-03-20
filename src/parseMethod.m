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
        addParameter(p,'EdgeThreshold',Inf);
        r = parseResults(p,m.detectorArgs);

        detName = sprintf('vl-%s-%s-%s',lower(r.Method), ...
            num2str(r.PeakThreshold),num2str(r.EdgeThreshold));
        detFunc = @(I) vl_covdet(255*rgb2gray(im2single(I)),m.detectorArgs{:})';
    case 'dog'
        % Single scale DoG detector
        addParameter(p,'sigma',1);
        addParameter(p,'k',2);
        addParameter(p,'threshold',0);
        r = parseResults(p,m.detectorArgs);
        
        detName = sprintf('dog-%s-%s-%s', ...
            num2str(r.sigma),num2str(r.k),num2str(r.threshold));
        detFunc = @(I) dogBlobDetector(rgb2gray(im2double(I)),r.sigma,r.k,r.threshold);
    case ''
        detName = '';
    otherwise
        error('Unrecognized detector!')
end
detCache = r.cache;

%% Parse descriptor arguments
p = inputParser;
addParameter(p,'cache',1);
addParameter(p,'debug',0);
switch m.descriptor
    case 'sift'
        colours = {'gray','rgb bin','rgb','opponent','gaussian opponent', ...
            'invariant','normal'};
        addOptional(p,'colour',colours{1},okArg(colours));
        r = parseResults(p,m.descriptorArgs);

        desName = ['sift-' r.colour];
        desFunc = @(I,F) siftDescriptors(I,F,r.colour,r.debug);
    case 'k-jet'
        domains = {'auto','spatial','fourier'};
        addParameter(p,'k',1);
        addParameter(p,'sigma',1);
        addOptional(p,'domain',domains{1},okArg(domains));
        r = parseResults(p,m.descriptorArgs);

        desName = [num2str(r.k) '-jet-' num2str(r.sigma)];
        desFunc = @(I,F) kJetDescriptors(I,F,r.k,r.sigma,r.domain);
    case 'cellhist'
        bTypes = {'square','polar','concentric polar'};
        fTypes = {'gaussian','triangle','box'};
        addParameter(p,'contentType','go');
        addParameter(p,'scaleBase',2);
        addParameter(p,'blockType',fTypes{1},okArg(bTypes));
        addParameter(p,'blockSize',[1 1]);
        addParameter(p,'blockSpacing',[1 1]);
        addParameter(p,'spatialType',fTypes{1},okArg(fTypes));
        addParameter(p,'spatialSigma',[3 3]);
        addParameter(p,'binType',fTypes{1},okArg(fTypes));
        addParameter(p,'binSigma',pi/8);
        addParameter(p,'binCount',8);
        r = parseResults(p,m.descriptorArgs);

        desName = sprintf('cellhist-%s-%s-%s-%s,%s-%s,%s-%s-%s,%s-%s-%s-%s',...
                    r.contentType,...
                    num2str(r.scaleBase),...
                    r.blockType,...
                    num2str(r.blockSize(1)),...
                    num2str(r.blockSize(2)),...
                    num2str(r.blockSpacing(1)),...
                    num2str(r.blockSpacing(2)),...
                    r.spatialType,...
                    num2str(r.spatialSigma(1)),...
                    num2str(r.spatialSigma(2)),...
                    r.binType,...
                    num2str(r.binSigma),...
                    num2str(r.binCount));
        desFunc = @(I,F) cellHistDescriptors(I,F,r.contentType,r.scaleBase, ...
            r.blockType,r.blockSize,r.blockSpacing, ...
            r.spatialType,r.spatialSigma,r.binType,r.binSigma,r.binCount);
    otherwise
        error('Unrecognized descriptor!')
end
desCache = r.cache;

%% Combine names and functions
if isempty(detName)
    mName = desName;
    mFunc = desFunc;
else
    mName = [detName '_' desName];
    mFunc = @(I,resDir,imName) methodFunc(I,resDir,imName,detName,desName,detFunc,desFunc,detCache,desCache);
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
% Loading and saving of intermediate results is handled
% in this function.
function [X,D] = methodFunc(I,resDir,imName,detName,desName,detFunc,desFunc,detCache,desCache)
detDir = [resDir '/' detName];
desDir = [detDir '_' desName];
detPath = [detDir '/features_' imName '.mat'];
desPath = [desDir '/descriptors_' imName '.mat'];
if exist(desPath,'file') && desCache
    load(desPath);
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
end

end
