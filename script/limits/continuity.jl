
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


plt = plot([-1,0], [-1,-1],  color=:black, legend=false, linewidth=5)
plot!(plt, [0, 1], [ 1, 1], color=:black, linewidth=5)
plt


plot([-1,-.1, .1, 1], [-1,-1, 1, 1], color=:black, legend=false, linewidth=5)


alert("""
The limit in the definition of continuity is the basic limit and not an extended sense where
infinities are accounted for. As with limits, such extensions are qualified in the language,
as in "*right* continous."
""")


plot([-1,-.01], [-1,-.01], legend=false, color=:black)
plot!([.01, 1], [.01, 1], color=:black)
scatter!([0], [1/2], markersize=5, markershape=:circle)


x = [0,1]; y=[0,0]
plt = plot(x.-2, y.-2, color=:black, legend=false)
plot!(plt, x.-1, y.-1, color=:black)
plot!(plt, x.-0, y.-0, color=:black)
plot!(plt, x.+1, y.+1, color=:black)
plot!(plt, x.+2, y.+2, color=:black)
scatter!(plt, [-2,-1,0,1,2], [-2,-1,0,1,2], markersize=5, markershape=:circle)
plt


using CalculusWithJulia   # load `SymPy`
using Plots
@vars x c
ex1 = 3x^2 + c
ex2 = 2x-3
del = limit(ex1, x=>0, dir="+") - limit(ex2, x=>0, dir="-")


solve(del, c)


choices = [L"f+g", L"f-g", L"f\cdot g", L"f\circ g", L"f/g"]
ans = length(choices)
radioq(choices, ans)


choices = [L"For all $x$", L"For all $x > 0$", L"For all $x$ where $\sin(x) > 0$"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [L"For all $x$", L"For all $x > 0$", L"For all $x$ where $\sin(x) > 0$"]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"The function $g$ is continuous everywhere",
L"The function $f$ is continuous everywhere",
L"The function $g$ is continuous everywhere and $f$ is continuous on the range of $g$",
L"The function $f$ is continuous everywhere and $g$ is continuous on the range of $f$"]
ans = 3
radioq(choices, ans, keep_order=true)


choices=[
L"When $x > 2$",
L"When $x \geq 2$",
L"When $x \leq 2$",
L"For $x \geq 0$"]
ans = 3
radioq(choices, ans)


f(x) = (x^2 -4)/(x-2);
numericq(f(2.00001), .001)


numericq(0, .001)


val = (3*0 - 4) - (sin(2*0 - pi/2))
numericq(val)


choices = [L"No, as $g(c)$ may not be in the interval $(a,b)$",
"Yes, composition of continuous functions results in a continous function, so the limit is just the function value."
]
ans=1
radioq(choices, ans)


xs = range(0, stop=2, length=50)
plot(xs, [sqrt(1 - (x-1)^2) for x in xs], legend=false, xlims=(0,4))
plot!([2,3], [1,0])
scatter!([3],[0], markersize=5)
plot!([3,4],[1,0])
scatter!([4],[0], markersize=5)


yesnoq(true)


yesnoq(false)


yesnoq(false)


yesnoq(true)


plot(xs, [sin.(2pi*xs) cos.(2pi*xs)], layout=2, title=["f" "g"], legend=false)


val = sin(2pi * cos(2pi * 1/4))
numericq(val)


val = cos(2pi * sin(2pi * 1/4))
numericq(val)


choices = ["Can't tell",
L"-1.0",
L"0.0"
]
ans = 1
radioq(choices, ans)

