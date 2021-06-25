#
# Simple example demonstring use a Yao circuit with QX framework
#

using YaoQX

# create a YaoBlocks circuit
circ = ghz(3)

# create a quantum register and apply the circuit
reg = QXReg(3)
apply!(reg, circ)

# get 10 measurements
measure(reg; nshots=10)