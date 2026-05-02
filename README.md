<center>

# Serial Peripheral Interface (SPI)

</center>

Serial Peripheral Interface (SPI) protocol establishes synchronous-serial bit transfer between *different* ICs. It follows master-slave relationship, with master sharing a clock signal with the slave IC for ensuring synchronous transfers. 

*Source : [Wikipedia](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface)*

## Implementation

This repository contains three blocks required for implementing the SPI interface, i.e. SPI-Master, SPI-Slave and a top wrapper acting as a Register Interface (RIF)

## Design Parameters

- ### CPOL : 0

Clock polarity: Shared clock (sclk) remains low under idle condition.

- ### CPHA : 1
