
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia   # loads `QuadGK`, `Roots`, ...
using Plots
f(x) = 1 - abs(x)
plot([f, zero], -1, 1)


f(x) = 1
plot([f, zero], 0, 1)


f(x) = sqrt(1 - x^2)
plot([f, zero], -1, 1)


f(x) = x > 1 ? 2 - x : 1.0
plot([f, zero], 0, 2)


## {{{archimedes_parabola}}}
pyplot()
fig_size = (600, 400)


f(x) = x^2
colors = [:black, :blue, :orange, :red, :green, :orange, :purple]

## Area of parabola

## Area of parabola
function make_triangle_graph(n)
    title = "Area of parabolic cup ..."
    n==1 && (title = "Area = 1/2")
    n==2 && (title = "Area = previous + 1/8")
    n==3 && (title = "Area = previous + 2*(1/8)^2")
    n==4 && (title = "Area = previous + 4*(1/8)^3")
    n==5 && (title = "Area = previous + 8*(1/8)^4")
    n==6 && (title = "Area = previous + 16*(1/8)^5")
    n==7 && (title = "Area = previous + 32*(1/8)^6")



    plt = plot(f, 0, 1, legend=false, size = fig_size, linewidth=2)
    annotate!(plt, [(0.05, 0.9, text(title,:left))])  # if in title, it grows funny with gr
    n >= 1 && plot!(plt, [1,0,0,1, 0], [1,1,0,1,1], color=colors[1], linetype=:polygon, fill=colors[1], alpha=.2)
    n == 1 && plot!(plt, [1,0,0,1, 0], [1,1,0,1,1], color=colors[1], linewidth=2)
    for k in 2:n
        xs = range(0, stop=1, length=1+2^(k-1))
        ys = map(f, xs)
        k < n && plot!(plt, xs, ys, linetype=:polygon, fill=:black, alpha=.2)
        if k == n
            plot!(plt, xs, ys, color=colors[k], linetype=:polygon, fill=:black, alpha=.2)
            plot!(plt, xs, ys, color=:black, linewidth=2)
        end
    end
    plt
end



n = 7
anim = @animate for i=1:n
    make_triangle_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)


caption = L"""
The first triangle has area $1/2$, the second has area $1/8$, then $2$ have area $(1/8)^2$, $4$ have area $(1/8)^3$, ...
With some algebra, the total area then should be $1/2 \cdot (1 + (1/4) + (1/4)^2 + \cdots) = 2/3$.
"""

plotly()
ImageFile(imgfile, caption)


imgfile = "figures/beeckman-1618.png"
caption = L"""

Figure of Beeckman (1618) showing a means to compute the area under a
curve, in this example the line connecting points $A$ and $B$. Using
approximations by geometric figures with known area is the basis of
Riemann sums.

"""
ImageFile(imgfile, caption)


note("""

The above approach, like Archimedes', ends with a limit being
taken. The answer comes from using a limit to add a big number of
small values. As with all limit questions, worrying about whether a
limit exists is fundamental. For this problem, we will see that for
the general statement there is a stretching of the concept of a limit.

""")


note(L"""

There is a more compact notation to $x_1 + x_2 + \cdots + x_n$, this using the *summation notation* or capital sigma. We have:

$$~
\Sigma_{i = 1}^n x_i = x_1 + x_2 + \cdots + x_n
~$$

The notation includes three pieces of information:

- The $\Sigma$ is an indication of a sum

- The ${i=1}$ and $n$ sub- and superscripts indicate the range to sum over.

- The term $x_i$ is a general term describing the $i$th entry, where it is understood that $i$ is just some arbitrary indexing value.

With this notation, a Riemann sum can be written  as $\Sigma_{i=1}^n f(c_i)(x_i-x_{i-1})$.
""")


note(L"""

The expression $V = \int_a^b f(x) dx$ is known as the *definite
integral* of $f$ over $[a,b]$.
Much earlier than Riemann, Cauchy had defined the definite integral in terms of a sum of rectangular
products beginning with $S=(x_1 - x_0) f(x_0) + (x_2 - x_1) f(x_1) +
\cdots + (x_n - x_{n-1}) f(x_{n-1})$ (the left Riemann sum). He showed
the limit was well defined for any continuous function. Riemann's
formulation relaxes the choice of partition and the choice of the
$c_i$ so that integrability can be better understood.

""")


a, b = 0, 1
f(x) = x^2


n = 5
xs = a:(b-a)/n:b       # also range(a, b, length=n)
deltas = diff(xs)      # forms x2-x1, x3-x2, ..., xn-xn-1
cs = xs[1:end-1]       # finds left-hand end points. xs[2:end] would be right-hand ones.


sum(f(cs[i]) * deltas[i] for i in 1:length(deltas))


a, b = 0, 1
f(x) = x^2
n = 50_000
xs = a:(b-a)/n:b
deltas = diff(xs)
cs = xs[1:end-1]
sum(f(cs[i]) * deltas[i] for i in 1:length(deltas))


