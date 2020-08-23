
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia   # loads `SymPy`, `Roots`
using Plots
@vars x y
u = SymFunction("u")
x0, y0 = 1, 1
F(y,x) = y*x

dsolve(u'(x) - F(u(x), x))


out = dsolve(u'(x) - F(u(x),x), u(x), ics=(u, x0, y0))


p = plot(legend=false)
vectorfieldplot!((x,y) -> [1, F(x,y)], xlims=(0, 2.5), ylims=(0, 10))
plot!(rhs(out),  linewidth=5)


## {{{euler_graph}}}

fig_size = (600, 400)
function make_euler_graph(n)
    x, y = symbols("x, y")
    F(y,x) = y*x
    x0, y0 = 1, 1

    h = (2-1)/5
    xs = zeros(n+1)
    ys = zeros(n+1)
    xs[1] = x0   # index is off by 1
    ys[1] = y0
    for i in 1:n
        xs[i + 1] = xs[i] + h
        ys[i + 1] = ys[i] + h * F(ys[i], xs[i])
    end

	p = plot(legend=false)
    vectorfieldplot!((x,y) -> [1, F(y,x)], xlims=(1,2), ylims=(0,6))

    ## Add Euler soln
    plot!(p, xs, ys, linewidth=5)
    scatter!(p, xs, ys)

    ## add function
    u = SymFunction("u")
    out = dsolve(u'(x) - F(u(x), x), u(x), ics=(u, x0, y0))
    plot!(p, rhs(out), x0, xs[end], linewidth=5)

    p
end




n = 5
anim = @animate for i=1:n
    make_euler_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)


caption = """
Illustration of a function stitching together slope field lines to
approximate the answer to an initial-value problem. The other function drawn is the actual solution.
"""

ImageFile(imgfile, caption)


n=5
h = (2-1)/n
xs = zeros(n+1)
ys = zeros(n+1)
xs[1] = x0   # index is off by 1
ys[1] = y0
for i in 1:n
  xs[i + 1] = xs[i] + h
  ys[i + 1] = ys[i] + h * F(ys[i], xs[i])
end


plot(exp(-1/2)*exp(x^2/2), x0, 2)
plot!(xs, ys)


function linterp(xs, ys)
    function(x)
        ((x < xs[1]) || (x > xs[end])) && return NaN
        for i in 1:(length(xs) - 1)
            if xs[i] <= x < xs[i+1]
                l = (x-xs[i]) / (xs[i+1] - xs[i])
                return (1-l) * ys[i] + l * ys[i+1]
            end
        end
        ys[end]
    end
end


function euler(F, x0, xn, y0, n)
  h = (xn - x0)/n
  xs = zeros(n+1)
  ys = zeros(n+1)
  xs[1] = x0
  ys[1] = y0
  for i in 1:n
    xs[i + 1] = xs[i] + h
    ys[i + 1] = ys[i] + h * F(ys[i], xs[i])
  end
  linterp(xs, ys)
end


u = euler(F, 1, 2, 1, 50)
plot(exp(-1/2)*exp(x^2/2), x0, 2)
plot!(u, x0, 2)


imgfile ="figures/euler.png"
caption = """Figure from first publication of Euler's method. From [Gander and Wanner](http://www.unige.ch/~gander/Preprints/Ritz.pdf)."""

ImageFile(imgfile, caption)


F(y,x) = x + y
x0, xn, y0 = 0, 2, 1
f = euler(F, x0, xn, y0, 25)
f(xn)


plot(f, x0, xn)
u = SymFunction("u")
out = dsolve(u'(x) - F(u(x),x), u(x), ics = (u, x0, y0))
plot(rhs(out), x0, xn)
plot!(f, x0, xn)


@vars x
u = SymFunction("u")
F(y,x) = sin(x*y)
eqn = u'(x) - F(u(x), x)
out = dsolve(eqn)


out = dsolve(eqn, u(x), ics=(u, 0, 1))


x0, xn, y0 = 0, 2, 1

p = plot(legend=false)
vectorfieldplot!((x,y) -> [1, F(y,x)], xlims=(x0,xn), ylims=(0,5))
plot!(rhs(out).removeO(),  linewidth=5)

u = euler(F, x0, xn, y0, 10)
plot!(u, linewidth=5)


imgfile = "figures/bead-game.jpg"
caption = """

A child's bead game. What shape wire will produce the shortest time for a bed to slide from a top to the bottom?

"""
ImageFile(imgfile, caption)


imgfile = "figures/galileo.gif"
caption = """
As early as 1638, Galileo showed that an object falling along `AC` and then `CB` will fall faster than one traveling along `AB`, where `C` is on the arc of a circle.
From the [History of Math Archive](http://www-history.mcs.st-and.ac.uk/HistTopics/Brachistochrone.html).
"""
ImageFile(imgfile, caption)


##{{{brach_graph}}}

function brach(f, x0, vx0, y0, vy0, dt, n)
    m = 1
    g = 9.8

    axs = Float64[0]
    ays = Float64[-g]
    vxs = Float64[vx0]
    vys = Float64[vy0]
    xs = Float64[x0]
    ys = Float64[y0]

    for i in 1:n
        x = xs[end]
        vx = vxs[end]

        ax = -f'(x) * (f''(x) * vx^2 + g) / (1 + f'(x)^2)
        ay = f''(x) * vx^2 + f'(x) * ax

        push!(axs, ax)
        push!(ays, ay)

        push!(vxs, vx + ax * dt)
        push!(vys, vys[end] + ay * dt)
        push!(xs, x       + vxs[end] * dt)# + (1/2) * ax * dt^2)
        push!(ys, ys[end] + vys[end] * dt)# + (1/2) * ay * dt^2)
    end

    [xs ys vxs vys axs ays]

end


fs = [x -> 1 - x,
      x -> (x-1)^2,
      x -> 1 - sqrt(1 - (x-1)^2),
      x ->  - (x-1)*(x+1),
      x -> 3*(x-1)*(x-1/3)
      ]


MS = [brach(f, 1/100, 0, 1, 0, 1/100, 100) for f in fs]


function make_brach_graph(n)

    p = plot(xlim=(0,1), ylim=(-1/3, 1), legend=false)
    for (i,f) in enumerate(fs)
        plot!(f, 0, 1)
        U = MS[i]
        x = min(1.0, U[n,1])
        scatter!(p, [x], [f(x)])
    end
    p

end



n = 4
anim = @animate for i=[1,5,10,15,20,25,30,35,40,45,50,55,60]
    make_brach_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)


caption = """
The race is on. An illustration of beads falling along a path, as can be seen, some paths are faster than others. The fastest path would follow a cycloid. See [Bensky and Moelter](https://pdfs.semanticscholar.org/66c1/4d8da6f2f5f2b93faf4deb77aafc7febb43a.pdf) for details on simulating a bead on a wire.
"""

ImageFile(imgfile, caption)


function back_euler(F, x0, xn, y0, n)
    h = (xn - x0)/n
    xs = zeros(n+1)
    ys = zeros(n+1)
    xs[1] = x0
    ys[1] = y0
    for i in 1:n
        xs[i + 1] = xs[i] + h
        ## solve y[i+1] = y[i] + h * F(y[i+1], x[i+1])
        ys[i + 1] = find_zero(y -> ys[i] + h * F(y, xs[i + 1]) - y, ys[i]+h)
    end
  linterp(xs, ys)
end


F(y, x; C=1) = sqrt(C/y - 1)
x0, xn, y0 = 0, 1.2, 0
cyc = back_euler(F, x0, xn, y0, 50)
plot(x -> 1 - cyc(x), x0, xn)


F(y,x) = -5y
x0, xn, y0 = 0, 2, 1
u = euler(F, x0, xn, y0, 4)     # n =4 => h = 2/4
vectorfieldplot((x,y) -> [1,F(y,x)], xlims=(0, 2), ylims=(-5, 5))
plot!(x -> y0 * exp(-5x), 0, 2, linewidth=5)
plot!(u, 0, 2, linewidth=5)


u = euler(F, x0, xn, y0, 50)    # n=50 => h = 2/50
plot(x -> y0 * exp(-5x), 0, 2)
plot!(u, 0, 2)


u = back_euler(F, x0, xn, y0, 4)     # n =4 => h = 2/4
vectorfieldplot((x,y) -> [1,F(y,x)],  xlims=(0, 2), ylims=(-1, 1))
plot!(x -> y0 * exp(-5x), 0, 2, linewidth=5)
plot!(u, 0, 2, linewidth=5)


function euler2(x0, xn, y0, yp0, n; g=9.8, l = 5)
  xs, us, vs = zeros(n+1), zeros(n+1), zeros(n+1)
  xs[1], us[1], vs[1] = x0, y0, yp0
  h = (xn - x0)/n
  for i = 1:n
    xs[i+1] = xs[i] + h
	us[i+1] = us[i] + h * vs[i]
	vs[i+1] = vs[i] + h * (-g / l) * sin(us[i])
	end
	linterp(xs, us)
end


l, g = 5, 9.8
T = 2pi * sqrt(l/g)
x0, xn, y0, yp0 = 0, 4T, pi/4, 0
plot(euler2(x0, xn, y0, yp0, 20), 0, 4T)


plot(euler2(x0, xn, y0, yp0, 360), 0, 4T)
plot!(x -> pi/4*cos(sqrt(g/l)*x), 0, 4T)


F(y,x) = x - y
x0, xn, y0 = 0, 1, 1
val = euler(F, x0, xn, y0, 5)(1)
numericq(val)


F(y, x) = x * sin(y)
x0, xn, y0 = 0, 5, 1
n = 50
u = euler(F, x0, xn, y0, n)
numericq(u(xn))


F(y, x) = 1 - 2y/x
x0, xn, y0 = 1, 2, 0
n = 50
u = euler(F, x0, xn, y0, n)
numericq(u(xn))


F(y, x) = y*log(y)/x
x0, xn, y0 = 2, 3, exp(1)
n = 25
u = euler(F, x0, xn, y0, n)
numericq(u(xn))


F(y, x) = y * (1-2x)
x0, xn, y0 = 0, 2, 1
n = 50
u = euler(F, x0, xn, y0, n)
numericq(u(1/2))


numericq(u(3/2))


choices = [
"The same as before - the amplitude grows",
"The solution is identical to that of the approximation found by linearization of the sine term",
"The solution has a constant amplitude, but its period is slightly *shorter* than that of the approximate solution found by linearization",
"The solution has a constant amplitude, but its period is slightly *longer* than that of the approximate solution found by linearization"]
ans = 4
radioq(choices, ans, keep_order=true)

