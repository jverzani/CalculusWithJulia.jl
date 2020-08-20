
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots


note("""
`Plots` is a frontend for one of several backends. `Plots` comes with a backend for web-based graphics (call `plotly()` to specify that); a backend for static graphs (call `gr()` for that). If the `PyPlot` package is installed, calling `pyplot()` with set that as a backend. For terminal usage, if the `UnicodePlots` package is installed, calling `unicodeplots()` will enable that usage.""")


f(x) = 1 - x^2/2
plot(f, -3, 3)


plot(sin, 0, 2pi)


f(x) = 1 / (1 + x^2)
plot(f, -3, 3)


f(x) = exp(-x^2/2)
plot(f, -2, 2)


plot(x -> cos(x) - x, 0, pi/2)


note("""

The function object in the general pattern `action(function, args...)`
is commonly specified in one of three ways: by a name, as with `f`; as an
anonymous function; or as the return value of some other action
through composition.

""")


f(x) = tan(x)
plot(f, -10, 10)


f(x) = sin(x)
xs = range(0, 2pi, length=10)
ys = f.(xs)


plot(xs, ys)


f(x) = 1/x
xs = range(-1, 1, length=251)
ys = f.(xs)
ys[xs .== 0.0] .= NaN
plot(xs, ys)


g(x) = abs(x) < .05 ? NaN : f(x)
plot(g, -1, 1)


xs = range(-pi, pi, length=100)
ys = sin.(xs)
plot(xs, ys)


plot(-xs, ys)


plot(xs, -ys)


plot(-xs,  -ys)


plot(ys, xs)


xs = range(-pi/2, pi/2, length=100)
ys = [sin(x) for x in xs]
plot(ys, xs)


f(x) = 1 - x^2/2
plot(cos, -pi/2, pi/2)
plot!(f, -pi/2, pi/2)


f(x) = x^5 - x + 1
plot(f, -1.5, 1.4)
plot!(zero, -1.5, 1.4)


plot(f, -1.5, 1.4)
plot!(zero, -1.5, 1.4)


f(x) = x*(x-1)
plot(f, -1, 2)
scatter!([0,1], [0,0])


alert("""

Julia has a convention to use functions named with a `!` suffix to
indicate that they mutate some object. In this case, the object is the
current graph, though it is implicit. Both `plot!`, `scatter!`, and
`annotate!` (others too) do this by adding a layer.

""")


f(x) = cos(x); g(x) = sin(x)
xs = range(0, 2pi, length=100)
plot(f.(xs), g.(xs))


plot(f, g, 0, 2pi)


g(x) = x^2
f(x) = x^3
plot(g, 0, 25)
plot!(f, 0, 25)


xs = range(0, 5, length=100)
plot(g, f, 0, 25)


g(x) = x - sin(x)
f(x) = x^3
plot(g, f, -pi/2, pi/2)


R, r, rho = 1, 1/4, 1/4
g(t) = (R-r) * cos(t) + rho * cos((R-r)/r * t)
f(t) = (R-r) * sin(t) - rho * sin((R-r)/r * t)

plot(g, f, 0, max((R-r)/r, r/(R-r))*2pi)


val = 3;
numericq(val, 1e-16)


choices = ["`(-Inf, -1)` and `(0,1)`",
	"`(-Inf, -0.577)` and `(0.577, Inf)`",
	"`(-1, 0)` and `(1, Inf)`"
	];
ans=3;
radioq(choices, ans)


f(x) = 3x^4 + 8x^3 - 18x^2
val = -3;
numericq(val, 0.25)


choices = ["`(-Inf, -3)` and `(0, 1)`",
	"`(-3, 0)` and `(1, Inf)`",
	"`(-Inf, -4.1)` and `(1.455, Inf)`"
	];
ans=2;
radioq(choices, ans)


val = 3;
numericq(val, .2)


choices = [
"`f(x) = x <= 35.0 ? 10.0 : 10.0 + 35.0 * (x-4)`",
"`f(x) = x <= 4    ? 35.0 : 35.0 + 10.0 * (x-4)`",
"`f(x) = x <= 10   ? 35.0 : 35.0 +  4.0 * (x-10)`"
]
ans = 3
radioq(choices, ans)


ans = 15
numericq(ans, .5)


using Roots
val = fzero(x -> cos(x) -x, .7)
numericq(val, .25)


val = fzero(x -> log(x) - 2, 8)
numericq(val, .5)


xs = range(0, 1, length=250)
f(x) = sin(500*pi*x)
plot(xs, f.(xs))


choices = [L"It oscillates wildly, as the period is $T=2\pi/(500 \pi)$ so there are 250 oscillations.",
	"It should oscillate evenly, but instead doesn't oscillate very much near 0 and 1",
	L"Oddly, it looks exactly like the graph of $f(x) = \sin(2\pi x)$."]
ans = 3
radioq(choices, ans)


choices = ["Yes",
"No, but is still looks pretty bad, as fitting 250 periods into a too small number of pixels is a problem.",
"No, the graph shows clearly all 250 periods."
]
ans = 2
radioq(choices, ans)


function trimplot(f, a, b, c=20; kwargs...)
   fn = x -> abs(f(x)) < c ? f(x) : NaN
   plot(fn, a, b; kwargs...)
end


f(x) = 1/x
trimplot(f, -1, 1)


choices = ["They appear the same, using `trimplot` just complicates things.",
           "The trimmed graph is not influenced by the vertical asymptote at 0. It is a better graph.",
           "There is an error when plotting `trimplot(f)`."]
ans = 2
radioq(choices, ans)


R, r, rho = 1, 3/4, 1/4
f(t) = (R-r) * cos(t) + rho * cos((R-r)/r * t)
g(t) = (R-r) * sin(t) - rho * sin((R-r)/r * t)

plot(f, g, 0, max((R-r)/r, r/(R-r))*2pi, aspect_ratio=:equal)


choices = [
"Four sharp points, like a star",
"Four petals, like a flower",
"An ellipse",
"A straight line"
]
ans = 2
radioq(choices, ans)


function spirograph(R, r, rho)
  f(t) = (R-r) * cos(t) + rho * cos((R-r)/r * t)
  g(t) = (R-r) * sin(t) - rho * sin((R-r)/r * t)

  plot(f, g, 0, max((R-r)/r, r/(R-r))*2pi, aspect_ratio=:equal)
end


R, r, rho = 1, 3/4, 1/4


choices = [
"Four sharp points, like a star",
"Four petals, like a flower",
"An ellipse",
"A straight line",
"None of the above"
]
ans = 1
radioq(choices, ans, keep_order=true)


R, r, rho = 1, 1/2, 1/4


choices = [
"Four sharp points, like a star",
"Four petals, like a flower",
"An ellipse",
"A straight line",
"None of the above"
]
ans = 3
radioq(choices, ans,keep_order=true)


R, r, rho = 1, 1/4, 1


choices = [
"Four sharp points, like a star",
"Four petals, like a flower",
"A circle",
"A straight line",
"None of the above"
]
ans = 2
radioq(choices, ans, keep_order=true)


R, r, rho = 1, 1/8, 1/4


choices = [
"Four sharp points, like a star",
"Four petals, like a flower",
"A circle",
"A straight line",
"None of the above"
]
ans = 5
radioq(choices, ans, keep_order=true)

