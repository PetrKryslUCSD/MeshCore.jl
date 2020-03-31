module mtest1
using MeshCore: NoSuchShape, P1, L2, ShapeColl, manifdim, nfacets, SHAPE_DESC
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
    @test SHAPE_DESC["P1"].name == "P1"
    @test SHAPE_DESC["L2"].name == "L2"
    @test SHAPE_DESC["T3"].name == "T3"
    @test SHAPE_DESC["T4"].name == "T4"
    @test SHAPE_DESC["Q4"].name == "Q4"
    @test SHAPE_DESC["H8"].name == "H8"
    true
end
end
using .mtest1
mtest1.test()

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
using MeshCore: Locations, nlocations, coordinates, nspacedims, coordinatetype
using MeshCore: LocAccess, locations
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    v =  Locations(xyz)
    @test nlocations(v) == 12
    x = coordinates(v, SVector{2}([2, 4]))
    @test x[1] == SVector{2}([633.3333333333334 0.0])
    @test nspacedims(v) == 2
    @test coordinatetype(v) == Float64
    la = LocAccess(v)
    @test locations(la) == v
    true
end
end
using .mtest2
mtest2.test()

module mtest3
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nlocations, nfacets, facetdesc, nshapes
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
using MeshCore: skeleton
using Test
function test()
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)

    facemesh = skeleton(mesh)
    @test nrelations(facemesh) == 17
    true
end
end
using .mtest5
mtest5.test()

module mtest6
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nvertices, nfacets, facetdesc, nrelations, facetconnectivity
using MeshCore: Locations, IncRel
using MeshCore: skeleton, coordinates, retrieve
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    locs =  Locations(xyz)
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)

    facemesh = skeleton(mesh)
    @test nrelations(facemesh) == 17
    # @show facemeshx
    for i in 1:nrelations(facemesh)
        x = coordinates(locs, retrieve(facemesh, i))
    end #
    @test coordinates(locs, retrieve(facemesh, 17)) == StaticArrays.SArray{Tuple{2},Float64,1,2}[[1900.0, 800.0], [1266.6666666666667, 800.0]]
    @test coordinates(locs, retrieve(facemesh, 17)[1]) == [1900.0, 800.0]
    true
end
end
using .mtest6
mtest6.test()

