module mod1ame
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nfacets, facetdesc, nshapes
using MeshCore: Q4ShapeDesc, shapedesc, n1storderv, nridges, nshifts, nvertices
using MeshCore: IncRel, retrieve
using Test
function test()
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    ir = IncRel(q4s, vrts, cc)
    q4s = ShapeColl(Q4, 6, "q4s")
    vrts = ShapeColl(P1, 12, "vrts")
    ir = IncRel(q4s, vrts, cc)
    @test summary(ir.left) == "q4s = 6 x Q4"
    @test summary(ir.right) == "vrts = 12 x P1"
    @test summary(ir) == "(q4s, vrts): q4s = 6 x Q4, vrts = 12 x P1" 
    
    true
end
end
using .mod1ame
mod1ame.test()

module mtest1
using MeshCore: NoSuchShape, P1, L2, L3, SHAPE_DESC
using MeshCore: NoSuchShape, ShapeColl, manifdim, nfacets
using MeshCore: shapedesc, nshapes, manifdim, nvertices, facetdesc, nfacets, ridgedesc, nridges
using Test
function test()
    @test manifdim(P1) == 0
    @test nfacets(L2) == 2
    vrts = ShapeColl(P1, 12)
    lines = ShapeColl(L2, 32)
    @test shapedesc(vrts) == P1
    @test nshapes(vrts) == 12
    @test manifdim(vrts) == manifdim(P1)
    @test nvertices(lines) == nvertices(L2)
    @test facetdesc(lines) == P1
    @test nfacets(lines) == nfacets(L2)
    @test ridgedesc(lines) == NoSuchShape
    @test nridges(lines) == 0

    lines3 = ShapeColl(L3, 13)
    @test nvertices(lines3) == nvertices(L3)
    @test nvertices(lines3) == 3
    @test facetdesc(lines3) == P1
    @test nfacets(lines3) == nfacets(L3)
    @test ridgedesc(lines3) == NoSuchShape
    @test nridges(lines3) == 0
    @test manifdim(lines3) == 1

    @test SHAPE_DESC["P1"].name == "P1"
    @test SHAPE_DESC["L2"].name == "L2"
    @test SHAPE_DESC["T3"].name == "T3"
    @test SHAPE_DESC["T4"].name == "T4"
    @test SHAPE_DESC["Q4"].name == "Q4"
    @test SHAPE_DESC["H8"].name == "H8"
    @test SHAPE_DESC["L3"].name == "L3"
    true
end
end
using .mtest1
mtest1.test()

module mtattr11
using MeshCore: VecAttrib
using Test
function test()
    a = VecAttrib([1, 2, 4]);
    @test getindex(a, 3)     == 4
    setindex!(a, 6, 3)    
    @test  getindex(a, 3) == 6  
    @test a[3] == 6
    a[3] = -3
    @test a[3] == -3
    # @show a
    true
end
end
using .mtattr11
mtattr11.test()

module mtest1a1
using MeshCore: _sense
using Test
function test()
    oc = [4, 1, 5, 13]
    fc = [4, 1, 5, 13]
    @test _sense(fc, oc, 4) == +1
    fc = [13, 4, 1, 5]
    @test _sense(fc, oc, 4) == +1
    fc = [1, 5, 13, 4]
    @test _sense(fc, oc, 4) == +1
    fc = [1, 4, 13, 5]
    @test _sense(fc, oc, 4) == -1
    fc = [5, 1, 4, 13]
    @test _sense(fc, oc, 4) == -1
    fc = [13, 5, 1, 4]
    @test _sense(fc, oc, 4) == -1
    fc = [4, 13, 5, 1]
    @test _sense(fc, oc, 4) == -1
    true
end
end
using .mtest1a1
mtest1a1.test()

module mtest2
using StaticArrays
using MeshCore: VecAttrib
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    N, T = size(xyz, 2), eltype(xyz)
    a =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])

    @test length(a) == 12
    x = a[SVector{2}([2, 4])]
    @test x[1] == SVector{2}([633.3333333333334 0.0])
    @test length(a[1]) == 2
    @test eltype(a[1]) == Float64
   
    true
