function X = visualizeGoHist(cells,binC,sigma)

cells = permute(cells,[4 2 3 1]);
binC = permute(binC,[3 2 1]);
X = repmat(cells,2,1,numel(binC)) + ...
    repmat([sin(binC) -cos(binC); -sin(binC) cos(binC)]*sigma,1,1,1,size(cells,4));

end