function [options_, oo_]=ms_variance_decomposition(M_, options_, oo_)
%function ms_variance_decomposition()
% calls ms_variance_decomposition mex function
%
% INPUTS
%    M_
%    options_
%    oo_
%
% OUTPUTS
%    options_
%    oo_
%
% SPECIAL REQUIREMENTS
%    none

% Copyright (C) 2011 Dynare Team
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

disp('Variance Decomposition');
options_ = set_ms_estimation_flags_for_other_mex(options_);
options_ = set_ms_simulation_flags_for_other_mex(options_);
oo_ = set_oo_w_estimation_output(options_, oo_);

% NOTICE THAT VARIANCE DECOMPOSITION DEFAULTS TO USING THE MEAN, NOT MEDIAN OR BANDED

opt = {options_.ms.output_file_tag, ...
    'seed', options_.DynareRandomStreams.seed, ...
    'horizon', options_.ms.horizon, ...
    'filtered', options_.ms.filtered_probabilities, ...
    'error_bands', options_.ms.error_bands, ...
    'percentiles', options_.ms.error_band_percentiles, ...
    'thin', options_.ms.thinning_factor, ...
    'mean'};

[err, vd] = mex_ms_variance_decomposition(opt{:},'free_parameters',oo_.ms.maxparams,'shocks',options_.ms.shock_draws);
mexErrCheck('mex_ms_variance_decomposition ergodic ', err);
plot_ms_variance_decomposition(M_,vd, 'Ergodic Variance Decomposition',options_.graph_save_formats,options_.TeX);

[err, regime_vd] = mex_ms_variance_decomposition(opt{:},'free_parameters',oo_.ms.maxparams,'shocks',options_.ms.shock_draws,'regimes');
mexErrCheck('mex_ms_variance_decomposition ergodic regimes', err);
save([M_.fname '/' options_.ms.output_file_tag '_ergodic_vd.mat'], 'vd', 'regime_vd');

if exist(options_.ms.load_mh_file,'file') > 0
    [err, vd] = mex_ms_variance_decomposition(opt{:},'simulation_file',options_.ms.load_mh_file,'shocks',options_.ms.shocks_per_parameter,'parameter_uncertainty');
    mexErrCheck('mex_ms_variance_decomposition bayesian ', err);

    [err, regime_vd] = mex_ms_variance_decomposition(opt{:},'simulation_file',options_.ms.load_mh_file,'shocks',options_.ms.shocks_per_parameter,'parameter_uncertainty','regimes');
    mexErrCheck('mex_ms_variance_decomposition bayesian regimes ', err);
    save([M_.fname '/' options_.ms.output_file_tag '_bayesian_vd.mat'], 'vd', 'regime_vd');
end
options_ = initialize_ms_sbvar_options(M_, options_);
end