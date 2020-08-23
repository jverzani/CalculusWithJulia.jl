
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


### {{{sqrt_graph}}}
pyplot()
fig_size=(600, 400)

function make_sqrt_x_graph(n)

    b = 1
    a = 1/2^n
    xs = range(1/2^8, stop=b, length=250)
    x1s = range(a, stop=b, length=50)
    f(x) = 1/sqrt(x)
    val = N(integrate(f, 1/2^n, b))
    title = "area under f over [1/$(2^n), $b] is $(rpad(round(val, digits=2), 4))"

    plt = plot(f, range(a, stop=b, length=251), xlim=(0,b), ylim=(0, 15), legend=false, size=fig_size, title=title)
    plot!(plt,  [b, a, x1s...], [0, 0, map(f, x1s)...], linetype=:polygon, color=:orange)

    plt


end
caption = L"""

Area under $1/\sqrt{x}$ over $[a,b]$ increases as $a$ gets closer to $0$. Will it grow unbounded or have a limit?

"""
n = 10
anim = @animate for i=1:n
    make_sqrt_x_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


note("""When the integral exists, it is said to *converge*. If it doesn't exist, it is said to *diverge*.
""")


using CalculusWithJulia    # loads `SymPy`, `QuadGK`
using Plots
@vars M
limit(sympy.Si(M), M => oo)


f(x) = exp(-x^2/2)
quadgk(f, -Inf, Inf)


note(L"""

The cases $f(x) = x^{-n}$ for $n > 0$ are tricky. For $n > 1$, the functions can be integrated over $[1,\infty)$, but not $(0,1]$. For $0 < n < 1$, the functions can be integrated over $(0,1]$ but not $[1, \infty)$.

""")


@vars x
integrate(1/x, (x, -1, 1))


f(x) = 1 / sqrt(abs(x))
quadgk(f, -1, 0, 1)


yesnoq("no")


yesnoq("yes")


yesnoq("no")


yesnoq("no")


yesnoq("no")


f(x) = 1/(1+x^2)
a, b= 0, Inf
val, _ = quadgk(f, a, b)
numericq(val)


f(x) =log(x)/x^2
a, b= 1, Inf
val, _ = quadgk(f, a, b)
numericq(val)


f(x) = cbrt((x-1)^2)
val, _ = quadgk(f , 0, 1, 2)
numericq(val)


choices =[
"It is convergent",
"It is divergent",
"Can't say"]
ans = 1
radioq(choices, ans, keep_order=true)


choices =[
"It is convergent",
"It is divergent",
"Can't say"]
ans = 3
radioq(choices, ans, keep_order=true)


choices =[
"It is convergent",
"It is divergent",
"Can't say"]
ans = 2
radioq(choices, ans, keep_order=true)


choices =[
"It is convergent",
"It is divergent",
"Can't say"]
ans = 2
radioq(choices, ans, keep_order=true)


choices =[
"It is convergent",
"It is divergent",
"Can't say"]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"\int_1^\infty u^{2/3}/u^2 \cdot du",
L"\int_0^1 u^{2/3} \cdot du",
L"\int_0^\infty 1/u \cdot du"
]
ans = 1
radioq(choices, ans)


f(x) = 1/pi * 1/sqrt(x*(1-x))
a, b= 0, 1
val, _ = quadgk(f, a, b)
numericq(val)

