using Documenter, MeshCore

makedocs(
	modules = [MeshCore],
	doctest = false, clean = true,
	format = Documenter.HTML(prettyurls = false),
	authors = "Petr Krysl",
	sitename = "MeshCore.jl",
	pages = Any[
		"Home" => "index.md",
		"How to guide" => "guide/guide.md",
		"Reference" => "man/reference.md",
		"Concepts" => "concepts/concepts.md"	
	],
	)

deploydocs(
    repo = "github.com/PetrKryslUCSD/MeshCore.jl.git",
)