end
end
using .mtest2
mtest2.test()

module mtest3
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nfacets, facetdesc, nshapes
using MeshCore: Q4ShapeDesc, shapedesc, n1storderv, nridges, nshifts, nvertices
using MeshCore: IncRel, retrieve
using Test
function test()
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    ir = IncRel(q4s, vrts, cc)
    q4s = ShapeColl(Q4, 6, "q4s")
    vrts = ShapeColl(P1, 12, "vrts")
    ir = IncRel(q4s, vrts, cc)
    @test ir.name == "(q4s, vrts)"
    @test manifdim(q4s) == 2
    @test nvertices(q4s) == 4
    @test facetdesc(q4s) == L2
    @test nfacets(q4s) == 4
    @test nshapes(q4s) == 6
    @test manifdim(shapedesc(q4s)) == 2
    @test nvertices(shapedesc(q4s)) == 4
    @test nfacets(shapedesc(q4s)) == 4
    @test nridges(shapedesc(q4s)) == 4
    @test n1storderv(shapedesc(q4s)) == 4
    @test nshifts(shapedesc(q4s)) == 4
    @test retrieve(ir, 3, 3) == 7
    @test retrieve(ir, 1, 4) == 5
    @test retrieve(ir, 6, 1) == 7

    true
end
end
using .mtest3
mtest3.test()

module mtest5
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nvertices, nfacets, facetdesc, nrelations, facetconnectivity
using MeshCore: IncRel
using MeshCore: ir_skeleton
using Test
function test()
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)

    facemesh = ir_skeleton(mesh)
    @test nrelations(facemesh) == 17
    true
end
end
using .mtest5
mtest5.test()

module mtest6
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nvertices, nfacets, facetdesc, nrelations, facetconnectivity
using MeshCore: VecAttrib, IncRel
using MeshCore: ir_skeleton, retrieve
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    N, T = size(xyz, 2), eltype(xyz)
    locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)

    facemesh = ir_skeleton(mesh)
    @test nrelations(facemesh) == 17
    # @show facemeshx
    for i in 1:nrelations(facemesh)
        x = locs[retrieve(facemesh, i)]
    end #
    @test locs[retrieve(facemesh, 17)] == StaticArrays.SArray{Tuple{2},Float64,1,2}[[1266.6666666666667, 800.0], [1900.0, 800.0], ]
    @test locs[retrieve(facemesh, 17)[1]] == [1266.6666666666667, 800.0]
    true
end
end
using .mtest6
mtest6.test()

module mtest7
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nvertices, nfacets, facetdesc, nrelations, facetconnectivity
using MeshCore: VecAttrib, IncRel
using MeshCore: ir_skeleton, ir_boundary, nshapes
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    N, T = size(xyz, 2), eltype(xyz)
    locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)

    bdrymesh = ir_boundary(mesh)
    @test nrelations(bdrymesh) == 10
    # @show bdrymesh.left, bdrymesh.right
    @test nshapes(bdrymesh.left) == 10
    @test nshapes(bdrymesh.right) == 12
    true
end
end
using .mtest7
mtest7.test()

