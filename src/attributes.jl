"""
    AbsAttrib

Abstract type of attribute.
"""
abstract type AbsAttrib
end

"""
    Attrib{F}<:AbsAttrib

Attribute: `F` is either a function type, or type of a callable object.
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
struct Attrib{F}<:AbsAttrib
    co::F # function or a callable object
    name::String # name of the attribute
end

"""
    Attrib(co::F) where {F}

Construct attribute with the callable object `co`, and with default name.
"""
function Attrib(co::F) where {F}
    Attrib(co, "attrib")
end

"""
    AttribDataWrapper{T}

Simple type to store a vector of data with a shape collection.
"""
struct AttribDataWrapper{T}
    v::Vector{T}
end

"""
    (d::AttribDataWrapper{T})(j::Int64) where {T}

Retrieve the value stored in the data wrapper at index `j`.
"""
function (d::AttribDataWrapper{T})(j::Int64) where {T}
    return d.v[j]
end

"""
    val(d::AttribDataWrapper{T}, I::SVector) where {N, T}

Retrieve values stored in the data wrapper for all indexes in `I`.
"""
@generated function val(d::AttribDataWrapper{T}, I::SVector) where {N, T}
    nidx = length(I)
    expr = :(())
    for i in 1:nidx
        push!(expr.args, :(d.v[I[$i]]))
    end
    return :(SVector($expr))
end

"""
    val(d::AttribDataWrapper{T}, j::Int64) where {T}

Access the `j`-th value of the wrapper.
"""
function val(d::AttribDataWrapper{T}, j::Int64) where {T}
    return d.v[j]
end

"""
    nvals(d::AttribDataWrapper{T})

How many values are there stored in this wrapper?
"""
nvals(d::AttribDataWrapper{T}) where {T} = length(d.v)