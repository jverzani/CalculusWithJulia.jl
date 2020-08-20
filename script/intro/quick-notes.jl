
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using LinearAlgebra


using Pkg
Pkg.add("SomePackageName")


using CalculusWithJulia
using Plots


f(x) = exp(x) * 2x


function g(x)
  a = sin(x)^2
  a + a^2 + a^3
end


fn = x -> sin(2x)
fn(pi/2)


Derivatve(f::Function) = x -> ForwardDiff.derivative(f, x)    # ForwardDiff is loaded in CalculusWithJulia


r(t) = [sin(t), cos(t), t]


f(x,y,z) = x*y + y*z + z*x
f(v) = f(v...)


f(x) = x[1]*x[2] + x[2]*x[3] + x[3]*x[1]


F(x,y,z) = [-y, x, z]
F(v) = F(v...)


f(t) = sin(t)*sqrt(t)
sin(1), sqrt(1), f(1)


Area(w, h) = w * h    # area of rectangle
Area(w) = Area(w, w)  # area of square using area of rectangle defintion


F(x,y,z) = [-y, x, z]
F(v) = F(v...)


circle(x; r=1) = sqrt(r^2 - x^2)
circle(0.5), circle(0.5, r=10)


using SymPy
@vars x y z  # no comma as done here, though @vars(x,y,z) is also available
x^2 + y^3 + z


@vars x y z real=true


sin(x)^2 + cos(x)^2


x - x + 1  # 1 is now symbolic


sin(PI), sin(pi)


1 / Sym(2)


N(PI)


sympy.harmonic(10)


x1 = (1, "two", 3.0)


x2 = [1, 2, 3.0]  # 3.0 makes theses all floating point


x3 = [1 2 3; 4 5 6; 7 8 9]


x4 = [1 2 3.0]


x1[1], x2[2], x3[3]


x3[1,2] # row one column two


x2[1], x3[1,1] = 2, 2


a,b,c = x2


5:10:55  # an object that describes 5, 15, 25, 35, 45, 55


1:10     # an object that describes 1,2,3,4,5,6,7,8,9,10


range(0, pi, length=5)  # range(a, stop=b, length=n) for version 1.0


for i in [1,2,3]
  print(i)
end


CalculusWithJulia.WeaveSupport.note("""Technical aside: For assignment within a for loop at the global level, a `global` declaration may be needed to ensure proper scoping.""")


[i^2 for i in [1,2,3]]


[1/(i+j) for i in 1:3, j in 1:4]


xs = [1,2,3]
sin.(xs)   # sin(1), sin(2), sin(3)


log.(5, xs)


ys = [4 5] # a row vector
f(x,y) = (x,y)
f.(xs, ys)    # broadcasting a column and row vector makes a matrix, then applies f.


map(sin, [1,2,3])


CalculusWithJulia.WeaveSupport.note("""Many different computer languages implement `map`, broadcasting is less common. `Julia`'s use of the dot syntax to indicate broadcasting is reminiscent of MATLAB, but is quite different.""")


using Plots
pyplot()      # select pyplot. Use `gr()` for GR; `plotly()` for Plotly


CalculusWithJulia.WeaveSupport.note("""
The `plotly` backend and `gr` backends are available by default. The `plotly` backend is has some interactivity, `gr` is for static plots. The `pyplot` package is used for certain surface plots, when `gr` can not be used.
""")


plot(sin, 0, 2pi)


f(x) = exp(-x/2pi)*sin(x)
plot(f, 0, 2pi)


plot(x -> sin(x) + sin(2x), 0, 2pi)


CalculusWithJulia.WeaveSupport.note("""The time to first plot can be lengthy! This can be removed by creating a custom `Julia` image, but that is not introductory level stuff. As well, standalone plotting packages offer quicker first plots, but the simplicity of `Plots` is preferred. Subsequent plots are not so time consuming, as the initial time is spent compiling functions so their re-use is speedy.
""")


xs = range(0, 2pi, length=100)
ys = sin.(xs)
plot(xs, ys, color=:red)


@vars x
plot(exp(-x/2pi)*sin(x), 0, 2pi)


