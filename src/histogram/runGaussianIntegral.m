clc, clear all

syms x y pi a b k
syms sigma positive
syms sigma1 positive
syms sigma2 positive
%1/((2*pi)^(1/2)*sigma)
g(x,sigma) = 2/sqrt(pi) * exp(-k*x^2);
int(g(x,sigma1),x,0,a)
int(g(y,sigma2),y,0,b)
int(int(g(x,sigma1)*g(y,sigma2),x,0,a),y,0,b)