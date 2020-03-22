[Table of contents](https://petrkryslucsd.github.io/MeshCore.jl/latest/index.html)

# Guide

Contents:
- [Glossary](@ref)
- [Example](@ref)
- [Basic objects](@ref)
- [Derived Incidence Relations](@ref)

## Glossary

- *Incidence relation*: Map from one shape collection to another shape
  collection. For instance, three-dimensional finite elements (cells) are typically linked to the vertices by
  the incidence relation ``3 \rightarrow 0``, i. e. for each tetrahedron the
  four vertices are listed. Some incidence relations link a shape to a fixed
  number of other shapes, other incidence relations are of variable arity.
  This is what is usually understood as a "mesh".
- *Shape*: topological shape of any manifold dimension, ``0`` for vertices,
  ``1`` for edges, ``2`` for faces, and ``3`` for cells.
- *Shape descriptor*: description of the type of the shape, such as the number
  of vertices, facets, edgets, and so on.
- *Shape collection*: set of shapes of a particular shape description.
- *Facet*: shape bounding another shape. A shape is bounded by facets.
- *Edget*: shape one manifold dimension lower than the facet. For instance a
  tetrahedron is bounded by facets, which in turn are bounded by edges. These
  edges are the "edgets" of the tetrahedron.  The edgets can also be thought of
  as a "leaky" bounding shapes of 3-D cells.
- *Mesh topology*: The mesh topology can be understood as an incidence relation
  between two shape collections.
- *Incidence relation operations*: The operations defined in the
  library are the *skeleton*, the *transpose*, the *bounded-by for facets*, and *bounded-by for edgets*.

## Example

Let us begin with a simple example of the use of the library. (The next step relies on a related package, `MeshPorter`.) First import the mesh from a file:
```
mesh = import_NASTRAN("trunc_cyl_shell_0.nas")
```
The mesh data structure can be now queried as to the incidence relations.
The `:connectivity` is the incidence relation that defines the connectivity of the tetrahedral mesh that was read in:
```
connectivity = increl(mesh, :connectivity)
@test (nshapes(connectivity.right), nshapes(connectivity.left)) == (376, 996)
```
The incidence relation connects the shape collection on the left (tetrahedra), with the shape collection on the right (vertices). We can check that the correct number of entities
were imported:
```
@test (nshapes(connectivity.right), nshapes(connectivity.left)) == (376, 996)
```
We can now extract the shape collection of the vertices from the mesh, retrieve the geometry attribute, and pass these quantities to the export function:
```
vertices = shapecoll(mesh, :vertices)
geom = attribute(vertices, :geom)
vtkwrite("trunc_cyl_shell_0", geom.val.locs, connectivity)
```
Extract zero-dimensional entities (points) by a triple application of the
`skeleton` function. Check that the number of shapes in the skeleton is equal
to the number of the vertices (in this particular skeleton they correspond
one-to-one).
```
ir00 = skeleton(skeleton(skeleton(connectivity)))
@test (nshapes(ir00.right), nshapes(ir00.left)) == (376, 376)
```
Export the mesh for visualization (requires the use of the `MeshPorter` package).
```
vtkwrite("trunc_cyl_shell_0-boundary-skeleton", geom.val.locs, ir00)
```

## Basic objects


The objects with which the library works are the incidence relations
(`IncRel`), the shape descriptors (subtypes of `AbstractShapeDesc`), and the
shape collections (`ShapeColl`).

### Geometry

The locations are points in space. They are defined for the vertices.

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

Meshes are understood here simply as incidence relations. For instance, at the simplest level
meshes are defined by the *connectivity*. The connectivity is the incidence
relation linking the shape (``d``-dimensional manifold, where ``d \ge 0``) to
the set of vertices.  The number of vertices connected by the shapes is a fixed
number, for instance 4 for linear tetrahedra.



The collection of ``d``-dimensional shapes is thus defined by the connectivity
``d \rightarrow 0``. The starting point for the processing of  the mesh is
typically a two-dimensional or three-dimensional mesh. Let us say we start with
a three dimensional mesh, so the basic data structure consists of the incidence
relation ``3 \rightarrow 0``. The incidence relation ``2 \rightarrow 0`` can be
derived by application of the method `skeleton`. Repeated application of the
`skeleton` method will yield the relation ``1 \rightarrow 0``, and finally ``0
\rightarrow 0``. Note that at difference to other definitions of the incidence
relation ``0 \rightarrow 0`` (Logg 2008) this relation is one-to-one, not
one-to-many.

The table below shows the incidence relations (connectivity) that are the basic
information for generated or imported meshes. For instance a surface mesh
composed of triangles will start from the incidence relation ``2 \rightarrow
0``. No other incidence relation from the table will exist at that point.

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:--------|:--------|:--------|:--------|:--------|
| 0     | 0 -> 0 |------ | ------ | ------ |
| 1     | 1 -> 0 |------ | ------ | ------ |
| 2     | 2 -> 0 |------ | ------ | ------ |
| 3     | 3 -> 0 |------ | ------ | ------ |

The relation ``0 \rightarrow 0`` is trivial: Vertex is incident upon itself.
Hence it may not be worthwhile  to actually create a shape collection for this
relation. It is included for completeness only, really.

## Derived Incidence Relations

The incidence relations computable with the library are summarized in the
table below. They include the initial incidence relation  in the first column of
the table (connectivity of the first mesh), and the subsequently available
incidence relations in the rest of the table. Some of these relations are
defined for meshes derived from the initial mesh.

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:--------|:--------|:--------|:--------|:--------|
| 0     | 0 -> 0 | 0 -> 1 | 0 -> 2 | 0 -> 3 |
| 1     | 1 -> 0 | ------ | 1 -> 2 | 1 -> 3 |
| 2     | 2 -> 0 | 2 -> 1 | ------ | 2 -> 3 |
| 3     | 3 -> 0 | 3 -> 1 | 3 -> 2 | ------ |

In general the relations below the diagonal require the calculation of derived
meshes. The relations above the diagonal are obtained by the so-called transpose
operation, and do not require the construction of new meshes. Also, the
relations below the diagonal are of fixed size. That is the number of entities
incident on a given entity is a fixed number that can be determined beforehand.
An example is  the relation ``3 \rightarrow 2``, where for the ``j``-th cell the
list consists of the faces bounding the cell.

On the other hand, the relations above the diagonal are in general of variable
length. For example the relation ``2 \rightarrow 3`` represents the cells which
are bounded by a face: so either 2 or 1 cells.

### Incidence relations ``d \rightarrow 0``

The table below summarizes the incidence relations that represent  the initial meshes.

| Manif. dim. |   0   |   1   |   2   |  3   |
|:--------|:--------|:--------|:--------|:--------|
| 0     | 0 -> 0 |------ | ------ | ------ |
| 1     | 1 -> 0 |------ | ------ | ------ |
| 2     | 2 -> 0 |------ | ------ | ------ |
| 3     | 3 -> 0 |------ | ------ | ------ |

For instance, for a surface mesh the relation ``2 \rightarrow 0`` is defined initially.
The relations *above* that can be calculated with the `skeleton` function.
So,  the skeleton of the surface mesh would consist of all the edges
in the mesh, expressible as the incidence relation  ``1 \rightarrow 0``.

Note that the `skeleton` method constructs a derived mesh: the incidence relations
in the column of the above table are therefore defined for related, but separate, meshes.

### Incidence relations ``d \rightarrow d-1``

This incidence relation provides for each shape the list of shapes by which the
shape is bounded of manifold dimension lower by one. For example, for each
triangular face (manifold dimension 2), the relationship would state the global
numbers of edges (manifold dimension 1) by which the triangle face is bounded.

| Manif. dim.  |   0   |   1   |   2   |  3   |
|:--------|:--------|:--------|:--------|:--------|
|   0     | ------ | ------ | ------ | ------ |
|   1     | 1 -> 0 | ------ | ------ | ------ |
|   2     | ------ | 2 -> 1 | ------ | ------ |
|   3     | ------ | ------ | 3 -> 2 | ------ |

The incidence  relation ``d \rightarrow d-1`` may be derived with the function
`bbyfacets`, which operates on two shape collections: the shapes of dimension ``d``
and the facet shapes of dimension ``d-1``.

The relationship ``1  \rightarrow 0`` can be derived in two ways: from the incidence relation ``2
\rightarrow  0`` by the `skeleton` function, or by the `bbyfacets` function applied
to a shape collection of edges and  a shape collection of the vertices.

### Incidence relations ``d \rightarrow d-2``

This incidence relation provides for each shape the list of shapes by which the
shape is "bounded" of manifold dimension lower by two. For example, for each
triangular face (manifold dimension 2), the relationship would state the global
numbers of vertices (manifold dimension 0) by which the triangle face is
"bounded". The word "bounded" is in quotes because the relationship of bounding
is very leaky: Clearly we do not cover most of the boundary, only the vertices.

Similar relationship can be derived for instance between tetrahedra and the
edges (``3 \rightarrow 1``). Again, the incidence relation is very leaky in that
it provides cover for the edges of the tetrahedron.

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:--------|:--------|:--------|:--------|:--------|
| 0     | ------ | ------ | ------ | ------ |
| 1     | ------ | ------ | ------ | ------ |
| 2     | 2 -> 0 | ------ | ------ | ------ |
| 3     | ------ | 3 -> 1 | ------ | ------ |

The relationship ``2  \rightarrow 0`` can be derived in two ways: from the
incidence relation ``3 \rightarrow  0`` by the `skeleton` function, or by the
`bbyfacets` function applied to a shape collection of cells and  a shape
collection of the edges.


### Incidence relations ``d_1 \rightarrow d_2``, where ``d_1 \lt d_2``

The relations above the diagonal of the table below are lists of shapes incident
on lower-dimension shapes. These are computed from the incidence relations from
the lower triangle of the table by the function `increl_transpose`.

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:--------|:--------|:--------|:--------|:--------|
|   0     | ------ | 0 -> 1 | 0 -> 2 | 0 -> 3 |
|   1     | ------ | ------ | 1 -> 2 | 1 -> 3 |
|   2     | ------ | ------ | ------ | 2 -> 3 |
|   3     | ------ | ------ | ------ | ------ |

No new meshes are needed to construct the upper triangle  of the incidence
relations table. However, constructing the incidence relation  will still take a
pass through the entire mesh. The incidence relations in the upper triangle of
the table are all of variable arity: for instance the incidence relation ``1
\rightarrow 3`` is the list of three-dimensional cells that share a given edge.
Clearly the number of cells varies from edge to edge.

### Incidence relations ``d \rightarrow d``, where ``d \gt 1``

These incidence relations do not fit the table referenced many times above. The
definition of such a relation is not unique:  It needs to refer to a connecting shape. For
instance, the relationship between faces,   ``2 \rightarrow 2``, needs to state
through which shape the incidence occurs: is it through the common vertex? Is it
through a common edge? Similarly, for cells the incidence relationship ``3
\rightarrow 3`` will be different for the incidence to follow from a common
vertex, a common edge, or a common face.

### How incidence relations are computed

For definiteness here we assume that the initial mesh (i. e. the incidence relation)
is ``3 \rightarrow 0``.

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:------------------|:------------------|:------------------|:------------------|:------------------|
|   0     | 0 -> 0: sk(1 -> 0) | 0 -> 1: tr(1 -> 0) | 0 -> 2: tr(2 -> 0) | 0 -> 3: tr(3 -> 0) |
|   1     | 1 -> 0: sk(2 -> 0) | ------ | 1 -> 2: tr(2 -> 1) | 1 -> 3: tr(3 -> 1) |
|   2     | 2 -> 0: sk(3 -> 0) | 2 -> 1: bf(2 -> 0, 1 -> 0, 0 -> 1) | ------ | 2 -> 3: tr(3 -> 2) |
|   3     | 3 -> 0 | 3 -> 1: be(3 -> 0, 1 -> 0, 0 -> 1) | 3 -> 2: bf(3 -> 0, 2 -> 0, 0 -> 2)| ------ |
