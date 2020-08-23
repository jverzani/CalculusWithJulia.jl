
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia 
using Plots
gr()   # better graphics than plotly() here


f(x,y) = x^2 + y^2


using LaTeXStrings
note(L"""

This is a function of *two* variables, used here to express one side of an equation. `Julia` makes this easy to do - just make sure two variables are in the signature of `f` when it is defined. Using functions like this, we can express our equation in the form $f(x,y) = c$ or $f(x,y) = g(x,y)$, the latter of which can be expressed as $h(x,y) = f(x,y) - g(x,y) = 0$. That is, only the form $f(x,y)=c$ is needed.

""")


r = Eq(f, 2^2)


note("""
There are unicode infix operators for each of these which make it
easier to read at the cost of being harder to type in. This predicate
would be written as `f ⩵ 2^2` where `⩵` is **not** two equals signs,
but rather typed with `\\Equal[tab]`.)
""")


plot(r)


a,b = -1,2
f(x,y) =  y^4 - x^4 + a*y^2 + b*x^2
plot(Eq(f, 0), xlims=(-3,3), ylims=(-3,3))


note(L"""

The rendered plots look "blocky" due to the algorithm used to plot the
equations. As there is no rule defining $(x,y)$ pairs to plot, a
search by regions is done. A region is initially labeled
undetermined. If it can be shown that for any value in the region the
equation is true (equations can also be inequalities), the region is
colored black. If it can be shown it will never be true, the region is
dropped. If a black-and-white answer is not clear, the region is
subdivided and each subregion is similarly tested. This continues
until the remaining undecided regions are smaller than some
threshold. Such regions comprise a boundary, and here are also colored
black. Only regions are plotted - not $(x,y)$ pairs - so the results
are blocky. Pass larger values of $N=M$ (with defaults of $8$) to
`plot` to lower the threshold at the cost of longer computation times.

""")


using IntervalArithmetic, IntervalConstraintProgramming
S = @constraint x^2 + y^2 <= 2


X = IntervalBox(-3..3, -3..3)


r = pave(S, X)


plot(r.inner)       # plot interior; use r.boundary for boundary


a, b = 2, 1
f(x,y) = x^2*y + a * b * y - a^2 * x
plot(Eq(f, 0))


a = 3
f(x,y) = x^4 - a^2*(x^2 - y^2)
plot(Eq(f, 0))


note(L"""

In this example we mix notations using $g'(x)$ to
represent a derivative of $g$ with respect to $x$ and $dy/dx$ to
represent the derivative of $y$ with respect to $x$. This is done to
emphasize the value that we are solving for. It is just a convention
though, we could just as well have used the "prime" notation for each.

""")


F(x,y) = x^2 + y^2

a,b = sqrt(2)/2, -sqrt(2)/2

m = -a/b
tl(x) = b + m * (x-a)


f(x,y) = x^2 + y^2
plot(Eq(f, 1), xlims=(-2, 2), ylims=(-2, 2))
plot!(tl)


a = 1
F(x,y) = x^3 + y^3 - 3*a*x*y
plot(Eq(F,0))


y1(x) = minimum(find_zeros(y->F(x,y), -10, 10))  # find_zeros from `Roots`


plot(y1, -5, 5)


@vars a b c d x y
ex = x*y - (a*c^3 + b*x^2 + c*x + d)


u = SymFunction("u")


ex1 = ex(y => u(x))


ex2 = diff(ex1, x)


dydx = diff(u(x), x)
ex3 = solve(ex2, dydx)[1]    # pull out lone answer with [1] indexing


dydx = ex3(u(x) => y)


function dy_dx(eqn)
  u = SymFunction("u")
  eqn1 = eqn(y => u(x))
  eqn2 = solve(diff(eqn1, x), diff(u(x), x))[1]
  eqn2(u(x) => y)
end


H = ex(a=>1, b=>1, c=>1, d=>1)
x0, y0 = 1, 4
m = dydx(x=>1, y=>4, a=>1, b=>1, c=>1, d=>1)
plot(Eq(lambdify(H), 0), xlims=(-5,5), ylims=(-5,5))
plot!(y0 + m * (x-x0))


alert("The use of `lambdify` is needed to turn the symbolic expression, `H`, into a function, as `ImplicitEquations` expects functions in its predicates.")


note("""

While `SymPy` itself has the `plot_implicit` function for plotting implicit equations,  this works only with `PyPlot`, not `Plots`, so we use the `ImplicitEquations` package in these examples.

""")


F(x,y) = x^3 - y^3
plot(Eq(F, 3),  xlims=(-3, 3), ylims=(-3, 3))


@vars x y
u = SymFunction("u")

