module CalculusWithJulia


using Reexport
@reexport using Plots
@reexport using Roots
@reexport using SpecialFunctions
@reexport using SymPy
@reexport using QuadGK
@reexport using HCubature
@reexport using LinearAlgebra
@reexport using Base.MathConstants

import ForwardDiff


include("multidimensional.jl")
include("derivatives.jl")
include("integration.jl")
include("plot-utils.jl")

export unzip, divergence, gradient, curl, ∇, uvec
export tangent, secant, D
export riemann, fubini
export plotif, trimplot, signchart,
       arrow!, vectorfieldplot!


end # module
