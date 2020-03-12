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
nnodes
facetdesc
nfacets
facets
facetconnectivity
```


## Topology operations

```@docs
VertexToShape(vertices, shapes::ShapeCollection{S, N, T}) where {S, N, T}
skeleton
boundary
```

## Index

```@index
```
