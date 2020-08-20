
] add CalculusWithJulia


using CalculusWithJulia


using CalculusWithJulia.WeaveSupport


] status


] add QuadGK


note("""
Installing the `CalculusWithJulia` package is the only package necessary to install for these notes.
""")


using QuadGK


quadgk(sin, 0, pi)

