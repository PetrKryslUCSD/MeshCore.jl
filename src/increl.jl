"""
    AbstractIncRel

Type of abstract incidence relation.
"""
abstract type AbstractIncRel
end

"""
    nrelations(ir::IR) where {IR<:AbstractIncRel}

Retrieve the total number of relations.
"""
nrelations(ir::IR) where {IR<:AbstractIncRel} = 0

"""
    nentities(ir::IR, i::IT) where {IR<:AbstractIncRel, IT}

Retrieve the number of entities in the `j`-th relation.
"""
nentities(ir::IR, j::IT) where {IR<:AbstractIncRel, IT} = 0

"""
    (ir::IR)(i::IT, j::IT) where {IR<:AbstractIncRel, IT}

Retrieve the number of the `k`-th entity  in the `j`-th relation.
"""
(ir::AbstractIncRel)(j::IT, k::IT) where {IT} = 0

"""
    IncRelFixed{NV, IT}

Incidence relation expressing the connectivity.
Connectivity is the `d -> 0` incidence relation. The number of entities per
relation is fixed to `NV` = number of vertices per entity; `IT` = integer type.
"""
struct IncRelFixed{NV, IT} <: AbstractIncRel
	_v::Vector{SVector{NV, IT}} # vector of arrays of entities
end

nrelations(ir::IncRelFixed)  = length(ir._v)
nentities(ir::IncRelFixed, j::IT) where {IT} = length(ir._v[j])
(ir::IncRelFixed)(j::IT, k::IT) where {IT} = ir._v[j][k]
(ir::IncRelFixed)(j::IT) where {IT} = ir._v[j]

"""
    IncRelVar

Used for dispatch of access to `d1 -> d2` incidence-relations, such as `d1 = 0`
and `d2 >= d1`, and others. The number of entities per relation is variable.
All fields are private.
"""
struct IncRelVar{IT} <: AbstractIncRel
	_v::Vector{Vector{IT}}
end

nrelations(ir::IncRelVar)  = length(ir._v)
nentities(ir::IncRelVar{IT}, j::IT) where {IT} = length(ir._v[j])
(ir::IncRelVar)(j::IT, k::IT) where {IT} = ir._v[j][k]

"""
    increl_transpose(ir::IR) where {IR<:AbstractIncRel}

Compute the incidence relation `d1 -> d2`, where `d2 >= d1` for `d2`-dimensional shapes.

This only makes sense for `d2 >= 0`. For `d2=1` we get for each vertex the list
of edges connected to the vertex, and analogously faces and cells for `d=2` and
`d=3`.
"""
function increl_transpose(ir::IR) where {IR<:AbstractIncRel}
	# Find out how many of the transpose incidence relations there are
	nvmax = 0
	for j in 1:nrelations(ir)
		for k in 1:nentities(ir, j)
			nvmax = max(nvmax, ir(j, k))
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
    for j in 1:nrelations(ir)
		for k in 1:nentities(ir, j)
			c = abs(ir(j, k)) # this could be an oriented entity: remove the sign
			push!(_v[c], j)
		end
	end
    return IncRelVar(_v)
end
