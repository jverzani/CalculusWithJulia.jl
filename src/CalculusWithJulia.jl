"""
    CalculusWithJulia

A package to accompany [notes](calculuswithjulia.github.io) on using Julia with calculus.

This package does two things:

* It loads a few other packages making it easier to use (and install) the functionality provided by them and

* It defines a handful of functions for convenience. The exported ones
are `e`, `unzip`, `rangeclamp` `tangent`, `secant`, `D` (and the prime
notation), `divergence`, `gradient`, `curl`, and `∇`.


## Packages loaded by `CalculusWithJulia`

* The `SpecialFunctions` is loaded giving access to a few special functions used in these notes, e.g., `airyai`, `gamma`

* The `ForwardDiff` package is loaded giving access to its  `derivative`,  `gradient`, `jacobian`, and `hessian` functions for finding automatic derivatives of functions. In addition, this package defines `'` (for functions) to return a derivative (which commits [type piracy](https://docs.julialang.org/en/v1/manual/style-guide/index.html#Avoid-type-piracy-1)), `∇` to find the gradient (`∇(f)`), the divergence (`∇⋅F`). and the curl (`∇×F`), along with `divergence` and `curl`.


* The `LinearAlgebra` package is loaded for access to several of its functions for working with vectors `norm`, `cdot` (`⋅`), `cross` (`×`), `det`.

* The `PlotUtils` package is loaded so that its `adapted_grid` function is available.

## Packages with extra features added when loaded

The `Julia` package `Requires` allows for additional code to be run when another package is loaded. The following packages have additional code to load:

* `SymPy`: for symbolic math.

* `Plots`: the `Plots` package provides a plotting interface.

Several plot recipes are provided to ease the creation of plots in the notes.
`plotif`, `trimplot`, and `signchart` are used for plotting univariate functions;
`plot_polar` and `plot_parametric` are used to plot curves in 2 or 3 dimensions;
`plot_parametric` also makes the plotting og parameterically defined surfaces easier;
`vectorfieldplot` and `vectorfieldplot3d` can be used to plot vector fields; and
`arrow` is a simplified interface to `quiver` that also indicates 3D vectors.

* `MDBM`: the  `MDBM` package is useful for finding contours in ``2`` or ``3`` dimensions.

## Other packages with recurring roles in the notes

* `Roots` is used to find zeros of univariate functions

* `QuadGK` and `HCubature` are used for numeric integration

* `ImplicitEquations` is used to make 2-dimesional plots of implicit equations.

"""
module CalculusWithJulia

using Reexport
using RecipesBase
import PlotUtils
import ForwardDiff
export ForwardDiff
using Roots

@reexport using LinearAlgebra
@reexport using SpecialFunctions

using EllipsisNotation
import EllipsisNotation: Ellipsis
export ..
import IntervalSets
import IntervalSets: ClosedInterval





include("multidimensional.jl")
include("derivatives.jl")
include("integration.jl")
include("plot-utils.jl")
include("plot-recipes.jl")
include("WeaveSupport/WeaveSupport.jl")

using Requires

function __init__()
    @require SymPy="24249f21-da20-56a4-8eb1-6a02cf4ae2e6" include("sympy.jl")
    @require Plots="91a5bcdd-55d7-5caf-9e0b-520d859cae80" include("plots.jl")
    @require MDBM="ea0cff06-48de-41e3-bd0e-d3c1feffd247" include("implicit_equation.jl")
end

e = exp(1)
export e

export unzip, rangeclamp
export tangent, secant, D, sign_chart
export riemann
export divergence, gradient, curl, ∇

end # module
