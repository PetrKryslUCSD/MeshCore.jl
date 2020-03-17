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
nshifts
facetdesc
nfacets
facets
edgetconnectivity
edgetdesc
nedgets
edgets
edgetconnectivity
```

## Incidence relations

```@docs
nrelations
nentities
(ir::IncRelFixed)(j::IT, k::IT) where {IT} = ir._v[j][k]
(ir::IncRelFixed)(j::IT) where {IT} = ir._v[j]
```

## Relations below the diagonal

```@docs
skeleton
boundary
boundedby
boundedby2
```

## Relations above the diagonal

```@docs
increl_transpose
```

## Index

```@index
```
