clc, clear all

syms t b

x = solve(1 - sin(b) == sin(t + b), b);
1/sin(x(1)) - 1