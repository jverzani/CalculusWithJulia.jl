export plotif, trimplot, signchart
export arrow!, vectorfieldplot!
export newton_vis


##
## --------------------------------------------------
##

"""
   trimplot(f, a, b, c=20; kwargs...)

Plot f over [a,b] but break graph if it exceeds c in absolute value.
"""
function trimplot(f, a, b, c=20; kwargs...)
    xs = range(a, stop=b, length=251)
    ys = f.(xs)
    
    us, vs = Real[NaN], Real[NaN]
    p = Plots.plot(us, vs, xlim=(a, b), legend=false, kwargs...)
    for (x,y) in zip(xs, ys)
        if abs(y) <= c
            push!(us, x); push!(vs, y)
        else
            length(us) > 0 && Plots.plot!(p, us, vs, color=1)
            empty!(us); empty!(vs)
        end
    end
    length(us) > 0 && Plots.plot!(p, us, vs, color=1)
    p
end


"""
    plotif(f, g, a, b)

Plot f colored depending on g >= 0 or not.
"""
function plotif(f, g, a, b, args...; colors=(1,2), linewidth=5, legend=false,  kwargs... )


    xs = a:(b-a)/251:b
    zs = f.(xs)
    p = Plots.plot(xs, f.(xs), args...; color=colors[1], linewidth=linewidth, legend=legend, kwargs...)

    ys = g.(xs)
    ys[ys .< 0] .= NaN

    us,vs = Float64[], Float64[]
    for (i,y) in enumerate(ys)
        if isnan(y)
            if length(vs) > 1
                Plots.plot!(p, us, vs, color=colors[2], linewidth=5)
            end
            empty!(us)
            empty!(vs)
        else
            push!(us, xs[i])
            push!(vs, zs[i])
        end
    end
    if length(vs) > 1
        Plots.plot!(p, us, vs, color=colors[2], linewidth=5)
    end
    p
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

