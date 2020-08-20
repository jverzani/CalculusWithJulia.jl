````julia

using CwJWeaveTpl
fnames = [
          "calculator",
          "variables",
          "numbers_types",
          "logical_expressions",
          "vectors",
          "ranges",
          "functions",
          "plotting",
          "transformations",
          "inversefunctions",
          "polynomial",
          "polynomial_roots",
          "rational_functions",
          "exp_log_functions",
          "trig_functions",
          "julia_overview"
]

process_file(nm; cache=:off) = CwJWeaveTpl.mmd(nm * ".jmd", cache=cache)

function process_files(;cache=:user)
    for f in fnames
        @show f
        process_file(f, cache=cache)
    end
end

"""
## TODO

* the first bit of vectors is a bit rushed

"""
````


````
Error: ArgumentError: Package CwJWeaveTpl not found in current path:
- Run `import Pkg; Pkg.add("CwJWeaveTpl")` to install the CwJWeaveTpl packa
ge.
````


