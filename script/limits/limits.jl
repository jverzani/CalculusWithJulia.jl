
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


###{{{archimedes_parabola}}}
pyplot()
fig_size=(400, 300)

f(x) = x^2
colors = [:black, :blue, :orange, :red, :green, :orange, :purple]

## Area of parabola
function make_triangle_graph(n)
    title = "Area of parabolic cup ..."
    n==1 && (title = "\${Area = }1/2\$")
    n==2 && (title = "\${Area = previous }+ 1/8\$")
    n==3 && (title = "\${Area = previous }+ 2*(1/8)^2\$")
    n==4 && (title = "\${Area = previous }+ 4*(1/8)^3\$")
    n==5 && (title = "\${Area = previous }+ 8*(1/8)^4\$")
    n==6 && (title = "\${Area = previous }+ 16*(1/8)^5\$")
    n==7 && (title = "\${Area = previous }+ 32*(1/8)^6\$")



    plt = plot(f, 0, 1, legend=false, size = fig_size, linewidth=2)
    annotate!(plt, [(0.05, 0.9, text(title,:left))])  # if in title, it grows funny with gr
    n >= 1 && plot!(plt, [1,0,0,1, 0], [1,1,0,1,1], color=colors[1], linetype=:polygon, fill=colors[1], alpha=.2)
    n == 1 && plot!(plt, [1,0,0,1, 0], [1,1,0,1,1], color=colors[1], linewidth=2)
    for k in 2:n
        xs = range(0,stop=1, length=1+2^(k-1))
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


x = 1/10000
(1 + x)^(1/x)


f(x) = (1 + x)^(1/x)
xs = [1/10^i for i in 1:5]
[xs f.(xs)]


0/0, Inf/Inf, 0 * Inf, Inf - Inf


0^0, 1^Inf, Inf^0


x = 1
sin(x) / x


x = 0
sin(x) / x


using CalculusWithJulia  # loads SymPy
using Plots
f(x) = sin(x)/x
plot(f, -pi/2, pi/2)


plot([sin, x -> x], -pi/2,  pi/2)


f(x) = (x^2 - 5x + 6) / (x^2 + x - 6)
c = 2
f(c)


c, delta = 2, 1
plot(f, c - delta, c + delta)


f(x) = x == 2.0 ? -0.2 :  (x^2 - 5x + 6) / (x^2 + x - 6)


f(x) = (sqrt(x) - 5) / (sqrt(x-16) - 3)
c = 25
f(c)


hs = [1/10^i for i in 1:8]


xs = c .+ hs
ys = f.(xs)


[xs ys]


xs = c .- hs
ys = f.(xs)
[xs ys]


c = 1
f(x) = x^x
ys = [(f(c + h) - f(c)) / h for  h in hs]
[hs ys]


ys = [(f(c + h) - f(c)) / h for  h in -hs]
[-hs ys]


f(x) = (1 - cos(x)) / x^2
f(0)


c = 0
xs = c .+ hs
ys = [f(x) for x in xs]
[xs ys]


y1s = [1 - cos(x) for x in xs]
y2s = [x^2 for x in xs]
[xs y1s y2s]


@vars x real=true
f(x) = (1 - cos(x)) / x^2
limit(f(x), x=>0)		# f(x) is a symbolic expression when x is


limit(f, 0)


limit( (2sin(x) - sin(2x)) / (x - sin(x)), x=>0)


f(x) = (exp(x) - 1 - x) / x^2
limit(f, 0)


@vars rho real=true
limit( (x^(1-rho) - 1) / (1 - rho), rho=>1)


c = pi/2
f(x) = cos(x) / (x - pi/2)
f(c)


limit(f(x), x=>PI/2)


plot(f, c - pi/4, c + pi/4)


f(x) = cos(x) / (x - PI/2)
limit(f(x), x => PI/2)


