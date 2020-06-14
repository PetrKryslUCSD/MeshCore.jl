
"""
    AbsShapeDesc

Abstract shape descriptor (simplex, or cuboid, of various manifold dimension)

The definitions of concrete types below define a set of shape descriptors,
covering the usual element shapes: point, line segment, quadrilateral,
hexahedron, and a similar hierarchy for the simplex elements: point, line
segment, triangle, tetrahedron.

The concrete types of the shape descriptor will provide access to the following
properties of the shape S:
- `manifdim` = manifold dimension of the shape S (i. e. 0, 1, 2, or 3),
- `nvertices` = number of vertices of the shape S,
- `n1storderv` = number of first-order vertices for the shape S, for instance
    a 6-node triangle has 3 first-order vertices,
- `nfacets` = number of shapes on the boundary of the shape S,
- `facetdesc` = shape descriptor of the shapes on the boundary of the shape S,
- `facets` = definitions of the shapes on the boundary of the shape S in terms
    of local connectivity
- `ridgedesc` = shape descriptor of the shapes on the boundary of the boundary
  of the shape S (which we call ridges here),
- `ridges` = definitions of the shapes on the boundary of the boundary of the
  shape S in terms of local connectivity

The bit-type values are defined with the type parameters:
- `MD` is the manifold dimension, 
- `NV` is the number of connected vertices, 
- `NF` is the number of boundary facets, 
- `FD` is the descriptor of the facet (boundary shape).
- `NR` is the number of boundary ridges, 
- `RD` is the descriptor of the ridge (boundary shape).
- `NFOV` is number of first-order vertices, 
- `NSHIFTS` is the number of shifts that should be attempted when matching
  shapes to determine orientation.
"""
abstract type AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
end

"""
    manifdim(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

What is the manifold dimension of this shape?
"""
manifdim(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} = MD

"""
    nvertices(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

How many vertices does the shape connect?
"""
nvertices(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} = NV

"""
    nfacets(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

How many facets bound the shape?
"""
nfacets(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} = NF

"""
    nridges(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

How many ridges bound the shape?
"""
nridges(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} = NR

"""
    n1storderv(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

How many 1st-order vertices are there per shape?

For instance, for hexahedra each shape has 8 1st-order vertices.
"""
n1storderv(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} = NFOV

"""
    nshifts(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

How many circular shifts should be tried to figure out the orientation (sense)?
"""
nshifts(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} = NSHIFTS

"""
    NoSuchShapeDesc

Base descriptor: no shape is of this description.
"""
struct NoSuchShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
end

const NoSuchShape = NoSuchShapeDesc{
0,  # MD
0,  # NV
0,  # NF
0,  # FD
0,  # NR
0,  # RD
0, # NFOV
0 # NSHIFTS
}()

"""
    P1ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

Shape descriptor of a point shape.
"""
struct P1ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 0, Int64, 0}
    ridgedesc::RD
    ridges::SMatrix{NR, 0, Int64, 0}
    name::String
end

const P1 = P1ShapeDesc{
0,  # MD
1,  # NV
0,  # NF
NoSuchShapeDesc,  # FD
0,  # NR
NoSuchShapeDesc,  # RD
1, # NFOV
0 # NSHIFTS
}(NoSuchShape, SMatrix{0, 0}(Int64[]), NoSuchShape, SMatrix{0, 0}(Int64[]), "P1")

"""
    L2ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

Shape descriptor of a line segment shape.
"""
struct L2ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 1, Int64, 2}
    ridgedesc::RD
    ridges::SMatrix{NR, 0, Int64, 0}
    name::String
end

const L2 = L2ShapeDesc{
1,  # MD
2,  # NV
2,  # NF
P1ShapeDesc,  # FD
0,  # NR
NoSuchShapeDesc,  # RD
2, # NFOV
0 # NSHIFTS
}(P1, SMatrix{2, 1}([1; 2]), NoSuchShape, SMatrix{0, 0}(Int64[]), "L2")

"""
    Q4ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

Shape descriptor of a quadrilateral shape.

Facets: First the two orthogonal to xi, then the two orthogonal to eta. The
coordinate along the edge increases.

Ridges: Counterclockwise.
"""
struct Q4ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 2, Int64, 4*2}
    ridgedesc::RD
    ridges::SMatrix{NR, 1, Int64, 4*1}
    name::String
end

