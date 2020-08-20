
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


## parts picture
u(x) = sin(x*pi/2)
v(x) = x
xs = range(0, stop=1, length=50)
a,b = 1/4, 3/4
p = plot(u, v, 0, 1, legend=false)
plot!(p, zero, 0, 1)
scatter!(p, [u(a), u(b)], [v(a), v(b)], color=:orange, markersize=5)

plot!(p, [u(a),u(a),0, 0, u(b),u(b),u(a)], [0, v(a), v(a), v(b), v(b), 0, 0], linetype=:polygon, fillcolor=:orange, alpha=0.25)
#plot!(p, [u(a),u(a),0],  [0, v(a), v(a)], color=:orange)
#plot!(p,  [u(b),u(b),0], [0, v(b), v(b)], color=:orange)
annotate!(p, [(0.65, .25, "A"), (0.4, .55, "B")])
annotate!(p, [(u(a),v(a) + .08, "(u(a),v(a))"), (u(b),v(b)+.08, "(u(b),v(b))")])


using CalculusWithJulia   # loads `SymPy`
@vars x
integrate(x^10 * exp(x), x)


integrate(cos(x)^10, x)


choices = [
L"du=1/x dx \quad v = x",
L"du=x\log(x) dx\quad v = 1",
L"du=1/x dx\quad v = x^2/2"]
ans = 1
radioq(choices, ans)


choices = [
L"du=\sec(x)\tan(x)dx \quad v=\tan(x)",
L"du=\csc(x) dx \quad v=\sec(x)^3 / 3",
L"du=\tan(x)  dx \quad v=\sec(x)\tan(x)"
]
ans = 1
radioq(choices, ans)


choices = [
L"du=-e^{-x} dx \quad v=\sin(x)",
L"du=-e^{-x} dx \quad v=-\sin(x)",
L"du=\sin(x)dx \quad v=-e^{-x}"
]
ans = 1
radioq(choices, ans)


f(x) = x*log(x)
a,b = 1,4
val,err = quadgk(f, a, b)
numericq(val)


f(x) = x*cos(2x)
a,b = 0, pi/2
val,err = quadgk(f, a, b)
numericq(val)


f(x) = log(x)^2
a,b = 1,exp(1)
val,err = quadgk(f, a, b)
numericq(val)


choices = [
L"x(\log(x))^n - n \int (\log(x))^{n-1} dx",
L"\int (\log(x))^{n+1}/(n+1) dx",
L"x(\log(x))^n - \int (\log(x))^{n-1} dx"
]
ans = 1
radioq(choices, ans)


choices = ["L", "I", "A", "T", "E"]
ans = 3
radioq(choices, ans, keep_order=true)


choices = ["L", "I", "A", "T", "E"]
ans = 1
radioq(choices, ans, keep_order=true)


choices = ["L", "I", "A", "T", "E"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = ["L", "I", "A", "T", "E"]
ans = 4
radioq(choices, ans, keep_order=true)


choices = [
L"x\cos^{-1}(x)-\sqrt{1 - x^2}",
L"x^2/2 \cos^{-1}(x) - x\sqrt{1-x^2}/4 - \cos^{-1}(x)/4",
L"-\sin^{-1}(x)"]
ans = 1
radioq(choices, ans)

