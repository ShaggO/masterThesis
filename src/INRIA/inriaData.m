classdef inriaData < handle

properties
    posTrain        = [];
    negTrainCutouts = [];
    negTrainFull    = [];
    posTest         = [];
    negTestCutouts  = [];
    negTestFull     = [];
    nWindows        = 10;
    seed            = 10^5;
    paths
end

methods
    function obj = inriaData(nWindows,seed)
        if nargin == 2
            obj.nWindows = nWindows;
            obj.seed = seed;
        end
        obj.paths = load('paths');
    end

    function images = loadCache(obj,type)
        if strcmp(type,'all')
            obj.loadCache('posTrain');
%             obj.loadCache('negTrainCutouts');
            obj.loadCache('negTrainFull');
            obj.loadCache('posTest');
%             obj.loadCache('negTestCutouts');
            obj.loadCache('negTestFull');
        else
            if ~isempty(obj.(type))
                % Already loaded. Do nothing
                return
            end

            switch type
                case 'posTrain'
                    imgPath = [obj.paths.inriaDataSet '/inriaPosTrain'];
                case 'negTrainCutouts'
                    imgPath = [obj.paths.inriaDataSet '/inriaNegTrainFull'];
                    type = 'negTrainFull';
%                     imgPath = [obj.paths.inriaDataSet '/inriaNegTrainCutouts' obj.pathSuffix];
                case 'negTrainFull'
                    imgPath = [obj.paths.inriaDataSet '/inriaNegTrainFull'];
                case 'posTest'
                    imgPath = [obj.paths.inriaDataSet '/inriaPosTest'];
                case 'negTestCutouts'
                    imgPath = [obj.paths.inriaDataSet '/inriaNegTestFull'];
                    type = 'negTestFull';
%                     imgPath = [obj.paths.inriaDataSet '/inriaNegTestCutouts' obj.pathSuffix];
                case 'negTestFull'
                    imgPath = [obj.paths.inriaDataSet '/inriaNegTestFull'];
                otherwise
                    error(['Invalid cache type: ' type]);
            end
            data = load(imgPath);
            obj.(type) = data.images;
            images = data.images;
        end
    end

    function [L,D,X] = getDescriptors(obj,method,desSave,type,index,runInParallel)
        if nargin < 5
            index = 'all';
        end
        if nargin < 6
            runInParallel = false;
        end
        
        % workaround incoming!
        if ismember(type,{'negTrainCutouts','negTestCutouts'})
            detArgs = struct(method.detectorArgs{:});
            method.detector = 'randomwindow';
            if ismember('windowSize',fieldnames(detArgs))
                method.detectorArgs = {'n',obj.nWindows,'seed',obj.seed, ...
                    'windowSize',detArgs.windowSize};
            else
                method.detectorArgs = {'n',obj.nWindows,'seed',obj.seed};
            end
        end

        [mFunc, mName] = parseMethod(method);
        desDir = [obj.paths.inriaResults '/' mName];

        if desSave && ~exist(desDir,'dir')
            mkdir(desDir);
        end

        if strcmp(index,'all')
            s = 'all';
        else
            s = sprintf('%.4d',index);
        end

        switch type
            case 'posTrain'
                desPath = [desDir '/DposTrain_' s '.mat'];
                L = 1;
            case 'negTrainCutouts'
                desPath = [desDir '/DnegTrainCutouts_' num2str(obj.nWindows) '_' num2str(obj.seed) '_' s '.mat'];
                type = 'negTrainFull';
                L = -1;
            case 'negTrainFull'
                desPath = [desDir '/DnegTrainFull_' s '.mat'];
                L = -1;
            case 'posTest'
                desPath = [desDir '/DposTest_' s '.mat'];
                L = 1;
            case 'negTestCutouts'
                desPath = [desDir '/DnegTestCutouts' num2str(obj.nWindows) '_' num2str(obj.seed) '_' s '.mat'];
                type = 'negTestFull';
                L = -1;
            case 'negTestFull'
                desPath = [desDir '/DnegTestFull_' s '.mat'];
                L = -1;
        end

        desVars = {'X','D'};
        [loaded,desLoad] = loadIfExist(desPath,'file');
        if loaded && all(ismember(desVars,fieldnames(desLoad)))
            D = desLoad.D;
            disp([num2str(size(D,1)) ' descriptors loaded.']);
        else
            obj.loadCache(type);
            images = obj.(type);
            
            if strcmp(index,'all')
                [X,D] = inriaDescriptors(images,mFunc,runInParallel);
            else
                [X,D] = inriaDescriptors(images(index),mFunc,runInParallel);
            end
            if desSave
                save(desPath,desVars{:})
            end
        end

        L = repmat(L,size(D,1),1);
    end

end

end
