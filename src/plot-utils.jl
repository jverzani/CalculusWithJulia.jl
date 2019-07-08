# some plotting utilities

"""
   trimplot(f, a, b, c=20; kwargs...)

Plot f over [a,b] but break graph if it exceeds c in absolute value.
"""
function trimplot(f, a, b, c=20; kwargs...)
  xs = range(a, stop=b, length=251)
  ys = f.(xs)

  us, vs = Real[], Real[]
  p = plot(us, vs, xlim=(a, b), legend=false, kwargs...)
  for (x,y) in zip(xs, ys)
    if abs(y) <= c
       push!(us, x); push!(vs, y)
    else
      length(us) > 0 && plot!(p, us, vs, color=:blue)
      empty!(us); empty!(vs)
    end
 end
 length(us) > 0 && plot!(p, us, vs, color=:blue)
 p
end


"""
    plotif(f, g, a, b)

Plot f colored depending on g < 0 or not.
"""
function plotif(f, g, a, b)
       xs = range(a, stop=b, length=251)
       ys = f.(xs)
       cols = [gx < 0 ? :red : :blue for gx in g.(xs)]
       p = plot(xs, ys, color=cols, linewidth=5, legend=false)
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



#### Multidimensional


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
function arrow!(plt::Plots.Plot, p, v; kwargs...)
    if length(p) == 2
        quiver!(plt, unzip([p])..., quiver=Tuple(unzip([v])); kwargs...)
    elseif length(p) == 3
        # 3d quiver needs support
        # https://github.com/JuliaPlots/Plots.jl/issues/319#issue-159652535
        # headless arrow instead
        plot!(plt, unzip([p, p+v])...; kwargs...)
    end
    plt
end
arrow!(p,v;kwargs...) = arrow!(Plots.current(), p, v; kwargs...)


"""
    vectorfieldplot!(plt, V; xlim, ylim, n, kwargs...)

Add a 2-D vector field. `V` a function `[x,y] -> [V1(x,y), V2(x,y)]`.
"""
function vectorfieldplot!(plt, V; xlim=(-5,5), ylim=(-5,5), n=10, kwargs...)

    dx, dy = (xlim[2]-xlim[1])/n, (ylim[2]-ylim[1])/n
    xs, ys = xlim[1]:dx:xlim[2], ylim[1]:dy:ylim[2]
    _vectorfieldplot2d(plt, V, xs, ys, dx, dy; kwargs...)

end
vectorfieldplot!(V; kwargs...) = vectorfieldplot!(Plots.current(), V; kwargs...)

function _vectorfieldplot2d(plt, V, xs, ys,
                            dx=diff(xs)[1], dy=diff(ys)[1],
                            kwargs...)

    ps = [[x,y] for x in xs for y in ys]
    vs = V.(ps)

    λ = 0.9 * min(dx, dy) / maximum(norm.(vs))

    arrow!.(Ref(plt), ps, λ * vs)

    plt

end


"""
    vectorfieldplot3d!([plt], V; [xlim=(-5,5)], [ylim=(-5,5)], [zlim=(-5,5)], [n=5], kwargs...)

Add 3d vector field plot

Example:
```
V(x,y,z) = [-y, x,0]
V(v) = V(v...)
p = plot([NaN],[NaN],[NaN], legend=false)
vectorfieldplot3d!(p, V)
```
"""
vectorfieldplot3d!(V; kwargs...) = vectorfieldplot3d!(Plots.current(), V; kwargs...)
function vectorfieldplot3d!(plt, V; xlim=(-5,5), ylim=(-5,5), zlim=(-5,5), n=5, kwargs...)

    dx, dy, dz = (xlim[2]-xlim[1])/n, (ylim[2]-ylim[1])/n, (zlim[2]-zlim[1])/n
    xs, ys, zs = xlim[1]:dx:xlim[2], ylim[1]:dy:ylim[2], zlim[1]:dz:zlim[2]

    _vectorfieldplot3d(plt, V, xs, ys, zs; kwargs...)
end

# lower level to give more control if needed
function _vectorfieldplot3d!(plt, V, xs, ys, zs,
                            dx=diff(xs)[1], dy=diff(ys)[1], dz=diff(zs)[1];
                            kwargs...)

    ps = [[x,y, z] for x in xs for y in ys for z in zs]
    vs = V.(ps)

    λ = 0.9 * min(dx, dy, dz) / maximum(norm.(vs))

    arrow!.(Ref(plt), ps, λ * vs)

    plt

end





"""
    Visualize `F(x,y,z) = c` by plotting assorted contour lines

This graphic makes slices in the `x`, `y`, and/or `z` direction of the 3-D level surface and plots them accordingly. Which slices (and their colors) are specified through a dictionary.

Examples:
```
F(x,y,z) = x^2 + y^2 + x^2
plot_implicit(F, 20)  # 20 slices in z direction
plot_implicit(F, 20, slices=Dict(:x=>:blue, :y=>:red, :z=>:green), nlevels=6) # all 3 shown

# A heart
a,b = 1,3
f(x,y,z) = (x^2+((1+b)*y)^2+z^2-1)^3-x^2*z^3-a*y^2*z^3
plot_implicit(f, xrng=(-2,2),yrng=(-1,1),zrng=(-1,2))
```

Note: Idea [from](https://stackoverflow.com/questions/4680525/plotting-implicit-equations-in-3d).

"""
function plot_implicit(F, c=0;
                       xrng=(-5,5), yrng=xrng, zrng=xrng,
                       nlevels=25,         # number of levels in a direction
                       slices=Dict(:z => :blue), # which directions and color
                       kwargs...          # passed to initial `plot` call
                       )

    _linspace(rng, n=150) = range(rng[1], stop=rng[2], length=n)

    X1, Y1, Z1 = _linspace(xrng), _linspace(yrng), _linspace(zrng)

    p = Plots.plot(;legend=false,kwargs...)

    if :x ∈ keys(slices)
        for x in _linspace(xrng, nlevels)
            local X1 = [F(x,y,z) for y in Y1, z in Z1]
            cnt = Contour.contours(Y1,Z1,X1, [c])
            for line in lines(levels(cnt)[1])
                ys, zs = coordinates(line) # coordinates of this line segment
                plot!(p, x .+ 0 * ys, ys, zs, color=slices[:x])
          end
        end
    end

    if :y ∈ keys(slices)
        for y in _linspace(yrng, nlevels)
            local Y1 = [F(x,y,z) for x in X1, z in Z1]
            cnt = Contour.contours(Z1,X1,Y1, [c])
            for line in lines(levels(cnt)[1])
                xs, zs = coordinates(line) # coordinates of this line segment
                plot!(p, xs, y .+ 0 * xs, zs, color=slices[:y])
            end
        end
    end

    if :z ∈ keys(slices)
        for z in _linspace(zrng, nlevels)
            local Z1 = [F(x, y, z) for x in X1, y in Y1]
            cnt = Contour.contours(X1, Y1, Z1, [c])
            for line in lines(levels(cnt)[1])
                xs, ys = coordinates(line) # coordinates of this line segment
                plot!(p, xs, ys, z .+ 0 * xs, color=slices[:z])
            end
        end
    end


    p
end
