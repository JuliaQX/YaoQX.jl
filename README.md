# YaoQX

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Roger-luo.github.io/YaoQX.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://Roger-luo.github.io/YaoQX.jl/dev)
[![Build Status](https://github.com/Roger-luo/YaoQX.jl/workflows/CI/badge.svg)](https://github.com/Roger-luo/YaoQX.jl/actions)
[![Coverage](https://codecov.io/gh/Roger-luo/YaoQX.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Roger-luo/YaoQX.jl)

## Installation

YaoQX is not yet registered so to install will need to provide full github path.

```
] add https://github.com/JuliaQX/YaoQX.jl
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