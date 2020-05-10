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
Q4ShapeDesc
H8ShapeDesc
T3ShapeDesc
T4ShapeDesc
SHAPE_DESC
```

## Shape collections

```@docs
ShapeColl{S <: AbsShapeDesc}
```

## Attributes

```@docs
AbsAttrib
Attrib{F}
AttribDataWrapper{T}
```


## Incidence relations

```@docs
IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
```
