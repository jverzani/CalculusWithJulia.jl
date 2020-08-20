
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia   # loads the `SymPy` package
using Plots
f(x) = (x-1)^2 * (x-2) / ((x+3)*(x-3) )
plot(f, -10, 10)


plot(f, -100, 100)


@vars x real=true
a =  (x-1)^2 * (x-2)
b = (x+3)*(x-3)


q, r = divrem(a, b)


q + r/b


f(x) = (x-1)^2 * (x-2) / ((x+3)*(x-3))  # as a function
p = f(x)                                # a symbolic expression
apart(p)


plot(apart(p) - (x - 4), 10, 100)


cancel(p)


p = (x^5 - 2x^4 + 3x^3 - 4x^2 + 5) / (5x^4 + 4x^3 + 3x^2 + 2x + 1)
apart(p)


a = 5x^3 + 6x^2 +2
b = x-1
q, r = divrem(a, b)


plot(a/b, -3, 3)
plot!(q, -3, 3)


plot(a/b, 5, 10)
plot!(q, 5, 10)


x = symbols("x")
p = (x-1)*(x-2)
q = (x-3)^3 * (x^2 - x - 1)
apart(p/q)


plot(1/x, -1, 1)


f(x) = (x-1)^2 * (x-2) / ((x+3)*(x-3) )
f(3), f(-3)


f(x) = (x-1)^2 * (x-2) / ((x+3)*(x-3) )
plot(f, -2.9, 2.9)


plot(f, -5, 5, ylims=(-20, 20))


function trimplot(f, a, b, c=20; kwargs...)
   fn = x -> abs(f(x)) < c ? f(x) : NaN
   plot(fn, a, b; kwargs...)
end


trimplot(f, -25, 25, 30)


function signchart(f, a, b)
   xs = range(a, stop=b, length=200)
   ys = f.(xs)
   cols = [fx < 0 ? :red  : :blue for fx in ys]
   plot(xs, ys, color=cols, linewidth=5, legend=false)
   plot!(zero, a, b)
   end


f(x) = x^3 - x
signchart(f, -3/2, 3/2)


sin_p(x) = (x - (7/60)*x^3) / (1 + (1/20)*x^2)
tan_p(x) = (x - (1/15)*x^3) / (1 - (2/5)*x^2)
plot(sin, -pi, pi)
plot!(sin_p, -pi, pi)


plot(tan, -pi/2 + 0.2, pi/2 - 0.2)
plot!(tan_p, -pi/2 + 0.2, pi/2 - 0.2)


choices = [L"A horizontal asymptote $y=0$",
L"A horizontal asymptote $y=1$",
L"A slant asymptote with slope $m=1$"]
ans = 3
radioq(choices, ans)


choices = [L"A horizontal asymptote $y=0$",
L"A horizontal asymptote $y=1$",
L"A slant asymptote with slope $m=1$"]
ans = 1
radioq(choices, ans)


choices = [L"A horizontal asymptote $y=0$",
L"A horizontal asymptote $y=1$",
L"A slant asymptote with slope $m=1$"]
ans = 2
radioq(choices, ans)


choices = [L"A horizontal asymptote $y=0$",
L"A horizontal asymptote $y=1$",
L"A slant asymptote with slope $m=1$"]
ans = 2
radioq(choices, ans)


choices = [L"A vertical asymptote $x=1$",
L"A slant asymptote with slope $m=1$",
L"A vertical asymptote $x=5$"
]
ans = 3
radioq(choices, ans)


choices = [L"y = 3x",
L"y = (1/3)x",
L"y = (1/3)x - (1/3)"
]
ans = 3
radioq(choices, ans)


f(x) = ((x-1) * (x-2)) / ((x-3) *(x-4))
delta = 1e-1
col = :blue
p = plot(f, -1, 3-delta, color=col, legend=false)
plot!(p, f, 3+delta, 4-3delta, color=col)
plot!(p,f, 4 + 5delta, 9, color=col)
p


choices = ["No, the graph clearly crosses the drawn asymptote",
"Yes, this is true"]
ans = 1
radioq(choices, ans)


plot(x -> 1/x, 10, 20)


plot(x -> 1/x, 100, 200)


choices = ["The horizontal asymptote is not a straight line.",
L"The $y$-axis scale shows that indeed the $y$ values are getting close to $0$.",
L"The graph is always decreasing, hence it will eventually reach $-\infty$."
]
ans = 2
radioq(choices, ans)


r1(t) = 50t^2 / (t^3 + 20)
val = r1(1)
numericq(val)


val = r1(24)
numericq(val)


choices = ["between 0 and 8 hours", "between 8 and 16 hours", "between 16 and 24 hours", "after one day"]
ans = 1
radioq(choices, ans)


choices = [L"a slant asymptote with slope $50$",
L"a horizontal asymptote $y=20$",
L"a horizontal asymptote $y=0$",
L"a vertical asymptote with $x = 20^{1/3}$"]
ans = 3
radioq(choices, ans)


yesnoq(false)


choices = [
L"The $\sin(x)$ oscillates, but the rational function eventually follows $7/60 \cdot x^3$",
L"The $\sin(x)$ oscillates, but the rational function has a slant asymptote",
L"The $\sin(x)$ oscillates, but the rational function has a non-zero horizontal asymptote",
L"The $\sin(x)$ oscillates, but the rational function has a horizontal asymptote of $0$"]
ans = 2
radioq(choices, ans)

