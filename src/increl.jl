"""
    IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}

Incidence relation expressing connectivity between an entity of the shape on the
left and a list of entities of the shape on the right.

The incidence relation may be referred to by its code: `(d1, d2)`, where `d1` is
the manifold dimension of the shape collection on the left, and `d2` is the
manifold dimension of the shape collection on the right.

Main operations referred to with the abbreviations used in the paper:

- skt = ir_skeleton
- trp = ir_transpose
- bbf = ir_bbyfacets
- bbr = ir_bbyridges
- idt = ir_identity

Access to the incidence relation data is through indexing:
For instance
```
ir[55]
```
provides access to the entire incidence relation `ir` of the entity 55.
The first component of this incidence relation for the entity 55 is
```
ir[55][1]
```
or equivalently
```
ir[55, 1]
```
"""
struct IncRel{LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
    left::ShapeColl{LEFT}
    right::ShapeColl{RIGHT}
    _v::Vector{T} # vector of vectors of shape numbers
    name::String # name of the incidence relation
    function IncRel(
        left::ShapeColl{LEFT},
        right::ShapeColl{RIGHT},
        v::Vector{T},
        name::String,
        internal
    ) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}
        @_check (nshapes(left) == length(v))
        minn = typemax(eltype(v[1]))
        maxn = typemin(eltype(v[1]))
        for i in 1:length(v)
            if !isempty(v[i])
                minn = min(minn, minimum(abs.(v[i])))
                maxn = max(maxn, maximum(abs.(v[i])))
            end
        end
        @_check (nshapes(right) >= maxn)
        return new{LEFT,RIGHT,T}(left, right, v, name)
    end
end

# Provide access to the incidence relation data as if it was a one-dimensional
# or two dimensional array.
Base.IndexStyle(::Type{<:IncRel}) = IndexLinear()
Base.size(ir::IR) where {IR<:IncRel} = (length(ir._v),)
Base.getindex(ir::IR, i::Int) where {IR<:IncRel} = ir._v[i]
Base.getindex(ir::IR, i::Int, k::Int) where {IR<:IncRel} = ir._v[i][k]

"""
    IncRel(
        left::ShapeColl{LEFT},
        right::ShapeColl{RIGHT},
        v::Vector{Vector{IT}},
        name::String
    ) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, IT}

Convenience constructor with a vector of vectors (of integers) and a name.
"""
function IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    v::Vector{Vector{IT}},
    name::String
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, IT}
    IncRel(left, right, deepcopy(v), name, true)
end

"""
    IncRel(
            left::ShapeColl{LEFT},
            right::ShapeColl{RIGHT},
            v::Vector{Vector{IT}}
        ) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, IT}

Convenience constructor with a vector of vectors (of integers) and a default name.
"""
function IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    v::Vector{Vector{IT}},
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, IT}
    IncRel(left, right, v, "(" * left.name * ", " * right.name * ")", true)
end

"""
    IncRel(
        left::ShapeColl{LEFT},
        right::ShapeColl{RIGHT},
        v::Vector{SVector{N, IT}},
        name::String
    ) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}

Convenience constructor with a vector of static vectors (of integers) and a name.
"""
function IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    v::Vector{SVector{N, IT}},
    name::String
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}
    IncRel(left, right, deepcopy(v), name, true)
end

"""
    IncRel(
        left::ShapeColl{LEFT},
        right::ShapeColl{RIGHT},
        v::Vector{SVector{N, IT}}
    ) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}

Convenience constructor with a vector of static vectors (of integers) and a default name.
"""
function IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    v::Vector{SVector{N, IT}}
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}
    IncRel(left, right, v, "(" * left.name * ", " * right.name * ")", true)
end

"""
    IncRel(
        left::ShapeColl{LEFT},
        right::ShapeColl{RIGHT},
        data::Matrix{MT},
        name::String
    ) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}

Convenience constructor supplying a matrix and a name.
"""
function IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    data::Matrix{MT},
    name::String
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}
    _v = [SVector{nvertices(left.shapedesc)}(data[idx, :]) for idx in 1:size(data, 1)]
    IncRel(left, right, _v, name, true)
end

"""
    IncRel(
        left::ShapeColl{LEFT},
        right::ShapeColl{RIGHT},
        data::Matrix{MT}
    ) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}

Convenience constructor supplying a matrix and a default name.
"""
function IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    data::Matrix{MT}
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, MT}
    _v = [SVector{nvertices(left.shapedesc)}(data[idx, :]) for idx in 1:size(data, 1)]
    IncRel(left, right, data, "(" * left.name * ", " * right.name * ")")
end

