
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


imgfile = "figures/seesaw.png"
caption = L"""

A silhouette of two children on a seesaw. The seesaw can be balanced
only if the distance from the central point for each child reflects
their relative weights, or masses, through the formula $d_1m_1 = d_2
m_2$. This means if the two children weigh the same the balance will
tip in favor of the child farther away, and if both are the same
distance, the balance will tip in favor of the heavier.
"""
ImageFile(imgfile, caption)


using CalculusWithJulia  # loads `Plots`, `Roots`, `QuadGK`, `SymPy`
using Plots
f(x) = 1 - abs(x)
a, b = -1.5, 1.5
plot(f, a, b)
plot!(zero, a, b)


n = 21
xs = range(-1, stop=1, length=n)
cs = (xs[1:(end-1)] + xs[2:end]) / 2

p = plot(legend=false);

for i in 1:(n-1)
   xi, xi1 = xs[i], xs[i+1]
   plot!(p, [xi, xi1, xi1, xi], [0,0,1,1]*f(cs[i]), linetype=:polygon, color=:red);
end

for i in 1:(n-1)
  ci = cs[i]
  scatter!(p, [ci], [.1], markersize=12*f(cs[i]), color=:orange);
end
plot!(p, [-1,1], [0,0])

p


f(x) = (1-x)/2
plot(f, -1, 1)
plot!(zero, -1, 1)


f(x) = 1 - x^2
g(x) = (x-1)^2 -2
plot(f, -3, 3)
plot!(g, -3, 3)


h(x) = f(x) - g(x)
a,b = find_zeros(h, -3, 3)
top, err = quadgk(x -> x*h(x), a, b)
bottom, err = quadgk(h, a, b)
cm = top / bottom


note("""

It proves convenient to use the `->` notation for an anonymous function above, as our function `h` is not what is being integrated all the time, but some simple modification. If this isn't palatable, a new function could be defined and passed along to `quadgk`.

""")


note("""

In this example, we used an infinite region, so the idea of "balancing" may be a bit unrealistic, nonetheless, this intuitive interpretation is still a good one to keep this in mind. The point of comparing to the median is that the balancing point is to the right of where the area splits in half. Basically, the center of mass follows in the direction of the area far to the right of the median, as this area is skewed in that direction.

""")


k = 3
phi(u) = exp(2(k-1)) - exp(2(k-u))
f(u) = max(0, phi(u))
g(u) = min(f(u+1), f(k))

plot(f, 0, k)
plot!(g, 0, k)
plot!(zero, 0, k)


h(x) = g(x) - f(x)
top, _ = quadgk(x -> x*h(x), 0, k)
bottom, _ = quadgk(h, 0, k)
top/bottom


u(i) = 1/2*(2k - log(exp(2(k-1)) - i))
p = plot(legend=false);
for i in 0:floor(phi(k))
  x = u(i)
  plot!(p, [x,x,x-1,x-1], [f(x),f(x)+1, f(x)+1, f(x)], linetype=:polygon, color=:orange);
end
xs = range(0, stop=exp(1), length=50)
plot!(p, f, 0, e, linewidth=5);
plot!(p, g, 0, 3, linewidth=5)
p


@vars a b x y
eqn = x/b + y/a - 1
fy = solve(eqn, x)[1]
integrate(y*fy, (y, 0, a)) / integrate(fy, (y, 0, a))


fx = solve(eqn, y)[1]
integrate(x*fx, (x, 0, b)) / integrate(fx, (x, 0, b))


note(L"""

The [centroid](http://en.wikipedia.org/wiki/Centroid) of a region in the plane is just $(\text{cm}_x, \text{cm}_y)$. This last fact says the centroid of the right triangle  is just $(b/3, a/3)$. The centroid can be found by other geometric means. The link shows the plumb line method. For triangles, the centroid is also the intersection point of the medians, the lines that connect a vertex with its opposite midpoint.

""")


f(x) = sqrt(1 - x^2)
plot(f, -1, 1)


a,b = 0, 2pi
ts = range(a, stop=b, length=50)
p = plot(t -> 2cos(t), t->2sin(t), a, b, legend=false, aspect_ratio=:equal);
plot!(p, cos.(ts), 1 .+ sin.(ts), linetype=:polygon, color=:red);
plot!(p, [-sqrt(3), sqrt(3)], [-1,-1], color=:orange);
plot!(p, [-sqrt(3), -1],      [1,1],   color=:orange);
plot!(p, [sqrt(3), 1],        [1,1],   color=:orange);
p


f(y) = y < 0 ? 2*sqrt(4 - y^2) : 2* (sqrt(4 - y^2)- sqrt(1 - (y-1)^2))
top, _ = quadgk( y -> y * f(y), -2, 2)
bottom, _ = quadgk( f, -2, 2)
top/bottom


f(x) = sqrt(4 - x)
a, b = 0, 4
top, _ = quadgk(x -> x*f(x), a,b)
bottom, _ = quadgk(f, a,b)
val = top/bottom
numericq(val)


f(x) = 3 * sqrt(1 - (x/2)^2)
a, b= 0, 2

top, _ = quadgk(x -> x*f(x), a,b)
bottom, _ = quadgk(f, a,b)
val = top/bottom
numericq(val)


f(x) = x^3 * (1-x)^4
a, b= 0, 1

top, _ = quadgk(x -> x*f(x), a,b)
bottom, _ = quadgk(f, a,b)
val = top/bottom
numericq(val)


k, lambda = 2, 2
f(x) = (k/lambda) * (x/lambda)^(k-1) * exp(-(x/lambda)^k)
a, b = 0, Inf

top, _ = quadgk(x -> x*f(x), a,b)
bottom, _ = quadgk(f, a,b)
val = top/bottom
numericq(val)


m, s = 2, 4
f(x) = 1/(4s) * sech((x-m)/2s)^2
a,b = -Inf, Inf

top, _ = quadgk(x -> x*f(x), a,b)
bottom, _ = quadgk(f, a,b)
val = top/bottom
numericq(val)


f(y) = 2*sqrt(1 - y^2)
a, b = 3/4, 1


top, _ = quadgk(x -> x*f(x), a,b)
bottom, _ = quadgk(f, a,b)
val = top/bottom
numericq(val)


f(y) = 2*acos(y)
a, b= 0, 1

top, _ = quadgk(x -> x*f(x), a,b)
bottom, _ = quadgk(f, a,b)
val = top/bottom
numericq(val)


ds = [0.75, 0.835, 0.705, 0.955]
rs = ds/2
xs = rs[4] .- rs
ts = range(0,stop=2pi, length=50)
p = plot(legend=false, aspect_ratio=:equal);
for i in 1:4
  plot!(p, xs[i] .+ rs[i]*cos.(ts), rs[i]*sin.(ts));
end

p


ds = [0.75, 0.835, 0.705, 0.955]
ms = [2.5, 5, 2.268, 5.670]
rs = ds/2
xs = rs[4] .- rs
val = sum(ms .* xs) / sum(ms)
numericq(val)

