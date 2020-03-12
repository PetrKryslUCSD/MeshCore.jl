
"""
    AbstractShapeDesc

Abstract shape descriptor (simplex, or cuboid, of various manifold dimension)

The definitions of concrete types below define a set of shape descriptors,
covering the usual element shapes: point, line segment, quadrilateral,
hexahedron, and a similar hierarchy for the simplex elements: point, line
segment, triangle, tetrahedron.

The concrete types of the shape descriptor will provide access to
`manifdim` = manifold dimension of the shape (0, 1, 2, or 3),
`nnodes` = number of nodes (vertices) of the shape,
`facetdesc` = shape descriptor of the shapes on the boundary of this shape,
`nfacets` = number of shapes on the boundary of this shape,
`facets` = definitions of the shapes on the boundary of this shape in terms
    of local connectivity
"""
abstract type AbstractShapeDesc
end

"""
    NoSuchShapeDesc

Base description: no shape is of this description.
"""
struct NoSuchShapeDesc <: AbstractShapeDesc
end

"""
    P1ShapeDesc{BS}

Shape description of a point shape. `BS` is the type of the facet (boundary
shape).
"""
struct P1ShapeDesc{BS} <: AbstractShapeDesc
    manifdim::Int64
    nnodes::Int64
    facetdesc::BS
    nfacets::Int64
    facets::SMatrix{1, 0, Int64, 0}
end

const P1 = P1ShapeDesc(0, 1, NoSuchShapeDesc(), 0, SMatrix{1, 0}(Int64[]))

"""
    L2ShapeDesc{BS}

Shape description of a line segment shape. `BS` is the type of the facet (boundary
shape).
"""
struct L2ShapeDesc{BS} <: AbstractShapeDesc
    manifdim::Int64
    nnodes::Int64
    facetdesc::BS
    nfacets::Int64
    facets::SMatrix{2, 1, Int64, 2}
end

const L2 = L2ShapeDesc(1, 2, P1, 2, SMatrix{2, 1}([1; 2]))

"""
    Q4ShapeDesc{BS}

Shape description of a quadrilateral shape. `BS` is the type of the facet (boundary
shape).
"""
struct Q4ShapeDesc{BS} <: AbstractShapeDesc
    manifdim::Int64
    nnodes::Int64
    facetdesc::BS
    nfacets::Int64
    facets::SMatrix{4, 2, Int64, 8}
end

const Q4 = Q4ShapeDesc(2, 4, L2, 4, SMatrix{4, 2}([1 2; 2 3; 3 4; 4 1]))

"""
    H8ShapeDesc{BS}

Shape description of a hexahedral shape. `BS` is the type of the facet (boundary
shape).
"""
struct H8ShapeDesc{BS} <: AbstractShapeDesc
    manifdim::Int64
    nnodes::Int64
    facetdesc::BS
    nfacets::Int64
    facets::SMatrix{6, 4, Int64, 24}
end

const H8 = H8ShapeDesc(3, 8, Q4, 6, SMatrix{6, 4}(
[1 4 3 2;
1 2 6 5;
2 3 7 6;
3 4 8 7;
4 1 5 8;
6 7 8 5]))

"""
    T3ShapeDesc{BS}

Shape description of a triangular shape. `BS` is the type of the facet (boundary
shape).
"""
struct T3ShapeDesc{BS} <: AbstractShapeDesc
    manifdim::Int64
    nnodes::Int64
    facetdesc::BS
    nfacets::Int64
    facets::SMatrix{3, 2, Int64, 6}
end

const T3 = T3ShapeDesc(2, 3, L2, 3, SMatrix{3, 2}(
[1 2; 2 3; 3 1]))

"""
    T4ShapeDesc{BS}

Shape description of a tetrahedral shape. `BS` is the type of the facet (boundary
shape).
"""
struct T4ShapeDesc{BS} <: AbstractShapeDesc
    manifdim::Int64
    nnodes::Int64
    facetdesc::BS
    nfacets::Int64
    facets::SMatrix{4, 3, Int64, 12}
end

const T4 = T4ShapeDesc(3, 4, T3, 4, SMatrix{4, 3}([1 3 2; 1 2 4; 2 3 4; 1 4 3]))

const SHAPE_DESC = Dict("P1"=>P1, "L2"=>L2, "T3"=>T3, "T4"=>T4, "Q4"=>Q4, "H8"=>H8)

"""
    ShapeCollection{S <: AbstractShapeDesc, N, T}

This is the type of a homogeneous collection of finite element shapes.

- S = shape descriptor:
- `N` = number of vertices incident on the shape (i. e. by which the shape is
    defined)
- `T` = type of the vertex numbers (some concrete type of `Integer`).
"""
struct ShapeCollection{S <: AbstractShapeDesc, N, T}
    # Shape descriptor
    shapedesc::S
    # Connectivity: incidence relation Shape -> Vertex
    connectivity::Vector{SVector{N, T}}
end

"""
    ShapeCollection(shapedesc::S, C::Array{T, 2}) where {S <: AbstractShapeDesc, T}

Convenience constructor from a matrix. One shape per row.
"""
function ShapeCollection(shapedesc::S, C::Array{T, 2}) where {S <: AbstractShapeDesc, T}
    cc = [SVector{shapedesc.nnodes}(C[idx, :]) for idx in 1:size(C, 1)]
    return ShapeCollection(shapedesc, cc)
end

"""
    shapedesc(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the shape descriptor.
"""
shapedesc(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc

"""
    connectivity(shapes::ShapeCollection{S, N, T}, i::I) where {S, N, T, I}

Retrieve connectivity of one shape from the collection.
"""
connectivity(shapes::ShapeCollection{S, N, T}, i::I) where {S, N, T, I} = shapes.connectivity[i]

"""
    connectivity(shapes::ShapeCollection{S, N, T}, I::SVector) where {S, N, T}

Retrieve connectivity of multiple shapes from the collection.

Static arrays are used to help the compiler avoid memory allocation.
"""
@generated function connectivity(shapes::ShapeCollection{S, N, T}, I::SVector) where {S, N, T}
    nidx = length(I)
    expr = :(())
    for i in 1:nidx
        push!(expr.args, :(shapes.connectivity[I[$i]]))
    end
    return :(SVector($expr))
end

"""
    nshapes(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Number of shapes in the collection.
"""
nshapes(shapes::ShapeCollection{S, N, T}) where {S, N, T} = length(shapes.connectivity)

"""
    manifdim(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the manifold dimension of the collection.
"""
manifdim(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc.manifdim

"""
    nnodes(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the number of nodes per shape.
"""
nnodes(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc.nnodes

"""
    facetdesc(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the shape type of the boundary facet.
"""
facetdesc(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc.facetdesc

"""
    nfacets(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the number of boundary facets per shape.
"""
nfacets(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc.nfacets

"""
    facets(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the connectivity of the facets.
"""
facets(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc.facets

"""
    connectivity(shapes::ShapeCollection{S, N, T}, i::I) where {S, N, T, I}

Retrieve connectivity of one shape from the collection.
"""
function facetconnectivity(shapes::ShapeCollection{S, N, T}, i::I, j::I) where {S, N, T, I}
    return shapes.connectivity[i][shapes.shapedesc.facets[j, :]]
end
