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
    return ShapeCollection(facetdesc(shapes), c)
end

"""
    boundary(shapes::ShapeCollection{S, N, T}) where {S, N, T}

Compute the shape collection for the boundary of the collection on input.

This is a convenience version of the `skeleton` function.
"""
function boundary(shapes::ShapeCollection{S, N, T}) where {S, N, T}
    return skeleton(shapes; boundaryonly = true)
end

struct VertexToShape{S, N, T}
	shapes::ShapeCollection{S, N, T}
	v::Vector{Vector{Int64}}
end

"""
    VertexToShape(vertices, shapes::ShapeCollection{S, N, T}) where {S, N, T}

Compute the incident relation `0 -> d` for `d`-dimensional shapes.

This only makes sense for `d > 0`. For `d=1` we get for each vertex the list of
edges connected to the vertex, and analogously faces and cells for `d=2` and
`d=3`.
"""
function VertexToShape(vertices, shapes::ShapeCollection{S, N, T}) where {S, N, T}
    v = Vector{Int64}[];
	sizehint!(v, nvertices(vertices))
    for i in 1:nvertices(vertices)
        push!(v, Int64[])  # initially empty arrays
    end
    for j in 1:nshapes(shapes)
		c = connectivity(shapes, j)
        for i in c
            push!(v[i], j)
        end
    end
    return VertexToShape(shapes, v)
end
