# How to ...

## ... create a shape collection

A shape collection of 6 quadrilaterals may be created as:
```
using MeshCore: Q4, ShapeColl
q4s = ShapeColl(Q4, 6)
```

Here `Q4` is the shape descriptor of 4-node quadrilaterals.


## ... create an incidence relation

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

## ... inspect an incidence relation

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

## ... inspect a shape descriptor

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