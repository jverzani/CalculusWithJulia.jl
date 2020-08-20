
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia   # to load the `Plots` package
f(x) = 2^x
plot(f, 0, 4)
plot!([2,2,0], [0,f(2),f(2)])


note(L"""The use of a negative exponent on the function name is *easily* confused for the notation for a reciprocal when it is used on a mathematical *expression*. An example might be the notation $(1/x)^{-1}$. As this is an expression this would simplify to $x$ and not the inverse of the *function* $f(x)=1/x$ (which is $f^{-1}(x) = 1/x$).
""")


f(x) = x^2 + 2
plot(f, 0, 4)
plot!([2,2,0], [0,f(2),f(2)])


f(x) = 2^x
xs = range(0, 2, length=50)
ys = f.(xs)
plot(xs, ys, color=:blue)
plot!(ys, xs, color=:red) # the inverse


f(x) = cbrt(x)
xs = range(-2, 2, length=150)
ys = f.(xs)
plot(xs, ys, color=:blue, aspect_ratio=:equal, legend=false)
plot!(ys, xs, color=:red)
plot!(identity, color=:green, linestyle=:dash)
x, y = 1/2, f(1/2)
plot!([x,y], [y,x], color=:green, linestyle=:dot)


note(L"""In the above we used `cbrt(x)` and not `x^(1/3)`. The latter usage assumes that $x \geq 0$ as it isn't guaranteed that for all real exponents the answer will be a real number. The `cbrt` function knows there will always be a real answer and provides it.
""")


f(x) = sqrt(x)
c = 2
tl(x) = f(c) + 1/(2 * sqrt(2)) * (x - c)
xs = range(0, 3, length=150)
ys = f.(xs)
zs = tl.(xs)
plot(xs, ys,  color=:blue, legend=false)
plot!(xs, zs, color=:blue) # the tangent line
plot!(ys, xs, color=:red)  # the inverse function
plot!(zs, xs, color=:red)  # inverse of tangent line


choices = [L"No, for all $x$ in the domain an an inverse, the value of any inverse will be the same, hence all inverse functions would be identical.",
L"Yes, the function $f(x) = x^2, x \geq 0$ will have a different inverse than the same function $f(x) = x^2,  x \leq 0$"]
ans = 1
radioq(choices, ans)


choices = [L"Yes, the function is the linear function $f(x)=(x+1)/2 + 1$ and so is monotonic.",
L"No, the function is $1$ then $2$ then $1$, but not \"one-to-one\""
]
ans = 1
radioq(choices, ans)


choices=[L"Yes, a graph over $(-100, 100)$ will show this.",
L"No, a graph over $(-2,2)$ will show this."
]
ans = 2
radioq(choices, ans)


yesnoq(false)


f(x) = x - sin(x)
plot(f, 0, 6pi)


yesnoq(true)


choices = [L"g(x) = x", L"g(x) = x^{-1}"]
ans = 1
radioq(choices, ans)


choices = [L"g(x) = x", L"g(x) = x^{-1}"]
ans = 2
radioq(choices, ans)


f(x) = sin(pi/4 * x)
plot(f, -2, 2)


val = f(1)
numericq(val, 0.2)


val = 2
numericq(val, 0.2)


val = 1/f(1)
numericq(val, 0.2)


val = 2/3
numericq(val, 0.2)


choices=[
L"The function that multiplies by $2$, subtracts $1$ and then squares the value.",
L"The function that divides by $2$, adds $1$, and then takes the square root of the value.",
L"The function that takes square of the value, then subtracts $1$, and finally multiplies by $2$."
]
ans = 1
radioq(choices, ans)


numericq(5)


numericq(2)


numericq(1/13)


numericq(3)


choices = [
L"f^{-1}(x) = (5y-4)^{1/3}",
L"f^{-1}(x) = (5y-4)^3",
L"f^{-1}(x) = 5/(x^3 + 4)"
]
ans = 1
radioq(choices, ans)


choices = [
L"f^{-1}(x) = (x-e)^{1/\pi}",
L"f^{-1}(x) = (x-\pi)^{e}",
L"f^{-1}(x) = (x-e)^{\pi}"
]
ans = 1
radioq(choices, ans)


choices = [
L"[7, \infty)",
L"(-\infty, \infty)",
L"[0, \infty)"]
ans = 1
radioq(choices, ans)


choices = [
L"[7, \infty)",
L"(-\infty, \infty)",
L"[0, \infty)"]
ans = 3
radioq(choices, ans)


f(x) = x^3
xs = range(0, 2, length=100)
ys = f.(xs)
plot(xs, ys, color=:blue, legend=false)
plot!(ys, xs, color=:red)
plot!(x->x, linestyle=:dash)


yesnoq(true)


f(x) = x^3 - x - 1
xs = range(-2,2, length=100)
ys = f.(xs)
plot(xs, ys, color=:blue, legend=false)
plot!(-xs, -ys, color=:red)
plot!(x->x, linestyle=:dash)


yesnoq(false)


a,b,c,d = 1,2,3,5
f1(x) = x + d/c; f2(x) = 1/x; f3(x) = (b*c-a*d)/c^2 * x; f4(x)= x + a/c
f(x) = (a*x+b) / (c*x + d)
numericq(f(10))


numericq(f4(f3(f2(f1(10)))))


choices = [L"As $f4(f3(f2(f1(x))))=(f4 \circ f3 \circ f2 \circ f1)(x)$",
L"As $f4(f3(f2(f1(x))))=(f1 \circ f2 \circ f3 \circ f4)(x)$",
"As the latter is more complicated than the former."
]
ans=1
radioq(choices, ans)


choices = [L"g2(x) = x^{-1}", L"g2(x) = x", L"g2(x) = x -1"]
ans = 1
radioq(choices, ans)


choices = [L"c^2/(b\cdot c - a\cdot d) \cdot  x", L"(b\cdot c-a\cdot d)/c^2 \cdot  x", L"c^2 x"]
ans = 1
radioq(choices, ans)


g1(x) = x - d/c; g2(x) = 1/x; g3(x) = 1/((b*c-a*d)/c^2) *x; g4(x)= x - a/c
val = g4(g3(g2(g1(f4(f3(f2(f1(10))))))))
numericq(val)


val = g1(g2(g3(g4(f4(f3(f2(f1(10))))))))
numericq(val)

