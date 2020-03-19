# Types

```@meta
CurrentModule = MeshCore
```

## Geometry

```@docs
Locations{N, T<:AbstractFloat}
```

## Shape descriptors

```@docs
AbstractShapeDesc
NoSuchShapeDesc
P1ShapeDesc
L2ShapeDesc
Q4ShapeDesc
H8ShapeDesc
T3ShapeDesc
T4ShapeDesc
```

## Shape collections

```@docs
ShapeColl{S <: AbsShapeDesc}
```

## Attributes

```@docs
AbsAttrib
Attrib{F}<:AbsAttrib
```


## Incidence relations

```@docs
IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
```
