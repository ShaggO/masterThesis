function F = gridDetector(Isize,type,scales,gr)
%GRIDDETECTOR Not actually a detector. Creates a regular grid across the
%image for given scale(s).

c = ([Isize(2) Isize(1)]+1)/2; % image center
F = zeros(0,3);

for i = 1:numel(scales)
    gri = gr*scales(i);
    switch type
        case 'square'
            x = 0:2*gri:(Isize(2)-1)/2;
            x = c(1) + [-x(end:-1:2) x];
            y = 0:2*gri:(Isize(1)-1)/2;
            y = c(2) + [-y(end:-1:2) y];
            Fi = [repmat(x,[numel(y) 1]) repmat(y',[1 numel(x)])];
            Fi = reshape(Fi,[],2);
        case 'triangle'
            x1 = 0:2*sqrt(3)*gri:(Isize(2)-1)/2;
            x1 = c(1) + [-x1(end:-1:2) x1];
            x2 = sqrt(3)*gri:2*sqrt(3)*gri:(Isize(2)-1)/2;
            x2 = c(1) + [-x2(end:-1:1) x2];
            y1 = 0:2*gri:(Isize(1)-1)/2;
            y1 = c(2) + [-y1(end:-1:2) y1];
            y2 = gri:2*gri:(Isize(1)-1)/2;
            y2 = c(2) + [-y2(end:-1:1) y2];
            F1 = [repmat(x1,[numel(y1) 1]) repmat(y1',[1 numel(x1)])];
            F1 = reshape(F1,[],2);
            F2 = [repmat(x2,[numel(y2) 1]) repmat(y2',[1 numel(x2)])];
            F2 = reshape(F2,[],2);
            Fi = [F1; F2];
    end
    F = [F; Fi ones(size(Fi,1),1)*scales(i)];
end

end