
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
#CalculusWithJulia.WeaveSupport.ImageFile("figures/calculator.png", "Screenshot of a calculator provided by the Google search engine.")
nothing


txt = """
<iframe width="560" height="315" src="https://www.youtube.com/embed/sxLdGjV-_yg" frameborder="0" allowfullscreen></iframe>
"""
CalculusWithJulia.WeaveSupport.HTMLoutput(txt)


1 + 2


1 + 2, 2 - 3, 3 * 4, 4 / 5, 5 ^ 6


-1 - 2


6 - -3


warning(L"""

`Julia` only uses one symbol for minus, but web pages may not! Copying
and pasting an expression with a minus sign can lead to hard to
understand errors such as: `invalid character "−"`. There are several
Unicode symbols that look similar to the ASCII minus sign, but are
different. These notes use a different character for the minus sign for
the typeset math (e.g., $1 - \pi$) than for the code within cells
(e.g. `1 - 2`). Thus, copying and pasting the typeset math may not work as expected.

""")


9 / 5 * 20 + 32


2 * 20 + 30


(9/5*20 + 32) - (2 * 20 + 30)


9 / 5 * 5 + 32


(9 / 5 * 5 + 32) - 40


1 + 2 + 3 + 4 + 5


1/2/3/4/5/6


4^3 - 3^4


11^2 + 12^2


1 + 2 - 3 * 4 / 5 ^ 6


(1 + 2) - ((3 * 4) / (5 ^ 6))


(1 + ((2 - 3) * 4)) / (5 ^ 6)


(100 - 98.6) / 98.6 * 100


(101^2 + 10) - (100^2 + 10)


(100^2 + 10) / 100


(4 - 2) / (3 - 1)


(1 + 2) / (3 + 4)


1 + 2 / 3 + 4


alert(L"""

The viniculum also indicates grouping when used with the square root
(the top bar), and complex conjugation. That usage is often clear
enough, but the usage of the viniculum in division often leads to
confusion. The example above is one where the parentheses are often,
erroneously, omitted. However, more confusion can arise when there is
more than one vinicula. An expression such as $a/b/c$ written inline
has no confusion, it is: $(a/b) / c$ as left association is used; but
when written with a pair of vinicula there is often the typographical
convention of a slightly longer vinicula to indicate which is to
be considered first. In the absence of that, then top to bottom association is
often implied.

""")


note("""

In `Julia` many infix operations can be done using a prefix manner. For example `14 + 2` can also be evaluated by `+(14,2)`.

""")


pi


using CalculusWithJulia
e


e^(1/(2*pi))


alert("""In most cases. There are occasional (basically rare) spots where using `pi` by itself causes an eror where `1*pi` will not. The reason is `1*pi` will create a floating point value from the irrational object, `pi`.
""")


1/2pi, 1/2*pi


2pi^2pi


2pi^2pi, 2 * (pi/2) * pi, (2pi)^(2pi), 2 * (pi^(2pi))


using DataFrames
calc = [
L" $+$, $-$, $\times$, $\div$",
L"x^y",
L"\sqrt{}, \sqrt[3]{}",
L"e^x",
L" $\ln$, $\log$",
L"\sin, \cos, \tan, \sec, \csc, \cot",
"In degrees, not radians",
L"\sin^{-1}, \cos^{-1}, \tan^{-1}",
L"n!",
]


julia = [
"`+`, `-`, `*`, `/`",
"`^`",
"`sqrt`, `cbrt`",
"`exp`",
"`log`, `log10`",
"`sin`, `cos`, `tan`, `sec`, `csc`, `cot`",
"`sind`, `cosd`, `tand`, `secd`, `cscd`, `cotd`",
"`asin`, `acos`, `atan`",
"`factorial`"
]

CalculusWithJulia.WeaveSupport.table(DataFrame(Calculator=calc, Julia=julia))


sqrt(4), sqrt(5)


exp(2), log(10), sqrt(100), 10^(1/2)


