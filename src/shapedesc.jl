
"""
    AbstractShapeDesc

Abstract shape descriptor (simplex, or cuboid, of various manifold dimension)

The definitions of concrete types below define a set of shape descriptors,
covering the usual element shapes: point, line segment, quadrilateral,
hexahedron, and a similar hierarchy for the simplex elements: point, line
segment, triangle, tetrahedron.

The concrete types of the shape descriptor will provide access to
`manifdim` = manifold dimension of the shape (0, 1, 2, or 3),
`nvertices` = number of vertices of the shape,
`nfacets` = number of shapes on the boundary of this shape,
`facetdesc` = shape descriptor of the shapes on the boundary of this shape,
`n1storderv` = number of first-order vertices for the shape, for instance 
    a 6-node triangle has 3 first-order vertices,
`facets` = definitions of the shapes on the boundary of this shape in terms
    of local connectivity

The bit-type values are defined with the type parameters:
`MD` is the manifold dimension, `NV` is the
number of connected vertices, `NF` is the number of boundary facets, `N1OV`
number of first-order vertices, `FD` is the descriptor of the facet
(boundary shape).
"""
abstract type AbstractShapeDesc{MD, NV, NF, N1OV, FD}
end

"""
    manifdim(sd::AbstractShapeDesc{MD, NV, NF, N1OV, FD}) where {MD, NV, NF, N1OV, FD}

What is the manifold dimension of this shape?
"""
manifdim(sd::AbstractShapeDesc{MD, NV, NF, N1OV, FD}) where {MD, NV, NF, N1OV, FD} = MD

"""
    nvertices(sd::AbstractShapeDesc{MD, NV, NF, N1OV, FD}) where {MD, NV, NF, N1OV, FD}

How many vertices does the shape connect?
"""
nvertices(sd::AbstractShapeDesc{MD, NV, NF, N1OV, FD}) where {MD, NV, NF, N1OV, FD} = NV

"""
    nfacets(sd::AbstractShapeDesc{MD, NV, NF, N1OV, FD}) where {MD, NV, NF, N1OV, FD}

How many facets bound the shape?
"""
nfacets(sd::AbstractShapeDesc{MD, NV, NF, N1OV, FD}) where {MD, NV, NF, N1OV, FD} = NF

"""
    nfacets(sd::AbstractShapeDesc{MD, NV, NF, N1OV, FD}) where {MD, NV, NF, N1OV, FD}

How many 1st-order vertices is there per facet?

For instance, for hexahedra each facet has 4 1st-order vertices.
"""
n1storderv(sd::AbstractShapeDesc{MD, NV, NF, N1OV, FD}) where {MD, NV, NF, N1OV, FD} = N1OV

"""
    NoSuchShapeDesc

Base descriptor: no shape is of this description.
"""
struct NoSuchShapeDesc{MD, NV, NF, N1OV, FD} <: AbstractShapeDesc{MD, NV, NF, N1OV, FD}
end

"""
    P1ShapeDesc{MD, NV, NF, N1OV, FD}

Shape descriptor of a point shape. 
"""
struct P1ShapeDesc{MD, NV, NF, N1OV, FD} <: AbstractShapeDesc{MD, NV, NF, N1OV, FD}
    facetdesc::FD
    facets::SMatrix{NF, 0, Int64, 0}
end
const P1 = P1ShapeDesc{0, 1, 0, 1, NoSuchShapeDesc}(NoSuchShapeDesc{0, 0, 0, 0, NoSuchShapeDesc}(), SMatrix{1, 0}(Int64[]))

"""
    L2ShapeDesc{MD, NV, NF, N1OV, FD}

Shape descriptor of a line segment shape.
"""
struct L2ShapeDesc{MD, NV, NF, N1OV, FD} <: AbstractShapeDesc{MD, NV, NF, N1OV, FD}
    facetdesc::FD
    facets::SMatrix{NF, 1, Int64, 2}
end
const L2 = L2ShapeDesc{1, 2, 2, 2, P1ShapeDesc}(P1, SMatrix{2, 1}([1; 2]))

"""
    Q4ShapeDesc{MD, NV, NF, N1OV, FD}

Shape descriptor of a quadrilateral shape.
"""
struct Q4ShapeDesc{MD, NV, NF, N1OV, FD} <: AbstractShapeDesc{MD, NV, NF, N1OV, FD}
    facetdesc::FD
    facets::SMatrix{NF, 2, Int64, 8}
end
const Q4 = Q4ShapeDesc{2, 4, 4, 4, L2ShapeDesc}(L2, SMatrix{4, 2}([1 2; 2 3; 3 4; 4 1]))

"""
    H8ShapeDesc{MD, NV, NF, N1OV, FD}

Shape descriptor of a hexahedral shape. 
"""
struct H8ShapeDesc{MD, NV, NF, N1OV, FD} <: AbstractShapeDesc{MD, NV, NF, N1OV, FD}
    facetdesc::FD
    facets::SMatrix{NF, 4, Int64, 24}
end
const H8 = H8ShapeDesc{3, 8, 6, 8, Q4ShapeDesc}(Q4, SMatrix{6, 4}(
[1 4 3 2;
1 2 6 5;
2 3 7 6;
3 4 8 7;
4 1 5 8;
6 7 8 5]))

"""
    T3ShapeDesc{MD, NV, NF, N1OV, FD}

Shape descriptor of a triangular shape. 
"""
struct T3ShapeDesc{MD, NV, NF, N1OV, FD} <: AbstractShapeDesc{MD, NV, NF, N1OV, FD}
    facetdesc::FD
    facets::SMatrix{NF, 2, Int64, 6}
end
const T3 = T3ShapeDesc{2, 3, 3, 3, L2ShapeDesc}(L2, SMatrix{3, 2}(
[1 2; 2 3; 3 1]))

"""
    T4ShapeDesc{MD, NV, NF, N1OV, FD}

Shape descriptor of a tetrahedral shape. 
"""
struct T4ShapeDesc{MD, NV, NF, N1OV, FD} <: AbstractShapeDesc{MD, NV, NF, N1OV, FD}
    facetdesc::FD
    facets::SMatrix{NF, 3, Int64, 12}
end
const T4 = T4ShapeDesc{3, 4, 4, 4, T3ShapeDesc}(T3, SMatrix{4, 3}([1 3 2; 1 2 4; 2 3 4; 1 4 3]))

"""
    SHAPE_DESC

Dictionary of all the descriptors.
"""
const SHAPE_DESC = Dict("P1"=>P1, "L2"=>L2, "T3"=>T3, "T4"=>T4, "Q4"=>Q4, "H8"=>H8)
