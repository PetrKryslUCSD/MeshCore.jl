
"""
    AbsShapeDesc

Abstract shape descriptor (simplex, or cuboid, of various manifold dimension)

The definitions of concrete types below define a set of shape descriptors,
covering the usual element shapes: point, line segment, quadrilateral,
hexahedron, and a similar hierarchy for the simplex elements: point, line
segment, triangle, tetrahedron.

The concrete types of the shape descriptor will provide access to
`manifdim` = manifold dimension of the shape (0, 1, 2, or 3),
`nvertices` = number of vertices of the shape,
`n1storderv` = number of first-order vertices for the shape, for instance
    a 6-node triangle has 3 first-order vertices,
`nfacets` = number of shapes on the boundary of this shape,
`facetdesc` = shape descriptor of the shapes on the boundary of this shape,
`facets` = definitions of the shapes on the boundary of this shape in terms
    of local connectivity

The bit-type values are defined with the type parameters:
`MD` is the manifold dimension, `NV` is the
number of connected vertices, `NF` is the number of boundary facets, `N1OV`
number of first-order vertices, `FD` is the descriptor of the facet
(boundary shape).
"""
abstract type AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}
end

"""
    manifdim(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

What is the manifold dimension of this shape?
"""
manifdim(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} = MD

"""
    nvertices(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

How many vertices does the shape connect?
"""
nvertices(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} = NV

"""
    nfacets(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

How many facets bound the shape?
"""
nfacets(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} = NF

"""
    nedgets(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

How many edgets bound the shape?
"""
nedgets(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} = NE

"""
    n1storderv(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

How many 1st-order vertices are there per shape?

For instance, for hexahedra each shape has 8 1st-order vertices.
"""
n1storderv(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} = N1OV

"""
    nshifts(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

How many circular shifts should be tried to figure out the orientation (sense)?
"""
nshifts(sd::AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} = NSHIFTS

"""
    NoSuchShapeDesc

Base descriptor: no shape is of this description.
"""
struct NoSuchShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}
end

const NoSuchShape = NoSuchShapeDesc{
0,  # MD
0,  # NV
0,  # NF
0,  # FD
0,  # NE
0,  # ED
0, # N1OV
0 # NSHIFTS
}()

"""
    P1ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

Shape descriptor of a point shape.
"""
struct P1ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 0, Int64, 0}
    edgetdesc::ED
    edgets::SMatrix{NE, 0, Int64, 0}
end

const P1 = P1ShapeDesc{
0,  # MD
1,  # NV
0,  # NF
NoSuchShapeDesc,  # FD
0,  # NE
NoSuchShapeDesc,  # ED
1, # N1OV
0 # NSHIFTS
}(NoSuchShape, SMatrix{0, 0}(Int64[]), NoSuchShape, SMatrix{0, 0}(Int64[]))

"""
    L2ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

Shape descriptor of a line segment shape.
"""
struct L2ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 1, Int64, 2}
    edgetdesc::ED
    edgets::SMatrix{NE, 0, Int64, 0}
end

const L2 = L2ShapeDesc{
1,  # MD
2,  # NV
2,  # NF
P1ShapeDesc,  # FD
0,  # NE
NoSuchShapeDesc,  # ED
2, # N1OV
0 # NSHIFTS
}(P1, SMatrix{2, 1}([1; 2]), NoSuchShape, SMatrix{0, 0}(Int64[]))

"""
    Q4ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

Shape descriptor of a quadrilateral shape.
"""
struct Q4ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 2, Int64, 4*2}
    edgetdesc::ED
    edgets::SMatrix{NE, 1, Int64, 4*1}
end

const Q4 = Q4ShapeDesc{
2,  # MD
4,  # NV
4,  # NF
L2ShapeDesc, # FD
4,  # NE
P1ShapeDesc,  # ED
4,  # N1OV
4 # NSHIFTS
}(L2, SMatrix{4, 2}([1 2; 2 3; 3 4; 4 1]), P1, SMatrix{4, 1}([1; 2; 3; 4]))

"""
    H8ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

Shape descriptor of a hexahedral shape.
"""
struct H8ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 4, Int64, 6*4}
    edgetdesc::ED
    edgets::SMatrix{NE, 2, Int64, 12*2}
end

const H8 = H8ShapeDesc{
3,  # MD
8,  # NV
6,  # NF
Q4ShapeDesc, # FD
12, # NE
L2ShapeDesc, # ED
8, # N1OV
0 # NSHIFTS
}(Q4, SMatrix{6, 4}(
[1 4 3 2;
1 2 6 5;
2 3 7 6;
3 4 8 7;
4 1 5 8;
6 7 8 5]), L2, SMatrix{12, 2}([1 2; 2 3; 3 4; 4 1; 5 6; 6 7; 7 8; 8 5; 1 5; 2 6; 3 7; 4 8;];))

"""
    T3ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

Shape descriptor of a triangular shape.
"""
struct T3ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 2, Int64, 3*2}
    edgetdesc::ED
    edgets::SMatrix{NE, 1, Int64, 3*1}
end

const T3 = T3ShapeDesc{2, # MD
3, # NV
3, # NF
L2ShapeDesc, # FD
3, # NE
P1ShapeDesc, # ED
3, # N1OV
3 # NSHIFTS
}(L2, SMatrix{3, 2}([1 2; 2 3; 3 1]), P1, SMatrix{3, 1}([1; 2; 3]))

"""
    T4ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}

Shape descriptor of a tetrahedral shape.
"""
struct T4ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 3, Int64, 4*3}
    edgetdesc::ED
    edgets::SMatrix{NE, 2, Int64, 6*2}
end

const T4 = T4ShapeDesc{3,  # MD
4,  # NV
4,  # NF
T3ShapeDesc, # FD
6,  # NE
L2ShapeDesc, # ED
4, # N1OV
0 # NSHIFTS
}(T3, SMatrix{4, 3}([1 3 2; 1 2 4; 2 3 4; 1 4 3]), L2, SMatrix{6, 2}([1  2; 2  3; 3  1; 4  1; 4  2; 4  3]))

"""
    SHAPE_DESC

Dictionary of all the descriptors.
"""
const SHAPE_DESC = Dict("P1"=>P1, "L2"=>L2, "T3"=>T3, "T4"=>T4, "Q4"=>Q4, "H8"=>H8)
