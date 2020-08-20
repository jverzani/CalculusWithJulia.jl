
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


f1(x) = x^2
g1(x) = sqrt(x)
a,b = 1/4, 3/4

xs = range(a, stop=b, length=250)
ss = vcat(xs, reverse(xs))
ts = vcat(f1.(xs), g1.(reverse(xs)))

plot(f1, 0, 1, legend=false)
plot!(g1, 0, 1)
plot!(ss, ts, fill=(0, :red))
plot!(xs, f1.(xs), linewidth=5, color=:green)
plot!(xs, g1.(xs), linewidth=5, color=:green)


plot!(xs, f1.(xs), legend=false, linewidth=5, color=:blue)
plot!(xs, g1.(xs), linewidth=5, color=:blue)
u,v = .4, .5
plot!([u,v,v,u,u], [f1(u), f1(u), g1(u), g1(u), f1(u)], color=:black, linewidth=3)


using CalculusWithJulia  # loads  `Roots`, `QuadGK`, `SymPy`
using Plots
f(x) = 2 - x^2
g(x) = 2x
plot(f, -3,3)
plot!(g, -3,3)


a,b = find_zeros(x -> f(x) - g(x), -3, 3)


quadgk(x -> f(x) - g(x), a, b)[1]


f(x) = sin(x)
g(x) = cos(x)
plot([f,g], 0, 2pi)


a,b = find_zeros(x -> f(x) - g(x), 0, 2pi)  # pi/4, 5pi/4
quadgk(x -> f(x) - g(x), a, b)[1]


@vars x n real=true positive=true
ex = integrate(x^n - x^(n+1), (x, 0, 1))
together(ex)


summation(1/(n+1)/(n+2), (n, 1, oo))


f(x) = 2 - x^2
a,b = -1, 1/2
c = (a+b)/2
xs = range(-sqrt(2), stop=sqrt(2), length=50)
rxs = range(a, stop=b, length=50)
rys = map(f, rxs)


plot(f, a, b, legend=false, linewidth=3)
xs = [a,c,b,a]
plot!(xs, f.(xs), linewidth=3)


f(x) = 2 - x^2
a,b = -1, 1/2
c = (a +b)/2
function secant(f, x1, x2)
   m = (f(x2) - f(x1)) / (x2 - x1)
   x -> f(x1) + m * (x-x1)
end

sac, sab, scb = secant(f, a,c), secant(f, a,b), secant(f, c,b)
f1(x) = min(sac(x), scb(x))
f2(x) = sab(x)

val1 = quadgk(x -> f1(x) - f2(x), a, b)[1]


val2 = quadgk(x -> f(x) - f2(x), a, b)[1]


val1 * 4/3 - val2


f(x) = x^4
g(x) = exp(x)
plot([f, g], 0, 10)


a,b = find_zeros(x -> f(x) - g(x), 0, 10)
quadgk(x -> f(x) - g(x), a, b)[1]


m = 1/2
plot(sin, 0, pi)
plot!(x -> m*x, 0, pi)


B(m) = maximum(find_zeros(x -> sin(x) - m*x, 0, pi))
a = 0
b = B(m)
quadgk(x -> sin(x) - m*x, a, b)[1]


area(m) = quadgk(x -> sin(x) - m*x, 0, B(m))[1]


plot(area, 0, 1)


find_zero(m -> area(m) - 1, (0, 1))


f(x) = log(x+1)
g(x) = x - 1
plot([f,g,zero],0, 3)


a = 0
b = find_zero(x -> f(x) - g(x), 2)


quadgk(x -> f(x) - zero(x), a, 1)[1] + quadgk(x -> f(x) - g(x), 1, b)[1]


h(x) = x < 1 ? 0.0 : g(x)
quadgk(x -> f(x) - h(x), a, b)[1]


a1=f(a)
b1=f(b)
f1(y)=y+1                # y=x-1, so x=y+1
g1(y)=exp(y)-1           # y=log(x+1) so e^y = x + 1, x = e^y - 1
quadgk(y -> f1(y) - g1(y), a1, b1)[1]


note("""

When doing problems by hand this latter style can often reduce the complications, but when approaching the task numerically, the first two styles are generally easier, though computationally more expensive.

""")


f(x) = x^3
xs = range(-1, stop=1, length=50)
ys = f.(xs)
plot(ys, xs)


ys = range(-1, stop=1, length=50)
xs = [y^3 for y in ys]
plot(xs, ys)


ys = range(0, stop=2, length=50)
xs = [y^2 for y in ys]
plot(xs, ys)
xs = [2-y for y in ys]
plot!(xs, ys)
plot!(zero, 0, 2)


f(y) = 2-y
g(y) = y^2
a, b = 0, 1
quadgk(y -> f(y) - g(y), a, b)[1]


using Roots
f(x) = 2 - x^2
g(x) = x^2 - 3
a,b = find_zeros(x -> f(x) - g(x), -10,10)
val, _ = quadgk(x -> f(x) - g(x), a, b)
numericq(val)


f(x) = cos(x)
g(x) = x
a = 0
b = find_zero(x -> f(x) - g(x), 1)
val, _ = quadgk(x -> f(x) - g(x), a, b)
numericq(val)


f(x) = sqrt(1 - x^2)
g(x) = 1/2 * (x + 1)
a,b = find_zeros(x -> f(x) - g(x), -1, 1)
val, _ = quadgk(x -> f(x) - g(x), a, b)
numericq(val)


f(x) = x
g(x) = 1.0
h(x) = min(f(x), g(x))
j(x) = x^2 / 4
a,b = find_zeros(x -> h(x) - j(x), 0, 3)
val, _ = quadgk(x -> h(x) - j(x), a, b)
numericq(val)


f(x) = x^2
g(x) = -x^4
a,b = -1, 1
val, _ = quadgk(x -> f(x) - g(x), a, b)
numericq(val)


import SpecialFunctions: gamma
f(x) = 1/(sqrt(pi)*gamma(1/2)) * (1 + x^2)^(-1)
g(x) = 1/sqrt(2*pi) * exp(-x^2/2)
a,b =  find_zeros(x -> f(x) - g(x), -3, 3)
val, _ = quadgk(x -> f(x) - g(x), a, b)
numericq(val)


f(y) = (y-1)^2
g(y) = 3 - y
h(y) = 2sqrt(y)
a = 0
b = find_zero(y -> f(y) - g(y), 2)
f1(y) = max(f(y), zero(y))
g1(y) = min(g(y), h(y))
val, _ = quadgk(y -> g1(y) - f1(y), a, b)
numericq(val)


f(x) = x^2
g(x) = x
a, b = 0, 2
val, _ = quadgk(x -> abs(f(x) - g(x)), a, b)
numericq(val)


7850 * 2.2 * (1/39.3)^3


f(x) = x^2/70
g(x) = 35 + x^2/140
a,b = find_zeros(x -> f(x) - g(x), -100, 100)
ar, _ = quadgk(x -> abs(f(x) - g(x)), a, b)
val = 5 * ar * 7850 * 2.2 * (1/39.3)^3
numericq(val)


choices=["Less than two tons", "More than two tons"]
ans = 2
radioq(choices, ans, keep_order=true)


mr(x) = 2 + exp((-x/10)) / (1 + exp(-x/10))
mc(x) = 1 + (1/2) * exp(-x/5) / (1 + exp(-x/5))
a, b = 0, 100
val, _ = quadgk(x -> mr(x) - mc(x), 0, 100)
numericq(val)

