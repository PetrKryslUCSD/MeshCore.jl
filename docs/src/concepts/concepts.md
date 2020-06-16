[Table of contents](https://petrkryslucsd.github.io/MeshCore.jl/latest/index.html)

# Concepts

Contents:
- [Glossary](@ref)
- [Example](@ref)
- [Basic objects](@ref)
- [Derived Incidence Relations](@ref)

## Glossary

- *Incidence relation*: Map from one shape collection to another shape
  collection. For instance, three-dimensional finite elements (cells) are typically linked to the vertices by
  the incidence relation ``(3,0)``, i. e. for each tetrahedron the
  four vertices are listed. Some incidence relations link a shape to a fixed
  number of other shapes, other incidence relations are of variable arity.
  This is what is usually understood as a "mesh".
- *Shape*: topological shape of any manifold dimension, ``0`` for vertices,
  ``1`` for edges, ``2`` for faces, and ``3`` for cells.
- *Shape descriptor*: description of the type of the shape, such as the number
  of vertices, facets, ridges, and so on.
- *Shape collection*: set of shapes of a particular shape description.
- *Facet*: shape bounding another shape. A shape is bounded by facets.
- *Ridge*: shape one manifold dimension lower than the facet. For instance a
  tetrahedron is bounded by facets, which in turn are bounded by edges. These
  edges are the "ridges" of the tetrahedron.  The ridges can also be thought of
  as a "leaky" bounding shapes of 3-D cells.
- *Mesh topology*: The mesh topology can be understood as an incidence relation
  between two shape collections.
- *Incidence relation operations*: The operations defined in the
  library are the *skeleton*, the *transpose*, the *bounded-by for facets*, and *bounded-by for ridges*.

## Example

Please refer to the [`MeshTutor.jl`](https://github.com/PetrKryslUCSD/MeshTutor.jl.git) package for a tutorial on the use of the library.

## Basic objects


The objects with which the library works are the incidence relations
(`IncRel`), the shape descriptors (subtypes of `AbstractShapeDesc`), and the
shape collections (`ShapeColl`).

### Geometry

The locations are points in space. They are defined as attributes for the vertices.

### Shape descriptors and shape collections

The shape collections are homogeneous collections of  shapes such as the usual
vertices (0-dimensional manifolds), line segments (1-dimensional manifolds),
triangles and quadrilaterals (2-dimensional manifolds), tetrahedra and
hexahedra (3-dimensional manifolds). The shape descriptors describe the
topology of one entity of the shape.

### Incidence relations

The incidence relations are really
definitions of meshes where one shape collection, the one on the left of the
incidence relation, is mapped to ``N`` entities in the shape collection on the
right.

## Topology of meshes

Meshes are understood here simply as incidence relations. For instance, at the
simplest level meshes are defined by the *connectivity*. The connectivity is
the incidence relation linking the shape (``d``-dimensional manifold, where ``d
\ge 0``) to the set of vertices.  The number of vertices connected by the
shapes is a fixed number, for instance 4 for linear tetrahedra.



The collection of ``d``-dimensional shapes is thus defined by the connectivity
``(d,0)``. The starting point for the processing of  the mesh is
typically a two-dimensional or three-dimensional mesh. Let us say we start with
a three dimensional mesh, so the basic data structure consists of the incidence
relation ``(3,0)``. The incidence relation ``(2,0)`` can be
derived by application of the method `skeleton`. Repeated application of the
`skeleton` method will yield the relation ``(1,0)``, and finally ``(0,0)``. Note that at difference to other definitions of the incidence
relation ``(0,0)`` (Logg 2008) this relation is one-to-one, not
one-to-many.

The table below shows the incidence relations (connectivity) that are the basic
information for generated or imported meshes. For instance a surface mesh
composed of triangles will start from the incidence relation ``2 \rightarrow
0``. No other incidence relation from the table will exist at that point.

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:---: | :---: | :---: | :---: | :---: |
| 0     | ``(0,0)`` |------ | ------ | ------ |
| 1     | ``(1,0)`` |------ | ------ | ------ |
| 2     | ``(2,0)`` |------ | ------ | ------ |
| 3     | ``(3,0)`` |------ | ------ | ------ |

The relation ``(0,0)`` is trivial: Vertex is incident upon itself.
Hence it may not be worthwhile  to actually create a shape collection for this
relation. It is included for completeness only, really.

## Derived Incidence Relations

The incidence relations computable with the library are summarized in the
table below. They include the initial incidence relation  in the first column of
the table (connectivity of the first mesh), and the subsequently available
incidence relations in the rest of the table. Some of these relations are
defined for meshes derived from the initial mesh.

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:---: | :---: | :---: | :---: | :---: |
| 0     | ``(0,0)`` | ``(0,1)`` | ``(0,2)`` | ``(0,3)`` |
| 1     | ``(1,0)`` | ``(1,1)`` | ``(1,2)`` | ``(1,3)`` |
| 2     | ``(2,0)`` | ``(2,1)`` | ``(2,2)`` | ``(2,3)`` |
| 3     | ``(3,0)`` | ``(3,1)`` | ``(3,2)`` | ``(3,3)`` |

In general the relations below the diagonal require the calculation of derived
meshes. The relations above the diagonal are obtained by the so-called transpose
operation, and do not require the construction of new meshes. Also, the
relations below the diagonal are of fixed size. That is the number of entities
incident on a given entity is a fixed number that can be determined beforehand.
An example is  the relation ``(3,2)``, where for the ``j``-th cell the
list consists of the faces bounding the cell.

On the other hand, the relations above the diagonal are in general of variable
length. For example the relation ``(2,3)`` represents the cells which
are bounded by a face: so either 2 or 1 cells.

### Incidence relations ``(d,0)``

The table below summarizes the incidence relations that represent  the initial meshes.

| Manif. dim. |   0   |   1   |   2   |  3   |
|:---: | :---: | :---: | :---: | :---: |
| 0     | ``(0,0)`` |------ | ------ | ------ |
| 1     | ``(1,0)`` |------ | ------ | ------ |
| 2     | ``(2,0)`` |------ | ------ | ------ |
| 3     | ``(3,0)`` |------ | ------ | ------ |

For instance, for a surface mesh the relation ``(2,0)`` is defined initially.
The relations *above* that can be calculated with the `skeleton` function.
So,  the skeleton of the surface mesh would consist of all the edges
in the mesh, expressible as the incidence relation  ``(1,0)``.

Note that the `skeleton` function constructs a derived mesh: the incidence
relations in the column of the above table are therefore defined for related,
but separate, meshes.

### Incidence relations ``(d,d-1)``

This incidence relation provides for each shape the list of shapes by which the
shape is bounded of manifold dimension lower by one. For example, for each
triangular face (manifold dimension 2), the relationship would state the global
numbers of edges (manifold dimension 1) by which the triangle face is bounded.

| Manif. dim.  |   0   |   1   |   2   |  3   |
|:---: | :---: | :---: | :---: | :---: |
|   0     | ------ | ------ | ------ | ------ |
|   1     | ``(1,0)`` | ------ | ------ | ------ |
|   2     | ------ | ``(2,1)`` | ------ | ------ |
|   3     | ------ | ------ | ``(3,2)`` | ------ |

The incidence  relation ``(d,d-1)`` may be derived with the function
`bbyfacets`, which operates on two shape collections: the shapes of dimension ``d``
and the facet shapes of dimension ``d-1``.

The relationship ``(1 ,0)`` can be derived in two ways: from the incidence relation ``(2,0)`` by the `skeleton` function, or by the `bbyfacets` function applied
to a shape collection of edges and  a shape collection of the vertices.

### Incidence relations ``(d,d-2)``

This incidence relation provides for each shape the list of shapes by which the
shape is "bounded" of manifold dimension lower by two. For example, for each
triangular face (manifold dimension 2), the relationship would state the global
numbers of vertices (manifold dimension 0) by which the triangle face is
"bounded". The word "bounded" is in quotes because the relationship of bounding
is very leaky: Clearly we do not cover most of the boundary, only the vertices.

Similar relationship can be derived for instance between tetrahedra and the
edges (``3,1``). Again, the incidence relation is very leaky in that
it provides cover for the edges of the tetrahedron.

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:---: | :---: | :---: | :---: | :---: |
| 0     | ------ | ------ | ------ | ------ |
| 1     | ------ | ------ | ------ | ------ |
| 2     | ``(2,0)`` | ------ | ------ | ------ |
| 3     | ------ | ``(3,1)`` | ------ | ------ |

The relationship ``(2 ,0)`` can be derived in two ways: from the
incidence relation ``(3, 0)`` by the `skeleton` function, or by the
`bbyfacets` function applied to a shape collection of cells and  a shape
collection of the edges.


### Incidence relations ``(d_1,d_2)``, where ``d_1 \lt d_2``

The relations above the diagonal of the table below are lists of shapes incident
on lower-dimension shapes. These are computed from the incidence relations from
the lower triangle of the table by the function `increl_transpose`.

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:---: | :---: | :---: | :---: | :---: |
|   0     | ------ | ``(0,1)`` | ``(0,2)`` | ``(0,3)`` |
|   1     | ------ | ------ | ``(1,2)`` | ``(1,3)`` |
|   2     | ------ | ------ | ------ | ``(2,3)`` |
|   3     | ------ | ------ | ------ | ------ |

The incidence relations in the upper triangle
of the table are all of variable arity: for instance the incidence relation
``(1,3)`` is the list of three-dimensional cells that share a given edge.
Clearly the number of cells varies from edge to edge.

### Incidence relations ``(d,d)``, where ``d \gt 1``

These incidence relations are mostly useful for uniformity to record an identity relation: an entity is mapped to itself. The operation is denoted here `id`(``(d,d)``).

This defers starkly from the
definitions of such relations that can be found in the literature.  Those are one-to-many, and don't fit the table above. They need to refer to a connecting
shape. For instance, the relationship between faces,   ``(2,2)``, would need to
state through which shape the incidence occured: was it through the common
vertex? Was it through a common edge? Similarly, for cells the incidence
relationship ``(3,3)`` would be different for the incidences that followed from a common vertex, a common edge, or a common face.

### How incidence relations are computed

For definiteness here we assume that the initial mesh (i. e. the incidence
relation) is ``3,0``. The other 12 relations in the table below can be computed by applying the four procedures: skeleton (`sk`), bounded-by-facet (`bf`), bounded-by-ridges (`be`), and transpose (`tr`). In addition there is the identity-producing operation (`id`).

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:---:  | :---:  | :---:  | :---:  | :---:  |
|   0     | `sk`(``(1,0)``) |  `tr`(``(1,0)``) | `tr`(``(2,0)``) |  `tr`(``(3,0)``) |
|   1     | `sk`(``(2,0)``) | `id`(``(1,1)``) | `tr`(``(2,1)``) | `tr`(``(3,1)``) |
|   2     | `sk`(``(3,0)``) | `bf`(``(2,0)``, ``(1,0)``, ``(0,1)``) | `id`(``(2,2)``) | `tr`(``(3,2)``) |
|   3     | ``(3,0)`` | `be`(``(3,0)``, ``(1,0)``, ``(0,1)``) | `bf`(``(3,0)``, ``(2,0)``, ``(0,2)``)| `id`(``(3,3)``) |
