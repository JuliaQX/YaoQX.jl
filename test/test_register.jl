using Test

using YaoQX

@testset "Test register data structure" begin
    circ = YaoQX.ghz(3)
    reg = QXReg(3)
    apply!(reg, circ)
    @test length(reg.tnc) == 5
    @test length.(measure(reg, nshots=10)) == (10, 10)
end