# Load ImplicitEquations

## meta these
preds = [(:Lt, :≪, :<), # \ll
         (:Le, :≦, :<=), # \leqq
         (:Eq, :⩵, :(==)), # \Equal
         (:Ge, :≧, :>=), # \gegg
         (:Gt, :≫, :>) # \gg
         ]

#import SymPy: Lt, Le, Eq, Ge, Gt, ≪, ≦, ⩵, ≧, ≫
for (fn, uop, op) in preds
    fnname =  string(fn)

    @eval begin
        ($fn)(f::Function, x::Real) = Pred(f, $op, x)
        ($uop)(f::Function, x::Real) = ($fn)(f, x)
        ($fn)(f::Function, g::Function) = $(fn)((x,y) -> f(x,y) - g(x,y), 0)
        ($uop)(f::Function, g::Function) = ($fn)(f, g)
    end
    eval(Expr(:export, fn))
    eval(Expr(:export, uop))
end
import ImplicitEquations: Neq
export Neq
