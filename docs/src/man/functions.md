# Functions

```@meta
CurrentModule = MeshCore
```

## Geometry

```@docs
Locations(xyz::Array{T, 2}) where {T}
nlocations(loc::Locations{N, T}) where {N, T}
nspacedims(loc::Locations{N, T}) where {N, T}
coordinatetype(loc::Locations{N, T}) where {N, T}
coordinates(loc::Locations{N, T}, i::Int64) where {N, T}
coordinates(loc::Locations{N, T}, I::SVector) where {N, T}
```

## Access to geometry from an attribute


```@docs
locations(la::LocAccess{N, T}) where {N, T}
coordinates
```

## Shapes

```@docs
ShapeColl(shapedesc::S, nshapes::Int64) where {S <: AbsShapeDesc}
ShapeColl(shapedesc::S, nshapes::Int64, d::Dict) where {S <: AbsShapeDesc}
ShapeColl(shapedesc::S, nshapes::Int64, s::String) where {S <: AbsShapeDesc}
shapedesc
nshapes
manifdim
nvertices
facetdesc
nfacets
facetconnectivity
edgetdesc
nedgets
edgetconnectivity
n1storderv
nshifts
attribute
```

## Incidence relations

```@docs
IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, v::Vector{T}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{MT}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}
nrelations
nentities
retrieve
```

### Relations below the diagonal

```@docs
skeleton
boundary
bbyfacets
bbyedgets
```

### Relations above the diagonal

```@docs
transpose(mesh::IncRel)
```

## Index

```@index
```