"""
    IncRel(
        left::ShapeColl{LEFT},
        right::ShapeColl{RIGHT},
        data::Vector{NTuple{N, IT}},
        name::String
    ) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}

Convenience constructor supplying a vector of tuples instead of a vector of vectors and a name.
"""
function IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    data::Vector{NTuple{N, IT}},
    name::String
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}
    _v = [SVector{nvertices(left.shapedesc)}(data[idx]) for idx in 1:size(data, 1)]
    IncRel(left, right, _v, name, true)
end

"""
    IncRel(
        left::ShapeColl{LEFT},
        right::ShapeColl{RIGHT},
        data::Vector{NTuple{N, IT}}
    ) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}

Convenience constructor supplying a vector of tuples instead of a vector of vectors and a name.
"""
function IncRel(
    left::ShapeColl{LEFT},
    right::ShapeColl{RIGHT},
    data::Vector{NTuple{N, IT}}
) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, N, IT}
    IncRel(left, right, data, "(" * left.name * ", " * right.name * ")")
end


"""
    indextype(ir::IncRel)

Provide type of the incidence index (entity number).
Presumably some type of integer.
"""
indextype(ir::IncRel) = eltype(eltype(ir._v))

"""
    nrelations(ir::IncRel)

Number of individual relations in the incidence relation.
"""
nrelations(ir::IncRel) = length(ir._v)

"""
    nentities(ir::IncRel, j::IT) where {IT}

Number of individual entities in the `j`-th relation in the incidence relation.
"""
nentities(ir::IncRel, j::IT) where {IT} = length(ir._v[j])

"""
    code(ir::IncRel{LEFT,RIGHT,T}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T}

Formulate the code of the incidence relation.
"""
ir_code(ir::IncRel{LEFT,RIGHT,T}) where {LEFT<:AbsShapeDesc, RIGHT<:AbsShapeDesc, T} =
    (manifdim(shapedesc(ir.left)), manifdim(shapedesc(ir.right)))

"""
    ir_transpose(ir::IncRel, name = "trp")

Compute the "transposed" incidence relation `(d1, d2)`, where `d2 >= d1`.

This only makes sense for `d2 >= 0`. For `d2=1` we get for each vertex the list
of edges connected to the vertex, and analogously faces and cells for `d=2` and
`d=3`.

# Returns
Incidence relation for the transposed incidence relation. The left and right
shape collection are swapped in the output relative to the input.
"""
function ir_transpose(ir::IncRel, name = "trp")
    @_check (manifdim(ir.left) >= manifdim(ir.right))
    inttype = eltype(ir._v[1])
    # Find out how many of the transpose incidence relations there are
    nvmax = nshapes(ir.right)
    # pre-allocate relations vector
    _v = Vector{inttype}[]
    sizehint!(_v, nvmax)
    # Initialize the relations to empty
    for i in 1:nvmax
        push!(_v, inttype[])  # initially empty arrays
    end
    # Build the transpose relations
    for j in 1:nrelations(ir)
        for k in 1:nentities(ir, j)
            c = abs(ir[j, k]) # this could be an oriented entity: remove the sign
            push!(_v[c], j)
        end
    end
    return IncRel(ir.right, ir.left, _v, name)
end

function _asmatrix(ir, inttype)
    c = fill(inttype(0), nshapes(ir.left), nvertices(shapedesc(ir.left)))
    for i in 1:nshapes(ir.left)
        c[i, :] = ir[i]
    end
    return c
end

function _mysortdim2!(A)
    # Sort each row  of A in ascending order.
    m, n = size(A)
    r = zeros(eltype(A), n)
    for k in 1:m
        for i in 1:n
            r[i] = A[k, i]
        end
        sort!(r)
        for i in 1:n
            A[k, i] = r[i]
        end
    end
    return A
end

function _mysortrowsperm(A)
    # Sort the rows of A by sorting each column from back to front.
    m, n = size(A)
    indx = collect(1:m)
    sindx = zeros(eltype(A), m)
    nindx = zeros(eltype(A), m)
    col = zeros(eltype(A), m)
    for c in n:-1:1
        for i in 1:m
            col[i] = A[indx[i], c]
        end
        # Sorting a column vector is much faster than sorting a column matrix
        #sindx = sortperm(col, alg=QuickSort);
        sortperm!(sindx, col, alg = QuickSort) # available for 0.4, slightly faster
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
    m, n = size(A)
    occurrences = zeros(eltype(A), m)
    occurrences[1] = 1
    for i in 2:m
        if A[i, :] == A[i - 1, :]
            occurrences[i] = occurrences[i - 1] + 1
        else
            occurrences[i] = 1
        end
    end
    return occurrences
end

