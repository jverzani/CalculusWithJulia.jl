
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


a0, h, n = 200, -10, 20
a0 + n * h


a0, h, n = -8, 10, 15
a0 + n * h


1:10


collect(1:10)


collect(1:7:50)


collect(100:-7:1)


a, b, n = -1, 1, 9
h = (b-a)/(n-1)
collect(a:h:b)


function evenly_spaced(a, b, n)
    h = (b-a)/(n-1)
    collect(a:h:b)
end


evenly_spaced(0, 2pi, 5)


evenly_spaced(1/5, 3/5, 3)


1/5, 1/5 + 1*1/5, 1/5 + 2*1/5


xs = range(-1, 1, length=9)


collect(xs)


note("""
For `Julia` version `1.0` the stop value is also specified with a keyword, as in `range(-1, stop=1, length=9)`. An adjustment will need to be made if that version is used.
""")


filter(iseven, 0:25)


isprime(n) =  all(!iszero(rem(n, i)) for i in 2:floor(Int,sqrt(n)))
filter(isprime, 100:200)


x = [0, 2, 4, 6, 8, 10]


[2k for k in 0:50]


[7k for k in 1:10]


[x^2 for x in 1:10]


[2^i for i in 1:10]


[1/2^i for i in 1:10]


sum([2^i for i in 1:10])


sum(2^i for i in 1:10)


sum(p for p in 1:100 if isprime(p))


sum(k for k in 1:100 if rem(k,7) == 0)  ## add multiples of 7


ways = [(q, d, n, p) for q = 0:25:100 for d = 0:10:(100 - q) for n = 0:5:(100 - q - d) for p = (100 - q - d - n)]
length(ways)


ways[1:3]


[(q, d, n, p) for q = 0:25:100 for d = 0:10:(100 - q) for n = 0:5:(100 - q - d) for p = (100 - q - d - n) if q > d > n > p]


rand()


rand()


rand(10)


alert(L"""
The documentation for `rand` shows that the value is in $[0,1)$, but in practice $0$ doesn't come up with any frequency - about 1 out of every $10^{19}$ numbers - so we say $(0,1)$.
""")


choices = [
q"1:99",
q"1:3:99",
q"1:2:99"
]
ans = 3
radioq(choices, ans)


choices = [q"2:7:72", q"2:9:72", q"2:72", q"72:-7:2"]
ans = 1
radioq(choices, ans)


val = length(collect(0:19:1000))
numericq(val)


choices = [
"`10:-1:1`",
"`10:1`",
"`1:-1:10`",
"`1:10`"
]
ans = 1
radioq(choices, ans)


val = (1:4:7)[end]
numericq(val)


yesnoq(true)


yesnoq(true)


choices = ["It is just random",
"Addition happens prior to the use of `:` so this is like `1:(4+2):5`",
"It gives the correct answer, a generator for the vector `[3,5,7,9]`"
]
ans = 2
radioq(choices, ans)


choices = ["as `a:(b-1)`", "as `(a:b) - 1`, which is `(a-1):(b-1)`"]
ans = 1
radioq(choices, ans)


choices = [q"[10^i for i in 1:6]", q"[10^i for i in [10, 100, 1000]]", q"[i^10 for i in [1:6]]"]
ans = 1
radioq(choices, ans)


choices = [
q"[10^-i for i in 1:7]",
q"[(1/10)^i for i in 1:7]",
q"[i^(1/10) for i in 1:7]"]
ans = 2
radioq(choices, ans)


choices = [q"[x^3 - 2x + 3 for i in -5:5]", q"[x^3 - 2x + 3 for x in -(5:5)]", q"[x^3 - 2x + 3 for x in -5:5]"]
ans = 3
radioq(choices, ans)


val = length(filter(isprime, 1100:1200))
numericq(val)


n1 = length(filter(isprime, 1000:2000))
n2 = length(filter(isprime, 11_000:12_000))
booleanq(n1 > n2, labels=[q"1000:2000", q"11000:12000"])


val = sum(1:2:99)
numericq(val)


booleanq(true, labels=["Yes, this is true", "No, this is false"])


as = [2^i for i in 0:10]
val = sum(as)
numericq(val)


yesnoq(true)


val = prod(1:2:19)
numericq(val)