module mtopoop1
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nvertices, nfacets, facetdesc, nshapes
using MeshCore: IncRel, ir_transpose, nshapes, retrieve, VecAttrib
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    N, T = size(xyz, 2), eltype(xyz)
    locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)
    # Test the transpose incidence relation
    tmesh = ir_transpose(mesh)
    shouldget = Array{Int64,1}[[1], [1, 3], [3, 5], [5], [1, 2], [1, 2, 3, 4], [3, 4, 5, 6], [5, 6], [2], [2, 4], [4, 6], [6]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (retrieve(tmesh, j, k) == shouldget[j][k])
        end
    end
    @test allmatch
    true
end
end
using .mtopoop1
mtopoop1.test()

module mtopoop2
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nvertices, nfacets, facetdesc, nshapes
using MeshCore: ir_bbyfacets, ir_skeleton, ir_transpose
using MeshCore: IncRel, retrieve, VecAttrib
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    N, T = size(xyz, 2), eltype(xyz)
    locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)
    fmesh = ir_skeleton(mesh)
    # Test the transpose incidence relation
    tmesh = ir_bbyfacets(mesh, fmesh)
    shouldget = StaticArrays.SArray{Tuple{4},Int64,1,4}[
    [2, 4, 1, 8],                                                            
    [9, 11, 8, 15],                                                          
    [4, 6, 3, 10],                                                           
    [11, 13, 10, 16],                                                        
    [6, 7, 5, 12],                                                          
    [13, 14, 12, 17]   ]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (retrieve(tmesh, j, k) == shouldget[j][k])
        end
    end
    @test allmatch
    true
end
end
using .mtopoop2
mtopoop2.test()

