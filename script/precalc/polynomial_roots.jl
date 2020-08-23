
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia  # loads SymPy
using Plots
f(x) = x^2 - x
plot(f, -2, 2)
plot!(zero, -2, 2)


@vars x real=true


(x^4 + 2x^2 + 5) / (x-2)


q, r = divrem(x^4 + 2x^2 + 5, x - 2)


note("""For those who have worked with SymPy within Python, `divrem` is the `div` method renamed, as `Julia`'s `div` method has the generic meaning of returning the quotient.""")


apart((x^4 + 2x^2 + 5) / (x-2))


p = 2x^4 + x^3 - 19x^2 - 9x + 9
factor(p)


plot(x^2 - 1,  -2, 2, legend=false)  # two roots
plot!(x^2, -2, 2)                           # one (double) root
plot!(x^2 + 1, -2, 2)                       # no real root
plot!(zero, -2, 2)


solve(x^2 + 2x - 3)


@vars a b c
solve(a*x^2 + b*x + c, x)


@vars a
@vars b real=true
c = symbols("c", positive=true)
solve(a^2 + 1)     # works, as a can be complex


solve(b^2 + 1)     # fails, as b is assumed real


solve(c + 1)       # fails, as c is assumed positive


p = x^2 - 2
factor(p)


rts = solve(p)
prod(x-r for r in rts)


@vars x
solve(x^4 - 2x - 1)


solve(x^5 - x + 1)


rts = solve(x^5 - x + 1)
N.(rts)     # note the `.(` to broadcast over all values in rts


ex = x^7 -3x^6 +  2x^5 -1x^3 +  2x^2 + 1x^1  - 2
solve(ex)


N.(solve(ex))


p = 8x^4 - 8x^2  + 1
rts = solveset(p)


elements(rts)


N.(elements(solveset(p)))


p =   x^5 - 100x^4 + 4000x^3 - 80000x^2 + 799999x - 3199979
plot(p, -10, 10)


plot(p, 10,20)


plot(p, 18, 22)


p =  x^5 - 100x^4 + 4000x^3 - 80000x^2 + 799999x - 3199979
N.(solve(p))



note(""" **Other numeric methods**
Finding roots of polynomials numerically is implemented in a few `Julia`-only packages, for example the `roots` function of the `Polynomials` package and the `roots` function of the `PolynomialRoots` package, among other (`AMRVW`, `AMVW`, ...)."""

)


choices = [L"x^3 + x^2 + x + 2",
L"x-2",
L"6",
L"0"]
ans = 3
radioq(choices, ans)


choices = [L"x - 1",
L"x^2 - 2x + 2",
"2"
]
ans = 2
radioq(choices, ans)


choices = [
L"x^2 - x + 1",
L"x^3 + x^2 - 1",
L"-2x + 2"
]
ans = 3
radioq(choices, ans)


choices = [
L"x^5 - x + 1",
L"2x^4 + 4x^3 + 8x^2 + 16x + 30",
L"x^5 + 2x^4 + 4x^3 + 8x^2 + 15x + 31",
L"x^4 +2x^3 + 4x^2 + 8x + 15",
L"31"]
ans = 1
radioq(choices, ans)


choices = [
L"x^5 - x + 1",
L"2x^4 + 4x^3 + 8x^2 + 16x + 30",
L"x^5 + 2x^4 + 4x^3 + 8x^2 + 15x + 31",
L"x^4 +2x^3 + 4x^2 + 8x + 15",
L"31"]
ans = 4
radioq(choices, ans)


choices = [
L"x^5 - x + 1",
L"2x^4 + 4x^3 + 8x^2 + 16x + 30",
L"x^5 + 2x^4 + 4x^3 + 8x^2 + 15x + 31",
L"x^4 +2x^3 + 4x^2 + 8x + 15",
L"31"]
ans = 5
radioq(choices, ans)


choices = [
L" $2$ and  $3$",
L" $(x-2)$ and $(x-3)$",
L" $(x+2)$ and $(x+3)$"]
ans = 2
radioq(choices, ans)


yesnoq(false)


numericq(2)


choices = [
q"[-0.434235, -0.434235,  0.188049, 0.188049, 0.578696, 4.91368]",
q"[-0.434235, -0.434235,  0.188049, 0.188049]",
q"[0.578696, 4.91368]",
q"[-0.434235+0.613836im, -0.434235-0.613836im]"]
ans = 3
radioq(choices, ans)


using Roots
xs = fzeros(x -> x^5 - 3x + 1, -10, 10)
yesnoq(length(xs) > 1)


using Roots
xs = fzeros(x -> x^5 - 1.5x + 1, -10, 10)
yesnoq(length(xs) > 1)


numericq(2)


numericq(0)


numericq(3)


numericq(1)


ans = 1 + 4 + 1 + 2 + 1
numericq(ans)


f(x) = x^5 - 4x^4 + x^3 - 2x^2 + x
rts = fzeros(f, -5, 5)
ans = maximum(abs.(rts))
numericq(ans)


p = Permutation(0,2)
q = Permutation(1,2)
m = 0
for perm in (p, q, q*p, p*q, p*q*p, p^2)
    global a,b,c =  perm([2,3,4])
     fn = x -> x^3 - a*x^2 + b*x - c
    rts_ = fzeros(fn, -10, 10)
	global a1 = maximum(abs.(rts_))
	global m = a1 > m ? a1 : m
end
numericq(m)


choices = [L"4x^2 - 1", L"2x^2", L"x", L"2x"]
ans = 1
radioq(choices, ans)


yesnoq(true)


1 + 1 + 6/32


import LinearAlgebra: norm
@syms x
p = 16x^5 - 20x^3 + 5x
rts = N.(solve(p))
ans = maximum(norm.(rts))
numericq(ans)


plot(p, -2, 2)


yesnoq(true)

