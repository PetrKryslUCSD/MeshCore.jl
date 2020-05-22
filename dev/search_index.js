var documenterSearchIndex = {"docs":
[{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Table of contents","category":"page"},{"location":"guide/guide.html#Guide-1","page":"Guide","title":"Guide","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Contents:","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Glossary\nExample\nBasic objects\nDerived Incidence Relations","category":"page"},{"location":"guide/guide.html#Glossary-1","page":"Guide","title":"Glossary","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Incidence relation: Map from one shape collection to another shape collection. For instance, three-dimensional finite elements (cells) are typically linked to the vertices by the incidence relation (30), i. e. for each tetrahedron the four vertices are listed. Some incidence relations link a shape to a fixed number of other shapes, other incidence relations are of variable arity. This is what is usually understood as a \"mesh\".\nShape: topological shape of any manifold dimension, 0 for vertices, 1 for edges, 2 for faces, and 3 for cells.\nShape descriptor: description of the type of the shape, such as the number of vertices, facets, ridges, and so on.\nShape collection: set of shapes of a particular shape description.\nFacet: shape bounding another shape. A shape is bounded by facets.\nRidge: shape one manifold dimension lower than the facet. For instance a tetrahedron is bounded by facets, which in turn are bounded by edges. These edges are the \"ridges\" of the tetrahedron.  The ridges can also be thought of as a \"leaky\" bounding shapes of 3-D cells.\nMesh topology: The mesh topology can be understood as an incidence relation between two shape collections.\nIncidence relation operations: The operations defined in the library are the skeleton, the transpose, the bounded-by for facets, and bounded-by for ridges.","category":"page"},{"location":"guide/guide.html#Example-1","page":"Guide","title":"Example","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Please refer to the MeshTutor.jl package for a tutorial on the use of the library.","category":"page"},{"location":"guide/guide.html#Basic-objects-1","page":"Guide","title":"Basic objects","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The objects with which the library works are the incidence relations (IncRel), the shape descriptors (subtypes of AbstractShapeDesc), and the shape collections (ShapeColl).","category":"page"},{"location":"guide/guide.html#Geometry-1","page":"Guide","title":"Geometry","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The locations are points in space. They are defined for the vertices.","category":"page"},{"location":"guide/guide.html#Shape-descriptors-and-shape-collections-1","page":"Guide","title":"Shape descriptors and shape collections","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The shape collections are homogeneous collections of  shapes such as the usual vertices (0-dimensional manifolds), line segments (1-dimensional manifolds), triangles and quadrilaterals (2-dimensional manifolds), tetrahedra and hexahedra (3-dimensional manifolds). The shape descriptors describe the topology of one entity of the shape.","category":"page"},{"location":"guide/guide.html#Incidence-relations-1","page":"Guide","title":"Incidence relations","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The incidence relations are really definitions of meshes where one shape collection, the one on the left of the incidence relation, is mapped to N entities in the shape collection on the right.","category":"page"},{"location":"guide/guide.html#Topology-of-meshes-1","page":"Guide","title":"Topology of meshes","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Meshes are understood here simply as incidence relations. For instance, at the simplest level meshes are defined by the connectivity. The connectivity is the incidence relation linking the shape (d-dimensional manifold, where d ge 0) to the set of vertices.  The number of vertices connected by the shapes is a fixed number, for instance 4 for linear tetrahedra.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The collection of d-dimensional shapes is thus defined by the connectivity (d0). The starting point for the processing of  the mesh is typically a two-dimensional or three-dimensional mesh. Let us say we start with a three dimensional mesh, so the basic data structure consists of the incidence relation (30). The incidence relation (20) can be derived by application of the method skeleton. Repeated application of the skeleton method will yield the relation (10), and finally (00). Note that at difference to other definitions of the incidence relation (00) (Logg 2008) this relation is one-to-one, not one-to-many.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The table below shows the incidence relations (connectivity) that are the basic information for generated or imported meshes. For instance a surface mesh composed of triangles will start from the incidence relation 2 rightarrow 0. No other incidence relation from the table will exist at that point.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 (00) ––– ––– –––\n1 (10) ––– ––– –––\n2 (20) ––– ––– –––\n3 (30) ––– ––– –––","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The relation (00) is trivial: Vertex is incident upon itself. Hence it may not be worthwhile  to actually create a shape collection for this relation. It is included for completeness only, really.","category":"page"},{"location":"guide/guide.html#Derived-Incidence-Relations-1","page":"Guide","title":"Derived Incidence Relations","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The incidence relations computable with the library are summarized in the table below. They include the initial incidence relation  in the first column of the table (connectivity of the first mesh), and the subsequently available incidence relations in the rest of the table. Some of these relations are defined for meshes derived from the initial mesh.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 (00) (01) (02) (03)\n1 (10) ––– (12) (13)\n2 (20) (21) ––– (23)\n3 (30) (31) (32) –––","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"In general the relations below the diagonal require the calculation of derived meshes. The relations above the diagonal are obtained by the so-called transpose operation, and do not require the construction of new meshes. Also, the relations below the diagonal are of fixed size. That is the number of entities incident on a given entity is a fixed number that can be determined beforehand. An example is  the relation (32), where for the j-th cell the list consists of the faces bounding the cell.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"On the other hand, the relations above the diagonal are in general of variable length. For example the relation (23) represents the cells which are bounded by a face: so either 2 or 1 cells.","category":"page"},{"location":"guide/guide.html#Incidence-relations-(d,0)-1","page":"Guide","title":"Incidence relations (d0)","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The table below summarizes the incidence relations that represent  the initial meshes.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 (00) ––– ––– –––\n1 (10) ––– ––– –––\n2 (20) ––– ––– –––\n3 (30) ––– ––– –––","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"For instance, for a surface mesh the relation (20) is defined initially. The relations above that can be calculated with the skeleton function. So,  the skeleton of the surface mesh would consist of all the edges in the mesh, expressible as the incidence relation  (10).","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Note that the skeleton method constructs a derived mesh: the incidence relations in the column of the above table are therefore defined for related, but separate, meshes.","category":"page"},{"location":"guide/guide.html#Incidence-relations-(d,d-1)-1","page":"Guide","title":"Incidence relations (dd-1)","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"This incidence relation provides for each shape the list of shapes by which the shape is bounded of manifold dimension lower by one. For example, for each triangular face (manifold dimension 2), the relationship would state the global numbers of edges (manifold dimension 1) by which the triangle face is bounded.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 ––– ––– ––– –––\n1 (10) ––– ––– –––\n2 ––– (21) ––– –––\n3 ––– ––– (32) –––","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The incidence  relation (dd-1) may be derived with the function bbyfacets, which operates on two shape collections: the shapes of dimension d and the facet shapes of dimension d-1.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The relationship (1 0) can be derived in two ways: from the incidence relation (20) by the skeleton function, or by the bbyfacets function applied to a shape collection of edges and  a shape collection of the vertices.","category":"page"},{"location":"guide/guide.html#Incidence-relations-(d,d-2)-1","page":"Guide","title":"Incidence relations (dd-2)","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"This incidence relation provides for each shape the list of shapes by which the shape is \"bounded\" of manifold dimension lower by two. For example, for each triangular face (manifold dimension 2), the relationship would state the global numbers of vertices (manifold dimension 0) by which the triangle face is \"bounded\". The word \"bounded\" is in quotes because the relationship of bounding is very leaky: Clearly we do not cover most of the boundary, only the vertices.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Similar relationship can be derived for instance between tetrahedra and the edges (31). Again, the incidence relation is very leaky in that it provides cover for the edges of the tetrahedron.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 ––– ––– ––– –––\n1 ––– ––– ––– –––\n2 (20) ––– ––– –––\n3 ––– (31) ––– –––","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The relationship (2 0) can be derived in two ways: from the incidence relation (3 0) by the skeleton function, or by the bbyfacets function applied to a shape collection of cells and  a shape collection of the edges.","category":"page"},{"location":"guide/guide.html#Incidence-relations-(d_1,d_2),-where-d_1-\\lt-d_2-1","page":"Guide","title":"Incidence relations (d_1d_2), where d_1 lt d_2","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The relations above the diagonal of the table below are lists of shapes incident on lower-dimension shapes. These are computed from the incidence relations from the lower triangle of the table by the function increl_transpose.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 ––– (01) (02) (03)\n1 ––– ––– (12) (13)\n2 ––– ––– ––– (23)\n3 ––– ––– ––– –––","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The incidence relations in the upper triangle of the table are all of variable arity: for instance the incidence relation (13) is the list of three-dimensional cells that share a given edge. Clearly the number of cells varies from edge to edge.","category":"page"},{"location":"guide/guide.html#Incidence-relations-(d,d),-where-d-\\gt-1-1","page":"Guide","title":"Incidence relations (dd), where d gt 1","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"These incidence relations do not fit the table referenced many times above. The definition of such a relation is not unique:  It needs to refer to a connecting shape. For instance, the relationship between faces,   (22), needs to state through which shape the incidence occurs: is it through the common vertex? Is it through a common edge? Similarly, for cells the incidence relationship (33) will be different for the incidence to follow from a common vertex, a common edge, or a common face.","category":"page"},{"location":"guide/guide.html#How-incidence-relations-are-computed-1","page":"Guide","title":"How incidence relations are computed","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"For definiteness here we assume that the initial mesh (i. e. the incidence relation) is 30. The other 12 relations in the table below can be computed by applying the four procedures: skeleton (sk), bounded-by-facet (bf), bounded-by-ridges (be), and transpose (tr).","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 sk((10)) tr((10)) tr((20)) tr((30))\n1 sk((20)) ––– tr((21)) tr((31))\n2 sk((30)) bf((20(1,0)(0,1)``) ––– tr((32))\n3 (30) be((30), (10), (01)) bf((30), (20), (02)) –––","category":"page"},{"location":"index.html#MeshCore-Documentation-1","page":"Home","title":"MeshCore Documentation","text":"","category":"section"},{"location":"index.html#Conceptual-guide-1","page":"Home","title":"Conceptual guide","text":"","category":"section"},{"location":"index.html#","page":"Home","title":"Home","text":"The concepts and ideas are described.","category":"page"},{"location":"index.html#","page":"Home","title":"Home","text":"Pages = [\n    \"guide/guide.md\",\n]\nDepth = 1","category":"page"},{"location":"index.html#Manual-1","page":"Home","title":"Manual","text":"","category":"section"},{"location":"index.html#","page":"Home","title":"Home","text":"The description of the types and of the functions.","category":"page"},{"location":"index.html#","page":"Home","title":"Home","text":"Pages = [\n    \"man/types.md\",\n    \"man/functions.md\",\n]\nDepth = 3","category":"page"},{"location":"man/types.html#Types-1","page":"Types","title":"Types","text":"","category":"section"},{"location":"man/types.html#","page":"Types","title":"Types","text":"CurrentModule = MeshCore","category":"page"},{"location":"man/types.html#Shape-descriptors-1","page":"Types","title":"Shape descriptors","text":"","category":"section"},{"location":"man/types.html#","page":"Types","title":"Types","text":"AbsShapeDesc\nNoSuchShapeDesc\nP1ShapeDesc\nL2ShapeDesc\nQ4ShapeDesc\nH8ShapeDesc\nT3ShapeDesc\nT4ShapeDesc\nSHAPE_DESC","category":"page"},{"location":"man/types.html#MeshCore.AbsShapeDesc","page":"Types","title":"MeshCore.AbsShapeDesc","text":"AbsShapeDesc\n\nAbstract shape descriptor (simplex, or cuboid, of various manifold dimension)\n\nThe definitions of concrete types below define a set of shape descriptors, covering the usual element shapes: point, line segment, quadrilateral, hexahedron, and a similar hierarchy for the simplex elements: point, line segment, triangle, tetrahedron.\n\nThe concrete types of the shape descriptor will provide access to the following properties of the shape S:\n\nmanifdim = manifold dimension of the shape S (i. e. 0, 1, 2, or 3),\nnvertices = number of vertices of the shape S,\nn1storderv = number of first-order vertices for the shape S, for instance   a 6-node triangle has 3 first-order vertices,\nnfacets = number of shapes on the boundary of the shape S,\nfacetdesc = shape descriptor of the shapes on the boundary of the shape S,\nfacets = definitions of the shapes on the boundary of the shape S in terms   of local connectivity\nridgedesc = shape descriptor of the shapes on the boundary of the boundary of the shape S (which we call ridges here),\nridges = definitions of the shapes on the boundary of the boundary of the shape S in terms of local connectivity\n\nThe bit-type values are defined with the type parameters:\n\nMD is the manifold dimension, \nNV is the number of connected vertices, \nNF is the number of boundary facets, \nFD is the descriptor of the facet (boundary shape).\nNE is the number of boundary ridges, \nED is the descriptor of the ridge (boundary shape).\nNFOV is number of first-order vertices, \nNSHIFTS is the number of shifts that should be attempted when matching shapes to determine orientation.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.NoSuchShapeDesc","page":"Types","title":"MeshCore.NoSuchShapeDesc","text":"NoSuchShapeDesc\n\nBase descriptor: no shape is of this description.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.P1ShapeDesc","page":"Types","title":"MeshCore.P1ShapeDesc","text":"P1ShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nShape descriptor of a point shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.L2ShapeDesc","page":"Types","title":"MeshCore.L2ShapeDesc","text":"L2ShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nShape descriptor of a line segment shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.Q4ShapeDesc","page":"Types","title":"MeshCore.Q4ShapeDesc","text":"Q4ShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nShape descriptor of a quadrilateral shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.H8ShapeDesc","page":"Types","title":"MeshCore.H8ShapeDesc","text":"H8ShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nShape descriptor of a hexahedral shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.T3ShapeDesc","page":"Types","title":"MeshCore.T3ShapeDesc","text":"T3ShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nShape descriptor of a triangular shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.T4ShapeDesc","page":"Types","title":"MeshCore.T4ShapeDesc","text":"T4ShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nShape descriptor of a tetrahedral shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.SHAPE_DESC","page":"Types","title":"MeshCore.SHAPE_DESC","text":"SHAPE_DESC\n\nDictionary of all the descriptors.\n\n\n\n\n\n","category":"constant"},{"location":"man/types.html#Shape-collections-1","page":"Types","title":"Shape collections","text":"","category":"section"},{"location":"man/types.html#","page":"Types","title":"Types","text":"ShapeColl{S <: AbsShapeDesc}","category":"page"},{"location":"man/types.html#MeshCore.ShapeColl","page":"Types","title":"MeshCore.ShapeColl","text":"ShapeColl{S <: AbsShapeDesc}\n\nThis is the type of a homogeneous collection of finite element shapes.\n\nS = shape descriptor: subtype of AbsShapeDesc.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#Attributes-1","page":"Types","title":"Attributes","text":"","category":"section"},{"location":"man/types.html#","page":"Types","title":"Types","text":"AbsAttrib\nAttrib{F}\nAttribDataWrapper{T}","category":"page"},{"location":"man/types.html#MeshCore.AbsAttrib","page":"Types","title":"MeshCore.AbsAttrib","text":"AbsAttrib\n\nAbstract type of attribute. It is a subtype of AbstractArray.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#Incidence-relations-1","page":"Types","title":"Incidence relations","text":"","category":"section"},{"location":"man/types.html#","page":"Types","title":"Types","text":"IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}","category":"page"},{"location":"man/types.html#MeshCore.IncRel","page":"Types","title":"MeshCore.IncRel","text":"IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}\n\nIncidence relation expressing connectivity between an entity of the shape on the left and a list of entities of the shape on the right.\n\nThe incidence relation may be referred to by its code: (d1, d2), where d1 is the manifold dimension of the shape collection on the left, and d2 is the manifold dimension of the shape collection on the right.\n\n\n\n\n\n","category":"type"},{"location":"man/functions.html#Functions-1","page":"Functions","title":"Functions","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"CurrentModule = MeshCore","category":"page"},{"location":"man/functions.html#Shapes-1","page":"Functions","title":"Shapes","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"ShapeColl(shapedesc::S, nshapes::Int64) where {S <: AbsShapeDesc}\nShapeColl(shapedesc::S, nshapes::Int64, d::Dict) where {S <: AbsShapeDesc}\nShapeColl(shapedesc::S, nshapes::Int64, s::String) where {S <: AbsShapeDesc}\nshapedesc\nnshapes\nmanifdim\nnvertices\nfacetdesc\nnfacets\nfacetconnectivity\nridgedesc\nnridges\nridgeconnectivity\nn1storderv\nnshifts\nattribute","category":"page"},{"location":"man/functions.html#MeshCore.ShapeColl-Union{Tuple{S}, Tuple{S,Int64}} where S<:MeshCore.AbsShapeDesc","page":"Functions","title":"MeshCore.ShapeColl","text":"ShapeColl(shapedesc::S, nshapes::Int64) where {S <: AbsShapeDesc}\n\nSet up new shape collection with an empty dictionary of attributes and a default name.\n\n\n\n\n\n","category":"method"},{"location":"man/functions.html#MeshCore.ShapeColl-Union{Tuple{S}, Tuple{S,Int64,String}} where S<:MeshCore.AbsShapeDesc","page":"Functions","title":"MeshCore.ShapeColl","text":"ShapeColl(shapedesc::S, nshapes::Int64, s::String) where {S <: AbsShapeDesc}\n\nSet up new shape collection with an empty dictionary of attributes.\n\n\n\n\n\n","category":"method"},{"location":"man/functions.html#MeshCore.shapedesc","page":"Functions","title":"MeshCore.shapedesc","text":"shapedesc(shapes::ShapeColl)\n\nRetrieve the shape descriptor.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.nshapes","page":"Functions","title":"MeshCore.nshapes","text":"nshapes(shapes::ShapeColl)\n\nNumber of shapes in the collection.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.manifdim","page":"Functions","title":"MeshCore.manifdim","text":"manifdim(sd::AbsShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nWhat is the manifold dimension of this shape?\n\n\n\n\n\nmanifdim(shapes::ShapeColl)\n\nRetrieve the manifold dimension of the collection.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.nvertices","page":"Functions","title":"MeshCore.nvertices","text":"nvertices(sd::AbsShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nHow many vertices does the shape connect?\n\n\n\n\n\nnvertices(shapes::ShapeColl)\n\nRetrieve the number of vertices per shape.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.facetdesc","page":"Functions","title":"MeshCore.facetdesc","text":"facetdesc(shapes::ShapeColl)\n\nRetrieve the shape type of the boundary facet.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.nfacets","page":"Functions","title":"MeshCore.nfacets","text":"nfacets(sd::AbsShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nHow many facets bound the shape?\n\n\n\n\n\nnfacets(shapes::ShapeColl)\n\nRetrieve the number of boundary facets per shape.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.facetconnectivity","page":"Functions","title":"MeshCore.facetconnectivity","text":"facetconnectivity(shapes::ShapeColl, j::Int64)\n\nRetrieve connectivity of the j-th facet shape of the i-th shape from the collection.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.ridgedesc","page":"Functions","title":"MeshCore.ridgedesc","text":"ridgedesc(shapes::ShapeColl)\n\nRetrieve the shape type of the boundary ridge.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.nridges","page":"Functions","title":"MeshCore.nridges","text":"nridges(sd::AbsShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nHow many ridges bound the shape?\n\n\n\n\n\nnridges(shapes::ShapeColl)\n\nRetrieve the number of boundary ridges per shape.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.ridgeconnectivity","page":"Functions","title":"MeshCore.ridgeconnectivity","text":"ridgeconnectivity(shapes::ShapeColl, j::Int64)\n\nRetrieve connectivity of the j-th ridge shape of the i-th shape from the collection.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.n1storderv","page":"Functions","title":"MeshCore.n1storderv","text":"n1storderv(sd::AbsShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nHow many 1st-order vertices are there per shape?\n\nFor instance, for hexahedra each shape has 8 1st-order vertices.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.nshifts","page":"Functions","title":"MeshCore.nshifts","text":"nshifts(sd::AbsShapeDesc{MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NE, RD, NFOV, NSHIFTS}\n\nHow many circular shifts should be tried to figure out the orientation (sense)?\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.attribute","page":"Functions","title":"MeshCore.attribute","text":"attribute(shapes::ShapeColl, s::Symbol)\n\nRetrieve a named attribute.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#Incidence-relations-1","page":"Functions","title":"Incidence relations","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, v::Vector{T}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}\nIncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{MT}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}\nindextype\nnrelations\nnentities\nretrieve","category":"page"},{"location":"man/functions.html#MeshCore.IncRel-Union{Tuple{T}, Tuple{RIGHT}, Tuple{LEFT}, Tuple{MeshCore.ShapeColl{LEFT},MeshCore.ShapeColl{RIGHT},Array{T,1}}} where T where RIGHT<:MeshCore.AbsShapeDesc where LEFT<:MeshCore.AbsShapeDesc","page":"Functions","title":"MeshCore.IncRel","text":"IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{MT}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}\n\nConvenience constructor with a vector of vectors and a default name.\n\n\n\n\n\n","category":"method"},{"location":"man/functions.html#MeshCore.IncRel-Union{Tuple{MT}, Tuple{RIGHT}, Tuple{LEFT}, Tuple{MeshCore.ShapeColl{LEFT},MeshCore.ShapeColl{RIGHT},Array{MT,2}}} where MT where RIGHT<:MeshCore.AbsShapeDesc where LEFT<:MeshCore.AbsShapeDesc","page":"Functions","title":"MeshCore.IncRel","text":"IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{MT}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}\n\nConvenience constructor supplying a matrix instead of a vector of vectors and a default name.\n\n\n\n\n\n","category":"method"},{"location":"man/functions.html#MeshCore.indextype","page":"Functions","title":"MeshCore.indextype","text":"indextype(ir::IncRel)\n\nProvide type of the incidence index (entity number). Presumably some type of integer.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.nrelations","page":"Functions","title":"MeshCore.nrelations","text":"nrelations(ir::IncRel)\n\nNumber of individual relations in the incidence relation.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.nentities","page":"Functions","title":"MeshCore.nentities","text":"nentities(ir::IncRel, j::IT) where {IT}\n\nNumber of individual entities in the j-th relation in the incidence relation.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.retrieve","page":"Functions","title":"MeshCore.retrieve","text":"retrieve(ir::IncRel{LEFT, RIGHT, T}, j::IT1, k::IT2) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T, IT1, IT2}\n\nRetrieve the incidence relation for j-th relation, k-th entity.\n\n\n\n\n\nretrieve(ir::IncRel{LEFT, RIGHT, T}, j::IT) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T, IT}\n\nRetrieve the row of the incidence relation for j-th relation.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#Relations-below-the-diagonal-1","page":"Functions","title":"Relations below the diagonal","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"skeleton\nboundary\nbbyfacets\nbbyridges","category":"page"},{"location":"man/functions.html#MeshCore.skeleton","page":"Functions","title":"MeshCore.skeleton","text":"skeleton(ir::IncRel, name = \"skt\")\n\nCompute the skeleton of an incidence relation.\n\nThis computes a new incidence relation from an existing incidence relation.\n\nOptions\n\nboundaryonly: include in the skeleton only shapes on the boundary   of the input collection, true or false (default).\n\nReturns\n\nIncidence relation for the skeleton of the input incidence relation. The left shape collection consists of facets (shapes of manifold dimension one less than the manifold dimension of the shapes themselves). The right shape collection is the same as for the input.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.boundary","page":"Functions","title":"MeshCore.boundary","text":"boundary(ir::IncRel, name = \"bdr\")\n\nCompute the incidence relation for the boundary of the incidence relation on input.\n\nThe skeleton function.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.bbyfacets","page":"Functions","title":"MeshCore.bbyfacets","text":"bbyfacets(ir::IncRel, fir::IncRel, tfir::IncRel, name = \"bbf\")\n\nCompute the incidence relation (d, d-1) for d-dimensional shapes.\n\nIn other words, this is the incidence relation between shapes and the shapes that bound these shapes (facets). For tetrahedra as the shapes, the incidence relation lists the numbers of the faces that bound each individual tetrahedron. The resulting left shape is of the same shape description as in the ir.\n\nArguments\n\nir = incidence relation (d, 0),\nfir = incidence relation (d-1, 0),\ntfir = transpose of the above, incidence relation (0, d-1).\n\nReturns\n\nIncidence relation for the bounded-by relationship between shape collections. The left shape collection is the same as for the ir, the right shape collection is for the facets (shapes of manifold dimension one less than the manifold dimension of the shapes themselves).\n\nnote: Note\nThe numbers of the facets are signed: positive when the facet bounds the shape in the sense in which it is defined by the shape as oriented with an outer normal; negative otherwise. The sense is defined by the numbering of the 1st-order vertices of the facet shape.\n\n\n\n\n\nbbyfacets(ir::IncRel, fir::IncRel, name = \"bbf\")\n\nCompute the incidence relation (d, d-1) for d-dimensional shapes.\n\nConvenience function where the transpose of the incidence relation on the right is computed on the fly.\n\nSee also: bbyfacets(ir::IncRel, fir::IncRel, tfir::IncRel)\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.bbyridges","page":"Functions","title":"MeshCore.bbyridges","text":"bbyridges(ir::IncRel, eir::IncRel, teir::IncRel, name = \"bbr\")\n\nCompute the incidence relation (d, d-2) for d-dimensional shapes.\n\nIn other words, this is the incidence between shapes and the shapes that \"bound\" the boundaries of these shapes (i. e. ridges). For tetrahedra as the shapes, the incidence relation lists the numbers of the edges that \"bound\" each individual tetrahedron. The resulting shape is of the same shape description as the shapes on input.\n\nReturns\n\nThe incidence relation for the \"bounded by\" relationship between shape collections. The left shape collection is the same as for the ir, the right shape collection is for the ridges (shapes of manifold dimension two less than the manifold dimension of the shapes themselves).\n\nnote: Note\nThe numbers of the ridges are signed: positive when the ridge bounds the shape in the sense in which it is defined by the shape as oriented with an outer normal; negative otherwise. The sense is defined by the numbering of the 1st-order vertices of the ridge shape.\n\n\n\n\n\nbbyridges(ir::IncRel, eir::IncRel, name = \"bbr\")\n\nCompute the incidence relation (d, d-2) for d-dimensional shapes.\n\nConvenience function where the transpose of the incidence relation on the right is computed on the fly.\n\nSee also: bbyridges(ir::IncRel, eir::IncRel, efir::IncRel)\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#Relations-above-the-diagonal-1","page":"Functions","title":"Relations above the diagonal","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"transpose(mesh::IncRel)","category":"page"},{"location":"man/functions.html#MeshCore.transpose-Tuple{MeshCore.IncRel}","page":"Functions","title":"MeshCore.transpose","text":"transpose(ir::IncRel, name = \"trp\")\n\nCompute the incidence relation (d1, d2), where d2 >= d1.\n\nThis only makes sense for d2 >= 0. For d2=1 we get for each vertex the list of edges connected to the vertex, and analogously faces and cells for d=2 and d=3.\n\nReturns\n\nIncidence relation for the transposed incidence relation. The left and right shape collection are swapped in the output relative to the input.\n\n\n\n\n\n","category":"method"},{"location":"man/functions.html#Attributes-1","page":"Functions","title":"Attributes","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"nvals(d::AttribDataWrapper{T}) where {T} \nval(d::AttribDataWrapper{T}, j::Int64) where {T}\n(d::AttribDataWrapper{T})(j::Int64) where {T}","category":"page"},{"location":"man/functions.html#Index-1","page":"Functions","title":"Index","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"","category":"page"}]
}
