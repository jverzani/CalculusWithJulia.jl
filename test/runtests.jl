using CalculusWithJulia
using Test

include("package-test.jl")
!isinteractive() && include("doc-build-test.jl")
