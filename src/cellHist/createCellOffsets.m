function [c, cPol] = createCellOffsets(type,n,d)
%CREATECELLOFFSETS Create cell offsets

switch type
    case 'square'
        r = (n-1) .* d/2;
        [meshX,meshY] = meshgrid(-r(1):d(1):r(1),-r(2):d(2):r(2));
        c = [meshX(:) meshY(:)];
    case 'polar'
        r = d * ((1:n(2))-1/2);
        a = 2*pi/n(1) * (1:n(1));
        [meshR,meshA] = meshgrid(r,a);
        meshX = cos(meshA) .* meshR;
        meshY = sin(meshA) .* meshR;
        c = [meshX(:) meshY(:)];
    case 'polar central'
        r = d * (1:n(2));
        a = 2*pi/n(1) * (1:n(1));
        [meshR,meshA] = meshgrid(r,a);
        meshX = cos(meshA) .* meshR;
        meshY = sin(meshA) .* meshR;
        c = [0 0; meshX(:) meshY(:)];
    case 'concentric polar'
        r = d * (1:n(2));
        a = 2*pi/n(1) * (1:n(1));
        [meshR,meshA] = meshgrid(r,a);
        meshA(:,2:2:end) = meshA(:,2:2:end) + pi/n(1);
        meshX = cos(meshA) .* meshR;
        meshY = sin(meshA) .* meshR;
        c = [meshX(:) meshY(:)];
    case 'concentric polar central'
        r = d * ((1:n(2))-1/2);
        a = 2*pi/n(1) * (1:n(1));
        [meshR,meshA] = meshgrid(r,a);
        meshA(:,2:2:end) = meshA(:,2:2:end) + pi/n(1);
        meshX = cos(meshA) .* meshR;
        meshY = sin(meshA) .* meshR;
        c = [0 0; meshX(:) meshY(:)];
end

c = round(10^6 * c) / 10^6;

[theta,rho] = cart2pol(c(:,1),c(:,2));
cPol = [theta rho];

end

