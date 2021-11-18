## Modified from
## https://github.com/SciML/SciMLTutorials.jl/blob/master/src/SciMLTutorials.jl

using Weave
using Pkg

const repo_directory = joinpath(@__DIR__,"..")
const cssfile =   joinpath(@__DIR__, "..", "templates", "skeleton_css.css")
const htmlfile =  joinpath(@__DIR__, "..", "templates", "bootstrap.tpl")
const latexfile = joinpath(@__DIR__, "..", "templates", "julia_tex.tpl")

# do we build the file?
function build_file(jmdfile, outfile; force=false)
    force && return true
    !isfile(outfile) && return true
    mtime(outfile) < mtime(jmdfile) && return true
    return false
end

# build list ⊂ (:script,:html,:weave_html, :pdf,:github,:notebook,:pluto)
function weave_file(folder, file; build_list=(:html,), force=false, kwargs...)
    jmddir = isdir(folder) ? folder : joinpath(repo_directory,"CwJ",folder)
    tmp = joinpath(jmddir, file)
    bnm = replace(basename(tmp), r".jmd$" => "")


    if !force
        testfile = joinpath(repo_directory, "html", folder, bnm*".html")
        if isfile(testfile) && (mtime(testfile) >= mtime(tmp))
            return
        end
    end

    Pkg.activate(dirname(tmp))
    Pkg.instantiate()
    args = Dict{Symbol,String}(:folder=>folder,:file=>file)

    if :script ∈ build_list
        println("Building Script")
        dir = joinpath(repo_directory,"script",folder)
        isdir(dir) || mkpath(dir)

        ext = ".jl"
        outfile = joinpath(dir, bnm*ext)
        build_file(file, outfile, force=force) || return nothing

        args[:doctype] = "script"
        tangle(tmp;out_path=dir)
    end

    if :html ∈ build_list
        ## use jmd -> pluto notebook -> generate_html
        println("Building HTML: $file")
        cd(jmddir)

        dir = joinpath(repo_directory,"html",folder)
        isdir(dir) || mkpath(dir)

        ext = ".html"
        outfile = joinpath(dir, bnm*ext)
        build_file(file, outfile, force=force) || return nothing

