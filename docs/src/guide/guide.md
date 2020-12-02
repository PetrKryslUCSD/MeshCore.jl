# How-to guide

## How to create a shape collection

A shape collection of 6 quadrilaterals may be created as:
```
using MeshCore: Q4, ShapeColl
q4s = ShapeColl(Q4, 6)
```

Here `Q4` is the shape descriptor of 4-node quadrilaterals.


## How to create an incidence relation

A incidence relation of 6 quadrilaterals that connect vertices (nodes) given in the vector of tuples `c` may be created as: First we create the shape collections for the quadrilaterals and the vertices. 
```
using MeshCore: P1, Q4, ShapeColl
q4s = ShapeColl(Q4, 6)
vrts = ShapeColl(P1, 12)
```
Here `P1` is the shape descriptor of a single point.

Then we supply the data for the connectivity:
```
c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
using MeshCore: IncRel
ir = IncRel(q4s, vrts, c)
```

## How to inspect an incidence relation

Given an incidence relation `ir`, a summary of it may be printed as 
```
summary(ir) 
```
The two shape collections, the one on the left and the one on the right of the incidence relation, may be summarized as:
```
summary(ir.left), summary(ir.right)  
```

The number of the shapes in the two collections may be obtained as
```
using MeshCore: nshapes
nshapes(ir.left), nshapes(ir.right)  
```

## How to inspect a shape descriptor

In the incidence relation from above (quadrilaterals versus vertices), the quadrilaterals are the shape collection on the left of the incidence relation, and the vertices are there shape collection on the right. The manifold dimension of the vertices is 0.
```
vrts = ir.right
using MeshCore: shapedesc
sd = shapedesc(vrts)
using MeshCore: manifdim
manifdim(vrts) == manifdim(P1)  == manifdim(sd)  == 0
```
The quadrilaterals are the shape collection on the left.
```
quads = ir.left
```
The facets of the quadrilaterals are line segments (shape descriptor `L2`) .

```
using MeshCore: facetdesc, L2
facetdesc(quads) == L2
```
Each quadrilateral has 4 facets.
```
using MeshCore: nfacets, Q4
nfacets(quads) == nfacets(Q4) == 4
```
The ridges of the quadrilaterals are the vertices:
```
using MeshCore: ridgedesc, nridges, P1
ridgedesc(quads) == P1
nridges(quads) == 4
```

## How to attach the geometry attribute

Here is a small tetrahedral mesh defined by the connectivity `conn`. 
```
c = [ [1, 10, 7, 8], 
 [5, 4, 2, 11], 
 [11, 2, 8, 10],
 [4, 11, 10, 2],
 [2, 1, 8, 10], 
 [4, 10, 1, 2], 
 [2, 11, 8, 9], 
 [6, 5, 3, 12], 
 [12, 3, 9, 11],
 [5, 12, 11, 3],
 [3, 2, 9, 11], 
 [5, 11, 2, 3] ]   
using MeshCore: T4, P1, ShapeColl
tets = ShapeColl(T4, size(c, 1))
vrts = ShapeColl(P1, 12)
using MeshCore: IncRel
conn = IncRel(tets, vrts, c)
```
The locations of the vertices are at this point undefined. To remedy this deficiency, we attach the geometry attribute:
```
xyz = [[0.0, 0.0, 0.0], [1.0, 0.0, 0.0], [2.0, 0.0, 0.0], [0.0, 1.0, 0.0], [1.0, 1.0, 0.0], [2.0, 1.0, 0.0], [0.0, 0.0, 3.0], [1.0, 0.0, 3.0], [2.0, 0.0, 3.0], [0.0, 1.0, 3.0], [1.0, 1.0, 3.0], [2.0, 1.0, 3.0]]
using MeshCore:  VecAttrib
locs = VecAttrib(xyz)
vrts.attributes["geom"] = locs
```

## How to generate a skeleton

## How to generate a transposed incidence relation

