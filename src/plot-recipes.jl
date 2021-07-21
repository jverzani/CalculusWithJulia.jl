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
        quiver := unzip([dv])
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
