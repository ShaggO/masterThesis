function d = kJetCoeffs(k)

d = [];
for i = 1:k
    d = [d; (0:i)' (i:-1:0)'];
end

end

