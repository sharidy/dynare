function o = table(varargin)
%function o = table(varargin)
% Table Class Constructor
%
% INPUTS
%   0 args => empty table
%   1 arg (table class) => copy object
%
% OUTPUTS
%   none
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

o.seriesElements = seriesElements();

o.title = '';
o.title_size = 'large';
o.footnote = '';

o.config = '';
o.hlines = false;
o.vlines = false;
o.vline_after = '';

o.data = '';
o.seriestouse = '';
o.range = {};
o.precision = 1;

if nargin == 1
    assert(isa(varargin{1}, 'table'),['With one arg to Table constructor, ' ...
                        'you must pass a table object']);
    o = varargin{1};
    return;
elseif nargin > 1
    if round(nargin/2) ~= nargin/2
        error(['Options to Table constructor must be supplied in name/value ' ...
               'pairs.']);
    end

    optNames = lower(fieldnames(o));

    % overwrite default values
    for pair = reshape(varargin, 2, [])
        field = lower(pair{1});
        if any(strmatch(field, optNames, 'exact'))
            o.(field) = pair{2};
        else
            error('%s is not a recognized option to the Table constructor.', ...
                  field);
        end
    end
end

% Check options provided by user
assert(ischar(o.title), '@table.table: title must be a string');
assert(ischar(o.footnote), '@table.table: footnote must be a string');
assert(ischar(o.config), '@table.table: config file must be a string');
assert(islogical(o.hlines), '@table.table: hlines must be true or false');
assert(islogical(o.vlines), '@table.table: vlines must be true or false');
assert(isint(o.precision), '@table.table: precision must be an int');
assert(isempty(o.range) || (isa(o.range, 'dynDates') && o.range.ndat >= 2), ...
       ['@table.table: range is specified as a dynDates range, e.g. ' ...
        '''dynDates(''1999q1''):dynDates(''1999q3'')''.']);
assert(isempty(o.data) || isa(o.data, 'dynSeries'), ...
       '@table.table: data must be a dynSeries');
assert(isempty(o.seriestouse) || iscellstr(o.seriestouse), ...
       '@table.table: seriestouse must be a cell array of string(s)');
assert(isempty(o.vline_after) || isa(o.vline_after, 'dynDate'), ...
       '@table.table: vline_after must be a dynDate');
if o.vlines
    o.vline_after = '';
end
valid_title_sizes = {'Huge', 'huge', 'LARGE', 'Large', 'large', 'normalsize', ...
                    'small', 'footnotesize', 'scriptsize', 'tiny'};
assert(any(strcmp(o.title_size, valid_title_sizes)), ...
       ['@table.table: title_size must be one of ' strjoin(valid_title_sizes, ' ')]);

% using o.seriestouse, create series objects and put them in o.seriesElements
if ~isempty(o.data)
    if isempty(o.seriestouse)
        for i=1:o.data.vobs
            o.seriesElements = o.seriesElements.addSeries('data', o.data{o.data.name{i}});
        end
    else
        for i=1:length(o.seriestouse)
            o.seriesElements = o.seriesElements.addSeries('data', o.data{o.seriestouse{i}});
        end
    end
end
o = rmfield(o, 'seriestouse');
o = rmfield(o, 'data');

% Create table object
o = class(o, 'table');
end