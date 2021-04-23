using Test
@time @testset "Mesh core" begin
    include("test_core.jl")
    include("attributes_tests.jl")
end
