# YaoQX

## Installation

YaoQX is not yet registered so to install will need to provide full github path.

```
] add YaoQX
```

## Usage

The following shows a very simple usage of YaoQX

```
using YaoQX

# create a YaoBlocks circuit
circ = ghz(3)

# create a quantum register and apply the circuit
reg = QXReg(3)
apply!(reg, circ)

# get 10 measurements
measure(reg; nshots=10)
```

In this example a circuit of type `YaoBlocks` is created. This is applied to a quantum
register. A measurement is then performed which returns 10 bitstrings and corresponding
amplitudes. Note that the bistrings returned are currently not distributed according to
the output distribution, but instead of just uniformly sampled. This will be addressed in
future updates when more advanced sampling methods are added to JuliaQX.

YaoQX can also be used to convert `YaoBlocks` circuits to a TensorNetworkCircuit struct that
can then be used with the [QXTools](https://github.com/JuliaQX/QXTools.jl) framework.

```
using YaoQX
using QXTools

# create a YaoBlocks circuit
circ = ghz(3)

# convert to a TensorNetworkCircuit
tnc = convert_to_tnc(circ)
```