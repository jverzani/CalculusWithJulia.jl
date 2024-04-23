module CalculusWithJuliaPlotsExt

using CalculusWithJulia
import CalculusWithJulia:
    ClosedInterval,
    find_colors, identify_colors
import CalculusWithJulia:
    plotif, trimplot, signchart,
    plot_polar, plot_polar!,
    plot_parametric, plot_parametric!,
    plot_implicit_surface,
    vectorfieldplot,   vectorfieldplot!,
    arrow3d,
    newton_vis, newton_plot!,
    riemann_plot, riemann_plot!,
    implicit_plot, implicit_plot!,
    arrow, arrow!

import Plots
import Plots: plot, plot!, scatter, scatter!, Shape, current,
    surface, surface!,
    quiver, quiver!

using Plots.RecipesBase
import Contour

# just show body, not standalone
function Plots._show(io::IO, ::MIME"text/html", plt::Plots.Plot{Plots.PlotlyBackend})
    write(io, Plots.html_body(plt))
end

# -----

# use rangeclamp
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
    plot(xs, f.(xs), colors=cols, legend=legend, kwargs...)
end

function plotif(f, g, a, b)
    xs = range(a, b, length=251)
    cols = identify_colors(g, xs)
    plot(xs, f.(xs), color=cols, legend=false)
end

function signchart(f, a, b)
    p = plotif(f, f, a, b)
    plot!(p, zero)
    p
end

adapted_grid = CalculusWithJulia.PlotUtils.adapted_grid
function xyzs(ab::ClosedInterval, r)
    a, b = abs = extrema(ab)
    xs = sort(union([adapted_grid(t -> r(t)[i], abs)[1] for i in eachindex(r(a))]...))
    unzip(r.(xs))
end

plot_parametric(ab::ClosedInterval, r; kwargs...) = plot(xyzs(ab, r)...; kwargs...)
plot_parametric!(ab::ClosedInterval, r; kwargs...) = plot!(xyzs(ab, r)...; kwargs...)

plot_polar(ab::ClosedInterval, r; kwargs...) =
    plot_parametric(ab, t->[r(t)*cos(t), r(t)*sin(t)]; kwargs...)
plot_polar!(ab::ClosedInterval, r; kwargs...) =
    plot_parametric!(ab, t->[r(t)*cos(t), r(t)*sin(t)]; kwargs...)

