clc, clear

G = imnorm(dGauss2d(0,0,320,40));
imwrite(G,'../report/img/gaussianDerivative_0_0.png');

d = kJetCoeffs(2);
for i = 1:size(d,1)
    G = imnorm(dGauss2d(d(i,1),d(i,2),320,40),true);
    imwrite(G,['../report/img/gaussianDerivative_' num2str(d(i,1)) '_' num2str(d(i,2)) '.png']);
end