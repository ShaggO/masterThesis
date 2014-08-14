clc, clear all

a = rand(10,1);
b = rand(10,1);

[~,~,ci] = ttest2(a,b,'vartype','unequal')

r = (var(a)/numel(a) + var(b)/numel(b))^2 / ((var(a)/numel(a))^2/(numel(a)-1) + (var(b)/numel(b))^2/(numel(b)-1))
ci = mean(a) - mean(b) + [-1; 1] * tinv(0.975,r) * sqrt(var(a)/numel(a) + var(b)/numel(b))