function XYZs(u::ClosedInterval, v::ClosedInterval, r; n=51)
    us = range(extrema(u)..., length=n)
    vs = range(extrema(v)..., length=n)
    unzip(r.(us', vs))  # Plots.jl style; flip for Makie
end

# needs plotly(); not gr()
plot_parametric(u::ClosedInterval, v::ClosedInterval, F;  kwargs...) =
    surface(XYZs(u,v,F)...;  kwargs..., )
plot_parametric!(u::ClosedInterval, v::ClosedInterval, F; kwargs...) =
    surface!(XYZs(u,v,F)...;  kwargs...)


function plot_implicit_surface(F, c=0;
                       xlim=(-5,5), ylim=xlim, zlim=xlim,
                       nlevels=25,         # number of levels in a direction
                       slices=Dict(:z => :blue), # Dict(:x => :color, :y=>:color, :z=>:color)
                       kwargs...          # passed to initial `plot` call
                       )

    _linspace(rng, n=150) = range(extrema(rng)..., n)

    X1, Y1, Z1 = _linspace(xlim), _linspace(ylim), _linspace(zlim)

    p = plot(;legend=false,kwargs...)

    if :x ∈ keys(slices)
        for x in _linspace(xlim, nlevels)
            local X1 = [F(x,y,z) for y in Y1, z in Z1]
            cnt = Contour.contours(Y1,Z1,X1, [c])
            for line in Contour.lines(Contour.levels(cnt)[1])
                ys, zs = Contour.coordinates(line) # coordinates of this line segment
                plot!(p, x .+ 0 * ys, ys, zs, color=slices[:x])
          end
        end
    end

    if :y ∈ keys(slices)
        for y in _linspace(ylim, nlevels)
            local Y1 = [F(x,y,z) for x in X1, z in Z1]
            cnt = Contour.contours(Z1,X1,Y1, [c])
            for line in Contour.lines(Contour.levels(cnt)[1])
                xs, zs = Contour.coordinates(line) # coordinates of this line segment
                plot!(p, xs, y .+ 0 * xs, zs, color=slices[:y])
            end
        end
    end

    if :z ∈ keys(slices)
        for z in _linspace(zlim, nlevels)
            local Z1 = [F(x, y, z) for x in X1, y in Y1]
            cnt = Contour.contours(X1, Y1, Z1, [c])
            for line in Contour.lines(Contour.levels(cnt)[1])
                xs, ys = Contour.coordinates(line) # coordinates of this line segment
                plot!(p, xs, ys, z .+ 0 * xs, color=slices[:z])
            end
        end
    end


    p
end


## 3D Arrow function by Rafael Guerra https://discourse.julialang.org/t/plot-with-sticks-or-arrows/68422/14; modified for
## See comment here about possible issue: https://discourse.julialang.org/t/tube-plots/65999/9
# as: arrow head size 0-1 (fraction of arrow length)
# la: arrow alpha transparency 0-1
function arrow3d!(p, x, y, z,  u, v, w; as=0.1, lc=:black, la=1, lw=0.4, scale=:identity)
    (as < 0) && (nv0 = -maximum(norm.(eachrow([u v w]))))
    for (x,y,z, u,v,w) in zip(x,y,z, u,v,w)
        nv = sqrt(u^2 + v^2 + w^2)
        v1, v2 = -[u,v,w]/nv, nullspace([u v w])[:,1]
        v4 = (3*v1 + v2)/3.1623  # sqrt(10) to get unit vector
        v5 = v4 - 2*(v4'*v2)*v2
        (as < 0) && (nv = nv0)
        v4, v5 = -as*nv*v4, -as*nv*v5
        plot!(p, [x,x+u], [y,y+v], [z,z+w], lc=lc, la=la, lw=lw, scale=scale, label=false)
        plot!(p, [x+u,x+u-v5[1]], [y+v,y+v-v5[2]], [z+w,z+w-v5[3]], lc=lc, la=la, lw=lw, label=false)
        plot!(p, [x+u,x+u-v4[1]], [y+v,y+v-v4[2]], [z+w,z+w-v4[3]], lc=lc, la=la, lw=lw, label=false)
    end
    p
end

function arrow!(plt, p, v; kwargs...)
  if length(p) == 2
      quiver!(plt, unzip([p])..., quiver=Tuple(unzip([v])); kwargs...)
  elseif length(p) == 3
      # 3d quiver needs support
      # https://github.com/JuliaPlots/Plots.jl/issues/319#issue-159652535
      # headless arrow instead
      #plot!(plt, unzip(p, p+v)...; kwargs...)
      ## use the above instead
      arrow3d!(plt, unzip(p,p+v)...; kwargs...)
  end
end
arrow!(p,v; kwargs...) = arrow!(current(), p, v; kwargs...)

function vectorfieldplot!(plt, V; xlim=(-5,5), ylim=(-5,5), n=10, kwargs...)

    dx, dy = (xlim[2]-xlim[1])/n, (ylim[2]-ylim[1])/n
    xs, ys = xlim[1]:dx:xlim[2], ylim[1]:dy:ylim[2]

    ps = [[x,y] for x in xs for y in ys]
    vs = V.(ps)
    λ = 0.9 * min(dx, dy) /maximum(norm.(vs))

    quiver!(plt, unzip(ps)..., quiver=unzip(λ * vs))

end
vectorfieldplot!(V; kwargs...) = vectorfieldplot!(current(), V; kwargs...)


# various recipes for Plots.jl

"""
   trimplot(f, a, b, c=20; kwargs...)

Plot f over [a,b] but break graph if it exceeds c in absolute value.
"""
@userplot TrimPlot
@recipe function __(a::TrimPlot)
    if length(a.args) < 4
        f, x0, x1 = a.args
        c = 20
    else
        f, x0, x1, c = a.args
    end

    xs = range(x0, x1, length=251)
    ys = f.(xs)

    Xs = Any[]
    Ys = Any[]

    us, vs = Real[], Real[]
    for (x,y) in zip(xs, ys)
        if abs(y) <= c
            push!(us, x); push!(vs, y)
        else
            if length(us) > 0
                push!(Xs, copy(us))
                push!(Ys, copy(vs))
            end
            empty!(us); empty!(vs)
        end
    end
    if length(us) > 0
        push!(Xs, copy(us))
        push!(Ys, copy(vs))
    end

    seriestype := :path
    x := Xs
    y := Ys


    Xs, Ys
end


"""
    plotif(f, g, a, b)

Plot f colored depending on g < 0 or not.
"""
@userplot PlotIf
@recipe function __(a::PlotIf)
    f, g, x0, x1 = a.args
    xs = range(x0, x1, length=251)
    ys = f.(xs)

    seriestype := :path
    x := xs
    y := ys
    color := [gx < 0 ? :red : :blue for gx in g.(xs)]
    linewidth := 5
    legend := false

    xs, ys
end


@userplot SignChart
@recipe function __(a::SignChart)
    f, x0, x1 = a.args
    xs = range(x0, x1, length=251)
    ys = f.(xs)
    zs = zeros(length(xs))
    @series begin
        seriestype := :path
        x := xs
        y := zs
        linewidth := 1
        color := :black
        xs, zs
    end

    seriestype := :path
    x := xs
    y := ys
    color := [y < 0 ? :red : :blue for y in ys]

    linewidth --> 5
    legend --> false

    xs, ys
end

#### Multidimensional

# """
#     plot_polar(r, a, b; [n=251]

# Create a polar plot of `r(theta)` for `a <= theta <= b`.

# An alternative to the three step approach:

# ```
# ts = range(a, b, length=n)
# rs = r.(ts)
# plot(ts, rs, proj=:polar, legend=false)
# ```


# """
# @userplot Plot_Polar
# @recipe function __(rt::Plot_Polar; n=251)

#     r, a, b = rt.args
#     fn = t -> r(t) * [cos(t), sin(t)]
#     ts = range(a, stop=b, length=n)
#     xs = fn.(ts)

#     xys = unzip(xs)
#     seriestype := :path
#     x := xys[1]
#     y := xys[2]
#     xys
# end

# """
#     plot_parametric_curve(r, a, b; [n=251])

# For `r` taking `R -> R^n` make a plot over [a,b] using n points.

# There are other ways to produce this plot:
# * if we have two functions, `rx` and `ry` say, then passing as function arguments should work

# ```
# plot(rx, ry, a, b)
# ```

# * if we have a vector-valued function, then either of these work:

# ```
# r(t) = [cos(t), sin(t), t]
# plot(unzip(r, a, b, n)...)  # unzip reshapes the data
# plot_parametric_curve(r, a, b)
# ```

# We see that this function is a convenience for vector-valued descriptions of parameterized curves.
# """
# @userplot Plot_Parametric_Curve
# @recipe function __(r::Plot_Parametric_Curve; n=251)

#     f, a, b = r.args
#     ts = range(a, stop=b, length=n)
#     xs = f.(ts)

#     n = length(first(xs))
#     if n == 2
#         xys = unzip(xs)
#         seriestype := :path
#         x := xys[1]
#         y := xys[2]
#         xys
#     else
#         xyzs = unzip(xs)
#         seriestype := :path3d
#         x := xyzs[1]
#         y := xyzs[2]
#         z := xyzs[3]
#         xyzs
#     end
# end



# """
#     plot_parametric_surface(F, [xlim=(-5,5)], [ylim=(-5,5)], [nx=50], [ny=50])

# Plot the paremeterized surface described by `F:R^2 -> R^3`. This works with `pyplot` and `plotly`, but not `gr`.

# A surface `(x,y,f(x,y))` can be directly plotted with `surface` as:

# ```
# surface(xs, ys, f)
# ```

# where `xs` and `ys` provide a grid to plot over.

# For parametrically described surfaces, the above doesn't work. This function provides an interface:

# ```
# F(u,v) = [u*cos(v), u*sin(v), u] # a cone
# plot_parametric_surface(F, xlim=(0, 1), ylim=(0,2pi))
# ```

# The values of `xlim` are used as the range to plot over; `nx` specifies the number of points to use. Similarly for `ylim`.
# """
# @userplot Plot_Parametric_Surface
# @recipe function __(r::Plot_Parametric_Surface; nx=50, ny=50)

#     F = first(r.args)

#     xlim = get(plotattributes,:xlims, (-5,5))
#     ylim = get(plotattributes,:ylims, (-5,5))



#     us = range(xlim[1], xlim[2], length=nx)
#     vs = range(ylim[1], ylim[2], length=ny)
#     ws = unzip(F.(us, vs'))

#     seriestype := :surface
#     x := ws[1]
#     y := ws[2]
#     z := ws[3]
#     xlims := extrema(ws[1])
#     ylims := extrema(ws[2])
#     ws

# end

"""
   arrow(p, v)

Add vector, `v`, to plot anchored at point `p`.

Example
```
Fn = parametric(t -> [2cos(t), 3sin(t)])
Fnp = t -> ForwardDiff.derivative(Fn, t)
p = plot(Fn, 0, 2pi, legend=false)
for t in 0:pi/4:pi
   arrow!(Fn(t), Fnp(t))
end
p
```
"""
@userplot Arrow
@recipe function __(a::Arrow)
    v0, dv0 = a.args
    v = [v0...]; dv = [dv0...]
    if length(v) == 2
        seriestype := :quiver
        quiver := Tuple(unzip([dv]))
        x,y = unzip([v])
        x := x
        y := y
        ()
    else
        seriestype := :path3d
        M = hcat(v, v + dv)'
        (M[:,1],M[:,2], M[:,3])
    end

end

"""
    vectorfieldplot(F; [xlim=(-5,5)], [ylim=(-5,5)], [nx=8], [ny=8])

Create a vector field plot using a grid described by `xlim`, `ylim` with `nx` and `ny` grid points in each direction.

```
F(x,y) = [-y, x]
vectorfieldplot(F, xlim=(-4,4), ylim=(-4,4))
```
"""
@userplot VectorFieldPlot
@recipe function __(V::VectorFieldPlot; nx=8, ny=8)

    ars = V.args
    F = ars[1]
    xlim = get(plotattributes,:xlims, (-5,5))
    ylim = get(plotattributes,:ylims, (-5,5))

    dx, dy = (xlim[2]-xlim[1])/(nx-1), (ylim[2]-ylim[1])/(ny-1)
    xs, ys = xlim[1]:dx:xlim[2], ylim[1]:dy:ylim[2]

    ps = [[x,y] for x in xs for y in ys]
    vs = (xy -> F(xy[1], xy[2])).(ps)


    λ = 0.9 * minimum([u/maximum(getindex.(vs,i)) for (i,u) in enumerate((dx,dy))])

    seriestype := :quiver
    quiver := unzip(λ * vs)
    xs, ys = unzip(ps)
        x := xs
    y := ys
    ()
end

"""
    vectorfieldplot3d(F; [xlim=(-5,5)], [ylim=(-5,5)], [nx=5], [ny=5])

Create a 3 dimensional vector field plot using a grid described by `xlim`, `ylim`, `zlim` with `nx`, `ny`, and `nz` grid points in each direction.

Note: the vectors are represented with line, not arrow due to no implementation of `:quiver3d`.

```
F(x,y,z) = [-y, x,z]
vectorfieldplot3d(F, xlims=(-4,4), ylims=(-4,4), zlims=(0,3))
```
"""
@userplot VectorFieldPlot3d
@recipe function __(V::VectorFieldPlot3d;  nx=5, ny=5, nz=5)
    ars = V.args
    F = ars[1]
    xlim = get(plotattributes,:xlims, (-5,5))
    ylim = get(plotattributes,:ylims, (-5,5))
    zlim = get(plotattributes,:zlims, (-5,5))

    dx, dy, dz = (xlim[2]-xlim[1])/(nx-1), (ylim[2]-ylim[1])/(ny-1), (zlim[2]-zlim[1])/(nz-1)
    xs, ys, zs = xlim[1]:dx:xlim[2], ylim[1]:dy:ylim[2], zlim[1]:dz:zlim[2]

    ps = [[x,y,z] for x in xs for y in ys for z in zs]
    vs = (xyz -> F(xyz[1], xyz[2], xyz[3])).(ps)


    λ = 0.9 * minimum([u/maximum(getindex.(vs,i)) for (i,u) in enumerate((dx,dy,dx))])

    seriestype := :path3d
    dxs, dys, dzs = unzip(λ * vs)
    xs, ys, zs = unzip(ps)

    legend := false
    [[x,dx] for (x,dx) in zip(xs, xs+dxs)],    [[y,dy] for (y,dy) in zip(ys, ys+dys)],    [[z,dz] for (z,dz) in zip(zs, zs+dzs)]
end


## the ImplicitPlots.jl package has a lot of packages that need updating
## This copies over the necessary bits, leaving the fancier for later
## Copied from the MIT licensed
## https://github.com/saschatimme/ImplicitPlots.jl/blob/master/src/ImplicitPlots.jl
struct ImplicitFunction{N,F}
    f::F
end
ImplicitFunction{N}(f) where {N} = ImplicitFunction{N,typeof(f)}(f)
(IF::ImplicitFunction{2})(x, y) = IF.f(x, y)
ImplicitFunction(f) = ImplicitFunction{2}(f)

@recipe function implicit(f::ImplicitFunction{2}; aspect_ratio = :equal, resolution = 400)
    xlims --> (-5.0, 5.0)
    xlims = plotattributes[:xlims]
    ylims --> xlims
    ylims = plotattributes[:ylims]

    linewidth --> 1
    grid --> true
    aspect_ratio := aspect_ratio

    rx = range(xlims[1]; stop = xlims[2], length = resolution)
    ry = range(ylims[1]; stop = ylims[2], length = resolution)
    z = [f(x, y) for x in rx, y in ry]

    nplot = plotattributes[:plot_object].n
    lvl = Contour.contour(collect(rx), collect(ry), z, 0.0)
    lines = Contour.lines(lvl)
    !isempty(lines) || return p

    clr = get(plotattributes, :linecolor, :dodgerblue)
    for (k, line) in enumerate(lines)
        xs, ys = Contour.coordinates(line)
        @series begin
            seriestype := :path
            linecolor --> clr
            if k > 1
                label := ""
            end
            xs, ys
        end
    end
end
implicit_plot(f; kwargs...) = Plots.RecipesBase.plot(ImplicitFunction(f); kwargs...)
implicit_plot!(f; kwargs...) = Plots.RecipesBase.plot!(ImplicitFunction(f); kwargs...)
implicit_plot!(p::Plots.RecipesBase.AbstractPlot, f; kwargs...) =
    Plots.RecipesBase.plot!(p, ImplicitFunction(f); kwargs...)


## simple visualization
## ----
# don't like should just provide ! method
function newton_vis(f, x0, a=Inf,b=-Inf; steps=5, kwargs...)
    xs = Float64[x0]
    for i in 1:steps
        push!(xs, xs[end] - f(xs[end]) / f'(xs[end]))
    end

    m,M = extrema(xs)
    m = min(m, a)
    M = max(M, b)

    p = plot(f, m, M; linewidth=3, legend=false, kwargs...)
    plot!(p, zero)
    for i in 1:steps
        plot!(p, [xs[i],xs[i],xs[i+1]], [0,f(xs[i]), 0])
        scatter!(p, xs[i:i],[0])
    end
    scatter!(p, [xs[steps+1]], [0])
    p
end

function newton_plot!(f, x0; steps=5, annotate_steps::Int=0,
                     fill=nothing,kwargs...)
    xs, ys = Float64[x0], [0.0]
    for i in 1:steps
        xᵢ = xs[end]
        xᵢ₊₁ = xᵢ - f(xᵢ)/f'(xᵢ)
        append!(xs, [xᵢ, xᵢ₊₁]), append!(ys, [f(xᵢ), 0])
    end
    plot!(xs, ys; fill, kwargs...)

    if annotate_steps > 0
        anns = [(x,0,text("x$(i-1)", :top)) for
                (i,x) ∈ enumerate(xs[1:2:2annotate_steps])]
        annotate!(anns)
    end
    current()
end


function riemann_plot(f, a, b, n; method="right", fill=nothing, kwargs...)
    plot(f, a, b; legend=false, kwargs...)
    riemann_plot!(f, a, b, n; method, fill, kwargs...)
end

# riemann_plot!(sin, 0, pi/2, 2; method="simpsons", fill=(:green, 0.25, 0))
function riemann_plot!(f, a, b, n; method="right",
                      linecolor=:black, fill=nothing, kwargs...)
    if method == "right"
        shape = (l, r, f) -> begin
            Δ = r - l
            Shape(l .+ [0, Δ, Δ, 0, 0], [0, 0, f(r), f(r), 0])
        end
    elseif method == "left"
        shape = (l, r, f) -> begin
            Δ = r - l
            Shape(l .+ [0, Δ, Δ, 0, 0], [0, 0, f(l), f(l), 0])
        end
    elseif method == "trapezoid"
        shape = (l, r, f) -> begin
            Δ = r - l
            Shape(l .+ [0, Δ, Δ, 0, 0], [0, 0, f(r), f(l), 0])
        end
    elseif method == "simpsons"
        shape = (l, r, f) -> begin
            Δ = r - l
            a, b, m = l, r, l + (r-l)/2
            parabola = x -> begin
                tot =  f(a) * (x-m) * (x-b) / (a-m) / (a-b)
                tot += f(m) * (x-a) * (x-b) / (m-a) / (m-b)
                tot += f(b) * (x-a) * (x-m) / (b-a) / (b-m)
                tot
            end
            xs = range(0, Δ, 3)
            Shape(l .+ vcat(reverse(xs), xs, Δ),
                  vcat(zero.(xs), parabola.(l .+ xs), 0))
        end
    end
    xs = range(a, b, n + 1)
    ls, rs = Base.Iterators.take(xs, n), Base.Iterators.rest(xs, 1)
    for (l, r) ∈ zip(ls, rs)
        plot!(shape(l, r, f); linecolor, fill, kwargs...)
    end
    current()
end


end
