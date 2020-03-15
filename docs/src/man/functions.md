# Functions

```@meta
CurrentModule = MeshCore
```

## Vertices

```@docs
Vertices(xyz::Array{T, 2}) where {T}
nvertices
nspacedims
coordinatetype
coordinates
```

## Shapes

```@docs
ShapeCollection(shapedesc::S, C::Array{T, 2}) where {S <: AbstractShapeDesc, T}
shapedesc
connectivity
nshapes
manifdim
nvertices
n1storderv
facetdesc
nfacets
facets
facetconnectivity
```

## Topology operations

```@docs
skeleton
boundary
increl_vertextoshape
(ir::IncRelVertexToShape)(j::Int64) 
increl_bounding
(ir::IncRelBounding)(j::Int64)
```

## Index

```@index
```
