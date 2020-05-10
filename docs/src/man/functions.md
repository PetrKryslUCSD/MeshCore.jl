# Functions

```@meta
CurrentModule = MeshCore
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
ridgedesc
nridges
ridgeconnectivity
n1storderv
nshifts
attribute
```

## Incidence relations

```@docs
IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, v::Vector{T}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{MT}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}
indextype
nrelations
nentities
retrieve
```

### Relations below the diagonal

```@docs
skeleton
boundary
bbyfacets
bbyridges
```

### Relations above the diagonal

```@docs
transpose(mesh::IncRel)
```

### Attributes

```@docs
nvals(d::AttribDataWrapper{T}) where {T} 
val(d::AttribDataWrapper{T}, j::Int64) where {T}
(d::AttribDataWrapper{T})(j::Int64) where {T}
```


## Index

```@index
```
