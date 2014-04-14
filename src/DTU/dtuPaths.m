function [imNumKey,liNumKey,imNum,liNum,pathLabels] = dtuPaths()
%DTUPATHS Returns the 4 arcs and 2 light path indices for the DTU dataset

pathLabels = {...
    'Arc 1',...
    'Arc 2',...
    'Arc 3',...
    'Linear path',...
    'Light path x',...
    'Light path z'...
};

imNumKey = 25;
liNumKey = 0;
% Arc 1 [1:24 26:49]
imNum{1} = [1 12 24 26 38 49];
% Arc 2 [65:94]
imNum{2} = [65 70 75 84 89 94];
% Arc 3 [95:119]
imNum{3} = [95 99 103 111 115 119];
% Linear [50:64]
imNum{4} = [50 54 57 60 64];
% Light path x [12 25 60 87]
imNum{5} = [12 87];
% Light path z [12 25 60 87]
imNum{6} = [12 87];

liNum = {0,...
         0,...
         0,...
         0,...
         20:2:28,... % [20:28]
         29:2:35}; % [29:35]
%{
imNum{1} = [1 12];
imNum{5} = [12 25 60];
liNum{5} = [20 21];
%}

end

