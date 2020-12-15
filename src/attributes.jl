"""
    AbsAttrib

Abstract type of attribute. It is a subtype of AbstractArray.
"""
abstract type AbsAttrib{T}<:AbstractArray{T, 1}
end

Base.IndexStyle(::Type{<:AbsAttrib}) = IndexLinear()

"""
    VecAttrib{T}<:AbsAttrib{T}

Attribute stores a quantity of type `T`, one value per shape.
The value is indexed to the serial number of the object.

# Example
Attribute to allow access to the locations of the vertices.
```
using Test
using StaticArrays
using MeshCore: VecAttrib, ShapeColl, P1, attribute
xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0]
N, T = size(xyz, 2), eltype(xyz)
locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
vertices = ShapeColl(P1, size(xyz, 1))
vertices.attributes["geom"] = locs
a = attribute(vertices, "geom")
@test a[2] == [633.3333333333334, 0.0]
```
Attribute to label the vertices.
```
using Test
using StaticArrays
using MeshCore: VecAttrib, ShapeColl, P1, attribute
a = VecAttrib([1 for i in 1:size(xyz, 1)] )
vertices = ShapeColl(P1, size(xyz, 1))
vertices.attributes["label"] = a
@test a[3] == 1
```

The vector attribute supports the methods `size`, `getindex`, `setindex!`.
"""
struct VecAttrib{T} <: AbsAttrib{T}
    v::Vector{T}
end


Base.size(a::A) where {A<:VecAttrib} =  (length(a.v), )
Base.getindex(a::A, i::Int) where {A<:VecAttrib} = a.v[i]
Base.getindex(a::A, I::Vararg{Int, N}) where {A<:VecAttrib, N}  = a.v[I...]
Base.setindex!(a::A, v, i::Int) where {A<:VecAttrib} =  (a.v[i] = v)  
Base.setindex!(a::A, v, I::Vararg{Int, N}) where {A<:VecAttrib, N} = (a.v[I...] .= v) 

"""
    FunAttrib{T, M, F} <: AbsAttrib{T}

Attribute provides access to a quantity of type `T`, one value per shape.
The value is indexed to the serial number of the object.

# Example
Attribute to allow access to the locations of the vertices.
```
using Test
using StaticArrays
using MeshCore: VecAttrib, ShapeColl, P1, attribute
xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0]
N, T = size(xyz, 2), eltype(xyz)
flocs = FunAttrib(SVector{N, T}([0.0 0.0]), size(xyz, 1), i -> SVector{N, T}(xyz[i, :]))
@test flocs[10] == [633.3333333333334, 800.0]
```
Attribute to label the vertices.
```
using Test
using StaticArrays
using MeshCore: VecAttrib, ShapeColl, P1, attribute
xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0]
a = FunAttrib(0, size(xyz, 1), i -> i)
vertices = ShapeColl(P1, size(xyz, 1))
vertices.attributes["label"] = a
@test a[3] == 1
```

The function attribute supports the methods `size`, `getindex`.
It does not support `setindex!`: there is no way of changing the data.
"""
struct FunAttrib{T, M, F} <: AbsAttrib{T}
    z::T
    m::M
    f::F
end

Base.size(a::A) where {A<:FunAttrib} =  (a.m, )
Base.getindex(a::A, i::Int) where {A<:FunAttrib} = a.f(i)
Base.getindex(a::A, I::Vararg{Int, N}) where {A<:FunAttrib, N}  = a.f.(I...)

"""
    datavaluetype(AbsAttrib{T}) where {T} 

Retrieve the type of the attribute  value.
"""
datavaluetype(a::AbsAttrib{T}) where {T} = T

