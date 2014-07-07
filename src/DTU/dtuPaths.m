function [imNumKey,liNumKey,imNum,liNum,pathNames,pathLabels,pathXlabel] = dtuPaths(type)
%DTUPATHS Returns the 4 arcs and 2 light path indices for the DTU dataset
if nargin < 1
    type = 'test';
end

pathNames = {...
    'Arc 1',...
    'Arc 2',...
    'Arc 3',...
    'Linear path',...
    'Light path x',...
    'Light path z'...
};

imNumKey = 25;
liNumKey = 0;
pathLabels = {};
pathXlabel = {};

switch type
    case 'test'
        % Arc 1 [1:24 26:49]
        %imNum{1} = [1 12 24 26 38 49];
        imNum{1} = [1:24 26:49];
        pathLabels{1} = linspace(-40,40,numel(imNum{1})+1);
        pathLabels{1} = pathLabels{1}([1:24,26:end]);
        pathXlabel{1} = 'Angle (degrees)';
        % Arc 2 [65:94]
        %imNum{2} = [65 70 75 84 89 94];
        imNum{2} = 65:94;
        pathLabels{2} = linspace(-25,25,numel(imNum{2}));
        pathXlabel{2} = 'Angle (degrees)';
        % Arc 3 [95:119]
        %imNum{3} = [95 99 103 111 115 119];
        imNum{3} = 95:119;
        pathLabels{3} = linspace(-20,20,numel(imNum{3}));
        pathXlabel{3} = 'Angle (degrees)';
        % Linear [50:64]
        %imNum{4} = [50 54 57 60 64];
        imNum{4} = 50:64;
        pathLabels{4} = linspace(50,80,numel(imNum{4}));
        pathXlabel{4} = 'Distance (cm)';
        % Light path x [12 25 60 87]
        %imNum{5} = [12 87];
        imNum{5} = [12 60 87];
        pathXlabel{5} = 'Direction number';
        % Light path z [12 25 60 87]
        %imNum{6} = [12 87];
        imNum{6} = [12 60 87];
        pathXlabel{6} = 'Direction number';

        liNum = {0,...
                 0,...
                 0,...
                 0,...
                 20:28,... % [20:28]
                 29:35}; % [29:35]

        pathLabels{5} = 1:numel(liNum{5});
        pathLabels{6} = (1:numel(liNum{6}))+numel(liNum{5});
    case 'train'
        % 21 train images in total (+keyframe)
        imNum = {...
            [1 12 38 49],...
            [65 94],...
            [95 119],...
            [50 57 64],...
            [12 87],...
            [12 87]...
        };

        liNum = {...
            0,...
            0,...
            0,...
            0,...
            [20 24 28],...
            [29 35]...
        };
end

end

