
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots
position(t) = 60 * t
plot(position, 0, 3)


plotly()
plot(sin, 0, 2pi)


15/(1/2)


function position(t)
  if t <= 3
     60*t
  elseif 3 < t <= 3.5
     position(3) + 30(t -3)
  elseif 3.5 < t <= 4
     position(3.499)  + 75(t-3.5)
  elseif 4 < t <= 4.5
     position(4)
  else
     position(4) + 60(t-4.5)
  end
end
plot(position, 0, 6)


180/3


15/(1/2)


37.5 / (1/2)


function speed(t)
  if     0   < t <= 3
     60
  elseif 3   < t <= 3.5
     30
  elseif 3.5 < t <= 4
     75
  elseif 4   < t <= 4.5
     0
  else
     60
  end
end
plot(speed, 0, 6)


note("""

We were pretty loose with some key terms. There is a distinction
between "speed" and "velocity", this being the speed is the absolute
value of velocity. Velocity incorporates a direction as well as a
magnitude. Similarly, distance traveled and change in position are not
the same thing when there is back tracking involved. The total
distance traveled is computed with the speed, the change in position
is computed with the velocity. When there is no change of sign, it is
a bit more natural, perhaps, to use the language of speed and
distance.

""")


using DataFrames
ts = [0,1,2,3,4,5]
dxs = [0,1,3, 5, 7, 9]
ds = [0,1,4,9,16,25]
d = DataFrame(t=ts, delta=dxs, distance=ds)
table(d)


ts = [0,1,2,3,4, 5]
xs = [0,1,4,9,16,25]
plot(ts, xs)


(9-0) / (3-0)  # (xs[4] - xs[1]) / (ts[4] - ts[1])


(9-4) / (3-2)  # (xs[4] - xs[3]) / (ts[4] - ts[3])


xs[2]-xs[1], xs[3] - xs[2], xs[4] - xs[3], xs[5] - xs[4]


pyplot()
fig_size=(600, 400)

function secant_line_tangent_line_graph(n)
    f(x) = sin(x)
    c = pi/3
    h = 2.0^(-n) * pi/4
    m = (f(c+h) - f(c))/h

    xs = range(0, stop=pi, length=50)
    plt = plot(f, 0, pi, legend=false, size=fig_size)
    plot!(plt, xs, f(c) .+ cos(c)*(xs .- c), color=:orange)
    plot!(plt, xs, f(c) .+ m*(xs .- c), color=:black)
    scatter!(plt, [c,c+h], [f(c), f(c+h)], color=:orange, markersize=5)

    plot!(plt, [c, c+h, c+h], [f(c), f(c), f(c+h)], color=:gray30)
    annotate!(plt, [(c+h/2, f(c), text("h", :top)), (c + h + .05, (f(c) + f(c + h))/2, text("f(c+h) - f(c)", :left))])

    plt
end
caption = L"""

The slope of each secant line represents the *average* rate of change between $c$ and $c+h$. As $h$ goes towards $0$, we recover the slope of the tangent line, which represents the *instantatneous* rate of change.

"""



n = 5
anim = @animate for i=0:n
    secant_line_tangent_line_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


function line_approx_fn_graph(n)
    f(x) = sin(x)
    c = pi/3
    h = round(2.0^(-n) * pi/2, digits=2)
    m = cos(c)

    Delta = max(f(c) - f(c-h), f(min(c+h, pi/2)) - f(c))

    p = plot(f, c-h, c+h, legend=false, xlims=(c-h,c+h), ylims=(f(c)-Delta,f(c)+Delta ))
    plot!(p, x -> f(c) + m*(x-c))
    scatter!(p, [c], [f(c)])
    p
end
caption = L"""

The tangent line is the best linear approximation to the function at the point $(c, f(c))$. As the viewing window zooms in on $(c,f(c))$ we
    can see how the graph and its tangent line get more similar.

"""

pyplot()
n = 6
anim = @animate for i=1:n
    line_approx_fn_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


note("""
This last point was certainly not obvious at
first. [Barrow](http://www.maa.org/sites/default/files/0746834234133.di020795.02p0640b.pdf),
who had Newton as a pupil and was the first to sketch a proof of part
of the Fundamental Theorem of Calculus, understood a tangent line to
be a line that intersects a curve at only one point.
""")


