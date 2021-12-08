"""
Centered content in a card with :content, :caption, :width
"""
centered_content_tpl = """
<div class="d-flex justify-content-center">
<div class="card border-light mx-3 px-3 my-3 py-3" style="{{#:width}}width={{:width}}px{{/:width}}{{^:width}} max-width: 560px;{{/:width}}">
  {{{:content}}}
  <div class="card-footer text-muted">
    <span class="card-text">
      <small class="text-muted">
      {{{:caption}}}
      </small>
    </span>
  </div>
</div>
</div>
"""


"""

Take an image file and encode it

## Examples
```
ImageFile("http://...", "caption")
ImageFile("/fullpath/to_file/", "caption")
ImageFile(:integrals, "figures/pic.png", "caption")
ImageFile(p, "caption") # p a Plot object
```


"""
mutable struct ImageFile
    f
    caption
    alt
    width
    content
end
# 2 args f, caption
ImageFile(f,caption=""; alt="A Figure", width=nothing) = ImageFile(f, caption, alt, width)

# 3 args dir, f, caption
function ImageFile(dir::Symbol, f::AbstractString, caption;
                   alt="A Figure", width=nothing)
    basedir = replace(dirname(@__DIR__), "/src" => "")
    fname = joinpath(basedir, "CwJ", string(dir), f)

    ImageFile(fname, caption, alt, width)
end
# plot -> string for file
function ImageFile(f, caption, alt, width)
    imgfile = tempname() * ".gif"
    io = open(imgfile, "w")
    show(io, "image/png", f)
    close(io)
    ImageFile(imgfile, caption, alt, width)
end

function ImageFile(f::AbstractString, caption, alt, width)
    fcontent = occursin(r"^http", f) ? read(download(f), String) : read(f, String)
    data = base64encode(fcontent)
    content = Mustache.render(gif_to_img_tpl, data=data, alt=alt)
    caption = Markdown.parse(caption)
    ImageFile(f, caption, alt, width, content)
end




## WeaveTpl
function Base.show(io::IO, m::MIME"text/html", x::ImageFile)

    content = x.content
    if content == nothing
        data = (read(x.f, String))
        content = gif_to_image(data=data, alt="figure")
    end
    caption = sprint(io -> show(io, "text/html", x.caption))

    print(io, """<div class="d-flex justify-content-center">""")
    print(io, "  <figure>")
    print(io, content)
    print(io, "    <figcaption>")
    print(io, caption)
    print(io, """
    </figcaption>
  </figure>
</div>
""")
end
#Mustache.render(io, centered_content_tpl; content=content, caption=caption)

function Base.show(io::IO, ::MIME"text/latex", x::ImageFile)
    fname = x.f
    if occursin(r"gif$", fname)
        println(io, "XXX can not include `.gif` file here")
    else
        print(io, """
\\begin{figure}
\\caption{$(x.caption)}
\\includegraphics[width=0.6\\textwidth]{$(x.f)}
\\end{figure}
""")
    end
end


" template for an base64 encoded image"
gif_to_img_tpl = mt"""
  <img src="data:image/gif;base64,{{{:data}}}" class="card-img-top" alt="{{{:alt}}}">
"""


# """

function gif_to_data(imgfile::AbstractString, caption="", width=480)
    data = base64encode(read(imgfile, String))
    content = Mustache.render(gif_to_img_tpl, data=data, alt="A Figure")
    Mustache.render(centered_content_tpl, content=content, caption=md(caption), width=width)
end

# take an image and process
function gif_to_data(img, caption="")
    imgfile = tempname() * ".gif"
    io = open(imgfile, "w")
    show(io, "image/png", img)
    close(io)
    gif_to_data(imgfile, caption)
end
