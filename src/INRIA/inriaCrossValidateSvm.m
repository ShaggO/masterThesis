function PRAUC = inriaCrossValidateSvm(data,n,method,svmArgs,desSave)

PRAUC = zeros(n,1);
for k = 1:n
    [~,PRAUC(k)] = inriaValidateSvm(data,n,k,method,svmArgs,desSave);
end
PRAUC = mean(PRAUC);

end