note("""

Parentheses have many roles. We've just seen that parentheses may be
used for grouping, and now we see they are used to indicate a function
is being called. These are familiar from their parallel usage in
traditional math notation. In `Julia`, a third usage is common, the
making of a "tuple," or a container of different objects, for example
`(1, sqrt(2), pi)`. In these notes, the output of multiple commands separated by commas is a printed tuple.

""")


log(e), log(2, e), log(10, e), log(e, 2)


sqrt(11^2 + 12^2)


sqrt((1/4 * (1 - 1/4)) / 10)


sqrt((5 - -3)^2 + (6 - -4)^2)


1 / (1/10 + 1/20)


sqrt(-1)


factorial(1000)


2^62, 2^63


alert("""

In a turnaround from a classic blues song, we can think of `Julia` as
built for speed, not for comfort. All of these errors above could be
worked around so that the end user doesn't see them. However, this
would require slowing things down, either through checking of
operations or allowing different types of outputs for similar type of
inputs. These are tradeoffs that are not made for performance
reasons. For the most part, the tradeoffs don't get in the way, but
learning where to be careful takes some time. Error messages
often suggest a proper alternative.

""")


(3987^12 + 4365^12)^(1/12)


(3987.0^12 + 4365.0^12)^(1/12)


(3987.0^12 + 4365.0^12)^(1/12) - 4472


val = 22/7
numericq(val)


val = sqrt(220)
numericq(val)


val = 2^8
numericq(val)


val = (9-5*(3-4)) / (6-2)
numericq(val)


val = (.25 - .2)^2/((1/4)^2 + (1/3)^2);
numericq(val)


val = sum((1/2).^(0:4));
numericq(val)


val = (3 - 2^2)/(4 - 2*3);
numericq(val)


val = (1/2)*32*3^2 + 100*3 - 20;
numericq(val)


choices = [
q"(3 - 2)/ 4 - 1",
q"3 - 2 / (4 - 1)",
q"(3 - 2) / (4 - 1)"]
ans = 3
radioq(choices, ans)


choices = [
q"3 * 2 / 4",
q"(3 * 2) / 4"
]
ans = 1
radioq(choices, ans)


choices = [
q"2 ^ 4 - 2",
q"(2 ^ 4) - 2",
q"2 ^ (4 - 2)"]
ans = 3
radioq(choices, ans)


val = 11532 - 9653
numericq(val)


choices = [
q"1 / (2 / 3 / 4 / 5 / 6)",
q"1 / 2 * 3 / 4  * 5 / 6",
q"1 /(2 * 3 * 4 * 5 * 6)"]
ans = 3
radioq(choices, ans)


choices = [
q"2 - 3 - 4",
q"(2 - 3) - 4",
q"2 - (3 - 4)"
];
ans = 3;
radioq(choices, ans)


choices = [
q"2 - 3 * 4",
q"(2 - 3) * 4",
q"2 - (3 * 4)"
];
ans = 2;
radioq(choices, ans)


choices = [
q"-1^2",
q"(-1)^2",
q"-(1^2)"
];
ans = 2;
radioq(choices, ans)


val = sin(pi/10)
numericq(val)


val = sind(52)
numericq(val)


yesnoq(false)


numericq(round(3.5))


numericq(sqrt(32-12))


choices = [
L"exp(\pi)",
L"\pi^exp(1)"
];
ans = exp(pi) - pi^exp(1) > 0 ? 1 : 2;
radioq(choices, ans)


x = 3;
ans = x - sin(x)/cos(x);
numericq(pi - ans)


val = factorial(10)
numericq(val)


choices = [q"4", q"-4"]
ans = 2
radioq(choices, ans)


ImageFile("figures/order_operations_pop_mech.png")


val = 8/2*(2+2)
numericq(val)


8÷2(2+2)


yesnoq(false)


choices = [
"The precedence of numeric literal coefficients used for implicit multiplication is higher than other binary operators such as multiplication (`*`), and division (`/`, `\`, and `//`)",
"Of course it is correct."
]
ans=1
radioq(choices, ans)