eqn    = F(x,y) - 3
eqn1   = eqn(y => u(x))
dydx   = solve(diff(eqn1,x), diff(u(x), x))[1]        # 1 solution
d2ydx2 = solve(diff(eqn1, x, 2), diff(u(x),x, 2))[1]  # 1 solution
eqn2   = d2ydx2(diff(u(x), x) => dydx, u(x) => y)
simplify(eqn2)


imgfile = "figures/extrema-ring-string.png"
caption = "Ring on string figure."
ImageFile(imgfile, caption)


F(x, y, a, b) = sqrt(x^2 + y^2) + sqrt((a-x)^2 + (b-y)^2)


a, b, L = 3, 3, 10      # L > sqrt{a^2 + b^2}
F(x, y) = F(x, y, a, b)


plot(Eq(F, L), xlims=(-5, 7), ylims=(-5, 7))


@vars a b L x y
u = SymFunction("u")


F(x,y,a,b) = sqrt(x^2 + y^2) + sqrt((a-x)^2 + (b-y)^2)
eqn = F(x,y,a,b) - L


eqn1 = diff(eqn(y => u(x)), x)
eqn2 = solve(eqn1, diff(u(x), x))[1]
dydx  = eqn2(u(x) => y)


cps = solve(dydx, x)


eqn1 = eqn(x => cps[2])


eqn2 = eqn1(a=>3, b=>3, L=>10)
ystar = find_zero(eqn2, -3)


xstar = N(cps[2](y => ystar, a =>3, b => 3, L => 3))



F(x,y) = F(x,y, 3, 3)
tl(x) = ystar + 0 * (x- xstar)
plot(Eq(F, 10), xlims=(-4, 7), ylims=(-10, 10))
plot!(tl)


a0, b0 = 0,0   # the foci of the ellipse are (0,0) and (3,3)
a1, b1 = 3, 3
atan((b0 - ystar)/(a0 - xstar)) + atan((b1 - ystar)/(a1 - xstar)) # 0


x,y=1,1
yesnoq(x^2 - 2x*y + y^2 ==1)


using SymPy
@vars x y
eqn = x^2*y + 2y - 4x
val = float(N(solve(subs(eqn, (x,4)), y)[1]))
numericq(val)


yesnoq(false)


SymPy.@vars x y
u = SymFunction("u")
eqn = (x/3)^2 + (y/2)^2 - 1
dydx = SymPy.solve(SymPy.diff(SymPy.subs(eqn, y, u(x)), x), SymPy.diff(u(x), x))[1]
val = float(SymPy.N(SymPy.subs(dydx, (u(x), y), (x, 3/sqrt(2)), (y, 2/sqrt(2)))))
numericq(val)


a,b,n=1,2,3
val = b*(1 - ((1/2)/a)^n)^(1/n)
numericq(val)


choices = [
L" -(y/x) \cdot (x/a)^n \cdot (y/b)^{-n}",
L"b \cdot (1 - (x/a)^n)^{1/n}",
L"-(x/a)^n / (y/b)^n"
]
ans = 1
radioq(choices, ans)


using Roots
using ForwardDiff
D(f) = x -> ForwardDiff.derivative(f, float(x))
f(x) = x^2 - log(x)
x0 = 1/2
tl(x) = f(x0) + D(f)(x0) * (x - x0)
numericq(tl(0))


using Roots
a = 1
f(x,y) = y*(x^2 + a^2) - a^3
val = find_zero(y->f(2,y), 1)
numericq(val)


choices = [
L"-2xy/(x^2 + a^2)",
L"2xy / (x^2 + a^2)",
L"a^3/(x^2 + a^2)"
]
ans = 1
radioq(choices, ans)


### {{{lhopital_35}}}
imgfile = "figures/fcarc-may2016-fig35-350.gif"
caption = L"""

Image number 35 from L'Hospitals calculus book (the first). Given a description of the curve, identify
the point $E$ which maximizes the height.

"""
ImageFile(imgfile, caption)


choices = [L"y^2 = 3x/a", L"y=3x^2/a", L"y=a/(3x^2)", L"y^2=a/(3x)"]
ans = 2
radioq(choices, ans)


choices=[
L"x=(1/2) a 2^{1/2}",
L"x=(1/3) a 2^{1/3}",
L"x=(1/2) a^3 3^{1/3}",
L"x=(1/3) a^2 2^{1/2}"
]
ans = 2
radioq(choices, ans)


yesnoq(true)


choices = ["positive", "negative", "Can be both"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = ["positive", "negative", "Can be both"]
ans = 3
radioq(choices, ans, keep_order=true)


choices = ["concave up", "concave down", "both concave up and down"]
ans = 3
radioq(choices, ans, keep_order=true)

