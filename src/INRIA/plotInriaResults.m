function plotInriaResults(resultsFile)

load(resultsFile);

figure;

loglog(ROC(:,1)+eps,1-ROC(:,2)+eps,'-r');
xlabel('FPR');
ylabel('1-recall');
axis([1e-6 1e-1 0.01 0.5]);
grid on;

end
