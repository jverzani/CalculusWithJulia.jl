import Markdown, Pluto

## From Juno

import Base: iterate

# An iterator for the parse function: parsit(source) will iterate over the
# expressiosn in a string.
mutable struct ParseIt
    value::AbstractString
end


function parseit(value::AbstractString)
    ParseIt(value)
end

function Base.iterate(it::ParseIt)
    pos = 1
    iterate(it, pos)
#    (ex,newpos) = Meta.parse(it.value, 1)
#    ((it.value[1:(newpos-1)], ex), newpos)
end

function Base.iterate(it::ParseIt, pos)
    if pos > length(it.value)
        nothing
    else
        (ex,newpos) = Meta.parse(it.value, pos)
        ((it.value[pos:(newpos-1)], ex), newpos)
    end
end

# function start(it::ParseIt)
#     1
# end


# function next(it::ParseIt, pos)
#     (ex,newpos) = Meta.parse(it.value, pos)
#     ((it.value[pos:(newpos-1)], ex), newpos)
# end


# function done(it::ParseIt, pos)
#     pos > length(it.value)
# end


# A special dummy module in which a documents code is executed.
module WeaveSandbox
end

"""

Make a module of a given name.

"""
function make_module(nm=randstring())
    nm = "Z"*uppercase(nm)
    eval(Meta.parse("module " * nm * " end"))
    eval(Meta.parse(nm))
end

struct DisplayError
    x
end
Base.show(io::IO, ::MIME"text/plain", e::DisplayError) = println(io, e.x)

# Evaluate an expression and return its result and a string.
safeeval(m, ex::Nothing) = nothing
function safeeval(m, ex::Union{Number,Symbol, Expr})
    try
        res = Core.eval(m, ex)


    catch e
        printstyled("Error with evaluating $ex: $(string(e))\n", color=:red)
        DisplayError(string(e))
    end
end

function process_block(text, m = WeaveSandbox)
    result = ""
    for (cmd, ex) in parseit(strip(text))
        result = safeeval(m, ex)
    end
    result
end


# type piracy
function Markdown.plain(io::IO, l::Markdown.LaTeX)
    println(io, "```math")
    println(io, l.formula)
    println(io, "```")
end

function markdownToPluto(fname::AbstractString,
                         path::AbstractString=splitext(fname)[1] *".jl";
                         chunkToCell=process_content_evaluate(),
                         leadingCells = extra_cells, #() -> (),
                         trailingCells= () -> ())

    out = Markdown.parse_file(fname,  flavor=Markdown.julia)
    cells = chunkToCell.(out.content)

    for cell ∈ leadingCells()
        push!(cells, cell)
    end
    for cell ∈ trailingCells()
        push!(cells, cell)
    end

    nb = Pluto.Notebook(cells)
    Pluto.save_notebook(nb, path);
end


function process_content(content)
    T = isa(content, Markdown.Code) ? Val(:Code) :
        Val(:Markdown)
    return chunk_to_cell(T, content)
end

function chunk_to_cell(::Val{:Code}, chunk, args...)
    txt = chunk.code
    lang = chunk.language
    langs = map(lstrip, split(replace(lang,";"=>","), ","))

    # signal through langs (nocode, noeval, verbatime, ???)

    if "noeval" ∈ langs   || "verbatim" ∈ langs
        cell = Pluto.Cell("md\"\"\"```$(txt)```\"\"\"")
        cell.code_folded = true
        return cell
    end

    if contains(txt, "\n")
        txt = "let\n$(txt)\nend"
    end
    cell = Pluto.Cell(txt)
    ("nocode" ∈ langs || "echo=false" ∈ langs) && (cell.code_folded = true)

    result = try
        process_block(txt, m)
    catch err
        nothing
    end

    isnothing(result) && return cell



    return cell
end

function chunk_to_cell(::Val{:Markdown}, chunk, args...)
    txt = sprint(io -> Markdown.plain(io, chunk))
    cell = Pluto.Cell("md\"\"\"$(txt)\"\"\"")
    cell.code_folded = true
    return cell
end

# specialize

function chunk_to_cell(::Val{:Code_Evaluate}, chunk, m, args...)
    txt = chunk.code
    lang = chunk.language
    lang = replace(lang, ";" => ",")
    langs = map(lstrip, split(lang, ","))
    langs = [replace(l, r"\s+" => "") for l ∈ langs]


    if "noeval" ∈ langs   || "verbatim" ∈ langs
        cell = Pluto.Cell("md\"\"\"```$(txt)```\"\"\"")
        cell.code_folded = true
        return cell
    end

    block_type = "local" ∈ langs ? "let" : "begin"

    if contains(txt, "\n") || block_type == "let"
        txt = "$block_type\n$(txt)\nend"
    end
    cell = Pluto.Cell(txt)
    ("nocode" ∈ langs || "echo=false" ∈ langs) && (cell.code_folded = true)

    result = try
        process_block(txt, m)
    catch err
        nothing
    end


    # catch cases to show as HTML
    if isa(result, Question) || isa(result, OutputOnlyType)
        out = sprint(io -> show(io, "text/html", result))
        cell = Pluto.Cell("HTML(raw\"\"\"$(out)\"\"\")")
        cell.code_folded = true
    end

    return cell

end

# return process_content function
function process_content_evaluate()
    m = make_module()
    #    process_block("using WeavePynb, SymPy, Roots, Plots, LaTeXStrings, CalculusWithJulia", m)
    process_block("using LaTeXStrings", m)
    safeeval(m, Meta.parse("macro q_str(x)  \"`\$x`\" end"))

    function(content)
        T = isa(content, Markdown.Code) ? Val(:Code_Evaluate) :
        Val(:Markdown)
        return chunk_to_cell(T, content, m)
    end

end

# add Table of Contents
function extra_cells()
    cells = [
             Pluto.Cell("using PlutoUI"),
             Pluto.Cell("PlutoUI.TableOfContents()")
             ]
    for cell ∈ cells
        cell.code_folded = true
    end
    cells
end
