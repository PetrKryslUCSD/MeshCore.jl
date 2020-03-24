"""
    IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}

Incidence relation expressing connectivity between an entity of the shape on the
left and a list of entities of the shape on the right.
"""
struct IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
	left::ShapeColl{LEFT}
	right::ShapeColl{RIGHT}
	_v::Vector{T} # vector of vectors of shape numbers
    name::String # name of the incidence relation
end

"""
    IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{MT}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}

Convenience constructor with a vector of vectors and a default name.
"""
function IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, v::Vector{T}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
    IncRel(left, right, deepcopy(v), left.name * " -> " * right.name)
end

"""
    IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{MT}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}

Convenience constructor supplying a matrix instead of a vector of vectors and a default name.
"""
function IncRel(left::ShapeColl{LEFT}, right::ShapeColl{RIGHT}, data::Matrix{MT}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}
	_v = [SVector{nvertices(left.shapedesc)}(data[idx, :]) for idx in 1:size(data, 1)]
	IncRel(left, right, _v, left.name * " -> " * right.name)
end

"""
    nrelations(ir::IncRel)

Number of individual relations in the incidence relation.
"""
nrelations(ir::IncRel)  = length(ir._v)

"""
    nentities(ir::IncRel, j::IT) where {IT}

Number of individual entities in the `j`-th relation in the incidence relation.
"""
nentities(ir::IncRel, j::IT) where {IT} = length(ir._v[j])

"""
    retrieve(ir::IncRel{LEFT, RIGHT, T}, j::IT1, k::IT2) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T, IT1, IT2}

Retrieve the incidence relation for `j`-th relation, k-th entity.
"""
function retrieve(ir::IncRel{LEFT, RIGHT, T}, j::IT1, k::IT2) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T, IT1, IT2}
	return ir._v[j][k]
end

"""
    retrieve(ir::IncRel{LEFT, RIGHT, T}, j::IT) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T, IT}

Retrieve the row of the incidence relation for `j`-th relation.
"""
function retrieve(ir::IncRel{LEFT, RIGHT, T}, j::IT) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T, IT}
	return ir._v[j]
end

"""
    transpose(ir::IncRel)

Compute the incidence relation `d1 -> d2`, where `d2 >= d1`.

This only makes sense for `d2 >= 0`. For `d2=1` we get for each vertex the list
of edges connected to the vertex, and analogously faces and cells for `d=2` and
`d=3`.

# Returns
Incidence relation for the transposed incidence relation. The left and right
shape collection are swapped in the output relative to the input.
"""
function transpose(ir::IncRel)
	@_check (manifdim(ir.left) >= manifdim(ir.right))
	inttype = eltype(ir._v[1])
    # Find out how many of the transpose incidence relations there are
	nvmax = 0
	for j in 1:nrelations(ir)
		for k in 1:nentities(ir, j)
			nvmax = max(nvmax, retrieve(ir, j, k))
		end
	end
	# pre-allocate relations vector
	_v = Vector{inttype}[];
	sizehint!(_v, nvmax)
	# Initialize the relations to empty
    for i in 1:nvmax
        push!(_v, inttype[])  # initially empty arrays
    end
	# Build the transpose relations
    for j in 1:nrelations(ir)
		for k in 1:nentities(ir, j)
			c = abs(retrieve(ir, j, k)) # this could be an oriented entity: remove the sign
			push!(_v[c], j)
		end
	end
    return IncRel(ir.right, ir.left, _v)
end

function _asmatrix(ir, inttype)
    c = fill(inttype(0), nshapes(ir.left), nvertices(shapedesc(ir.left)))
    for i in 1:nshapes(ir.left)
        c[i, :] = retrieve(ir, i)
    end
    return c
end

function _mysortdim2!(A)
    # Sort each row  of A in ascending order.
    m, n = size(A);
    r = zeros(eltype(A), n)
    for k in 1:m
        for i in 1:n
            r[i] = A[k,i]
        end
        sort!(r);
        for i in 1:n
            A[k,i] = r[i]
        end
    end
    return A
end

function _mysortrowsperm(A)
    # Sort the rows of A by sorting each column from back to front.
    m,n = size(A);
    indx = collect(1:m); sindx = zeros(eltype(A), m)
    nindx = zeros(eltype(A), m);
    col = zeros(eltype(A), m)
    for c = n:-1:1
        for i in 1:m
            col[i] = A[indx[i],c]
        end
        #Sorting a column vector is much faster than sorting a column matrix
        # sindx = sortperm(col, alg=QuickSort);
        sortperm!(sindx, col, alg=QuickSort); # available for 0.4, slightly faster
        for i in 1:m
            nindx[i] = indx[sindx[i]]
        end
        for i in 1:m
            indx[i] = nindx[i]
        end
    end
    return indx
end