module mtopoop3
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nvertices, nfacets, facetdesc, nshapes
using MeshCore: ir_bbyfacets, ir_skeleton, ir_transpose
using MeshCore: IncRel, retrieve, VecAttrib
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    N, T = size(xyz, 2), eltype(xyz)
        locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)
    fmesh = ir_skeleton(mesh)
    # Test the bounded-by incidence relation
    bbmesh = ir_bbyfacets(mesh, fmesh)
    shouldget = StaticArrays.SArray{Tuple{4},Int64,1,4}[
    [2, 4, 1, 8],                                                           
    [9, 11, 8, 15],                                                         
    [4, 6, 3, 10],                                                          
    [11, 13, 10, 16],                                                       
    [6, 7, 5, 12],                                                          
    [13, 14, 12, 17]    ]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (retrieve(bbmesh, j, k) == shouldget[j][k])
        end
    end
    @test allmatch
    # Now test the transposed incidence relation
    tbbmesh = ir_transpose(bbmesh)
    shouldget = Array{Int64,1}[[1], [1], [3], [1, 3], [5], [3, 5], [5], [1, 2], [2], [3, 4], [2, 4], [5, 6],
    [4, 6], [6], [2], [4], [6]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (retrieve(tbbmesh, j, k) == shouldget[j][k])
        end
    end
    @test allmatch
    true
end
end
using .mtopoop3
mtopoop3.test()

module mtopoop4
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nvertices, nfacets, facetdesc, nshapes
using MeshCore: ir_bbyridges, ir_skeleton, ir_transpose
using MeshCore: IncRel, retrieve, VecAttrib
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    N, T = size(xyz, 2), eltype(xyz)
        locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)
    # fmesh = skeleton(mesh)
    vmesh = IncRel(ShapeColl(P1, 12), vrts, [[i] for i in 1:nshapes(vrts)] )
    # Test the bounded-by incidence relation
    bbmesh = ir_bbyridges(mesh, vmesh)
    shouldget = Array{Int64,1}[[1, 2, 6, 5], [5, 6, 10, 9], [2, 3, 7, 6], [6, 7, 11, 10], [3, 4, 8, 7], [7, 8, 12, 11]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (retrieve(bbmesh, j, k) == shouldget[j][k])
        end
    end
    @test allmatch
    # Now test the transposed incidence relation
    tbbmesh = ir_transpose(bbmesh)
    shouldget = Array{Int64,1}[[1], [1, 3], [3, 5], [5], [1, 2], [1, 2, 3, 4], [3, 4, 5, 6], [5, 6], [2], [2, 4], [4, 6], [6]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (retrieve(tbbmesh, j, k) == shouldget[j][k])
        end
    end
    @test allmatch
    true
end
end
using .mtopoop4
mtopoop4.test()

include("samplet4.jl")

module mt4topo1
using StaticArrays
using MeshCore: P1, T4, ShapeColl,  manifdim, nvertices, nridges, nshapes
using MeshCore: ir_bbyridges, ir_skeleton, ir_bbyfacets, nshifts, _sense, retrieve
using MeshCore: IncRel, ir_transpose, nrelations, nentities, VecAttrib
using ..samplet4: samplet4mesh
using Test
function test()
    xyz, cc = samplet4mesh()
    # Construct the initial incidence relation
    N, T = size(xyz, 2), eltype(xyz)
    locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
    vrts = ShapeColl(P1, length(locs))
    tets = ShapeColl(T4, size(cc, 1))
    ir30 = IncRel(tets, vrts, cc)
    # Test the incidence relations 3 -> 0 & 0 -> 3
    ir03 = ir_transpose(ir30)
    allmatch = true
    for j in 1:nrelations(ir03)
        for k in 1:nentities(ir03, j)
            f = retrieve(ir03, j, k)
            allmatch = allmatch && (j in retrieve(ir30, f))
        end # k
    end # j
    @test allmatch

    # Test the incidence relations 2 -> 0 & 0 -> 2
    ir20 = ir_skeleton(ir30)
    ir02 = ir_transpose(ir20)
    allmatch = true
    for j in 1:nrelations(ir02)
        for k in 1:nentities(ir02, j)
            f = retrieve(ir02, j, k)
            allmatch = allmatch && (j in retrieve(ir20, f))
        end # k
    end # j
    @test allmatch

    # Test the incidence relations 1 -> 0 & 0 -> 1
    ir10 = ir_skeleton(ir20)
    ir01 = ir_transpose(ir10)
    allmatch = true
    for j in 1:nrelations(ir01)
        for k in 1:nentities(ir01, j)
            f = retrieve(ir01, j, k)
            allmatch = allmatch && (j in retrieve(ir10, f))
        end # k
    end # j
    @test allmatch

    # Test the incidence relations 3 -> 2 & 2 -> 3
    ir20 = ir_skeleton(ir30)
    ir32 = ir_bbyfacets(ir30, ir20)
    # Check that the tetrahedra connectivity refers to all three vertices of the faces
    allmatch = true
    @test nrelations(ir30) == nrelations(ir32)
    for j in 1:nrelations(ir32)
        for k in 1:nentities(ir32, j)
            f = retrieve(ir32, j, k)
            for m in 1:3
                allmatch = allmatch && (retrieve(ir20, abs(f), m) in retrieve(ir30, j))
            end # m
        end # k
    end # j
    @test allmatch
    # Check that the orientations of the faces is correct
    allmatch = true
    @test nrelations(ir30) == nrelations(ir32)
    for j in 1:nrelations(ir32)
        for k in 1:nentities(ir32, j)
            for f in retrieve(ir32, j)
                orientation = sign(f)
                f = abs(f)
                fc = retrieve(ir20, f)
                matchone = false
                for m in 1:4
                    oc = retrieve(ir30, j)[ir30.left.shapedesc.facets[m, :]]
                    if length(intersect(fc, oc)) == 3
                        s = _sense(fc, oc, nshifts(ir20.left.shapedesc))
                        matchone = (s == orientation)
                    end
                    if matchone
                        break
                    end
                end # m
                allmatch = allmatch && matchone
            end
        end # k
    end # j
    @test allmatch
    # Check the transpose incidence relation
    ir23 = ir_transpose(ir32)
    allmatch = true
    for j in 1:nrelations(ir23)
        for k in 1:nentities(ir23, j)
            e = retrieve(ir23, j, k)
            allmatch = allmatch && (j in abs.(retrieve(ir32, e)))
        end # k
    end # j
    @test allmatch
    true
end
end
using .mt4topo1
mt4topo1.test()

module mtestattr1
using StaticArrays
using MeshCore: VecAttrib, P1, ShapeColl, attribute
using Test
# using BenchmarkTools

function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    N, T = size(xyz, 2), eltype(xyz)
    locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])

    @test locs[10] == [633.3333333333334, 800.0]

    # @show typeof(Dict(a.name=>a))
    # @show typeof(Dict("geom"=>locs))
    vertices = ShapeColl(P1, size(xyz, 1))
    vertices.attributes["geom"] = locs
    locs = vertices.attributes["geom"]
    @test locs[10] == [633.3333333333334, 800.0]
    @test length(locs) == 12

    locs = attribute(vertices, "geom")
    @test locs[10] == [633.3333333333334, 800.0]

    true
