[Table of contents](https://petrkryslucsd.github.io/MeshCore.jl/latest/index.html)

# Guide

Contents:
- [Glossary](@ref)
- [Example](@ref)
- [Basic objects](@ref)
- [Incidence relations](@ref)

## Glossary

- Shape: topological shape of any manifold dimension, ``0`` for vertices, ``1`` for
  edges, ``2`` for faces, and ``3`` for cells.
- Facet: shape bounding another shape. A shape is bounded by facets.
- Edget: shape one manifold dimension lower than the facet. For instance a
  tetrahedron is bounded by facets, which in turn are bounded by edges. These
  edges are the "edgets" of the tetrahedron. Edgets  can be thought of as the
  bounding shapes of the facets.
- Shape collection: set of shapes. Each shape is defined with reference
  to other shapes through an incidence relation.
- Incidence relation: Map from one shape to another shape. For instance,
  three-dimensional finite elements are defined by the
  incidence relation ``3 \rightarrow 0``, i. e. for each tetrahedron
  the four vertices are listed. Some incidence relations link a shape to
  a fixed number of other shapes, other incidence relations are of variable arity.
- Connectivity: The connectivity is the incidence relation ``d \rightarrow 0``
  linking the shape (``d``-dimensional manifold, where ``d \ge 0``) to the set
  of vertices (``0``-dimensional manifold).
- Mesh: Collection of shapes. It may be also a set of collections of shapes, but
  it is usually quite enough  to consider a mesh and the collection of shapes to
  be one and the same.  
- Initial mesh: The entry point into the library. The first mesh that was defined.
- Derived mesh: Mesh derived from another mesh through an incidence relation
- calculation.

## Example

Let us begin with a simple example of the use of the library:
First import the mesh from a file and check that the correct number of entities
were imported.
```
mesh = import_NASTRAN("trunc_cyl_shell_0.nas")
vertices, shapes = mesh["vertices"], mesh["shapes"][1]
@test (nvertices(vertices), nshapes(shapes)) == (376, 996)
```
Extract zero-dimensional entities (points) by a triple application of the
`skeleton` function. Check that the number of shapes is equal to the number of
the vertices (in this particular skeleton they correspond one-to-one).
```
bshapes = skeleton(skeleton(skeleton(shapes)))
@test (nvertices(vertices), nshapes(bshapes)) == (376, 376)
```
Export the mesh for visualization (requires the use of the `MeshPorter` package).
```
vtkwrite("trunc_cyl_shell_0-boundary-skeleton", vertices, bshapes)
```

## Basic objects

The objects with which the library works are the vertices and the shape
collections. The vertices are points in space, and the shape collections are
homogeneous collections of  shapes such as the usual vertices (0-dimensional
manifolds), line segments (1-dimensional manifolds), triangles and
quadrilaterals (2-dimensional manifolds), tetrahedra and hexahedra
(3-dimensional manifolds).

### Connectivity

The shapes are defined by the *connectivity*. The connectivity is the incidence
relation linking the shape (``d``-dimensional manifold, where ``d \ge 0``) to
the set of vertices.  The number of vertices connected by the shapes is a fixed
number, for instance 8 for linear hexahedra.

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

## Incidence relations

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
`boundedby`, which operates on two shape collections: the shapes of dimension ``d``
and the facet shapes of dimension ``d-1``.

The relationship ``1  \rightarrow 0`` can be derived in two ways: from the incidence relation ``2
\rightarrow  0`` by the `skeleton` function, or by the `boundedby` function applied
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

The relationship ``2  \rightarrow 0`` can be derived in two ways: from the incidence relation ``3
\rightarrow  0`` by the `skeleton` function, or by the `boundedby2` function applied
to a shape collection of cells and  a shape collection of the edges.


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
