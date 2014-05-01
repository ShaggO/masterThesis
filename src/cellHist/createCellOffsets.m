function [c, cPol, cellSize] = createCellOffsets(type,gn,gr)
%CREATECELLOFFSETS Create cell offsets

t = pi/gn(1);
switch type
    case 'square'
        d = 2*gr ./ (gn-1);
        [meshX,meshY] = meshgrid(-gr(1):d(1):gr(1),-gr(2):d(2):gr(2));
        c = [meshX(:) meshY(:)];
        cellSize = ones(size(c,1),1);
    case 'polar'
        a = 2*t * (1:gn(1)) + t;
        d = gr * ((1:gn(2))-1/2) / gn(2);
        c = polarGrid(a,d,0);
        cellSize = ones(size(c,1),1) / (2*gn(2));
    case 'polar central'
        a = 2*t * (1:gn(1)) + t;
        d = gr * (1:gn(2)) / gn(2);
        c = [0 0; polarGrid(a,d,0)];
        cellSize = ones(size(c,1),1) / (2*gn(2)+1);
    case 'concentric polar'
        a = 2*t * (1:gn(1)) + t;
        d = gr * (1:gn(2)) / gn(2);
        c = polarGrid(a,d,t);
        cellSize = ones(size(c,1),1) / (2*gn(2));
    case 'concentric polar central'
        a = 2*t * (1:gn(1)) + t;
        d = gr * ((1:gn(2))-1/2) / gn(2);
        c = [0 0; polarGrid(a,d,t)];
        cellSize = ones(size(c,1),1) / (2*gn(2)+1);
    case 'log-polar'
        a = 2*t * (1:gn(1)) + t;
        s = sin(t);
        d = ((1 + s) / (1 - s)) .^ (0:gn(2)-1);
        d = d / ((1+s) * d(end)) * gr;
        r = s * d;
        c = [0 0; polarGrid(a,d,0)];
        cellSize = [d(1)-r(1); reshape(repmat(r,gn(1),1),[],1)] / gr;
    case 'concentric log-polar'
        a = 2*t * (1:gn(1)) + t;
        k = -1/sin(log((exp(-(t*1i)/2)*(exp(t*1i) + exp(t*2*1i) + 1)^(1/2) + 1i)/(exp(t*1i) + 1))*1i) - 1;
        s = sin(t);
        d = real(k) .^ (0:gn(2)-1);
        d = d / ((1+s) * d(end)) * gr;
        r = s * d;
        c = [0 0; polarGrid(a,d,t)];
        cellSize = [d(1)-r(1); reshape(repmat(r,gn(1),1),[],1)] / gr;
end

c = round(10^6 * c) / 10^6;

[theta,rho] = cart2pol(c(:,1),c(:,2));
cPol = [theta rho];

end

function c = polarGrid(a,d,concenOffset)

[meshR,meshA] = meshgrid(d,a);
meshA(:,2:2:end) = meshA(:,2:2:end) + concenOffset;
meshX = cos(meshA) .* meshR;
meshY = sin(meshA) .* meshR;
c = [meshX(:) meshY(:)];

end