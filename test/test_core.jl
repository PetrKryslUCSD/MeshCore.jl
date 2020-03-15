module mmesh1
using MeshCore: P1, L2, manifdim, nfacets
using Test
function test()
    @test manifdim(P1) == 0
    @test nfacets(L2) == 2
    true
end
end
using .mmesh1
mmesh1.test()

module mmesh2
using StaticArrays
using MeshCore: Vertices, nvertices, coordinates
using Test
function test()
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    v =  Vertices(xyz)
    @test nvertices(v) == 12
    x = coordinates(v, SVector{2}([2, 4]))
    @test x[1] == SVector{2}([633.3333333333334 0.0])
    true
end
end
using .mmesh2
mmesh2.test()

module mmesh3
using StaticArrays
using MeshCore: L2, Q4, ShapeCollection, connectivity, manifdim, nvertices, nfacets, facetdesc, nshapes
using Test
function test()
    shapedesc = Q4
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(shapedesc)}(c[idx]) for idx in 1:length(c)]
    shapes = ShapeCollection(shapedesc, cc)
    @test connectivity(shapes, 3)[3] == 7
    @test connectivity(shapes, SVector{2}([2, 4]))[1][4] == 9
    @test manifdim(shapes) == 2
    @test nvertices(shapes) == 4
    @test facetdesc(shapes) == L2
    @test nfacets(shapes) == 4
    @test nshapes(shapes) == 6
    true
end
end
using .mmesh3
mmesh3.test()

module mmesh4
using StaticArrays
using MeshCore: L2, Q4, ShapeCollection, connectivity, manifdim, nvertices, nfacets, facetdesc, nshapes, facetconnectivity
using MeshCore: hyperfacecontainer, addhyperface!
using Test
function test()
    shapedesc = Q4
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(shapedesc)}(c[idx]) for idx in 1:length(c)]
    shapes = ShapeCollection(shapedesc, cc)
    @test connectivity(shapes, 3)[3] == 7
    @test connectivity(shapes, SVector{2}([2, 4]))[1][4] == 9
    @test manifdim(shapes) == 2
    @test nvertices(shapes) == 4
    @test facetdesc(shapes) == L2
    @test nfacets(shapes) == 4

    hfc = hyperfacecontainer()
    for i in 1:nshapes(shapes)
        for j in 1:nfacets(shapes)
            fc = facetconnectivity(shapes, i, j)
            addhyperface!(hfc, fc)
        end
    end

    c = SVector{nvertices(facetdesc(shapes)), Int64}[]
    for a in values(hfc)
        for h in a
            push!(c, SVector{nvertices(facetdesc(shapes))}(h.oc))
        end
    end
    @test length(c) == 17
    skel1shapes = ShapeCollection(facetdesc(shapes), c)
    @test nshapes(skel1shapes) == 17
    true
end
end
using .mmesh4
mmesh4.test()

module mmesh5
using StaticArrays
using MeshCore: L2, Q4, ShapeCollection, connectivity, manifdim, nvertices, nfacets, facetdesc, nshapes, facetconnectivity
using MeshCore: skeleton
using Test
function test()
    shapedesc = Q4
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(shapedesc)}(c[idx]) for idx in 1:length(c)]
    shapes = ShapeCollection(shapedesc, cc)
    @test connectivity(shapes, 3)[3] == 7
    @test connectivity(shapes, SVector{2}([2, 4]))[1][4] == 9
    @test manifdim(shapes) == 2
    @test nvertices(shapes) == 4
    @test facetdesc(shapes) == L2
    @test nfacets(shapes) == 4

    skel1shapes = skeleton(shapes)
    @test nshapes(skel1shapes) == 17
    true
end
end
using .mmesh5
mmesh5.test()

module mmesh6
using StaticArrays
using MeshCore: Vertices, coordinates
using MeshCore: L2, Q4, ShapeCollection, connectivity, manifdim, nvertices, nfacets, facetdesc, nshapes, facetconnectivity
using MeshCore: skeleton
using Test
function test()
    shapedesc = Q4
    xyz = [0.0 0.0; 633.3333333333334 0.0; 1266.6666666666667 0.0; 1900.0 0.0; 0.0 400.0; 633.3333333333334 400.0; 1266.6666666666667 400.0; 1900.0 400.0; 0.0 800.0; 633.3333333333334 800.0; 1266.6666666666667 800.0; 1900.0 800.0]
    v =  Vertices(xyz)
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(shapedesc)}(c[idx]) for idx in 1:length(c)]
    shapes = ShapeCollection(shapedesc, cc)
    @test connectivity(shapes, 3)[3] == 7
    @test connectivity(shapes, SVector{2}([2, 4]))[1][4] == 9
    @test manifdim(shapes) == 2
    @test nvertices(shapes) == 4
    @test facetdesc(shapes) == L2
    @test nfacets(shapes) == 4

    skel1shapes = skeleton(shapes)
    @test nshapes(skel1shapes) == 17
    for i in 1:nshapes(skel1shapes)
        x = coordinates(v, connectivity(skel1shapes, i))
    end #
    true
end
end
using .mmesh6
mmesh6.test()

module mtopoop1
using StaticArrays
using MeshCore: L2, Q4, ShapeCollection, connectivity, manifdim, nvertices, nfacets, facetdesc, nshapes
using MeshCore: Vertices, increl_0tomd, shapelist
using Test
function test()
    xyz = [0.0 0.0; 633.3 0.0; 1266.6 0.0; 1900.0 0.0; 0.0 400.0; 633.3 400.0; 1266.6 400.0; 1900.0 400.0; 0.0 800.0; 633.3 800.0; 1266.6 800.0; 1900.0 800.0]
    vertices =  Vertices(xyz)
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    shapes = ShapeCollection(Q4, cc)
    ir = increl_0tomd(shapes)
    shouldget = Array{Int64,1}[[1], [1, 3], [3, 5], [5], [1, 2], [1, 2, 3, 4], [3, 4, 5, 6], [5, 6], [2], [2, 4], [4, 6], [6]]
    for j in 1:length(shouldget)
        @test shapelist(ir, j) == shouldget[j]
    end
    @test shapelist(ir, 1000) == Int64[]
    true
end
end
using .mtopoop1
mtopoop1.test()

module mtopoop2
using StaticArrays
using MeshCore: L2, Q4, ShapeCollection, connectivity, manifdim, nvertices, nfacets, facetdesc, nshapes
using MeshCore: Vertices, increl_bound, shapelist, skeleton
using Test
function test()
    xyz = [0.0 0.0; 633.3 0.0; 1266.6 0.0; 1900.0 0.0; 0.0 400.0; 633.3 400.0; 1266.6 400.0; 1900.0 400.0; 0.0 800.0; 633.3 800.0; 1266.6 800.0; 1900.0 800.0]
    vertices =  Vertices(xyz)
    c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
    cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
    shapes = ShapeCollection(Q4, cc)
    edgeshapes = skeleton(shapes)
    @test nshapes(edgeshapes) == 17
    ir = increl_bound(shapes, edgeshapes)
    shouldget = Array{Int64,1}[[16, 1, 14, 17], [-14, 9, 6, 15], [2, 12, 10, -1], [-10, 4, 7, -9], [13, 11, 5, -12], [-5, 8, 3, -4]]
    for j in 1:length(shouldget)
        @test shapelist(ir, j) == shouldget[j]
    end
    @test shapelist(ir, 1000) == Int64[]
    true
end
end
using .mtopoop2
mtopoop2.test()
