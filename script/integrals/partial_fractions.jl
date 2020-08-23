
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


note("""

Many calculus texts will give some examples for finding a partial
fraction decomposition. We push that work off to `SymPy`, as for all
but the easiest cases - a few are in the problems - it can be a bit tedious.

""")


using CalculusWithJulia  # loads `SymPy`
@vars a b c A B x real=true


apart((x-2)*(x-3) / (x*(x-1)^2*(x^2 + 2)^3))


p = a/(x-c)


integrate(p, x)


@vars j positive=true
integrate(a/(x-c)^j, x)


integrate(A*x/((a*x)^2 + 1)^4, x)


integrate(B/((a*x)^2 + 1)^4, x)


integrate(B/((a*x)^2 - 1)^4, x)


q = (x * (x^2 + 1)^2)
apart(1/q)


integrate(1/q, x)


q =  (x^2 - 2x - 3)
apart(1/q)


integrate(1/q, x)


note(L"""

`SymPy` will find $\log(x)$ as an antiderivative for $1/x$, but more
generally, $\log(\lvert x\rvert)$ is one.

""")


val = -1
numericq(val)


val = 1
numericq(val)


numericq(-3/2)


numericq(13/2)


numericq(1/4)


numericq(-1/4)


numericq(1/2)


yesnoq("yes")


choices = [
"`SymPy` allows it.",
L"The value $c$ is a removable singularity, so the integral will be identical.",
L"The resulting function has an identical domain and is equivalent for all $x$."
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
"`SymPy` allows it.",
L"The value $c$ is a removable singularity, so the integral will be identical.",
L"The resulting function has an identical domain and is equivalent for all $x$."
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
"`SymPy` allows it.",
L"The value $c$ is a removable singularity, so the integral will be identical.",
L"The resulting function has an identical domain and is equivalent for all $x$."
]
ans = 3
radioq(choices, ans, keep_order=true)

