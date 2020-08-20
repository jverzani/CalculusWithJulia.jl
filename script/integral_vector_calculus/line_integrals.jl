
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots


rho(x,y,z) = 5 - z
rho(v) = rho(v...)
r(t) = [cos(t), 0, sin(t)]
@vars t
rp = diff.(r(t),t)  # r'
area = integrate((rho ∘ r)(t) * norm(rp), (t, 0, PI))


Mz = integrate(r(t)[3] * (rho ∘ r)(t) * norm(rp), (t, 0, PI))
Mz


Mz / area


f(x,y,z) = x*sin(y)*cos(z)
f(v) = f(v...)
r(t) = [t, t^2, t^3]
integrand(t) = (f ∘ r)(t) * norm(r'(t))
quadgk(integrand, 0, pi)


F(x,y,z) = [x-y, x^2 - y^2, x^2 - z^2]
F(v) = F(v...)
r(t) = [t, t^2, t^3]

@vars t real=true
integrate((F ∘ r)(t) ⋅ diff.(r(t), t), (t, 0, 1))


r1(t) = [-1 + 2t, 0]
r2(t) = [1-t, t]
r3(t) = [-t, 1-t]
F(x,y) = [-y, x]
F(v) = F(v...)
integrand(r) = t -> (F ∘ r)(t) ⋅ r'(t)
C1 = quadgk(integrand(r1), 0, 1)[1]
C2 = quadgk(integrand(r2), 0, 1)[1]
C3 = quadgk(integrand(r3), 0, 1)[1]
C1 + C2 + C3


using QuadGK
uvec(v) = v/norm(v) # unit vector
GMm = 10
F(r) = - GMm /norm(r)^2 * uvec(r)
r(t) = [1-t, 0, t]
quadgk(t -> (F ∘ r)(t) ⋅ r'(t), 0, 1)


r(t) = [cos(t), 0, sin(t)]
quadgk(t -> (F ∘ r)(t) ⋅ r'(t), 0, 1)


note("""
The [Washington Post](https://www.washingtonpost.com/outlook/everything-you-thought-you-knew-about-gravity-is-wrong/2019/08/01/627f3696-a723-11e9-a3a6-ab670962db05_story.html") had an article by Richard Panek with the quote "Well, yes — depending on what we mean by 'attraction.' Two bodies of mass don’t actually exert some mysterious tugging on each other. Newton himself tried to avoid the word 'attraction' for this very reason. All (!) he was trying to do was find the math to describe the motions both down here on Earth and up there among the planets (of which Earth, thanks to Copernicus and Kepler and Galileo, was one)." The point being the formula above is a mathematical description of the force, but not an explanation of how the force actually is transferred.
""")


@vars k q q0 t
F(r) = k*q*q0 * r / norm(r)^3
r(t) = [cos(t), sin(t)]
T(r) = [-r[2], r[1]]
W = integrate(F(r(t)) ⋅ T(r(t)), (t, 0, 2PI))


Radial(x,y) = [x,y]
Radial(v) = Radial(v...)

r(t) = [-1 + t, 0]
quadgk(t -> Radial(r(t)) ⋅ r'(t), 0, 2)


r(t) = [-cos(t), sin(t)]
quadgk(t -> Radial(r(t)) ⋅ r'(t), 0, pi)


gr()
p = plot(legend=false, aspect_ratio=:equal)
for y in range(0, 1, length=15)
    arrow!( [0,y], [3,0])
end
plot!(p, [2,2],[.6, .9], linewidth=3)
arrow!( [2,.75],1/2*[1,0], linewidth=3)
theta = pi/3
l = .3/2
plot!(p, [2-l*cos(theta), 2+l*cos(theta)], [.25-l*sin(theta), .25+l*sin(theta)], linewidth=3)
arrow!( [2, 0.25], 1/2*[sin(theta), -cos(theta)], linewidth=3)

plotly()
p


note(L"""
For a Jordan curve, the positive orientation of the curve is such that the normal direction (proportional to $\hat{T}'$) points away from the bounded interior. For a non-closed path, the choice of parameterization will determine the normal and the integral for flow across a curve is dependent - up to its sign - on this choice.
""")


3000/60


40 * 50 * 5 * 60


r(t) = [cos(t), 2sin(t)]
F(x,y) = [cos(x), sin(x*y)]
F(v) = F(v...)
normal(a,b) = [b, -a]
G(t) = (F ∘ r)(t) ⋅ normal(r(t)...)
a, b = 0, pi/2
quadgk(G, a, b)[1]


@vars t real=true
F(x,y) = [-y,x]
F(v) = F(v...)
r(t) = [cos(t),sin(t)]
T(t) = diff.(r(t), t)
normal(a,b) = [b,-a]
integrate((F ∘ r)(t) ⋅ normal(T(t)...) , (t, 0, 2PI))


@vars t real=true
F(x,y) = [x, y]
F(v) = F(v...)
r(t) = [cos(t),sin(t)]
T(t) = diff.(r(t), t)
normal(a,b) = [b,-a]
integrate((F ∘ r)(t) ⋅ normal(T(t)...) , (t, 0, 2PI))


F(x,y) = [x,y] / norm([x,y])^2
F(v) = F(v...)


@vars s real=true

r(s) = [-1 + s, -1]
n = [0,-1]
A1 = integrate(F(r(s)) ⋅ n, (s, 0, 2))


r(s) = [1, -1 + s]
n = [1, 0]
A2 = integrate(F(r(s)) ⋅ n, (s, 0, 2))


r(s) = [1 - s, 1]
n = [0, 1]
A3 = integrate(F(r(s)) ⋅ n, (s, 0, 2))


r(s) = [-1, 1-s]
n = [-1, 0]
A4 = integrate(F(r(s)) ⋅ n, (s, 0, 2))

A1 +  A2 +  A3 + A4


@vars t real=true
r(t) = [cos(t), sin(t)]
N(t) = r(t)
integrate(F(r(t)) ⋅ N(t), (t, 0, 2PI))


#out = download("https://upload.wikimedia.org/wikipedia/en/c/c1/Cloud_Gate_%28The_Bean%29_from_east%27.jpg")
#cp(out, "figures/kapoor-cloud-gate.jpg")
imgfile = "figures/kapoor-cloud-gate.jpg"
caption = """
The Anish Kapoor sculpture Cloud Gate maps the Cartesian grid formed by its concrete resting pad onto a curved surface showing the local distortions.  Knowing the areas of the reflected grid after distortion would allow the computation of the surface area of the sculpture through addition. (Wikipedia)
"""
ImageFile(imgfile, caption)


f(x,y) = 2 - (x+1/2)^2 - y^2
xs = ys = range(0, 1/2, length=10)
p = surface(xs, ys, f, legend=false, camera=(45,45))
for x in xs
    plot!(p, unzip(y -> [x, y, f(x,y)], 0, 1/2)..., linewidth=3)
    plot!(p, unzip(y -> [x, y, 0], 0, 1/2)..., linewidth=3)
end
for y in ys
    plot!(p, unzip(x -> [x, y, f(x,y)], 0, 1/2)..., linewidth=3)
    plot!(p, unzip(x -> [x, y, 0], 0, 1/2)..., linewidth=3)
end
p


# from https://commons.wikimedia.org/wiki/File:Surface_integral1.svg
#cp(download("https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Surface_integral1.svg/500px-Surface_integral1.svg.png"), "figures/surface-integral-cell.png", force=true)
imgfile = "figures/surface-integral-cell.png"
caption = "The rectangular region maps to a piece of the surface approximated by a parallelogram whose area can be computed. (Wikipedia)"
ImageFile(imgfile, caption)


pyplot()
f(x,y)= .5 - ((x-2)/4)^2 - ((y-1)/3)^2
Phi(uv) = [uv[1],uv[2],f(uv...)]

xs = range(0, 3.5, length=50)
ys = range(0, 2.5, length=50)
surface(xs,ys, f, legend=false)
Δx = 0.5; Δy = 0.5
x0 = 2.5; y0 = 0.25

ps = [[x0,y0,0], [x0+Δx,y0,0],[x0+Δx,y0+Δy,0],[x0, y0+Δy, 0],[x0,y0,0]]
plot!(unzip(ps)..., seriestype=:shape, color =:blue)

fx = t -> [x0+t, y0, f(x0+t, y0)]
fy = t -> [x0, y0+t, f(x0, y0+t)]
plot!(unzip(fx.(xs.-x0))..., color=:green)
plot!(unzip(fy.(ys.-y0))..., color=:green)
fx = t -> [x0+t, y0+Δy, f(x0+t, y0+Δy)]
fy = t -> [x0+Δx, y0+t, f(x0+Δx, y0+t)]
ts = range(0, 1, length=20)
plot!(unzip(fx.(ts*Δx))..., color=:green)
plot!(unzip(fy.(ts*Δy))..., color=:green)

Pt = [x0,y0,f(x0,y0)]
Jac = ForwardDiff.jacobian(Phi, Pt[1:2])
v1 = Jac[:,1]; v2 = Jac[:,2]
arrow!(Pt, v1/2, linewidth=5, color=:red)
arrow!(Pt, v2/2, linewidth=5, color=:red)
arrow!(Pt + v1/2, v2/2, linewidth=1, linetype=:dashed, color=:red)
arrow!(Pt + v2/2, v1/2, linewidth=1, linetype=:dashed, color=:red)
arrow!(Pt, (1/4)*(v1 × v2), linewidth=3, color=:blue)


@vars R theta a b positive=true
n = [cos(theta), sin(theta), -b] × [-R*sin(theta), R*cos(theta), 0]
se = simplify(norm(n))


Phi(r, theta) = [r*cos(theta), r*sin(theta), a - b*r]
Phi(R, theta).jacobian([R, theta])


integrate(1 * se, (R, 0, a/b), (theta, 0, 2PI))


R = a/b; h = a
pi * R * (R + sqrt(R^2 + h^2)) |> simplify


Rad = 1
Phi(theta, phi) = Rad * [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(phi)]
Phi(v) = Phi(v...)

function surface_element(pt)
  Jac = ForwardDiff.jacobian(Phi, pt)
  v1, v2 = Jac[:,1], Jac[:,2]
  norm(v1 × v2)
end
out = hcubature(surface_element, (0, 0), (2pi, 1pi))
out[1] - 4pi*Rad^2  # *basically* zero


H = SymFunction("H")
@vars x theta real=true
Phi(x, theta) = [x, H(x)*cos(theta), H(x)*sin(theta)]
Jac = Phi(x, theta).jacobian([x, theta])
v1, v2 = Jac[:,1], Jac[:,2]
norm(v1 × v2)


norm((v1 × v2)/H(x)) .|> simplify


@vars theta phi real=true
Phi(theta, phi) = [cos(phi)*cos(theta), cos(phi)*sin(theta), sin(phi)]
Jac = Phi(theta,phi).jacobian([theta, phi])
v1, v2 = Jac[:,1], Jac[:,2]
SurfElement = norm(v1 × v2) |> simplify


z = sin(phi)
integrate(z * SurfElement, (theta, 0, 2PI), (phi, 0, PI/2))


@vars y theta positive=true
Phi(y,theta) = [sqrt(y)*cos(theta), y, sqrt(y)*sin(theta)]
Jac = Phi(y, theta).jacobian([y, theta])
v1, v2 = Jac[:,1], Jac[:,2]
Normal = v1 × v2


F(x,y,z) = [0, y, -z]
F(v) = F(v...)
integrate(F(Phi(y,theta)) ⋅ Normal, (theta, 0, 2PI), (y, 0, 4))


F(x,y,z) = [1, y, z]
F(v) = F(v...)


@vars R theta positive=true
Phi(r,theta) = [r*cos(theta), r*sin(theta), 0]
Jac = Phi(R, theta).jacobian([R, theta])
v1, v2 = Jac[:,1], Jac[:,2]
Normal = v1 × v2 .|> simplify


F(x,y,z)= [1, y, -z]
A1 = integrate(F(Phi(R, theta)) ⋅ (-Normal), (theta, 0, 2PI), (R, 0, 1))  # use -Normal for outward pointing


Phi(r, theta) = [r*cos(theta), r*sin(theta), 1 + r*cos(theta)]
Jac = Phi(R, theta).jacobian([R, theta])
v1, v2 = Jac[:,1], Jac[:,2]
Normal = v1 × v2 .|> simplify  # has correct orientation


A2 = integrate(F(Phi(R, theta)) ⋅ (Normal), (theta, 0, 2PI), (R, 0, 1))


@vars z positive=true
Phi(z, theta) = [cos(theta), sin(theta), z]
Jac = Phi(z, theta).jacobian([z, theta])
v1, v2 = Jac[:,1], Jac[:,2]
Normal = v1 × v2 .|> simplify  # wrong orientation, so we change sign below


A3 = integrate(F(Phi(Rad, theta)) ⋅ (-Normal), (z, 0, 1 + cos(theta)), (theta, 0, 2PI))


A1 + A2 + A3


E(r) = (1/norm(r)^2) * uvec(r) # kq = 1

Phi(theta, phi) = 1*[sin(phi)*cos(theta), sin(phi) * sin(theta), cos(phi)]
Phi(r) = Phi(r...)

normal(r) = Phi(r)/norm(Phi(r))

function SE(r)
    Jac = ForwardDiff.jacobian(Phi, r)
    v1, v2 = Jac[:,1], Jac[:,2]
    v1 × v2
end

a = rand() * Phi(2pi*rand(), pi*rand())
A1 = hcubature(r -> E(Phi(r)-a) ⋅ normal(r) * norm(SE(r)), (0.0,0.0), (2pi, 1pi))
A1[1]


a = 2 * Phi(2pi*rand(), pi*rand())  # random point with radius 2
A1 = hcubature(r -> E(Phi(r)-a) ⋅ normal(r) * norm(SE(r)), (0.0,0.0), (2pi, pi/2))
A2 = hcubature(r -> E(Phi(r)-a) ⋅ normal(r) * norm(SE(r)), (0.0,pi/2), (2pi, 1pi))
A1[1] + A2[1]


r(t) = [exp(t)*cos(t), exp(-t)*sin(t)]
val = norm(r'(1/2))
numericq(val)


T(t) = r'(t)/norm(r'(t))
N(t) = T'(t)/norm(T'(t))
val = N(1/2)[1]
numericq(val)


Phi(u,v) = [u, v, u^2 + v^2]
Jac = ForwardDiff.jacobian(uv -> Phi(uv...), [1,2])
val = norm(Jac[:,1] × Jac[:,2])
numericq(val)


choices = [
L"\langle a, b, c\rangle / \| \langle a, b, c\rangle\|",
L"\langle a, b, c\rangle",
L"\langle d-a, d-b, d-c\rangle / \| \langle d-a, d-b, d-c\rangle\|",
]
ans = 1
radioq(choices, ans)


choices = [
L"No. Moving $d$ just shifts the plane up or down the $z$ axis, but won't change the normal vector",
L"Yes. Of course. Different values for $d$ mean different values for $x$, $y$, and $z$ are needed.",
L"Yes. The gradient of $F(x,y,z) = ax + by + cz$ will be normal to the level curve $F(x,y,z)=d$, and so this will depend on $d$."
]
ans = 1
radioq(choices, ans)


F(x,y,z) = [-y, x, z]
r(t) = [cos(t), sin(t), t]
val = quadgk(t -> F(r(t)...) ⋅ r'(t), 0, 2pi)[1]
numericq(val)


choices = [
L"2\pi + 2\pi^2",
L"2\pi^2",
L"4\pi"
]
ans = 1
radioq(choices, ans)


F(x,y) = [2x^3*y^2, x*y^4 + 1]
r(t) = [t, t^2]
val = quadgk(t -> F(r(t)...) ⋅ r'(t), -1, 1)[1]
numericq(val)


choices =[
L"It will be $0$, as $\nabla{f}$ is orthogonal to the level curve and $\vec{r}'$ is tangent to the level curve",
L"It will $f(b)-f(a)$ for any $b$ or $a$"
]
ans = 1
radioq(choices, ans)


numericq(0)


@vars t real=true
f(x,y) =  atan(y/x)
r(t) = [cos(t), sin(t)]
∇f = subs.(∇(f(x,y)), x .=> r(t)[1], y .=> r(t)[2]) .|> simplify
drdt = diff.(r(t), t)
∇f ⋅ drdt |> simplify


choices = [
L"The field is a potential field, but the path integral around $0$ is not path dependent.",
L"The value of $d/dt(f\circ\vec{r})=0$, so the integral should be $0$."
]
ans =1
radioq(choices, ans)


choices = [
"Not continuous everywhere",
"Continuous everywhere"
]
ans = 1
radioq(choices, ans)


@vars x y
F(x,y) = [2x^3*y^2, x*y^4 + 1]
val = iszero(diff(F(x,y)[2],x) - diff(F(x,y)[1],y))
yesnoq(val)


@vars x y
F(x,y) = [2x^3, y^4 + 1]
val = iszero(diff(F(x,y)[2],x) - diff(F(x,y)[1],y))
yesnoq(val)


choices = [
L"\int_0^{2\pi} (a\cos(t)) \cdot (b\cos(t)) dt",
L"\int_0^{2\pi} (-b\sin(t)) \cdot (b\cos(t)) dt",
L"\int_0^{2\pi} (a\cos(t)) \cdot (a\cos(t)) dt"
]
ans=1
radioq(choices, ans)


choices = [
L"\langle \cos(v), \sin(v), 1\rangle",
L"\langle -u\sin(v), u\cos(v), 0\rangle",
L"u\langle -\cos(v), -\sin(v), 1\rangle"
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"\langle \cos(v), \sin(v), 1\rangle",
L"\langle -u\sin(v), u\cos(v), 0\rangle",
L"u\langle -\cos(v), -\sin(v), 1\rangle"
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
L"\langle \cos(v), \sin(v), 1\rangle",
L"\langle -u\sin(v), u\cos(v), 0\rangle",
L"u\langle -\cos(v), -\sin(v), 1\rangle"
]
ans = 3
radioq(choices, ans, keep_order=true)


Phi(u,v) = [u*v, u^2*v, u*v^2]
Phi(v) = Phi(v...)
function SurfaceElement(u,v)
  pt = [u,v]
  Jac = ForwardDiff.jacobian(Phi, pt)
  v1, v2 = Jac[:,1], Jac[:,2]
  cross(v1, v2)
end
a,err = hcubature(uv -> norm(SurfaceElement(uv...)), (0,0), (1,1))
numericq(a)


Phi(u,v) = [u*v, u^2*v, u*v^2]
Phi(v) = Phi(v...)
function SurfaceElement(u,v)
  pt = [u,v]
  Jac = ForwardDiff.jacobian(Phi, pt)
  v1, v2 = Jac[:,1], Jac[:,2]
  cross(v1, v2)
end
F(x,y,z) = [y^2,x,z]
F(v) = F(v...)
integrand(uv) = dot(F(Phi(uv)...), SurfaceElement(uv...))
a, err = hcubature(integrand, (0,0), (1,1))
numericq(a)


F(v) = [0,0,1]
Phi(theta, phi) = [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(phi)]
Phi(v) = Phi(v...)
function SurfaceElement(u,v)
  pt = [u,v]
  Jac = ForwardDiff.jacobian(Phi, pt)
  v1, v2 = Jac[:,1], Jac[:,2]
  cross(v1, v2)
end
integrand(uv) = dot(F(Phi(uv)), SurfaceElement(uv...))
a, err = hcubature(integrand, (0, 0), (2pi, pi/2))
numericq(abs(a))


#@vars x y real=true
#phi = 1 - (x+y)
#SE = sqrt(1 + diff(phi,x)^2, diff(phi,y)^2)
#integrate(x*y*S_, (y, 0, 1-x), (x,0,1)) # \sqrt{2}/24
choices = [
L"\sqrt{2}/24",
L"2/\sqrt{24}",
L"1/12"
]
ans = 1
radioq(choices, ans)


#Phi(u,v) = [u^2, u*v, v^2]
#F(x,y,z) = [x,y^2,z^3]
#Phi(v) = Phi(v...); F(v) = F(v...)
#@vars u v real=true
#function SurfaceElement(u,v)
#  pt = [u,v]
#  Jac = Phi(u,v).jacobian([u,v])
#  v1, v2 = Jac[:,1], Jac[:,2]
#  cross(v1, v2)
#end
#integrate(F(Phi(u,v)) ⋅ SurfaceElement(u,v), (u,0,1), (v,0,1)) # 17/252
choices = [
L"17/252",
L"0",
L"7/36",
L"1/60"
]
ans = 1
radioq(choices, ans)