plot(sin, 0, 2pi, color=:red)
plot!(cos, 0, 2pi, color=:blue)
plot!(zero, color=:green)  # no a, b then inherited from graph.


ts = range(0, 2pi, length = 100)
xs = [exp(t/2pi) * cos(t) for t in ts]
ys = [exp(t/2pi) * sin(t) for t in ts]
plot(xs, ys)


f1(t) = exp(t/2pi) * cos(t)
f2(t) = exp(t/2pi) * sin(t)
plot(f1, f2, 0, 2pi)


r(t) = exp(t/2pi) * [cos(t), sin(t)]
plot_parametric_curve(r, 0, 2pi)


ts = range(0, 2pi, length = 4)
vs = r.(ts)


ts = range(0, 2pi, length = 100)
vs = r.(ts)
xs = [vs[i][1] for i in eachindex(vs)]
ys = [vs[i][2] for i in eachindex(vs)]
plot(xs, ys)


plot(unzip(vs)...)


gr()
plot_parametric_curve(r, 0, 2pi)
t0 = pi/8
arrow!(r(t0), r'(t0))


plotly()    # The `plotly` backend allows for rotation by the mouse; otherwise the `camera` argument is used
f(x, y) = 2 - x^2 + y^2
xs = ys = range(-2,2, length=25)
surface(xs, ys, f)


surface(xs, ys, f.(xs, ys'))


contour(xs, ys, f)


contour(xs, ys, f.(xs, ys'))


f(x,y) = sin(x*y) - cos(x*y)
plot(Le(f, 0))     # or plot(f ≦ 0) using \leqq[tab] to create that symbol


X(theta, phi) = sin(phi)*cos(theta)
Y(theta, phi) = sin(phi)*sin(theta)
Z(theta, phi) = cos(phi)
thetas = range(0, pi/4, length=20)
phis = range(0, pi, length=20)
surface(X.(thetas, phis'), Y.(thetas, phis'), Z.(thetas, phis'))


Phi(theta, phi) = [sin(phi) * cos(theta), sin(phi) * sin(theta), cos(phi)]
thetas, phis = range(0, pi/4, length=15), range(0, pi, length=20)
xs, ys, zs = parametric_grid(thetas, phis, Phi)
surface(xs, ys, zs)
wireframe!(xs, ys, zs)


gr()  # better arrows than plotly()
F(x,y) = [-y, x]
vectorfieldplot(F, xlim=(-2, 2), ylim=(-2,2), nx=10, ny=10)


xs = [1, 1/10, 1/100, 1/1000]
f(x) = sin(x)/x
[xs f.(xs)]


@vars x
limit(sin(x)/x, x => 0)


@vars h x
limit((sin(x+h) - sin(x))/h, h => 0)


ForwardDiff.derivative(sin, pi/3) - cos(pi/3)


f(x) = sin(x)
f'(pi/3) - cos(pi/3)  # or just sin'(pi/3) - cos(pi/3)


f(x) = sin(x)
f''''(pi/3) - f(pi/3)


@vars x
f(x) = exp(-x)*sin(x)
ex = f(x)  # symbolic expression
diff(ex, x)   # or just diff(f(x), x)


diff(ex, x, x)


diff(ex, x, 5)


@vars mu sigma x
diff(exp(-((x-mu)/sigma)^2/2), x)


f(x,y,z) = x*y + y*z + z*x
f(v) = f(v...)               # this is needed for ForwardDiff.gradient
ForwardDiff.gradient(f, [1,2,3])


@vars x y z
ex = x*y + y*z + z*x
diff(ex, x)    # ∂f/∂x


f(x,y,z) =  x*y + y*z + z*x
f(v) = f(v...)
gradient(f)(1,2,3) - gradient(f, [1,2,3])


∇(f)(1,2,3)   # same as gradient(f, [1,2,3])


@vars x y z
ex = x*y + y*z + z*x
diff.(ex, [x,y,z])  # [diff(ex, x), diff(ex, y), diff(ex, z)]


gradient(ex, [x,y,z])


∇((ex, [x,y,z]))  # for this, ∇(ex) also works


F(u,v) = [u*cos(v), u*sin(v), u]
F(v) = F(v...)    # needed for ForwardDiff.jacobian
pt = [1, pi/4]
ForwardDiff.jacobian(F , pt)


@vars u v
ex = F(u,v)
ex.jacobian([u,v])


@vars u v real=true
vcat([diff.(ex, [u,v])' for ex in F(u,v)]...)


F(x,y,z) = [-y, x, z]
F(v) = F(v...)
pt = [1,2,3]
tr(ForwardDiff.jacobian(F , pt))


divergence(F, [1,2,3])
(∇⋅F)(1,2,3)    # not ∇⋅F(1,2,3) as that evaluates F(1,2,3) before the divergence


@vars x y z
ex = F(x,y,z)
sum(diff.(ex, [x,y,z]))    # sum of [diff(ex[1], x), diff(ex[2],y), diff(ex[3], z)]


divergence(ex, [x,y,z])
∇⋅(F(x,y,z), [x,y,z])   # For this, ∇ ⋅ F(x,y,z) also works


F(x,y,z) = [-y, x, 1]
F(v) = F(v...)
curl(F, [1,2,3])


curl(F)(1,2,3), curl(F)([1,2,3])


(∇×F)(1,2,3)


using QuadGK
quadgk(sin, 0, pi)


quadgk(x->1/x^(1/2), 0, 1)


@vars a x real=true
integrate(exp(a*x)*sin(x), x)


integrate(sin(a + x), (x, 0, PI))   #  ∫_0^PI sin(a+x) dx


f(x,y) = x*y^2
f(v) = f(v...)
hcubature(f, (0,0), (1, 2))  # computes ∫₀¹∫₀² f(x,y) dy dx


f(x,y,z) = x*y^2*z^3
f(v) = f(v...)
hcubature(f, (0,0,0), (1, 2,3)) # computes ∫₀¹∫₀²∫₀³ f(x,y,z) dz dy dx


f(x,y) = x*y^2
f(v) = f(v...)
Phi(r, theta) = r * [cos(theta), sin(theta)]
Phi(rtheta) = Phi(rtheta...)
integrand(rtheta) = f(Phi(rtheta)) * det(ForwardDiff.jacobian(Phi, rtheta))
hcubature(integrand, (0.0,-pi/2), (1.0, pi/2))


fubini(f, (x -> -sqrt(1-x^2), x -> sqrt(1-x^2)), (0, 1))


@vars x y real=true
integrate(x * y^2, (y, -sqrt(1-x^2), sqrt(1-x^2)), (x, 0, 1))


f(x,y) = 2 - x^2 - y^2
f(v) = f(v...)
r(t) = [cos(t), sin(t)]/t
integrand(t) = (f∘r)(t) * norm(r'(t))
quadgk(integrand, 1, 2)


F(x,y) = [-y, x]
F(v) = F(v...)
r(t) =  [cos(t), sin(t)]/t
integrand(t) = (F∘r)(t) ⋅ r'(t)
quadgk(integrand, 1, 2)


@vars x y z t real=true
phi(x,y,z) = 1/sqrt(x^2 + y^2 + z^2)
r(t) = [cos(t), sin(t), t]
∇phi = diff.(phi(x,y,z), [x,y,z])
∇phi_r = subs.(∇phi, x.=> r(t)[1], y.=>r(t)[2], z.=>r(t)[3])
rp = diff.(r(t), t)
ex = simplify(∇phi_r ⋅ rp )


integrate(ex, (t, 0, 2PI))


Phi(u,v) = [u*cos(v), u*sin(v), u]
Phi(v) = Phi(v...)

function SE(Phi, pt)
   J = ForwardDiff.jacobian(Phi, pt)
   J[:,1] × J[:,2]
end

norm(SE(Phi, [1,2]))


hcubature(pt -> norm(SE(Phi, pt)), (0.0,0.0), (1.0, 2pi))


@vars u v real=true
ex = Phi(u,v)
J = ex.jacobian([u,v])
SurfEl = norm(J[:,1] × J[:,2]) |> simplify


integrate(SurfEl, (u, 0, 1), (v, 0, 2PI))


F(x,y,z) = [x, y, z]
ex = F(Phi(u,v)...)  ⋅ (J[:,1] × J[:,2])
integrate(ex, (u,0,1), (v, 0, 2PI))

