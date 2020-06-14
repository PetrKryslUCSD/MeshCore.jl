"""
    AbsAttrib

Abstract type of attribute. It is a subtype of AbstractArray.
"""
abstract type AbsAttrib{T}<:AbstractArray{T, 1}
end

Base.IndexStyle(::Type{<:AbsAttrib}) = IndexLinear()
Base.size(a::A) where {A<:AbsAttrib} =  (length(a.v), )
Base.getindex(a::A, i::Int) where {A<:AbsAttrib} = a.v[i]
Base.getindex(a::A, I::Vararg{Int, N}) where {A<:AbsAttrib, N}  = a.v[I...]
Base.setindex!(a::A, v, i::Int) where {A<:AbsAttrib} =  (a.v[i] = v)  
Base.setindex!(a::A, v, I::Vararg{Int, N}) where {A<:AbsAttrib, N} = a.v[I...]  

"""
    VecAttrib{T}<:AbsAttrib{T}

Attribute stores a quantity of type `T`, one value per shape.
The value is linked to the serial number of the object.

# Example
Attribute to allow access to the locations of the vertices.
```
using Test
using StaticArrays
using MeshCore: AttribDataWrapper, Attrib, ShapeColl, P1, attribute
xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0]
N, T = size(xyz, 2), eltype(xyz)
locs =  AttribDataWrapper([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
a = Attrib(locs)
vertices = ShapeColl(P1, size(xyz, 1), Dict("geom"=>a))
a = attribute(vertices, "geom")
@test a.co(2) == [633.3333333333334, 0.0]
```
Attribute to label the vertices.
```
using Test
using StaticArrays
using MeshCore: AttribDataWrapper, Attrib, ShapeColl, P1, attribute
a = Attrib(i -> 1)
vertices = ShapeColl(P1, size(xyz, 1), Dict("label"=>a))
a = attribute(vertices, "label")
@test a.co(10) == 1
```
"""
struct VecAttrib{T}<:AbsAttrib{T}
    v::Vector{T}
end

"""
    datavaluetype(VecAttrib{T}) where {T} 

Retrieve the type of the attribute  value.
"""
datavaluetype(VecAttrib{T}) where {T} = T

