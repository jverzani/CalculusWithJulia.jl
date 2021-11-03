import Markdown, Pluto

# type piracy
function Markdown.plain(io::IO, l::Markdown.LaTeX)
    println(io, "```math")
    println(io, l.formula)
    println(io, "```")
end

function markdownToPluto(fname::AbstractString,
                         path::AbstractString;
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
    "nocode" ∈ langs && (cell.code_folded = true)

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
    langs = map(lstrip, split(lang, ","))
    # signal through langs (nocode, noeval, verbatime, ???)

    if "noeval" ∈ langs   || "verbatim" ∈ langs
        cell = Pluto.Cell("md\"\"\"```$(txt)```\"\"\"")
        cell.code_folded = true
        return cell
    end

    block_type = "let" ∈ langs ? "let" : "begin"


    if contains(txt, "\n") || block_type == "let"
        txt = "$block_type\n$(txt)\nend"
    end
    cell = Pluto.Cell(txt)
    "nocode" ∈ langs && (cell.code_folded = true)

    result = try
        process_block(txt, m)
    catch err
        nothing
    end

    @show txt, result

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
