function v = nthField(S,n)
%NTHFIELD Contents of the nth field of S

f = fieldnames(S);
v = S.(f{n});

end