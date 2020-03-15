
"""
    ShapeCollection{S <: AbstractShapeDesc, N, T}

This is the type of a homogeneous collection of finite element shapes.

- S = shape descriptor: subtype of AbstractShapeDesc{MD, NV, NF, FD}
- `IT` = type of the vertex numbers (some concrete type of `Integer`).
"""
struct ShapeCollection{IT, S <: AbstractShapeDesc{MD, NV, NF, FD} where {MD, NV, NF, FD}, NV}
    # Shape descriptor
    shapedesc::S
    # Connectivity: incidence relation Shape -> Vertex
    connectivity::Vector{SVector{NV, IT}}
end

"""
    ShapeCollection(shapedesc::S, C::Array{T, 2}) where {S <: AbstractShapeDesc, T}

Convenience constructor from a matrix. One shape per row.
"""
function ShapeCollection(shapedesc::S, C::Array{IT, 2}) where {S <: AbstractShapeDesc, IT}
    cc = [SVector{nvertices(shapedesc)}(C[idx, :]) for idx in 1:size(C, 1)]
    return ShapeCollection(shapedesc, cc)
end

"""
    shapedesc(shapes::ShapeCollection)

Retrieve the shape descriptor.
"""
shapedesc(shapes::ShapeCollection) = shapes.shapedesc

"""
    connectivity(shapes::ShapeCollection, i::I) where {I}

Retrieve connectivity of one shape from the collection.
"""
connectivity(shapes::ShapeCollection, i::I) where {I} = shapes.connectivity[i]

"""
    connectivity(shapes::ShapeCollection, I::SVector)

Retrieve connectivity of multiple shapes from the collection.

Static arrays are used to help the compiler avoid memory allocation.
"""
@generated function connectivity(shapes::ShapeCollection, I::SVector)
    nidx = length(I)
    expr = :(())
    for i in 1:nidx
        push!(expr.args, :(shapes.connectivity[I[$i]]))
    end
    return :(SVector($expr))
end

"""
    nshapes(shapes::ShapeCollection)

Number of shapes in the collection.
"""
nshapes(shapes::ShapeCollection) = length(shapes.connectivity)

"""
    manifdim(shapes::ShapeCollection)

Retrieve the manifold dimension of the collection.
"""
manifdim(shapes::ShapeCollection) = manifdim(shapes.shapedesc)

"""
    nvertices(shapes::ShapeCollection)

Retrieve the number of vertices per shape.
"""
nvertices(shapes::ShapeCollection) = nvertices(shapes.shapedesc)

"""
    facetdesc(shapes::ShapeCollection)

Retrieve the shape type of the boundary facet.
"""
facetdesc(shapes::ShapeCollection) = shapes.shapedesc.facetdesc

"""
    nfacets(shapes::ShapeCollection)

Retrieve the number of boundary facets per shape.
"""
nfacets(shapes::ShapeCollection) = nfacets(shapes.shapedesc)

"""
    facets(shapes::ShapeCollection)

Retrieve the connectivity of the facets.
"""
facets(shapes::ShapeCollection) = shapes.shapedesc.facets

"""
    connectivity(shapes::ShapeCollection, i::I) where {I}

Retrieve connectivity of one shape from the collection.
"""
function facetconnectivity(shapes::ShapeCollection, i::I, j::I) where {I}
    return shapes.connectivity[i][shapes.shapedesc.facets[j, :]]
end

"""
    skeleton(shapes::ShapeCollection; options...)

Compute the skeleton of the shape collection.

This computes a new shape collection from an existing shape collection. It
consists of facets (shapes of manifold dimension one less than the manifold
dimension of the shapes themselves).

# Options
- `boundaryonly`: include in the skeleton only shapes on the boundary
    of the input collection, `true` or `false` (default).
"""
function skeleton(shapes::ShapeCollection; options...)
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
    c = SVector{nvertices(facetdesc(shapes)), Int64}[]
    for hfa in values(hfc)
        for hf in hfa
            if (boundaryonly && hf.nref != 2) || (!boundaryonly)
                push!(c, SVector{nvertices(facetdesc(shapes))}(hf.oc))
            end
        end
    end
    return ShapeCollection(facetdesc(shapes), c)
end

"""
    boundary(shapes::ShapeCollection)

Compute the shape collection for the boundary of the collection on input.

This is a convenience version of the `skeleton` function.
"""
function boundary(shapes::ShapeCollection)
    return skeleton(shapes; boundaryonly = true)
end

