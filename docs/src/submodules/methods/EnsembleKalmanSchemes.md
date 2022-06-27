# Ensemble Kalman Schemes

## API for data assimilation solvers
There are currently four families of data assimilation solvers available in this package, which
define the outer-loop of the data assimilation cycle.  Particularly, these define how the sequential
data assimilation cycle will pass over a time series of observations.  Ensemble filters run only
forward-in-time.  The classic lag-shift smoother runs identically to the filter in its forecast
and filter steps, but includes an additional retrospective analysis to past ensemble states
stored in memory.  The single iteration smoother follows the same convention as the classic smoother,
except in that new cycles are initiated from a past, reanlyzed ensemble state.  The Gauss-Newton
iterative smoothers are 4D smoothers, which iteratively optimize the initial condition at the
beginning of a data assimilation cycle, and propagate this initial condition to initialize the
subsequent cycle.  A full discussion of these methods can be found in
[Grudzien, et al. 2021](https://gmd.copernicus.org/preprints/gmd-2021-306/).

For each outer-loop method defining the data assimilation cycle, different types of analyses
can be specified within their arguments.  Likewise, these outer-loop methods require arguments such
as the ensemble state or the range of ensemble states to analyze, an observation to assimilate or
a range of observations to assimilate, as the observation error covariances, the ensemble covariance
inflation parameter and key word arguments for running the underlying dynamical state model.
Examples of the syntax are below:

```{julia}
ensemble_filter(analysis::String, ens::Array{Float64,2}, obs::Vector{Float64},
                         obs_cov::CovM, state_infl::Float64, kwargs::StepKwargs)

ls_smoother_classic(analysis::String, ens::Array{Float64,2}, obs::Array{Float64,2},
                             obs_cov::CovM, state_infl::Float64, kwargs::StepKwargs)

ls_smoother_single_iteration(analysis::String, ens::Array{Float64,2}, obs::Array{Float64,2},
                             obs_cov::CovM, state_infl::Float64, kwargs::StepKwargs)

ls_smoother_gauss_newton(analysis::String, ens::Array{Float64,2}, obs::Array{Float64,2},
                             obs_cov::CovM, state_infl::Float64, kwargs::StepKwargs;
                             ϵ::Float64=0.0001, tol::Float64=0.001, max_iter::Int64=10)

"""
analysis   -- string name analysis scheme given to the transform sub-routine
ens        -- ensemble matrix defined by the array with columns given by the replicates of
              the model state
obs        -- observation vector for the current analysis in ensemble_filter / array with
              columns given by the observation vectors for the ordered sequence of analysis
							times in the current smoothing window
obs_cov    -- observation error covariance matrix
state_infl -- multiplicative covariance inflation factor for the state variable covariance
kwargs     -- keyword arguments for parameter estimation or other functionality, including
              integration parameters for the state model in smoothing schemes
"""
```

The type of analysis to be passed to the transform step is specified with the `analysis` string, with partiuclar
analysis methods described below.  Observations for the filter schemes correspond to information available
at a single analysis time while the ls (lag-shift) smoothers require an array of observations corresponding
to all analysis times within the DAW.  Observation covariances are typed as [`CovM`](@ref) for efficiency.
The `state_infl` is a required tuneable parameter for multiplicative covariance inflation.   Extended parameter
state covariance inflation can be specified in `kwargs`.  These outer-loops will pass the required values
to the `transform` function that generates the ensemble transform for conditioning on observations.  Different
outer-loop schemes can be built around the `transform` function alone in order to use validated ensemble transform 
schemes.  Utility scripts to generate observation operators, analyze ensemble statistics, etc, are included
in the below. 

## Methods

```@autodocs
Modules = [DataAssimilationBenchmarks.EnsembleKalmanSchemes]
```