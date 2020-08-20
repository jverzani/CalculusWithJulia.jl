
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


###{{{taylor_animation}}}
pyplot()
fig_size = (600, 400)

taylor(f, x, c, n) = series(f, x, c, n+1).removeO()
function make_taylor_plot(u, a, b, k)
    k = 2k
    plot(u, a, b, title="plot of T_$k", linewidth=5, legend=false, size=fig_size, ylim=(-2,2.5))
    if k == 1
        plot!(zero, range(a, stop=b, length=100))
    else
        plot!(taylor(u, x, 0, k), range(a, stop=b, length=100))
    end
end



@vars x
u = 1 - cos(x)
a, b = -2pi, 2pi
n = 8
anim = @animate for i=1:n
    make_taylor_plot(u, a, b, i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)


caption = L"""

Illustration of the Taylor polynomial of degree $k$, $T_k(x)$, at $c=0$ and its graph overlayed on that of the function $1 - \cos(x)$.

"""

plotly()
ImageFile(imgfile, caption)


divided_differences(f, x) = f(x)
function divided_differences(f, x, xs...)
    xs = sort(vcat(x, xs...))
    (divided_differences(f, xs[2:end]...) - divided_differences(f, xs[1:end-1]...)) / (xs[end] - xs[1])
end


using CalculusWithJulia   # loads `SymPy`, `ForwardDiff`
using Plots
@vars x c real=true
@vars h positive=true
u = SymFunction("u")

ex = divided_differences(u, c, c+h)


limit(ex, h => 0)


ex = divided_differences(u, c, c+h, c+2h)
simplify(ex)


limit(ex, h => 0)


p = divided_differences(u, c) + divided_differences(u, c, c+h) * (x-c)
p(x => c) - u(c)


p(x => c+h) - u(c+h)


p = p + divided_differences(u, c, c+h, c+2h)*(x-c)*(x-(c+h))
simplify(p)


p(x => c+2h) - u(c+2h)


simplify(p(x => c+2h) - u(c+2h))


simplify(p(x => c+3h) - u(c+3h))


f(x) = cos(x)
a, b = -pi/2, pi/2
c = 0
h = 1/4

fp = -sin(c)  # by hand, or use diff(f), ...
fpp = -cos(c)


p = plot(f, a, b, linewidth=5, legend=false, color=:blue)
plot!(p, x->f(c) + fp*(x-c), a, b; color=:green, alpha=0.25, linewidth=5)                     # tangent line is flat
plot!(p, x->f(c) + fp*(x-c) + (1/2)*fpp*(x-c)^2, a, b; color=:green, alpha=0.25, linewidth=5)  # a parabola
p


x0, x1, x2 = c-h, c, c+h
f0 = divided_differences(f, x0)
fd = divided_differences(f, x0, x1)
fdd = divided_differences(f, x0, x1, x2)

plot(f, a, b,                  color=:blue, linewidth=5, legend=false)
plot!(x -> f0 + fd*(x-x0), a, b,     color=:green, alpha=0.25, linewidth=5);
plot!(x -> f0 + fd*(x-x0) + fdd * (x-x0)*(x-x1), a,b,  color=:green, alpha=0.25, linewidth=5);


f(t) = log(1 + t)
a, b = -1/2, 1
plot(f, a, b, legend=false, linewidth=5)
plot!(t -> t, a, b)
plot!(t -> t - t^2/2, a, b)


@vars x
c, n = 0, 10
l = series(log(1 + x), x, c, n+1)


series(1/(1-x), x, 0, 10)   # sum x^i for i in 0:n


series(exp(x), x, 0, 10)    # sum x^i/i! for i in 0:n


series(sin(x), x, 0, 10)    # sum (-1)^i * x^(2i+1) / (2i+1)! for i in 0:n


series(cos(x), x, 0, 10)    # sum (-1)^i * x^(2i) / (2i)! for i in 0:n


function taylor_poly(f, c=0, n=2)
     x -> f(c) + sum(D(f, i)(c) * (x-c)^i / factorial(i) for i in 1:n)
end


a = .1
f(x) = log(1+x)
Tn = taylor_poly(f, 0, 5)
Tn(a) - f(a)


function newton_form(f, xs)
  x -> begin
     tot = divided_differences(f, xs[1])
     for i in 2:length(xs)
        tot += divided_differences(f, xs[1:i]...) * prod([x-xs[j] for j in 1:(i-1)])
     end
     tot
  end
end


f(x) = sin(x)
c, h, n = 0, 1/4, 4
int_poly = newton_form(f, [c + i*h for i in 0:n])
tp = taylor_poly(f, c, n)
a, b = -pi, pi
plot(sin, a, b; linewidth=5)
plot!(int_poly, a, b, color=:green)
plot!(tp, a, b, color=:red)


d1(x) = f(x) - int_poly(x)
d2(x) = f(x) - tp(x)
a, b = -pi, pi
plot(d1, a, b, color=:blue)
plot!(d2, a, b, color=:green)


f(x) = 1 - cos(x)
a, b = -pi, pi
plot(f, a, b, linewidth=5)
plot!(taylor_poly(f, 0, 2), a, b)
plot!(taylor_poly(f, 0, 4), a, b)
plot!(taylor_poly(f, 0, 6), a, b)


G = 6.67408e-11
h = 780 * 1000
R =  3959 * 1609.34   # 1609 meters per mile
M = 5.972e24
P0, hR = (2pi)/sqrt(G*M) * R^(3/2), h/R

Preal = P0 * (1 + hR)^(3/2)
P1 = P0 * (1 + 3*hR/2)
Preal, P1


