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
la = LocAccess(locs)
a = Attrib(la)
vertices = ShapeColl(P1, size(xyz, 1), Dict(:geom=>a))
a = vertices.attributes[:geom]
@test a.val(10) == [633.3333333333334, 800.0]
```
Attribute to label the vertices.
```
a = Attrib(i -> 1)
vertices = ShapeColl(P1, size(xyz, 1), Dict(:label=>a))
a = vertices.attributes[:label]
@test a.val(10) == 1
```
"""
struct Attrib{F}<:AbsAttrib
    val::F # function or a callable object
    name::String # name of the attribute
end

"""
    Attrib(val::F) where {F}

Construct attribute with default name.
"""
function Attrib(val::F) where {F}
    Attrib(val, "attrib")
end