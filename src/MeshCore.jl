module MeshCore

using StaticArrays

include("utilities.jl")
include("attributes.jl")
include("shapedesc.jl")
include("shapes.jl")
include("increl.jl")

# When we do using MeshCore.Exports, the symbols defined there are exported.
include("Exports.jl")

end # module
