function offsets = createCellOffsets(type,n,d)
%CREATECELLOFFSETS Create cell offsets

switch type
    case 'square'
        r = (n-1) .* d/2;
        [meshX,meshY] = meshgrid(-r(1):d(1):r(1),-r(2):d(2):r(2));
        offsets = [meshX(:) meshY(:)];
    case 'polar'
        r = d * (1:n(2));
        a = 2*pi/n(1) * (1:n(1));
        [meshR,meshA] = meshgrid(r,a);
        meshX = cos(meshA) .* meshR;
        meshY = sin(meshA) .* meshR;
        offsets = [0 0; meshX(:) meshY(:)];
    case 'concentric polar'
        r = d * (1:n(2));
        a = 2*pi/n(1) * (1:n(1));
        [meshR,meshA] = meshgrid(r,a);
        meshA(:,2:2:end) = meshA(:,2:2:end) + pi/n(1);
        meshX = cos(meshA) .* meshR;
        meshY = sin(meshA) .* meshR;
        offsets = [0 0; meshX(:) meshY(:)];
end

end

