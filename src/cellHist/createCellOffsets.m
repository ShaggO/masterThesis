function [c, cPol, cellSize] = createCellOffsets(type,gn,gr,cellSigma)
%CREATECELLOFFSETS Create cell offsets

switch type
    case 'square window'
        x = 0:2*gn:gr(2)/2-3*gn-2;
        x = [-x(end:-1:2) x];
        y = 0:2*gn:gr(1)/2-3*gn-2;
        y = [-y(end:-1:2) y];
        c = [repmat(x,[numel(y) 1]) repmat(y',[1 numel(x)])];
        c = reshape(c,[],2);
        d = min(abs(abs(c) - repmat(fliplr(gr)/2,size(c,1),1)),[],2);
        cellSize = min((d-2)/(3*cellSigma(1))-10^-6,1);
    case 'triangle window'
        x1 = 0:2*sqrt(3)*gn:gr(2)/2-3*gn-2;
        x1 = [-x1(end:-1:2) x1];
        x2 = sqrt(3)*gn:2*sqrt(3)*gn:gr(2)/2-3*gn-2;
        x2 = [-x2(end:-1:1) x2];
        y1 = 0:2*gn:gr(1)/2-3*gn-2;
        y1 = [-y1(end:-1:2) y1];
        y2 = gn:2*gn:gr(1)/2-3*gn-2;
        y2 = [-y2(end:-1:1) y2];
        c1 = [repmat(x1,[numel(y1) 1]) repmat(y1',[1 numel(x1)])];
        c1 = reshape(c1,[],2);
        c2 = [repmat(x2,[numel(y2) 1]) repmat(y2',[1 numel(x2)])];
        c2 = reshape(c2,[],2);
        c = [c1; c2];
        d = min(abs(abs(c) - repmat(fliplr(gr)/2,size(c,1),1)),[],2);
        cellSize = min((d-2)/(3*cellSigma(1))-10^-6,1);
    case 'square'
        d = 2*gr ./ gn;
        r = (gn-1)/2;
        [meshX,meshY] = meshgnd(d(1)*(-r(1):r(1)),d(2)*(-r(2):r(2)));
        c = [meshX(:) meshY(:)];
        cellSize = ones(size(c,1),1) / (gn(2));
    case 'polar'
        t = pi/gn(1);
        a = 2*t * (1:gn(1)) + t;
        d = gr * ((1:gn(2))-1/2) / gn(2);
        c = polarGrid(a,d,0);
        cellSize = ones(size(c,1),1) / (2*gn(2));
    case 'polar central'
        t = pi/gn(1);
        a = 2*t * (1:gn(1)) + t;
        d = gr * (1:gn(2)) / (gn(2)+1/2);
        c = [0 0; polarGrid(a,d,0)];
        cellSize = ones(size(c,1),1) / (2*gn(2)+1);
    case 'concentric polar'
        t = pi/gn(1);
        a = 2*t * (1:gn(1)) + t;
        d = gr * ((1:gn(2))-1/2) / gn(2);
        c = polarGrid(a,d,t);
        cellSize = ones(size(c,1),1) / (2*gn(2));
    case 'concentric polar central'
        t = pi/gn(1);
        a = 2*t * (1:gn(1)) + t;
        d = gr * (1:gn(2)) / (gn(2)+1/2);
        c = [0 0; polarGrid(a,d,t)];
        cellSize = ones(size(c,1),1) / (2*gn(2)+1);
    case 'log-polar'
        t = pi/gn(1);
        a = 2*t * (1:gn(1)) + t;
        s = sin(t);
        d = ((1 + s) / (1 - s)) .^ (0:gn(2)-1);
        d = d / ((1+s) * d(end)) * gr;
        r = s * d;
        c = [0 0; polarGrid(a,d,0)];
        cellSize = [d(1)-r(1); reshape(repmat(r,gn(1),1),[],1)] / gr;
    case 'concentric log-polar'
        t = pi/gn(1);
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