function riemann(f, a, b, n; method="left")
  xs = a:(b-a)/n:b
  deltas = diff(xs)      # forms x2-x1, x3-x2, ..., xn-xn-1
  if method == "left"
    cs = xs[1:end-1]
  elseif method == "right"
    cs = xs[2:end]
  else
    cs = [(xs[i] + xs[i+1])/2 for i in 1:length(deltas)]
  end
  sum(f(cs[i]) * deltas[i] for i in 1:length(deltas))
end


f(x) = exp(x)
riemann(f, 0, 5, 10)   # S_10


riemann(f, 0, 5, 50_000)


f(x) = abs(x) > 2 ? 1.0 : abs(x) - 1.0
plot([f, zero], -3,3)


f(x) = x > 0 ? x * log(x) : 0.0


f(x) = x * log(x)
riemann(f, 0, 2, 50_000, method="right")


xs = range(-1, 1, length=5)
deltas = diff(xs)
cs = [-3/4, -1/4, 1/4, 3/4]
f(x) = sqrt(1 - x^2)
a = sum(f(c)*delta for (c,delta) in zip(cs, deltas))


2a


note(L"""

The Wikipedia article mentions that Kepler used a similar formula $100$
years prior to Simpson, or about $200$ years before Riemann published
his work. Again, the value in Riemann's work is not the computation of
the answer, but the framework it provides in determining if a function
is Riemann integrable or not.

""")


using QuadGK       # loaded with CalculusWithJulia
f(x) = x * log(x)
quadgk(f, 0, 2)


f(x) = x^5 - x + 1
quadgk(f, -2, 2)


quadgk(sin, 0, pi)


f(x) = x^x
quadgk(f, 0, 2)


quadgk(exp, 0, 5)


A, err = quadgk(cos, 0, pi/4)
A


A = quadgk(tan, 0, pi/4)[1]


f(x) = exp(cos(x))
A,err = quadgk(f, -pi, pi)


C = 1/A
f(x) = C * exp(cos(x))


F(x) = quadgk(f, -pi, x)[1]


using Roots     # loaded with `CalculusWithJulia`
[find_zero(x -> F(x) - p, (-pi, pi)) for p in [0.25, 0.5, 0.75]]


f(x) = sqrt(5^2 - x^2)
val, _ = quadgk(f, -5,5)
numericq(val)


f(x) = 2- abs(x)
a,b = -2, 2
val, _ = quadgk(f, a,b)
numericq(val)


f(x) = x <= 3 ? 3.0 : 3 + 3*(x-3)
a,b = 0, 9
val, _ = quadgk(f, a, b)
numericq(val)


f(x) = floor(x)
a, b = 0, 5
val, _ = quadgk(f, a, b)
numericq(val)


function f(x)
  if x < -1
    abs(x+1)
  elseif -1 <= x <= 1
    sqrt(1 - x^2)
  else
    abs(x-1)
  end
end
plot(f, -3, 3, aspect_ratio=:equal)


val = (1/2 * 2 * 2) * 2 + pi*1^2/2
numericq(val)


f(x) = sin(x)
xs = -1:1/2:1
deltas = diff(xs)
val = sum(map(f, xs[1:end-1]) .* deltas)
numericq(val)


val = 0
numericq(val)


val = 1
numericq(val)


choices = [
L"1",
L"p",
L"1-p",
L"p^2"]
 ans = 3
radioq(choices, ans)


choices = [
L"2^5 - 0^5",
L"2^5/5 - 0^5/5",
L"2^4/4 - 0^4/4",
L"3\cdot 2^3 - 3 \cdot 0^3"]
ans = 2
radioq(choices, ans)


val = exp(1)
numericq(val)


val = 11
numericq(val)


choices = [
L"The area between $c$ and $b$ must be positive, so $F(c) < F(b)$.",
L"F(b) - F(c) = F(a).",
L" $F(x)$ is continuous, so between $a$ and $b$ has an extreme value, which must be at $c$. So $F(c) \geq F(b)$."
]
ans = 1
radioq(choices, ans)


choices = [
L"(10 - 0)/100 \cdot (e^{10} - e^{0})",
L"10/100",
L"(10 - 0) \cdot e^{10} / 100^4"
]
ans = 1
radioq(choices, ans)


f(x) = x^x
a, b = 1, 4
val, _ = quadgk(f, a, b)
numericq(val)


f(x) = exp(-x^2)
a, b = 0, 3
val, _ = quadgk(f, a, b)
numericq(val)


f(x) = tan(x*pi/2)
a, b = 0, 9/10
val, _ = quadgk(f, a, b)
numericq(val)


f(x) = 1/sqrt(1 - x^2)
a, b =-1/2, 1/2
val, _ = quadgk(f, a, b)
numericq(val)


ns = [-0.861136, -0.339981, 0.339981, 0.861136]


wts = [0.347855, 0.652145, 0.652145, 0.347855]


f(x) = cos(pi/2*x)
val = sum([f(wi)*ni for (wi, ni) in zip(wts, ns)])
numericq(val)


choices = [
L"around $10^{-1}$",
L"around $10^{-2}$",
L"around $10^{-4}$",
L"around $10^{-6}$",
L"around $10^{-8}$"]
ans = 4
radioq(choices, ans, keep_order=true)


f(x) = exp(x)
val = sum([f(wi)*ni for (wi, ni) in zip(wts, ns)])
numericq(val)

