
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


##{{{ different_poly_graph }}}
pyplot()
fig_size = (400, 300)
anim = @animate for m in  2:2:10
    fn = x -> x^m
    plot(fn, -1, 1, size = fig_size, legend=false, title="graph of x^$m", xlims=(-1,1), ylims=(-.1,1))
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)
caption = "Polynomials of varying even degrees over [-1,1]."

ImageFile(imgfile, caption)


### {{{ lines_m_graph }}}

pyplot()
anim = @animate for m in  [-5, -2, -1, 1, 2, 5, 10, 20]
    fn = x -> m * x
    plot(fn, -1, 1, size = fig_size, legend=false, title="m = $m", xlims=(-1,1), ylims=(-20, 20))
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)
caption = "Graphs of y = mx for different values of m"

ImageFile(imgfile, caption)


note("""

`SymPy` is installed when the accompanying `CalculusWithJulia` package
 is installed. It could also be installed directly. The package relies
 on both Python being installed and SymPy being added to the installed
 Python. This is done automatically on installation, if needed, when
 the `PyCall` package is installed.

""")


using CalculusWithJulia   # loads the `SymPy` package
using Plots
a,b,c = symbols("a,b,c")
x = symbols("x", real=true)


@vars h t


note("""Macros in `Julia` are just transformations of the syntax into other synax. The `@` indicates they behave differently than regular function calls. For the `@vars` macro, the arguments are **not** separated by commas, as a normal function cal would be.
""")


p = -16x^2 + 100


typeof(p)


quad = a*x^2 + b*x + c


sin(a*(x - b*pi) + c)


quad + quad^2 - quad^3


p = -16x^2 + 100
p(x => (x-1)^2)


y = p(x=>2)


typeof(y)


p(4) # substitutes x=>4


@vars a b c E F
p = a*x^2 + b*x + c
p(x => x-E) + F


expand(p(x => x-E) + F)


p = -16x^2 + 100
y = p(2)


N(y)


N(PI, 60)


plot(x^5 - x + 1, -3/2, 3/2)


### {{{ poly_growth_graph }}}

pyplot()
anim = @animate for m in  0:2:12
    fn = x -> x^m
    plot(fn, -1.2, 1.2, size = fig_size, legend=false, xlims=(-1.2, 1.2), ylims=(0, 1.2^12), title="x^{$m} over [-1.2, 1.2]")
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)
caption = L"Demonstration that $x^{10}$ grows faster than $x^8$, ... and $x^2$  grows faster than $x^0$ (which is constant)."

ImageFile(imgfile, caption)


plot(x^5, -2, 2)


### {{{ leading_term_graph }}}

pyplot()
anim = @animate for n in 1:6
    m = [1, .5, -1, -5, -20, -25]
    M = [2, 4,    5, 10, 25, 30]
    fn = x -> (x-1)*(x-2)*(x-3)*(x-5)

    plt = plot(fn, m[n], M[n], size=fig_size, legend=false, linewidth=2, title ="Graph of on ($(m[n]), $(M[n]))")
    if n > 1
        plot!(plt, fn, m[n-1], M[n-1], color=:red, linewidth=4)
    end
end

caption = "The previous graph is highlighted in red. Ultimately the leading term (\$x^4\$ here) dominates the graph."
imgfile = tempname() * ".gif"
gif(anim, imgfile, fps=1)

ImageFile(imgfile, caption)


p = a*x^2 + b*x + c
n = 2    # the degree of p
q = expand(x^n * p(x => 1/x))


expand((x-1)*(x-2)*(x-3))


factor(x^3 - 6x^2 + 11x -6)


factor(x^5 - 5x^4 + 8x^3 - 8x^2 + 7x - 3)


x^2 - 2


f(x) = -16x^2 + 100


f(x)


p = -16*x^2 + 100
p(2)


numericq(2)


numericq(3)


numericq(5)


booleanq(false, labels=["Yes", "No"])


booleanq(true, labels=["Yes", "No"])


booleanq(true, labels=["Yes", "No"])


choices = ["3", L"3x^2", L"-2x", L"5"]
ans = 2
radioq(choices, ans)


numericq(-2)


numericq(1)


numericq(-4)


choices = ["point-slope form", "slope-intercept form", "general form"]
ans = 2
radioq(choices, ans)


@vars x
p = -16x^2 + 64


choices = [q"p*2", q"p[2]", q"p_2", q"p(x=>2)"]
ans = 4
radioq(choices, ans)


choices = [
L"Be $U$-shaped, opening upward",
L"Be $U$-shaped, opening downward",
L"Overall, go upwards from $-\infty$ to $+\infty$",
L"Overall, go downwards from $+\infty$ to $-\infty$"]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"Be $U$-shaped, opening upward",
L"Be $U$-shaped, opening downward",
L"Overall, go upwards from $-\infty$ to $+\infty$",
L"Overall, go downwards from $+\infty$ to $-\infty$"]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"Be $U$-shaped, opening upward",
L"Be $U$-shaped, opening downward",
L"Overall, go upwards from $-\infty$ to $+\infty$",
L"Overall, go downwards from $+\infty$ to $-\infty$"]
ans = 2
radioq(choices, ans, keep_order=true)


numericq(4)


numericq(6)


choices = [q"x^3 - 3x^2  + 2x",
q"x^3 - x^2 - 2x",
q"x^3 + x^2 - 2x",
q"x^3 + x^2 + 2x"]
ans = 2
radioq(choices, 2)


choices = [
q"-h^2 + 3hx  - 3x^2",
q"h^3 + 3h^2x + 3hx^2 + x^3 -x^3/h",
q"x^3 - x^3/h",
q"0"]
ans = 1
radioq(choices, ans)

