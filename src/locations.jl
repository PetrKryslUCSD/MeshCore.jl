"""
    Locations{N, T}

Locations of the vertices.

- `N` = number of coordinates, equal to the number of space dimensions,
- `T` = type of the individual coordinates (concrete subtype of `AbstractFloat`).
"""
struct Locations{N, T<:AbstractFloat}
    _v::Vector{SVector{N, T}}
end

"""
    Locations(xyz::Array{T, 2}) where {T}

Construct from a matrix (2D array), one vertex per row.
"""
function Locations(xyz::Array{T, 2}) where {T}
    N = size(xyz, 2)
    Locations([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
end

"""
    nlocations(loc::Locations{N, T}) where {N, T}

Retrieve number of Locations.
"""
nlocations(loc::Locations{N, T}) where {N, T} = length(loc._v)

"""
    nspacedims(loc::Locations{N, T}) where {N, T}

Retrieve the number of space dimensions.
"""
nspacedims(loc::Locations{N, T}) where {N, T} = N

"""
    coordinatetype(loc::Locations{N, T}) where {N, T}

Retrieve type of individual coordinates.
"""
coordinatetype(loc::Locations{N, T}) where {N, T} = T

"""
    coordinates(Locations::Locations{N, T}, i::I) where {N, T, I<:Int}

Retrieve coordinates of a single vertex.
"""
coordinates(loc::Locations{N, T}, i::Int64) where {N, T} = loc._v[i]

"""
    coordinates(loc::Locations{N, T}, I::SVector) where {N, T}

Access coordinates of selected Locations.
"""
@generated function coordinates(loc::Locations{N, T}, I::SVector) where {N, T}
    nidx = length(I)
    expr = :(())
    for i in 1:nidx
        push!(expr.args, :(loc._v[I[$i]]))
    end
    return :(SVector($expr))
end


"""
    LocAccess{N, T}

Data structure to access the locations of vertices.
"""
struct LocAccess{N, T}
    locs::Locations{N, T}
end

"""
    (la::LocAccess)(j::Int64)

Access the coordinate of the `j`-th vertex.
"""
(la::LocAccess)(j::Int64) = coordinates(la.locs, j)
