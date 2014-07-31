clc, clear all;

load('results/inriaConstantHard.mat')
nHard = [0 1 2 5 10 20 35 50 75 100] * 10^3;
nHard = [{[]},mat2cell(nHard,1,ones(1,numel(nHard)))];
colours = {'r-','g-','b-','k-','m-'};

figure
set(gcf,'color','white');
PRAUC
for i = 1:size(PRAUC,2)
    PRAUCi = PRAUC(~isnan(PRAUC(:,i)),i);
    nHardi = nHard(~isnan(PRAUC(:,i)));
    % Automatic point
    autoMask = cellfun(@isempty,nHard);
    if any(autoMask)
        nHardi{autoMask} = nHardAuto(i);
    end
    [nHardi,sIdx] = sort(cell2mat(nHardi))
    PRAUCi = PRAUCi(sIdx);

    plot(nHardi',PRAUCi,colours{i});
    hold on
    if any(autoMask)
        plot(nHardi(autoMask(sIdx)),PRAUCi(autoMask(sIdx)),[colours{i} 'x']);
    end
end
%axis([0 8*10^4 0.5 1])
xlabel('Amount of hard negatives added for re-training');
ylabel('PR AUC');
name = {'Go','Si','GoSi','HOG'};
legend(name,'location','southeast')
export_fig('../report/img/inriaConstantHard.pdf','-r300');
