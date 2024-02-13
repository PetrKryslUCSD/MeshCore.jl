
```@meta
CurrentModule = MeshCore
```

# Functions

## Shapes descriptors

```@docs
manifdim(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
nvertices(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
nfacets(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
nridges(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
n1storderv(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}
nshifts(sd::AbsShapeDesc{MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS}) where {MD, NV, NF, FD, NR, RD, NFOV, NSHIFTS} 
nfeatofdim
```

## Shapes

```@docs
ShapeColl(shapedesc::S, nshapes::Int64) where {S <: AbsShapeDesc}
ShapeColl(shapedesc::S, nshapes::Int64, s::String) where {S <: AbsShapeDesc}
shapedesc
nshapes
manifdim(shapes::ShapeColl)
nvertices(shapes::ShapeColl) 
facetdesc
nfacets(shapes::ShapeColl)
facetconnectivity
ridgedesc
nridges(shapes::ShapeColl)
ridgeconnectivity
attribute
Base.summary(sc::S) where {S<:ShapeColl}
```

## Incidence relations

```@docs
IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    v::Vector{Vector{IT}},
    name::String
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, IT}
IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    v::Vector{Vector{IT}},
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, IT}
IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    v::Vector{SVector{N, IT}},
    name::String
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}
IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    v::Vector{SVector{N, IT}}
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}
IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    data::Matrix{MT},
    name::String
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}
IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    data::Matrix{MT}
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}
IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    data::Vector{NTuple{N, IT}},
    name::String
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}
IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    data::Vector{NTuple{N, IT}}
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}
indextype
nrelations
nentities
ir_code
getv
Base.summary(ir::IncRel)
```

### Relations below the diagonal

```@docs
ir_skeleton
ir_bbyfacets
ir_bbyridges
```

### Relations above the diagonal

```@docs
ir_transpose(mesh::IncRel)
```

### Relations on the diagonal

```@docs
ir_identity(ir::IncRel, side = :left)
```

### Attributes

```@docs
datavaluetype
```

### Utilities

```@docs
ir_subset
ir_boundary
```


## Index of functions

```@index
```


# Types

## Shape descriptors

```@docs
AbsShapeDesc
NoSuchShapeDesc
P1ShapeDesc
L2ShapeDesc
L3ShapeDesc
Q4ShapeDesc
Q8ShapeDesc
H8ShapeDesc
T3ShapeDesc
T6ShapeDesc
T4ShapeDesc
SHAPE_DESC
```

## Shape collections

```@docs
ShapeColl{S <: AbsShapeDesc}
```

## Attributes

```@docs
AbsAttrib{T}
VecAttrib{T}
FunAttrib{T,M,F}
```


## Incidence relations

```@docs
IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
```
