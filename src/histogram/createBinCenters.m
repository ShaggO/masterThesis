function [Cout, Csize] = createBinCenters(left, right, count, varargin)
% CREATEBINCENTERS  Generate bin centers for use in histogram
% Params:
%   left    Left endpoint of the range
%   right   Right endpoint of the range
%   Count   Number of bins
% Optional parameters:
%   endpoints   Whether or not there should be bins at the endpoints
%   offset      Offset to shift the bin centers in either positive or negative direction. Should be less thant (right-left)/(2*count)

p = inputParser;
addOptional(p,'endpoints',boolean(zeros(size(left))),@islogical);
addOptional(p,'offset',zeros(size(left)),@(x) isnumeric(x));
parse(p, varargin{:});
endpoints = p.Results.endpoints;
offset = p.Results.offset;

assert(~(any(endpoints & offset ~= 0)),'The combination of using the endpoints and offsetting them makes no sense...');

assert(all(left < right),'The left endpoint should be to the left of the right endpoint (left < right).')

% Create linear spaces for each histogram dimension
Csize = zeros(1,numel(left));
C = cell(1,numel(left));
for i = 1:numel(left)
    if endpoints(i)
        C{i} = linspace(left(i),right(i),count(i))';
    else
        delta = (right(i) - left(i)) / (2*count(i));
        assert(abs(offset(i)) <= delta, ['Offset (' num2str(i) ' too large. It should be smaller than (right-left)/(2*count) = ' delta '.']);
        C{i} = linspace(left(i)+delta,right(i)-delta,count(i))'+offset(i);
    end
    Csize(i) = numel(C{i});
end

% Create nd-grid for all histogram dimensions
[C{:}] = ndgrid(C{:});
Cout = zeros(numel(C{1}),numel(left));

% Format nd-grid as matrix.
% Column = dimension, row = bin center
for i = 1:numel(left)
    Cout(:,i) = C{i}(:);
end

end
