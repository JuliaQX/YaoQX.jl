using QXTns
using YaoBlocks

export QXReg, ghz, qx_intrinsic_nodes

mutable struct QXReg{B} <: AbstractRegister{B}
    qubits::Int
    tnc::TensorNetworkCircuit
    QXReg(n::Int) = new{1}(n, TensorNetworkCircuit(n))
end

function YaoAPI.apply!(reg::QXReg, block::AbstractBlock)
    for (locs, matrix) in qx_intrinsic_nodes(block)
        push!(reg.tnc, collect(locs), Matrix(matrix))
    end
    return reg
end

YaoAPI.nactive(reg::QXReg) = reg.qubits
YaoAPI.nqubits(reg::QXReg) = reg.qubits

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
