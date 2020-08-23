
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots
plot(sin, 0, pi)
plot!(x -> 2/pi, 0, 2pi)


plot(x -> exp(-x), 0, log(2))
plot!(x -> 1/(2*log(2)), 0, log(2))


f(x) = x < 1 ? 1.0 : 2.0
a,b = 0, 2
val, _ = quadgk(f, a, b)
numericq(val/(b-a))


f(x) = x < 2 ? 1.0 : 2.0
a, b= 0, 2
val, _ = quadgk(f, a, b)
numericq(val/(b-a))


choices = [
L"\int_0^t v(u) du = v^2/2 \big|_0^t",
L"\int_0^t (v(0) + v(u))/2 du = v(0)/2\cdot t + x(u)/2\ \big|_0^t",
L"(v(0) + v(t))/2 \cdot \int_0^t du = (v(0) + v(t))/2 \cdot t"
]
ans = 1
radioq(choices, ans)


f(x) = cos(x)
a,b = -pi/2,pi/2
val, _ = quadgk(f, a, b)
val = val/(b-a)
numericq(val)


f(x) = cos(x)
a,b = 0, pi
val, _ = quadgk(f, a, b)
val = val/(b-a)
numericq(val)


f(x) = exp(-2x)
a, b = 0, 2
val, _ = quadgk(f, a, b)
val = val/(b-a)
numericq(val)


f(x) = sin(x)^2
a, b = 0, pi
val, _ = quadgk(f, a, b)
val = val/(b-a)
numericq(val)


choices = [
L"That of $f(x) = x^{10}$.",
L"That of $g(x) = \lvert x \rvert$."]
ans = 2
radioq(choices, ans)


choices = [
L"f(x; 2,3)",
L"f(x; 3,4)"
]
n1, _ = quadgk(x -> x^2 *(1-x)^3, 0, 1)
n2, _ = quadgk(x -> x^3 *(1-x)^4, 0, 1)
ans = 1 + (n1 < n2)
radioq(choices, ans)


numericq(100 * 100)


choices = [
L"Because the mean value theorem says this is $f(c) (x-a)$ for some $c$ and both terms are positive by the assumptions",
"Because the definite integral is only defined for positive area, so it is always positive"
]
ans = 1
radioq(choices, ans)


choices = [
L"By the extreme value theorem, $F(x)$ must reach its maximum, hence it must increase.",
L"By the intermediate value theorem, as $F(x) > 0$, it must be true that $F(x)$ is increasing",
L"By the fundamental theorem of calculus, part I, $F'(x) = f(x) > 0$, hence $F(x)$ is increasing"
]
ans = 3
radioq(choices, ans)


f(x) = x^2
a,b = 0, 1
val1 = quadgk(f, a, b)[1] / (b-a)
val2 = exp(quadgk(x -> log(f(x)), a, b)[1] / (b - a))

choices = [
L"The average of $f$",
L"The exponential of the average of $\log(f)$"
]
ans = val1 > val2 ? 1 : 2
radioq(choices, ans)

