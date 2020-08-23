
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


2 + 2   # use shift-enter to evaluate


2/1, 1/2


2^64


(2 + 1//2) + 0.5


[1,1,2,3,5,8]


x = 2
a_really_long_name = 3
a, b = 1, 2    # multiple assignment
a1 = a2 = 0    # chained assignment, sets a2 and a1 to 0


x + a_really_long_name + a - b


sqrt(10)
sin(pi/3)
log(5, 100)   # log base 5 of 100


log


f(x) = -16x^2 + 100x + 2


a = 1
f(x) = 2*a + x
f(3)   # 2 * 1 + 3
a = 4
f(3)  # now 2 * 4 + 3


area(w, h) = w*h


f(x; m=1, b=0) = m*x + b     # note ";"
f(1)                         # uses m=1, b=0   -> 1 * 1 + 0
f(1, m=10)                   # uses m=10, b=0  -> 10 * 1 + 0
f(1, m=10, b=5)              # uses m=10, b=5  -> 10 * 1 + 5


function f(x)
  y = x^2
  z = y - 3
  z
end


x -> cos(x)^2 - cos(2x)


our_abs(x) = (x < 0) ? -x : x


[x^2 for x in 1:10]


xs = [1,2,3,4,5]
sin.(xs)     # gives back [sin(1), sin(2), sin(3), sin(4), sin(5)]


using CalculusWithJulia


plot(sin, 0, 2pi) # plot a function - by name - over an interval [a,b]


note("""
This is in the form of **the** basic pattern employed: `verb(function_object, arguments...)`. The verb in this example is `plot`, the object `sin`, the arguments `0, 2pi` to specify `[a,b]` domain to plot over.
""")


plot(sin, 0, 2pi)
plot!(cos, 0, 2pi)
plot!(zero, 0, 2pi)


plot( x -> exp(-x/pi) * sin(x), 0, 2pi)


using SymPy   # load package, not needed here as it was done already with CalculusWithJulia
@vars x a b c # no commas here, though `@vars(x,a,b,c)` can be used


p = a*x^2 + b*x + c


p(x=>2), p(x=>2, a=>3, b=>4, c=>1)


plot(64 - (1/2)*32 * x^2, 0, 2)

