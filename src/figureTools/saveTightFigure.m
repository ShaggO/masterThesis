function saveTightFigure(H,file,crop)
%SAVETIGHTFIGURE save the figure as file
% Inputs:
%   H       Figure handle
%   file    Filename of output file

if nargin<3
    crop = [0 0 0 0];
end

set(0,'currentfigure',H);

if strcmp(get(gca,'Visible'),'on')
    set(gca,'units','centimeters');
    pos = get(gca,'Position');
    ti = get(gca,'TightInset');
else
    set(gca,'units','normalized');
    set(gca,'position',[0 0 1 1]);
    ti = [0 0 0 0];
    set(gca,'units','centimeters');
    pos = get(gca,'Position');
end

ti = ti + crop;
set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

saveas(gcf,file);

end