end
end
using .mtestattr1
mtestattr1.test()

module m113651
using Test
using StaticArrays
using MeshCore: VecAttrib, ShapeColl, P1, attribute
function test()
	xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0]
	N, T = size(xyz, 2), eltype(xyz)
	locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])
	vertices = ShapeColl(P1, size(xyz, 1))
    vertices.attributes["geom"] = locs
	a = attribute(vertices, "geom")
	@test a[2] == [633.3333333333334, 0.0]

    dofn =  VecAttrib([i for i in 1:size(xyz, 1)])
    vertices.attributes["dofn"] = dofn
    # @show keys(vertices.attributes)
    @test "geom" in keys(vertices.attributes)
    @test "dofn" in keys(vertices.attributes)
end
end
using .m113651
m113651.test()

# module m1136193
# using Test
# using StaticArrays
# using MeshCore: VecAttrib, ShapeColl, P1, attribute
# function test()
# 	xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0]
# 	a = Attrib(i -> 1)
# 	vertices = ShapeColl(P1, size(xyz, 1), Dict("label"=>a))
# 	a = attribute(vertices, "label")
# 	@test a.co(3) == 1
# end
# end
# using .m1136193
# m1136193.test()

module mtest3a1
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nfacets, facetdesc, nshapes
using MeshCore: Q4ShapeDesc, shapedesc, n1storderv, nridges, nshifts, nvertices
using MeshCore: IncRel, retrieve
using Test
function test()
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    ir = IncRel(q4s, vrts, cc)
    q4s = ShapeColl(Q4, 6, "q4s")
    vrts = ShapeColl(P1, 12, "vrts")
    ir = IncRel(q4s, vrts, cc)
    @test ir.name == "(q4s, vrts)"
    @test manifdim(q4s) == 2
    @test nvertices(q4s) == 4
    @test facetdesc(q4s) == L2
    @test nfacets(q4s) == 4
    @test nshapes(q4s) == 6
    @test manifdim(shapedesc(q4s)) == 2
    @test nvertices(shapedesc(q4s)) == 4
    @test nfacets(shapedesc(q4s)) == 4
    @test nridges(shapedesc(q4s)) == 4
    @test n1storderv(shapedesc(q4s)) == 4
    @test nshifts(shapedesc(q4s)) == 4
    @test retrieve(ir, 3, 3) == 7
    @test retrieve(ir, 1, 4) == 5
    @test retrieve(ir, 6, 1) == 7

    ir = IncRel(q4s, vrts, cc, "vertices")
    @test ir.name == "vertices"
    
    true
end
end
using .mtest3a1
mtest3a1.test()


module mtest3a2
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nfacets, facetdesc, nshapes
using MeshCore: Q4ShapeDesc, shapedesc, n1storderv, nridges, nshifts, nvertices
using MeshCore: IncRel, retrieve, ir_subset, nrelations
using Test
function test()
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    ir = IncRel(q4s, vrts, cc)
    sir = ir_subset(ir, [1, 2])
    @test nrelations(sir) == 2
    @test isapprox(retrieve(sir, 1), [1, 2, 6, 5])
    
    true
end
end
using .mtest3a2
mtest3a2.test()

