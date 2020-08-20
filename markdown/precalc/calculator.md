# Replacing the calculator with a computer


Let us consider a basic calculator with buttons to add, subtract,
multiply, divide, and take square roots. Using such a simple thing is
certainly familiar for any reader of these notes. Indeed, a
familiarity with a *graphing* calculator is expected. `Julia` makes
these familiar tasks just as easy, offering numerous conveniences along the
way. In this section we describe how.

The following image is the calculator that Google presents upon searching for "calculator."




![Screenshot of a calculator provided by the Google search engine](figures/calculator.png)


This calculator should have a familiar appearance with a keypad of
numbers, a set of buttons for arithmetic operations, a set of buttons
for some common mathematical functions, a degree/radian switch, and
buttons for interacting with the calculator: `Ans`, `AC` (also `CE`),
and `=`.

The goal here is to see the counterparts within `Julia` to these features.


----

For an illustration of *really* basic calculator, have some fun watching this video:

````
<div><iframe width="560" height="315" src="https://www.youtube.com/embed/sx
LdGjV-_yg" frameborder="0" allowfullscreen></iframe>
</div>
````





## Operations

Performing a simple computation on the calculator typically involves
hitting buttons in a sequence, such as "1", "+", "2", "`=`" to compute
3 from adding 1 + 2. In `Julia`, the process is not so
different. Instead of pressing buttons, the various values are
typed in. So, we would have:

````julia

1 + 2
````


````
3
````





Sending an expression to `Julia`'s interpreter - the equivalent of
pressing the "`=`" key on a calculator - is done at the command line
by pressing the `Enter` or `Return` key, and in `IJulia` using the
"play" icon, or the keyboard shortcut `Shift-Enter`. If the current
expression is complete, then `Julia` evaluates it and shows any
output.  If the expression is not complete, `Julia`'s response depends
on how it is being called. Within `IJulia`, a message about
"premature" end of input is given. If the expression raises an error,
this will be noted.


The basic arithmetic operations on a calculator are "+", "-", "×",
"÷", and "$xʸ$". These have parallels in `Julia` through the *binary*
operators: `+`, `-`, `*`, `/`, and `^`:

````julia

1 + 2, 2 - 3, 3 * 4, 4 / 5, 5 ^ 6
````


````
(3, -1, 12, 0.8, 15625)
````





On some calculators, there is a distinction between minus signs - the
binary minus sign and the unary minus sign to create values such as
$-1$.

In `Julia`, the same symbol, "`-`", is used for each:

````julia

-1 - 2
````


````
-3
````





An expression like $6 - -3$, subtracting minus three from six, must be handled with some care.  With the
Google calculator, the expression must be entered with accompanying
parentheses: $6 -(-3)$. In `Julia`, parentheses may be used, but are not needed. However, if omitted, a
space is required between the two minus signs:

````julia

6 - -3
````


````
9
````





(If no space is included, the value "`--`" is parsed like a different, undefined, operation.)


