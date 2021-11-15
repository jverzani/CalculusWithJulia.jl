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

Caption uses LaTeX markup, not markdown.

"""
mutable struct ImageFile
    f
    caption
    alt
    width
    content
end
ImageFile(f,caption=""; alt="A Figure", width=nothing) = ImageFile(f, caption, alt, width)
function ImageFile(f, caption, alt, width)
    imgfile = tempname() * ".gif"
    io = open(imgfile, "w")
    show(io, "image/png", f)
    close(io)
    ImageFile(imgfile, caption, alt, width)
end
function ImageFile(f::AbstractString, caption, alt, width)
    data = base64encode(read(f, String))
    content = Mustache.render(gif_to_img_tpl, data=data, alt=alt)
    caption = Markdown.parse(caption)
    ImageFile(f, caption, alt, width, content)
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
