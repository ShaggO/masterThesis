function offsets = createCellOffsets(type,n,d,central)
%CREATECELLOFFSETS Create cell offsets
if nargin < 4
    central = false;
end

switch type
    case 'square'
        if central
            n = n-1;
        end
        r = (n-1) .* d/2;
        [meshX,meshY] = meshgrid(-r(1):d(1):r(1),-r(2):d(2):r(2));
        offsets = [meshX(:) meshY(:)];
    case 'polar'
        if central
            middle = [];
            r = d * ((1:n(2))-1/2);
            a = 2*pi/n(1) * (1:n(1)) + pi/n(1);
        else
            middle = [0 0];
            r = d * (1:n(2));
            a = 2*pi/n(1) * (1:n(1));
        end
        [meshR,meshA] = meshgrid(r,a);
        meshX = cos(meshA) .* meshR;
        meshY = sin(meshA) .* meshR;
        offsets = [middle; meshX(:) meshY(:)];
    case 'concentric polar'
        if central
            middle = [];
            r = d * ((1:n(2))-1/2);
            a = 2*pi/n(1) * (1:n(1)) + pi/n(1);
        else
            middle = [0 0];
            r = d * (1:n(2));
            a = 2*pi/n(1) * (1:n(1));
        end
        [meshR,meshA] = meshgrid(r,a);
        meshA(:,2:2:end) = meshA(:,2:2:end) + pi/n(1);
        meshX = cos(meshA) .* meshR;
        meshY = sin(meshA) .* meshR;
        offsets = [middle; meshX(:) meshY(:)];
end

end

