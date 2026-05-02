# SV file

SV_SPI_MASTER = $(shell pwd)/src/spi_master.sv
TB_SPI_MASTER = $(shell pwd)/tb/spi_master_tb.sv
VVP_SPI_MASTER = $(shell pwd)/temp/spi_master.vvp
VCD_SPI_MASTER = $(shell pwd)/temp/spi_master.vcd

SV_SPI_SLAVE = $(shell pwd)/src/spi_slave.sv
TB_SPI_SLAVE = $(shell pwd)/tb/spi_slave_tb.sv
VVP_SPI_SLAVE = $(shell pwd)/temp/spi_slave.vvp
VCD_SPI_SLAVE = $(shell pwd)/temp/spi_slave.vcd

SV_SPI_TOP = $(shell pwd)/src/spi_top.sv
TB_SPI_TOP = $(shell pwd)/tb/spi_top_tb.sv
VVP_SPI_TOP = $(shell pwd)/temp/spi_top.vvp
VCD_SPI_TOP = $(shell pwd)/temp/spi_top.vcd

# COMPILATION

COMPILER = iverilog
COMPILER_FLAG1 = -o
COMPILER_FLAG2 = -g2012

# SIMULATION

SIMULATOR = vvp

# Target : Master

spi_master: compile_spi_master
	$(SIMULATOR) $(VVP_SPI_MASTER)

compile_spi_master:
	mkdir -p temp
	$(COMPILER) $(COMPILER_FLAG2) $(COMPILER_FLAG1) $(VVP_SPI_MASTER) $(SV_SPI_MASTER) $(TB_SPI_MASTER)

wave_spi_master:
	gtkwave $(VCD_SPI_MASTER)

clean_spi_master:
	rm -rf $(VVP_SPI_MASTER)
	rm -rf $(VCD_SPI_MASTER)