"""
    IncRel0tomd

Used for dispatch of access to `0 -> d` incidence-relations.
All fields are private.
"""
struct IncRel0tomd
	_from::Int64
	_to::Int64
    _v::Vector{Vector{Int64}}
end

"""
    increl_0tomd(shapes::ShapeCollection)

Compute the incidence relation `0 -> d` for `d`-dimensional shapes.

This only makes sense for `d > 0`. For `d=1` we get for each vertex the list of
edges connected to the vertex, and analogously faces and cells for `d=2` and
`d=3`.
"""
function increl_0tomd(shapes::ShapeCollection)
	nvmax = 0
    for j in 1:nshapes(shapes)
        nvmax = max(nvmax, maximum(connectivity(shapes, j)))
    end
    _v = Vector{Int64}[];
	sizehint!(_v, nvmax)
    for i in 1:nvmax
        push!(_v, Int64[])  # initially empty arrays
    end
    for j in 1:nshapes(shapes)
		c = connectivity(shapes, j)
        for i in c
            push!(_v[i], j)
        end
    end
    return IncRel0tomd(0, manifdim(shapes), _v)
end

# """
#     increl(shapes::ShapeCollection, from::Int64, to::Int64)

# Retrieve incidence relations of type `from -> to`.
# """
# function increl(shapes::ShapeCollection, from::Int64, to::Int64)
# 	relation = "$(from) -> $(to)"
# 	if !(relation in keys(shapes.increldict))
# 		if relation == "0 -> $(to)"
# 			shapes.increldict[relation] = _v2s(shapes)
# 		end
# 	end
# 	ir = shapes.increldict[relation]
# 	return ir
# end

"""
    shapelist(ir::IncRel0tomd, j::Int64)

Retrieve list of shapes incident on vertex `j` of the incidence relation `0 -> d`.
"""
function shapelist(ir::IncRel0tomd, j::Int64)
	if j <= length(ir._v)
		return ir._v[j]
	end
	return Int64[]
end

"""
    IncRelbound

Used for dispatch of access to `d -> d-1` incidence-relations, that is from a
shape to its bounding shapes (i. e. facets as members of a global mesh).
All fields are private.
"""
struct IncRelbound
	_md::Int64 # manifold dimension of the shapes
	_f::Vector{Vector{Int64}} # director of lists of facets
end

"""
    increl_bound(shapes::ShapeCollection, facetshapes::ShapeCollection)

Compute the incidence relation `d -> d-1` for `d`-dimensional shapes.

In other words, this is the incidence between shapes and the shapes that bound
these shapes (facets). For tetrahedra as the shapes, the incidence relation
lists the numbers of the faces that bound each individual tetrahedron.

!!! Note
The numbers of the facets are signed: positive when the facet bounds the shape
in the sense in which it is defined by the shape as oriented with an outer
normal; negative otherwise. The sense is defined by the numbering of the
1st-order vertices of the facet shape.
"""
function increl_bound(shapes::ShapeCollection, facetshapes::ShapeCollection)
	function facesense(fc, oc) # is the facet used in the positive or in the negative sense?
		for i in 1:length(fc)-1
			if fc == oc
				return +1 # facet used in the positive sense
			end
			fc = circshift(fc, 1) # try a circular shift
		end
		return -1 # facet used in the positive sense
	end
	@assert manifdim(shapes) == manifdim(facetshapes)+1
	hfc = hyperfacecontainer()
    for i in 1:nshapes(facetshapes)
		fc = connectivity(facetshapes, i)
        addhyperface!(hfc, fc, i) # store the facet number with the hyper face
    end
	nsmax = nshapes(shapes)
    _f = Vector{Int64}[];
	sizehint!(_f, nsmax)
    for i in 1:nsmax
        push!(_f, fill(0, nfacets(shapes)))  # initially empty arrays
    end
	for i in 1:nshapes(shapes)
		for j in 1:nfacets(shapes)
			fc = facetconnectivity(shapes, i, j)
			hf = gethyperface(hfc, fc)
			if hf == EMPTYHYPERFACE
				@error "Hyper face not found? $(fc)"
			end
			sgn = facesense(fc[1:n1storderv(facetshapes.shapedesc)], hf.oc)
			_f[i][j] = sgn * hf.store
		end
    end
    return IncRelbound(manifdim(shapes), _f)
end

"""
    shapelist(ir::IncRelbound, j::Int64)

Retrieve list of facet shapes incident on shape `j`.

These define the incidence relation `d -> d-1`.
"""
function shapelist(ir::IncRelbound, j::Int64)
	if j <= length(ir._f)
		return ir._f[j]
	end
	return Int64[]
end
