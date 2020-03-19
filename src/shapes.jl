"""
    ShapeColl{S <: AbsShapeDesc}

This is the type of a homogeneous collection of finite element shapes.

- `S` = shape descriptor: subtype of AbsShapeDesc.
"""
struct ShapeColl{S <: AbsShapeDesc}
    shapedesc::S # Shape descriptor
	nshapes::Int64 # Number of shapes in the collection
	attributes::Dict # dictionary of attributes
end

"""
    ShapeColl(shapedesc::S, nshapes::Int64) where {S <: AbsShapeDesc}

Set up new shape collection with an empty dictionary of attributes.
"""
function ShapeColl(shapedesc::S, nshapes::Int64) where {S <: AbsShapeDesc}
	ShapeColl(shapedesc::S, nshapes::Int64, Dict{Symbol, Any}())
end

"""
    shapedesc(shapes::ShapeColl)

Retrieve the shape descriptor.
"""
shapedesc(shapes::ShapeColl) = shapes.shapedesc

"""
    nshapes(shapes::ShapeColl)

Number of shapes in the collection.
"""
nshapes(shapes::ShapeColl) = shapes.nshapes

"""
    manifdim(shapes::ShapeColl)

Retrieve the manifold dimension of the collection.
"""
manifdim(shapes::ShapeColl) = manifdim(shapes.shapedesc)

"""
    nvertices(shapes::ShapeColl)

Retrieve the number of vertices per shape.
"""
nvertices(shapes::ShapeColl) = nvertices(shapes.shapedesc)

"""
    facetdesc(shapes::ShapeColl)

Retrieve the shape type of the boundary facet.
"""
facetdesc(shapes::ShapeColl) = shapes.shapedesc.facetdesc

"""
    nfacets(shapes::ShapeColl)

Retrieve the number of boundary facets per shape.
"""
nfacets(shapes::ShapeColl) = nfacets(shapes.shapedesc)

"""
    facetconnectivity(shapes::ShapeColl, j::Int64)

Retrieve connectivity of the `j`-th facet shape of the `i`-th shape from the collection.
"""
function facetconnectivity(shapes::ShapeColl, j::Int64)
    return shapes.shapedesc.facets[j, :]
end

"""
    edgetdesc(shapes::ShapeColl)

Retrieve the shape type of the boundary edget.
"""
edgetdesc(shapes::ShapeColl) = shapes.shapedesc.edgetdesc

"""
    nedgets(shapes::ShapeColl)

Retrieve the number of boundary edgets per shape.
"""
nedgets(shapes::ShapeColl) = nedgets(shapes.shapedesc)

"""
    edgetconnectivity(shapes::ShapeColl, j::Int64)

Retrieve connectivity of the `j`-th edget shape of the `i`-th shape from the collection.
"""
function edgetconnectivity(shapes::ShapeColl, j::Int64)
    return shapes.shapedesc.edgets[j, :]
end

"""
    attribute(shapes::ShapeColl, s::Symbol)

Retrieve a named attribute.
"""
attribute(shapes::ShapeColl, s::Symbol) = shapes.attributes[s]

function _sense(fc, oc, nshifts) # is the facet used in the positive or in the negative sense?
	if fc == oc
		return +1 # facet used in the positive sense
	end
	for i in 1:nshifts-1
		fc = circshift(fc, 1) # try a circular shift
		if fc == oc
			return +1 # facet used in the positive sense
		end
	end
	return -1 # facet used in the positive sense
end
