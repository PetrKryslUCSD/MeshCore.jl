"""
    AbstractVertices

Abstract type to represent a collection of vertices.
"""
abstract type AbstractVertices
end

"""
    Vertices{N, T}

Vertices of the mesh.

- N = number of coordinates, equal to the number of space dimensions,
- T = type of the individual coordinates (concrete subtype of `AbstractFloat`).
"""
struct Vertices{N, T<:AbstractFloat} <: AbstractVertices
    coordinates::Vector{SVector{N, T}}
end

"""
    Vertices(xyz::Array{T, 2}) where {T}

Construct from a matrix (2D array), one vertex per row.
"""
function Vertices(xyz::Array{T, 2}) where {T}
    N = size(xyz, 2)
    Vertices([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
end

"""
    nvertices(v::Vertices{N, T}) where {N, T}

Retrieve number of vertices.
"""
nvertices(v::Vertices{N, T}) where {N, T} = length(v.coordinates)

"""
    nspacedims(v::Vertices{N, T}) where {N, T}

Retrieve the number of space dimensions.
"""
nspacedims(v::Vertices{N, T}) where {N, T} = N

"""
    coordinatetype(v::Vertices{N, T}) where {N, T}

Retrieve type of individual coordinates.
"""
coordinatetype(v::Vertices{N, T}) where {N, T} = T

"""
    coordinates(vertices::Vertices{N, T}, i::I) where {N, T, I<:Int}

Retrieve coordinates of a single vertex.
"""
coordinates(vertices::Vertices{N, T}, i::I) where {N, T, I<:Int} = vertices.coordinates[i]

"""
    coordinates(vertices::Vertices{N, T}, I::SVector) where {N, T}

Access coordinates of selected vertices.
"""
@generated function coordinates(vertices::Vertices{N, T}, I::SVector) where {N, T}
    nidx = length(I)
    expr = :(())
    for i in 1:nidx
        push!(expr.args, :(vertices.coordinates[I[$i]]))
    end
    return :(SVector($expr))
end
