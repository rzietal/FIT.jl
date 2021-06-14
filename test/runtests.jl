using Test
using FIT


@testset "Parse example file" begin

    @show data = fit2table("example.fit")

    @test 1 == 1
end