const Q4 = Q4ShapeDesc{
2,  # MD
4,  # NV
4,  # NF
L2ShapeDesc, # FD
4,  # NR
P1ShapeDesc,  # RD
4,  # NFOV
4 # NSHIFTS
}(L2, SMatrix{4, 2}([1 4; 2 3; 1 2; 4 3]), P1, SMatrix{4, 1}([1; 2; 3; 4]), "Q4")

"""
    H8ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

Shape descriptor of a hexahedral shape.

Facets: First the two faces orthogonal to xi, then the two orthogonal to eta,
finally the two orthogonal to zeta. The vertices are given counterclockwise when
looking from the outside.

Ridges: First the four edges parallel to xi, then the four parallel to eta, and
finally the four parallel to zeta.
"""
struct H8ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 4, Int64, 6*4}
    ridgedesc::RD
    ridges::SMatrix{NR, 2, Int64, 12*2}
    name::String
end

const H8 = H8ShapeDesc{
3,  # MD
8,  # NV
6,  # NF
Q4ShapeDesc, # FD
12, # NR
L2ShapeDesc, # RD
8, # NFOV
0 # NSHIFTS
}(Q4, SMatrix{6, 4}(
[8 4 1 5; 7 6 2 3; 6 5 1 2; 7 3 4 8; 3 2 1 4; 7 8 5 6]), L2, SMatrix{12, 2}([8 7; 5 6; 1 2; 4 3; 6 7; 5 8; 1 4; 2 3; 3 7; 4 8; 1 5; 2 6];), "H8")

"""
    T3ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

Shape descriptor of a triangular shape.

Facets: We start with the edge opposite to vertex 1, then the edge opposite to
vertex 2 and so on. The vertices define counterclockwise orientation.

Ridges: The vertices in counterclockwise order.
"""
struct T3ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 2, Int64, 3*2}
    ridgedesc::RD
    ridges::SMatrix{NR, 1, Int64, 3*1}
    name::String
end

const T3 = T3ShapeDesc{2, # MD
3, # NV
3, # NF
L2ShapeDesc, # FD
3, # NR
P1ShapeDesc, # RD
3, # NFOV
3 # NSHIFTS
}(L2, SMatrix{3, 2}([2 3; 3 1; 1 2]), P1, SMatrix{3, 1}([1; 2; 3]), "T3")

"""
    T4ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}

Shape descriptor of a tetrahedral shape.

Facets: We start with the face opposite to vertex 1, then the face opposite to
vertex 2 and so on. The vertices define counterclockwise orientation when viewed
from outside of the shape.

Ridges: The vertices of the edges are defined in the order based on the
right-hand side rotation rule: rotate about an edge (ridge) as if it was a
rotation vector  with positive orientation. The vertices on the edge opposite
across the tetrahedron are traversed in the order given by the rotation.
"""
struct T4ShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} <: AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
    facetdesc::FD
    facets::SMatrix{NF, 3, Int64, 4*3}
    ridgedesc::RD
    ridges::SMatrix{NR, 2, Int64, 6*2}
    name::String
end

const T4 = T4ShapeDesc{3,  # MD
4,  # NV
4,  # NF
T3ShapeDesc, # FD
6,  # NR
L2ShapeDesc, # RD
4, # NFOV
0 # NSHIFTS
}(T3, SMatrix{4, 3}([2 3 4; 1 4 3; 4 1 2; 3 2 1]), L2, SMatrix{6, 2}([1 4; 2 3; 1 2; 3 4; 4 2; 1 3]), "T4")

"""
    SHAPE_DESC

Dictionary of all the descriptors.
"""
const SHAPE_DESC = Dict("P1"=>P1, "L2"=>L2, "T3"=>T3, "T4"=>T4, "Q4"=>Q4, "H8"=>H8)

"""
    nfeatofdim(sd::SD, m) where {SD <: AbsShapeDesc}

Compute number of manifold features of given dimension.

For instance, a tetrahedron with four vertices has 1 feature of manifold
dimension 3, four features of manifold dimension 2, six features of manifold
dimension 1, and four features of manifold dimension 0.
"""
function nfeatofdim(sd::SD, m) where {SD <: AbsShapeDesc}
    if m > manifdim(sd)
        return 0
    end
    if m == manifdim(sd)
        return 1
    elseif m == manifdim(sd) - 1
        return nfacets(sd)
    elseif m == manifdim(sd) - 2
        return nridges(sd)
    else
        return nvertices(sd)
    end
end
