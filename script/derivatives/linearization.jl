
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


tangent(f, c) = x -> f(c) + f'(c) * (x - c)


using CalculusWithJulia
using Plots


f(x) = x^2
plot(f, -3, 3)
plot!(tangent(f, -1), -3, 3)
plot!(tangent(f, 2), -3, 3)


f(x) = sin(x)
plot(f, -pi/2, pi/2)
plot!(tangent(f, 0), -pi/2, pi/2)


f(x) = log(1 + x)
plot(f, -1/2, 1/2)
plot!(tangent(f, 0), -1/2, 1/2)


f(x) = 1/(1-x)
plot(f, -1/2, 1/2)
plot!(tangent(f, 0), -1/2, 1/2)


f(x) = sin(x)
a, b = -1/4, pi/2

p = plot(f, a, b, legend=false);
plot!(p, x->x, a, b);
plot!(p, [0,1,1], [0, 0, 1], color=:brown);
plot!(p, [0,1,1], [0, 0, sin(1)], color=:green);
annotate!(p, collect(zip([1/2,1+.05, 1/2-1/8], [.05, sin(1)/2, .75], ["Δx", "Δy", "m=dy/dx"])));
p


f(x) = sin(x)
c, deltax = 0, 0.1
f(c + deltax) - f(c), f'(c) * deltax


c, deltax = 0, 10*pi/180
actual=f(c + deltax) - f(c)
approx = f'(c) * deltax
actual, approx


(approx - actual) / actual * 100


abs(50 - 60/70*60) / (60/70*60) * 100


fp(x) = 3*x^2
c, Delta = 10, 0.1
approx = 1000 + fp(c) * Delta


actual = 10.1^3
(actual - approx)/actual * 100


(1000 - approx)/approx * 100


h(x) = abs(sin(x) - x)
g(x) = x^2/2
plot(h, -2, 2)
plot!(g, -2, 2)


h(x) = abs(log(1+x) - x)
g(x) = x < 0 ? x^2/(2*(1+x)^2) : x^2/2
plot(h, -0.5, 2)
plot!(g, -0.5, 2)


@vars x
series(exp(sin(x)), x, 0, 2)


choices = [
L"1 + 1/2",
L"1 + x^{1/2}",
L"1 + (1/2)\cdot x",
L"1 - (1/2) \cdot x"]
ans = 3
radioq(choices, ans)


choices = [
L"1 + k",
L"1 + x^k",
L"1 + k\cdot x",
L"1 - k \cdot x"]
ans = 3
radioq(choices, ans)


choices = [
L"1",
L"1 + x",
L"x",
L"1 - x^2/2"
]
ans = 1
radioq(choices, ans)


choices = [
L"1",
L"x",
L"1 + x",
L"1 - x"
]
ans = 2
radioq(choices, ans)


choices = [
L"5 \cdot (1 + (1/2) \cdot (x/25))",
L"1 - (1/2) \cdot x",
L"1 + x",
L"25"
]
ans = 1
radioq(choices, ans)


tgent(x) = 5 + x/10
ans = tgent(1) - sqrt(26)
numericq(ans)


est = 12.34
act = 12.0
ans = (est -act)/act * 100
numericq(ans)


tl(x) = x
x0 = 5 * pi/180
est = x0
act = sin(x0)
ans = (est -act)/act * 100
numericq(ans)


tl(x) = 4 + 4x
ans = tl(.2) - 4
numericq(abs(ans))