"""
    ir_skeleton(ir::IncRel, name = "skt")

Compute the "skeleton" of an incidence relation.

Compute a new incidence relation from an existing incidence relation to extract
the skeleton.

# Returns
Incidence relation for the skeleton of the input incidence relation. The left
shape collection consists of facets (shapes of manifold dimension one less than
the manifold dimension of the shapes themselves). The right shape collection is
the same as for the input.
"""
function ir_skeleton(ir::IncRel, name = "skt")
    @_check (manifdim(ir.right) == 0)
    @_check (manifdim(ir.left) > 0)
    inttype = eltype(ir._v[1])
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
    # identify boundary facets: the hyperface is boundary if it has no repeats
    isunq = [(rep[i] == 1) && (rep[i + 1] == 1) for i in 1:(length(rep) - 1)]
    push!(isunq, (rep[end] == 1)) # and the last one
    # unique rows are obtained by ignoring the repeats
    unq = findall(a -> a == 1, rep)
    unqhfc = shfc[unq, :] # unique hyper faces
    sir = IncRel(ShapeColl(facetdesc(ir.left), size(unqhfc, 1)), ir.right, unqhfc, name)
    sir.left.attributes["isboundary"] = VecAttrib(isunq[unq]) # store the is-boundary attribute
    return sir
end

"""
    ir_boundary(ir::IncRel, name = "bdr")

Compute the incidence relation for the boundary of the incidence relation on input.

The `skeleton` function.
"""
function ir_boundary(ir::IncRel, name = "bdr")
    sir = ir_skeleton(ir)
    isboundary = sir.left.attributes["isboundary"]
    ind = [i for i in 1:length(isboundary) if isboundary[i]]
    lft = ShapeColl(shapedesc(sir.left), length(ind), "facets")
    return IncRel(lft, sir.right, sir._v[ind], name)
end

function _selectrepeating(v, nrepeats)
    m = length(v)
    occurrences = zeros(eltype(v), m)
    sort!(v)
    occurrences[1] = 1
    for i in 2:m
        if v[i] == v[i - 1]
            occurrences[i] = occurrences[i - 1] + 1
        else
            occurrences[i] = 1
        end
    end
    repeats = [o == nrepeats for o in occurrences]
    return v[repeats]
end

"""
    ir_bbyfacets(ir::IncRel, fir::IncRel, tfir::IncRel, name = "bbf")

Compute the "bounded by facets" incidence relation `(d, d-1)` for `d`-dimensional shapes.

In other words, this is the incidence relation between shapes and the shapes
that bound these shapes (facets). For tetrahedra as the shapes, the incidence
relation lists the numbers of the faces that bound each individual tetrahedron.
The resulting left shape is of the same shape description as in the `ir`.

# Arguments
- `ir` = incidence relation `(d, 0)`,
- `fir` = incidence relation `(d-1, 0)`,
- `tfir` = transpose of the above, incidence relation `(0, d-1)`.

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
function ir_bbyfacets(ir::IncRel, fir::IncRel, tfir::IncRel, name = "bbf")
    @_check (manifdim(ir.right) == 0)
    @_check (manifdim(fir.right) == 0)
    @_check (manifdim(tfir.left) == 0)
    @_check manifdim(ir.left) == manifdim(tfir.right) + 1
    @_check manifdim(tfir.right) == manifdim(fir.left)
    inttype = eltype(ir._v[1])
    n1st = n1storderv(fir.left.shapedesc)
    nshif = nshifts(fir.left.shapedesc)
    # Sweep through the relations of (d, 0,) and use the (0, d-1) tfir
    _c = fill(inttype(0), nrelations(ir), nfacets(ir.left))
    for i in 1:nrelations(ir) # Sweep through the relations of (d, 0)
        sv = ir[i]
        c = inttype[] # this will be the list of facets at the vertices of this entity
        for j in 1:nentities(ir, i) # for all vertices
            fv = ir[i, j]
            for k in 1:nentities(tfir, fv)
                push!(c, tfir[fv, k])
            end # k
        end
        c = _selectrepeating(c, nvertices(tfir.right)) # keep the repeats
        @_check length(c) == nfacets(ir.left)
        # Now figure out the orientations
        for k in 1:nfacets(ir.left)
            fc = sv[facetconnectivity(ir.left, k)]
            sfc = sort(fc)
            for j in 1:length(c)
                oc = fir[c[j]]
                if sfc == sort(oc)
                    sgn = _sense(fc[1:n1st], oc, nshif)
                    _c[i, k] = sgn * c[j]
                    break
                end
            end # j
        end
    end
    bfacets = ShapeColl(fir.left.shapedesc, nshapes(tfir.right))
    return IncRel(ir.left, bfacets, _c, name)
end

"""
    ir_bbyfacets(ir::IncRel, fir::IncRel, name = "bbf")

Compute the "bounded by facets" incidence relation `(d, d-1)` for `d`-dimensional shapes.