module mfeat1
using StaticArrays
using MeshCore: P1, L2, Q4, H8, T3, T4
using MeshCore: nfeatofdim
# using BenchmarkTools
using Test
function test()
    @test nfeatofdim(P1, 0) == 1
    @test nfeatofdim(P1, 1) == 0
    @test nfeatofdim(P1, 2) == 0
    @test nfeatofdim(P1, 3) == 0
    
    @test nfeatofdim(L2, 0) == 2
    @test nfeatofdim(L2, 1) == 1
    @test nfeatofdim(L2, 2) == 0
    @test nfeatofdim(L2, 3) == 0

    @test nfeatofdim(T3, 0) == 3
    @test nfeatofdim(T3, 1) == 3
    @test nfeatofdim(T3, 2) == 1
    @test nfeatofdim(T3, 3) == 0

    @test nfeatofdim(T4, 0) == 4
    @test nfeatofdim(T4, 1) == 6
    @test nfeatofdim(T4, 2) == 4
    @test nfeatofdim(T4, 3) == 1

    @test nfeatofdim(Q4, 0) == 4
    @test nfeatofdim(Q4, 1) == 4
    @test nfeatofdim(Q4, 2) == 1
    @test nfeatofdim(Q4, 3) == 0

    @test nfeatofdim(H8, 0) == 8
    @test nfeatofdim(H8, 1) == 12
    @test nfeatofdim(H8, 2) == 6
    @test nfeatofdim(H8, 3) == 1

    # @btime nfeatofdim($H8, 0)
    # @btime nfeatofdim($H8, 1)
    # @btime nfeatofdim($H8, 2)
    # @btime nfeatofdim($H8, 3)
    true
end
end
using .mfeat1
mfeat1.test()

module mtest4a5
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nfacets, facetdesc, nshapes
using MeshCore: Q4ShapeDesc, shapedesc, n1storderv, nridges, nshifts, nvertices
using MeshCore: IncRel, retrieve, ir_subset, nrelations, ir_identity
using Test
function test()
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    ir = IncRel(q4s, vrts, cc)
    sir = ir_subset(ir, [1, 2])
    @test nrelations(sir) == 2
    @test isapprox(retrieve(sir, 1), [1, 2, 6, 5])
    ir1 = ir_identity(ir, :left)
    @test nrelations(ir1) == 6 
    @test nshapes(ir1.left) == 6 
    @test nshapes(ir1.right) == 6 
    true
end
end
using .mtest4a5
mtest4a5.test()

module mtest1q
using MeshCore: NoSuchShape, P1, L3, T6, SHAPE_DESC
using MeshCore: NoSuchShape, ShapeColl, manifdim, nfacets
using MeshCore: shapedesc, nshapes, manifdim, nvertices, facetdesc, nfacets, ridgedesc, nridges, n1storderv
using Test
function test()
    @test manifdim(P1) == 0
    @test nfacets(L3) == 2
    @test nvertices(L3) == 3
    @test n1storderv(L3) == 2
    @test nfacets(T6) == 3
    
    vrts = ShapeColl(P1, 12)
    lines = ShapeColl(L3, 32)
    @test shapedesc(vrts) == P1
    @test nshapes(vrts) == 12
    @test manifdim(vrts) == manifdim(P1)
    @test nvertices(lines) == nvertices(L3)
    @test facetdesc(lines) == P1
    @test nfacets(lines) == nfacets(L3)
    @test ridgedesc(lines) == NoSuchShape
    @test nridges(lines) == 0

    tris6 = ShapeColl(T6, 13)
    @test nvertices(tris6) == nvertices(T6)
    @test nvertices(tris6) == 6
    @test n1storderv(T6) == 3
    @test facetdesc(tris6) == L3
    @test nfacets(tris6) == nfacets(T6)
    @test ridgedesc(tris6) == P1
    @test nridges(tris6) == 3
    @test manifdim(tris6) == 2

    @test SHAPE_DESC["P1"].name == "P1"
    @test SHAPE_DESC["L2"].name == "L2"
    @test SHAPE_DESC["T3"].name == "T3"
    @test SHAPE_DESC["T6"].name == "T6"
    @test SHAPE_DESC["T4"].name == "T4"
    @test SHAPE_DESC["Q4"].name == "Q4"
    @test SHAPE_DESC["H8"].name == "H8"
    @test SHAPE_DESC["L3"].name == "L3"
    true
