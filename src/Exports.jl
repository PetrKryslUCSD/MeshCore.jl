module Exports

###############################################################################
using ..MeshCore: AbsAttrib, VecAttrib
using ..MeshCore: datavaluetype

export AbsAttrib, VecAttrib
export datavaluetype

###############################################################################
using ..MeshCore: AbsShapeDesc, NoSuchShapeDesc, P1ShapeDesc, L2ShapeDesc, Q4ShapeDesc, H8ShapeDesc, T3ShapeDesc, T4ShapeDesc, L3ShapeDesc, T6ShapeDesc, Q8ShapeDesc
using ..MeshCore: manifdim, nvertices, nfacets, nridges, n1storderv, nshifts
using ..MeshCore: nfeatofdim
using ..MeshCore: SHAPE_DESC, NoSuchShape, P1, L2, T3, T4, Q4, H8, L3, T6, Q8

export AbsShapeDesc, NoSuchShapeDesc, P1ShapeDesc, L2ShapeDesc, Q4ShapeDesc, H8ShapeDesc, T3ShapeDesc, T4ShapeDesc, L3ShapeDesc, T6ShapeDesc, Q8ShapeDesc
export manifdim, n1storderv, nfacets, nridges, nshifts, nvertices
export nfeatofdim
export SHAPE_DESC, NoSuchShape, P1, L2, T3, T4, Q4, H8, L3, T6, Q8

###############################################################################
using ..MeshCore: ShapeColl
using ..MeshCore: shapedesc, nshapes, manifdim, nvertices, facetdesc, nfacets, facetconnectivity, ridgedesc, nridges, ridgeconnectivity, attribute

export ShapeColl
export shapedesc, nshapes, manifdim, nvertices, facetdesc, nfacets, facetconnectivity, ridgedesc, nridges, ridgeconnectivity, attribute

###############################################################################
using ..MeshCore: IncRel
using ..MeshCore: indextype, nrelations, nentities, retrieve, ir_code
using ..MeshCore: ir_boundary, ir_subset
using ..MeshCore: ir_skeleton, ir_transpose, ir_bbyfacets, ir_bbyfacets, ir_identity

export IncRel
export indextype, nrelations, nentities, retrieve, ir_code
export ir_boundary, ir_subset
export ir_skeleton, ir_transpose, ir_bbyfacets, ir_bbyfacets, ir_identity

end # module
