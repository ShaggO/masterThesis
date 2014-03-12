clc, clear all

SInobins = 9; % Number of bins in Shape Index histogram
SIbinrange = [-1, 1]; % Shape index histogram bin range
SIbinscale = diff(SIbinrange) / (2*SInobins); % Shape index histogram bin scale
SIbincenters = linspace(SIbinrange(1) + SIbinscale, SIbinrange(2) - SIbinscale, SInobins)';
SInorm = 0.5*sqrt(2*pi)*SIbinscale*(erf(sqrt(2)*(1+SIbincenters)/(2*SIbinscale)) - erf(sqrt(2)*(SIbincenters-1)/(2*SIbinscale)));

SIbinscale
SIbincenters
SInorm