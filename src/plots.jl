
## -----

export plotif, trimplot, signchart,
    plot_polar, plot_polar!,
    plot_parametric,   plot_parametric!,
    implicit_plot, implicit_plot!,
    vectorfieldplot,   vectorfieldplot!,
    vectorfieldplot3d,   vectorfieldplot3d!,
    arrow, arrow!

export newton_vis, newton_plot!, riemann_plot, riemann_plot!


##
## --------------------------------------------------
##

"""
   trimplot(f, a, b, c=20; kwargs...)

Plot f over [a,b] but break graph if it exceeds c in absolute value.
"""
function trimplot end

"""
    plotif(f, g, a, b)

Plot of `f` over `[a,b]` with the intervals where `g ≥ 0` highlighted in many ways.
"""
function plotif end

"""
   signchart(f, a, b)

Plot f over a,b with different color when negative.
"""
function signchart end

## --- parametric plots


"""
    plot_parametric(ab, r; kwargs...)
    plot_parametric!(ab, r; kwargs...)
    plot_parametric(u, v, F; kwargs...)
    plot_parametric!(u, v, F; kwargs...)

Make a parametric plot of a space curve or parametrized surface

The intervals to plot over are specifed using `a..b` notation, from IntervalSets
"""
function plot_parametric  end
function plot_parametric! end
function plot_polar  end
function plot_polar! end
## ----

function implicit_plot end
function implicit_plot! end

"""
    Visualize `F(x,y,z) = c` by plotting assorted contour lines

This graphic makes slices in the `x`, `y`, and/or `z` direction of the 3-D level surface and plots them accordingly. Which slices (and their colors) are specified through a dictionary.

Examples:
```
F(x,y,z) = x^2 + y^2 + x^2
plot_implicit_surface(F, 20)  # 20 slices in z direction
plot_implicit_surface(F, 20, slices=Dict(:x=>:blue, :y=>:red, :z=>:green), nlevels=6) # all 3 shown

# A heart
a,b = 1,3
F(x,y,z) = (x^2+((1+b)*y)^2+z^2-1)^3-x^2*z^3-a*y^2*z^3
plot_implicit_surface(F, xlims=-2..2,ylims=-1..1,zlims=-1..2)
```

Note: Idea [from](https://stackoverflow.com/questions/4680525/plotting-implicit-equations-in-3d).

Not exported.
"""
function plot_implicit_surface end

## ----



"""
   `arrow!(p, v)`

Add the vector `v` to the plot anchored at `p`.

This would just be a call to `quiver`, but there is no 3-D version of that. As well, the syntax for quiver is a bit awkward for plotting just a single arrow. (Though efficient if plotting many).

```
using Plots
r(t) = [sin(t), cos(t), t]
rp(t) = [cos(t), -sin(t), 1]
plot(unzip(r, 0, 2pi)...)
t0 = 1
arrow!(r(t0), rp(t0))
```
"""
function arrow end
function arrow! end
function arrow3d end
function arrow3d! end



"""

    vectorfieldplot(V; xlim=(-5,5), ylim=(-5,5), n=10; kwargs...)

V is a function that takes a point and returns a vector (2D dimensions), such as `V(x) = x[1]^2 + x[2]^2`.

The grid `xlim × ylim` is paritioned into (n+1) × (n+1) points. At each point, `pt`, a vector proportional to `V(pt)` is drawn.

This is written to add to an existing plot.

```
plot()  # make a plot
V(x,y) = [x, y-x]
vectorfield_plot!(p, V)
p
```
"""
function vectorfieldplot end
function vectorfieldplot! end
function vectorfieldplot3d end
function vectorfieldplot3d! end


##
# visualize newtons method
"""
    newton_vis(f, x0, a=Inf, b=-Inf; steps=5, kwargs...)
"""
function newton_vis end
"""
    newton_plot!(f, x0; steps=5, annotate_steps::Int=0, kwargs...)

Add trace of Newton's method to plot.

* `steps`: how many steps from `x0` to illustrate
* `annotate_steps::Int`: how may steps to annotate
"""
function newton_plot! end

# visualize Riemann sum
"""
    riemann_plot!(f, a, b, n; method="method", fill, kwargs...)
    riemann_plot(f, a, b, n; method="method", fill, kwargs...)

Add visualization of riemann sum in a layer.

* `method`: one of `right`, `left`, `trapezoid`, `simpsons`
* `fill`: to specify fill color, something like `("green", 0.25, 0)` will fill in green with an alpha transparency.

"""
function riemann_plot! end
function riemann_plot end
