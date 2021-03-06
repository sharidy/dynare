function o = series(varargin)
%function o = series(varargin)
% Series Class Constructor
%
% INPUTS
%   varargin        0 args  : empty series object
%                   1 arg   : must be series object (return a copy of arg)
%                   > 1 args: option/value pairs (see structure below for
%                   options)
%
% OUTPUTS
%   o   [series] series object
%
% SPECIAL REQUIREMENTS
%   none

% Copyright (C) 2013 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <http://www.gnu.org/licenses/>.

o = struct;

o.data = '';

o.color = 'k';
o.line_style = '-';
o.line_width = 0.5;

o.graph_marker = '';
o.graph_marker_edge_color = 'auto';
o.graph_marker_face_color = 'auto';
o.graph_marker_size = 6;

o.table_markers = false;
o.table_neg_color = 'red';
o.table_pos_color = 'blue';

o.table_align_right = false;

if nargin == 1
    assert(isa(varargin{1}, 'series'),['@series.series: with one arg you ' ...
                        'must pass a series object']);
    o = varargin{1};
    return;
elseif nargin > 1
    if round(nargin/2) ~= nargin/2
        error(['@series.series: options must be supplied in name/value ' ...
               'pairs.']);
    end

    optNames = lower(fieldnames(o));

    % overwrite default values
    for pair = reshape(varargin, 2, [])
        field = lower(pair{1});
        if any(strmatch(field, optNames, 'exact'))
            o.(field) = pair{2};
        else
            error('@series.series: %s is not a recognized option.', field);
        end
    end
end

% Create series object
o = class(o, 'series');
end