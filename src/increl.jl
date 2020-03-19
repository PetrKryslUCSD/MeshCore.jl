"""
    IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}

Incidence relation expressing connectivity between an entity of the shape on the
left and a list of entities of the shape on the right.
"""
struct IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
	left::ShapeColl{LEFT}
	right::ShapeColl{RIGHT}
	_v::Vector{T} # vector of vectors of shape numbers
end

"""
    IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{T}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}

Convenience constructor supplying a matrix instead of a vector of vectors.
"""
function IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{T}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
	_v = [SVector{nvertices(left.shapedesc)}(data[idx, :]) for idx in 1:size(data, 1)]
	IncRel(left, right, _v)
end

"""
    nrelations(ir::IncRel)

Number of individual relations in the incidence relation.
"""
nrelations(ir::IncRel)  = length(ir._v)

"""
    nentities(ir::IncRel, j::Int64) 

Number of individual entities in the `j`-th relation in the incidence relation.
"""
nentities(ir::IncRel, j::Int64) = length(ir._v[j])

"""
    (ir::IncRel)(j::IT, k::IT) where {IT}

Retrieve the incidence relation for `j`-th relation, k-th entity.
"""
(ir::IncRel)(j::IT, k::IT) where {IT} = ir._v[j][k]

"""
    (ir::IncRel)(j::IT) where {IT}

Retrieve the row of the incidence relation for `j`-th relation.
"""
(ir::IncRel)(j::IT) where {IT} = ir._v[j]

"""
    transpose(mesh::IncRel)

Compute the incidence relation `d1 -> d2`, where `d2 >= d1`.

This only makes sense for `d2 >= 0`. For `d2=1` we get for each vertex the list
of edges connected to the vertex, and analogously faces and cells for `d=2` and
`d=3`.

# Returns
Incidence relation for the transposed mesh. The left and right shape collection
are swapped in the output relative to the input.
"""
function transpose(mesh::IncRel)
	# Find out how many of the transpose incidence relations there are
	nvmax = 0
	for j in 1:nrelations(mesh)
		for k in 1:nentities(mesh, j)
			nvmax = max(nvmax, mesh(j, k))
		end
	end
	# pre-allocate relations vector
    _v = Vector{Int64}[];
	sizehint!(_v, nvmax)
	# Initialize the relations to empty
    for i in 1:nvmax
        push!(_v, Int64[])  # initially empty arrays
    end
	# Build the transpose relations
    for j in 1:nrelations(mesh)
		for k in 1:nentities(mesh, j)
			c = abs(mesh(j, k)) # this could be an oriented entity: remove the sign
			push!(_v[c], j)
		end
	end
    return IncRel(mesh.right, mesh.left, _v)
end

"""
    skeleton(mesh::IncRel; options...)

Compute the skeleton of the mesh.

This computes a new incidence relation from an existing incidence relation. 

# Options
- `boundaryonly`: include in the skeleton only shapes on the boundary
    of the input collection, `true` or `false` (default).

# Returns
Incidence relation for the skeleton mesh. The left shape collection consists of
facets (shapes of manifold dimension one less than the manifold dimension of the
shapes themselves). The right shape collection is the same as for the input.
"""
function skeleton(mesh::IncRel; options...)
    boundaryonly = false
    if :boundaryonly in keys(options)
        boundaryonly = options[:boundaryonly];
    end
    hfc = hyperfacecontainer()
    for i in 1:nrelations(mesh)
        v = mesh(i)
        for j in 1:nfacets(mesh.left)
            fc = v[facetconnectivity(mesh.left, j)]
            addhyperface!(hfc, fc)
        end
    end
    nv = nvertices(facetdesc(mesh.left))
    c = SVector{nv, Int64}[]
    for hfa in values(hfc)
        for hf in hfa
            if (boundaryonly && hf.nref != 2) || (!boundaryonly)
                push!(c, SVector{nv}(hf.oc))
            end
        end
    end
    return IncRel(ShapeColl(facetdesc(mesh.left), length(c)), mesh.right, c)
end

"""
    boundary(mesh::IncRel)

Compute the incidence relation for the boundary of the collection on input.

This is a convenience version of the `skeleton` function.
"""
function boundary(mesh::IncRel)
    return skeleton(mesh; boundaryonly = true)
end

