using CalculusWithJulia
using Test

# conditional on args
#=
using Pkg
Pkg.test("CalculusWithJulia") # basic tests
test_args = ["plots=true"] # run plot tests
test_args = ["force=true"] # generate all html pages
test_args = ["force=true", "target=:pdf"] # generate all as pdf
test_args = ["folder=:precalc"] # make folder as needed
test_args = ["folder=:precalc", "force=true"] # make all in folder
test_args = ["folder=:precalc", "file=:functions"]
Pkg.test("CalculusWithJulia", test_args=test_args)
=#



if isempty(ARGS)
    @info "running package tests"
    include("package-test.jl")
end

if "plots=true" ∈ ARGS
    @info "running plots-tests"
    include("test-plots.jl")
end

function parse_args(ARGS)
    force, folder, file, target = false, nothing, nothing, :html
    for arg ∈ ARGS
        if "force=true" == arg
            force=true
        end
        m = match(r"^folder=:(.*)", arg)
        if m != nothing
            folder = m.captures[1]
        end

        m = match(r"^file=:(.*)", arg)
        if m != nothing
            file = m.captures[1]
        end

        m = match(r"^target=:(.*)", arg)
        if m != nothing
            target = m.captures[1]
        end

    end

    return(folder=folder, file=file, force=force, target=target)
end

folder, file, force, target = parse_args(ARGS)

if folder != nothing || file != nothing || force
    include("build-pages.jl")
    build_pages(folder, file, target, force)
end
