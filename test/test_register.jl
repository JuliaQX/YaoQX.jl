using Test

using YaoQX
using QXTools

@testset "Test register data structure" begin
    circ = YaoQX.ghz(3)
    reg = QXReg(3)
    apply!(reg, circ)
    @test length(reg.tnc) == 5
    @test length.(measure(reg, nshots=10)) == (10, 10)
end

@testset "Test convert to tnc" begin
    circ = YaoQX.ghz(3)
    tnc = convert_to_tnc(circ)
    @test tnc.qubits == 3
    # tnc has 5 gates and 6 input/output nodes
    @test length(tnc) == 11
end