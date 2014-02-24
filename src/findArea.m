function a = findArea(varargin)

p = inputParser;
defaultHeight = 1;
defaultUnits = 'inches';
defaultShape = 'rectangles';
expectedShapes = {'square','rectangle','parallelogram'};

addParameter(p,'units',defaultUnits);
addParameter(p,'shape',defaultShape,...
    @(x) any(validatestring(x,expectedShapes)));
addOptional(p,'width',1,@isnumeric);
addOptional(p,'height',defaultHeight,@isnumeric);

parse(p,varargin{:});
a = p.Results.width .* p.Results.height;

p.Results