end
end
using .mtest1q
mtest1q.test()


module mtest2q
using MeshCore: NoSuchShape, P1, L3, Q8, SHAPE_DESC
using MeshCore: NoSuchShape, ShapeColl, manifdim, nfacets
using MeshCore: shapedesc, nshapes, manifdim, nvertices, facetdesc, nfacets, ridgedesc, nridges, n1storderv
using Test
function test()
    @test manifdim(P1) == 0
    @test nfacets(L3) == 2
    @test nvertices(L3) == 3
    @test n1storderv(L3) == 2
    @test nfacets(Q8) == 4
    @test nridges(Q8) == 4
    
    vrts = ShapeColl(P1, 12)
    lines = ShapeColl(L3, 32)
    @test shapedesc(vrts) == P1
    @test nshapes(vrts) == 12
    @test manifdim(vrts) == manifdim(P1)
    @test nvertices(lines) == nvertices(L3)
    @test facetdesc(lines) == P1
    @test nfacets(lines) == nfacets(L3)
    @test ridgedesc(lines) == NoSuchShape
    @test nridges(lines) == 0

    q8s = ShapeColl(Q8, 13)
    @test nvertices(q8s) == nvertices(Q8)
    @test nvertices(q8s) == 8
    @test n1storderv(Q8) == 4
    @test facetdesc(q8s) == L3
    @test nfacets(q8s) == nfacets(Q8)
    @test ridgedesc(q8s) == P1
    @test nridges(q8s) == 4
    @test manifdim(q8s) == 2

    @test SHAPE_DESC["P1"].name == "P1"
    @test SHAPE_DESC["L2"].name == "L2"
    @test SHAPE_DESC["T3"].name == "T3"
    @test SHAPE_DESC["T6"].name == "T6"
    @test SHAPE_DESC["T4"].name == "T4"
    @test SHAPE_DESC["Q4"].name == "Q4"
    @test SHAPE_DESC["Q8"].name == "Q8"
    @test SHAPE_DESC["H8"].name == "H8"
    @test SHAPE_DESC["L3"].name == "L3"
    true
end
end
using .mtest2q
mtest2q.test()

module mtestbb1
using MeshCore: @_check
using Test
function test()
    @_check 1 == 1 "Really?"
    @_check 1 == 1 "Why " * "not?"
    a = 13
    b = 13
    @_check a == b "Why is $a " * "not equal to $b?"
    a = 61
    @_check a > b "Why is $a " * "not greater than $b?"
    Test.@test_throws AssertionError @_check(a < b, "Why is $a " * "not greater than $b?")
    true
end
end
using .mtestbb1
mtestbb1.test()

module mtestattr6
using StaticArrays
using MeshCore: VecAttrib, P1, ShapeColl, attribute
using Test
# using BenchmarkTools

function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    N, T = size(xyz, 2), eltype(xyz)
    locs =  VecAttrib([SVector{N, T}(xyz[i, :]) for i in 1:size(xyz, 1)])

    @test locs[10] == [633.3333333333334, 800.0]
    locs[10] = -locs[10]
    @test locs[10] == [-633.3333333333334, -800.0]
    @test isapprox(locs[8:10], StaticArrays.SArray{Tuple{2},Float64,1,2}[[1900.0, 400.0], [0.0, 800.0], [-633.3333333333334, -800.0]])
    locs[8:10] .= StaticArrays.SArray{Tuple{2},Float64,1,2}[[1.0, 1.0], [1.0, 1.0], [1.0, 1.0]]
    @test isapprox(locs[8:10], StaticArrays.SArray{Tuple{2},Float64,1,2}[[1.0, 1.0], [1.0, 1.0], [1.0, 1.0]])

    true
end
end
using .mtestattr6
mtestattr6.test()


