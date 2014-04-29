function [mFunc, mName] = parseMethod(m)
%PARSEMETHOD Parses a method struct into a combined detector and
%descriptor function and unique name. We assume original RGB image inputs.

%% Parse detector arguments
p = inputParser;
addParameter(p,'cache',1);
switch lower(m.detector)
    case 'vl'
        methods = {'DoG','Hessian','HessianLaplace','HarrisLaplace',...
            'MultiscaleHessian','MultiscaleHarris'};
        addParameter(p,'Method',methods{1},okArg(methods));
        addParameter(p,'PeakThreshold',0)
        addParameter(p,'EdgeThreshold',10)
        addParameter(p,'OctaveResolution',3)
        r = parseResults(p,m.detectorArgs);

        detName = sprintf('vl-%s-%s-%s-%s',lower(r.Method), ...
            num2str(r.PeakThreshold),num2str(r.EdgeThreshold), ...
            num2str(r.OctaveResolution));
        detFunc = @(I) vlDetector(I,...
            'Method',r.Method,...
            'PeakThreshold',r.PeakThreshold,...
            'EdgeThreshold',r.EdgeThreshold,...
            'OctaveResolution',r.OctaveResolution)';
    case 'cvtbrisk'
        addParameter(p,'MinContrast',0.2);
        addParameter(p,'MinQuality',0.1);
        addParameter(p,'NumOctaves',4);
        r = parseResults(p,m.detectorArgs);

        detName = sprintf(['cvtbrisk' repmat('-%s',[1 3])],...
            num2str(r.MinContrast),...
            num2str(r.MinQuality),...
            num2str(r.NumOctaves));
        detFunc = @(I) cvtDetector(I,'brisk',...
            'MinContrast',r.MinContrast,...
            'MinQuality',r.MinQuality,...
            'NumOctaves',r.NumOctaves);
    case 'cvtmser'
        addParameter(p,'ThresholdDelta',2)
        addParameter(p,'RegionAreaRange',[30 14000])
        addParameter(p,'MaxAreaVariation',0.25)
        r = parseResults(p,m.detectorArgs);

        detName = sprintf(['cvtmser' repmat('-%s',[1 3])],...
            num2str(r.ThresholdDelta),...
            nums2str(r.RegionAreaRange),...
            num2str(r.MaxAreaVariation));
        detFunc = @(I) cvtDetector(I,'mser',...
            'ThresholdDelta',r.ThresholdDelta,...
            'RegionAreaRange',r.RegionAreaRange,...
            'MaxAreaVariation',r.MaxAreaVariation);
    case 'cvtsurf'
        addParameter(p,'MetricThreshold',1000.0)
        addParameter(p,'NumOctaves',3)
        addParameter(p,'NumScaleLevels',4)
        r = parseResults(p,m.detectorArgs);

        detName = sprintf(['cvtsurf' repmat('-%s',[1 3])],...
            num2str(r.MetricThreshold),...
            num2str(r.NumOctaves),...
            num2str(r.NumScaleLevels));
        detFunc = @(I) cvtDetector(I,'surf',...
            'MetricThreshold',r.MetricThreshold,...
            'NumOctaves',r.NumOctaves,...
            'NumScaleLevels',r.NumScaleLevels);
    case 'dog'
        % Single scale DoG detector
        addParameter(p,'sigma',1);
        addParameter(p,'k',2);
        addParameter(p,'threshold',0);
        r = parseResults(p,m.detectorArgs);

        detName = sprintf('dog-%s-%s-%s', ...
            num2str(r.sigma),num2str(r.k),num2str(r.threshold));
        detFunc = @(I) dogBlobDetector(I,r.sigma,r.k,r.threshold);
    case ''
        r.cache = false;
        detName = '';
        detFunc = false;
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
switch lower(m.descriptor)
    case 'none'
        r = parseResults(p,m.descriptorArgs);
        desName = 'none';
        desFunc = @(I,F) deal(F(:,1:2),zeros(size(F,1),1));
    case 'sift'
        r = parseResults(p,m.descriptorArgs);
        desName = ['sift-' r.colour];
        desFunc = @(I,F) siftDescriptor(I,F);
    case 'full-sift'
        addParameter(p,'PeakThresh',0)
        addParameter(p,'EdgeThresh',10)
        addParameter(p,'NormThresh',0)
        addParameter(p,'Magnif',3)
        addParameter(p,'WindowSize',2)
        r = parseResults(p,m.descriptorArgs);
        desName = sprintf(['full-sift' repmat('-%s',[1 5])],...
            num2str(r.PeakThresh),...
            num2str(r.EdgeThresh),...
            num2str(r.NormThresh),...
            num2str(r.Magnif),...
            num2str(r.WindowSize));
        desFunc = @(I) fullSiftDescriptor(I,...
            'PeakThresh',r.PeakThresh,...
            'EdgeThresh',r.EdgeThresh,...
            'NormThresh',r.NormThresh,...
            'Magnif',r.Magnif,...
            'WindowSize',r.WindowSize);
    case 'k-jet'
        domains = {'auto','spatial','fourier'};
        addParameter(p,'k',1);
        addParameter(p,'sigma',1);
        addOptional(p,'domain',domains{1},okArg(domains));
        r = parseResults(p,m.descriptorArgs);
        desName = [num2str(r.k) '-jet-' r.colour '-' num2str(r.sigma)];
        desFunc = @(I,F) kJetDescriptors(I,F,r.k,r.sigma,r.domain);
    case 'cvtbrisk'
        r = parseResults(p,m.descriptorArgs);
        desName = ['cvtbrisk-' r.colour];
        desFunc = @(I,F) cvtDescriptor(I,F,'brisk');
    case 'cvtfreak'
        r = parseResults(p,m.descriptorArgs);
        desName = ['cvtfreak-' r.colour];
        desFunc = @(I,F) cvtDescriptor(I,F,'freak');
    case 'cvtsurf'
        addParameter(p,'SURFSize',64);
        r = parseResults(p,m.descriptorArgs);
        desName = ['cvtsurf-' r.colour '-' num2str(r.SURFSize)];
        desFunc = @(I,F) cvtDescriptor(I,F,'surf','SURFSize',r.SURFSize);
    case 'cvtblock'
        addParameter(p,'BlockSize',11);
        r = parseResults(p,m.descriptorArgs);
        desName = ['cvtblock-' r.colour '-' num2str(r.BlockSize)];
        desFunc = @(I,F) cvtDescriptor(I,F,'block','BlockSize',r.BlockSize);
    case 'cellhist'
        bTypes = {'square','polar','polar central', ...
            'concentric polar','concentric polar central'};
        fTypes = {'gaussian','triangle','box'};
        fTypesCenter = [fTypes {'none'}];
        fTypesCell = [fTypes {'polar gaussian'}];
        nTypes = {'cell','block','pixel','none'};
        addParameter(p,'contentType','go');
        addParameter(p,'magnitudeType','m');
        addParameter(p,'scaleBase',2^(1/3));
        addParameter(p,'scaleOffset',0.5);
        addParameter(p,'rescale',1);
        addParameter(p,'gridType',bTypes{1},okArg(bTypes));
        addParameter(p,'gridSize',[1 1]);
        addParameter(p,'gridRadius',[3 3]);
        addParameter(p,'centerFilter','box',okArg(fTypesCenter));
        addParameter(p,'centerSigma',[Inf Inf]);
        addParameter(p,'cellFilter',fTypes{1},okArg(fTypesCell));
        addParameter(p,'cellSigma',[1 1]);
        addParameter(p,'normType',nTypes{1},okArg(nTypes));
        addParameter(p,'normFilter',fTypes{1},okArg(fTypes));
        addParameter(p,'normSigma',[2 2]);
        addParameter(p,'binFilter',fTypes{1},okArg(fTypes));
        addParameter(p,'binSigma',1);
        addParameter(p,'binCount',8);
        addParameter(p,'cellNormStrategy',3);
        r = parseResults(p,m.descriptorArgs);

        if (strcmp(r.normType,'cell') || strcmp(r.normType,'none')) && ...
                any(r.cellNormStrategy == 0:1)
            r.normFilter = fTypes{1};
            r.normSigma = [3 3];
            normString = r.normType;
        else
            normString = [r.normType '-' r.normFilter '-' ...
                nums2str(r.normSigma) '-' num2str(r.cellNormStrategy)];
        end

        desName = sprintf(['cellhist' repmat('-%s',[1 17])],...
            r.colour,...
            r.contentType,...
            r.magnitudeType,...
            num2str(r.scaleBase),...
            num2str(r.scaleOffset),...
            num2str(r.rescale),...
            r.gridType,...
            nums2str(r.gridSize),...
            nums2str(r.gridRadius),...
            r.centerFilter,...
            nums2str(r.centerSigma),...
            r.cellFilter,...
            nums2str(r.cellSigma),...
            normString,...
            r.binFilter,...
            nums2str(r.binSigma),...
            nums2str(r.binCount));
        desFunc = @(I,F) cellHistDescriptors(I,F,r.contentType,r.magnitudeType,...
            r.scaleBase,r.scaleOffset,r.rescale,r.gridType,r.gridSize,r.gridRadius,...
            r.centerFilter,r.centerSigma,r.cellFilter,r.cellSigma,...
            r.normType,r.normFilter,r.normSigma,r.binFilter,r.binSigma,r.binCount,...
            r.cellNormStrategy);
    otherwise
        error('Unrecognized descriptor!')