function _countrepeats(A)
    m, n = size(A);
    occurrences = zeros(eltype(A), m);
    occurrences[1] = 1
    for i in 2:m
        if A[i, :] == A[i-1, :]
            occurrences[i] = occurrences[i-1] + 1
        else
            occurrences[i] = 1
        end
    end
    return occurrences
end

"""
    skeleton(ir::IncRel; options...)

Compute the skeleton of an incidence relation.

This computes a new incidence relation from an existing incidence relation.

# Options
- `boundaryonly`: include in the skeleton only shapes on the boundary
    of the input collection, `true` or `false` (default).

# Returns
Incidence relation for the skeleton of the input incidence relation. The left
shape collection consists of facets (shapes of manifold dimension one less than
the manifold dimension of the shapes themselves). The right shape collection is
the same as for the input.
"""
function skeleton(ir::IncRel; options...)
	@_check (manifdim(ir.right) == 0)
	@_check (manifdim(ir.left) > 0)
	inttype = eltype(ir._v[1])
    boundaryonly = false
    if :boundaryonly in keys(options)
        boundaryonly = options[:boundaryonly];
    end
    c = _asmatrix(ir, inttype) # incidence as a 2D array
    # construct a 2D array of the hyperface incidences
    hfc = c[:, facetconnectivity(ir.left, 1)]
    for i in 2:nfacets(shapedesc(ir.left))
        hfc = vcat(hfc, c[:, facetconnectivity(ir.left, i)])
    end
    # make a working copy
    s2hfc = deepcopy(hfc)
    _mysortdim2!(s2hfc) # sort columnwise
    idx = _mysortrowsperm(s2hfc) # find row permutation that sorts the rows
    # sort the rows of both the original hyper face array and the column-sorted array
    shfc = hfc[idx, :]
    s2hfc = s2hfc[idx, :]
    rep = _countrepeats(s2hfc) # find the repeats of the rows
    if boundaryonly
        isunq = falses(length(rep))
        for i in 1:length(rep)-1
            # The hyperface is boundary if it has no repeats
            isunq[i] = (rep[i] == 1) && (rep[i+1] == 1)
        end
        isunq[end] = (rep[end] == 1)
        unq = findall(a -> a == true, isunq) # all not-repeated rows are unique
        unqhfc = shfc[unq, :] # unique hyper faces
    else
        # unique rows are obtained by ignoring the repeats
        unq = findall(a -> a == 1, rep)
        unqhfc = shfc[unq, :] # unique hyper faces
    end
    return IncRel(ShapeColl(facetdesc(ir.left), size(unqhfc, 1)), ir.right, unqhfc)
end

"""
    boundary(ir::IncRel)

Compute the incidence relation for the boundary of the incidence relation on input.

This is a convenience version of the `skeleton` function.
"""
function boundary(ir::IncRel)
    return skeleton(ir; boundaryonly = true)
end

function _selectrepeating(v, nrepeats)
	m = length(v);
    occurrences = zeros(eltype(v), m);
	sort!(v)
	occurrences[1] = 1
    for i in 2:m
        if v[i] == v[i-1]
            occurrences[i] = occurrences[i-1] + 1
        else
            occurrences[i] = 1
        end
    end
	repeats = [o == nrepeats for o in occurrences]
    return v[repeats]
end

"""
    bbyfacets(ir::IncRel, fir::IncRel, tfir::IncRel)

Compute the incidence relation `d -> d-1` for `d`-dimensional shapes.

In other words, this is the incidence relation between shapes and the shapes
that bound these shapes (facets). For tetrahedra as the shapes, the incidence
relation lists the numbers of the faces that bound each individual tetrahedron.
The resulting left shape is of the same shape description as in the `ir`.

# Arguments
- `ir` = incidence relation `d -> 0`,
- `fir` = incidence relation `d-1 -> 0`,
- `tfir` = transpose of the above, incidence relation `0 -> d-1`.

# Returns
Incidence relation for the bounded-by relationship between shape collections.
The left shape collection is the same as for the `ir`, the right shape
collection is for the facets (shapes of manifold dimension one less than the
manifold dimension of the shapes themselves).

!!! note
    The numbers of the facets are signed: positive when the facet bounds the shape
    in the sense in which it is defined by the shape as oriented with an outer
    normal; negative otherwise. The sense is defined by the numbering of the
    1st-order vertices of the facet shape.
"""
function bbyfacets(ir::IncRel, fir::IncRel, tfir::IncRel)
	@_check (manifdim(ir.right) == 0) && (manifdim(tfir.left) == 0)
	@_check manifdim(ir.left) == manifdim(tfir.right)+1
	@_check manifdim(tfir.right) == manifdim(fir.left)
	inttype = eltype(ir._v[1])
	n1st = n1storderv(fir.left.shapedesc)
	nshif = nshifts(fir.left.shapedesc)
	# Sweep through the relations of d -> 0, and use the 0 -> d-1 tfir
	_c = fill(inttype(0), nrelations(ir), nfacets(ir.left))
    for i in 1:nrelations(ir) # Sweep through the relations of d -> 0
		sv = retrieve(ir, i)
		c = inttype[] # this will be the list of facets at the vertices of this entity
		for j in 1:nentities(ir, i) # for all vertices
			fv = retrieve(ir, i, j)
			for k in 1:nentities(tfir, fv)
				push!(c, retrieve(tfir, fv, k))
			end # k
		end
		c = _selectrepeating(c, nvertices(tfir.right)) # keep the repeats
		@_check length(c) == nfacets(ir.left)
		# Now figure out the orientations
		for k in 1:nfacets(ir.left)
			fc = sv[facetconnectivity(ir.left, k)]
			sfc = sort(fc)
			for j in 1:length(c)
				oc = retrieve(fir, c[j])
				if sfc == sort(oc)
					sgn = _sense(fc[1:n1st], oc, nshif)
					_c[i, k] = sgn * c[j]
					break;
				end
			end # j
		end
	end
	bfacets = ShapeColl(fir.left.shapedesc, size(_c, 1))
	return IncRel(ir.left, bfacets, _c)
