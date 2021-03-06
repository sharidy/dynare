function [vdec, cc, ac] = mc_moments(mm, ss, dr)

% Copyright (C) 2012 Dynare Team
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

global options_ M_

  [nr1, nc1, nsam] = size(mm);
  disp('Computing theoretical moments ...')
  h = dyn_waitbar(0,'Theoretical moments ...');
  
  for j=1:nsam,
    dr.ghx = mm(:, [1:(nc1-M_.exo_nbr)],j);
    dr.ghu = mm(:, [(nc1-M_.exo_nbr+1):end], j);
    if ~isempty(ss),
      set_shocks_param(ss(j,:));
    end
    [vdec(:,:,j), corr, autocorr, z, zz] = th_moments(dr,options_.varobs);
    cc(:,:,j)=triu(corr);
    dum=[];
    for i=1:options_.ar
    dum=[dum, autocorr{i}];
    end
    ac(:,:,j)=dum;
    dyn_waitbar(j/nsam,h)
  end
  dyn_waitbar_close(h)
  disp(' ')
  disp('... done !')