f(x) = sin(x)
c = 0
tl(x) = f(c) + 1 * (x - c)
plot(f, -pi/2, pi/2)
plot!(tl, -pi/2, pi/2)


@vars x h real=true
n = 5
ex = expand((x+h)^n - x^n)


cancel(ex/h, h)


ex = sympy.expand_trig(sin(x+h) - sin(x))  # expand_trig is not exposed in `SymPy`


limit((sin(x+h) - sin(x))/ h, h=>0)


limit((log(x+h) - log(x))/h, h=>0)


alert(L"""

There are several different
[notations](http://en.wikipedia.org/wiki/Notation_for_differentiation)
for derivatives. Some are historical, some just add
flexibility. We use the prime notation of Lagrange: $f'(x)$, $u'$ and $[\text{expr}]'$,
where the first emphasizes that the derivative is a function with a
value at $x$, the second emphasizes the derivative operates on
functions, the last emphasize that we are taking the derivative of
some expression (the "rule" part of an unnamed function).

There are many other notations:

- The Leibniz notation uses the infinitesimals: $dy/dx$ to relate to
  $\Delta y/\Delta x$. This notation is very common, and especially
  useful when more than one variable is involved.  `SymPy` uses
  Leibniz notation in some of its output, expressing somethings such
  as:

$$~
f'(x) = \frac{d}{d\xi}(f(\xi)) \big|_{\xi=x}.
~$$

  The notation - $\big|$ - on the right-hand side separates the tasks of finding the
  derivative and evaluating the derivative at a specific value.

- Euler used `D` for the operator `D(f)`. This notation is appropriated by an
  operator in the `CalculusWithJulia` package. This was initially used by
  [Argobast](http://jeff560.tripod.com/calculus.html).

- Newton used a "dot" $\dot{x}(t)$, which is still widely used in physics to indicate  a derivative in time.




""")


u,v = SymFunction("u,v") # make symbolic functions
f(x) = u(x) * v(x)
limit((f(x+h) - f(x))/h, h=>0)


limit(( u(v(x+h)) - u(v(x)) ) / (v(x+h) - v(x)), h=>0)


diff(x^5 * sin(x))


diff(x^5/sin(x))


diff(sin(x^5))


diff(sin(x)^5)


note("""
The `diff` function can be called as `diff(ex)` when there is just one
free variable, as in the above examples; as  `diff(ex, var)` when there are parameters in the
expression; or, as `diff(f)`, where `f` is the name of a univariate function.
"""
)


using DataFrames
nm = ["Power rule", "constant", "sum/difference", "product", "quotient", "chain"]
rule = [L"[x^n]' = n\cdot x^{n-1}",
 L"[cf(x)]' = c \cdot f'(x)",
 L"[f(x) \pm g(x)]' = f'(x) \pm g'(x)",
 L"[f(x) \cdot g(x)]' = f'(x)\cdot g(x) + f(x) \cdot g'(x)",
 L"[f(x)/g(x)]' = (f'(x) \cdot g(x) - f(x) \cdot g'(x)) / g(x)^2",
 L"[f(g(x))]' = f'(g(x)) \cdot g'(x)"]
d = DataFrame(Name=nm, Rule=rule)
table(d)


fn = [L"x^n \text{ all } n",
L"e^x",
L"\log(x)",
L"\sin(x)",
L"\cos(x)"]
a = [L"nx^{n-1}",
L"e^x",
L"1/x",
L"\cos(x)",
L"-\sin(x)"]
d = DataFrame(Function=fn, Derivative=a)
table(d)


diff(diff(e^(-x^2))) |> simplify


diff(e^(-x^2), x, x) |> simplify


args, funcname = SymPy.Introspection.args, SymPy.Introspection.funcname # args, funcname are not exported
@vars x y z


ex = x + y + z
funcname(ex)


args(ex)


ex = x^2 + sin(x) + sqrt(x^2 + 2)
funcname(ex)


args(ex)


ex = x * y * z
funcname(ex)


args(ex)


ex = x^4
funcname(ex)


ex = x/y
funcname(ex)


args(ex)


ex = 1/y
funcname(ex)


funcname(x)


funcname(Sym(3))


args(x), args(Sym(3))


function diffex(ex)
    n = length(free_symbols(ex))

    n == 0 && return Sym(0)
    n > 1 && error("This is a simple example, use diff")

    _diff(Val{Symbol(funcname(ex))}, args(ex)...)
