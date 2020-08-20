
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


imgfile = "figures/jump-rope.png"
caption = """

A kids' jump rope by Lifeline is comprised of little plastic segments of uniform length around a cord. The length of the rope can be computed by adding up the lengths of each segment, regardless of how the rope is arranged.

"""
ImageFile(imgfile, caption)


note(L"""

The form of the integral may seem daunting with the square root and
the derivatives. A more general writing would create a vector out of
the two functions: $\phi(t) = \langle g(t), f(t) \rangle$. It is
natural to then let $\phi'(t) = \langle g'(t), f'(t) \rangle$. With
this, the integrand is just the norm - or length - of the
derivative, or $L=\int \| \phi'(t) \| dt$. This is similar to the
distance traveled being the integral of the speed, or the absolute
value of the derivative of position.

""")


## {{{arclength_graph}}}
pyplot()
fig_size=(600, 400)

function make_arclength_graph(n)

    ns = [10,15,20, 30, 50]

    g(t) = cos(t)/t
    f(t) = sin(t)/t

    ts = range(1, stop=4pi, length=200)
    tis = range(1, stop=4pi, length=ns[n])

    p = plot(g, f, 1, 4pi, legend=false, size=fig_size,
             title="Approximate arc length with $(ns[n]) points")
    plot!(p,  map(g, tis), map(f, tis), color=:orange)

    p

end

n = 5
anim = @animate for i=1:n
    make_arclength_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)
caption = L"""

The arc length of the parametric curve can be approximated using straight line segments connecting points. This gives rise to an integral expression defining the length in terms of the functions $f$ and $g$.

"""

plotly()
ImageFile(imgfile, caption)


note(L"""

[Bressoud](http://www.math.harvard.edu/~knill/teaching/math1a_2011/exhibits/bressoud/)
notes that Gregory (1668) proved this formula for arc length of the
graph of a function by showing that the length of the curve $f(x)$ is defined
by the area under $\sqrt{1 + f'(x)^2}$. (It is commented that this was
also known a bit earlier by von Heurat.) Gregory went further though,
as part of the fundamental theorem of calculus was contained in his
work.  Gregory then posed this inverse question: given a curve
$y=g(x)$ find a function $u(x)$ so that the area under $g$ is equal to
the length of the second curve. The answer given was $u(x) =
(1/c)\int_a^x \sqrt{g^2(t) - c^2}$, which if $g(t) = \sqrt{1 + f'(t)}$
and $c=1$ says $u(x) = \int_a^x f(t)dt$.

An analogy might be a sausage maker. These take a mass of ground-up sausage material and return a long length of sausage. The material going in would depend on time via an equation like $\int_0^t g(u) du$ and the length coming out would be a constant (accounting for the cross section) times $u(t) = \int_0^t \sqrt{1 + g'(s)} ds$.

""")


using CalculusWithJulia  # loads `SymPy`, `Roots`, `QuadGK`, `ForwardDiff`
using Plots
@vars x
F = integrate(sqrt(1 + (2x)^2), x)


F(1) - F(0)


f(x) = x^2
plot(f, 0, 1)


note(L"""

The integrand $\sqrt{1 + f'(x)^2}$ may seem odd at first, but it can be interpreted as the length of the hypotenuse of a right triangle with "run" of $1$ and rise of $f'(x)$. This triangle is easily formed using the tangent line to the graph of $f(x)$. By multiplying by $dx$, the integral is "summing" up the lengths of infinitesimal pieces of the tangent line approximation.

""")


@vars x
ex = integrate(sqrt(1 + (1/x)^2), (x, 1/Sym(e), e))    # 1/Sym(e) keeps as symbolic value


N(ex)


f(x; a=2) = a * cosh(x/a)
plot(f, -1, 1)


