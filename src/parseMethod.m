function [mFunc, mName] = parseMethod(m)
% Parses a method struct into a descriptor function and directory name

%% Parse detector arguments
p = inputParser;
switch m.detector
    case 'vl'
        methods = {'DoG','Hessian','HessianLaplace','HarrisLaplace',...
            'MultiscaleHessian','MultiscaleHarris'};
        addParameter(p,'Method',methods{1},okArg(methods));
        addParameter(p,'PeakThreshold',0);
        addParameter(p,'EdgeThreshold',Inf);
        r = parseResults(p,m.detectorArgs);

        detName = sprintf('%s-%s-%s',lower(r.Method), ...
            num2str(r.PeakThreshold),num2str(r.EdgeThreshold));
        detFunc = @(I) vl_covdet(single(rgb2gray(I)),m.detectorArgs{:})';
    case ''
        detName = '';
    otherwise
        error('Unrecognized detector!')
end

%% Parse descriptor arguments
p = inputParser;
addParameter(p,'debug',0);
switch m.descriptor
    case 'sift'
        colours = {'gray','rgb bin','rgb','opponent','gaussian opponent', ...
            'invariant','normal'};
        addOptional(p,'colour',colours{1},okArg(colours));
        r = parseResults(p,m.descriptorArgs);

        desName = ['sift-' r.colour];
        desFunc = @(I,F) getSiftDescriptors(I,F,r.colour,r.debug);
    case 'k-jet'
        domains = {'auto','spatial','fourier'};
        addParameter(p,'k',1);
        addParameter(p,'sigma',1);
        addOptional(p,'domain',domains{1},...
            @(x) any(validatestring(x,domains)));
        r = parseResults(p,m.descriptorArgs);

        desName = [num2str(r.k) '-jet-' num2str(r.sigma)];
        desFunc = @(I,F) getKJetDescriptors(I,F,r.k,r.sigma,r.domain);
    otherwise
        error('Unrecognized descriptor!')
end

%% Combine names and functions
if isempty(detName)
    mName = desName;
    mFunc = desFunc;
else
    mName = [detName '_' desName];
    mFunc = @(I) desFunc(I,detFunc(I));
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
