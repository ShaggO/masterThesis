clc, clear

params = load('results/optimize/inriaParametersGo');
I = zeros([134 70 3]);

method1 = params.method;
method2 = modifyDescriptor(params.method,'cellSigma',[0.6 0.6]);

mFunc1 = parseMethod(method1);
mFunc2 = parseMethod(method2);

mFunc1(I,'','',false)
mFunc2(I,'','',false)