Convenience function where the transpose of the incidence relation `fir`
is computed on the fly.

# See also: [`ir_bbyfacets(ir::IncRel, fir::IncRel, tfir::IncRel)`](@ref)
"""
function ir_bbyfacets(ir::IncRel, fir::IncRel, name = "bbf")
    return ir_bbyfacets(ir, fir, ir_transpose(fir), name)
end

"""
    ir_bbyridges(ir::IncRel, eir::IncRel, teir::IncRel, name = "bbr")

Compute the "bounded by ridges" incidence relation `(d, d-2)` for `d`-dimensional shapes.

In other words, this is the incidence between shapes and the shapes that "bound"
the boundaries of these shapes (i. e. ridges). For tetrahedra as the shapes, the
incidence relation lists the numbers of the edges that "bound" each individual
tetrahedron. The resulting shape is of the same shape description as the
`shapes` on input.

# Returns
The incidence relation for the "bounded by" relationship between shape
collections. The left shape collection is the same as for the `ir`, the right
shape collection is for the ridges (shapes of manifold dimension two less than
the manifold dimension of the shapes themselves).

!!! note
    The numbers of the ridges are signed: positive when the ridge bounds the shape
    in the sense in which it is defined by the shape as oriented with an outer
    normal; negative otherwise. The sense is defined by the numbering of the
    1st-order vertices of the ridge shape.
"""
function ir_bbyridges(ir::IncRel, eir::IncRel, teir::IncRel, name = "bbr")
    @_check (manifdim(ir.right) == 0) && (manifdim(teir.left) == 0)
    @_check manifdim(ir.left) == manifdim(teir.right) + 2
    @_check manifdim(teir.right) == manifdim(eir.left)
    inttype = eltype(ir._v[1])
    n1st = n1storderv(eir.left.shapedesc)
    nshif = nshifts(eir.left.shapedesc)
    # Sweep through the relations of (d, 0), and use the (0, d-2) teir
    _c = fill(inttype(0), nrelations(ir), nridges(ir.left))
    for i in 1:nrelations(ir) # Sweep through the relations of (d, 0)
        sv = ir[i]
        c = inttype[] # this will be the list of facets at the vertices of this entity
        for j in 1:nentities(ir, i) # for all vertices
            fv = ir[i, j]
            for k in 1:nentities(teir, fv)
                push!(c, teir[fv, k])
            end # k
        end
        c = _selectrepeating(c, nvertices(teir.right)) # keep the repeats
        @_check length(c) == nridges(ir.left)
        # Now figure out the orientations
        for k in 1:nridges(ir.left)
            fc = sv[ridgeconnectivity(ir.left, k)]
            sfc = sort(fc)
            for j in 1:length(c)
                oc = eir[c[j]]
                if sfc == sort(oc)
                    sgn = _sense(fc[1:n1st], oc, nshif)
                    _c[i, k] = sgn * c[j]
                    break
                end
            end # j
        end
    end
    bridges = ShapeColl(eir.left.shapedesc, nshapes(teir.right))
    return IncRel(ir.left, bridges, _c, name)
end

"""
    ir_bbyridges(ir::IncRel, eir::IncRel, name = "bbr")

Compute the "bounded-by-ridges" incidence relation `(d, d-2)`.

Convenience function where the transpose of the incidence relation on the right
is computed on the fly.

# See also: [`ir_bbyridges(ir::IncRel, eir::IncRel, efir::IncRel)`](@ref)
"""
function ir_bbyridges(ir::IncRel, eir::IncRel, name = "bbr")
    return ir_bbyridges(ir, eir, ir_transpose(eir), name)
end

"""
    ir_identity(ir::IncRel, side = :left)

Compute the "identity" incidence relation `(d, d)`.

Either the left (side = :left) or the right (side = :right) shape is mapped
to itself.
"""
function ir_identity(ir::IncRel, side = :left)
    if side == :left
        return IncRel(
            ir.left,
            ir.left,
            [SVector{1,Int64}([idx]) for idx in 1:nshapes(ir.left)],
        )
    else
        return IncRel(
            ir.right,
            ir.right,
            [SVector{1,Int64}([idx]) for idx in 1:nshapes(ir.right)],
        )
    end
end

"""
    ir_subset(ir::IncRel, list)

Compute the incidence relation representing a subset of the shape collection
on the left.
"""
function ir_subset(ir::IncRel, list)
    ssl = ShapeColl(ir.left.shapedesc, length(list))
    return IncRel(ssl, ir.right, ir._v[list], ir.left.name * "subset")
end

"""
    Base.summary(ir::IncRel)

Form a brief summary of the incidence relation.
"""
function Base.summary(ir::IncRel)
    return "$(ir.name): " * summary(ir.left) * ", " * summary(ir.right)
end