quadgk(x -> sqrt(1 + f'(x)^2), -1, 1)[1]


imgfile = "figures/johns-catenary.jpg"
caption = "One of Jasper Johns' Catenary series. Art Institute of Chicago."
ImageFile(imgfile, caption)


cat(x; a=1, b=0) = a*cosh(x/a) - b
a = find_zero(a -> cat(78/2, a=a, b=118 + a), 10)


a = 13
b = 118 + a
f(x) = cat(x, a=13, b=118+13)
quadgk(x -> sqrt(1 + f'(x)^2), -78/2, 78/2)[1]


a = 1298/2;
b = -147;
f(x) = (-b/a^2)*(x^2 - a^2);
val, _ = quadgk(x -> sqrt(1 + f'(x)^2), -a, a)
val


a = 1
g(t) = a*(3cos(t) - cos(3t))
f(t) = a*(3sin(t) - sin(3t))
plot(g, f, 0, 2pi)


quadgk(t -> sqrt(g'(t)^2 + f'(t)^2), 0, 2pi)[1]


a, b= 1, 2
s(u) = quadgk(t -> sqrt(a^2 * sin(t)^2 + b^2 * cos(t)^2), 0, u)[1]


plot(s, 0, 2pi)


using Roots
sinv(u) = find_zero(x -> s(x) - u, (0, s(2pi)))


g(t) = a*cos(t)
f(t) = b*sin(t)

plot(t->g(s(t)), t-> f(s(t)), 0, s(2*pi))


f(x) = exp(x)
val = sqrt( (f(1) - f(0))^2 - (1 - 0)^2)
numericq(val)


val = (1 - 0) + (f(1) - f(0))
numericq(val)


a,b = 0, 1
val, _ = quadgk(x -> sqrt(1 + exp(x)^2), a, b)
numericq(val)


f(x) = x^(3/2)
a, b = 0, 4
val, _ = quadgk( x -> sqrt(1 + f'(x)^2), a, b)
numericq(val)


f(x) = x^2 - log(x)
a, b= 1/10, 2
val, _ = quadgk( x -> sqrt(1 + (f)(x)^2), a, b)
numericq(val)


f(x) = tan(x)
a, b= -pi/4, pi/4
val, _ = quadgk( x -> sqrt(1 + f'(x)^2), a, b)
numericq(val)


sqrt((tan(pi/4) - tan(-pi/4))^2 + (pi/4 - -pi/4)^2)


fp(x) = tan(x)
a, b = 0, pi/4
val, _ = quadgk(x -> sqrt(1 + fp(x)^2), a, b)
numericq(val)


g(x, a) = a * log((a + sqrt(a^2 - x^2))/x) - sqrt(a^2 - x^2)


a = 12
f(x) = g(x, a);
val = quadgk(x -> sqrt(1 + D(f)(x)^2), 1, a)[1];
numericq(val, 1e-3)


note("""

To see an example of how the tractrix can be found in an everyday observation, follow this link on a description of [bicycle](https://simonsfoundation.org/multimedia/mathematical-impressions-bicycle-tracks) tracks.

""")


g(t) = t + sin(t)
f(t) = cos(t)
a, b = 0, pi
val, _ = quadgk( x -> sqrt(D(g)(x)^2 + D(f)(x)^2), a, b)
numericq(val)


g(t) = cos(t)^3
f(t) = sin(t)^3
a, b = 0, 2pi
val, _ = quadgk( x -> sqrt(D(g)(x)^2 + D(f)(x)^2), a, b)
numericq(val)


g(t) = (2t+3)^(2/3)/3
f(t) = t + t^2/2
a, b = 0, 3
val, _ = quadgk( x -> sqrt(D(g)(x)^2 + D(f)(x)^2), a, b)
numericq(val)


g(t) = t - sin(t)
f(t) = 1 - cos(t)
a, b = 0, 2pi
val, _ = quadgk( x -> sqrt(D(g)(x)^2 + D(f)(x)^2), a, b)
numericq(val)

