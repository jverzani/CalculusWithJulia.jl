
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


### {{{perimeter_area_graphic}}}
pyplot()
fig_size = (400, 400)


function perimeter_area_graphic_graph(n)
    h = 1 + 2n
    w = 10-h
    plt = plot([0,0,w,w,0], [0,h,h,0,0], legend=false, size=fig_size,
               xlim=(0,10), ylim=(0,10))
    scatter!(plt, [w], [h], color=:orange, markersize=5)
    annotate!(plt, [(w/2, h/2, "Area=$(round(w*h,digits=1))")])
    plt
end

caption = """

Some possible rectangles that satisfy the constraint on the perimeter and their area.

"""
n = 6
anim = @animate for i=1:n
    perimeter_area_graphic_graph(i-1)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


using CalculusWithJulia   #  `ForwardDiff`, `Roots`, `SymPy`
using Plots
A(b) = b * (10 - b)
plot(A, 0, 10)


A(b, h) = b*h


h(b) = (20 - 2b) / 2


A(b) = A(b, h(b))


find_zeros(A', 0, 10)   # find_zeros in `Roots`,


alert("""

Look at the last definition of `A`. The function `A` appears on both sides, though on the left side with one argument and on the right with two. These are two "methods" of a *generic* function, `A`. `Julia` allows multiple definitions for the same name as long as the arguments (their number and type) can disambiguate which to use. In this instance, when one argument is passed in then the last defintion is used (`A(b,h(b))`), whereas if two are passed in, then the method that multiplies both arguments is used. The advantage of multiple dispatch is illustrated: the same concept - area - has one function name, though there may be different ways to compute the area, so there is more than one implementation.

""")


ts = range(0, stop=pi, length=50)
x1,y1 = 4, 4.85840
x2,y2 = 3, 6.1438
delta = 4
p = plot(delta .+ x1*[0, 1,1,0], y1*[0,0,1,1],          linetype=:polygon, fillcolor=:blue, legend=false)
plot!(p, x2*[0, 1,1,0], y2*[0,0,1,1],                linetype=:polygon, fillcolor=:blue)

plot!(p, delta .+ x1/2 .+ x1/2*cos.(ts), y1.+x1/2*sin.(ts), linetype=:polygon, fillcolor=:red)
plot!(p, x2/2 .+ x2/2*cos.(ts), y2 .+ x2/2*sin.(ts),         linetype=:polygon, fillcolor=:red)
p


A(x, y) = x*y + pi*(x/2)^2 / 2


y(x) = (20 - x - pi * x/2) / 2


A(x) = A(x, y(x))


plot(A, 0, 20/(1+pi/2))


plot(A', 5.5, 5.7)


x = find_zero(A', (0, 20/(1+pi/2)))


(x, A(x))


@vars width height real=true

Area  = width * height + pi * (width/2)^2 / 2
Perim = 2*height + width + pi * width/2
h0    = solve(Perim - 20, height)[1]
Area  = Area(height=> h0)
w0    = solve(diff(Area,width), width)[1]


diff(Area, width, width)(width => 40)


A(w, h) = w*h + pi*(w/2)^2 / 2
h(w)    = (20 - w - pi * w/2) / 2
A(w)    =  A(w, h(w))
find_zero(A', (0, 20/(1+pi/2)))  # 40 / (pi + 4)


p = plot([0, 0, 15], [15, 0, 0], color=:blue, legend=false)
plot!(p, [5, 5, 15], [15, 8, 8], color=:blue)
plot!(p, [0,14.53402874075368], [12.1954981558864, 0], linewidth=3)
plot!(p, [0,5], [8,8], color=:orange)
plot!(p, [5,5], [0,8], color=:orange)
annotate!(p, [(13, 1/2, "θ"),
              (2.5, 11, "l2"), (10, 5, "l1"), (2.5, 7.0, "l2 * cos(θ)"),
	      (5.1, 5, "l1 * sin(θ)")])


l(l1, l2) = l1 + l2
l1(t) = 8/sin(t)
l2(t) = 5/cos(t)

l(t) = l(l1(t), l2(t))		# or simply l(t) = 8/sin(t) + 5/cos(t)


delta = 0.2
plot(l, delta, pi/2 - delta)


x = find_zero(l', (0.5, 1.0))


l(x)


T(x) = x/30 + sqrt(5^2 + (10-x)^2)/10


plot(T, 0, 10)


plot(T, 7, 9)


x = find_zero(T', (7, 9))


T(x)


sqrt(10^2 + 5^2)/10, T(x), (10+5)/30


### {{{lhopital_43}}}

imgfile = "figures/fcarc-may2016-fig43-250.gif"
caption = L"""

Image number $43$ from l'Hospital's calculus book (the first). A
traveler leaving location $C$ to go to location $F$ must cross two
regions separated by the straight line $AEB$. We suppose that in the
region on the side of $C$, he covers distance $a$ in time $c$, and
that on the other, on the side of $F$, distance $b$ in the same time
$c$. We ask through which point $E$ on the line $AEB$ he should pass,
so as to take the least possible time to get from $C$ to $F$? (From
http://www.ams.org/samplings/feature-column/fc-2016-05.)


"""
ImageFile(imgfile, caption)


@vars a b L x r0 r1 positive=true

d0 = sqrt(x^2 + a^2)
d1 = sqrt((L-x)^2 + b^2)

t = d0/r0 + d1/r1   # time = distance/rate
dt = diff(t, x)     # look for critical points


t1, t2 = SymPy.Introspection.args(dt)  # args finds arguments to the outer function (+ in this case)


ex = numer(t1^2)*denom(t2^2) - denom(t1^2)*numer(t2^2)


sympy.Poly(ex, x).coeffs() # a0 + a1⋅x + a2⋅x^2 + a3⋅x^3 + a4⋅x^4


q = ex(b=>0)
factor(q)


solve(q(r1=>r0), x)


ta = t(b=>0, r1=>r0)
ta(x=>0), ta(x=>L)


out = solve(q(r1 => 2r0), x)


t(r1 =>2r0, b=>0, x=>out[1], a=>1, L=>2, r0 => 1)  # for x=L


t(r1 =>2r0, b=>0, x=>out[2], a=>1, L=>2, r0 => 1)


t(r1 =>2r0, b=>0, x=>0, a=>1, L=>2, r0 => 1)


pts = [0, out...]
vals = N.([t(r1 =>2r0, b=>0, x=>u, a=>2, L=>1, r0 => 1) for u in pts])
[pts vals]


f(x) = x * exp(-x^2)
plot(f, 0, 100)


plot(f', 0, 5)


x = find_zero(f', (0, 1))


f(x)


SA(h, r) = h * 2pi * r + 2pi * r^2


h(r) = 355 / (pi * r^2)


SA(r) = SA(h(r), r)


plot(SA, 2, 10)


r0 = find_zero(SA', (3, 5))


h(r0)


A(a,b) = pi*a*b
P = 20
b1(a) = 20/pi - a
A(a) = A(a, b1(a))
x = find_zero(A', (0, 10))
val = A(x)
numericq(val)


A(a,b) = pi*a*b
P = 20
b1(a) = sqrt((P*2/pi)^2 - a^2)
A(a) = A(a, b1(a))
x = find_zero(A', (0, 10))
val = A(x)
numericq(val)


Ar(y) = (10-2y)*y;
val = Ar(find_zero(Ar',  5))
numericq(val, 1e-3)


yesnoq("no")


yesnoq("yes")


Prim(x,y) = 2x + 2y
Prim(x) = Prim(x, 20/x)
xstar = find_zero(Prim', 5)
val = Prim(xstar)
numericq(val)


choices = [
"It can be infinite",
"It is also 20",
L"17.888"
]
ans = 1
radioq(choices, ans)


2 * (1/2 * 10*cos(pi/4) * 10 * sin(pi/4)) + 10*sin(pi/4) * 10


function Ar(t)
	 opp = 10 * sin(t)
	 adj = 10 * cos(t)
	 2 * opp * adj/2 + opp * 10
end
t = find_zero(Ar', pi/4);	## Has issues with order=8 algorithm, tol > 1e-14 is needed
val = t * 180/pi;
numericq(val, 1e-3)


using Roots
P = 20
A(x,y) = x*y + pi * (x/2)^2
y(x) = (P - pi*x)/2 # P = 2y + 2pi*x/2
A(x) = A(x,y(x))
x0 = find_zero(D(A), (0, 10))
val = y(x0)
numericq(val) # 0


p = plot([0, 30,30], [0,0,10], xlim=(0, 32), color=:blue, legend=false)
plot!(p, [30, 30], [10, 30], color=:blue, linewidth=4)
plot!(p, [0, 30,30,0], [0,10,30,0], color=:orange)
annotate!(p, [(x,y,l) for (x,y,l) in zip([15, 5, 31, 31], [1.5, 3.5, 5, 20], ["x=30", "θ", "10", "20"])])


theta(x) = atan(30/x) - atan(10/x)
val = find_zero(D(theta), 20); ## careful where one starts
val = theta(val) * 180/pi
numericq(val, 1e-1)


Likhood(t) = t^3 * exp(-3t) * exp(-2t) * exp(-4t) ## 0 <= t <= 10


x = find_zero(Likhood',  (0.1, 0.5))


choices=["It does work and the answer is x = 2.27...",
	 L" $Likhood(t)$ is not continuous on $0$ to $10$",
         L" $Likhood(t)$ takes its maximum at a boundary point - not a critical point"];
ans = 3;
radioq(choices, ans)


using SymPy
n = 10
@vars s
xs = [symbols("x\$i") for i in 1:n]
s(x) = sum((x-xs[i])^2 for i in 1:n)
cps = solve(diff(s(x), x), x)


choices=[
"The mean, or average, of the values",
"The median, or middle number, of the values",
L"The square roots of the values squared, $(x_1^2 + \cdots x_n^2)^2$"
]
ans = 1
radioq(choices, ans)


f(x) = 2x + 3/x;
val = find_zero(f', 1);
numericq(val, 1e-3)


# 4 = xy
Prim(x) = 2x + 2*(4/x);
val = find_zero(D(Prim), 1);
numericq(Prim(val), 1e-3)		## a square!


Ar(w,h) = w + h
h(w) = (400 - 2pi*w/2 + 2w) / 2
Ar(w) = Ar(w, h(w)) ## linear
val = Ar(0)
numericq(val)


#A = w*h = 12000
w(h) = 12_000 / h
S(w, h) = (w- 2*8) * (h - 2*32)
S(h) = S(w(h), h)
hstar =find_zero(D(S), 500)
wstar = w(hstar)
numericq(wstar)


numericq(hstar)


f(x) = log(x) - x
p = plot(f, 0.2, 2, ylim=(-2,0.25), legend=false, linewidth=3)
plot!(p, [0,0], [-2, 0.25], color=:blue)
plot!(p, [0,2],[0,0], color=:blue)
xs = [0,1]; ys = [0, f(1)]
scatter!(p, xs,ys, color=:orange)
plot!(p, xs, ys, color=:orange, linewidth=3)
annotate!(p, [(.75, f(.5)/2, "d = $(round(sqrt(.5^2 + f(.5)^2), digits=2))")])
p


d2(x) = sqrt((0-x)^2 + (0 - f(x))^2)
xstar = find_zero(D(d2), 1)
val = d2(xstar)
numericq(val)


### {{{lhopital_40}}}
imgfile ="figures/fcarc-may2016-fig40-300.gif"
caption = L"""

Image number $40$ from l'Hospital's calculus book (the first calculus book). Among all the cones that can be inscribed in a sphere, determine which one has the largest lateral area. (From http://www.ams.org/samplings/feature-column/fc-2016-05)

"""
ImageFile(imgfile, caption)


using Roots
SA(r,l) = pi * r * l
y(x) = sqrt(1 - x^2)
l(x) = sqrt((x-(-1))^2 +  y(x)^2)
SA(x) = SA(y(x), l(x))
cp = find_zero(D(SA), (-1, 1))
val = SA(cp)
numericq(val)


choices = ["exactly four times",
L"exactly $\pi$ times",
L"about $2.6$ times as big",
"about the same"]
ans = 1
radioq(choices, ans)

