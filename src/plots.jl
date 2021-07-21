
# just show body, not standalone
function Plots._show(io::IO, ::MIME"text/html", plt::Plots.Plot{Plots.PlotlyBackend})
    write(io, Plots.html_body(plt))
end

## -----

export plotif, trimplot, signchart,
       plot_polar, plot_polar!,
       plot_parametric,   plot_parametric!,
       vectorfieldplot,   vectorfieldplot!,
       vectorfieldplot3d, vectorfieldplot3d,
       arrow, arrow!

export newton_vis


##
## --------------------------------------------------
##

"""
   trimplot(f, a, b, c=20; kwargs...)

Plot f over [a,b] but break graph if it exceeds c in absolute value.
"""
function trimplot(f, a, b, c=20; color=:black, legend=false, kwargs...)
    F = (a,b) -> begin
        fa, fb = f(a), f(b)
        M = max(fa, fb)
        m = min(fa, fb)
        m < -c && return false
        M > c && return false
        true
    end
    xs = range(a, b, length=251)
    cols = find_colors(F, xs, (color, :transparent, :red))
    Plots.plot(xs, f.(xs), colors=cols, legend=legend, kwargs...)
end


"""
    plotif(f, g, a, b)

Plot f colored depending on g >= 0 or not.
"""
function plotif(f, g, a, b)
    xs = range(a, b, length=251)
    cols = identify_colors(g, xs)
    Plots.plot(xs, f.(xs), color=cols, legend=false)
end

"""
   signchart(f, a, b)

Plot f over a,b with different color when negative.
"""
function signchart(f, a, b)
    p = plotif(f, f, a, b)
    Plots.plot!(p, zero)
    p
end

## --- parametric plots

adapted_grid = CalculusWithJulia.PlotUtils.adapted_grid
function xyzs(ab::ClosedInterval, r)
    a, b = abs = extrema(ab)
    xs = sort(union([adapted_grid(t -> r(t)[i], abs)[1] for i in eachindex(r(a))]...))
    unzip(r.(xs))
end

"""
    plot_parametric(ab, r; kwargs...)
    plot_parametric!(ab, r; kwargs...)
    plot_parametric(u, v, F; kwargs...)
    plot_parametric!(u, v, F; kwargs...)

Make a parametric plot of a space curve or parametrized surface

The intervals to plot over are specifed using `a..b` notation, from IntervalSets
"""
plot_parametric(ab::ClosedInterval, r; kwargs...) = Plots.plot(xyzs(ab, r)...; kwargs...)
plot_parametric!(ab::ClosedInterval, r; kwargs...) = Plots.plot!(xyzs(ab, r)...; kwargs...)

plot_polar(ab::ClosedInterval, r; kwargs...) =
    plot_parametric(ab, t->[r(t)*cos(t), r(t)*sin(t)]; kwargs...)
plot_polar!(ab::ClosedInterval, r; kwargs...) =
    plot_parametric!(ab, t->[r(t)*cos(t), r(t)*sin(t)]; kwargs...)

## ----