module mtest7
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nvertices, nfacets, facetdesc, nrelations, facetconnectivity
using MeshCore: Locations, IncRel
using MeshCore: skeleton, coordinates, boundary, nshapes
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    locs =  Locations(xyz)
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)

    bdrymesh = boundary(mesh)
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
using MeshCore: IncRel, Locations, transpose, nshapes, retrieve
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    locs =  Locations(xyz)
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)
    # Test the transpose incidence relation
    tmesh = transpose(mesh)
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
using MeshCore: Locations, bbyfacets, skeleton, transpose
using MeshCore: IncRel, retrieve
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    locs =  Locations(xyz)
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)
    fmesh = skeleton(mesh)
    # Test the transpose incidence relation
    tmesh = bbyfacets(mesh, fmesh)
    shouldget = StaticArrays.SArray{Tuple{4},Int64,1,4}[[1, 4, -8,
2], [8, 11, 15, 9], [3, 6, -10, -4], [10, 13, 16, -11], [5, 7, -12, -6], [12, 14, 17, -13                    ]]
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
using MeshCore: Locations, bbyfacets, skeleton, transpose
using MeshCore: IncRel, retrieve
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    locs =  Locations(xyz)
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)
    fmesh = skeleton(mesh)
    # Test the bounded-by incidence relation
    bbmesh = bbyfacets(mesh, fmesh)
    shouldget = StaticArrays.SArray{Tuple{4},Int64,1,4}[[1, 4, -8, 2], [8, 11, 15, 9], [3, 6, -10, -4], [10, 13, 16, -11], [5, 7, -12, -6], [12, 14, 17, -13]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (retrieve(bbmesh, j, k) == shouldget[j][k])
        end
    end
    @test allmatch
    # Now test the transposed incidence relation
    tbbmesh = transpose(bbmesh)
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
using MeshCore: Locations, bbyridges, skeleton, transpose
using MeshCore: IncRel, retrieve
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    locs =  Locations(xyz)
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)
    # fmesh = skeleton(mesh)
    vmesh = IncRel(ShapeColl(P1, 12), vrts, [[i] for i in 1:nshapes(vrts)] )
    # Test the bounded-by incidence relation
    bbmesh = bbyridges(mesh, vmesh)
    shouldget = Array{Int64,1}[[1, 2, 6, 5], [5, 6, 10, 9], [2, 3, 7, 6], [6, 7, 11, 10], [3, 4, 8, 7], [7, 8, 12, 11]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (retrieve(bbmesh, j, k) == shouldget[j][k])
        end
    end
    @test allmatch
    # Now test the transposed incidence relation
    tbbmesh = transpose(bbmesh)
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
using MeshCore: bbyridges, skeleton, bbyfacets, nshifts, _sense, retrieve
using MeshCore: IncRel, Locations, transpose, nrelations, nentities, nlocations
using ..samplet4: samplet4mesh
using Test
function test()
    xyz, cc = samplet4mesh()
    # Construct the initial incidence relation
    locs = Locations(xyz)
    vrts = ShapeColl(P1, nlocations(locs))
    tets = ShapeColl(T4, size(cc, 1))
    ir30 = IncRel(tets, vrts, cc)
    # Test the incidence relations 3 -> 0 & 0 -> 3
    ir03 = transpose(ir30)
    allmatch = true
    for j in 1:nrelations(ir03)
        for k in 1:nentities(ir03, j)
            f = retrieve(ir03, j, k)
            allmatch = allmatch && (j in retrieve(ir30, f))
        end # k
    end # j
    @test allmatch

    # Test the incidence relations 2 -> 0 & 0 -> 2
    ir20 = skeleton(ir30)
    ir02 = transpose(ir20)
    allmatch = true
    for j in 1:nrelations(ir02)
        for k in 1:nentities(ir02, j)
            f = retrieve(ir02, j, k)
            allmatch = allmatch && (j in retrieve(ir20, f))
        end # k
    end # j
    @test allmatch

    # Test the incidence relations 1 -> 0 & 0 -> 1
    ir10 = skeleton(ir20)
    ir01 = transpose(ir10)
    allmatch = true
    for j in 1:nrelations(ir01)
        for k in 1:nentities(ir01, j)
            f = retrieve(ir01, j, k)
            allmatch = allmatch && (j in retrieve(ir10, f))
        end # k
    end # j
    @test allmatch

    # Test the incidence relations 3 -> 2 & 2 -> 3
    ir20 = skeleton(ir30)
    ir32 = bbyfacets(ir30, ir20)
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
    ir23 = transpose(ir32)
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
using MeshCore: Locations, coordinates, Attrib, LocAccess, P1, ShapeColl, attribute
using Test
# using BenchmarkTools

function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    locs =  Locations(xyz)

    # la = LocAccess(locs)
    # a = Attrib(la)
    # @btime $a.val(10)
    # @btime coordinates($locs, 10)
    #
    # a = Attrib(j -> coordinates(locs, j))
    # @btime $a.val(10)
    # @btime coordinates($locs, 10)

    la = LocAccess(locs)
    a = Attrib(la)
    @test coordinates(a.val, 10) == [633.3333333333334, 800.0]

    la = LocAccess(locs)
    a = Attrib(la, "geom")
    # @show typeof(Dict(a.name=>a))
    vertices = ShapeColl(P1, size(xyz, 1), Dict(a.name=>a))
    a = vertices.attributes["geom"]
    @test coordinates(a.val, 10) == [633.3333333333334, 800.0]

    a = attribute(vertices, "geom")
    @test coordinates(a.val, 10) == [633.3333333333334, 800.0]
    # @btime $a.val(10)
    # @btime a.val(10)

    true
end
end
using .mtestattr1
mtestattr1.test()