module mtesat4a5
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nfacets, facetdesc, nshapes
using MeshCore: Q4ShapeDesc, shapedesc, n1storderv, nridges, nshifts, nvertices
using MeshCore: IncRel, retrieve, ir_subset, nrelations, ir_identity, indextype, ir_code
using Test
function test()
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    ir = IncRel(q4s, vrts, cc)
    @test indextype(ir) == Int64
    @test ir_code(ir) == (2, 0)
    sir = ir_subset(ir, [1, 2])
    @test nrelations(sir) == 2
    @test isapprox(retrieve(sir, 1), [1, 2, 6, 5])
    ir1 = ir_identity(ir, :left)
    @test nrelations(ir1) == 6 
    @test nshapes(ir1.left) == 6 
    @test nshapes(ir1.right) == 6 
    true
end
end
using .mtesat4a5
mtesat4a5.test()


module mfeatx1
using StaticArrays
using MeshCore: P1, L2, Q4, H8, T3, T4, T6, L3
using MeshCore: nfeatofdim
# using BenchmarkTools
using Test
function test()
  
    @test nfeatofdim(L3, 0) == 3
    @test nfeatofdim(L3, 1) == 1
    @test nfeatofdim(L3, 2) == 0
    @test nfeatofdim(L3, 3) == 0

    @test nfeatofdim(T6, 0) == 6
    @test nfeatofdim(T6, 1) == 3
    @test nfeatofdim(T6, 2) == 1
    @test nfeatofdim(T6, 3) == 0

    true
end
end
using .mfeatx1
mfeatx1.test()


module mtest3y1
using StaticArrays
using MeshCore.Exports
using Test
function test()
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    ir = IncRel(q4s, vrts, cc)
    q4s = ShapeColl(Q4, 6, "q4s")
    vrts = ShapeColl(P1, 12, "vrts")
    ir = IncRel(q4s, vrts, cc)
    @test ir.name == "(q4s, vrts)"
    @test manifdim(q4s) == 2
    @test nvertices(q4s) == 4
    @test facetdesc(q4s) == L2
    @test nfacets(q4s) == 4
    @test nshapes(q4s) == 6
    @test manifdim(shapedesc(q4s)) == 2
    @test nvertices(shapedesc(q4s)) == 4
    @test nfacets(shapedesc(q4s)) == 4
    @test nridges(shapedesc(q4s)) == 4
    @test n1storderv(shapedesc(q4s)) == 4
    @test nshifts(shapedesc(q4s)) == 4
    @test retrieve(ir, 3, 3) == 7
    @test retrieve(ir, 1, 4) == 5
    @test retrieve(ir, 6, 1) == 7

    true
end
end
using .mtest3y1
mtest3y1.test()

module mtest1y2
using MeshCore.Exports
using Test
function test()
    @test manifdim(P1) == 0
    @test nfacets(L2) == 2
    vrts = ShapeColl(P1, 12)
    lines = ShapeColl(L2, 32)
    @test shapedesc(vrts) == P1
    @test nshapes(vrts) == 12
    @test manifdim(vrts) == manifdim(P1)
    @test nvertices(lines) == nvertices(L2)
    @test facetdesc(lines) == P1
    @test nfacets(lines) == nfacets(L2)
    @test ridgedesc(lines) == NoSuchShape
    @test nridges(lines) == 0

    lines3 = ShapeColl(L3, 13)
    @test nvertices(lines3) == nvertices(L3)
    @test nvertices(lines3) == 3
    @test facetdesc(lines3) == P1
    @test nfacets(lines3) == nfacets(L3)
    @test ridgedesc(lines3) == NoSuchShape
    @test nridges(lines3) == 0
    @test manifdim(lines3) == 1

    @test SHAPE_DESC["P1"].name == "P1"
    @test SHAPE_DESC["L2"].name == "L2"
    @test SHAPE_DESC["T3"].name == "T3"
    @test SHAPE_DESC["T4"].name == "T4"
    @test SHAPE_DESC["Q4"].name == "Q4"
    @test SHAPE_DESC["H8"].name == "H8"
    @test SHAPE_DESC["L3"].name == "L3"
    true
end
end
using .mtest1y2
mtest1y2.test()
