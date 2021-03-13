@testset "VecAttrib" begin
    using MeshCore: VecAttrib, datavaluetype
    attribute = VecAttrib([i for i in 1:10])
    
    @test IndexStyle(attribute) == IndexLinear()
    @test size(attribute) == (10,)
    for i in 1:10
        @test attribute[i] == i
    end
    @test attribute[1,2,3,2,1] == [1,2,3,2,1]
    attribute[1] = 100
    @test attribute[1] == 100
    attribute[1,2,10] = [100,200,1000]
    @test attribute[1,2,10] == [100,200,1000]
    @test datavaluetype(attribute) == Int
end

@testset "FunAttrib" begin
    using MeshCore: FunAttrib, datavaluetype
    fun_attribute = FunAttrib(0, 10, x -> x)

    @test IndexStyle(fun_attribute) == IndexLinear()
    @test size(fun_attribute) == (10,)
    for i in 1:10
        @test fun_attribute[i] == i
    end
    @test fun_attribute[1,2,3,2,1] == [1,2,3,2,1]
    @test datavaluetype(fun_attribute) == Int
end
