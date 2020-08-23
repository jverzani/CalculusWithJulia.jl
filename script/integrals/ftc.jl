
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


note(L"""

In Part 1, the integral $F(x) = \int_a^x f(u) du$ is defined for any
Riemann integrable function, $f$. If the function is not continuous,
then it is true the $F$ will be continuous, but it need not be true
that it is differentiable at all points in $(a,b)$. Forming $F$ from
$f$ is a form of *smoothing*. It makes a continuous function out of an
integrable one, a differentiable function from a continuous one, and a
$k+1$-times differentiable function from a $k$-times differentiable
one.

""")


using CalculusWithJulia  # loads `SymPy`, `QuadGK`
using Plots
integrate(sin)


integrate(sin, 0, pi)


@vars x n real=true
integrate(x^n, x)          # indefinite integral


integrate(acos(1-x), (x, 0, 2))


##{{{ftc_graph}}}
pyplot()
fig_size = (600, 400)

function make_ftc_graph(n)
    a, b = 2, 3
    ts = range(0, stop=b, length=50)
    xs = range(a, stop=b, length=8)
    g(x) = x
    G(x) = x^2/2

    xn,xn1 = xs[n:(n+1)]
    xbar = (xn+xn1)/2
    rxs = collect(range(xn, stop=xn1, length=2))
    rys = map(g, rxs)

    p = plot(g, 0, b, legend=false, size=fig_size, xlim=(0,3.25), ylim=(0,5))
    plot!(p, [xn, rxs..., xn1], [0,rys...,0], linetype=:polygon, color=:orange)
    plot!(p, [xn1, xn1], [G(xn), G(xn1)], color=:orange, alpha = 0.25)
    annotate!(p, collect(zip([xn1, xn1], [G(xn1)/2, G(xn1)], ["A", "A"])))

    p
end

caption = L"""

Illustration showing $F(x) = \int_a^x f(u) du$ is a function that
accumulates area. The value of $A$ is the area over $[x_{n-1}, x_n]$
and also the difference $F(x_n) - F(x_{n-1})$.

"""

n = 7

anim = @animate for i=1:n
    make_ftc_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


F(x) = exp(-x^2) * quadgk(t -> exp(t^2), 0, x)[1]
Fp(x) = -2x*F(x) + 1
cps = find_zeros(Fp, -4,4)


Fpp(x) = -2F(x) + 4x^2*F(x) - 2x
Fpp.(cps)


function cnew = update(Cnew, Cold)
  cnew = Cnew - Cold
end


function update(Cnew, Cold)
  cnew = Cnew - Cold
end


function update(Cnew, Cold, n)
   cnew = (Cnew - Cold) * n
end


F(x) = exp(x^2)
val = F(2) - F(0)
numericq(val)


F(x) = sin(x) - x*cos(x)
a, b= 0, pi
val = F(b) - F(a)
numericq(val)


f(x) = x*(1-x)
a,b = 0, 1
F(x) = x^2/2 - x^3/3
val = F(b) - F(a)
numericq(val)


f(x) = exp(x) - 1
a, b = 0, exp(a)
F(x) = exp(x) - x
val = F(b) - F(a)
numericq(val)


f(x) = 1 - x^2/2 + x^4/24
a, b = 0, 1
val, _ = quadgk(f, a, b)
numericq(val)


choices = [
L"-x^2\cos(x)",
L"-x^2\cos(x) + 2x\sin(x)",
L"-x^2\cos(x) + 2x\sin(x) + 2\cos(x)"
]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"-e^{-x}",
L"-xe^{-x}",
L"-(1+x) e^{-x}",
L"-(1 + x + x^2) e^{-x}"
]
ans = 3
radioq(choices, ans, keep_order=true)


using SymPy
@vars x
val = N(integrate(exp(x) * sin(x), (x, 0, 2pi)))
numericq(val)


v(t) = 2t^2 - t
f(x) = quadgk(v, 0, x)[1] - 0
numericq(f(1))


f(x) = quadgk(sin, 0, x)[1] - 0
numericq(f(pi/2))


function g1(x)
  if x < 2
    -1 + x
  elseif 2 < x < 3
    1
  else
    1 + (1/2)*(x-3)
  end
  end
using Plots
plot(g1, 0, 5)


choices = [
"It is always positive",
"It is always negative",
L"Between $0$ and $1$",
L"Between $1$ and $5$"
]
ans = 4
radioq(choices, ans, keep_order=true)


choices = [
L"t=1",
L"t=2",
L"t=3",
L"t=4"]
ans = 2
radioq(choices, ans, keep_order=true)


val = 4
numericq(val)


choices = [
L"The position, $x(t)$, stays constant",
L"The position, $x(t)$, increases with a slope of $1$",
L"The position, $x(t)$, increases quadratically from $-1/2$ to $1$",
L"The position, $x(t)$, increases quadratically from $0$ to $1$"
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
L"f(t)",
L"-f(t-10)",
L"f(t) - f(t-10)"
]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
"At a critical point",
L"At the endpoint $0$",
L"At the endpoint $1$"]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"At a critical point, either $0$ or $1$",
L"At a critical point, $1/2$",
L"At the endpoint $0$",
L"At the endpoint $1$"]
ans = 2
radioq(choices, ans, keep_order=true)


f(x) = x^(2/3)
x = 2
A(x) = quadgk(f, 0, x)[1]
m=f(x)
T = x - A(x)/f(x)
Q = f(x)
P = A(x)
secpt = u -> 0 + P/(x-T) * (u-T)
xs = range(0, stop=x+1/4, length=50
)
p = plot(f, 0, x + 1/4, legend=false)
plot!(p, A, 0, x + 1/4, color=:red)
scatter!(p, [T, x, x, x], [0, 0, Q, P], color=:orange)
annotate!(p, collect(zip([T, x, x+.1, x+.1], [0-.15, 0-.15, Q-.1, P], ["T", "x", "Q", "P"])))
plot!(p,  [T-1/4, x+1/4], map(secpt, [T-1/4, x + 1/4]), color=:orange)
plot!(p, [T, x, x], [0, 0, P], color=:green)

p


choices = [
L"\lvert Tx \rvert \cdot f(x) = A(x)",
L"A(x) / \lvert Tx \rvert = A'(x)",
L"A(x) \cdot A'(x) = f(x)"
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"\lvert Tx \rvert \cdot f(x) = A(x)",
L"A(x) / \lvert Tx \rvert = A'(x)",
L"A(x) \cdot A'(x) = f(x)"
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
L"A'(x) = f(x)",
L"A(x) = A^2(x) / f(x)",
L"A'(x) = A(x)",
L"A(x) = f(x)"
]
ans = 1
radioq(choices, ans)


choices = [
L"Part 1: $[\int_a^x f(u) du]' = f$",
L"Part 2: $\int_a^b f(u) du = F(b)- F(a)$."]
ans=1
radioq(choices, ans, keep_order=true)

