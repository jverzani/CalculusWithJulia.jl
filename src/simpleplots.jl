import SimplePlots: plot, plot!, scatter, scatter!

# some plotting utilities
export plotif, trimplot, signchart
export arrow!, vectorfieldplot!
export newton_vis

###
include("demos.jl")

#  plot "recipe" for functions
function SimplePlots.plot(f::Function, a::Number, b::Number, args...; kwargs...)
    xs = range(float(a), float(b), length=500)
    plot(xs, f.(xs), args...; kwargs...)
end

function  SimplePlots.plot!(plt::SimplePlots.SimplePlot, f::Function, a::Number, b::Number, args...;  kwargs...)
    xs = range(float(a), float(b), length=500)
    plot!(plt, xs, f.(xs);  kwargs...)
end
SimplePlots.plot!(f::Function, args...; kwargs...) = SimplePlots.plot!(SimplePlots._plot, f, args...; kwargs...)

function  SimplePlots.plot!(plt::SimplePlots.SimplePlot, f::Function;  kwargs...)
    xs = plt.data[1]["x"]
    plot!(plt, xs, f.(xs);  kwargs...)
end


#  plot "recipe" for parametric functions
function SimplePlots.plot(f::Function, g::Function, a::Number, b::Number, args...; kwargs...)
    xs = range(float(a), float(b), length=500)
    plot(f.(xs), g.(xs), args...; kwargs...)
end

function  SimplePlots.plot!(plt::SimplePlots.SimplePlot, f::Function, g::Function, a::Number, b::Number, args...; kwargs...)
    xs = range(a, stop=b, length=500)
    plot!(plt, xs, f.(xs), args...;  kwargs...)
end
SimplePlots.plot!(f::Function, g::Function, a::Number, b::Number, args...; kwargs...) = SimplePlots.plot!(SimplePlots._plot, f, g, a, b, args...; kwargs...)



#  plot reciple  for SymPy objects
SimplePlots.plot(ex::Sym, a::Number, b::Number; kwargs...) = plot(lambdify(ex), a, b; kwargs...)
SimplePlots.plot!(ex::Sym; kwargs...)    = plot!(lambdify(ex); kwargs...)

SimplePlots.plot(ex1::Sym, ex2::Sym,  a::Number, b::Number; kwargs...) = plot(lambdify(ex1), lambdify(ex2), a, b; kwargs...)
SimplePlots.plot!(ex1::Sym, ex2::Sym,  a::Number, b::Number; kwargs...) =
    plot!(lambdify(ex1), lambdify(ex2), a,b; kwargs...)


# Plot of tuple 
function SimplePlots.plot(fs::Tuple, a::Number, b::Number; kwargs...)

    xs = range(a, stop=b, length=500)
    ys = [ [f(x) for x in xs] for f in fs]
    if length(ys) == 1
        plot(xs, ys[1]; kwargs...)
    else
        plot(ys...; kwargs...)
    end
end

function SimplePlots.plot!(fs::Tuple, args...; kwargs...)
    if length(fs) == 1
        xs = plt.data[1]["x"]
        plot!(xs, fs[1].(xs); kwargs...)
    else
        xs = range(args[1], stop=args[2], length=500)
        ys = [ [f(x) for x in xs] for f in fs]
        plot!(ys...; kwargs...)
    end
end

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
  p = plot(us, vs, xlim=(a, b), legend=false, kwargs...)
  for (x,y) in zip(xs, ys)
    if abs(y) <= c
       push!(us, x); push!(vs, y)
    else
      length(us) > 0 && plot!(p, us, vs, color=1)
      empty!(us); empty!(vs)
    end
 end
 length(us) > 0 && plot!(p, us, vs, color=1)
 p
end



"""
    plotif(f, g, a, b)

Plot f colored depending on g >= 0 or not.
"""
function plotif(f, g, a, b, args...; colors=(1,2), linewidth=5, legend=false,  kwargs... )


    xs = a:(b-a)/251:b
    zs = f.(xs)
    p = plot(xs, f.(xs), args...; color=colors[1], linewidth=linewidth, legend=legend, kwargs...)

    ys = g.(xs)
    ys[ys .< 0] .= NaN

    us,vs = Float64[], Float64[]
    for (i,y) in enumerate(ys)
        if isnan(y)
            if length(vs) > 1
                plot!(p, us, vs, color=colors[2], linewidth=5)
            end
            empty!(us)
            empty!(vs)
        else
            push!(us, xs[i])
            push!(vs, zs[i])
        end
    end
    if length(vs) > 1
        plot!(p, us, vs, color=colors[2], linewidth=5)
    end
    p
end

"""
   signchart(f, a, b)

Plot f over a,b with different color when negative.
"""
function signchart(f, a, b)
    p = plotif(f, f, a, b)
    plot!(p, zero)
    p
end



"""
   `arrow!(p, v)`

Add the vector `v` to the plot anchored at `p`.

This would just be a call to `quiver`, but there is no 3-D version of that. As well, the syntax for quiver is a bit awkward for plotting just a single arrow. (Though efficient if plotting many).

```
using SimplePlots
r(t) = [sin(t), cos(t), t]
rp(t) = [cos(t), -sin(t), 1]
plot(unzip(r, 0, 2pi)...)
t0 = 1
arrow!(r(t0), r'(t0))
```
"""
function arrow!(plt, p, v; kwargs...)
#function arrow!(plt::SimplePlots.plot, p, v; kwargs...)
  if length(p) == 2
     quiver!(plt, unzip([p])..., quiver=Tuple(unzip([v])); kwargs...)
  elseif length(p) == 3
    # 3d quiver needs support
    # https://github.com/JuliaPlots/Plots.jl/issues/319#issue-159652535
    # headless arrow instead
    plot!(plt, unzip(p, p+v)...; kwargs...)
	end
end
#arrow!(p,v;kwargs...) = arrow!(Plots.current(), p, v; kwargs...)

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

    quiver!(plt, unzip(ps)..., quiver=unzip(λ * vs))

end
vectorfieldplot!(V; kwargs...) = vectorfieldplot!(SimplePlots.current(), V; kwargs...)

