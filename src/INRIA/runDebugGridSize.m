clc, clear

params = load('results/optimize/inriaParametersGo');
I = zeros([134 70 3]);

method1 = modifyDescriptor(params.method,'gridType','triangle window');
method1 = modifyDescriptor(method1,'cellSigma',[0.5 0.5]);
method2 = modifyDescriptor(method1,'gridSize',5.5);

mFunc1 = parseMethod(method1);
mFunc2 = parseMethod(method2);

mFunc1(I,'','',false)
mFunc2(I,'','',false)