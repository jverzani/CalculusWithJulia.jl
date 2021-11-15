module WeaveSupport
## Modified from
## https://github.com/SciML/SciMLTutorials.jl/blob/master/src/SciMLTutorials.jl

import Base64: base64encode
using Random

using Weave

using Mustache
import Markdown
using JSON
using Reexport
@reexport using LaTeXStrings


using Pkg

include("formatting.jl")
include("bootstrap.jl")
include("questions.jl")
include("show-methods.jl")
include("toc.jl")



macro q_str(x)
    "`$x`"
end

export mmd
export @q_str
export ImageFile, Verbatim, Invisible, Outputonly, HTMLonly, JSXGraph
export alert, warning, note
export example, popup, table
export gif_to_data
export numericq, radioq, booleanq, yesnoq, shortq, longq, multiq


end # module
