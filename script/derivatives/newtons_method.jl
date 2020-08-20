
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


x = 2//1
x = x//2 + 1//x
x, x^2.0


x = x//2 + 1//x
x, x^2.0


x = x//2 + 1//x
x, x^2.0


x = x//2 + 1//x


x = 2.0
x = x/2 + 1/x   # 1.5, 2.25
x = x/2 + 1/x   # 1.4166666666666665, 2.006944444444444
x = x/2 + 1/x   # 1.4142156862745097, 2.0000060073048824
x = x/2 + 1/x   # 1.4142135623746899, 2.0000000000045106
x = x/2 + 1/x   # 1.414213562373095,  1.9999999999999996
x = x/2 + 1/x   # 1.414213562373095,  1.9999999999999996


using Plots
f(x) = x^3 - 2x - 5
fp(x) = 3x^2 - 2
c = 2
p = plot(f, 1.75, 2.25, legend=false)
plot!(x->f(2) + fp(2)*(x-2))
plot!(zero)
scatter!(p, [c], [f(c)], color=:orange, markersize=3)
p


using CalculusWithJulia
using Plots



x0 = 2
x1 = x0 - f(x0)/f'(x0)


f(x0), f(x1)


x2 = x1 - f(x1)/ f'(x1)
x2, f(x2), f(x1)


x3 = x2 - f(x2)/ f'(x2)
x3, f(x3), f(x2)


x4 = x3 - f(x3)/ f'(x3)
x4, f(x4), f(x3)


x = 2                     # x0
x = x - f(x) / f'(x)      # x1
x = x - f(x) / f'(x)      # x2
x = x - f(x) / f'(x)      # x3
x = x - f(x) / f'(x)      # x4


note("""

Newton looked at this same example in 1699 (B.T. Polyak, *Newton's
method and its use in optimization*, European Journal of Operational
Research. 02/2007; 181(3):1086-1096.) though his technique was
slightly different as he did not use the derivative, *per se*, but
rather an approximation based on the fact that his function was a
polynomial (though identical to the derivative). Raphson (1690)
proposed the general form, hence the usual name of the Newton-Raphson
method.


""")


### {{{newtons_method_example}}}

pyplot()
fig_size = (600, 400)


function newtons_method_graph(n, f, a, b, c)

    xstars = [c]
    xs = [c]
    ys = [0.0]

    plt = plot(f, a, b, legend=false, size=fig_size)
    plot!(plt, [a, b], [0,0], color=:black)


    ts = range(a, stop=b, length=50)
    for i in 1:n
        x0 = xs[end]
        x1 = x0 - f(x0)/D(f)(x0)
        push!(xstars, x1)
            append!(xs, [x0, x1])
        append!(ys, [f(x0), 0])
    end
    plot!(plt, xs, ys, color=:orange)
    scatter!(plt, xstars, 0*xstars, color=:orange, markersize=5)
    plt
end
caption = """

Illustration of Newton's Method converging to a zero of a function.

"""
n = 6

fn, a, b, c = x->log(x), .15, 2, .2

anim = @animate for i=1:n
    newtons_method_graph(i-1, fn, a, b, c)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


@vars x real=true
solve(cos(x) - x, x)


f(x) = cos(x) - x
x = .5
x = x - f(x)/f'(x)  # 0.7552224171056364
x = x - f(x)/f'(x)  # 0.7391416661498792
x = x - f(x)/f'(x)  # 0.7390851339208068
x = x - f(x)/f'(x)  # 0.7390851332151607
x = x - f(x)/f'(x)


x, f(x)


g(q) = 1/q
h(q) = 1/17 * (48 - 32q)
plot(g, 1/2, 1)
plot!(h)


a = log2((53 + 1)/log2(17))
ceil(Integer, a)


q = 0.80
x = (48/17) - (32/17)*q
x = -q*x*x + 2*x
x = -q*x*x + 2*x
x = -q*x*x + 2*x
x = -q*x*x + 2*x


