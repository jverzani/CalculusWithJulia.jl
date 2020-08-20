
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


## {{{lhopitals_picture}}}
pyplot()
fig_size=(600, 400)


function lhopitals_picture_graph(n)

    g = (x) -> sqrt(1 + x) - 1 - x^2
    f = (x) -> x^2
    ts = range(-1/2, stop=1/2, length=50)


    a, b = 0, 1/2^n * 1/2
    m = (f(b)-f(a)) /  (g(b)-g(a))

    ## get bounds
    tl = (x) -> g(0) + m * (x - f(0))

    lx = max(fzero(x -> tl(x) - (-0.05),-1000, 1000), -0.6)
    rx = min(fzero(x -> tl(x) - (0.25),-1000, 1000), 0.2)
    xs = [lx, rx]
    ys = map(tl, xs)

    plt = plot(g, f, -1/2, 1/2, legend=false, size=fig_size, xlim=(-.6, .5), ylim=(-.1, .3))
    plot!(plt, xs, ys, color=:orange)
    scatter!(plt, [g(a),g(b)], [f(a),f(b)], markersize=5, color=:orange)
    plt
end

caption = L"""

Geometric interpretation of $L=\lim_{x \rightarrow 0} x^2 / (\sqrt{1 +
x} - 1 - x^2)$. At $0$ this limit is indeterminate of the form
$0/0$. The value for a fixed $x$ can be seen as the slope of a secant
line of a parametric plot of the two functions, plotted as $(g,
f)$. In this figure, the limiting "tangent" line has $0$ slope,
corresponding to the limit $L$. In general, L'Hospital's rule is
nothing more than a statement about slopes of tangent lines.

"""

n = 6
anim = @animate for i=1:n
    lhopitals_picture_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)


plotly()
ImageFile(imgfile, caption)


using CalculusWithJulia    # loads `SymPy`
@vars a x positive=true real=true
f(x) = sqrt(2a^3*x - x^4) - a * (a^2*x)^(1//3)
g(x) = a - (a*x^3)^(1//4)


f(a), g(a)


fp, gp = subs(diff(f(x),x), x=>a), subs(diff(g(x),x), x=>a)


fp/gp


limit(f(x)/g(x), x, a)


choices = [
L"0/0",
L"\infty/\infty",
L"0^0",
L"\infty - \infty",
L"0 \cdot \infty"
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"0/0",
L"\infty/\infty",
L"0^0",
L"\infty - \infty",
L"0 \cdot \infty"
]
ans =3
radioq(choices, ans, keep_order=true)


choices = [
L"0/0",
L"\infty/\infty",
L"0^0",
L"\infty - \infty",
L"0 \cdot \infty"
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"0/0",
L"\infty/\infty",
L"0^0",
L"\infty - \infty",
L"0 \cdot \infty"
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"0/0",
L"\infty/\infty",
L"0^0",
L"\infty - \infty",
L"0 \cdot \infty"
]
ans = 5
radioq(choices, ans, keep_order=true)


choices = [
L"Yes. It is of the form $0/0$",
"No. It is not indeterminate"
]
ans = 2
radioq(choices, ans)


using SymPy
f(x) = (4x - sin(x))/x
L = float(N(limit(f, 0)))
numericq(L)


using SymPy
f(x) = (sqrt(1+x) - 1)/x
L = float(N(limit(f, 0)))
numericq(L)


using SymPy
f(x) = (x - sin(x))/x^3
L = float(N(limit(f, 0)))
numericq(L)


using SymPy
f(x) = (1 - x^2/2 - cos(x))/x^3
L = float(N(limit(f, 0)))
numericq(L)


using SymPy
f(x) = 1/x - 1/sin(x)
L = float(N(limit(f, 0)))
numericq(L)


using SymPy
@vars x
L = float(N(limit(log(x)/x, x=>oo)))
numericq(L)


yesnoq(false)


choices = [
L"e^{2/\pi}",
L"{2\pi}",
L"1",
L"0",
"It does not exist"
]
ans =1
radioq(choices, ans)

