
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


T0, Ta, r = 200, 72, 1/2
f(u, t) = -r*(u - Ta)
v(t) = Ta + (T0 - Ta) * exp(-r*t)
p = plot(v, 0, 6, linewidth=4, legend=false)
[plot!(p, x -> v(a) + f(v(a), a) * (x-a), 0, 6) for a in 1:2:5]
p


using CalculusWithJulia   # loads `SymPy`
using Plots
u = SymFunction("u")


@vars x y
@vars a positive=true


eqn = u'(x) - a * u(x) * (1 - u(x))


out = dsolve(eqn)


rhs(x) = x.rhs        # convenience to extract right hand side of an equation
eq = rhs(out)    # just the right hand side
C1 = first(setdiff(free_symbols(eq), (x,a))) # fish out constant
c1 = solve(eq(x=>0) - 1//2, C1)


eq(C1 => c1[1])


x0, y0 = 0, 1//2
dsolve(eqn, u(x), ics=(u, x0, y0))


@vars k m positive=true
eqn = u''(x) + k/m*u(x)
dsolve(eqn)


@vars a positive=true
dsolve(eqn, x, ics = ((u, 0, -a), (u', 0, 0)))


@vars g l positive=true
eqn = u''(x) + g/l*sin(u(x))
dsolve(eqn)


eqn = u''(x) + g/l * u(x)
dsolve(eqn, u(x), ics=((u, 0, a), (u', 0, 0)))


u = SymFunction("u")
@vars x w H positive=true
out = dsolve(u''(x) - w/H * sqrt(1 + u'(x)^2))


out = dsolve(u'(x) - w/H * sqrt(1 + u(x)^2))


eqn = u'(x) - rhs(out)
out1 = dsolve(eqn)


@vars x0 y0 v0 alpha g real=true
@vars x y t
u = SymFunction("u")
a1 = dsolve(u''(t) + 0, u(t), ics=((u, 0, x0), (u', 0, v0 * cos(alpha))))
a2 = dsolve(u''(t) - g, u(t), ics=((u, 0, y0), (u', 0, v0 * sin(alpha))))
ts = solve(x - rhs(a1), t)[1]
y = simplify(rhs(a2)(t => ts))


@vars gamma
u = SymFunction("u")
a1 = dsolve(u''(t) + gamma * u'(t),     u(t), ics=((u, 0, x0), (u', 0, v0 * cos(alpha))))
a2 = dsolve(u''(t) + gamma * u'(t) + g, u(t), ics=((u, 0, y0), (u', 0, v0 * sin(alpha))))
ts = solve(x - rhs(a1), t)[1]
y = simplify(rhs(a2)(t => ts))


y = y(x0 => 0, y0 => 0)


v_0, gam, alp = 200, 1/2, pi/4
soln = y(v0=>v_0, gamma=>gam, alpha=>alp, g=>9.8)
plot(soln, 0, v_0 * cos(alp) / gam - 1/10, legend=false)


@vars x y
x0, y0 = 1, 1
F(y, x) = y*x

plot(legend=false)
vectorfieldplot!((x,y) -> [1, F(y,x)], xlims=(x0, 2), ylims=(y0-5, y0+5))

f(x) =  y0*exp(-x0^2/2) * exp(x^2/2)
plot!(f,  linewidth=5)


note(L"""The order of variables in $F(y,x)$ is conventional with the equation $y'(x) = F(y(x),x)$.
""")


p = plot(legend=false)
vectorfieldplot!((x,y) -> [1,F(y,x)], xlims=(x0, 2), ylims=(y0-5, y0+5))
for y0 in -4:4
  f(x) =  y0*exp(-x0^2/2) * exp(x^2/2)
  plot!(f, x0, 2, linewidth=5)
end
p


u = SymFunction("u")
@vars x
dsolve(u'(x) - (1-x)/u(x))


choices = [
L"[-1, \infty)",
L"[-1, 4]",
L"[-1, 0]",
L"[1-\sqrt{5}, 1 + \sqrt{5}]"]
ans = 4
radioq(choices, ans)


u = SymFunction("u")
@vars x
out = dsolve(u'(x) - u(x)^2, u(x), ics=(u, 1, 1))
val = N(rhs(out(3/2)))
numericq(val)


eqn = u'(x) - (1 + x^2 + u(x)^2 + x^2 * u(x)^2)
out = dsolve(eqn, u(x), ics=(u, 0, 1))
val = N(rhs(out)(1).evalf())
numericq(val)


k, M = 1, 100
eqn = u'(x) - k * u(x) * (1 - u(x)/M)
out = dsolve(eqn, u(x), ics=(u, 0, 20))
val = N(rhs(out)(5))
numericq(val)


eqn = u'(x) - (sin(x) - u(x)/x)
out = dsolve(eqn, u(x), ics=(u, PI, 1))
val = N(rhs(out(2PI)))
numericq(val)


eqn = u'(x) - exp(-x)*u(x)
out = dsolve(eqn, u(x), ics=(u, 0, 1))
val = N(rhs(out)(5))
numericq(val)


u = SymFunction("u")
@vars x
eqn = diff(x^2*u'(x), x)
out = dsolve(eqn, u(x), ics=((u, 1, 2), (u, 10, 1))) |> rhs
out(5)  # 10/9
choices = [L"10/9", L"3/2", L"9/10", L"8/9"]
ans = 1
radioq(choices, ans)


choices = [
"The limit is a quadratic polynomial in `x`, mirroring the first part of that example.",
"The limit does not exists, but the limit to `oo` gives a quadratic polynomial in `x`, mirroring the first part of that example.",
"The limit does not exist, as there is a singularity, as seen by setting `gamma=0`."
]
ans = 1
radioq(choices, ans)

