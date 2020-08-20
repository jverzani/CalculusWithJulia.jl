
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots


using CalculusWithJulia   # to load `Plots` and `SymPy`
f(x) = sin(1/x)
plot(f, range(-1, stop=1, length=1000))


f(x) = x * sin(1/x)
plot(f, -1, 1)
plot!(abs)
plot!(x -> -abs(x))


f(x) = abs(x)/x
plot(f, -2, 2)


@vars x
f(x) = abs(x)/x
limit(f(x), x=>0, dir="+"), limit(f(x), x=>0, dir="-")


alert("""
However, `SymPy` will actually *not* get this correct as a limit, as one can verify through `limit(f(x), x=>0)`. This is because `SymPy` defaults to `dir="+"`. To be certain, you can check both to see they are equal.
""")


plot(floor, -5,5)


@vars x real=true
limit(x^x, x, 0, dir="+")


xs = range(0,stop=1, length=50)

plot(x->x^2, -2, -1, legend=false)
plot!(exp, -1,0)
plot!(x -> 1-2x, 0, 1)
plot!(sqrt, 1, 2)
plot!(x -> 1-x, 2,3)


limit(sin(x), x=>oo)


@vars x real=true
limit(exp(-x)*sin(x), x=>oo)


limit((x^2 - 2x +2)/(4x^2 + 3x - 2), x=>oo)


f(x) = x / sqrt(x^2 + 4)
limit(f(x), x=>oo), limit(f(x), x=>-oo)


f(x) = 1/x^2
M = 25
delta = 1/sqrt(M)

f(x) = 1/x^2 > 50 ? NaN : 1/x^2
plot(f, -1, 1, legend=false)
plot!([-delta, delta],	[M,M], color=colorant"orange")
plot!([-delta, -delta], [0,M], color=colorant"red")
plot!([delta, delta], [0,M], color=colorant"red")


f(x) = 1/x
plot(f, 1/50, 1,    color=:blue, legend=false)
plot!(f, -1, -1/50, color=:blue)


f(x) = 1/x
limit(f(x), x=>0, dir="-"), limit(f(x), x=>0, dir="+")


f(x) = x^x * (1 + log(x))
plot(f, 1/100, 1)


limit(f(x), x=>0, dir="+")


@vars i n integer=true
s(n) = 1//2 * summation((1//4)^i, (i, 0, n))    # rationals make for an exact answer
limit(s(n), n=>oo)


limit_type=[
"limit",
"right limit",
"left limit",
L"limit at $\infty$",
L"limit at $-\infty$",
L"limit of $\infty$",
L"limit of $-\infty$",
"limit of a sequence"
]

Notation=[
L"\lim_{x\rightarrow c}f(x) = L",
L"\lim_{x\rightarrow c+}f(x) = L",
L"\lim_{x\rightarrow c-}f(x) = L",
L"\lim_{x\rightarrow \infty}f(x) = L",
L"\lim_{x\rightarrow -\infty}f(x) = L",
L"\lim_{x\rightarrow c}f(x) = \infty",
L"\lim_{x\rightarrow c}f(x) = -\infty",
L"\lim_{n \rightarrow \infty} a_n = L"
]

Vs = [
L"(L-\epsilon, L+\epsilon)",
L"(L-\epsilon, L+\epsilon)",
L"(L-\epsilon, L+\epsilon)",
L"(L-\epsilon, L+\epsilon)",
L"(L-\epsilon, L+\epsilon)",
L"(M, \infty)",
L"(-\infty, M)",
L"(L-\epsilon, L+\epsilon)"
]

Us = [
L"(c - \delta, c+\delta)",
L"(c, c+\delta)",
L"(c - \delta, c)",
L"(M, \infty)",
L"(-\infty, M)",
L"(c - \delta, c+\delta)",
L"(c - \delta, c+\delta)",
L"(M, \infty)"
]

using DataFrames
d = DataFrame(Type=limit_type, Notation=Notation, V=Vs, U=Us)
table(d)


booleanq(true, labels=["Yes", "No"])


booleanq(false, labels=["Yes", "No"])


booleanq(true, labels=["Yes", "No"])


booleanq(false, labels=["Yes", "No"])


numericq(0)


numericq(0)


numericq(0)


choices=[L"L=-\infty", L"L=-1", L"L=0", L"L=\infty"]
ans = 1
radioq(choices, ans)


choices=[L"L=-\infty", L"L=-1", L"L=0", L"L=\infty"]
ans = 4
radioq(choices, ans)


choices=["The limit does exist - it is any number from -1 to 1",
  "Err, the limit does exists and is 1",
  "The function oscillates too much and its y values do not get close to any one value",
  "Any function that oscillates does not have a limit."]
ans = 3
radioq(choices, ans)


choices = [L"1", L"k", L"\log(k)", "The limit does not exist"]
ans = 1
radioq(choices, ans)


k = 10				# say. Replace with actual value
f(x) = x^(1/log(k, x))


choices = [L"1", L"k", L"\log(k)", "The limit does not exist"]
ans = 2
radioq(choices, ans)


choices=[
"the first one",
"the first and second ones",
"the first, second and third ones",
"the first, second, third, and fourth ones",
"all of them"]
ans = 5
radioq(choices, ans, keep_order=true)


choices = [
L"We can talk about the limit at $\infty$ of $f(x) - (mx + b)$ being $0$",
L"We can talk about the limit at $\infty$ of $f(x) - mx$ being $b$",
L"We can say $f(x) - (mx+b)$ has a horizontal asymptote $y=0$",
L"We can say $f(x) - mx$ has a horizontal asymptote $y=b$",
"Any of the above"]
ans = 5
radioq(choices, ans)


numericq(1)


numericq(-1)


choices = [L" $f(x)$ has a limit of $1$ as $x \rightarrow 0$",
L" $f(x)$ has a limit of $-11$ as $x \rightarrow 0$",
L" $f(x)$ does not have a limit as $x \rightarrow 0$"
]
ans = 3
radioq(choices, ans)

