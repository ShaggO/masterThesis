function F = randomWindowDetector(Isize,n,seed,windowSize)
%GRIDDETECTOR Not actually a detector. Creates random windows across the
%image for given scale(s).

rng(seed,'combRecursive');

c = ([Isize(2) Isize(1)]+1)/2; % image center

rx = floor((Isize(2)-windowSize(2))/2);
ry = floor((Isize(1)-windowSize(1))/2);

x = randi(2*rx-1,n,1)-rx+c(1);
y = randi(2*ry-1,n,1)-ry+c(2);

F = [x y ones(size(x,1),1)];

end