import AbstractPlotting: plot, plot!, scatter, scatter!

@info "Loading some plot recipes for Makie"




# some plotting utilities
export plotif, trimplot, signchart
export arrow!, vectorfieldplot!
export newton_vis

###

#  plot "recipe" for functions


function AbstractPlotting.plot(f::Function, a::Number, b::Number, args...; kwargs...)
    xs = range(float(a), float(b), length=500)
    AbstractPlotting.plot(xs, f.(xs), args...; kwargs...)
end

function  AbstractPlotting.plot!(scene::AbstractPlotting.Scene, f::Function, args...; kwargs...)
    rect = scene.data_limits[]
    a, b = rect.origin[1],  rect.origin[1] + rect.widths[1]
    xs = range(a, b, length=500)
    AbstractPlotting.plot!(scene, xs, f.(xs), args...;  kwargs...)
end

AbstractPlotting.plot!(f::Function, args...; kwargs...) = AbstractPlotting.plot!(AbstractPlotting.current_scene(), f, args...; kwargs...)


#  plot "recipe" for 2D parametric functions
function AbstractPlotting.plot(f::Function, g::Function, a::Number, b::Number, args...; kwargs...)
    xs = range(float(a), float(b), length=500)
    AbstractPlotting.lines(f.(xs), g.(xs), args...; kwargs...)
end

function  AbstractPlotting.plot!(scene::AbstractPlotting.Scene, f::Function, g::Function, a::Number, b::Number, args...; kwargs...)
    xs = range(a, stop=b, length=500)
    AbstractPlotting.plot!(scene, f.(xs), g.(xs), args...;  kwargs...)
end
AbstractPlotting.plot!(f::Function, g::Function, a::Number, b::Number, args...; kwargs...) =
    AbstractPlotting.plot!(AbstractPlotting.current_scene(), f, g, a, b, args...; kwargs...)



#  plot reciple  for SymPy objects
AbstractPlotting.plot(ex::Sym, a::Number, b::Number; kwargs...) = AbstractPlotting.plot(lambdify(ex), a, b; kwargs...)
AbstractPlotting.plot!(ex::Sym; kwargs...) = AbstractPlotting.plot!(lambdify(ex); kwargs...)

AbstractPlotting.plot(ex1::Sym, ex2::Sym,  a::Number, b::Number; kwargs...) =
    AbstractPlotting.plot(lambdify(ex1), lambdify(ex2), a, b; kwargs...)
AbstractPlotting.plot!(ex1::Sym, ex2::Sym,  a::Number, b::Number; kwargs...) =
    AbstractPlotting.plot!(lambdify(ex1), lambdify(ex2), a,b; kwargs...)


# Plot of tuple
# d= 1
# d>1 parametric
function AbstractPlotting.plot(fs::Tuple, a::Number, b::Number; kwargs...)
    xs = range(a, stop=b, length=500)
    ys = [ [f(x) for x in xs] for f in fs]
    if length(ys) == 1
        AbstractPlotting.lines(xs, ys[1]; kwargs...)
    else
        AbstractPlotting.lines(ys...; kwargs...)
    end
end

function AbstractPlotting.plot!(fs::Tuple, args...; kwargs...)
    xs = range(args[1], stop=args[2], length=500)
    ys = [ [f(x) for x in xs] for f in fs]
    AbstractPlotting.plot!(ys...; kwargs...)
end


## Parametric surface plot
using GeometryBasics
function make_vertices(r, xs, ys)
    [Point3f0(r(u,v))  for v in ys for u in xs]
end

# single row of faces
function make_facesⱼ(xs, ys, j)
    nx, ny = length(xs), length(ys)
    geti = (i,j) -> (j-1)*nx + (i-1) + 1
    faces = TriangleFace{Int}[]
    for i in 1:nx-1
        f1 = TriangleFace(geti(i,j), geti(i,j+1), geti(i+1,j+1))
        f2 = TriangleFace(geti(i+1,j+1), geti(i,j), geti(i+1,j))        
        append!(faces, (f1, f2))
    end

    faces
end


parametric_surface_plot(r, xs, ys; kwargs...) = parametric_surface_plot!(Scene(), r, xs, ys; kwargs...)
function parametric_surface_plot!(scene, r, xs, ys; kwargs...)
    nx, ny = length(xs), length(ys)

    vertices = make_vertices(r, xs, ys)

    for j in 1:ny-1
        facesⱼ =  make_facesⱼ(xs, ys, j)
        wireframe!(scene, GeometryBasics.Mesh(vertices, facesⱼ); kwargs...)
    end

    scene
end
export parametric_surface_plot, parametric_surface_plot!

##
## --------------------------------------------------
##

"""
   trimplot(f, a, b, c=20; kwargs...)

Plot f over [a,b] but break graph if it exceeds c in absolute value.
"""
function trimplot(f, a, b, c=20; kwargs...)
    plot(x -> abs(f(x)) <= c ? f(x) : NaN, a, b; kwargs...)
end




"""
    plotif(f, g, a, b)

Plot f colored depending on g >= 0 or not.
"""
function plotif(f, g, a, b)
    xs = range(a, b, length=251)
    cols = identify_colors(g, xs)
    cols = push!(cols, cols[end])
    lines(xs, f, color=cols, linewidth=10)
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
using AbstractPlotting
r(t) = [sin(t), cos(t), t]
rp(t) = [cos(t), -sin(t), 1]
lines(unzip(r, 0, 2pi)...)
t0 = 1
arrow!(r(t0), r'(t0))
```
"""
function arrow!(scene::AbstractPlotting.Scene, p, v; kwargs...)
    P = length(p) == 3 ? Point3f0 : Point2f0
    AbstractPlotting.arrows!(P.([p]), P.([v]); kwargs...)
end
arrow!(p,v;kwargs...) = arrow!(AbstractPlotting.current_scene(), p, v; kwargs...)

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
function vectorfieldplot( V; xlim=(-5,5), ylim=(-5,5), n=10, kwargs...)

    V′(x) = Point2f0(V(x...)...)
    AbstractPlotting.streamplot(V′, xlim[1]..xlim[2], ylim[1]..ylim[2]; kwargs...)
end
function vectorfieldplot!(scene::AbstractPlotting.Scene, V; xlim=(-5,5), ylim=(-5,5), n=10, kwargs...)

    V′(x) = Point2f0(V(x...)...)
    AbstractPlotting.streamplot!(scene, V′, xlim[1]..xlim[2], ylim[1]..ylim[2]; kwargs...)
end
vectorfieldplot!(V; kwargs...) =
    vectorfieldplot!(AbstractPlotting.current_scene(), V; kwargs...)

## --------------------------------------------------

##
# visualize newtons method
function newton_vis(f, x0, a=Inf,b=-Inf; steps=5, kwargs...)
    xs = Float64[x0]
    for i in 1:steps
        xᵢ = xs[end]
        xᵢ₊₁ = xᵢ - f(xᵢ)/f'(xᵢ)
        push!(xs, xᵢ₊₁)
    end

    m,M = extrema(xs)
    m = min(m, a)
    M = max(M, b)

    p = plot(f, m, M; linewidth=3,  kwargs...)
    plot!([m,M], [0,0])
    plot!(p, zero)
    for i in 1:steps
        plot!(p, [xs[i],xs[i],xs[i+1]], [0,f(xs[i]), 0])
        scatter!(p, xs[i:i],[0], markersize=1)
    end
    scatter!(p, [xs[steps+1]], [0], markersize=1)
    p
end