function XYZs(u::ClosedInterval, v::ClosedInterval, r; n=51)
    us = range(extrema(u)..., length=n)
    vs = range(extrema(v)..., length=n)
    unzip(r.(us', vs))  # Plots.jl style; flip for Makie
end

# needs plotly(); not gr()
plot_parametric(u::ClosedInterval, v::ClosedInterval, F;  kwargs...) =
    Plots.surface(XYZs(u,v,F)...;  kwargs..., )
plot_parametric!(u::ClosedInterval, v::ClosedInterval, F; kwargs...) =
    Plots.surface!(XYZs(u,v,F)...;  kwargs...)




import Contour

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
function plot_implicit_surface(F, c=0;
                       xlim=(-5,5), ylim=xlim, zlim=xlim,
                       nlevels=25,         # number of levels in a direction
                       slices=Dict(:z => :blue), # Dict(:x => :color, :y=>:color, :z=>:color)
                       kwargs...          # passed to initial `plot` call
                       )

    _linspace(rng, n=150) = range(extrema(rng)[1], stop=extrema(rng)[2], length=n)

    X1, Y1, Z1 = _linspace(xlim), _linspace(ylim), _linspace(zlim)

    p = Plots.plot(;legend=false,kwargs...)

    if :x ∈ keys(slices)
        for x in _linspace(xlim, nlevels)
            local X1 = [F(x,y,z) for y in Y1, z in Z1]
            cnt = Contour.contours(Y1,Z1,X1, [c])
            for line in Contour.lines(Contour.levels(cnt)[1])
                ys, zs = Contour.coordinates(line) # coordinates of this line segment
                Plots.plot!(p, x .+ 0 * ys, ys, zs, color=slices[:x])
          end
        end
    end

    if :y ∈ keys(slices)
        for y in _linspace(ylim, nlevels)
            local Y1 = [F(x,y,z) for x in X1, z in Z1]
            cnt = Contour.contours(Z1,X1,Y1, [c])
            for line in Contour.lines(Contour.levels(cnt)[1])
                xs, zs = Contour.coordinates(line) # coordinates of this line segment
                Plots.plot!(p, xs, y .+ 0 * xs, zs, color=slices[:y])
            end
        end
    end

    if :z ∈ keys(slices)
        for z in _linspace(zlim, nlevels)
            local Z1 = [F(x, y, z) for x in X1, y in Y1]
            cnt = Contour.contours(X1, Y1, Z1, [c])
            for line in Contour.lines(Contour.levels(cnt)[1])
                xs, ys = Contour.coordinates(line) # coordinates of this line segment
                Plots.plot!(p, xs, ys, z .+ 0 * xs, color=slices[:z])
            end
        end
    end


    p
end

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
arrow!(r(t0), r'(t0))
```
"""
function arrow!(plt, p, v; kwargs...)
  if length(p) == 2
      Plots.quiver!(plt, unzip([p])..., quiver=Tuple(unzip([v])); kwargs...)
  elseif length(p) == 3
    # 3d quiver needs support
    # https://github.com/JuliaPlots/Plots.jl/issues/319#issue-159652535
    # headless arrow instead
      Plots.plot!(plt, unzip(p, p+v)...; kwargs...)
	end
end
arrow!(p,v;kwargs...) = arrow!(Plots.current(), p, v; kwargs...)




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
function vectorfieldplot!(plt, V; xlim=(-5,5), ylim=(-5,5), n=10, kwargs...)

    dx, dy = (xlim[2]-xlim[1])/n, (ylim[2]-ylim[1])/n
    xs, ys = xlim[1]:dx:xlim[2], ylim[1]:dy:ylim[2]

    ps = [[x,y] for x in xs for y in ys]
    vs = V.(ps)
    λ = 0.9 * min(dx, dy) /maximum(norm.(vs))

    Plots.quiver!(plt, unzip(ps)..., quiver=unzip(λ * vs))

end
vectorfieldplot!(V; kwargs...) = vectorfieldplot!(Plots.current(), V; kwargs...)



##
# visualize newtons method
function newton_vis(f, x0, a=Inf,b=-Inf; steps=5, kwargs...)
    xs = Float64[x0]
    for i in 1:steps
        push!(xs, xs[end] - f(xs[end]) / f'(xs[end]))
    end

    m,M = extrema(xs)
    m = min(m, a)
    M = max(M, b)

    p = Plots.plot(f, m, M; linewidth=3, legend=false, kwargs...)
    Plots.plot!(p, zero)
    for i in 1:steps
        Plots.plot!(p, [xs[i],xs[i],xs[i+1]], [0,f(xs[i]), 0])
        Plots.scatter!(p, xs[i:i],[0])
    end
    Plots.scatter!(p, [xs[steps+1]], [0])
    p
end
