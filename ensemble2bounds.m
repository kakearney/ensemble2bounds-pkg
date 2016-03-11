function B = ensemble2bounds(data, dim, style)
%ENSEMBLE2BOUNDS Calculate data for boundedline ensemble plots
%
% B = ensemble2bounds(data)
% B = ensemble2bounds(data, dim)
%
% This is just a simple helper function to get the bounds needed to plot
% ensemble results using boundedline, errorbar, or ploterr.  Both errorbar
% and boundedline require errors relative to the center line, while ploterr
% requires actual values when plotting assymmetric errors, so both types of
% arrays are returned.
%
% Input variables:
%
%   data:   ensemble data, nens x n (or n x nens if you specify dim)
%
%   dim:    dimension along which ensemble members are located [1]
%
% Output variables:
%
%   B:      structure with error arrays:
%
%           mean:           n x 1, ensemble mean
%           median:         n x 1, ensemble median
%           med2:           n x 2, ensemble median, repeated twice
%           minmaxmean:     n x 2, error from mean to min and max
%           quartmed:       n x 2, error from median to lower and upper
%                           quartiles
%           minmaxquartmed: n x 2 x 2, error from median to min, max,
%                           lower, and upper quartiles
%           std:            n x 1, standard deviation
%           minmax:         n x 2, actual min and max
%           quart:          n x 2, actual lower and upper quartile


if nargin < 2
    dim = 1;
end

S = allstats(data, dim);
sz = size(data);

if dim == 2
    S = structfun(@(x) x', S, 'uni', 0); 
end

% Central values

B.mean = S.mean';
B.median = S.median';
B.med2 = [S.median' S.median'];

% Relative bounds (for errorbar/boundedline)

B.minmaxmean = [S.mean-S.min; S.max-S.mean]';
B.quartmed = [S.median-S.q1; S.q3-S.median]';
B.minmaxquartmed = cat(3, [S.mean-S.min; S.max-S.mean]', [S.median-S.q1; S.q3-S.median]');
B.std = S.std';

% Actual bounds (for ploterr)

B.minmax = [S.min; S.max]'; 
B.quart = [S.q1; S.q3]';





