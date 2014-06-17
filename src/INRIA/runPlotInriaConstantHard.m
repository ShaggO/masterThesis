clc, clear

load('C:\Users\Ben\Documents\GitHub\masterThesis\src\results\inriaConstantHard.mat')
nHard = [1 2 5 10 20 40 60 80 100] * 10^3;

figure
plot(repmat(nHard',1,5),PRAUC)
legend(name,'location','southeast')