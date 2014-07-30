clc, clear, close all

names = {'GoFinal','SiFinal','GoSiFinal','GoChosenSmall','HogFinal'};
for i = 1:numel(names)
    load(['results/inriaTestSvm' names{i}])
    
    probPos = sort(probPos);
    probNeg = sort(probNeg);
    
    x = -19:0.25:7;
    yNeg = hist(probNeg,x);
    yNeg = yNeg / sum(yNeg);
    yPos = hist(probPos,x);
    yPos = yPos / sum(yPos);
    
    if i == 1
        height = 3;
    else
        height = 2.5;
    end
    fig('unit','inches','width',12,'height',height,'fontsize',8);
    bar(x,yPos+yNeg,1,'r')
    hold on
    bar(x,yPos,1,'g')
%     axis([probNeg(1000)-0.2 probPos(end)+0.2 0 1.01*max([yPos yNeg])])
    axis([-11 7 0 1.02*max([yPos yNeg])])
    set(gca,'xtick',-20:2:20,'ytick',0:0.05:0.2)
    grid on
    legend('Negative','Positive','location','northwest')
    if i == 1
        xlabel('Classification score s')
    end
    ylabel('Fraction of class')
    
%     [min(probNeg) max(probPos)]
    
    export_fig('-r300',['../report/img/inriaHistogram' names{i} '.pdf']);
end