
using StaticArrays
using LinearAlgebra
using MeshCore: VecAttrib
using MeshCore: P1, L2, H8, ShapeColl, manifdim, nfacets, facetdesc, nshapes
using MeshCore: Q4ShapeDesc, shapedesc, n1storderv, nridges, nshifts, nvertices
using MeshCore: IncRel
using MeshCore: FunAttrib
using Test

    L, W, H = 1.5*pi, 3.0, 1.5
    R = 4.0
    M, N, K = 13, 4, 2
    linix = LinearIndices((M+1, N+1, K+1))
    sn(m, n, k) = linix[m, n, k]
    
    C = SVector{8, Int}[]
    for k in 1:K, n in 1:N, m in 1:M
        c = (
        sn(m, n, k), sn(m+1, n, k), sn(m+1, n+1, k), sn(m, n+1, k), 
        sn(m, n, k+1), sn(m+1, n, k+1), sn(m+1, n+1, k+1), sn(m, n+1, k+1)
        )
        push!(C, SVector{8, Int}(c))
    end
    loc = SVector{3, Float64}[]
    for k in 1:K+1, n in 1:N+1, m in 1:M+1
        a = (m-1)/M*L
        x, y, z = (R+(n-1)/N*W) * cos(a), (R+(n-1)/N*W) * sin(a), (k-1)/K*H * (1 + a)
        push!(loc, SVector{3, Float64}(x, y, z))
    end
    
    elements = ShapeColl(H8, length(C), "elements")
    vertices = ShapeColl(P1, length(loc), "vertices")
    
    vertices.attributes["geom"] = VecAttrib(loc)
    
    connectivities = IncRel(elements, vertices, C)
    
    cart = CartesianIndices((M+1, N+1, K+1))
    access_location(i) = let 
        ci  = cart[i]
        m, n, k = ci[1], ci[2], ci[3]
        a = (m-1)/M*L
        x, y, z = (R+(n-1)/N*W) * cos(a), (R+(n-1)/N*W) * sin(a), (k-1)/K*H * (1 + a)
        SVector{3, Float64}(x, y, z)
    end

    vertices2 = ShapeColl(P1, length(loc), "vertices2")
    vertices2.attributes["geom"] = FunAttrib(0.0, prod((M+1, N+1, K+1)), access_location);
    @show vertices.attributes["geom"]
    @show vertices2.attributes["geom"]
    
    n = 0.0
    for i in 1:size(vertices2.attributes["geom"], 1)
        global n += norm(vertices.attributes["geom"][i] - vertices2.attributes["geom"][i])
    end
    @test n ≈ 0
    
    