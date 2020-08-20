
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia  # Loads `SymPy`, `ForwardDiff`, `Roots`
using Plots
f(x) = abs(x)
plot(f, -1,1)


f(x) = (x^2)^(1/3)
plot(f, -1, 1)


f(x) = cbrt(x)
plot(f, -1, 1)


note("""

The `cbrt` function is used above, instead of `f(x) = x^(1/3)`, as the
latter is not defined for negative `x`. Though it can be for the exact
power `1/3`, it can't be for an exact power like `1/2`. This means the
value of the argument is important in determining the type of the
output - and not just the type of the argument. Having type-stable
functions is part of the magic to making `Julia` run fast, so `x^c` is
not defined for negative `x` and most floating point exponents.

""")


note("""

A hiker can appreciate the difference. A relative maximum would be the
crest of any hill, but an absolute maximum would be the summit.

""")


### {{{lhopital_32}}}
imgfile = "figures/lhopital-32.png"
caption =  L"""
Image number 32 from L'Hopitals calculus book (the first) showing that
at a relative minimum, the tangent line is parallel to the
$x$-axis. This of course is true when the tangent line is well defined
by Fermat's observation.
"""
ImageFile(imgfile, caption)


f(x) = 3x^3 - 2x
fp(x) = 9x^2 - 2
f'(3), fp(3)


f(x) = x^2 * exp(-x)
cps = find_zeros(f', -1, 6)     # find_zeros in `Roots`


f(0), f(2), f(5)


a, b = 0, 5
cps = find_zeros(f', a, b)
f.(cps), f(a), f(b)


note("""

If you don't like how the output has the values at critical points in a vector, the following, though a bit cryptic, could be done: `f.( (cps..., a, b) )`

""")


f(x) = exp(x) * (x^3 - x)
cps = find_zeros(f', 0, 2)


f.(cps), f(0), f(2)


note(L"""

**Absolute minimum** We haven't discussed the parallel problem of
  absolute minima over a closed interval. By considering the function
  $h(x) = - f(x)$, we see that the any thing true for an absolute
  maximum should hold in a related manner for an absolute minimum, in
  particular an absolute minimum on a closed interval will only occur
  at a critical point or an end point.

""")


f(x) = exp(x) * x * (x-1)
find_zeros(f', 0, 1)


x0 = fzero(f', 0, 1)
plot([f, x->f(x0) + 0*(x-x0)], 0, 1)


f(x) = x^3 - x
a, b = -2, 1.75
m = (f(b) - f(a)) / (b-a)
cps = find_zeros(x -> f'(x) - m, a, b)

p = plot(f, a-1, b+1,         linewidth=3, legend=false)
plot!(x -> f(a) + m*(x-a),  a-1, b+1,   linewidth=3, color=:orange)
scatter!([a,b], [f(a), f(b)])

for cp in cps
  plot!(x -> f(cp) + f'(cp)*(x-cp), a-1, b+1, color=:red)
end
p


### {{{parametric_fns}}}

using Printf
pyplot()
fig_size = (600, 400)


function parametric_fns_graph(n)
    f = (x) -> sin(x)
    g = (x) -> x

    ns = (1:10)/10
    ts = range(-pi/2, stop=-pi/2 + ns[n] * pi, length=100)

    plt = plot(f, g, -pi/2, -pi/2 + ns[n] * pi, legend=false, size=fig_size,
               xlim=(-1.1,1.1), ylim=(-pi/2-.1, pi/2+.1))
    scatter!(plt, [f(ts[end])], [g(ts[end])], color=:orange, markersize=5)
    val = @sprintf("% 0.2f", ts[end])
    annotate!(plt, [(0, 1, "t = $val")])
end
caption = L"""

Illustration of parametric graph of $(g(t), f(t))$ for $-\pi/2 \leq t
\leq \pi/2$ with $g(x) = \sin(x)$ and  $f(x) = x$. Each point on the
graph is from some value $t$ in the interval. We can see that the
graph goes through $(0,0)$ as that is when $t=0$. As well, it must go
through $(1, \pi/2)$ as that is when $t=\pi/2$

"""


n = 10
anim = @animate for i=1:n
    parametric_fns_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)


plotly()
ImageFile(imgfile, caption)


g(x) = sin(x)
f(x) = x
ts = range(-pi/2, stop=pi/2, length=50)
a,b = 0, pi/2
m = (f(b) - f(a))/(g(b) - g(a))
cps = find_zeros(x -> f'(x)/g'(x) - m, -pi/2, pi/2)
c = cps[1]
Delta = (0 + m * (c - 0)) - (g(c))

p = plot(g, f, -pi/2, pi/2, linewidth=3, legend=false)
plot!(x -> f(a) + m * (x - g(a)), -1, 1, linewidth=3, color=:red)
scatter!([g(a),g(b)], [f(a), f(b)])
for c in cps
  plot!(x -> f(c) + m * (x - g(c)), -1, 1, color=:orange)
end

p


c = pi/2
numericq(c)


c = pi
numericq(c)


c = 0
numericq(c)


c = 1
numericq(c)


using SymPy
c,x = symbols("c, x", real=true)
val = solve(3c^2 / (2c) - (2^3 - 1^3) / (2^2 - 1^2), c)[1]
numericq(float(val))


radioq(["Yes", "No"], 2)


choices = [
L"h(x) = f(x) - (f(b) - f(a)) / (b - a)",
L"h(x) = f(x) - (f(b) - f(a)) / (b - a) \cdot g(x)",
L"h(x) = f(x) - g(x)",
L"h(x) = f'(x) - g'(x)"
]
ans = 3
radioq(choices, ans)


choices = [
L"It isn't. The function $f(x) = x^2$ has two zeros and $f''(x) = 2 > 0$",
"By the Rolle's theorem, there is at least one, and perhaps more",
L"By the mean value theorem, we must have $f'(b) - f'(a) > 0$ when ever $b > a$. This means $f'(x)$ is increasing and can't double back to have more than one zero."
]
ans = 3
radioq(choices, ans)


choices = [
L"c = (a+b)/2",
L"c = \sqrt{ab}",
L"c = 1 / (1/a + 1/b)",
L"c = a + (\sqrt{5} - 1)/2 \cdot (b-a)"
]
ans = 2
radioq(choices, ans)


choices = [
L"c = (a+b)/2",
L"c = \sqrt{ab}",
L"c = 1 / (1/a + 1/b)",
L"c = a + (\sqrt{5} - 1)/2 \cdot (b-a)"
]
ans = 1
radioq(choices, ans)


choices = [L"The squeeze theorem applies, as $0 < g(x) < x$.",
L"As $f(x)$ goes to zero by Rolle's theorem it must be that $g(x)$ goes to $0$.",
L"This follows by the extreme value theorem, as there must be some $c$ in $[0,x]$."]
ans = 1
radioq(choices, ans)


choices = ["It isn't true. The limit must be 0",
L"The squeeze theorem applies, as $0 < g(x) < x$",
"This follows from the limit rules for composition of functions"]
ans = 3
radioq(choices, ans)

