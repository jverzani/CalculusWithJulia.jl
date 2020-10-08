# CalculusWithJulia

[![Build Status](https://travis-ci.com/jverzani/CalculusWithJulia.jl.svg?branch=master)](https://travis-ci.com/jverzani/CalculusWithJulia.jl)

`Julia` package to provide notes and features for using `Julia` to address typical problems from the undergraduate calculus sequence. 


The notes may be read at [Calculus with Julia](http://juliahub.com/docs/CalculusWithJulia). 

The notes expect that this package is installed, as it also provides a handful of conveniences for the task.

In addition to the html pages, there are other versions of the same material that can be generated, such as `ipynb` notebooks or `pdf` files. These are available by installing the package and running

```
CalculusWithJulia.WeaveSupport.weave_all()
```

The named argument `build_list` defaults to `build_list=(:script,:html,:pdf,:github,:notebook)` which has all the output formats specified. This can be customized as desired. 

The files are built in the package directory, available through the command `pathof(CalculusWithJulia)`.



## Contributing

This is a work in progress. To report an issue, make a comment, or suggest something new, please file an [issue](https://github.com/jverzani/CalculusWithJulia.jl/issues/). In your message add the tag `@jverzani` to ensure it is not overlooked. Otherwise, an email to `verzani` at `math.csi.cuny.edu` will also work.

To make edits to the documents directly, a pull request with the modified `*.jmd` files in the `CwJ` directory should be made. Minor edits to the `*.jmd` files should be possible through the GitHub web interface. The `*.html` files are generated using `Julia's` `Weave` package. This need not be done.

