clc, clear

load('results/inriaConstantHard.mat')
nHard = [1 2 5 10 20 40 60 80 100] * 10^3;
colours = {'b-','g-','c-','r-','m-'};

figure
set(gcf,'color','white');
for i = 1:size(PRAUC,2)
    plot(nHard',PRAUC(:,i),colours{i});
    hold on
end
%axis([0 8*10^4 0.5 1])
xlabel('Amount of hard negatives added for re-training');
ylabel('PR AUC');
name = {'Go','Si','GoSi','HOG (UoCTTI)','HOG (DalalTriggs)'};
legend(name,'location','southeast')
export_fig('../report/img/inriaConstantHard.pdf','-r300');
