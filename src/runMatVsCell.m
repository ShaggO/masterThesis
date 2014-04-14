clc, clear all

n = 1000000;

M = rand(100,n);

tic
s1 = prod(M,1);
toc

C = cell(1,n);
for i=1:n
    C{i} = M(:,i);
end

tic
s2 = cellfun(@prod,C);
toc

A = varArray;
A.set(M);

tic
s3 = A.prod(1);
toc