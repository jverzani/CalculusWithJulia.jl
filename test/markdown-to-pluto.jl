import Markdown, Pluto

function Markdown.plain(io::IO, l::Markdown.LaTeX)
    println(io, "```math")
    println(io, l.formula)
    println(io, "```")
end


"""
    chunk_to_cell(::Val{:Code}, chunk)

Triple-braced code is treated as a code to be executed, though we adjust based on "langs".

* `hold=true` or `local` -- wrap in a `let` block, so variable names don't escape. Otherwise, a `begin` block is added for multiline chunks. (Had to leverage a Weave chunk option!)
* `echo=false` or `nocode` to hide cell using `code_folded`.
* `eval=false` or `noeval` or `verbatim` to put in an MD cell
* `term=true` wrap in PlutoUI `with_terminal`
"""
function chunk_to_cell(::Val{:Code}, chunk, args...)
    txt = chunk.code
    txt = rstrip(lstrip(txt, '\n'), '\n')

    lang = chunk.language
    lang = replace(lang, ";" => ",")
    langs = map(lstrip, split(lang, ","))
    langs = replace.(langs, r" "=>"")

    # signal through langs
    if "eval=false" ∈ langs ||  "noeval" ∈ langs || "verbatim" ∈ langs
        cell = Pluto.Cell("md\"\"\"```\n$(txt)\n```\"\"\"")
        cell.code_folded = true
        return cell
    end

    if "term=true" ∈ langs
        txt = replace(txt, "\n" => "\n\t")
        txt = "with_terminal() do\n\t$(txt)\nend"
    end


    block_type = ("local" ∈ langs || "hold=true" ∈ langs) ? "let" : "begin"
    multiline = contains(txt, "\n")



    if multiline || block_type == "let"
        txt = replace(txt, "\n" => "\n\t")
        txt = "$(block_type)\n\t$(txt)\nend"
    end
    cell = Pluto.Cell(txt)


    if ("echo=false" ∈ langs || "nocode" ∈ langs)
        cell.code_folded = true
    end

    return cell
end

function chunk_to_cell(::Val{:Markdown}, chunk, args...)
    txt = sprint(io -> Markdown.plain(io, chunk))
    cell = Pluto.Cell("md\"\"\"$(txt)\"\"\"")
    cell.code_folded = true
    return cell
end

function process_content(content)
    T = isa(content, Markdown.Code) ? Val(:Code) : Val(:Markdown)
    return chunk_to_cell(T, content)
end

function md2notebook(fname)
    out = Markdown.parse_file(fname,  flavor=Markdown.julia)
    cells = process_content.(out.content)

    # add Table of contents -- no PlutoUI in file
    for cmd ∈ ("using PlutoUI",
               "PlutoUI.TableOfContents()"
               )
        cell = Pluto.Cell(cmd)
        cell.code_folded = true
        push!(cells, cell)
    end
    notebook = Pluto.Notebook(cells)
end

function nb2html(notebook, session=Pluto.ServerSession())
    Pluto.update_run!(session, notebook, [last(e) for e in notebook.cells_dict])
    Pluto.generate_html(notebook)
end

# save notebook to path
function nb2jl(notebook, path)
    Pluto.save_notebook(notebook, path);
end

md2html(fname) = (nb2html∘md2notebook)(fname)
md2jl(fname, path) = nb2jl(md2notebook(fname), path)
