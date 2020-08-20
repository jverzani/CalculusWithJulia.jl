
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


f(x) = exp(-x^2/2)
c = 1
h = 1e-8
approx = (f(c+h) - f(c)) / h


using CalculusWithJulia
@vars x
df = diff(f(x), x)
actual = N(df(c))
abs(actual - approx)


h = 1e-6
approx = (f(c+h) - f(c-h)) / (2h)
abs(actual - approx)


f(x) = exp(-x^2/2)
c = 1
ForwardDiff.derivative(f, c)   # derivative is qualified by a module name


approx = D(f)(c)         # D(f) is a function, D(f)(c) is the function called on c
abs(actual - approx)


f(x) = sqrt(1 + sin(cos(x)))
c, h = pi/4, 1e-8
fwd = (f(c+h) - f(c))/h


ds_value = D(f)(c)
ds_value, fwd, ds_value - fwd


@vars x
actual = diff(f(x), x) |> subs(x, PI/4) |> N
actual - ds_value, actual - fwd


f(x) = sin(x)
f'(pi), f''(pi)


f(x) = exp(-x^2/2)
fzero(f'', 0, 10)


f(x) = exp(-x)*sin(x)
c = pi
h = 0.1
@vars x

fp = diff(f(x),x)
fp, fp(c)


f'(c), (f(c+h)-f(c))/h


f(x) = x^x
c, h = 2, 0.1
val = (f(c+h) - f(c))/h
numericq(val)


f(x) = x^x
c = 2
val = f'(c)
numericq(val)


h = 1e-16
c = 0
approx = (f(c+h)-f(c))/h
val = abs(cos(0)  - approx)
numericq(val)


h = 1e-16
c = pi/4
approx = (f(c+h)-f(c))/h
val = abs(cos(0)  - approx)
numericq(val)


f(x) = x^x
val = D(f)(3)
numericq(val)


f(x) = abs(1 - sqrt(1 + x))
val = D(f)(3)
numericq(val)


f(x) = exp(sin(x))
val = D(f)(3)
numericq(val)


h = 1e-8
c = 3
val = (airyai(c+h) - airyai(c))/h
numericq(val)


fp_(t) = -16*2*t
c = 1
numericq(fp_(c))


fp_(h) = 3*32h^2 - 62
c = 2
numericq(fp_(2))

