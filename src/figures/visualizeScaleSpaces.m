function I = visualizeScaleSpaces(S,border)
%VISUALIZESCALESPACES Summary of this function goes here
%   Detailed explanation goes here

h = cellfun(@(x) size(x,1),S);
w = cellfun(@(x) size(x,2),S);

I = ones(h(1),w(1)+1+w(2)) * border;

I(1:h(1),1:w(1)) = S{1};
offset = 0;
for i = 2:numel(S)
    I(offset+(1:h(i)-1),w(1)+1+(1:w(i))) = S{i}(1:end-1,:);
    offset = offset+h(i);
end

end