"""
    boundedby(mesh::IncRel, fmesh::IncRel)

Compute the incidence relation `d -> d-1` for `d`-dimensional shapes.

In other words, this is the incidence between shapes and the shapes that bound
these shapes (facets). For tetrahedra as the shapes, the incidence relation
lists the numbers of the faces that bound each individual tetrahedron.
The resulting left shape is of the same shape description as in the `mesh`.

!!! note
    The numbers of the facets are signed: positive when the facet bounds the shape
    in the sense in which it is defined by the shape as oriented with an outer
    normal; negative otherwise. The sense is defined by the numbering of the
    1st-order vertices of the facet shape.

# Returns
Incidence relation for the bounded-by mesh. The left shape collection is the
same as for the `mesh`, the right shape collection is for the facets (shapes of
manifold dimension one less than the manifold dimension of the shapes
themselves).
"""
function boundedby(mesh::IncRel, fmesh::IncRel)
	@assert manifdim(mesh.left) == manifdim(fmesh.left)+1
    n1st = n1storderv(fmesh.left.shapedesc)
    nshif = nshifts(fmesh.left.shapedesc)
	hfc = hyperfacecontainer()
    for i in 1:nrelations(fmesh)
        fc = fmesh(i)
        addhyperface!(hfc, fc, i) # store the facet number with the hyper face
    end
	nsmax = nrelations(mesh)
    _v = Vector{Int64}[];
	sizehint!(_v, nsmax)
    for i in 1:nsmax
        push!(_v, fill(0, nfacets(mesh.left)))  # initially empty arrays
    end
	for i in 1:nrelations(mesh)
        v = mesh(i)
		for j in 1:nfacets(mesh.left)
            fc = v[facetconnectivity(mesh.left, j)]
			hf = gethyperface(hfc, fc)
			if hf == EMPTYHYPERFACE
				@error "Hyper face not found? $(hf)"
			end
			sgn = _sense(fc[1:n1st], hf.oc, nshif)
			_v[i][j] = sgn * hf.store
		end
    end
	cc = [SVector{nfacets(mesh.left)}(_v[idx]) for idx in 1:length(_v)]
    bfaces = ShapeColl(fmesh.left.shapedesc, length(_v))
    return IncRel(mesh.left, bfaces, cc)
end

"""
    boundedby2(mesh::IncRel, emesh::IncRel)

Compute the incidence relation `d -> d-2` for `d`-dimensional shapes.

In other words, this is the incidence between shapes and the shapes that "bound"
the boundaries of these shapes (i. e. edgets). For tetrahedra as the shapes, the
incidence relation lists the numbers of the edges that "bound" each individual
tetrahedron. The resulting shape is of the same shape description as the
`shapes` on input.

!!! note
    The numbers of the edgets are signed: positive when the edget bounds the shape
    in the sense in which it is defined by the shape as oriented with an outer
    normal; negative otherwise. The sense is defined by the numbering of the
    1st-order vertices of the edget shape.

# Returns
Incidence relation for the "bounded-by" mesh. The left shape collection is the
same as for the `mesh`, the right shape collection is for the edgets (shapes of
manifold dimension two less than the manifold dimension of the shapes
themselves).
"""
function boundedby2(mesh::IncRel, emesh::IncRel)
    @assert manifdim(mesh.left) == manifdim(emesh.left)+2
    n1st = n1storderv(emesh.left.shapedesc)
    nshif = nshifts(emesh.left.shapedesc)
    hfc = hyperfacecontainer()
    for i in 1:nrelations(emesh)
        fc = emesh(i)
        addhyperface!(hfc, fc, i) # store the facet number with the hyper face
    end
    nsmax = nrelations(mesh)
    _v = Vector{Int64}[];
    sizehint!(_v, nsmax)
    for i in 1:nsmax
        push!(_v, fill(0, nedgets(mesh.left)))  # initially empty arrays
    end
    for i in 1:nrelations(mesh)
        v = mesh(i)
        for j in 1:nedgets(mesh.left)
            fc = v[edgetconnectivity(mesh.left, j)]
            hf = gethyperface(hfc, fc)
            if hf == EMPTYHYPERFACE
                @error "Hyper face not found? $(hf)"
            end
            sgn = _sense(fc[1:n1st], hf.oc, nshif)
            _v[i][j] = sgn * hf.store
        end
    end
    cc = [SVector{nedgets(mesh.left)}(_v[idx]) for idx in 1:length(_v)]
    bedges = ShapeColl(emesh.left.shapedesc, length(_v))
    return IncRel(mesh.left, bedges, cc)
end

