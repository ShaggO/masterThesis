clc, clear all

A = varArray.newEmpty(1,[5 5]);

A.add([0 5; 0 5],[1 5]);
A.add([(1:3)' (2:4)'],2:2:4,2);
A.add([9; 9],4);
A.add([6; 6],4,4);
data1 = A.data{1}
data2 = A.data{2}
map = A.map
sizes = A.sizes
v = A.vector

B = varArray.newVector(v,sizes,map);
all(A.vector == B.vector)

% for i = 1:A.parts
%     [x,mask] = A.partData(i)
% end