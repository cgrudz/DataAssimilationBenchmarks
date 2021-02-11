########################################################################################################################
module SlurmExperimentDriver 
########################################################################################################################
# imports and exports
using Random, Distributions
using Debugger
using Distributed
using LinearAlgebra
using JLD
using DeSolvers
using L96 
using EnsembleKalmanSchemes
using FilterExps
using SmootherExps

########################################################################################################################
########################################################################################################################
## Experiments to run as a single function call
########################################################################################################################
########################################################################################################################
# Hybrid smoothers
########################################################################################################################
function hybrid_smoother_state_exp(j)
    f = load("/home/cgrudzien/da_benchmark/data/input_data/hybrid_state_smoother_input_args.jld")
    args = f["experiments"][j]
    hybrid_state(args)
end

t = parse(Int64, ARGS[1])
hybrid_smoother_state_exp(t)

end
