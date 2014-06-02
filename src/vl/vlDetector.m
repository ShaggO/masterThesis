function F = vlDetector(I, varargin)

F = vl_covdet(single(255*I),varargin{:});

end
