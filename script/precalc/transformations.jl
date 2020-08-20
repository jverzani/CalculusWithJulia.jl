
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


import Base: +
f::Function + g::Function = x -> f(x) + g(x)


(sin + sqrt)(4)


using CalculusWithJulia
using Plots
f(x) = x^2
g(x) = sin(x)
fg = f ∘ g      # typed as f \circ[tab] g
gf = g ∘ f      # typed as g \circ[tab] f
plot(fg, -2, 2)
plot!(gf, -2, 2)


note("""

Unlike how the basic arithmetic operations are treated, `Julia` defines the infix
Unicode operator `\\circ[tab]` to represent composition of functions,
mirroring mathematical notation. It's use with generic functions is a bit
cumbersome, as the operation returns an anonymous function. However, it
can be useful and will mirror standard mathematical usage up to issues
with precedence rules.)

""")


note("""
The real value of composition is to break down more complicated things into a sequence of easier steps. This is good mathematics, but also good practice more generally. For example, when we approach a problem with the computer, we generally use a smallish set of functions and piece them together (that is, compose them) to find a solution.
""")


using DataFrames
nms = ["*vertical shifts*","*horizontal shifts*","*stretching*","*scaling*"]
acts = [L"The function $h(x) = k + f(x)$ will have the same graph as $f$ shifted up by $k$ units.",
L"The function $h(x) = f(x - k)$ will have the same graph as $f$ shifted right by $k$ units.",
L"The function $h(x) = kf(x)$ will have the same graph as $f$ stretched by a factor of $k$ in the $y$ direction.",
L"The function $h(x) = f(kx)$ will have the same graph as $f$ compressed horizontally by a factor of $1$ over $k$."]
table(DataFrame(Transformation=nms, Description=acts))


up(f, k)       = x -> f(x) + k
over(f, k)     = x -> f(x - k)
stretch(f, k)  = x -> k * f(x)
scale(f, k)    = x -> f(k * x)


f(x) = max(0, 1 - abs(x))
plot(f, -2,2)


plot(f, -2, 2)
plot!(up(f, 2), -2, 2)


plot(f, -2, 4)
plot!(over(f, 2), -2, 2)


plot(f, -2, 2)
plot!(stretch(f, 2), -2, 2)


plot(f, -2, 2)
plot!(scale(f, 2), -2, 2)


plot(f, -2, 4)
plot!(up(over(f,2), 1), -2, 4)


plot(f, -1,9)
plot!(scale(over(f,2), 1/3), -1,9)


plot(f, -1, 5)
plot(over(scale(f, 1/3), 2), -1, 5)


a = 2; b = 5
h(x) = stretch(over(scale(f, 1/a), b), 1/a)(x)
plot(f, -1, 8)
plot(h, -1, 8)


a = 12
b = ((15 + 5/60 + 46/60/60) - (9 + 19/60 + 44/60/60)) / 2
d = 2pi/365


c = 79


newyork(t) = up(stretch(over(scale(sin, d), c), b), a)(t)
plot(newyork, -20, 385)


datetime = 15 + 0/60 + 4/60/60
delta = (newyork(184) - datetime) * 60


g(x) = sqrt(x)
f(x) = sin(x)
pi/2 |> g |> f


l(x) = action1(f, args...)(x)
l(10)


action2( action1(f, args..), other_args...)


D(f::Function) = k -> f(k) - f(k-1)


f(k) = 1 + k^2
D(f)(3), f(3) - f(3-1)


S(f) = k -> sum(f(i) for i in 1:k)


S(f)(4), f(1) + f(2) + f(3) + f(4)


k = 10    # some arbitrary value k >= 1
D(S(f))(k), f(k)


k=15
S(D(f))(k),  f(k) - f(0)


choices=[L"1/(x-2)", L"1/x - 2", L"x - 2", L"-2"]
ans = 2
radioq(choices, ans)


choices=[L"e^{-x^2 - 3}", L"(e^x -3)^2", L"e^{-(x-3)^2}", L"e^x+x^2+x-3"]
ans = 3
radioq(choices, ans)


choices = [L"f(x)=x^2; \quad g(x) = \sin^2(x)",
	   L"f(x)=x^2; \quad g(x) = \sin(x)",
	   L"f(x)=\sin(x); \quad g(x) = x^2"]
ans = 2
radioq(choices, ans)


choices = [L"h(x) = 4 + \sin(6x)", L"h(x) = 6 + \sin(x + 4)", L"h(x) = 6 + \sin(x-4)", L"h(x) = 6\sin(x-4)"]
ans = 3
radioq(choices, 3)


choices = [L"The graph of $h(x)$ is the graph of $f(x)$ stretched by a factor of 4",
	   L"The graph of $h(x)$ is the graph of $f(x)$ scaled by a factor of 2",
	   L"The graph of $h(x)$ is the graph of $f(x) shifted up by 4 units"]
ans = 3
radioq(choices, ans)


choices = [L"scaling by $1/a$, then shifting by $b$, then stretching by $1/a$",
           L"shifting by $a$, then scaling by $b$, and then scaling by $1/a$",
	   L"shifting by $a$, then scaling by $a$, and then scaling by $b$" ]
ans=1
radioq(choices, ans)


f(x) = 2*sin(pi*x)
p = plot(f, -2,2)


val = 2
numericq(val)


val = 2
numericq(val)


choices = [
L"2 \sin(x)",
L"\sin(2x)",
L"\sin(\pi x)",
L"2 \sin(\pi x)"
]
ans = 4
radioq(choices, ans)


choices = [
q"D(S(f))(n) = f(n)",
q"S(D(f))(n) = f(n) - f(0)"
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
q"D(S(f))(n) = f(n)",
q"S(D(f))(n) = f(n) - f(0)"
]
ans = 1
radioq(choices, ans, keep_order=true)

