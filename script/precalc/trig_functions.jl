
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


p = plot(legend=false, xlim=(0,5), ylim=(-1/2, 3),
         xticks=nothing, yticks=nothing, border=:none)
plot!([0,4,4,0],[0,0,3,0], linewidth=3)
del = .25
plot!([4-del, 4-del,4], [0, del, del], color=:black, linewidth=3)
annotate!([(.75, .35, "θ"), (4.0, 1.25, "opposite"), (2, -.25, "adjacent"), (1.5, 1.25, "hypotenuse")])


note("""Many students remember these through [SOH-CAH-TOA](http://mathworld.wolfram.com/SOHCAHTOA.html).""")


## {{{radian_to_trig}}}

#gr()
pyplot()
fig_size = (400, 300)

function plot_angle(m)
    r = m*pi

    ts = range(0, stop=2pi, length=100)
    tit = "$m * pi -> ($(round(cos(r), digits=2)), $(round(sin(r), digits=2)))"
    p = plot(cos.(ts), sin.(ts), legend=false, aspect_ratio=:equal,title=tit)
    plot!(p, [-1,1], [0,0], color=:gray30)
    plot!(p,  [0,0], [-1,1], color=:gray30)

    if r > 0
        ts = range(0, stop=r, length=100)
    else
        ts = range(r, stop=0, length=100)
    end

    plot!(p, (1/2 .+ abs.(ts)/10pi).* cos.(ts), (1/2 .+ abs.(ts)/10pi) .* sin.(ts), color=:red, linewidth=3)
    l = 1 #1/2 + abs(r)/10pi
    plot!(p, [0,l*cos(r)], [0,l*sin(r)], color=:green, linewidth=4)

    scatter!(p, [cos(r)], [sin(r)], markersize=5)
    annotate!(p, [(1/4+cos(r), sin(r), "(x,y)")])

    p
end



## different linear graphs
anim = @animate for m in  -4//3:1//6:10//3
    plot_angle(m)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)
caption = "An angle in radian measure corresponds to a point on the unit circle, whose coordinates define the sine and cosine of the angle."

ImageFile(imgfile, caption)


[cos(theta) for theta in [0, pi/6, pi/4, pi/3, pi/2]]


using CalculusWithJulia   # to load the `SymPy` package
using Plots
cos.([0, PI/6, PI/4, PI/3, PI/2])


note(L"""

For really large values, round off error can play a big role. For example, the *exact* value of $\sin(1000000 \pi)$ is $0$, but the returned value is not quite $0$ `sin(1_000_000 * pi) = -2.231912181360871e-10`. For exact multiples of $\pi$ with large multiples the `sinpi` and  `cospi` functions are useful.

(Both functions are computed by first employing periodicity to reduce the problem to a smaller angle. However, for large multiples the floating-point roundoff becomes a problem with the usual functions.)

""")


theta = 15 * 180/pi
adjacent = 100
opposite = adjacent * tan(theta)


tan(10 * pi/180)


30 * 3 / 6


1/30, tan(2*pi/180)


plot(sin, 0, 4pi)


plot(sin, 0, 4pi)
plot!(cos, 0, 4pi)


k = -2
pt = plot(tan, k*pi - pi/2+.1, k*pi + pi/2 - .1, legend=false, color=:blue)
for k in -1:2
  plot!(pt, tan,  k*pi - pi/2+.1, k*pi + pi/2 - .1, color=:blue)
end
pt


ImageFile("figures/summary-sum-and-difference-of-two-angles.jpg", "Geometric picture")


plot(asin, -1, 1)


plot(atan, -10, 10)


theta = 3pi/4                     # 2.35619...
x,y = (cos(theta), sin(theta))    # -0.7071..., 0.7071...
atan(y/x)


atan(y, x)


n, alpha, theta0 = 1.5, pi/3, pi/6
delta = theta0 - alpha + asin(n * sin(alpha - asin(sin(theta0)/n)))


n, alpha, theta0 = 1.5, pi/15, pi/10
delta = theta0 - alpha + asin(n * sin(alpha - asin(sin(theta0)/n)))
delta, (n-1)*alpha


n = 4/3
D(i) = pi + 2i - 4 * asin(sin(i)/n)
plot(D, 0, pi/2)


rad2deg(1.0)


T4(x) = (8x^4 - 8x^2 + 1) / 8
q(x) = (x+3/5)*(x+1/5)*(x-1/5)*(x-3/5)
plot(abs ∘ T4, -1,1)
plot!(abs ∘ q, -1,1)


a = sin(1.23456) > cos(6.54321)
choices = [L"\sin(1.23456)", L"\cos(6.54321)"]
ans = a ? 1 : 2
radioq(choices, ans, keep_order=true)


x = pi/4
a = cos(x) > x
choices = [L"\cos(x)", L"x"]
ans = a ? 1 : 2
radioq(choices, ans, keep_order=true)


choices = [
L"\cos(x) = \sin(x - \pi/2)",
L"\cos(x) = \sin(x + \pi/2)",
L"\cos(x) = \pi/2 \cdot \sin(x)"]
ans = 2
radioq(choices, ans)


choices = [
L"The values $k\pi$ for $k$ in $\dots, -2, -1, 0, 1, 2, \dots$",
L"The values $\pi/2 + k\pi$ for $k$ in $\dots, -2, -1, 0, 1, 2, \dots$",
L"The values $2k\pi$ for $k$ in $\dots, -2, -1, 0, 1, 2, \dots$"]
ans = 2
radioq(choices, ans, keep_order=true)


numericq(.0015, .01)


val = 3*acos(1/3)
numericq(val)


val = 0.1
numericq(val)


choices = ["odd", "even", "neither"]
ans = 1
radioq(choices, ans, keep_order=true)


choices = ["odd", "even", "neither"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = ["odd", "even", "neither"]
ans = 1
radioq(choices, ans, keep_order=true)


yesnoq(true)


yesnoq(false)