function nm(f, fp, x0)
  tol = 1e-14
  ctr = 0
  delta = Inf
  while (abs(delta) > tol) & (ctr < 50)
    delta = f(x0)/fp(x0)
    x0 = x0 - delta
    ctr = ctr + 1
  end

  ctr < 50 ? x0 : NaN
end


nm(sin, cos, 3)


f(x) = x^5 - 5^x


alpha = nm(f, f', 2)
alpha, f(alpha)


using Roots
find_zero((sin, cos), 3, Roots.Newton())  # alternatively Roots.newton(sin,cos, 3)


find_zero((f, f'), 2, Roots.Newton())


f(x) = cos(x) - x
x0 = 1
find_zero(f, x0)


find_zero(f, (0, 1))           ## [0,1] must be a bracketing interval


f(x) = cos(x)
g(x) = 5x
h(x) = f(x) - g(x)
x0 = find_zero((h,h'), 0, Roots.Newton())
x0, h(x0), f(x0), g(x0)


f(x) = sqrt(1 - cos(x^2)^2)
plot(f, 0, 1.77)


find_zero(f', 1.2)


note("""
The basic tradeoff: methods like Newton's are faster than the
bisection method in terms of function calls, but are not guaranteed to
converge, as the bisection method is.
""")


### {{{newtons_method_poor_x0}}}
pyplot()
caption = """

Illustration of Newton's Method converging to a zero of a function,
but slowly as the initial guess, is very poor, and not close to the
zero. The algorithm does converge in this illustration, but not quickly and not to the nearest root from
the initial guess.

"""

fn, a, b, c = x ->  sin(x) - x/4, -15, 20, 2pi

n = 20
anim = @animate for i=1:n
    newtons_method_graph(i-1, fn, a, b, c)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 2)

plotly()
ImageFile(imgfile, caption)


### {{{newtons_method_flat}}}
pyplot()
caption = L"""

Illustration of Newton's method failing to coverge as for some $x_i$,
$f'(x_i)$ is too close to 0. In this instance after a few steps, the
algorithm just cycles around the local minimum near $0.66$. The values
of $x_i$ repeat in the pattern: $1.0002, 0.7503, -0.0833, 1.0002,
\dots$. This is also an illustration of a poor initial guess. If there
is a local minimum or maximum between the guess and the zero, such
cycles can occur.

"""

fn, a, b, c = x -> x^5 - x + 1, -1.5, 1.4, 0.0

n=7
anim = @animate for i=1:n
    newtons_method_graph(i-1, fn, a, b, c)
end
imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


### {{{newtons_method_cycle}}}

pyplot()
fn, a, b, c, = x -> abs(x)^(0.49),  -2, 2, 1.0
caption = L"""

Illustration of Newton's Method not converging. Here the second
derivative is too big near the zero - it blows up near $0$ - and the
convergence does not occur. Rather the iterates increase in their
distance from the zero.

"""

n=10
anim = @animate for i=1:n
    newtons_method_graph(i-1, fn, a, b, c)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 2)

plotly()
ImageFile(imgfile, caption)


### {{{newtons_method_wilkinson}}}

pyplot()
caption = L"""

The function $f(x) = x^{20} - 1$ has two bad behaviours for Newton's
method: for $x < 1$ the derivative is nearly $0$ and for $x>1$ the
second derivative is very big. In this illustration, we have an
initial guess of $x_0=8/9$. As the tangent line is fairly flat, the
next approximation is far away, $x_1 = 1.313\dots$. As this guess is
is much bigger than $1$, the ratio $f(x)/f'(x) \approx
x^{20}/(20x^{19}) = x/20$, so $x_i - x_{i-1} \approx (19/20)x_i$
yielding slow, linear convergence until $f''(x_i)$ is moderate. For
this function, starting at $x_0=8/9$ takes 11 steps, at $x_0=7/8$
takes 13 steps, at $x_0=3/4$ takes 55 steps, and at $x_0=1/2$ it takes
$204$ steps.

"""


fn,a,b,c = x -> x^20 - 1,  .7, 1.4, 8/9
n = 10

anim = @animate for i=1:n
    newtons_method_graph(i-1, fn, a, b, c)
end
imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


import SpecialFunctions: airyai
p = plot(airyai, -3.3, 0, legend=false);
plot!(p, zero, -3.3, 0);
scatter!(p, [-2.8], [0], color=:orange, markersize=5);
annotate!(p, [(-2.8, 0.2, L"x_0")])


choices = [L"-2.224", L"-2.80",  L"-0.020", L"0.355"]
ans = 1
radioq(choices, ans, keep_order=true)


p = plot(x -> x^2 - 2, .75, 2.2, legend=false);
plot!(p, zero,                   color=:green);
scatter!(p, [1],[0],             color=:orange, markersize=5);
annotate!(p, [(1,.05, L"x_0"), (sqrt(2), .2, L"c")]);
p


choices = [
L"It must be $x_1 > c$",
L"It must be $x_1 < x_0$",
L"It must be $x_0 < x_1 < c$"
]
ans = 1
radioq(choices, ans)


p = plot(x -> x^2 - 2, .75, 2.2, legend=false);
plot!(p, zero, .75, 2.2, color=:green);
scatter!(p, [2],[0], color=:orange, markersize=5);
annotate!(p, [(2,.2, L"x_0"), (sqrt(2), .2, L"c")]);
p


choices = [
L"It must be $x_1 < c$",
L"It must be $x_1 > x_0$",
L"It must be $c < x_1 < x_0$"
]
ans = 3
radioq(choices, ans)


choices = [
L"As $f''(\xi)/2 \cdot(x-c)^2$ is non-negative, we must have $f(x) - (f(c) + f'(c)\cdot(x-c)) \geq 0$.",
L"As $f''(\xi) < 0$ it must be that $f(x) - (f(c) + f'(c)\cdot(x-c)) \geq 0$.",
L"This isn't true. The function $f(x) = x^3$ at $x=0$ provides a counterexample"
]
ans = 1
radioq(choices, ans)


using Roots
f(x) = x^2 - 3^x;
fp(x) = 2x - 3^x*log(3);
val = Roots.newton(f, fp, 0);
numericq(val, 1e-14)


f(x) = exp(x) - x^4;
fp(x) = exp(x) - 4x^3;
xstar= Roots.newton(f, fp, 2);
numericq(xstar, 1e-1)


f(x) = exp(x) - x^4;
fp(x) = exp(x) - 4x^3;
xstar = Roots.newton(f, fp, 8);
numericq(xstar, 1e-1)


k1=4
f(x)  = sin(x) - cos(k1*x);
fp(x) = cos(x) + k1*sin(k1*x);
val = Roots.newton(f, fp, pi/(2k1));
numericq(val)


f(x) = cos(x) - x^3
val = Roots.newton(f,f', 1/2)
numericq(val)


f(x) = x^5 + x - 1
val = Roots.newton(f,f', -1)
numericq(val)


choices = [
"Yes",
"No. The initial guess is not close enough",
"No. The second derivative is too big",
L"No. The first derivative gets too close to $0$ for one of the $x_i$"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
"Yes",
"No. The initial guess is not close enough",
"No. The second derivative is too big, or does not exist",
L"No. The first derivative gets too close to $0$ for one of the $x_i$"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
"Yes",
"No. The initial guess is not close enough",
"No. The second derivative is too big, or does not exist",
L"No. The first derivative gets too close to $0$ for one of the $x_i$"]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
"Yes",
"No. The initial guess is not close enough",
"No. The second derivative is too big, or does not exist",
L"No. The first derivative gets too close to $0$ for one of the $x_i$"]
ans = 4
radioq(choices, ans, keep_order=true)


choices = [
"Yes",
"No. The initial guess is not close enough",
"No. The second derivative is too big, or does not exist",
L"No. The first derivative gets too close to $0$ for one of the $x_i$"]
ans = 3
radioq(choices, ans, keep_order=true)


val = find_zero(x -> 4x^4 - 5x^3 + 4x^2 -20x -6, 0)
numericq(val)


f(x) = sin(x) - x/2
val = find_zero(f, 2)
numericq(val)


function newton_baffler(x)
    if ( x - 0.0 ) < -0.25
        0.75 * ( x - 0 ) - 0.3125
    elseif  ( x - 0 ) < 0.25
        2.0 * ( x - 0 )
    else
        0.75 * ( x - 0 ) + 0.3125
    end
end


yesnoq("yes")


yesnoq("no")


plot(newton_baffler, -1.1, 1.1)


choices = [
L"It doesn't fail, it converges to $0$",
L"The tangent lines for $|x| > 0.25$ intersect at $x$ values with $|x| > 0.25$",
L"The first derivative is $0$ at $1$"
]
ans = 2
radioq(choices, ans)


import SpecialFunctions: erf
f(x) = cos(100*x)-4*erf(30*x-10)


yesnoq("yes")


val = find_zero(f, 0)
numericq(val)


choices = [
"The zero is a simple zero",
"The zero is not a simple zero",
"The function oscillates too much to rely on the tangent line approximation far from the zero",
"We can find an answer"
]
ans = 4
radioq(choices, ans, keep_order=true)


yesnoq(false)


numericq(-999.999)


choices = [
"The zero is a simple zero",
"The zero is not a simple zero",
"The function oscillates too much to rely on the tangent line approximations far from the zero",
"We can find an answer"
]
ans = 3
radioq(choices, ans, keep_order=true)


f(x) = sin(x) - x/4
val = 22
numericq(val)


val = Roots.newton(f,f', 2pi)
numericq(val)


yesnoq("no")


val = 24
numericq(val, 2)


f(x,y) = x^2 + x * y + y^2 - 1
plot(Eq(f, 0), xlims=(-2,2), ylims=(-2,2))


function findy(x)
  fn = y -> (x^2 + x*y + y^2) - 1
  fp = y -> (x + 2y)
  find_zero((fn, fp), sqrt(1 - x^2), Roots.Newton())
end


x = .75
y = findy(x)
x^2 + x*y + y^2  ## is this 1?


yp(x) = (findy(x + 1e-6) - findy(x)) / 1e-6


xstar = find_zero(yp, 0.5)
ystar = findy(xstar)
choices = [L"(-0.577, 1.155)", L"(0,0)", L"(0, -0.577)", L"(0.577, 0.577)"]
ans = 1
radioq(choices, ans)


q = 0.8
xstar = 1.25 # q = 4/5 --> 1/q = 5/4
f(x) = 1/x - q


delta = 1e-6
secant_approx(x0,x1) = (f(x1) - f(x0)) / (x1 - x0)
diffq_approx(x0, h) = secant_approx(x0, x0+h)
steff_approx(x0) = diffq_approx(x0, f(x0))


x1 = 42/17 - 32/17*q
x1 = x1 - f(x1) / diffq_approx(x1, delta)   # |x1 - xstar| = 0.06511395862036995
x1 = x1 - f(x1) / diffq_approx(x1, delta)   # |x1 - xstar| = 0.003391809999860218; etc


x1 = 42/17 - 32/17*q
x1 = x1 - f(x1) / steff_approx(x1)   # |x1 - xstar| = 0.011117056291670258
x1 = x1 - f(x1) / steff_approx(x1)   # |x1 - xstar| = 3.502579696146313e-5; etc.


x1 = 42/17 - 32/17*q
x0 = x1 - delta # we need two initial values
x0, x1 = x1, x1 - f(x1) / secant_approx(x0, x1)   # |x1 - xstar| = 8.222358365284066e-6
x0, x1 = x1, x1 - f(x1) / secant_approx(x0, x1)   # |x1 - xstar| = 1.8766323799379592e-6; etc.


yesnoq(false)


yesnoq(true)


yesnoq(false)

