[Table of contents](https://petrkryslucsd.github.io/MeshCore.jl/latest/index.html)

# How to guide

## [How to create a shape collection](@ref createcollection)

A shape collection of 6 quadrilaterals may be created as:
```
using MeshCore: Q4, ShapeColl
q4s = ShapeColl(Q4, 6)
```

Here `Q4` is the shape descriptor of 4-node quadrilaterals.


## [How to create and incidence relation](@ref createir)

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