using DataFrames
rules = [L"\lim_{x \rightarrow c} (a \cdot f(x) + b \cdot g(x)) = a \cdot
  \lim_{x \rightarrow c} f(x) + b \cdot \lim_{x \rightarrow c}
  g(x)",
  L"\lim_{x \rightarrow c} f(x) \cdot g(x) = \lim_{x \rightarrow c}
  f(x) \cdot \lim_{x \rightarrow c} g(x)",
  L" $\lim_{x \rightarrow c} f(x) / g(x) = \lim_{x \rightarrow c} f(x) /
  \lim_{x \rightarrow c} g(x)$ - provided $\lim_{x \rightarrow c} g(x) \neq 0$",
  L" $\lim_{x \rightarrow c} (f \circ g)(x) = \lim_{x \rightarrow L}
  f(x)$, where $\lim_{x \rightarrow c}g(x) = L$"]
descr = [""" This says that limits involving sums, differences or scalar
  multiples of functions can be computed by first doing the individual
  limits and then combining the answers.""",
  """This says limits of
  products can be found by computing the limit of the individual
  factors and then combining.""",
  L"""This says limits of ratios can be found by computing
  the limit of the individual terms and then dividing provided you
  don't divide by $0$. The last part is really important, as this rule
  is no help with the common indeterminate form $0/0$.""",
  L"""This says the limit of
  compositions can be found by taking the limit of the interior
  function ($L$) and then finding the limit of the exterior function
  as $x$ approaches $L$."""]
  d = DataFrame(Rule=rules, Description=descr)
  table(d)


g(x) = cos(PI*x) / (1 - (2x)^2)
limit(g, 1//2)


limit(sin(PI*x)/(PI*x) * g(x), x=>1//2)


plot(cos(pi*x), 0.4, 0.6)
plot!(1 - (2x)^2)


plot(cos(pi*x), 0.4, 0.6)
plot!(-pi*(x - 1/2))


plot(1 - (2x)^2, 0.4, 0.6)
plot!(-4(x - 1/2))


f(x) = 3x + 2
c, L = 1, 5
epsilon = rand()                 # some number in (0,1)
delta = epsilon / 3
xs = c .+ delta * rand(100)       # 100 numbers, c < x < c + delta
as = [abs(f(x) - L) < epsilon for x in xs]
all(as)                          # are all the as true?


## {{{ limit_e_d }}}
pyplot()
function make_limit_e_d(n)
    f(x) = x^3

    xs = range(-.9, stop=.9, length=50)
    ys = map(f, xs)


    plt = plot(f, -.9, .9, legend=false, size=fig_size)
    if n == 0
        nothing
    else
        k = div(n+1,2)
        epsilon = 1/2^k
        delta = cbrt(epsilon)
        if isodd(n)
            plot!(plt, xs, 0*xs .+ epsilon, color=:orange)
            plot!(plt, xs, 0*xs .- epsilon, color=:orange)
        else
            plot!(delta * [-1,  1], epsilon * [ 1, 1], color=:orange)
            plot!(delta * [ 1, -1], epsilon * [-1,-1], color=:orange)
            plot!(delta * [-1, -1], epsilon * [-1, 1], color=:red)
            plot!(delta * [ 1,  1], epsilon * [-1, 1], color=:red)
        end
    end
    plt
end


n = 11
anim = @animate for i=1:n
    make_limit_e_d(i-1)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)


caption = L"""

Demonstration of $\epsilon$-$\delta$ proof of $\lim_{x \rightarrow 0}
x^3 = 0$. For any $\epsilon>0$ (the orange lines) there exists a
$\delta>0$ (the red lines of the box) for which the function $f(x)$
does not leave the top or bottom of the box (except possibly at the
edges). In this example $\delta^3=\epsilon$.

"""

plotly()
ImageFile(imgfile, caption)


f(x) = (x^2 - 3x +2) / (x^2 - 6x + 5)
plot(f, 0,2)


ans = 1/4
numericq(ans, 1e-1)


f(x) = x/(x+1)*x^2/(x^2+4)
plot(f, -3, -1.25)


f(x) = x/(x+1)*x^2/(x^2+4)
val = f(-2)
numericq(val, 1e-1)


f(x) = (exp(x) - 1)/x
p = plot(f, -1, 1)


val = N(limit(f, 0))
numericq(val, 1e-1)


val = 0
numericq(val, 1e-2)


choices = [L"0", L"1", L"e^x"]
ans = 3
radioq(choices, ans)


choices = [L"\cos(x)", L"\sin(x)", "1", "0", L"\sin(h)/h"]
ans = 1
radioq(choices, ans)


f(x) = x == 0 ? NaN : x * sin(1/x)
c, delta = 0, 1/4
plot([f, abs, x -> -abs(x)], c - delta, c + delta)


choices=[L"""The functions $g$ and $h$ both have a limit of $0$ at $x=0$ and the function $f$ is in
between both $g$ and $h$, so must to have a limit of $0$.
""",
	L"The functions $g$ and $h$ squeeze each other as $g(x) > h(x)$",
         L"The function $f$ has no limit - it oscillates too much near $0$"]
ans = 1
radioq(choices, ans)


f(x) = (3x^2 - x - 10)/(x^2 - 4);
val = convert(Float64, N(limit(f, 2)))
numericq(val)


f(x) = ((1/x) + (1/2))/(x^3 + 8)
numericq(-1/48, .001)


f(x) = (x - 27)/(x^(1//3) - 3)
val = N(limit(f, 27))
numericq(val)


f(x) = tan(2x)/(x-PI/2)
val = N(limit(f, PI/2))
numericq(val)


choices = [q"0", q"1", q"pi/180", q"180/pi"]
ans = 3
radioq(choices, ans)


choices = [q"0", q"1", q"pi", q"1/pi"]
ans = 3
radioq(choices, ans)


f(x) = sin(x) + tan(x) + cos(x)
numericq(f(0), 1e-5)


choices = [
"Yes, the value is `-9.2061`",
"Yes, the value is `-11.5123`",
"No, the value heads to negative infinity"
];
ans = 3;
radioq(choices, ans)


f(x) = x/(x-1) - 1/log(x)
val = convert(Float64, N(limit(f, 1)))
numericq(val)


f(x) =  1/PI * cos(PI*x)/(1 - (2x)^2)
val = N(limit(f, 1//2))
numericq(val)

