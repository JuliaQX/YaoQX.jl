using YaoQX
using Documenter

DocMeta.setdocmeta!(YaoQX, :DocTestSetup, :(using YaoQX); recursive=true)

makedocs(;
    modules=[YaoQX],
    authors="Roger-Luo <rogerluo.rl18@gmail.com> and contributors",
    repo="https://github.com/Roger-luo/YaoQX.jl/blob/{commit}{path}#{line}",
    sitename="YaoQX.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Roger-luo.github.io/YaoQX.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Roger-luo/YaoQX.jl",
)
