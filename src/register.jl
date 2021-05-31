using QXTns
using YaoArrays

mutable struct QXReg{B} <: AbstractRegister{B}
    qubits::Int
    tnc::TensorNetworkCircuit
    QXReg(n::Int) = new{1}(n, TensorNetworkCircuit(n))
end


nactive(reg::QXReg) = reg.qubits
