
# struct VertexToShape{S, N, T}
# 	shapes::ShapeCollection{S, N, T}
# 	v::Vector{Vector{Int64}}
# end

"""
    ShapeCollection{S <: AbstractShapeDesc, N, T}

This is the type of a homogeneous collection of finite element shapes.

- S = shape descriptor:
- `N` = number of vertices incident on the shape (i. e. by which the shape is
    defined)
- `T` = type of the vertex numbers (some concrete type of `Integer`).
"""
struct ShapeCollection{S <: AbstractShapeDesc, N, T}
    # Shape descriptor
    shapedesc::S
    # Connectivity: incidence relation Shape -> Vertex
    connectivity::Vector{SVector{N, T}}
    # Incidence relations, such as 0 -> d
    increldict
end

"""
    ShapeCollection(shapedesc::S, C::Array{T, 2}) where {S <: AbstractShapeDesc, T}

Convenience constructor from a matrix. One shape per row.
"""
function ShapeCollection(shapedesc::S, C::Array{T, 2}) where {S <: AbstractShapeDesc, T}
    cc = [SVector{shapedesc.nnodes}(C[idx, :]) for idx in 1:size(C, 1)]
    return ShapeCollection(shapedesc, cc, Dict())
end

"""
    shapedesc(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the shape descriptor.
"""
shapedesc(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc

"""
    connectivity(shapes::ShapeCollection{S, N, T}, i::I) where {S, N, T, I}

Retrieve connectivity of one shape from the collection.
"""
connectivity(shapes::ShapeCollection{S, N, T}, i::I) where {S, N, T, I} = shapes.connectivity[i]

"""
    connectivity(shapes::ShapeCollection{S, N, T}, I::SVector) where {S, N, T}

Retrieve connectivity of multiple shapes from the collection.

Static arrays are used to help the compiler avoid memory allocation.
"""
@generated function connectivity(shapes::ShapeCollection{S, N, T}, I::SVector) where {S, N, T}
    nidx = length(I)
    expr = :(())
    for i in 1:nidx
        push!(expr.args, :(shapes.connectivity[I[$i]]))
    end
    return :(SVector($expr))
end

"""
    nshapes(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Number of shapes in the collection.
"""
nshapes(shapes::ShapeCollection{S, N, T}) where {S, N, T} = length(shapes.connectivity)

"""
    manifdim(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the manifold dimension of the collection.
"""
manifdim(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc.manifdim

"""
    nnodes(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the number of nodes per shape.
"""
nnodes(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc.nnodes

"""
    facetdesc(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the shape type of the boundary facet.
"""
facetdesc(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc.facetdesc

"""
    nfacets(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the number of boundary facets per shape.
"""
nfacets(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc.nfacets

"""
    facets(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Retrieve the connectivity of the facets.
"""
facets(shapes::ShapeCollection{S, N, T}) where {S, N, T} = shapes.shapedesc.facets

"""
    connectivity(shapes::ShapeCollection{S, N, T}, i::I) where {S, N, T, I}

Retrieve connectivity of one shape from the collection.
"""
function facetconnectivity(shapes::ShapeCollection{S, N, T}, i::I, j::I) where {S, N, T, I}
    return shapes.connectivity[i][shapes.shapedesc.facets[j, :]]
end

"""
    skeleton(shapes::ShapeCollection{S, N, T}; options...) where {S, N, T}

Compute the skeleton of the shape collection.

It consists of facets (shapes of manifold dimension one less than the manifold
dimension of the shapes themselves).

# Options
- `boundaryonly`: include in the skeleton only shapes on the boundary
    of the input collection, `true` or `false` (default).
"""
function skeleton(shapes::ShapeCollection{S, N, T}; options...) where {S, N, T}
    boundaryonly = false
    if :boundaryonly in keys(options)
        boundaryonly = options[:boundaryonly];
    end
    hfc = hyperfacecontainer()
    for i in 1:nshapes(shapes)
        for j in 1:nfacets(shapes)
            fc = facetconnectivity(shapes, i, j)
            addhyperface!(hfc, fc)
        end
    end
    c = SVector{facetdesc(shapes).nnodes, Int64}[]
    for hfa in values(hfc)
        for hf in hfa
            if (boundaryonly && hf.nref != 2) || (!boundaryonly)
                push!(c, SVector{facetdesc(shapes).nnodes}(hf.oc))
            end
        end
    end
    return ShapeCollection(facetdesc(shapes), c, Dict())
end

"""
    boundary(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Compute the shape collection for the boundary of the collection on input.

This is a convenience version of the `skeleton` function.
"""
function boundary(shapes::ShapeCollection{S, N, T}) where {S, N, T}
    return skeleton(shapes; boundaryonly = true)
end

"""
    IncRel

Used for dispatch of access to incidence-relations.
All fields are private.
"""
struct IncRel
	_from::Int64
	_to::Int64
    _v::Vector{Vector{Int64}}
end


function _v2s(shapes::ShapeCollection{S, N, T}) where {S, N, T}
	# Compute the incidence relation `0 -> d` for `d`-dimensional shapes.
	#
	# This only makes sense for `d > 0`. For `d=1` we get for each vertex the list of
	# edges connected to the vertex, and analogously faces and cells for `d=2` and
	# `d=3`.
	nvmax = 0
    for j in 1:nshapes(shapes)
        nvmax = max(nvmax, maximum(connectivity(shapes, j)))
    end
    v = Vector{Int64}[];
	sizehint!(v, nvmax)
    for i in 1:nvmax
        push!(v, Int64[])  # initially empty arrays
    end
    for j in 1:nshapes(shapes)
		c = connectivity(shapes, j)
        for i in c
            push!(v[i], j)
        end
    end
    return IncRel(0, manifdim(shapes), v)
end

"""
    increl(shapes::ShapeCollection{S, N, T}, from::Int64, to::Int64) where {S, N, T}

Retrieve incidence relations of type `from -> to`.
"""
function increl(shapes::ShapeCollection{S, N, T}, from::Int64, to::Int64) where {S, N, T}
	relation = "$(from) -> $(to)"
	if !(relation in keys(shapes.increldict))
		if relation == "0 -> $(to)"
			shapes.increldict[relation] = _v2s(shapes)
		end
	end
	ir = shapes.increldict[relation]
	return ir
end

"""
    increllist(ir::IncRel, j::Int64)

Retrieve list of shapes incident on entity `j`.
"""
function increllist(ir::IncRel, j::Int64)
	if j <= length(ir._v)
		return ir._v[j]
	end
	return Int64[]
end
