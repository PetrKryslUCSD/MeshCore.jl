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

module mmesh1a1
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
using .mmesh1a1
mmesh1a1.test()

module mmesh2
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
using .mmesh2
mmesh2.test()

module mmesh3
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
using .mmesh3
mmesh3.test()

module mmesh5
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
using .mmesh5
mmesh5.test()

module mmesh6
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
using .mmesh6
mmesh6.test()
#
# module mtopoop1
# using StaticArrays
# using MeshCore: L2, Q4, ShapeColl, connectivity, manifdim, nvertices, nfacets, facetdesc, nshapes
# using MeshCore: IncRel, Vertices, increl_transpose
# using Test
# function test()
#     xyz = [0.0 0.0; 633.3 0.0; 1266.6 0.0; 1900.0 0.0; 0.0 400.0; 633.3 400.0; 1266.6 400.0; 1900.0 400.0; 0.0 800.0; 633.3 800.0; 1266.6 800.0; 1900.0 800.0]
#     vertices =  Vertices(xyz)
#     c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
#     cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
#     shapes = ShapeColl(Q4, IncRel(cc))
#     tincrel = increl_transpose(shapes.increl)
#     shouldget = Array{Int64,1}[[1], [1, 3], [3, 5], [5], [1, 2], [1, 2, 3, 4], [3, 4, 5, 6], [5, 6], [2], [2, 4], [4, 6], [6]]
#     allmatch = true
#     for j in 1:length(shouldget)
#         for k in 1:length(shouldget[j])
#             allmatch = allmatch && (tincrel(j, k) == shouldget[j][k])
#         end
#     end
#     @test allmatch
#     true
# end
# end
# using .mtopoop1
# mtopoop1.test()
#
# module mtopoop2
# using StaticArrays
# using MeshCore: L2, Q4, ShapeColl, connectivity, manifdim, nvertices, nfacets, facetdesc, nshapes
# using MeshCore: Vertices, boundedby, skeleton
# using MeshCore: IncRel, Vertices
# using Test
# function test()
#     xyz = [0.0 0.0; 633.3 0.0; 1266.6 0.0; 1900.0 0.0; 0.0 400.0; 633.3 400.0; 1266.6 400.0; 1900.0 400.0; 0.0 800.0; 633.3 800.0; 1266.6 800.0; 1900.0 800.0]
#     vertices =  Vertices(xyz)
#     c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
#     cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
#     shapes = ShapeColl(Q4, IncRel(cc))
#     facetshapes = skeleton(shapes)
#     @test nshapes(facetshapes) == 17
#     bbshapes = boundedby(shapes, facetshapes)
#     shouldget = Array{Int64,1}[[16, 1, 14, 17], [-14, 9, 6, 15], [2, 12, 10, -1], [-10, 4, 7, -9], [13, 11, 5, -12], [-5, 8, 3, -4]]
#     allmatch = true
#     for j in 1:length(shouldget)
#         for k in 1:length(shouldget[j])
#             allmatch = allmatch && (bbshapes.increl(j, k) == shouldget[j][k])
#         end
#     end
#     @test allmatch
#     true
# end
# end
# using .mtopoop2
# mtopoop2.test()
#
# module mtopoop3
# using StaticArrays
# using MeshCore: L2, Q4, ShapeColl, connectivity, manifdim, nvertices, nfacets, facetdesc, nshapes
# using MeshCore: Vertices, boundedby, skeleton
# using MeshCore: IncRel, Vertices, increl_transpose
# using Test
# function test()
#     xyz = [0.0 0.0; 633.3 0.0; 1266.6 0.0; 1900.0 0.0; 0.0 400.0; 633.3 400.0; 1266.6 400.0; 1900.0 400.0; 0.0 800.0; 633.3 800.0; 1266.6 800.0; 1900.0 800.0]
#     vertices =  Vertices(xyz)
#     c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
#     cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
#     shapes = ShapeColl(Q4, IncRel(cc))
#     facetshapes = skeleton(shapes)
#     @test nshapes(facetshapes) == 17
#     bbshapes = boundedby(shapes, facetshapes)
#     shouldget = Array{Int64,1}[[16, 1, 14, 17], [-14, 9, 6, 15], [2, 12, 10, -1], [-10, 4, 7, -9], [13, 11, 5, -12], [-5, 8, 3, -4]]
#     allmatch = true
#     for j in 1:length(shouldget)
#         for k in 1:length(shouldget[j])
#             allmatch = allmatch && (bbshapes.increl(j, k) == shouldget[j][k])
#         end
#     end
#     @test allmatch
#     # Now test the transposed incidence relation
#     tincrel = increl_transpose(bbshapes.increl)
#     shouldget = Array{Int64,1}[[1, 3], [3], [6], [4, 6], [5, 6], [2], [4], [6], [2, 4], [3, 4], [5], [3, 5], [5], [1, 2], [2], [1], [1]]
#     allmatch = true
#     for j in 1:length(shouldget)
#         for k in 1:length(shouldget[j])
#             allmatch = allmatch && (tincrel(j, k) == shouldget[j][k])
#         end
#     end
#     @test allmatch
#     true
# end
# end
# using .mtopoop3
# mtopoop3.test()
#
# module mtopoop4
# using StaticArrays
# using MeshCore: L2, Q4, P1, ShapeColl, connectivity, manifdim, nvertices, nedgets, nshapes
# using MeshCore: Vertices, boundedby2, skeleton
# using MeshCore: IncRel, Vertices, increl_transpose
# using Test
# function test()
#     xyz = [0.0 0.0; 633.3 0.0; 1266.6 0.0; 1900.0 0.0; 0.0 400.0; 633.3 400.0; 1266.6 400.0; 1900.0 400.0; 0.0 800.0; 633.3 800.0; 1266.6 800.0; 1900.0 800.0]
#     vertices =  Vertices(xyz)
#     c = [(1, 2, 6, 5), (5, 6, 10, 9), (2, 3, 7, 6), (6, 7, 11, 10), (3, 4, 8, 7), (7, 8, 12, 11)]
#     cc = [SVector{nvertices(Q4)}(c[idx]) for idx in 1:length(c)]
#     shapes = ShapeColl(Q4, IncRel(cc))
#     edgetshapes = ShapeColl(P1, IncRel([SVector{nvertices(P1)}([idx]) for idx in 1:nvertices(vertices)]))
#     @test nshapes(edgetshapes) == 12
#     bb2shapes = boundedby2(shapes, edgetshapes)
#     shouldget = Array{Int64,1}[[1, 2, 6, 5], [5, 6, 10, 9], [2, 3, 7, 6], [6, 7, 11, 10], [3, 4, 8, 7], [7, 8, 12, 11]]
#     allmatch = true
#     for j in 1:length(shouldget)
#         for k in 1:length(shouldget[j])
#             allmatch = allmatch && (bb2shapes.increl(j, k) == shouldget[j][k])
#         end
#     end
#     @test allmatch
#     # Now test the transposed incidence relation
#     tincrel = increl_transpose(bb2shapes.increl)
#     shouldget = Array{Int64,1}[[1], [1, 3], [3, 5], [5], [1, 2], [1, 2, 3, 4], [3, 4, 5, 6], [5, 6], [2], [2, 4], [4, 6], [6]]
#     allmatch = true
#     for j in 1:length(shouldget)
#         for k in 1:length(shouldget[j])
#             allmatch = allmatch && (tincrel(j, k) == shouldget[j][k])
#         end
#     end
#     @test allmatch
#     true
# end
# end
# using .mtopoop4
# mtopoop4.test()
#
# include("samplet4.jl")
#
# module mt4topo1
# using StaticArrays
# using MeshCore: ShapeColl, connectivity, manifdim, nvertices, nedgets, nshapes
# using MeshCore: Vertices, boundedby2, skeleton, boundedby, nshifts, _sense
# using MeshCore: IncRel, Vertices, increl_transpose, nrelations, nentities
# using ..samplet4: mesh
# using Test
# function test()
#     vertices, shapes = mesh()
#
#     # Test the incidence relations 3 -> 0 & 0 -> 3
#     tincrel = increl_transpose(shapes.increl)
#     allmatch = true
#     for j in 1:nrelations(tincrel)
#         for k in 1:nentities(tincrel, j)
#             f = tincrel(j, k)
#             allmatch = allmatch && (j in shapes.increl(f))
#         end # k
#     end # j
#     @test allmatch
#
#     # Test the incidence relations 2 -> 0 & 0 -> 2
#     faces = skeleton(shapes)
#     tincrel = increl_transpose(faces.increl)
#     allmatch = true
#     for j in 1:nrelations(tincrel)
#         for k in 1:nentities(tincrel, j)
#             f = tincrel(j, k)
#             allmatch = allmatch && (j in faces.increl(f))
#         end # k
#     end # j
#     @test allmatch
#
#     # Test the incidence relations 1 -> 0 & 0 -> 1
#     edges = skeleton(faces)
#     tincrel = increl_transpose(edges.increl)
#     allmatch = true
#     for j in 1:nrelations(tincrel)
#         for k in 1:nentities(tincrel, j)
#             f = tincrel(j, k)
#             allmatch = allmatch && (j in edges.increl(f))
#         end # k
#     end # j
#     @test allmatch
#
#     # Test the incidence relations 3 -> 2 & 2 -> 3
#     faces = skeleton(shapes)
#     bbfaces = boundedby(shapes, faces)
#     # Check that the tetrahedra connectivity refers to all three vertices of the faces
#     allmatch = true
#     @test nrelations(shapes.increl) == nrelations(bbfaces.increl)
#     for j in 1:nrelations(bbfaces.increl)
#         for k in 1:nentities(bbfaces.increl, j)
#             f = bbfaces.increl(j, k)
#             for m in 1:3
#                 allmatch = allmatch && (faces.increl(abs(f), m) in shapes.increl(j))
#             end # m
#         end # k
#     end # j
#     @test allmatch
#     # Check that the orientations of the faces is correct
#     allmatch = true
#     @test nrelations(shapes.increl) == nrelations(bbfaces.increl)
#     for j in 1:nrelations(bbfaces.increl)
#         for k in 1:nentities(bbfaces.increl, j)
#             for f in bbfaces.increl(j)
#                 orientation = sign(f)
#                 f = abs(f)
#                 fc = faces.increl(f)
#                 matchone = false
#                 for m in 1:4
#                     oc = shapes.increl(j)[shapes.shapedesc.facets[m, :]]
#                     if length(intersect(fc, oc)) == 3
#                         s = _sense(fc, oc, nshifts(faces.shapedesc))
#                         matchone = (s == orientation)
#                     end
#                     if matchone
#                         break
#                     end
#                 end # m
#                 allmatch = allmatch && matchone
#             end
#         end # k
#     end # j
#     @test allmatch
#     # Check the transpose incidence relation
#     tincrel = increl_transpose(bbfaces.increl)
#     allmatch = true
#     for j in 1:nrelations(tincrel)
#         for k in 1:nentities(tincrel, j)
#             e = tincrel(j, k)
#             allmatch = allmatch && (j in abs.(bbfaces.increl(e)))
#         end # k
#     end # j
#     @test allmatch
#     true
# end
# end
# using .mt4topo1
# mt4topo1.test()