end
if ~isempty(detName)
    desFunc = colourDescriptors(desFunc,r.colour);
end
desCache = r.cache;

%% Combine names and functions
mName = combineNames(detName,desName);
mFunc = @(I,resDir,imName,desSave) methodFunc(I,resDir,imName,...
        detName,desName,detFunc,desFunc,detCache,desCache,desSave);

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
function [X,D] = methodFunc(I,resDir,imName,detName,desName,...
    detFunc,desFunc,detCache,desCache,desSave)
detDir = [resDir '/' detName];
desDir = [resDir '/' combineNames(detName,desName)];
detPath = [detDir '/features_' imName];
desPath = [desDir '/descriptors_' imName];

loaded = false;
if desCache
    [loaded, des] = loadIfExist(desPath,'file');
end

if loaded && all(ismember({'X' 'D'},fieldnames(des)))
    X = des.X;
    D = des.D;
    disp(['Loaded ' num2str(size(D,1)) ' ' num2str(size(D,2)) '-dimensional descriptors.'])
else
    if isempty(detName) % check if the detector should be used
        [X,D] = desFunc(I);
    else
        loaded = false;
        if detCache
            [loaded, det] = loadIfExist(detPath,'file');
        end
        if loaded && ismember('F',fieldnames(det))
            F = det.F;
            disp(['Loaded ' num2str(size(F,1)) ' features.']);
        else
            F = detFunc(rgb2gray(I));

            if ~exist(detDir,'dir')
                mkdir(detDir);
            end
            save(detPath,'F');
            disp(['Detected ' num2str(size(F,1)) ' features.']);
        end

        assert(size(F,1) <= 10000, 'Too many features.')

        [X,D] = desFunc(I,F);
    end
    assert(~any(isnan(D(:))),'NaN present in descriptor.');

    if ~exist(desDir,'dir')
        mkdir(desDir);
    end
    if desSave
        save(desPath,'X','D');
    end

    disp(['Computed ' num2str(size(D,1)) ' ' num2str(size(D,2)) '-dimensional descriptors.'])
end

end

function name = combineNames(detName,desName)
if isempty(detName)
    name = desName;
else
    name = [detName '_' desName];
end
end
