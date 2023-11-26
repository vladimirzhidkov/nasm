# Exercise 3.04
After the addition operation, the processor sets the values of the ZF, SF, OF, and CF flags (among others, but we will only consider these four). Since each flag can be either zero or one, disregarding their meanings, it can be assumed that there are 16 possible combinations of values for these four flags - from 0000 to 1111, although in reality not all of these combinations may occur.

For each of the 16 combinations, propose such values for the AL and BL registers that the execution of the command add al, bl will lead to the occurrence of the considered combination of flags, or indicate that it is impossible.