````
CalculusWithJulia.WeaveSupport.Alert(L"
`Julia` only uses one symbol for minus, but web pages may not! Copying
and pasting an expression with a minus sign can lead to hard to
understand errors such as: `invalid character \"−\"`. There are several
Unicode symbols that look similar to the ASCII minus sign, but are
different. These notes use a different character for the minus sign for
the typeset math (e.g., $1 - \pi$) than for the code within cells
(e.g. `1 - 2`). Thus, copying and pasting the typeset math may not work as 
expected.

", Dict{Any,Any}(:class => "warning"))
````





### Examples

##### Example

For everyday temperatures, the conversion from Celsius to Fahrenheit
($9/5 C + 32$) is well approximated by simply doubling and
adding $30$. Compare these values for an average room temperature, $C=20$, and for a relatively chilly day, $C=5$:

For $C=20$:

````julia

9 / 5 * 20 + 32
````


````
68.0
````





The easy to compute approximate value is:

````julia

2 * 20 + 30
````


````
70
````





The difference is:

````julia

(9/5*20 + 32) - (2 * 20 + 30)
````


````
-2.0
````





For $C=5$, we have the actual value of:

````julia

9 / 5 * 5 + 32
````


````
41.0
````





and the easy to compute value is simply $40 = 10 + 30$. The difference is

````julia

(9 / 5 * 5 + 32) - 40
````


````
1.0
````






##### Example

Add the numbers $1 + 2 + 3 + 4 + 5$.

````julia

1 + 2 + 3 + 4 + 5
````


````
15
````





##### Example

How small is $1/2/3/4/5/6$? It is about $14/10,000$, as this will show:

````julia

1/2/3/4/5/6
````


````
0.001388888888888889
````





##### Example

Which is bigger $4^3$ or $3^4$? We can check by computing their difference:

````julia

4^3 - 3^4
````


````
-17
````





So $3^4$ is bigger.

##### Example

A right triangle has sides $a=11$ and $b=12$. Find the length of the
  hypotenuse squared. As $c^2 = a^2 + b^2$ we have:

````julia

11^2 + 12^2
````


````
265
````





## Order of operations

The calculator must use some rules to define how it will evaluate its instructions when two or more operations are involved. We know mathematically, that when $1 + 2 \cdot 3$ is to be evaluated the multiplication is  done first then the addition.

With the Google Calculator, typing `1 + 2 x 3 =` will give the value
$7$, but *if* we evaluate the `+` sign first, via `1`  `+` `2` `=` `x` `3` `=` the
answer will be 9, as that will force the addition of `1+2` before
multiplying. The more traditional way of performing that calculation
is to use *parentheses* to force an evaluation. That is,
`(1 + 2) * 3 =` will produce `9` (though one must type it in, and not use a mouse
to enter). Except for the most primitive of calculators, there are
dedicated buttons for parentheses to group expressions.

In `Julia`, the entire expression is typed in before being evaluated,
so the usual conventions of mathematics related to the order of
operations may be used. These are colloquially summarized by the
acronym [PEMDAS](http://en.wikipedia.org/wiki/Order_of_operations).

> **PEMDAS**. This acronym stands for Parentheses, Exponents,
> Multiplication, Division, Addition, Subtraction. The order indicates
> which operation has higher precedence, or should happen first. This
> isn't exactly the case, as "M" and "D" have the same precedence, as
> do "A" and "S". In the case of two operations with equal precedence,
> *associativity* is used to decide which to do. For the operations
> `+`, `-`, `*`, `/` the associativity is left to right, as in the
> left one is done first, then the right. However, `^` has right
> associativity, so `4^3^2` is `4^(3^2)` and not `(4^3)^2`. (Be warned
> that some calculators - and spread sheets, such as Excel - will
> treat this expression with left associativity.)


With rules of precedence, an expression like the following has a
clear interpretation to `Julia` without the need for parentheses:

````julia

1 + 2 - 3 * 4 / 5 ^ 6
````


````
2.999232
````





Working through PEMDAS we see that `^` is first, then `*` and then `/`
(this due to associativity and `*` being the leftmost expression of
the two) and finally `+` and then `-`, again by associativity
rules. So we should have the same value with:

````julia

(1 + 2) - ((3 * 4) / (5 ^ 6))
````


````
2.999232
````





If different parentheses are used, the answer will likely be different. For example, the following forces the operations to be `-`, then `*`, then `+`. The result of that is then divided by `5^6`:

````julia

(1 + ((2 - 3) * 4)) / (5 ^ 6)
````


````
-0.000192
````






### Examples

##### Example

The percentage error in $x$ if $y$ is the correct value is $(x-y)/y \cdot 100$. Compute this if $x=100$ and $y=98.6$.

````julia

(100 - 98.6) / 98.6 * 100
````


````
1.4198782961460505
````





##### Example

The marginal cost of producing one unit can be computed by
  finding the cost for $n+1$ units and subtracting the cost for
  $n$ units. If the cost of $n$ units is $n^2 + 10$, find the marginal cost when $n=100$.

````julia

(101^2 + 10) - (100^2 + 10)
````


````
201
````





##### Example

The average cost per unit is the total cost divided by the number of units. Again, if the cost of $n$ units is $n^2 + 10$, find the average cost for $n=100$ units.

````julia

(100^2 + 10) / 100
````


````
100.1
````





##### Example

The slope of the line through two points is $m=(y_1 - y_0) / (x_1 - x_0)$. For the two points $(1,2)$ and $(3,4)$ find the slope of the line through them.

````julia

(4 - 2) / (3 - 1)
````


````
1.0
````





### Two ways to write division - and they are not the same

The expression $a + b / c + d$ is equivalent to $a + (b/c) + d$ due to the order of operations. It will generally have a different answer than $(a + b) / (c + d)$.

How would the following be expressed, were it written inline:

$$~
\frac{1 + 2}{3 + 4}?
~$$

It would have to be computed through $(1 + 2) / (3 + 4)$.  This is
because unlike `/`, the implied order of operation in the mathematical
notation with the *horizontal division symbol* (the
[vinicula](http://tinyurl.com/y9tj6udl)) is to compute the top and the
bottom and then divide. That is, the vinicula is a grouping notation
like parentheses, only implicitly so. Thus the above expression really
represents the more verbose:


$$~
\frac{(1 + 2)}{(3 + 4)}.
~$$

Which  lends itself readily to the translation:

````julia

(1 + 2) / (3 + 4)
````


````
0.42857142857142855
````





To emphasize, this is not the same as the value without the parentheses:

````julia

1 + 2 / 3 + 4
````


````
5.666666666666666
````



````
CalculusWithJulia.WeaveSupport.Alert(L"
The viniculum also indicates grouping when used with the square root
(the top bar), and complex conjugation. That usage is often clear
enough, but the usage of the viniculum in division often leads to
confusion. The example above is one where the parentheses are often,
erroneously, omitted. However, more confusion can arise when there is
more than one vinicula. An expression such as $a/b/c$ written inline
has no confusion, it is: $(a/b) / c$ as left association is used; but
when written with a pair of vinicula there is often the typographical
convention of a slightly longer vinicula to indicate which is to
be considered first. In the absence of that, then top to bottom association
 is
often implied.

", Dict{Any,Any}())
````





### Infix, postfix, and prefix notation

The factorial button on the Google Button creates an expression like
`14!` that is then evaluated. The operator, `!`, appears after the
value (`14`) that it is applied to. This is called *postfix
notation*. When a unary minus sign is used, as in `-14`, the minus
sign occurs before the value it operates on. This uses *prefix
notation*. These concepts can be extended to binary operations, where
a third possibility is provided: *infix notation*, where the operator
is between the two values. The infix notation is common for our
familiar mathematical operations. We write `14 + 2` and not `+ 14 2`
or `14 2 +`. (Though if we had an old reverse-Polish notation
calculator, we would enter `14 2 +`!) In `Julia`, there are several
infix operators, such as `+`, `-`, ... and others that we may be
unfamiliar with. These mirror the familiar notation from most math
texts.


````
CalculusWithJulia.WeaveSupport.Alert("\nIn `Julia` many infix operations ca
n be done using a prefix manner. For example `14 + 2` can also be evaluated
 by `+(14,2)`.\n\n", Dict{Any,Any}(:class => "info"))
````





## Constants

The Google calculator has two built in constants, `e` and `π`. Julia provides these as well, though not quite as easily. First,  `π` is just `pi`:

````julia

pi
````


````
π = 3.1415926535897...
````





Whereas, `e` is is not simply the character `e`, but *rather* a [unicode](../unicode.html) character typed in as `\euler[tab]`.

However, when the accompanying package, `CalculusWithJulia`, is loaded, the character `e` will refer to the Euler constant (as it brings in the `Base.MathConstants` package):

````julia

using CalculusWithJulia
e
````


````
ℯ = 2.7182818284590...
````





In the sequel, we will just use `e` for this constant (though more commonly the `exp` function), with the reminder that base `Julia` alone does not reserve this symbol.

Mathematically these are irrational values with decimal expansions that do not repeat. `Julia` represents these values internally with additional accuracy beyond that which is displayed. Math constants can be used as though they were numbers, such is done with this expression:

````julia

e^(1/(2*pi))
````


````
1.17251960642002
````



````
CalculusWithJulia.WeaveSupport.Alert("In most cases. There are occasional (
basically rare) spots where using `pi` by itself causes an eror where `1*pi
` will not. The reason is `1*pi` will create a floating point value from th
e irrational object, `pi`.\n", Dict{Any,Any}())
````






### Numeric literals

For some special cases, Julia implements *multiplication* without a
multiplication symbol. This is when the value on the left is a number,
as in `2pi`, which has an equivalent value to `2*pi`. *However* the
two are not equivalent, in that multiplication with *numeric literals*
does not have the same precedence as regular multiplication - it is
higher. This has practical importance when used in division or
powers. For instance, these two are **not** the same:

````julia

1/2pi, 1/2*pi
````


````
(0.15915494309189535, 1.5707963267948966)
````





Why? Because the first `2pi` is performed before division, as multiplication with numeric literals  has higher precedence than regular multiplication, which is at the same level as division.

To confuse things even more, consider

````julia

2pi^2pi
````


````
2658.978166443007
````





Is this the same as `2 * (pi^2) * pi` or `(2pi)^(2pi)`?. The former would be the case is powers had higher precedence than literal multiplication, the latter would be the case were it the reverse. In fact, the correct answer is `2 * (pi^(2*pi))`:

````julia

2pi^2pi, 2 * (pi/2) * pi, (2pi)^(2pi), 2 * (pi^(2pi))
````


````
(2658.978166443007, 9.869604401089358, 103540.92043427199, 2658.97816644300
7)
````





This follows usual mathematical convention, but is a source of potential confusion. It can be best to be explicit about multiplication, save for the simplest of cases.


## Functions

On the Google calculator, the square root button has a single purpose: for the current value find a square root if possible, and if not signal an error (such as what happens if the value is negative). For more general powers, the $x^y$ key can be used.

In `Julia`, functions are used to perform the actions that a
specialized button may do on the calculator. `Julia` provides many
standard mathematical functions - more than there could be buttons on
a calculator - and allows the user to easily define their own
functions. For example, `Julia` provides the same set of functions as on
Google's calculator, though with different names. For logarithms,
$\ln$ becomes `log` and $\log$ is `log10` (computer programs almost
exclusively reserve `log` for the natural log); for factorials, $x!$,
there is `factorial`; for powers $\sqrt{}$ becomes `sqrt`, $EXP$
becomes `exp`, and $x^y$ is computed with the infix operator `^`. For the trigonometric
functions, the basic names are similar: `sin`, `cos`, `tan`. These
expect radians. For angles in degrees, the convenience functions
`sind`, `cosd`, and `tand` are provided. On the calculator, inverse
functions like $\sin^{-1}(x)$ are done by combining $Inv$ with
$\sin$. With `Julia`, the function name is `asin`, an abbreviation for
"arcsine." (Which is a good thing, as the notation using a power of
$-1$ is often a source of confusion and is not supported by `Julia`.) Similarly, there
are `asind`, `acos`, `acosd`, `atan`, and `atand` functions available
to the `Julia` user.

The following table summarizes the above:

````
CalculusWithJulia.WeaveSupport.Table(9×2 DataFrame. Omitted printing of 1 c
olumns
│ Row │ Calculator                                 │
│     │ AbstractString                             │
├─────┼────────────────────────────────────────────┤
│ 1   │  $+$, $-$, $\\times$, $\\div$              │
│ 2   │ $x^y$                                      │
│ 3   │ $\\sqrt{}, \\sqrt[3]{}$                    │
│ 4   │ $e^x$                                      │
│ 5   │  $\\ln$, $\\log$                           │
│ 6   │ $\\sin, \\cos, \\tan, \\sec, \\csc, \\cot$ │
│ 7   │ In degrees, not radians                    │
│ 8   │ $\\sin^{-1}, \\cos^{-1}, \\tan^{-1}$       │
│ 9   │ $n!$                                       │)
````








Using a function is very straightforward. A function is called using parentheses, in a manner visually similar to how a function is called mathematically. So if we consider the `sqrt` function, we have:

````julia

sqrt(4), sqrt(5)
````


````
(2.0, 2.23606797749979)
````





The function is referred to by name (`sqrt`) and called with parentheses. Any arguments are passed into the function using commas to separate values, should there be more than one. When there are numerous values for a function, the arguments may need to be given in a specific order or may possibly be specified with *keywords*.

Some more examples:

````julia

exp(2), log(10), sqrt(100), 10^(1/2)
````


````
(7.38905609893065, 2.302585092994046, 10.0, 3.1622776601683795)
````



````
CalculusWithJulia.WeaveSupport.Alert("\nParentheses have many roles. We've 
just seen that parentheses may be\nused for grouping, and now we see they a
re used to indicate a function\nis being called. These are familiar from th
eir parallel usage in\ntraditional math notation. In `Julia`, a third usage
 is common, the\nmaking of a \"tuple,\" or a container of different objects
, for example\n`(1, sqrt(2), pi)`. In these notes, the output of multiple c
ommands separated by commas is a printed tuple.\n\n", Dict{Any,Any}(:class 
=> "info"))
````






<script>
// XXX This seems to be no longer needed, as 2^(-1) is defined when -1 is a numeric literal
//
// `Julia`'s design embraces *polymorphism*, a term to indicate that the
// same function may have different implementations and the one
// ultimately called depends on the number and types of the
// arguments. Polymorphism is also commonly referred to as *multiple
// dispatch*. This is a great convenience for the user who only needs to
// remember one function name for related uses, that may differ only in
// technicalities.  For example, there are about $200$ methods
// implemented for the generic function `+`. This may be expected from
// mathematical analogy: the details of the operation of addition are
// different for integers, than rational numbers, than polynomials,
// though all can be added.
//
//
//
// The power operator, `^`, provides a concrete example. For integer
// bases there is a different implementation than there is for real
// bases. When the base is an integer, the answer may or may not be an
// integer:
//
// ```julia;
// 2^(-1), 2^2
// ```
//
// However, for floating point bases the answer is always a floating point number
//
// ```julia;
// 2.0^(-1), 2.0^2
// ```
</script>

### Multiple arguments

For the logarithm, we mentioned that `log` is the natural log and
`log10` implements the logarithm base 10. As well there is
`log2`. However, in general there is no `logb` for any base
`b`. Instead, the basic `log` function can take *two* arguments. When it
does, the first is the base, and the second the value to take the
logarithm of. This avoids forcing the user to remember that $\log_b(x)
= \log(x)/\log(b)$.

So we have all these different, but related, uses to find logarithms:

````julia

log(e), log(2, e), log(10, e), log(e, 2)
````


````
(1, 1.4426950408889634, 0.43429448190325176, 0.6931471805599453)
````





In `Julia`, the "generic" function `log` not only has different implementations for
different types of arguments (real or complex), but also has a
different implementation depending on the number of arguments.

### Examples


##### Example

A right triangle has sides $a=11$ and $b=12$. Find the length of the hypotenuse. As $c^2 = a^2 + b^2$ we have:

````julia

sqrt(11^2 + 12^2)
````


````
16.278820596099706
````





##### Example

A formula from statistics to compute the variance of binomial random variable for parameters $p$ and $n$
is $\sqrt{p (1-p)/10}$. Compute this value for $p=1/4$ and $n=10$.

````julia

sqrt((1/4 * (1 - 1/4)) / 10)
````


````
0.13693063937629152
````





##### Example

Find the distance between the points $(-3, -4)$ and $(5,6)$. Using the distance formula $\sqrt{(x_1-x_0)^2+(y_1-y_0)^2}$, we have:

````julia

sqrt((5 - -3)^2 + (6 - -4)^2)
````


````
12.806248474865697
````






##### Example

The formula to compute the resistance of two resistors in parallel is
given by: $1/(1/r_1 + 1/r_2)$. Suppose the resistance is $10$ in one resistor
and $20$ in the other. What is the resistance in parallel?

````julia

1 / (1/10 + 1/20)
````


````
6.666666666666666
````





## Errors

Not all computations on a calculator are valid. For example, the Google calculator will display `Error` as the output of $0/0$ or $\sqrt{-1}$. These are also errors mathematically, though the second is not if the complex numbers are considered.

In `Julia`, there is a richer set of error types. The value `0/0` will in fact not be an error, but rather a value `NaN`. This is a special floating point value indicating "not a number" and is the result for various operations.  The output of $\sqrt{-1}$ (computed via `sqrt(-1)`) will indicate a domain error:

````julia

sqrt(-1)
````


````
Error: DomainError with -1.0:
sqrt will only return a complex result if called with a complex argument. T
ry sqrt(Complex(x)).
````





For integer or real-valued inputs, the `sqrt` function expects non-negative values, so that the output will always be a real number.

There are other types of errors. Overflow is a common one on most
calculators. The value of $1000!$ is actually *very* large (over 2500
digits large). On the Google calculator it returns `Infinity`, a
slight stretch. For `factorial(1000)` `Julia` returns an
`OverflowError`. This means that the answer is too large to be
represented as a regular integer.

````julia

factorial(1000)
````


````
Error: OverflowError: 1000 is too large to look up in the table; consider u
sing `factorial(big(1000))` instead
````





How `Julia` handles overflow is a study in tradeoffs. For integer operations
that demand high performance, `Julia` does not check for overflow. So,
for example, if we are not careful strange answers can be
had. Consider the difference here between powers of 2:

````julia

2^62, 2^63
````


````
(4611686018427387904, -9223372036854775808)
````





On a machine with $64$-bit integers, the first of these two values is
correct, the second, clearly wrong, as the answer given is
negative. This is due to overflow. The cost of checking is considered
too high, so no error is thrown. The user is expected to have a sense
that they need to be careful when their values are quite large. (Or
the user can use floating point numbers, which though not exact, can represent much
bigger values.)


````
CalculusWithJulia.WeaveSupport.Alert("\nIn a turnaround from a classic blue
s song, we can think of `Julia` as\nbuilt for speed, not for comfort. All o
f these errors above could be\nworked around so that the end user doesn't s
ee them. However, this\nwould require slowing things down, either through c
hecking of\noperations or allowing different types of outputs for similar t
ype of\ninputs. These are tradeoffs that are not made for performance\nreas
ons. For the most part, the tradeoffs don't get in the way, but\nlearning w
here to be careful takes some time. Error messages\noften suggest a proper 
alternative.\n\n", Dict{Any,Any}())
````





##### Example

Did Homer Simpson disprove [Fermat's Theorem](http://www.npr.org/sections/krulwich/2014/05/08/310818693/did-homer-simpson-actually-solve-fermat-s-last-theorem-take-a-look)?

Fermat's theorem states there are no solutions over the integers to $a^n + b^n = c^n$ when $n > 2$. In the photo accompanying the linked article, we see:

$$~
3987^{12} + 4365^{12} - 4472^{12}.
~$$

If you were to do this on most calculators, the answer would be
$0$. Were this true, it would show that there is at least one solution
to $a^{12} + b^{12} = c^{12}$ over the integers - hence Fermat would be wrong. So is it $0$?

Well, let's try something with `Julia` to see. Being clever, we check if $(3987^{12} + 4365^{12})^{1/12} = 4472$:

````julia

(3987^12 + 4365^12)^(1/12)
````


````
28.663217591132355
````





Not even close. Case closed. But wait? This number to be found must be *at least* as big as $3987$ and we got $28$. Doh! Something can't be right. Well, maybe integer powers are being an issue. (The largest $64$-bit integer is less than $10^{19}$ and we can see that $(4\cdot 10^3)^{12}$ is bigger than $10^{36})$. Trying again using floating point values for the base, we see:


````julia

(3987.0^12 + 4365.0^12)^(1/12)
````


````
4472.000000007058
````





Ahh, we see something really close to $4472$, but not exactly. Why do
most calculators get this last part wrong? It isn't that they don't
use floating point, but rather the difference between the two numbers:

````julia

(3987.0^12 + 4365.0^12)^(1/12) - 4472
````


````
7.057678885757923e-9
````





is less than $10^{-8}$ so on display with $8$ digits may be rounded to $0$.

Moral: with `Julia` and with calculators, we still have to be mindful not to blindly accept an answer.






## Questions

###### Question


Compute $22/7$ with `Julia`.

````
CalculusWithJulia.WeaveSupport.Numericq(3.142857142857143, 0.001, "", "[3.1
4186, 3.14386]", 3.141857142857143, 3.1438571428571427, "", "")
````





###### Question


Compute $\sqrt{220}$ with `Julia`.

````
CalculusWithJulia.WeaveSupport.Numericq(14.832396974191326, 0.001, "", "[14
.8314, 14.8334]", 14.831396974191327, 14.833396974191325, "", "")
````





###### Question


Compute $2^8$ with `Julia`.

````
CalculusWithJulia.WeaveSupport.Numericq(256, 0, "", "[256.0, 256.0]", 256, 
256, "", "")
````





###### Question

Compute the value of

$$~
\frac{9 - 5 \cdot (3-4)}{6 - 2}.
~$$

````
CalculusWithJulia.WeaveSupport.Numericq(3.5, 0.001, "", "[3.499, 3.501]", 3
.499, 3.501, "", "")
````





###### Question


Compute the following using `Julia`:

$$~
\frac{(.25 - .2)^2}{(1/4)^2 + (1/3)^2}
~$$

````
CalculusWithJulia.WeaveSupport.Numericq(0.014399999999999993, 0.001, "", "[
0.0134, 0.0154]", 0.013399999999999992, 0.015399999999999994, "", "")
````





###### Question


Compute the decimal representation of the following using `Julia`:

$$~
1 + \frac{1}{2} + \frac{1}{2^2} + \frac{1}{2^3} + \frac{1}{2^4}
~$$

````
CalculusWithJulia.WeaveSupport.Numericq(1.9375, 0.001, "", "[1.9365, 1.9385
]", 1.9365, 1.9385, "", "")
````






###### Question

Compute the following using `Julia`:

$$~
\frac{3 - 2^2}{4 - 2\cdot3}
~$$

````
CalculusWithJulia.WeaveSupport.Numericq(0.5, 0.001, "", "[0.499, 0.501]", 0
.499, 0.501, "", "")
````





###### Question

Compute the following using `Julia`:

$$~
(1/2) \cdot 32 \cdot 3^2 + 100 \cdot 3 - 20
~$$

````
CalculusWithJulia.WeaveSupport.Numericq(424.0, 0.001, "", "[423.999, 424.00
1]", 423.999, 424.001, "", "")
````






###### Question


Wich of the following is a valid `Julia` expression for

$$~
\frac{3 - 2}{4 - 1}
~$$

that uses the least number of parentheses?

````
CalculusWithJulia.WeaveSupport.Radioq(["`(3 - 2)/ 4 - 1`", "`(3 - 2) / (4 -
 1)`", "`3 - 2 / (4 - 1)`"], 2, "", nothing, [1, 2, 3], ["`(3 - 2)/ 4 - 1`"
, "`(3 - 2) / (4 - 1)`", "`3 - 2 / (4 - 1)`"], "", false)
````





###### Question


Wich of the following is a valid `Julia` expression for

$$~
\frac{3\cdot2}{4}
~$$

that uses the least number of parentheses?

````
CalculusWithJulia.WeaveSupport.Radioq(["`3 * 2 / 4`", "`(3 * 2) / 4`"], 1, 
"", nothing, [1, 2], ["`3 * 2 / 4`", "`(3 * 2) / 4`"], "", false)
````





###### Question


Which of the following is a valid `Julia` expression for

$$~
2^{4 - 2}
~$$

that uses the least number of parentheses?

````
CalculusWithJulia.WeaveSupport.Radioq(["`(2 ^ 4) - 2`", "`2 ^ (4 - 2)`", "`
2 ^ 4 - 2`"], 2, "", nothing, [1, 2, 3], ["`(2 ^ 4) - 2`", "`2 ^ (4 - 2)`",
 "`2 ^ 4 - 2`"], "", false)
````





###### Question

In the U.S. version of the Office, the opening credits include a calculator calculation. The key sequence shown is `9653 +` which produces `11532`.  What value was added to?

````
CalculusWithJulia.WeaveSupport.Numericq(1879, 0, "", "[1879.0, 1879.0]", 18
79, 1879, "", "")
````





###### Question


We saw that `1 / 2 / 3 / 4 / 5 / 6` is about $14$ divided by $10,000$. But what would be a more familiar expression representing it:



````
CalculusWithJulia.WeaveSupport.Radioq(["`1 / (2 / 3 / 4 / 5 / 6)`", "`1 / 2
 * 3 / 4  * 5 / 6`", "`1 /(2 * 3 * 4 * 5 * 6)`"], 3, "", nothing, [1, 2, 3]
, ["`1 / (2 / 3 / 4 / 5 / 6)`", "`1 / 2 * 3 / 4  * 5 / 6`", "`1 /(2 * 3 * 4
 * 5 * 6)`"], "", false)
````





###### Question


One of these three expressions will produce a different answer, select
that one:

````
CalculusWithJulia.WeaveSupport.Radioq(["`(2 - 3) - 4`", "`2 - 3 - 4`", "`2 
- (3 - 4)`"], 3, "", nothing, [1, 2, 3], ["`(2 - 3) - 4`", "`2 - 3 - 4`", "
`2 - (3 - 4)`"], "", false)
````






###### Question

One of these three expressions will produce a different answer, select
that one:

````
CalculusWithJulia.WeaveSupport.Radioq(["`2 - (3 * 4)`", "`(2 - 3) * 4`", "`
2 - 3 * 4`"], 2, "", nothing, [1, 2, 3], ["`2 - (3 * 4)`", "`(2 - 3) * 4`",
 "`2 - 3 * 4`"], "", false)
````






###### Question

One of these three expressions will produce a different answer, select
that one:


````
CalculusWithJulia.WeaveSupport.Radioq(["`-1^2`", "`(-1)^2`", "`-(1^2)`"], 2
, "", nothing, [1, 2, 3], ["`-1^2`", "`(-1)^2`", "`-(1^2)`"], "", false)
````






###### Question

What is the value of $\sin(\pi/10)$?

````
CalculusWithJulia.WeaveSupport.Numericq(0.3090169943749474, 0.001, "", "[0.
30802, 0.31002]", 0.3080169943749474, 0.3100169943749474, "", "")
````




###### Question


What is the value of $\sin(52^\circ)$?

````
CalculusWithJulia.WeaveSupport.Numericq(0.788010753606722, 0.001, "", "[0.7
8701, 0.78901]", 0.787010753606722, 0.789010753606722, "", "")
````





###### Question


Is $\sin^{-1}(\sin(3\pi/2))$ equal to $3\pi/2$? (The "arc" functions
do no use power notation, but instead a prefix of `a`.)

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 2, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````





###### Question


What is the value of `round(3.5000)`

````
CalculusWithJulia.WeaveSupport.Numericq(4.0, 0.001, "", "[3.999, 4.001]", 3
.999, 4.001, "", "")
````





###### Question


What is the value of `sqrt(32 - 12)`

````
CalculusWithJulia.WeaveSupport.Numericq(4.47213595499958, 0.001, "", "[4.47
114, 4.47314]", 4.471135954999579, 4.47313595499958, "", "")
````





###### Question


Which is greater $e^\pi$ or $\pi^e$?


````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$exp(\pi)$
", L"$\pi^exp(1)$"], 1, "", nothing, [1, 2], LaTeXStrings.LaTeXString[L"$ex
p(\pi)$", L"$\pi^exp(1)$"], "", false)
````





###### Question


What is the value of $\pi - (x - \sin(x)/\cos(x))$ when $x=3$?



````
CalculusWithJulia.WeaveSupport.Numericq(-0.0009538894844847157, 0.001, "", 
"[-0.00195, 5.0e-5]", -0.0019538894844847157, 4.6110515515284355e-5, "", ""
)
````





###### Question


Factorials in `Julia` are computed with the function `factorial`, not the postfix operator `!`, as with math notation. What is $10!$?

````
CalculusWithJulia.WeaveSupport.Numericq(3628800, 0, "", "[3.6288e6, 3.6288e
6]", 3628800, 3628800, "", "")
````





###### Question

Will `-2^2` produce `4` (which is a unary `-` evaluated *before* `^`) or `-4` (which is a unary `-` evaluated *after* `^`)?

````
CalculusWithJulia.WeaveSupport.Radioq(["`-4`", "`4`"], 1, "", nothing, [1, 
2], ["`-4`", "`4`"], "", false)
````





###### Question

A twitter post from popular mechanics generated some attention.

````
CalculusWithJulia.WeaveSupport.ImageFile("figures/order_operations_pop_mech
.png", "")
````





What is the answer?

````
CalculusWithJulia.WeaveSupport.Numericq(16.0, 0.001, "", "[15.999, 16.001]"
, 15.999, 16.001, "", "")
````





Does this expression return the *correct* answer using proper order of operations?

````julia

8÷2(2+2)
````


````
1
````



````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 2, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````





Why or why not:

````
CalculusWithJulia.WeaveSupport.Radioq(["Of course it is correct.", "The pre
cedence of numeric literal coefficients used for implicit multiplication is
 higher than other binary operators such as multiplication (`*`), and divis
ion (`/`, ``, and `//`)"], 2, "", nothing, [1, 2], ["Of course it is correc
t.", "The precedence of numeric literal coefficients used for implicit mult
iplication is higher than other binary operators such as multiplication (`*
`), and division (`/`, ``, and `//`)"], "", false)
````


