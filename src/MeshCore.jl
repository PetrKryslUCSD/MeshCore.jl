module MeshCore

using StaticArrays

include("utilities.jl")
include("attributes.jl")
include("shapedesc.jl")
include("shapes.jl")
include("increl.jl")

# We can either use/import individual functions from MeshCore like so:
# ```
# using MeshCore: nrelations, nentities
# ```
# or we can bring into our context all exported symbols as
# ```
# using MeshCore.Exports
# ```
include("Exports.jl")

# Enable LSP look-up in test modules.
if false include("../test/runtests.jl") end

end # module
