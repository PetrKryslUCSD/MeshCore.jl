

module mtest1
using MeshCore: P1, L2, manifdim, nfacets
using Test
function test()
    @test manifdim(P1) == 0
    @test nfacets(L2) == 2

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
using MeshCore: Locations, nlocations, coordinates
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    v =  Locations(xyz)
    @test nlocations(v) == 12
    x = coordinates(v, SVector{2}([2, 4]))
    @test x[1] == SVector{2}([633.3333333333334 0.0])
    true
end
end
using .mtest2
mtest2.test()

module mtest3
using StaticArrays
using MeshCore: P1, L2, Q4, ShapeColl, manifdim, nlocations, nfacets, facetdesc, nshapes
using MeshCore: Q4ShapeDesc, shapedesc, n1storderv, nedgets, nshifts, nvertices
using MeshCore: IncRel
using Test
function test()
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    q4s = ShapeColl(Q4, 6)
    vrts = ShapeColl(P1, 12)
    mesh = IncRel(q4s, vrts, cc)
    @test manifdim(q4s) == 2
    @test nvertices(q4s) == 4
    @test facetdesc(q4s) == L2
    @test nfacets(q4s) == 4
    @test nshapes(q4s) == 6
    @test manifdim(shapedesc(q4s)) == 2
    @test nvertices(shapedesc(q4s)) == 4
    @test nfacets(shapedesc(q4s)) == 4
    @test nedgets(shapedesc(q4s)) == 4
    @test n1storderv(shapedesc(q4s)) == 4
    @test nshifts(shapedesc(q4s)) == 4
    @test mesh(3, 3) == 7
    @test mesh(1, 4) == 5
    @test mesh(6, 1) == 7

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
using MeshCore: skeleton, coordinates
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
    for i in 1:nrelations(facemesh)
        x = coordinates(locs, facemesh(i))
    end #
    @test coordinates(locs, facemesh(17)) == StaticArrays.SArray{Tuple{2},Float64,1,2}[[0.0, 400.0], [0.0, 0.0]]
    @test coordinates(locs, facemesh(17)[1]) == [0.0, 400.0]
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
using MeshCore: IncRel, Locations, transpose, nshapes
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
            allmatch = allmatch && (tmesh(j, k) == shouldget[j][k])
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
using MeshCore: Locations, boundedby, skeleton
using MeshCore: IncRel
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
    tmesh = boundedby(mesh, fmesh)
    shouldget = Array{Int64,1}[[16, 1, 14, 17], [-14, 9, 6, 15], [2, 12, 10, -1], [-10, 4, 7, -9], [13, 11, 5, -12], [-5, 8, 3, -4]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (tmesh(j, k) == shouldget[j][k])
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
using MeshCore: Locations, boundedby, skeleton, transpose
using MeshCore: IncRel
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
    bbmesh = boundedby(mesh, fmesh)
    shouldget = Array{Int64,1}[[16, 1, 14, 17], [-14, 9, 6, 15], [2, 12, 10, -1], [-10, 4, 7, -9], [13, 11, 5, -12], [-5, 8, 3, -4]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (bbmesh(j, k) == shouldget[j][k])
        end
    end
    @test allmatch
    # Now test the transposed incidence relation
    tbbmesh = transpose(bbmesh)
    shouldget = Array{Int64,1}[[1, 3], [3], [6], [4, 6], [5, 6], [2], [4], [6], [2, 4], [3, 4], [5], [3, 5], [5], [1, 2], [2], [1], [1]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (tbbmesh(j, k) == shouldget[j][k])
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
using MeshCore: Locations, boundedby2, skeleton, transpose
using MeshCore: IncRel
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
    bbmesh = boundedby2(mesh, vmesh)
    shouldget = Array{Int64,1}[[1, 2, 6, 5], [5, 6, 10, 9], [2, 3, 7, 6], [6, 7, 11, 10], [3, 4, 8, 7], [7, 8, 12, 11]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (bbmesh(j, k) == shouldget[j][k])
        end
    end
    @test allmatch
    # Now test the transposed incidence relation
    tbbmesh = transpose(bbmesh)
    shouldget = Array{Int64,1}[[1], [1, 3], [3, 5], [5], [1, 2], [1, 2, 3, 4], [3, 4, 5, 6], [5, 6], [2], [2, 4], [4, 6], [6]]
    allmatch = true
    for j in 1:length(shouldget)
        for k in 1:length(shouldget[j])
            allmatch = allmatch && (tbbmesh(j, k) == shouldget[j][k])
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
using MeshCore: P1, T4, ShapeColl,  manifdim, nvertices, nedgets, nshapes
using MeshCore: boundedby2, skeleton, boundedby, nshifts, _sense
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
            f = ir03(j, k)
            allmatch = allmatch && (j in ir30(f))
        end # k
    end # j
    @test allmatch

    # Test the incidence relations 2 -> 0 & 0 -> 2
    ir20 = skeleton(ir30)
    ir02 = transpose(ir20)
    allmatch = true
    for j in 1:nrelations(ir02)
        for k in 1:nentities(ir02, j)
            f = ir02(j, k)
            allmatch = allmatch && (j in ir20(f))
        end # k
    end # j
    @test allmatch

    # Test the incidence relations 1 -> 0 & 0 -> 1
    ir10 = skeleton(ir20)
    ir01 = transpose(ir10)
    allmatch = true
    for j in 1:nrelations(ir01)
        for k in 1:nentities(ir01, j)
            f = ir01(j, k)
            allmatch = allmatch && (j in ir10(f))
        end # k
    end # j
    @test allmatch

    # Test the incidence relations 3 -> 2 & 2 -> 3
    ir20 = skeleton(ir30)
    ir32 = boundedby(ir30, ir20)
    # Check that the tetrahedra connectivity refers to all three vertices of the faces
    allmatch = true
    @test nrelations(ir30) == nrelations(ir32)
    for j in 1:nrelations(ir32)
        for k in 1:nentities(ir32, j)
            f = ir32(j, k)
            for m in 1:3
                allmatch = allmatch && (ir20(abs(f), m) in ir30(j))
            end # m
        end # k
    end # j
    @test allmatch
    # Check that the orientations of the faces is correct
    allmatch = true
    @test nrelations(ir30) == nrelations(ir32)
    for j in 1:nrelations(ir32)
        for k in 1:nentities(ir32, j)
            for f in ir32(j)
                orientation = sign(f)
                f = abs(f)
                fc = ir20(f)
                matchone = false
                for m in 1:4
                    oc = ir30(j)[ir30.left.shapedesc.facets[m, :]]
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
            e = ir23(j, k)
            allmatch = allmatch && (j in abs.(ir32(e)))
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
    @test a.val(10) == [633.3333333333334, 800.0]

    la = LocAccess(locs)
    a = Attrib(la)
    vertices = ShapeColl(P1, size(xyz, 1), Dict(:geom=>a))
    a = vertices.attributes[:geom]
    @test a.val(10) == [633.3333333333334, 800.0]

    a = attribute(vertices, :geom)
    @test a.val(10) == [633.3333333333334, 800.0]
    # @btime $a.val(10)
    # @btime a.val(10)

    true
end
end
using .mtestattr1
mtestattr1.test()

module mt4mesh1
using StaticArrays
using MeshCore: P1, T4, ShapeColl,  manifdim, nvertices, nedgets, nshapes
using MeshCore: boundedby2, skeleton, boundedby, nshifts, _sense
using MeshCore: IncRel, Locations, transpose, nrelations, nentities, nlocations
using MeshCore: Mesh, insert!, Attrib, LocAccess, increl, shapecoll, attribute
using ..samplet4: samplet4mesh
using Test
function test()
    xyz, cc = samplet4mesh()
    # Construct the initial incidence relation
    locs = Locations(xyz)
    la = LocAccess(locs)
    vrts = ShapeColl(P1, nlocations(locs), Dict(:geom=>Attrib(la)))
    tets = ShapeColl(T4, size(cc, 1))
    ir30 = IncRel(tets, vrts, cc)

    mesh = Mesh()
    insert!(mesh, :vertices, vrts)
    insert!(mesh, :tetrahedra, tets)
    insert!(mesh, :ir30, ir30)
    
    @test shapecoll(mesh, :vertices) == vrts
    @test increl(mesh, :ir30) == ir30
    s = shapecoll(mesh, :vertices)
    a = attribute(s, :geom)
    @test a.val(nshapes(s)) == [3.0, 8.0, 5.0]

    true
end
end
using .mt4mesh1
mt4mesh1.test()
