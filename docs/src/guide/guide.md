[Table of contents](https://petrkryslucsd.github.io/MeshCore.jl/latest/index.html)

# Guide

Let us begin with a simple example of the use of the library:

## Example
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
Export the mesh for visualization.
```
vtkwrite("trunc_cyl_shell_0-boundary-skeleton", vertices, bshapes)
```

## Basic objects

The objects with which the library works are the vertices and the shape
collections. The vertices are points in space, and the shape collections are
homogeneous collections of  shapes such as the usual points (0-dimensional
manifolds), line segments (1-dimensional manifolds), triangles and
quadrilaterals (2-dimensional manifolds), tetrahedra and hexahedra
(3-dimensional manifolds).

### Topological relations

The topological relations computable with the library are summarized in the
table below. They include the initial incidence relation  in the first column of
the table (connectivity of the first mesh), and the subsequently available
incidence relations in the rest of the table. Some of these relations are
defined for meshes derived from the first mesh.

| Manif. dim.      |   0   |   1   |   2   |  3   |
|:--------|:--------|:--------|:--------|:--------|
| 0     | 0 -> 0 | 0 -> 1 | 0 -> 2 | 0 -> 3 |
| 1     | 1 -> 0 | x | x | x |
| 2     | 2 -> 0 | 2 -> 1 | x | x |
| 3     | 3 -> 0 | x | 3 -> 2 | x |

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

Note that the `skeleton` method constructs a derived mesh: the incidence relations
are therefore defined for related, but separate meshes.

### Incidence relations

#### Incidence relations ``0 \rightarrow d``

The relations in the first row of the table (``0 \rightarrow d``) are lists of
shapes incident on individual vertices. These are computed on demand by the
function `increl_vertextoshape`. The individual incidence relations can be accessed by
dispatch on the `IncRelVertexToShape` data. For instance, the relation ``0 \rightarrow 2`` can be
computed for 2-manifold shapes as
```
ir = increl_vertextoshape(shapes)
```
Here `manifdim(shapes)` is 2. The incidence list of two-dimensional shapes
connected to node 13 can be retrieved as `ir(13)`.

#### Incidence relations ``d \rightarrow d-1``

The relations below the diagonal of the table (``d \rightarrow d-1``) are lists
of facet shapes incident on individual shapes (bounding these shapes). The lists are computed on
demand by the function `increl_boundedby`. The individual incidence relations can be
accessed by dispatch on the `IncRelBoundedBy` data. For instance, the relation ``2
\rightarrow 1`` can be computed for 2-manifold shapes as
```
shapes = ShapeCollection(Q4, cc)
ir = increl_boundedby(shapes, skeleton(shapes))
```
Here `manifdim(shapes)` is 2, and `manifdim(skeleton(shapes))` is 1. The incidence
list of 1-dimensional shapes (edges) bounding the quadrilateral  3 can be
retrieved as `ir(3)`.