P5 = P0 * (1 + 3*hR/2 + 3*hR^2/8 - hR^3/16 + 3*hR^4/128 - 3*hR^5/256)


Preal/60


h = 12250 * 1609.34   # 1609 meters per mile
hR = h/R

Preal = P0 * (1 + hR)^(3/2)
P1 = P0 * (1 + 3*hR/2)
P5 = P0 * (1 + 3*hR/2 + 3*hR^2/8 - hR^3/16 + 3*hR^4/128 - 3*hR^5/256)

Preal, P1, P5


f1(x) = (1+x)^(3/2)
p2(x) = 1 + 3x/2 + 3x^2/8 - x^3/16 + 3x^4/128 - 3x^5/256
plot(f1, -1, 3, linewidth=4, legend=false)
plot!(p2, -1, 3)


using Unitful
m, mi, kg, s, hr = u"m", u"mi", u"kg", u"s", u"hr"

G = 6.67408e-11 * m^3 / kg / s^2
h = uconvert(m, 12250 * mi)   # unit convert miles to meter
R = uconvert(m,  3959 * mi)
M = 5.972e24 * kg

P0, hR = (2pi)/sqrt(G*M) * R^(3/2), h/R
Preal = P0 * (1 + hR)^(3/2)    # in seconds


uconvert(hr, Preal)  # ≈ 11.65 hours


@vars s
a = series(log(1 + s), s, 0, 19)
b = series(log(1 - s), s, 0, 19)
a_b = (a - b).removeO()  # remove"Oh" not remove"zero"


p = cancel(a_b - 2s/s)


@vars u
plot(u/(2+u), sqrt(2)/2 - 1, sqrt(2)-1)


M = (u/(2+u))(u => sqrt(2) - 1)


(2/19)*M^19


k, m = 2, 0.25
s = m / (2+m)
p = 2 * sum(s^(2i)/(2i+1) for i in 1:8)  # where the polynomial approximates the logarithm...

log(1 + m), m - s*(m-p), log(1 + m) - ( m - s*(m-p))


k * log(2) + (m - s*(m-p)), log(5)


choices = [
L"\sum_{k=0}^{10} x^k",
L"\sum_{k=1}^{10} (-1)^{n+1} x^n/n",
L"\sum_{k=0}^{4} (-1)^k/(2k+1)! \cdot x^{2k+1}",
L"\sum_{k=0}^{10} x^n/n!"
]
ans = 3
radioq(choices, ans)


choices = [
L"\sum_{k=0}^{10} x^k",
L"\sum_{k=1}^{10} (-1)^{n+1} x^n/n",
L"\sum_{k=0}^{4} (-1)^k/(2k+1)! \cdot x^{2k+1}",
L"\sum_{k=0}^{10} x^n/n!"
]
ans = 4
radioq(choices, ans)


choices = [
L"\sum_{k=0}^{10} x^k",
L"\sum_{k=1}^{10} (-1)^{n+1} x^n/n",
L"\sum_{k=0}^{4} (-1)^k/(2k+1)! \cdot x^{2k+1}",
L"\sum_{k=0}^{10} x^n/n!"
]
ans = 1
radioq(choices, ans)


choices = [
L"7/256",
L"-5/128",
L"1/5!",
L"2/15"
]
ans = 1
radioq(choices, ans)


choices = [
L"x^2 - x^6/3! + x^{10}/5!",
L"x^2",
L"x^2 \cdot (x - x^3/3! + x^5/5!)"
]
ans = 1
radioq(choices, ans)


choices = [L"f''''(0) = e",
L"f''''(0) = 4\cdot 3\cdot2 e",
L"f''''(0) = 0"]
ans = 2
radioq(choices, ans)


yesnoq(true)


choices =["It is increasing", "It is decreasing", "It both increases and decreases"]
ans = 1
radioq(choices, ans)


choices=["A critical point", "An end point"]
ans = 2
radioq(choices, ans)


choices = [
"The intermediate value theorem",
"The mean value theorem",
"The extreme value theorem"]
ans = 3
radioq(choices, ans)


choices = [
L"1/6!\cdot e^1 \cdot 1^6",
L"1^6 \cdot 1 \cdot 1^6"]
ans = 1
radioq(choices,ans)


choices = [
L"The function $e^x$ is increasing, so takes on its largest value at the endpoint and the function $|x^n| \leq |x|^n \leq (1/2)^n$",
L"The function has a critical point at $x=1/2$",
L"The function is monotonic in $k$, so achieves its maximum at $k+1$"
]
ans = 1
radioq(choices, ans)


f(k) = 1/factorial(k+1) * exp(1/2) * (1/2)^(k+1)
(f(13) > 1e-16 && f(14) < 1e-16) && numericq(14)


@vars x
ex = (1 - x + x^2)*exp(x)
Tn = series(ex, x, 0, 100).removeO()
ps = sympy.Poly(Tn, x).coeffs()
qs = numer.(ps)
qs[qs .> 1]  |> Tuple # format better for output


yesnoq(true)


using Roots
f(x) = sin(x)
xs = 0:3
dd = divided_differences
g(x) = dd(f,0) + dd(f, 0,1)*x + dd(f, 0,1,2)*x*(x-1) + dd(f, 0,1,2,3)*x*(x-1)*(x-2)
h1(x) = f(x) - g(x)
cps = find_zeros(D(h1), -1, 4)
plot(h1, -1/4, 3.25, linewidth=3, legend=false)
scatter!(xs, h1.(xs))
scatter!(cps, h1.(cps), markersize=3, marker=:square)

