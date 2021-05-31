using QXTns
using YaoBlocks

mutable struct QXReg{B} <: AbstractRegister{B}
    qubits::Int
    tnc::TensorNetworkCircuit
    QXReg(n::Int) = new{1}(n, TensorNetworkCircuit(n))
end

function apply!(reg::QXReg, block)
    for b in subblocks(block)
        if b isa AbstractContainer
            locs = occupied_locs(b)
            d = YaoBlocks.unmat(length(locs), mat(b), locs))
            push!(reg.tnc, convert(Array, locs), d)
        else
            apply!(reg, b)
        end
    end
end

nactive(reg::QXReg) = reg.qubits
