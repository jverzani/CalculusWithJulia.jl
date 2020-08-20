
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia  # loads  `SymPy`, `QuadGK`
using Plots
f(x) = cos(x)^3 * sin(x)
plot(f, 0, 1pi)


@vars x t real=true
f(x) = 4x / sqrt(x^2 + 1)
integrate(f(x), (x, 0, 2))


f(x) = 1/(x*log(x))
integrate(f(x), (x, e, Sym(e)^2))


integrate(f(x), x)


integrate(abs(x), (x, -2, 2))


f(x) = (1 + log(x)) * sqrt(1 + (x*log(x))^2 )
integrate(f(x), x)


u(x) = x * log(x)
@vars w dw
ex = f(x)
ex = ex(u(x) => w, diff(u(x),x) => dw)


ex = ex(dw => 1)
ex1 = integrate(ex, w)


ex1(w => u(x))


note("""
Lest it be thought this is an issue with `SymPy`, but not other
systems, this example was [borrowed](http://faculty.uml.edu/jpropp/142/Integration.pdf) from an
illustration for helping Mathematica.
""")


integrate(1/(1+x^2), x)


choices = [
L"\int u du",
L"\int u (1 - u^2) du",
L"\int u \cos(x) du"
]
ans = 1
radioq(choices, ans)


choices = [
L"u=\tan(x)",
L"u=\tan(x)^4",
L"u=\sec(x)",
L"u=\sec(x)^2"
]
ans = 1
radioq(choices, ans)


choices = [
L"u=x^2 - 1",
L"u=x^2",
L"u=\sqrt{x^2 - 1}",
L"u=x"
]
ans = 1
radioq(choices, ans)


yesnoq("no")


yesnoq("yes")


choices = [
L"\int u^3 du",
L"\int u du",
L"\int u^3/x du"
]
ans = 1
radioq(choices, ans)


choices = [
L"u=\cos(x)",
L"u=\sin(x)",
L"u=\tan(x)"
]
ans = 1
radioq(choices, ans)


choices = [
L"a=0,~ b=1",
L"a=1,~ b=0",
L"a=0,~ b=0",
L"a=1,~ b=1"
]
ans = 1
radioq(choices, ans)


choices = [
L"\sin(u) = x",
L"\tan(u) = x",
L"\sec(u) = x",
L"u = 1 - x^2"
]
ans = 1
radioq(choices, ans)


choices = [
L"u = 1 + x^2",
L"\sin(u) = x",
L"\tan(u) = x",
L"\sec(u) = x"
]
ans = 1
radioq(choices, ans)


choices = [
L"\sin(u) = x",
L"\tan(u) = x",
L"\sec(u) = x",
L"u = 1 - x^2"
]
ans = 1
radioq(choices, ans)


choices = [
L"4\sec(u) = x",
L"\sec(u) = x",
L"4\sin(u) = x",
L"\sin(u) = x"]
ans = 1
radioq(choices, ans)


choices = [
L"\tan(u) = x",
L"\tan(u) = x",
L"a\sec(u) = x",
L"\sec(u) = x"]
ans = 1
radioq(choices, ans)


choices =[
L"a=\pi/6,~ b=\pi/2",
L"a=\pi/4,~ b=\pi/2",
L"a=\pi/3,~ b=\pi/2",
L"a=1/2,~ b= 1"
]
ans =1
radioq(choices, ans)


choices = [
L"We could differentiate $\sec(u)$.",
L"We could differentiate $\log\lvert (\sec(u) + \tan(u))\rvert$ "]
ans = 2
radioq(choices, ans)

