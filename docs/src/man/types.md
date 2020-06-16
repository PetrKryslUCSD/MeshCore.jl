# Types

```@meta
CurrentModule = MeshCore
```

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
VecAttrib{T}<:AbsAttrib{T}
```


## Incidence relations

```@docs
IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
```
