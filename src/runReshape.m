clc, clear all

aMax = 3;
bMax = 3;
cMax = 3;
n = 0;
for a = 1:aMax
    for b = 1:bMax
        for c = 1:cMax
            n = n + 1;
            M(n) = a*100 + b*10 + c;
        end
    end
end

M = reshape(M,[aMax bMax cMax]);
permute(M,[3 2 1])