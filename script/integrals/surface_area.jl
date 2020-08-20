
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


imgfile = "figures/gehry-hendrix.jpg"
caption = """

The exterior of the Jimi Hendrix Museum in Seattle has the signature
style of its architect Frank Gehry. The surface is comprised of
patches. A general method to find the amount of material to cover the
surface - the surface area - might be to add up the area of the
patches. However, in this section we will see for surfaces of
revolution, there is an easier way. (Photo credit to
[http://firepanjewellery.com/].)
"""

ImageFile(imgfile, caption)


## {{{surface_revolution }}}
imgfile = "figures/surface-revolution.png"
caption = L"""

Vase-like figure formed by the rotation of the graph of $x = 2 + \cos(y)$ about the $y$ axis.

Photo credit: [wikipedia](https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Surface_of_revolution_illustration.png/188px-Surface_of_revolution_illustration.png).
    """

ImageFile(imgfile, caption)


## {{{approximate_surface_area}}}
pyplot()
fig_size=(600, 400)

xs,ys = range(-1, stop=1, length=50), range(-1, stop=1, length=50)
f(x,y)= 2 - (x^2 + y^2)

dr = [1/2, 3/4]
df = [f(dr[1],0), f(dr[2],0)]

function sa_approx_graph(i)
    p = plot(xs, ys, f, st=[:surface], legend=false)
    for theta in range(0, stop=i/10*2pi, length=10*i )
        path3d!(p,sin(theta)*dr, cos(theta)*dr, df)
    end
    p
end
n = 10

anim = @animate for i=1:n
    sa_approx_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)


caption = L"""

Surface of revolution of $f(x) = 2 - x^2$ about the $y$ axis. The lines segments are the images of rotating the secant line connecting $(1/2, f(1/2))$ and $(3/4, f(3/4))$. These trace out the frustum of a cone which approximates the corresponding surface area of the surface of revolution. In the limit, this approximation becomes exact and a formula for the surface area of surfaces of revolution can be used to compute the value.

"""

plotly()
ImageFile(imgfile, caption)


using CalculusWithJulia  # loads `SymPy`, `QuadGK`, `ForwardDiff`
using Plots
@vars x
F = integrate(2 * PI * x^2 * sqrt(1 + (2x)^2), x)


F(1) - F(0)


f(x) = x^x
a, b = 0, 2
val, _ = quadgk(x -> 2pi * f(x) * sqrt(1 + f'(x)^2), a, b)
val


f(x) = x^x
r0, r1 = f(0), f(2)
pi * (r1 + r0) * sqrt(2^2 + (r1-r0)^2)


@vars M
ex = integrate(2PI * (1/x) * sqrt(1 + (-1/x)^2), (x, 1, M))


limit(asinh(M), M, oo)


limit(ex, M, oo)


g(t) = 2(1 + cos(t)) * cos(t)
f(t) = 2(1 + cos(t)) * sin(t)
plot(g, f, 0, 1pi)


choices = [
L"-\int_1^{-1} 2\pi \sqrt{1 + u^2} du",
L"-\int_1^{_1} 2\pi u \sqrt{1 + u^2} du",
L"-\int_1^{_1} 2\pi u^2 \sqrt{1 + u} du"
]
ans = 1
radioq(choices, ans)


f(x) = sin(x)
a, b = 0, pi
val, _ = quadgk(x -> 2pi* f(x) * sqrt(1 + f'(x)^2), a, b)
numericq(val)


f(x) = sqrt(x)
a, b = 0, 4
val, _ = quadgk(x -> 2pi* f(x) * sqrt(1 + f'(x)^2), a, b)
numericq(val)


f(x) = x^3/9
a, b = 0, 2
val, _ = quadgk(x -> 2pi* f(x) * sqrt(1 + f'(x)^2), a, b)
numericq(val)


choices = [
L"\int_u^{u+h} 2\pi dx",
L"\int_u^{u_h} 2\pi y dx",
L"\int_u^{u_h} 2\pi x dx"
]
ans = 1
radioq(choices, ans)


g(t) = cos(t)
f(t) = sin(t)
a, b = 0, pi/4
val, _ = quadgk(t -> 2pi* f(t) * sqrt(g'(t)^2 + f'(t)^2), a, b)
numericq(val)


g(t) = cos(t^3)
f(t) = sin(t^3)
a, b = 0, pi
val, _ = quadgk(t -> 2pi* f(t) * sqrt(g'(t)^2 + f'(t)^2), a, b)
numericq(val)


g(t) = cos(t^5)
f(t) = sin(t^5)
a, b = 0, pi
val, _ = quadgk(t -> 2pi* f(t) * sqrt(g'(t)^2 + f'(t)^2), a, b)
numericq(val)