header_cmd = """
HTML(\"\"\"
<div class="admonition info"><a href="https://CalculusWithJulia.github.io">
<img src="https://raw.githubusercontent.com/jverzani/CalculusWithJulia.jl/master/CwJ/misc/logo.png" alt="Calculus with Julia" width="48" />
</a>
<span style="font-size:32px">Calculus With Julia</span>
</div>
\"\"\")
"""

        f = CalculusWithJulia.WeaveSupport.Footer(Symbol(bnm), Symbol(folder))
        out = sprint(io -> show(io, "text/html", f))
        footer_cmd = "HTML(\"\"\"$(out)\"\"\")"


        html_content = md2html(file,
                               header_cmds=(header_cmd,),
                               footer_cmds=("using PlutoUI",
                                            "PlutoUI.TableOfContents()",
                                            footer_cmd
                                            ))
        open(outfile, "w") do io
            write(io, html_content)
        end

    end

    if :weave_html ∈ build_list
        println("Building HTML for $file")
        dir = joinpath(repo_directory,"html",folder)
        isdir(dir) || mkpath(dir)

        figdir = joinpath(jmddir,"figures")
        htmlfigdir = joinpath(dir, "figures")

        if isdir(figdir)
            isdir(htmlfigdir) && rm(htmlfigdir, recursive=true)
            cp(figdir, htmlfigdir)
        end

        ext = ".html"
        outfile = joinpath(dir, bnm*ext)
        build_file(file, outfile, force=force) || return nothing


        Weave.set_chunk_defaults!(:wrap=>false)
        args[:doctype] = "html"



        # override printing for Polynomials, SymPy
        𝐦 = Core.eval(@__MODULE__, :(module $(gensym(:WeaveHTMLTestModule)) end))
        Core.eval(𝐦, quote
using SymPy, Polynomials
function Base.show(io::IO, ::MIME"text/html", x::T) where {T <: SymPy.SymbolicObject}
    #write(io, "<div class=\"well well-sm\">")
    write(io, "<div class=\"output\">")
    show(io, "text/latex", x)
    write(io, "</div>")
end

function Base.show(io::IO, ::MIME"text/html", x::Array{T}) where {T <: SymPy.SymbolicObject}
    #write(io, "<div class=\"well well-sm\">")
    write(io, "<div class=\"output\">")
    show(io, "text/latex", x)
    write(io, "</div>")
end

function Base.show(io::IO, ::MIME"text/html", x::T) where {T <: Polynomials.AbstractPolynomial}
#     #write(io, "<div class=\"well well-sm\">")
     write(io, "<div class=\"output\">")
     show(io, "text/latex", x)
     write(io, "</div>")
end

                  end)


        #weave(tmp,doctype = "md2html",out_path=dir,args=args; fig_ext=".svg", css=cssfile, kwargs...)
        weave(tmp;
              doctype = "md2html",
              out_path=dir,
              mod = 𝐦,
              args=args,
              fig_ext=".svg",
              template=htmlfile,
              fig_path=tempdir(),
              kwargs...)

        # clean up
        isdir(htmlfigdir) && rm(htmlfigdir, recursive=true)

    end

    if :pdf ∈ build_list

        eval(quote using Tectonic end) # load Tectonic; wierd testing error

        println("Building PDF")
        dir = joinpath(repo_directory,"pdf",folder)
        isdir(dir) || mkpath(dir)

        ext = ".pdf"
        outfile = joinpath(dir, bnm*ext)
        build_file(file, outfile, force=force) || return nothing



        fig_path = "_figures_" * bnm
        figdir = joinpath(jmddir,"figures")
        texfigdir = joinpath(dir, "figures")

        if isdir(figdir)
            isdir(texfigdir) && rm(texfigdir, recursive=true)
            cp(figdir, texfigdir)
        end

        args[:doctype] = "pdf"
        try
            weave(tmp,doctype="md2tex",out_path=dir,args=args;
                  template=latexfile,
                  fig_path=fig_path,
                  kwargs...)

            texfile = joinpath(dir, bnm * ".tex")
            Base.invokelatest(Tectonic.tectonic, bin -> run(`$bin $texfile`))


            # clean up
            for ext in (".tex",)
                f = joinpath(dir, bnm * ext)
                isfile(f) && rm(f)
            end

        catch ex
            @warn "PDF generation failed" exception=(ex, catch_backtrace())

        end

        isdir(texfigdir) && rm(texfigdir, recursive=true)
        isdir(joinpath(dir,fig_path)) && rm(joinpath(dir,fig_path), recursive=true)
        for ext in (".aux", ".log", ".out")
            f = joinpath(dir, bnm * ext)
            isfile(f) && rm(f)
        end

    end

    if :github ∈ build_list
        println("Building Github Markdown")
        dir = joinpath(repo_directory,"markdown",folder)
        isdir(dir) || mkpath(dir)


        ext = ".md"
        outfile = joinpath(dir, bnm*ext)
        build_file(file, outfile, force=force) || return nothing

        args[:doctype] = "github"
        weave(tmp,doctype = "github",out_path=dir, args=args;
              fig_path=tempdir(),
              kwargs...)
    end

    if :notebook ∈ build_list
        println("Building Notebook")
        dir = joinpath(repo_directory,"notebook",folder)
        isdir(dir) || mkpath(dir)

        ext = ".ipynb"
        outfile = joinpath(dir, bnm*ext)
        build_file(file, outfile, force=force) || return nothing

        args[:doctype] = "notebook"
        Weave.convert_doc(tmp,outfile)
    end

    if :pluto ∈ build_list
        println("Building Pluto notebook")
        dir = joinpath(repo_directory,"pluto",folder)
        isdir(dir) || mkpath(dir)


        ext = ".jl"
        outfile = joinpath(dir, bnm*ext)
        build_file(file, outfile, force=force) || return nothing

        md2jl(file, outfile)
    end

end

"""
    weave_all(; force=false, build_list=(:script,:html,:pdf,:github,:notebook))

Run `weave` on all source files.

* `force`: by default, only run `weave` on files with `html` file older than the source file in `CwJ`
* `build_list`: list of output types to be built. The default is all types

The files will be built as subdirectories in the package directory. This is returned by `pathof(CalculusWithJulia)`.

"""
function weave_all(;force=false, build_list=(:script,:html,:pdf,:github,:notebook))
    for folder in readdir(joinpath(repo_directory,"CwJ"))
        folder == "test.jmd" && continue
        weave_folder(folder; force=force, build_list=build_list)
    end
end

function weave_folder(folder; force=false, build_list=(:html,))
    !isnothing(match(r"\.ico$", folder)) && return nothing
    for file in readdir(joinpath(repo_directory,"CwJ",folder))
        !occursin(r".jmd$", basename(file)) && continue
        println("Building $(joinpath(folder,file))")
        try
            weave_file(folder,file; force=force, build_list=build_list)
        catch
        end
    end
end
