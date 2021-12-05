using QXTns
using QXTools
using QXContexts

using YaoBlocks
using Reexport

@reexport using YaoAPI

export QXReg, ghz, qx_intrinsic_nodes

"""Register for QX"""
mutable struct QXReg{B} <: AbstractRegister{B}
    qubits::Int
    tnc::TensorNetworkCircuit
    cg::ComputeGraph
    QXReg(n, tnc) = new{1}(n, tnc)
end

function QXReg(n::Int)
    tnc = TensorNetworkCircuit(n)
    QXReg(n, tnc)
end

"""
    YaoAPI.apply!(reg::QXReg, block::AbstractBlock)

Apply the given block to the register
"""
function YaoAPI.apply!(reg::QXReg, block::AbstractBlock)
    for (locs, matrix) in qx_intrinsic_nodes(block)
        push!(reg.tnc, collect(locs), Matrix(matrix))
    end
    return reg
end

YaoAPI.nactive(reg::QXReg) = reg.qubits
YaoAPI.nqubits(reg::QXReg) = reg.qubits

"""Prepare a ghz circuit block"""
function ghz(n)
    chain(put(1=>H), chain(map(x -> control(n, x, x+1=>X), 1:n-1)...))
end

qx_intrinsic_nodes(blk::AbstractBlock) = qx_intrinsic_nodes!([], blk)

function qx_intrinsic_nodes!(list, blk::AbstractBlock)
    for each in subblocks(blk)
        if each isa ControlBlock && length(each.ctrl_locs) < 2 && length(each.locs) == 1
            if each.ctrl_locs[1] < each.locs[1]
                gate = control(2, 1, 2=>each.content)
            else
                gate = control(2, 2, 1=>each.content)
            end

            push!(list, occupied_locs(each) => mat(gate))
        elseif each isa PutBlock
            push!(list, occupied_locs(each)=>mat(first(subblocks(each))))
        elseif each isa PrimitiveBlock
            push!(list, 1=>mat(each))
        else
            qx_intrinsic_nodes!(list, each)
        end
    end
    return list
end

find_primitive_blocks(blk::AbstractBlock) = find_primitive_blocks!([], blk)

function find_primitive_blocks!(list, blk::AbstractBlock)
    for each in subblocks(blk)
        if each isa PrimitiveBlock
            push!(list, each)
        else
            find_primitive_blocks!(list, each)
        end
    end
    return list
end

"""
    YaoAPI.measure(reg::QXReg; nshots=10)

Measure the register and return the measurements. Note that currently this returns
an array of bitstrings and an array of corresponsing amplitudes. This should be replaced
by a rejection sampler which should be able to return measurements distributed according to
the expected output distribution.
"""
function YaoAPI.measure(reg::QXReg; nshots=10)
    if !isdefined(reg, :cg)
        add_input!(reg.tnc, "0"^nqubits(reg))
        add_output!(reg.tnc, "0"^nqubits(reg))
        # must be outputs on network currently to find a plan
        bond_groups, plan, _ = contraction_scheme(reg.tnc.tn, 2;
                                                  seed=rand(Int),
                                                  time=10)

        reg.cg = build_compute_graph(reg.tnc, plan, bond_groups)
    end
    ctx = QXContext(reg.cg)
    sampler_params = Dict(:method => "List",
                          :params =>
                     Dict(:num_samples => nshots,
                          :bitstrings => collect(amplitudes_uniform(nqubits(reg), nothing, nshots))))
    sampler = ListSampler(ctx; sampler_params[:params]...)
    sampler()
end

"""
    QXTools._convert_to_tnc(block::AbstractBlock; kwargs...)

Convert the given YaoBlocks circuit to a TensorNetworkCircuit
"""
function QXTools._convert_to_tnc(block::AbstractBlock; kwargs...)
    tnc = TensorNetworkCircuit(nqubits(block))
    for (locs, matrix) in qx_intrinsic_nodes(block)
        push!(tnc, collect(locs), Matrix(matrix); kwargs...)
    end
    return tnc
end

"""
    QXTools.convert_to_tnc(circ::AbstractBlock;
                           input::Union{String, Nothing}=nothing,
                           output::Union{String, Nothing}=nothing,
                           no_input::Bool=false,
                           no_output::Bool=false,
                           kwargs...)

Function to convert a YaoBlocks circuit to a QXTools tensor network circuit
"""
function QXTools.convert_to_tnc(circ::AbstractBlock;
                        input::Union{String, Nothing}=nothing,
                        output::Union{String, Nothing}=nothing,
                        no_input::Bool=false,
                        no_output::Bool=false,
                        kwargs...)
    tnc = QXTools._convert_to_tnc(circ; kwargs...)
    if !no_input add_input!(tnc, input) end
    if !no_output add_output!(tnc, output) end
    tnc
end