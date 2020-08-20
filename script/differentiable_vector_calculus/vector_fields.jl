
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots
F(u,v) = [-v, u]
vectorfieldplot(F, xlim=(-5,5), ylim=(-5,5), nx=10, ny=10)


#out download("https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/VFPt_Earths_Magnetic_Field_Confusion.svg/320px-VFPt_Earths_Magnetic_Field_Confusion.svg.png")
#cp(out, "figures/magnetic-field.png")

imgfile = "figures/magnetic-field.png"
caption = """
Illustration of the magnetic field of the earth using field lines to indicate the field. From
[Wikipedia](https://en.wikipedia.org/wiki/Magnetic_field).
"""
ImageFile(imgfile, caption)


gr()
F(r,theta) = r*[cos(theta), sin(theta)]
F(v) = F(v...)

rs = range(0, 2, length=5)
thetas = range(0, pi/2, length=9)

plot(legend=false, aspect_ratio=:equal)
plot!(unzip(F.(rs, thetas'))..., color=:red)
plot!(unzip(F.(rs', thetas))..., color=:blue)

pt = [1, pi/4]
J = ForwardDiff.jacobian(F, pt)
arrow!(F(pt...), J[:,1], linewidth=5, color=:red)
arrow!(F(pt...), J[:,2], linewidth=5, color=:blue)


X(theta,phi) = sin(phi) * cos(theta)
Y(theta,phi) = sin(phi) * sin(theta)
Z(theta,phi) = cos(phi)


thetas = range(0, stop=pi/2, length=50)
phis   = range(0, stop=pi,   length=50)

xs = [X(theta, phi) for theta in thetas, phi in phis]
ys = [Y(theta, phi) for theta in thetas, phi in phis]
zs = [Z(theta, phi) for theta in thetas, phi in phis]

plotly()
surface(xs, ys, zs)  ## see note


note("""Note: PyPlot can  be used directly to make these surface plots: `import PyPlot; PyPlot.plot_surface(xs,ys,zs)`""")


pyplot()  # for variety to compare to plotly()
surface(X.(thetas, phis'), Y.(thetas, phis'), Z.(thetas, phis'))


Phi(theta, phi) = [X(theta, phi), Y(theta, phi), Z(theta, phi)]

surface(unzip(Phi.(thetas, phis'))...)


xs, ys, zs = parametric_grid(thetas, phis, Phi)
surface(xs, ys, zs)


using SymPy
@vars theta phi
out = [diff.(Phi(theta, phi), theta) diff.(Phi(theta, phi), phi)]


subs.(out, theta.=> PI/12, phi.=>PI/6) .|> N


using ForwardDiff
Phi(v) = Phi(v...)    # need Phi(v) defined, not Phi(theta, phi)
pt = [pi/12, pi/6]
out = ForwardDiff.jacobian(Phi, pt)


us, vs = range(0, pi/2, length=25); range(0, pi, length=25)
xs, ys, zs = parametric_grid(us, vs, Phi)
surface(xs, ys, zs, legend=false)
arrow!(Phi(pt), out[:,1], linewidth=3)
arrow!(Phi(pt), out[:,2], linewidth=3)


using SymPy, LinearAlgebra   # done by CalculusWithJulia
@vars a b real=true

r = sqrt(a^2 + b^2)
theta = atan(b/a)

Jac = Sym[diff.(r, [a,b])';        # [∇f_1'; ∇f_2']
          diff.(theta, [a,b])']

simplify.(Jac)


[r, theta].jacobian([a, b])


det(Jac) |> simplify


function spherical_from_cartesian(x,y,z)
    r = sqrt(x^2 + y^2 + z^2)
    theta = atan(y/x)
    phi = acos(z/r)
    [r, theta, phi]
end

function cartesian_from_spherical(r, theta, phi)
    x = r*sin(phi)*cos(theta)
    y = r*sin(phi)*sin(theta)
    z = r*cos(phi)
    [x, y, z]
end

function cylindrical_from_cartesian(x, y, z)
    r = sqrt(x^2 + y^2)
    theta = atan(y/x)
    z = z
    [r, theta, z]
end

function cartesian_from_cylindrical(r, theta, z)
    x = r*cos(theta)
    y = r*sin(theta)
    z = z
    [x, y, z]
end


@vars r theta phi real=true

ex1 = cartesian_from_spherical(r, theta, phi)
J1 = ex1.jacobian([r, theta, phi])


det(J1) |> simplify


cylindrical_from_cartesian(v) = cylindrical_from_cartesian(v...)   # allow a vector of arguments

cylindrical_from_spherical(r, theta, phi) = (cylindrical_from_cartesian ∘ cartesian_from_spherical)(r, theta, phi)


ex2 = cylindrical_from_spherical(r, theta, phi)
J2 = ex2.jacobian([r, theta, phi])


@vars x y z real=true
ex3 = cylindrical_from_cartesian(x, y, z)
J3 = ex3.jacobian([x,y,z])


J3_Ga = subs.(J3, x .=> ex1[1], y .=> ex1[2], z .=> ex1[3]) .|> simplify  # the dots are important


J3_Ga * J1


J3_Ga * J1 - J2 .|> simplify


gradient(f::Function) = x -> ForwardDiff.gradient(f, x)


function Jacobian(F, x)
    n = length(F(x...))
    grads = [gradient(x -> F(x...)[i])(x) for i in 1:n]
    vcat(grads'...)
end


rtp = [1, pi/3, pi/4]
cylindrical_from_spherical(v) = cylindrical_from_spherical(v...)

ForwardDiff.jacobian(cylindrical_from_spherical, rtp)


cartesian_from_spherical(v) = cartesian_from_spherical(v...)

ForwardDiff.jacobian(cylindrical_from_cartesian, cartesian_from_spherical(rtp)) * ForwardDiff.jacobian(cartesian_from_spherical, rtp)


cartesian_from_spherical(v) = cartesian_from_spherical(v...) # F
spherical_from_cartesian(v) = spherical_from_cartesian(v...) # F⁻¹

p = [1, pi/3, pi/4]
q = cartesian_from_spherical(p)

A1 = ForwardDiff.jacobian(spherical_from_cartesian, q)    # J_F⁻¹(q)
A2 = ForwardDiff.jacobian(cartesian_from_spherical, p)    # J_F(p)

A1 * A2


det(A1), 1/det(A2)


F(u, v) = [u*cos(v), u*sin(v), 2v]
plotly()


us, vs = range(0, 1, length=25), range(0, 2pi, length=25)
xs, ys, zs = parametric_grid(us, vs, F)
surface(xs, ys, zs)


yesnoq(true)


rad(u) = 1 + u^2
F(u, v) = [rad(u)*cos(v), rad(u)*sin(v), u]


us, vs = range(-1, 1, length=25), range(0, 2pi, length=25)
xs, ys, zs = parametric_grid(us, vs, F)
surface(xs, ys, zs)


yesnoq(true)


choices = [
"Yes",
"No, it is the transpose"
]
ans=2
radioq(choices, ans, keep_order=true)


choices = [
"Yes",
"No, it is the transpose"
]
ans=1
radioq(choices, ans, keep_order=true)


@vars lambda lambda_0 phi phi_0
F(lambda,phi) = [cos(phi)*sin(lambda-lambda_0), cos(phi_0)*sin(phi) - sin(phi_0)*cos(phi)*cos(lambda-lambda_0)]

out = [diff.(F(lambda, phi), lambda) diff.(F(lambda, phi), phi)]
det(out) |> simplify


choices = [
"The determinant of the Jacobian.",
"The determinant of the Hessian.",
"The determinant of the gradient."
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
"`det(F(lambda, phi).jacobian([lambda, phi]))`",
"`det(hessian(F(lambda, phi), [lambda, phi]))`",
"`det(gradient(F(lambda, phi), [lambda, phi]))`"
]
ans=1
radioq(choices, ans, keep_order=true)


choices = [
L"3x^2y^2/(z\cos(z) + \sin(z) + 1)",
L"2x^3y/ (z\cos(z) + \sin(z) + 1)",
L"3x^2y^2"
]
ans = 1
radioq(choices, ans)


choices = [
L"\frac{y \left(- x^{2} z^{2}{\left (x,y \right )} + 2 y^{2}\right)}{\left(x^{2} y^{2} - 2 z^{2}{\left (x,y \right )}\right) z{\left (x,y \right )}}",
L"\frac{x \left(2 x^{2} - y^{2} z^{2}{\left (x,y \right )}\right)}{\left(x^{2} y^{2} - 2 z^{2}{\left (x,y \right )}\right) z{\left (x,y \right )}}",
L"\frac{x \left(2 x^{2} - z^{2}{\left (x,y \right )}\right)}{\left(x^{2} - 2 z^{2}{\left (x,y \right )}\right) z{\left (x,y \right )}}"
]
ans = 1
radioq(choices, ans)


choices = [
L"R/r",
L"S/r",
L"R"
]
ans = 1
radioq(choices, ans)


choices = [
L"k r^{k-2} R",
L"kr^k R",
L"k r^{k-2} S"
]
ans = 1
radioq(choices, ans)


yesnoq(true)


choices = [
L"S/r^2",
L"S/r",
L"S"
]
ans = 1
radioq(choices, ans)


choices = [
L"As the left-hand side becomes $(-n+2)r^{-n}$, only $n=2$.",
L"All $n \geq 0$",
L"No values of $n$"
]
ans = 1
radioq(choices, ans)

