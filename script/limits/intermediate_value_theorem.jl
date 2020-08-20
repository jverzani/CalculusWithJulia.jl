
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


### {{{IVT}}}
pyplot()
fig_size=(400, 400)



function IVT_graph(n)
    f(x) = sin(pi*x) + 9x/10
    a,b = [0,3]

    xs = range(a,stop=b, length=50)


    ## cheat -- pick an x, then find a y
    Δ = .2
    x = range(a + Δ, stop=b - Δ, length=6)[n]
    y = f(x)

    plt = plot(f, a, b, legend=false, size=fig_size)
    plot!(plt, [0,x,x], [f(x),f(x),0], color=:orange, linewidth=3)

    plot

end

n = 6
anim = @animate for i=1:n
    IVT_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)


caption = L"""

Illustration of intermediate value theorem. The theorem implies that any randomly chosen $y$
value between $f(a)$ and $f(b)$ will have  at least one $x$ in $[a,b]$
with $f(x)=y$.

"""

plotly()
ImageFile(imgfile, caption)


## {{{bisection_graph}}}
pyplot()
function bisecting_graph(n)
    f(x) = x^2 - 2
    a,b = [0,2]

    err = 2.0^(1-n)
    title = "b - a = $err"
    xs = range(a, stop=b, length=100)
    plt = plot(f, a, b, legend=false, size=fig_size, title=title)

    if n >= 1
        for i in 1:n
            c = (a+b)/2
            if f(a) * f(c) < 0
                a,b=a,c
            else
                a,b=c,b
            end
        end
    end
    plot!(plt, [a,b],[0,0], color=:orange, linewidth=3)
    scatter!(plt, [a,b], [f(a), f(b)], color=:orange, markersize=5, markershape=:circle)

    plt

end


n = 9
anim = @animate for i=1:n
    bisecting_graph(i-1)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)


caption = L"""

Illustration of the bisection method to find a zero of a function. At
each step the interval has $f(a)$ and $f(b)$ having opposite signs so
that the intermediate value theorem guaratees a zero.

"""

plotly()
ImageFile(imgfile, caption)


function bisection(f, a, b)
  if f(a) == 0 return(a) end
  if f(b) == 0 return(b) end
  if f(a) * f(b) > 0 error("[a,b] is not a bracketing interval") end

  tol = 1e-14  # small number (but should depend on size of a, b)
  c = a/2 + b/2

  while abs(b-a) > tol
    if f(c) == 0 return(c) end

    if f(a) * f(c) < 0
       a, b = a, c
    else
       a, b = c, b
    end

    c = a/2 + b/2

  end
  c
end


c = bisection(sin, 3, 4)


sin(c)


using CalculusWithJulia  # loads `Roots`
using Plots
find_zero(sin, (3, 4))   # use a tuple, (a, b), to specify the bracketing interval


alert("""
Notice, the call `find_zero(sin, (3,4))` again fits the template `action(function, args...)` that we see repeatedly. The `find_zero` function can also be called through `fzero`.
""")


f(x) = x^5 - x + 1
c = find_zero(f, (-2, -1))
(c, f(c))


f(x) = exp(x) - x^4
plot(f, 5, 10)


find_zero(f, (5, 10))


f(x) = x^3 - x + 1
plot(f, -3, 3)


find_zero(f, (-2, -1))


f(x) = cos(x)
g(x) = x
plot(f, -pi, pi)
plot!(g)


h(x) = f(x) - g(x)
find_zero(h, (0, 2))


plan1(x) = 47.49 + 0.77x
plan2(x) = 30.00 + 2.00x


plot(plan1, 10, 20)
plot!(plan2)


find_zero(x -> plan1(x) - plan2(x), (10, 20))


j(x; theta=pi/4, g=32, v0=200) = tan(theta)*x - (1/2)*g*(x/(v0*cos(theta)))^2


function y(x; theta=pi/4, g=32, v0=200, gamma=1)
	 a = gamma * v0 * cos(theta)
	 (g/a + tan(theta)) * x + g/gamma^2 * log((a-gamma^2 * x)/a)
end


plot(j, 0, 500)


@vars x
roots(j(x))


plot(j, 0, 1250)


plot(y, 0, 1250)


gamma = 1
a = 200 * cos(pi/4)
b = a/gamma^2


plot(y, 0, b - 1)


x1 = find_zero(y, (b/2, b-1/10))


plot(j, 0, 1250)
plot!(y, 0, x1)


f(x) = 1/x
x0 = find_zero(f, (-1, 1))


sign(f(prevfloat(x0))), sign(f(nextfloat(x0)))


f(x) = cos(10*pi*x)
find_zeros(f, 0, 1)


f(x) = x^5 - x^4 + x^3 - x^2 + 1
find_zeros(f, -10, 10)


f(x) = exp(x) - x^5
zs = find_zeros(f, -20, 20)


f.(zs)