end

"""
    bbyfacets(ir::IncRel, fir::IncRel)

Compute the incidence relation `d -> d-1` for `d`-dimensional shapes.

Convenience function where the transpose of the incidence relation on the right
is computed on the fly.

# See also: [`bbyfacets(ir::IncRel, fir::IncRel, tfir::IncRel)`](@ref)
"""
function bbyfacets(ir::IncRel, fir::IncRel)
	return bbyfacets(ir, fir, transpose(fir))
end

"""
    bbyedgets(ir::IncRel, eir::IncRel)

Compute the incidence relation `d -> d-2` for `d`-dimensional shapes.

In other words, this is the incidence between shapes and the shapes that "bound"
the boundaries of these shapes (i. e. edgets). For tetrahedra as the shapes, the
incidence relation lists the numbers of the edges that "bound" each individual
tetrahedron. The resulting shape is of the same shape description as the
`shapes` on input.

# Returns
The incidence relation for the "bounded by" relationship between shape
collections. The left shape collection is the same as for the `ir`, the right
shape collection is for the edgets (shapes of manifold dimension two less than
the manifold dimension of the shapes themselves).

!!! note
    The numbers of the edgets are signed: positive when the edget bounds the shape
    in the sense in which it is defined by the shape as oriented with an outer
    normal; negative otherwise. The sense is defined by the numbering of the
    1st-order vertices of the edget shape.
"""
function bbyedgets(ir::IncRel, eir::IncRel, teir::IncRel)
	@_check (manifdim(ir.right) == 0) && (manifdim(teir.left) == 0)
	@_check manifdim(ir.left) == manifdim(teir.right)+2
	@_check manifdim(teir.right) == manifdim(eir.left)
	inttype = eltype(ir._v[1])
	n1st = n1storderv(eir.left.shapedesc)
	nshif = nshifts(eir.left.shapedesc)
	# Sweep through the relations of d -> 0, and use the 0 -> d-1 teir
	_c = fill(inttype(0), nrelations(ir), nedgets(ir.left))
	for i in 1:nrelations(ir) # Sweep through the relations of d -> 0
		sv = retrieve(ir, i)
		c = inttype[] # this will be the list of facets at the vertices of this entity
		for j in 1:nentities(ir, i) # for all vertices
			fv = retrieve(ir, i, j)
			for k in 1:nentities(teir, fv)
				push!(c, retrieve(teir, fv, k))
			end # k
		end
		c = _selectrepeating(c, nvertices(teir.right)) # keep the repeats
		@_check length(c) == nedgets(ir.left)
		# Now figure out the orientations
		for k in 1:nedgets(ir.left)
			fc = sv[edgetconnectivity(ir.left, k)]
			sfc = sort(fc)
			for j in 1:length(c)
				oc = retrieve(eir, c[j])
				if sfc == sort(oc)
					sgn = _sense(fc[1:n1st], oc, nshif)
					_c[i, k] = sgn * c[j]
					break;
				end
			end # j
		end
	end
	bedgets = ShapeColl(eir.left.shapedesc, size(_c, 1))
	return IncRel(ir.left, bedgets, _c)
end

"""
    bbyedgets(ir::IncRel, eir::IncRel)

Compute the incidence relation `d -> d-2` for `d`-dimensional shapes.

Convenience function where the transpose of the incidence relation on the right
is computed on the fly.

# See also: [`bbyedgets(ir::IncRel, eir::IncRel, efir::IncRel)`](@ref)
"""
function bbyedgets(ir::IncRel, eir::IncRel)
	return bbyedgets(ir, eir, transpose(eir))
end
