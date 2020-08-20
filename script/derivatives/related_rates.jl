
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


### {{{growing_rects}}}
pyplot()
fig_size=(600, 400)



## Secant line approaches tangent line...
function growing_rects_graph(n)
    w = (t) -> 2 + 4t
    h = (t) -> 3/2 * w(t)
    t = n - 1

    w_2 = w(t)/2
    h_2 = h(t)/2

    w_n = w(5)/2
    h_n = h(5)/2

    plt = plot(w_2 * [-1, -1, 1, 1, -1], h_2 * [-1, 1, 1, -1, -1], xlim=(-17,17), ylim=(-17,17),
               legend=false, size=fig_size)
    annotate!(plt, [(-1.5, 1, "Area = $(round(Int, 4*w_2*h_2))")])
    plt


end
caption = L"""

As $t$ increases, the size of the rectangle grows. The ratio of width to height is fixed. If we know the rate of change in time for the width ($dw/dt$) and the height ($dh/dt$) can we tell the rate of change of *area* with respect to time ($dA/dt$)?

"""
n=6

anim = @animate for i=1:n
    growing_rects_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


A(w,h) = w * h


w(t) = 2 + 4*t


h(t) = 3/2 * w(t)


A(t) = A(w(t), h(t))


using CalculusWithJulia               # loads `ForwardDiff`, `Roots`
using Plots
tstar = fzero(x -> w(x) - 8, [0, 4])  # or solve by hand to get 3/2


A(t) = A(w(t), h(t))
da_dt = A'(tstar)


xs = [6, 54, 150, 294, 486, 726]
ds = diff(xs)


diff(ds)


using SymPy
@vars t
diff(A(t), t)


l, b, dbdt = 12, 4, 2
height = sqrt(l^2 - b^2)
-b/height * dbdt


###{{{baseball_been_berry_good}}}
## Secant line approaches tangent line...
pyplot()
function baseball_been_berry_good_graph(n)

    v0 = 15
    x = (t) -> 50t
    y = (t) -> v0*t - 5 * t^2


    ns = range(.25, stop=3, length=8)

    t = ns[n]
    ts = range(0, stop=t, length=50)
    xs = map(x, ts)
    ys = map(y, ts)

    degrees = atand(y(t)/(100-x(t)))
    degrees = degrees < 0 ? 180 + degrees : degrees

    plt = plot(xs, ys, legend=false, size=fig_size, xlim=(0,150), ylim=(0,15))
    plot!(plt, [x(t), 100], [y(t), 0.0], color=:orange)
    annotate!(plt, [(55, 4,"theta = $(round(Int, degrees)) degrees"),
                    (x(t), y(t), "($(round(Int, x(t))), $(round(Int, y(t))))")])

end
caption = L"""

The flight of the ball as being tracked by a stationary outfielder.  This ball will go over the head of the player. What can the player tell from the quantity $d\theta/dt$?

"""
n = 8


anim = @animate for i=1:n
    baseball_been_berry_good_graph(i)
end


imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


@vars t
theta = SymFunction("theta")

v0 = 5
x(t) = 50t
y(t) = v0*t - 5 * t^2
eqn = tan(theta(t)) - y(t) / (100 - x(t))


thetap = diff(theta(t),t)
dtheta = solve(diff(eqn, t), thetap)[1]


d2theta = diff(dtheta, t)(thetap => dtheta)


dtheta = dtheta(cos(theta(t))^2 => (100 -x(t))^2/(y(t)^2 + (100-x(t))^2))


plot(dtheta, 0, v0/5)


v0 = 15
x(t) = 50t
y(t) = v0*t - 5 * t^2
eqn = tan(theta(t)) - y(t) / (100 - x(t))
thetap = diff(theta(t),t)
dtheta = solve(diff(eqn, t), thetap)[1]
dtheta = subs(dtheta, cos(theta(t))^2, (100 - x(t))^2/(y(t)^2 + (100 - x(t))^2))
plot(dtheta, 0, v0/5)


choices = [
L"The rate of change of price will be $0$",
"The rate of change of price will increase",
"The rate of change of price will be positive and will depend on the rate of change of excess demand."
]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
"If the rate of change of unemployment is negative, the rate of change of wages will be negative.",
"If the rate of change of unemployment is negative, the rate of change of wages will be positive."
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
L"The rate of change of pressure is always increasing by $c$",
"If volume is constant, the rate of change of pressure is proportional to the temperature",
"If volume is constant, the rate of change of pressure is proportional to the rate of change of temperature",
"If pressure is held constant, the rate of change of pressure is proportional to the rate of change of temperature"]
ans = 3
radioq(choices, ans, keep_order=true)


# a = pi*r^2
# da/dt = pi * 2r * drdt
r = 10; drdt = 1
val = pi * 2r * drdt
numericq(val, units=L"feet$^2$/second")


# a = pi*r^2
# da/dt = pi * 2r * drdt
r = 10; dadt = 1
val =  dadt /( pi * 2r)
numericq(val, units="inches/second")


## tan(theta) = x/y
## sec^2(theta) dtheta/dt = 1/y dx/dt (y is constant)
## dxdt = y sec^2(theta) dtheta/dt
dthetadt = pi/4
y0 = .4; x0 = 1.0
theta = atan(x0/y0)
val = y0 * sec(theta)^2 * dthetadt
numericq(val, units="kilometers/minute")


## y/200 = 6/x
## dydt = 200 * 6 * -1/x^2 dxdt
x0 = 200 - 50
dxdt = 4
val = 200 * 6 * (1/x0^2) * dxdt
numericq(val, units="feet/second")


choices = [
L"f(x) = 1/x",
L"f(x) = x^0",
L"f(x) = x",
L"f(x) = x^2"
]
ans = 4
radioq(choices, ans)


r, dVdt = 3, 2
drdt = dVdt / (4 * pi * r^2)
numericq(drdt, units="units per unit time")


choices = [
L"y = 1 - x^2 - \log(x)",
L"y = 1 - x^2",
L"y = 1 - \log(x)",
L"y = x(2x - 1/x)"
]
ans = 1
radioq(choices, ans)


choices = [
L"dy/dt = 2x + 1/x",
L"dy/dt = 1 - x^2 - \log(x)",
L"dy/dt = -2x - 1/x",
L"dy/dt = 1"
]
ans=1
radioq(choices, ans)

