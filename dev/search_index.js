var documenterSearchIndex = {"docs":
[{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Table of contents","category":"page"},{"location":"guide/guide.html#Guide-1","page":"Guide","title":"Guide","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Contents:","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Glossary\nExample\nBasic objects\nIncidence relations","category":"page"},{"location":"guide/guide.html#Glossary-1","page":"Guide","title":"Glossary","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Shape: topological shape of any manifold dimension, 0 for vertices, 1 for edges, 2 for faces, and 3 for cells.\nFacet: shape bounding another shape. A shape is bounded by facets.\nEdget: shape one manifold dimension lower than the facet. For instance a tetrahedron is bounded by facets, which in turn are bounded by edges. These edges are the \"edgets\" of the tetrahedron. Edgets  can be thought of as the bounding shapes of the facets.\nShape collection: set of shapes. Each shape is defined with reference to other shapes through an incidence relation.\nIncidence relation: Map from one shape to another shape. For instance, three-dimensional finite elements are defined by the incidence relation 3 rightarrow 0, i. e. for each tetrahedron the four vertices are listed. Some incidence relations link a shape to a fixed number of other shapes, other incidence relations are of variable arity.\nConnectivity: The connectivity is the incidence relation d rightarrow 0 linking the shape (d-dimensional manifold, where d ge 0) to the set of vertices (0-dimensional manifold).\nMesh: Collection of shapes. It may be also a set of collections of shapes, but it is usually quite enough  to consider a mesh and the collection of shapes to be one and the same.  \nInitial mesh: The entry point into the library. The first mesh that was defined.\nDerived mesh: Mesh derived from another mesh through an incidence relation\ncalculation.","category":"page"},{"location":"guide/guide.html#Example-1","page":"Guide","title":"Example","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Let us begin with a simple example of the use of the library: First import the mesh from a file and check that the correct number of entities were imported.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"mesh = import_NASTRAN(\"trunc_cyl_shell_0.nas\")\nvertices, shapes = mesh[\"vertices\"], mesh[\"shapes\"][1]\n@test (nvertices(vertices), nshapes(shapes)) == (376, 996)","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Extract zero-dimensional entities (points) by a triple application of the skeleton function. Check that the number of shapes is equal to the number of the vertices (in this particular skeleton they correspond one-to-one).","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"bshapes = skeleton(skeleton(skeleton(shapes)))\n@test (nvertices(vertices), nshapes(bshapes)) == (376, 376)","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Export the mesh for visualization (requires the use of the MeshPorter package).","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"vtkwrite(\"trunc_cyl_shell_0-boundary-skeleton\", vertices, bshapes)","category":"page"},{"location":"guide/guide.html#Basic-objects-1","page":"Guide","title":"Basic objects","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The objects with which the library works are the vertices and the shape collections. The vertices are points in space, and the shape collections are homogeneous collections of  shapes such as the usual vertices (0-dimensional manifolds), line segments (1-dimensional manifolds), triangles and quadrilaterals (2-dimensional manifolds), tetrahedra and hexahedra (3-dimensional manifolds).","category":"page"},{"location":"guide/guide.html#Connectivity-1","page":"Guide","title":"Connectivity","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The shapes are defined by the connectivity. The connectivity is the incidence relation linking the shape (d-dimensional manifold, where d ge 0) to the set of vertices.  The number of vertices connected by the shapes is a fixed number, for instance 8 for linear hexahedra.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The collection of d-dimensional shapes is thus defined by the connectivity d rightarrow 0. The starting point for the processing of  the mesh is typically a two-dimensional or three-dimensional mesh. Let us say we start with a three dimensional mesh, so the basic data structure consists of the incidence relation 3 rightarrow 0. The incidence relation 2 rightarrow 0 can be derived by application of the method skeleton. Repeated application of the skeleton method will yield the relation 1 rightarrow 0, and finally 0 rightarrow 0. Note that at difference to other definitions of the incidence relation 0 rightarrow 0 (Logg 2008) this relation is one-to-one, not one-to-many.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The table below shows the incidence relations (connectivity) that are the basic information for generated or imported meshes. For instance a surface mesh composed of triangles will start from the incidence relation 2 rightarrow 0. No other incidence relation from the table will exist at that point.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 0 -> 0 ––– ––– –––\n1 1 -> 0 ––– ––– –––\n2 2 -> 0 ––– ––– –––\n3 3 -> 0 ––– ––– –––","category":"page"},{"location":"guide/guide.html#Incidence-relations-1","page":"Guide","title":"Incidence relations","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The incidence relations computable with the library are summarized in the table below. They include the initial incidence relation  in the first column of the table (connectivity of the first mesh), and the subsequently available incidence relations in the rest of the table. Some of these relations are defined for meshes derived from the initial mesh.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 0 -> 0 0 -> 1 0 -> 2 0 -> 3\n1 1 -> 0 ––– 1 -> 2 1 -> 3\n2 2 -> 0 2 -> 1 ––– 2 -> 3\n3 3 -> 0 3 -> 1 3 -> 2 –––","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"In general the relations below the diagonal require the calculation of derived meshes. The relations above the diagonal are obtained by the so-called transpose operation, and do not require the construction of new meshes. Also, the relations below the diagonal are of fixed size. That is the number of entities incident on a given entity is a fixed number that can be determined beforehand. An example is  the relation 3 rightarrow 2, where for the j-th cell the list consists of the faces bounding the cell.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"On the other hand, the relations above the diagonal are in general of variable length. For example the relation 2 rightarrow 3 represents the cells which are bounded by a face: so either 2 or 1 cells.","category":"page"},{"location":"guide/guide.html#Incidence-relations-d-\\rightarrow-0-1","page":"Guide","title":"Incidence relations d rightarrow 0","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The table below summarizes the incidence relations that represent  the initial meshes.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 0 -> 0 ––– ––– –––\n1 1 -> 0 ––– ––– –––\n2 2 -> 0 ––– ––– –––\n3 3 -> 0 ––– ––– –––","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"For instance, for a surface mesh the relation 2 rightarrow 0 is defined initially. The relations above that can be calculated with the skeleton function. So,  the skeleton of the surface mesh would consist of all the edges in the mesh, expressible as the incidence relation  1 rightarrow 0.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Note that the skeleton method constructs a derived mesh: the incidence relations in the column of the above table are therefore defined for related, but separate, meshes.","category":"page"},{"location":"guide/guide.html#Incidence-relations-d-\\rightarrow-d-1-1","page":"Guide","title":"Incidence relations d rightarrow d-1","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"This incidence relation provides for each shape the list of shapes of manifold dimension lower by one by which the shape is bounded. For example, for each triangular face (manifold dimension 2), the relationship would state the global numbers of edges (manifold dimension 1) by which the triangle face is bounded.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 ––– ––– ––– –––\n1 1 -> 0 ––– ––– –––\n2 ––– 2 -> 1 ––– –––\n3 ––– ––– 3 -> 2 –––","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The incidence  relation d rightarrow d-1 may be derived with the function boundedby, which operates on two shape collections: the shapes of dimension d and the facet shapes of dimension d-1.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The relationship 1  rightarrow 0 can be derived in two ways: from the incidence relation 2 rightarrow  0 by the skeleton function, or by the boundedby function applied to a shape collection of edges and  a shape collection of the vertices.","category":"page"},{"location":"guide/guide.html#Incidence-relations-d-\\rightarrow-d-2-1","page":"Guide","title":"Incidence relations d rightarrow d-2","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"This incidence relation provides for each shape the list of shapes of manifold dimension lower by two by which the shape is \"bounded\". For example, for each triangular face (manifold dimension 2), the relationship would state the global numbers of vertices (manifold dimension 0) by which the triangle face is \"bounded\". The word \"bounded\" is in quotes because the relationship of bounding is very leaky: Clearly we do not cover most of the boundary, only the vertices.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Similar relationship can be derived for instance between tetrahedra and the edges (3 rightarrow 1). Again, the incidence relation is very leaky in that it provides cover for the edges of the tetrahedron.","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 ––– ––– ––– –––\n1 ––– ––– ––– –––\n2 2 -> 0 ––– ––– –––\n3 ––– 3 -> 1 ––– –––","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The relationship 2  rightarrow 0 can be derived in two ways: from the incidence relation 3 rightarrow  0 by the skeleton function, or by the boundedby2 function applied to a shape collection of cells and  a shape collection of the edges.","category":"page"},{"location":"guide/guide.html#Incidence-relations-0-\\rightarrow-d-1","page":"Guide","title":"Incidence relations 0 rightarrow d","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The relations in the first row of the table (0 rightarrow d) are lists of shapes incident on individual vertices. These are computed on demand by the function increl_vertextoshape. The individual incidence relations can be accessed by dispatch on the IncRelVertexToShape data. For instance, the relation 0 rightarrow 2 can be computed for 2-manifold shapes as","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"ir = increl_vertextoshape(shapes)","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Here manifdim(shapes) is 2. The incidence list of two-dimensional shapes connected to node 13 can be retrieved as ir(13).","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 ––– 0 -> 1 0 -> 2 0 -> 3\n1 ––– ––– ––– –––\n2 ––– ––– ––– –––\n3 ––– ––– ––– –––","category":"page"},{"location":"guide/guide.html#Incidence-relations-d_1-\\rightarrow-d_2-1","page":"Guide","title":"Incidence relations d_1 rightarrow d_2","text":"","category":"section"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"The relations in the first row of the table (0 rightarrow d) are lists of shapes incident on individual vertices. These are computed on demand by the function increl_vertextoshape. The individual incidence relations can be accessed by dispatch on the IncRelVertexToShape data. For instance, the relation 0 rightarrow 2 can be computed for 2-manifold shapes as","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"ir = increl_vertextoshape(shapes)","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Here manifdim(shapes) is 2. The incidence list of two-dimensional shapes connected to node 13 can be retrieved as ir(13).","category":"page"},{"location":"guide/guide.html#","page":"Guide","title":"Guide","text":"Manif. dim. 0 1 2 3\n0 ––– 0 -> 1 0 -> 2 0 -> 3\n1 ––– ––– 1 -> 2 1 -> 3\n2 ––– ––– ––– 2 -> 3\n3 ––– ––– ––– –––","category":"page"},{"location":"index.html#MeshCore-Documentation-1","page":"Home","title":"MeshCore Documentation","text":"","category":"section"},{"location":"index.html#Conceptual-guide-1","page":"Home","title":"Conceptual guide","text":"","category":"section"},{"location":"index.html#","page":"Home","title":"Home","text":"The concepts and ideas are described.","category":"page"},{"location":"index.html#","page":"Home","title":"Home","text":"Pages = [\n    \"guide/guide.md\",\n]\nDepth = 1","category":"page"},{"location":"index.html#Manual-1","page":"Home","title":"Manual","text":"","category":"section"},{"location":"index.html#","page":"Home","title":"Home","text":"The description of the types and of the functions.","category":"page"},{"location":"index.html#","page":"Home","title":"Home","text":"Pages = [\n    \"man/types.md\",\n    \"man/functions.md\",\n]\nDepth = 3","category":"page"},{"location":"man/types.html#Types-1","page":"Types","title":"Types","text":"","category":"section"},{"location":"man/types.html#","page":"Types","title":"Types","text":"CurrentModule = MeshCore","category":"page"},{"location":"man/types.html#Vertices-1","page":"Types","title":"Vertices","text":"","category":"section"},{"location":"man/types.html#","page":"Types","title":"Types","text":"Vertices","category":"page"},{"location":"man/types.html#MeshCore.Vertices","page":"Types","title":"MeshCore.Vertices","text":"Vertices{N, T}\n\nVertices of the mesh.\n\nN = number of coordinates, equal to the number of space dimensions,\nT = type of the individual coordinates (concrete subtype of AbstractFloat).\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#Shapes-1","page":"Types","title":"Shapes","text":"","category":"section"},{"location":"man/types.html#Shape-descriptors-1","page":"Types","title":"Shape descriptors","text":"","category":"section"},{"location":"man/types.html#","page":"Types","title":"Types","text":"AbstractShapeDesc\nNoSuchShapeDesc\nP1ShapeDesc\nL2ShapeDesc\nQ4ShapeDesc\nH8ShapeDesc\nT3ShapeDesc\nT4ShapeDesc","category":"page"},{"location":"man/types.html#MeshCore.AbstractShapeDesc","page":"Types","title":"MeshCore.AbstractShapeDesc","text":"AbstractShapeDesc\n\nAbstract shape descriptor (simplex, or cuboid, of various manifold dimension)\n\nThe definitions of concrete types below define a set of shape descriptors, covering the usual element shapes: point, line segment, quadrilateral, hexahedron, and a similar hierarchy for the simplex elements: point, line segment, triangle, tetrahedron.\n\nThe concrete types of the shape descriptor will provide access to manifdim = manifold dimension of the shape (0, 1, 2, or 3), nvertices = number of vertices of the shape, n1storderv = number of first-order vertices for the shape, for instance     a 6-node triangle has 3 first-order vertices, nfacets = number of shapes on the boundary of this shape, facetdesc = shape descriptor of the shapes on the boundary of this shape, facets = definitions of the shapes on the boundary of this shape in terms     of local connectivity\n\nThe bit-type values are defined with the type parameters: MD is the manifold dimension, NV is the number of connected vertices, NF is the number of boundary facets, N1OV number of first-order vertices, FD is the descriptor of the facet (boundary shape).\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.NoSuchShapeDesc","page":"Types","title":"MeshCore.NoSuchShapeDesc","text":"NoSuchShapeDesc\n\nBase descriptor: no shape is of this description.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.P1ShapeDesc","page":"Types","title":"MeshCore.P1ShapeDesc","text":"P1ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}\n\nShape descriptor of a point shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.L2ShapeDesc","page":"Types","title":"MeshCore.L2ShapeDesc","text":"L2ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}\n\nShape descriptor of a line segment shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.Q4ShapeDesc","page":"Types","title":"MeshCore.Q4ShapeDesc","text":"Q4ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}\n\nShape descriptor of a quadrilateral shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.H8ShapeDesc","page":"Types","title":"MeshCore.H8ShapeDesc","text":"H8ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}\n\nShape descriptor of a hexahedral shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.T3ShapeDesc","page":"Types","title":"MeshCore.T3ShapeDesc","text":"T3ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}\n\nShape descriptor of a triangular shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#MeshCore.T4ShapeDesc","page":"Types","title":"MeshCore.T4ShapeDesc","text":"T4ShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}\n\nShape descriptor of a tetrahedral shape.\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#Collection-of-shapes-1","page":"Types","title":"Collection of shapes","text":"","category":"section"},{"location":"man/types.html#","page":"Types","title":"Types","text":"ShapeCollection","category":"page"},{"location":"man/types.html#MeshCore.ShapeCollection","page":"Types","title":"MeshCore.ShapeCollection","text":"ShapeCollection{S <: AbstractShapeDesc, N, T}\n\nThis is the type of a homogeneous collection of finite element shapes.\n\nS = shape descriptor: subtype of AbstractShapeDesc{MD, NV, NF, FD}\nIT = type of the vertex numbers (some concrete type of Integer).\n\n\n\n\n\n","category":"type"},{"location":"man/types.html#Incidence-relations-1","page":"Types","title":"Incidence relations","text":"","category":"section"},{"location":"man/types.html#","page":"Types","title":"Types","text":"IncRelVertexToShape\nIncRelBoundedBy","category":"page"},{"location":"man/functions.html#Functions-1","page":"Functions","title":"Functions","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"CurrentModule = MeshCore","category":"page"},{"location":"man/functions.html#Vertices-1","page":"Functions","title":"Vertices","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"Vertices(xyz::Array{T, 2}) where {T}\nnvertices\nnspacedims\ncoordinatetype\ncoordinates","category":"page"},{"location":"man/functions.html#MeshCore.Vertices-Union{Tuple{Array{T,2}}, Tuple{T}} where T","page":"Functions","title":"MeshCore.Vertices","text":"Vertices(xyz::Array{T, 2}) where {T}\n\nConstruct from a matrix (2D array), one vertex per row.\n\n\n\n\n\n","category":"method"},{"location":"man/functions.html#MeshCore.nvertices","page":"Functions","title":"MeshCore.nvertices","text":"nvertices(v::Vertices{N, T}) where {N, T}\n\nRetrieve number of vertices.\n\n\n\n\n\nnvertices(sd::AbstractShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}\n\nHow many vertices does the shape connect?\n\n\n\n\n\nnvertices(shapes::ShapeCollection)\n\nRetrieve the number of vertices per shape.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.nspacedims","page":"Functions","title":"MeshCore.nspacedims","text":"nspacedims(v::Vertices{N, T}) where {N, T}\n\nRetrieve the number of space dimensions.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.coordinatetype","page":"Functions","title":"MeshCore.coordinatetype","text":"coordinatetype(v::Vertices{N, T}) where {N, T}\n\nRetrieve type of individual coordinates.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.coordinates","page":"Functions","title":"MeshCore.coordinates","text":"coordinates(vertices::Vertices{N, T}, i::I) where {N, T, I<:Int}\n\nRetrieve coordinates of a single vertex.\n\n\n\n\n\ncoordinates(vertices::Vertices{N, T}, I::SVector) where {N, T}\n\nAccess coordinates of selected vertices.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#Shapes-1","page":"Functions","title":"Shapes","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"ShapeCollection(shapedesc::S, C::Array{T, 2}) where {S <: AbstractShapeDesc, T}\nshapedesc\nconnectivity\nnshapes\nmanifdim\nnvertices\nn1storderv\nfacetdesc\nnfacets\nfacets\nfacetconnectivity","category":"page"},{"location":"man/functions.html#MeshCore.ShapeCollection-Union{Tuple{T}, Tuple{S}, Tuple{S,Array{T,2}}} where T where S<:MeshCore.AbstractShapeDesc","page":"Functions","title":"MeshCore.ShapeCollection","text":"ShapeCollection(shapedesc::S, C::Array{T, 2}) where {S <: AbstractShapeDesc, T}\n\nConvenience constructor from a matrix. One shape per row.\n\n\n\n\n\n","category":"method"},{"location":"man/functions.html#MeshCore.shapedesc","page":"Functions","title":"MeshCore.shapedesc","text":"shapedesc(shapes::ShapeCollection)\n\nRetrieve the shape descriptor.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.connectivity","page":"Functions","title":"MeshCore.connectivity","text":"connectivity(shapes::ShapeCollection, i::IT) where {IT}\n\nRetrieve connectivity of the i-th shape from the collection.\n\n\n\n\n\nconnectivity(shapes::ShapeCollection, I::SVector)\n\nRetrieve connectivity of multiple shapes from the collection.\n\nStatic arrays are used to help the compiler avoid memory allocation.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.nshapes","page":"Functions","title":"MeshCore.nshapes","text":"nshapes(shapes::ShapeCollection)\n\nNumber of shapes in the collection.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.manifdim","page":"Functions","title":"MeshCore.manifdim","text":"manifdim(sd::AbstractShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}\n\nWhat is the manifold dimension of this shape?\n\n\n\n\n\nmanifdim(shapes::ShapeCollection)\n\nRetrieve the manifold dimension of the collection.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.n1storderv","page":"Functions","title":"MeshCore.n1storderv","text":"n1storderv(sd::AbstractShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}\n\nHow many 1st-order vertices are there per shape?\n\nFor instance, for hexahedra each shape has 8 1st-order vertices.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.facetdesc","page":"Functions","title":"MeshCore.facetdesc","text":"facetdesc(shapes::ShapeCollection)\n\nRetrieve the shape type of the boundary facet.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.nfacets","page":"Functions","title":"MeshCore.nfacets","text":"nfacets(sd::AbstractShapeDesc{MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}) where {MD, NV, NF, FD, NE, ED, N1OV, NSHIFTS}\n\nHow many facets bound the shape?\n\n\n\n\n\nnfacets(shapes::ShapeCollection)\n\nRetrieve the number of boundary facets per shape.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.facets","page":"Functions","title":"MeshCore.facets","text":"facets(shapes::ShapeCollection)\n\nRetrieve the connectivity of the facets.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.facetconnectivity","page":"Functions","title":"MeshCore.facetconnectivity","text":"facetconnectivity(shapes::ShapeCollection, i::I, j::I) where {I}\n\nRetrieve connectivity of the j-th facet shape of the i-th shape from the collection.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#Topology-operations-1","page":"Functions","title":"Topology operations","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"skeleton\nboundary\nincrel_vertextoshape\n(ir::IncRelVertexToShape)(j::Int64)\nincrel_boundedby\n(ir::IncRelBoundedBy)(j::Int64)","category":"page"},{"location":"man/functions.html#MeshCore.skeleton","page":"Functions","title":"MeshCore.skeleton","text":"skeleton(shapes::ShapeCollection; options...)\n\nCompute the skeleton of the shape collection.\n\nThis computes a new shape collection from an existing shape collection. It consists of facets (shapes of manifold dimension one less than the manifold dimension of the shapes themselves).\n\nOptions\n\nboundaryonly: include in the skeleton only shapes on the boundary   of the input collection, true or false (default).\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#MeshCore.boundary","page":"Functions","title":"MeshCore.boundary","text":"boundary(shapes::ShapeCollection)\n\nCompute the shape collection for the boundary of the collection on input.\n\nThis is a convenience version of the skeleton function.\n\n\n\n\n\n","category":"function"},{"location":"man/functions.html#Index-1","page":"Functions","title":"Index","text":"","category":"section"},{"location":"man/functions.html#","page":"Functions","title":"Functions","text":"","category":"page"}]
}