end


_diff(::Type{Val{:Add}}, xs...) = sum(diffex(ex) for ex in xs)


function _diff(::Type{Val{:Mul}}, fs...)
    f = prod(fs)
    sum(diffex(fi)/fi * f for fi in fs)
end


_diff(::Type{Val{:Pow}}, a, b) = sympy.powsimp(a^b * diffex(b * log(a)))


_diff(::Type{Val{:Symbol}}) = Sym(1)


_diff(::Any) = Sym(0)


_diff(::Type{Val{:log}}, ex) =  1/ex * diffex(ex)


_diff(::Type{Val{:exp}}, ex) = exp(ex) * diffex(ex)


_diff(::Type{Val{:sin}}, ex) =  cos(ex)   * diffex(ex)
_diff(::Type{Val{:cos}}, ex) = -sin(ex)   * diffex(ex)
_diff(::Type{Val{:tan}}, ex) =  sec(ex)^2 * diffex(ex)


diffex(x^5 + x^4 + x^3 + x^2 + x + 1)


diffex(sin(x^2) + cos(1/x))


diffex(x^x * exp(x))


fn = x -> -x*exp(x)*sin(pi*x)
plot(fn, 0, 2)


choices = [L"1/2", L"1", L"3/2"]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [L"f(1)", L"f(3/2)"]
ans = 2
radioq(choices, ans, keep_order=true)


numericq(0, 1e-2)


import SpecialFunctions: airyai
plot(airyai, -5, 5)


choices = ["positive", "negative"]
ans = 1
radioq(choices, ans, keep_order=true)


choices = ["positive", "negative"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = ["positive", "negative"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [L"e^x", L"x^e", L"(e-1)x^e", L"e x^{(e-1)}", "something else"]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [L"e^x", L"x^e", L"(e-1)x^e", L"e x^{(e-1)}", "something else"]
ans = 5
radioq(choices, ans, keep_order=true)


choices = [L"e^x", L"x^e", L"(e-1)x^e", L"e x^{(e-1)}", L"e \cdot e^{e\cdot x}", "something else"]
ans = 5
radioq(choices, ans, keep_order=true)


choices = [
L" $1$, as this is clearly the analog of the limit of $\sin(h)/h$.",
L"Does not exist. The answer is $0/0$ which is undefined",
L" $0$,  as this expression is the derivative of cosine at $0$. The answer follows, as cosine clearly has a tangent line with slope $0$  at $x=0$."]
ans = 3
radioq(choices, ans)


choices = [
L"f'(x) =  g(x)",
L"f'(x) = -g(x)",
L"f'(x) =  f(x)",
L"f'(x) = -f(x)"
]
ans= 1
radioq(choices, ans)


choices = [
L"f''(x) =  g(x)",
L"f''(x) = -g(x)",
L"f''(x) =  f(x)",
L"f''(x) = -f(x)"]
ans= 3
radioq(choices, ans)


yesnoq("yes")


yesnoq("no")


yesnoq("yes")


yesnoq("no")


yesnoq("no")


choices = [
L"If the graphs of $f$ and $g$ are translations up and down, the tangent line at corresponding points is unchanged.",
L"If the graphs of $f$ and $g$ are rescalings of each other through $g(x)=f(x/c)$, $c > 1$. Then the tangent line for corresponding points is the same.",
L"If the graphs of $f$ and $g$ are rescalings of each other through $g(x)=cf(x)$, $c > 1$. Then the tangent line for corresponding points is the same."
]
ans = 1
radioq(choices, ans)


## dv/dt = dv/dh * dh/dt = 3h * 2t
h = 14; t=3
val = (3*h) * (2*t)
numericq(val)


choices = [
L"f'(x) = k^2\cdot f(x)",
L"f'(x) = -k^2\cdot f(x)",
L"f''(x) = k^2\cdot f(x)",
L"f''(x) = -k^2\cdot f(x)"]
ans = 4
radioq(choices, ans)


choices = [
L"f'(x) = k^2\cdot f(x)",
L"f'(x) = -k^2\cdot f(x)",
L"f''(x) = k^2\cdot f(x)",
L"f''(x) = -k^2\cdot f(x)"]
ans = 3
radioq(choices, ans)

