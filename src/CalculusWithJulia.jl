"""
    CalculusWithJulia

A package to accompany [notes](calculuswithjulia.github.io) on using Julia with calculus.

This package does two things: 1) it loads several other packages making it easier to use (and install) the functionality provided by them and 2) defines a handful of functions and plot recipes for convenience.

## Packages loaded by `CalculusWithJulia`

### Built in packages.

The `MathConstants` package is reexported, allowing `e` to be used instead of `\euler[tab]` for a value of Euler's constant.

The `SpecialFunctions` is loaded giving access to a few special functions used in these notes, e.g., `airyai`.

The `LinearAlgebra` package is loaded for access to several of its functions for working with vectors `norm`, `cdot` (`⋅`), `cross` (`×`), `det`.

### Plotting

The `Plots` package is loaded giving access to `plot`, `scatter`, `annotate`, etc. The backends  used in the notes are `plotly`, `gr`, and `pyplot`.

The `ImplicitEquations` package is loaded for plotting implicitly defined functions.

In addition, several plot recipes are provided to ease the creation of plots:
`plotif`, `trimplot`, and `signchart` are used for plotting univariate functions;
`plot_polar` and `plot_parametric_curve` are used to plot curves in 2 or 3 dimensions;
`plot_parametric_surface` makes the plotting os parameterically defined surfaces easier;
`vectorfieldplot` and `vectorfieldplot3d` can be used to plot vector fields; and
`arrow` is a simplified interface to `quiver` that also indicates 3D vectors.


### Symbolic math

The `Sympy` package is loaded for symbolic mathematics

### Zeros of functions

The `Roots` package is loaded for its `fzero` and `fzeros` functions.

### Derivatives

The `ForwardDiff` package is loaded giving access to its  `derivative`,  `gradient`, `jacobian`, and `hessian` functions for finding automatic derivatives of functions. In addition, this package defines `'` (for functions) to return a derivative (which commits [type piracy](https://docs.julialang.org/en/v1/manual/style-guide/index.html#Avoid-type-piracy-1)), `∇` to find the gradient (`∇(f)`), the divergence (`∇⋅F`). and the curl (`∇×F`), along with `divergence` and `curl`.

### Integration

This package reexports `QuadGK`, for one-dimensional integrals; `HCubature`, for multidimensional integrals; and provides `riemann`, for Riemann sums, and `fubini`, for iterated integrals over non-rectangular regions based on `QuadGK`.

"""
module CalculusWithJulia

using Reexport
using RecipesBase
import ImplicitEquations # handle conflict with SymPy in plot-utils.jl
import ImplicitEquations: Pred
@reexport using LinearAlgebra
@reexport using Base.MathConstants
@reexport using SpecialFunctions
@reexport using Roots
@reexport using SymPy
import ForwardDiff
export ForwardDiff
@reexport using QuadGK
@reexport using HCubature



include("multidimensional.jl")
include("derivatives.jl")
include("integration.jl")
include("plot-utils.jl")
include("WeaveSupport/WeaveSupport.jl")

using Requires

function __init__()
    @require SimplePlots="307c2aad-90be-4152-b348-f51955fac6ce" include("simpleplots.jl")
    @require Plots="91a5bcdd-55d7-5caf-9e0b-520d859cae80" include("plots.jl")
    @require AbstractPlotting="537997a7-5e4e-5d89-9595-2241ea00577e" include("makie.jl")
    #@require MDBM="" include("implicit_equation.jl")    
end


export unzip, parametric_grid, divergence, gradient, curl, ∇
export tangent, secant, D
export riemann, fubini
export plotif, trimplot, signchart,
       plot_polar, plot_polar!,
       plot_parametric_curve,   plot_parametric_curve!,
       plot_parametric_surface, plot_parametric_surface!,
       vectorfieldplot,   vectorfieldplot!,
       vectorfieldplot3d, vectorfieldplot3d,
       arrow, arrow!


end # module
