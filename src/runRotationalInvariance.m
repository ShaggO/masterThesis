clc, clear all

syms a b c t

at = cos(t)^2 * a + 2*cos(t)*sin(t) * b + sin(t)^2 * c;
bt = -cos(t)*sin(t) * a + (cos(t)^2 - sin(t)^2) * b + cos(t)*sin(t) * c;
ct = sin(t)^2 * a - 2*cos(t)*sin(t) * b + cos(t)^2 * c;

simplify(-at-ct)
simplify(4*(bt^2))
simplify((at-ct)^2)