# Functions

```@meta
CurrentModule = MeshCore
```

## Shapes descriptors

```@docs
manifdim
nvertices
nfacets
nridges
n1storderv
nshifts
nfeatofdim
```

## Shapes

```@docs
ShapeColl(shapedesc::S, nshapes::Int64) where {S <: AbsShapeDesc}
ShapeColl(shapedesc::S, nshapes::Int64, s::String) where {S <: AbsShapeDesc}
ShapeColl(shapedesc::S, nshapes::Int64, s::String) where {S <: AbsShapeDesc}
shapedesc
nshapes
manifdim(shapes::ShapeColl)
nvertices
facetdesc
nfacets
facetconnectivity
ridgedesc
nridges
ridgeconnectivity
attribute
```

## Incidence relations

```@docs
IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, v::Vector{T}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{MT}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}
IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{MT}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}
indextype
nrelations
nentities
retrieve
code
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

### Relations on the diagonal

```@docs
identty(ir::IncRel, side = :left)
```

### Utilities

```@docs
subset
```


## Index

```@index
```
