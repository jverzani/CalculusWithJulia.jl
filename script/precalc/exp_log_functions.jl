
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots
f1(x) = (1/2)^x
f2(x) = 1^x
f3(x) = 2^x
f4(x) = exp(x)
a,b = -2, 2
p = plot(f1, a, b, legend=false)
plot!(f2, a, b); plot!(f3, a, b); plot!(f4, a, b)


r2, r8 = 0.02, 0.08
P0 = 1000
t = 20
P0 * exp(r2*t), P0 * exp(r8*t)


t2, t8 = 72/2, 72/8
exp(r2*t2), exp(r8*t8)


n = 2 * 24
2^(n/6)


f(x) = 2^x
xs = range(-2, stop=2, length=100)
ys = f.(xs)
plot(xs, ys,  color=:blue, legend=false)  # plot f
plot!(ys, xs, color=:red)                 # plot f^(-1)
xs = range(1/4, stop=4, length=100)
plot!(xs, log2.(xs), color=:green)        # plot log2


log2(1_000_000)


-5730 * log2(1/10)


note("""
(Historically) Libby and James Arnold proceeded to test the radiocarbon dating theory by analyzing samples with known ages. For example, two samples taken from the tombs of two Egyptian kings, Zoser and Sneferu, independently dated to 2625 BC plus or minus 75 years, were dated by radiocarbon measurement to an average of 2800 BC plus or minus 250 years. These results were published in Science in 1949. Within 11 years of their announcement, more than 20 radiocarbon dating laboratories had been set up worldwide. Source: [Wikipedia](http://tinyurl.com/p5msnh6).
""")


plot(log2, 1/2, 10)           # base 2
plot!(log, 1/2, 10)           # base e
plot!(log10, 1/2, 10)         # base 10


log(2, 2)


n = 4*7/4
val = 2 * 2^n
numericq(val)


val = 3 * (5/6)^5
numericq(val)


choices = [L"e^2", L"2^e"]
ans = e^2 - 2^e > 0 ? 1 : 2
radioq(choices, ans)


choices = [L"\log_8(9)", L"\log_9(10)"]
ans = log(8,9) > log(9,10) ? 1 : 2
radioq(choices, ans)


choices = [
L"\frac{\log(2)\log(3)}{\log(5)\log(4)}",
L"2/5",
L"\frac{\log(5)\log(4)}{\log(3)\log(2)}"
]
ans = 1
radioq(choices, ans)


ans = log(2,12) + log(3,12) == log(4, 12)
yesnoq(ans)


A, A0 = 100, 1/100
val = M = log(A) - log(A0)
numericq(val)


choices = ["1000 times", "100 times", "10 times", "the same"]
ans = 2
radioq(choices, ans, keep_order=true)


db_who, db_motorhead = 126, 130
db2P(db) = 10^(db/10)
P_who, P_motorhead = db2P.((db_who, db_motorhead))
val = P_motorhead / P_who
numericq(val)


plot(log, 1/4, 4)
f(x) = x - 1
plot!(f, 1/4, 4)


choices = [L"x \geq 1 + \log(x)", L"x \leq 1 + \log(x)"]
ans = 1
radioq(choices, ans)


f(x) = log(1-x)
g(x) = -x - x^2/2
plot(f, -3, 3/4)
plot!(g, -3, 3/4)


choices = [
L"\log(1-x) \geq -x - x^2/2",
L"\log(1-x) \leq -x - x^2/2"
]
ans = 1
radioq(choices, ans)


choices = [L"-y", L"1/y", L"-1/y"]
ans = 1
radioq(choices, ans)


choices = [
L"Flipped over the $x$ axis",
L"Flipped over the $y$ axis",
L"Flipped over the line $y=x$"
]
ans = 1
radioq(choices, ans)


choices = [L"a^x \cdot (a^{y-x} - 1)",
L"a^{y-x}",
L"a^{y-x} \cdot (a^x - 1)"]
ans = 1
radioq(choices, ans)


choices = [
L"as $a^{y-x} > 1$ and $y-x > 0$, $a^y > a^x$",
L"as $a^x  > 1$, $a^y > a^x$",
L"a^{y-x} > 0"
]
ans=1
radioq(choices, ans)


choices = [
L"as $a^{y-x} < 1$ as $y-x > 0$, $a^y < a^x$",
L"as $a^x   < 1$, $a^y < a^x$",
L"a^{y-x} < 0"
]
ans = 1
radioq(choices, ans)

