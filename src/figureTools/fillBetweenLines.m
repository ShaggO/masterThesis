function fillBetweenLines(X,Y1,Y2,varargin)

X = reshape(X,1,[]);
Y1 = reshape(Y1,1,[]);
Y2 = reshape(Y2,1,[]);

fill([X fliplr(X)],[Y1 fliplr(Y2)],varargin{:});

end