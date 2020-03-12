using Documenter, MeshCore

makedocs(
	modules = [MeshCore],
	doctest = false, clean = true,
	format = Documenter.HTML(prettyurls = false),
	authors = "Petr Krysl",
	sitename = "MeshCore.jl",
	pages = Any[
	"Home" => "index.md",
	"Guide" => "guide/guide.md",
	"Types and Functions" => Any[
		"man/types.md",
		"man/functions.md"]
		]
	)

deploydocs(
    repo = "github.com/PetrKryslUCSD/MeshCore.jl.git",
)