###{{{hardrock_profile}}}
imgfile = "figures/hardrock-100.png"
hardrock_profile =  gif_to_data(imgfile, """
Elevation profile of the  Hardrock 100 ultramarathon. Treating the profile as a function, the absolute maximum is just about 14,000 feet and the absolute minimum about 7600 feet. These are of interest to the runner for different reasons. Also of interest would be each local maxima and local minima - the peaks and valleys of the graph - and the total elevation climbed - the latter so important/unforgettable its value makes it into the chart's title.
                             """)

ImageFile(imgfile, caption)


f(x) = x * exp(-x)
plot(f, 0, 5)


f(x) = (x^2)^(1/3)
plot(f, -2, 2)


f(x) = exp(x) - x^4
val = find_zero(f, (-10, 0));
numericq(val, 1e-3)


f(x) = exp(x) - x^4
val = find_zero(f, (0, 5));
numericq(val, 1e-3)


b = 10
f(x) =  x^2 - b * x * log(x)
val = find_zero(f, (10, 500))
numericq(val, 1e-3)


plot(airyai, -10, 10)   # `airyai` loaded in `SpecialFunctions` by `CalculusWithJulia`


val = find_zero(airyai, (-5, -4));
numericq(val, 1e-8)


val = maximum(find_zeros(x -> x^3 - 3^x, 0, 20))
numericq(val)


choices = ["Only before 2", "Only after 2", "Before and after 2"]
ans = 3
radioq(choices, ans)


choices=[
L"$b \approx 2.2$",
L"$b \approx 2.5$",
L"$b \approx 2.7$",
L"$b \approx 2.9$"]
ans = 3
radioq(choices, ans)


### {{{cannonball_img}}}
imgfile = "figures/cannonball.jpg"
cannonball_img = gif_to_data(imgfile, """
Trajectories of potential cannonball fires with air-resistance included. (http://ej.iop.org/images/0143-0807/33/1/149/Full/ejp405251f1_online.jpg)
""")
ImageFile(imgfile, caption)


using ForwardDiff
D(f) = x -> ForwardDiff.derivative(f, x)


choices = [L"(0.0, 12.1875, 24.375)",
	L"(-4.9731, 0.0, 4.9731)",
	L"(0.0, 625.0, 1250.0)"]
ans = 1
radioq(choices, ans)


h(t; g=32, v0=390, gamma=1) = (g/gamma^2 + v0/gamma)*(1 - exp(-gamma*t)) - g*t/gamma


t0 = 0.0
tf = find_zero(h, (10, 20))
ta = find_zero(D(h), (t0, tf))
choices = [L"(0, 13.187, 30.0)",
	L"(0, 32.0, 390.0)",
	L"(0, 2.579, 13.187)"]
ans = 3
radioq(choices, ans)


choices = [L"It must be that $L > y$ as each $f(x)$ is.",
L"It must be that $L \geq y$",
L"It can happen that $L < y$, $L=y$, or $L>y$"]
ans = 2
radioq(choices, 2, keep_order=true)


choices = [
L"f(x) = \sin(x),~ I=(-2\pi, 2\pi)",
L"f(x) = \sin(x),~ I=(-\pi, \pi)",
L"f(x) = \sin(x),~ I=(-\pi/2, \pi/2)",
"None of the above"]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"f(x) = 1/x,~ I=[1,2]",
L"f(x) = 1/x,~ I=[-2, -1]",
L"f(x) = 1/x,~ I=[-1, 1]",
"none of the above"]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"f(x) = \text{sign}(x),~  I=[-1, 1]",
L"f(x) = 1/x,~      I=[-4, -1]",
L"f(x) = \text{floor}(x),~ I=[-1/2, 1/2]",
"none of the above"]
ans = 4
radioq(choices, ans, keep_order=true)


val = 2
numericq(val)


val = -sqrt(3)/3
numericq(val)


choices = [
L"There is no value $c$ for which $f(c)$ is an absolute maximum over $I$.",
L"There is just one value of $c$ for which $f(c)$ is an absolute maximum over $I$.",
L"There are many values of $c$ for which $f(c)$ is an absolute maximum over $I$."
]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"There is no value $M$ for which $M=f(c)$, $c$ in $I$ for which $M$ is an absolute maximum over $I$.",
L"There is just one value $M$ for which $M=f(c)$, $c$ in $I$ for which $M$ is an absolute maximum over $I$.",
L"There are many values $M$ for which $M=f(c)$, $c$ in $I$ for which $M$ is an absolute maximum over $I$."
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
L"f(x) = \sin(x),\quad I=[-\pi/2, \pi/2]",
L"f(x) = \sin(x),\quad I=[0, 2\pi]",
L"f(x) = \sin(x),\quad I=[-2\pi, 2\pi]"]
ans = 3
radioq(choices, ans)


val = maximum(find_zeros(x -> cos(x) * cosh(x) - 1, 0, 6pi))
numericq(val)


yesnoq(true)


a,b = 1, 2
k_x, k_y = 3, 4
plot(t -> a * cos(k_x *t), t-> b * sin(k_y * t), 0, 4pi)

