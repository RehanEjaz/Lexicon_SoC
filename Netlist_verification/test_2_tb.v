`default_nettype none

`timescale 1 ns / 1 ps
`define UNIT_DELAY #1

`ifdef SIM

`define USE_POWER_PINS

`endif

//RTL Paths
`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU_inst_checker.v"
//`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU_vec_dec_ctl.v"
//`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU_vpr_ctl.v"
`include "/home/hshabbir/Vector-Extension/design/vector_files/beh_lib.v"
//`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU_csr.v"
//`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU_decode.v"
//`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU.v"
//`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU_lsu.v"
//`include "/home/hshabbir/Vector-Extension/design/vector_files/axi_slv.v"
//`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU_exu.v"
//`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU_alu_ctl.v"
//`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU_mul_ctl.v"
`include "/home/hshabbir/Vector-Extension/design/vector_files/VPU_div_ctl.v"


//NETLIST Paths
/*`include "/home/merl-tools/openlane-rc5/openlane/designs/vector/runs/eb1_inst_check/results/lvs/eb1_inst_check.lvs.powered.v"
`include "/home/merl-tools/openlane-rc5/openlane/designs/vector/runs/eb1_vec_dec_ctl/results/lvs/eb1_vec_dec_ctl.lvs.powered.v"
`include "/home/merl-tools/openlane-rc5/openlane/designs/vector/runs/VIU_vpr_ctl/results/lvs/VIU_vpr_ctl.lvs.powered.v"
`include "/home/merl-tools/openlane-rc5/openlane/designs/vector/runs/VIU_csr/results/lvs/VIU_csr.lvs.powered.v"
*/
//`include "/home/merl-tools/openlane-rc5/openlane/designs/vector/runs/VPU_decode/results/lvs/VPU_decode.lvs.powered.v"
//`include "/home/merl-tools/openlane-rc5/openlane/designs/vector/runs/VPU_EXU/results/lvs/VPU_exu.lvs.powered.v"
//`include "/home/merl-tools/openlane-rc5/openlane/designs/vector/runs/VPU_ALU/results/lvs/VPU_alu_ctl.lvs.powered.v"
//`include "/home/merl-tools/openlane-rc5/openlane/designs/vector/runs/VPU_MUL/results/lvs/VPU_mul_ctl.lvs.powered.v"
//`include "/home/merl-tools/openlane-rc5/openlane/designs/vector/runs/VPU_DIV/results/lvs/VPU_div_ctl_up.lvs.powered.v"

// PDK Files
/*
`include "libs.ref/sky130_fd_io/verilog/sky130_fd_io.v"
`include "libs.ref/sky130_fd_io/verilog/sky130_ef_io.v"
`include "libs.ref/sky130_fd_io/verilog/sky130_ef_io__gpiov2_pad_wrapped.v"

`include "libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
`include "libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"
`include "libs.ref/sky130_fd_sc_hvl/verilog/primitives.v"
`include "libs.ref/sky130_fd_sc_hvl/verilog/sky130_fd_sc_hvl.v"
*/
module test_2_tb;
	reg clock;
	reg rst_l;
	reg [31:0] instr;
    	wire complete,complete_exu;
    	reg [31:0] avl;
    	reg [31:0] vtype;
    	reg [2:0] vec_ctl;
    	//wire [51:0] out;
    	reg scan_mode;
    	wire vpu_active;
    	wire stall_scalar;
    	reg [255:0] vs1_data,vs2_data,vs3_data;
    	reg [31:0] vstart;
    	reg [31:0] vl;
    	//wire [2:0] scalar_control;
    	//wire [4:0] rs1_address, rs2_address;
    	//wire [4:0] rd_address;
    	reg valid, illegal_instr;
    	//wire [31:0] immediate_data;
    	reg [7:0] ELEN;
    	wire [255:0] valu_result, vlsu_result, vdiv_result; 
    	reg valu_valid, vmul_valid, vlsu_valid, vdiv_valid;
    	wire illegal_config;
    	reg [17:0]	valu_op;
	reg [4:0]	vmul_op;
	reg [3:0]	vdiv_op;
	reg [8:0]	vlsu_op;
	wire [255:0] vlsu_vs2_d, vlsu_vs3_d;
	wire [31:0] vlsu_rs1_d, vlsu_rs2_d;
	wire illegal_instruction_lsu;
	reg cpu_halt_ack;
    	wire                             lsu_axi_awvalid;
   wire                              lsu_axi_awready;
   wire  [3-1:0]          lsu_axi_awid;
   wire  [31:0]                     lsu_axi_awaddr;
   wire  [3:0]                      lsu_axi_awregion;
   wire  [7:0]                      lsu_axi_awlen;
   wire  [2:0]                      lsu_axi_awsize;
   wire  [1:0]                      lsu_axi_awburst;
   wire                             lsu_axi_awlock;
   wire  [3:0]                      lsu_axi_awcache;
   wire  [2:0]                      lsu_axi_awprot;
   wire  [3:0]                      lsu_axi_awqos;

   wire                             lsu_axi_wvalid;
   wire                              lsu_axi_wready;
   wire  [63:0]                     lsu_axi_wdata;
   wire  [7:0]                      lsu_axi_wstrb;
   wire                             lsu_axi_wlast;

   wire                              lsu_axi_bvalid;
   wire                             lsu_axi_bready;
   wire   [1:0]                      lsu_axi_bresp;
   wire   [3-1:0]          lsu_axi_bid;

   // AXI Read Channels
   wire                             lsu_axi_arvalid;
   wire                              lsu_axi_arready;
   wire  [3-1:0]          lsu_axi_arid;
   wire  [31:0]                     lsu_axi_araddr;
   wire  [3:0]                      lsu_axi_arregion;
   wire  [7:0]                      lsu_axi_arlen;
   wire  [2:0]                      lsu_axi_arsize;
   wire  [1:0]                      lsu_axi_arburst;
   wire                             lsu_axi_arlock;
   wire  [3:0]                      lsu_axi_arcache;
   wire  [2:0]                      lsu_axi_arprot;
   wire  [3:0]                      lsu_axi_arqos;

   wire                              lsu_axi_rvalid;
   wire                             lsu_axi_rready;
   wire   [3-1:0]          lsu_axi_rid;
   wire   [63:0]                     lsu_axi_rdata;
   wire   [1:0]                      lsu_axi_rresp;
   wire                              lsu_axi_rlast;

	

	// External clock is used by default.  Make this artificially fast for the
	// simulation.  Normally this would be a slow clock and the digital PLL
	// would be the fast clock.

	always #50 clock <= (clock === 1'b0);

	initial begin
		clock = 0;
	end

	initial begin
		$dumpfile("test_2.vcd");
		$dumpvars(0, test_2_tb);

		// Repeat cycles of 1000 clock edges as needed to complete testbench
		repeat (300) begin
			repeat (1000) @(posedge clock);
			// $display("+1000 cycles");
		end
		$display("%c[1;31m",27);
		$display ("Monitor: Timeout, Test Mega-Project IO Ports (RTL) Failed");
		$display("%c[0m",27);
		$finish;
	end

	/*always @(out) begin
		#1 $display("wire value = 0x%0h, at time = %0t",out,$time);
	end
*/
	initial begin
		rst_l <= 1'b0;
		#200;
		rst_l <= 1'b1;	    // Release reset
	end
       
        initial begin
        	/*wait(expected == 52'h8000000040950);
        	wait(expected == 52'h8000000100950);
        	wait(expected == 52'h8000008080950);
        	wait(expected == 52'h8000000040851);
        	wait(expected == 52'h8000000100851);
        	wait(expected == 52'h8000008080851);
        	wait(expected == 52'h8000000040858);
        	wait(expected == 52'h8000000100858);
        	wait(expected == 52'h8000008080858);
           	$display("Monitor: Test 1 Mega-Project IO (RTL) Passed");
            	$finish;
	*/
	end
	initial begin
		//complete <= 1'b0;
		instr <= 32'h00000000;
		avl <= 32'h00000000;
		vec_ctl <= 3'h0;
		cpu_halt_ack <= 1'b0;
		#200;
		//complete <= 1'b0;
		//instr <= 32'h010572D7;
		//#200;
		//instr <= 32'h008572D7;
		//#100
		//avl <= 32'h00000006;
		//#500;
		//complete <= 1'b1;
		//#200;
		instr <= 32'h00000007;
		ELEN <= 8'h08;
		vstart <= 32'h00000000;
		vl <= 32'h00000020;
		avl <= 32'h0000004;
		vtype <= 32'h00000002;
		vdiv_valid <= 1'b1;
		vdiv_op <= 4'h9;
		valid <= 1'b1;
		vec_ctl <= 3'b100;
		//vs2_data <= 256'h0000000700000006000000050000000400000003000000020000000600000000;
		vs1_data <= 256'h9696969696969696969696969696969696969696969696969696969696969630;
		vs2_data <= 256'h8686868686868686868686868686868686868686868686868686868686868633;
		//vs2_data <= 256'h8600000000000000860000000000000086000000000000008600000000000000;
		//vs1_data <= 256'h0000123500000000d0580000d058000000000085f0123456d0580000f0123412;
		//vs2_data <= 256'h00003452d0580000d0580000d058000000000026d0580000d0580000d0580058;
		#100;
		avl <= 32'h00000000;
		vtype <= 32'h00000000;
		vdiv_valid <= 1'b0;
		vdiv_op <= 4'h0;
		vec_ctl <= 3'b000;
		cpu_halt_ack <= 1'b1;
		vs1_data <= 256'h0000000000000000000000000000000000000000000000000000000000000000;
		vs2_data <= 256'h0000000000000000000000000000000000000000000000000000000000000000;
		#1000000;
		/*cpu_halt_ack <= 1'b0;
		instr <= 32'h00000007;
		ELEN <= 8'h20;
		vstart <= 32'h00000000;
		vl <= 32'h00000008;
		avl <= 32'h00000004;
		vtype <= 32'h00000002;
		vdiv_valid <= 1'b1;
		vdiv_op <= 4'h9;
		vec_ctl <= 3'h0;
		valid <= 1'b1;
		//vs2_data <= 256'h0000000700000006000000050000000400000003000000020000000600000000;
		vs1_data <= 256'h0000000500000005000000050000000500000005000000050000000500000005;
		vs2_data <= 256'h0000000200000002000000020000000200000002000000020000000200000002;
		#200;
		avl <= 32'h00000000;
		vtype <= 32'h00000000;
		vdiv_valid <= 1'b0;
		vdiv_op <= 4'h0;
		cpu_halt_ack <= 1'b1;
		#300;
		cpu_halt_ack <= 1'b0;
		instr <= 32'h00000007;
		ELEN <= 8'h20;
		vstart <= 32'h00000000;
		vl <= 32'h00000008;
		avl <= 32'h00000004;
		vtype <= 32'h00000002;
		vdiv_valid <= 1'b1;
		vdiv_op <= 4'h0;
		vec_ctl <= 3'h0;
		valid <= 1'b1;
		//vs2_data <= 256'h0000000700000006000000050000000400000003000000020000000600000000;
		vs1_data <= 256'h00000007000000060000000500000004000000030000000200000001f0123456;
		vs2_data <= 256'h11223344556677889900aabbccddeeff112233445566778899aabbccf0123456;
		#200;
		avl <= 32'h00000000;
		vtype <= 32'h00000000;
		vdiv_valid <= 1'b0;
		vdiv_op <= 4'h0;
		cpu_halt_ack <= 1'b1;
		#300;
		/*cpu_halt_ack <= 1'b0;
		instr <= 32'h00000007;
		ELEN <= 8'h20;
		vstart <= 32'h00000000;
		vl <= 32'h00000008;
		avl <= 32'h00000004;
		vtype <= 32'h00000002;
		vmul_valid <= 1'b1;
		vmul_op <= 5'h08;
		vec_ctl <= 3'h0;
		valid <= 1'b1;
		//vs2_data <= 256'h0000000700000006000000050000000400000003000000020000000600000000;
		vs1_data <= 256'h00000007000000060000000500000004000000030000000200000001f0123456;
		vs2_data <= 256'h11223344556677889900aabbccddeeff112233445566778899aabbccf0123456;
		#200;
		avl <= 32'h00000000;
		vtype <= 32'h00000000;
		vmul_valid <= 1'b0;
		vmul_op <= 5'h00;
		cpu_halt_ack <= 1'b1;
		#300;
		*/
		
		//complete <= 1'b1;
		//vlsu_result <= 256'h0000000000000000000000000000000011111111222222233333344444555666;
		//#200;
		/*instr <= 32'h40550533; 
		complete <= 1'b0;
		avl <= 32'h00000000;
		#100;
		complete <= 1'b1;
		#200;
		instr <= 32'h00229293;
		complete <= 1'b0; 
		avl <= 32'h00000000;
		#200;
		instr <= 32'h005585B3; 
		avl <= 32'h00000000;
		#200;
		instr <= 32'h02066107;
		avl <= 32'h00000000;
		#100;
		complete <= 1'b1;
		vlsu_result <= 256'h0000000000000000000000000000000011111111222222233333344444555777;
		#200;
		instr <= 32'h00560633;
		complete <= 1'b0;
		avl <= 32'h00000000;
		#200;
		instr <= 32'h021101D7;
		avl <= 32'h00000000;
		#100;
		complete <= 1'b1;
		valu_result <= 256'h00000000000000000000000000000000aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa;
		#200;
		instr <= 32'h0206E1A7;
		complete <= 1'b0;
		avl <= 32'h00000000;
		#100;
		complete <= 1'b1;
		#200;
		instr <= 32'h005686B3;
		complete <= 1'b0; 
		avl <= 32'h00000000;
		#200;
		instr <= 32'hD05801B7;
		#200;
		instr <= 32'h0FF00293;
		#200;
		instr <= 32'h00518023;
		#200;
		instr <= 32'hFE000AE3;
		#200;
		instr <= 32'hD05801B7;
		#200;
		instr <= 32'h0FF00293;
		#200;
		instr <= 32'h403202D7;*/
		$finish;
	end

	VPU_inst_check dut_1(
			//.VPWR(1'b1),
			//.VGND(1'b0),
			.inst_opcode(instr[6:0]),
			.vpu_complete(complete),
			.valid_execution(valid),
			.vpu_active(vpu_active),
			.stall_scalar(stall_scalar)
		      );
		      
	/*VPU_decode #(256) dut_2 (
				//.VPWR(1'b1),
				//.VGND(1'b0),
				.clk(clock),
   				.rst_l(rst_l),
   				.instr(instr),
   				.vpu_active(vpu_active),
   				.vpu_complete(complete),
  				.rs2_data(vtype),
 				.rs1_data(avl),
   				.valu_result(valu_result),
   				.vdiv_result(vdiv_result),
   				.vlsu_result(vlsu_result),
   				.vstart(vstart),
   				.vl(vl),
   				.scalar_control(scalar_control),
   				.rs1_address(rs1_address),
   				.rs2_address(rs2_address),
   				.rd_address(rd_address),
   				.valu_valid(valu_valid),
   				.vmul_valid(vmul_valid),
   				.vdiv_valid(vdiv_valid),
   				.vlsu_valid(vlsu_valid),
   				.illegal_instr(illegal_instr),
   				.valu_op(valu_op),
   				.vmul_op(vmul_op),
   				.vdiv_op(vdiv_op),
   				.vlsu_op(vlsu_op),
   				.vs1_data(vs1_data),
   				.vs2_data(vs2_data),
   				.vs3_data(vs3_data),
   				.immediate_data(immediate_data),
   				.ELEN(ELEN),
   				.valid_execution(valid),
   				.illegal_config(illegal_config),
   				.scan_mode(scan_mode)
   				);	
   	*/			
   	/*VPU_exu dut_3 (.VPWR(1'b1),
			.VGND(1'b0),
   			.clk(clock),
			.rst_l(rst_l),
			.scan_mode(scan_mode),
			.cpu_halt_ack(1'b1),
			.valid_execution(valid),
			.valu_op(valu_op),
			.vmul_op(vmul_op),
			.vdiv_op(vdiv_op),
			.vstart(vstart),
			.vl(vl),
			.ELEN(ELEN),
			.vector_control(vec_ctl),
			.valu_valid(1'b0),
			.vmul_valid(1'b0),
			.vdiv_valid(1'b0),
			.vlsu_valid(vlsu_valid),
			.lsu_result(32'h00000000),                                  // Load result M-stage
			.lsu_nonblock_load_data(32'h00000000),                        // nonblock load data
			.alu_result(32'h000005C2),                                    // Primary ALU result
			.dec_i0_rs1_en_d(1'b1),                               // Qualify GPR RS1 data
			.dec_i0_rs2_en_d(1'b0),                               // Qualify GPR RS2 data
			.gpr_i0_rs1_d(avl),                                  // DEC data gpr
			.gpr_i0_rs2_d(vtype),                                  // DEC data gpr
			.immed_d(32'h00000000),                                // DEC data immediate
			.dec_i0_result_r(32'h00000000),                               // DEC result in R-stage
			.dec_i0_rs1_bypass_en_d(4'h4),                        // DEC bypass select  1 - X-stage, 0 - dec bypass data
			.dec_i0_rs2_bypass_en_d(4'h4),                        // DEC bypass select  1 - X-stage, 0 - dec bypass data
			.vs1_data(vs1_data),
			.vs2_data(vs2_data),
			.vs3_data(vs3_data),
			.vlsu_rs1_d(vlsu_rs1_d),                                   // VLSU base address
			.vlsu_rs2_d(vlsu_rs2_d),                                   // VLSU strided offset
			.vlsu_vs2_d(vlsu_vs2_d), 			       // VLSU indexed offset
			.vlsu_vs3_d(vlsu_vs3_d), 			       // VLSU store data                      
			.valu_result(valu_result),                           // VALU result
			.vdiv_result(vdiv_result), 			       // VDIV result
			.vpu_complete(complete_exu)	
			);*/
			
	VPU_div_ctl dut_5
			(
			//.VPWR(1'b1),
			//.VGND(1'b0),
			.clk(clock),
			.rst_l(rst_l),
			.scan_mode(1'b0),
			.cpu_halt_ack(cpu_halt_ack),
			.valid_execution(valid),
			.vstart(vstart),
			.vl(vl),
			.ELEN(ELEN),
			.vdiv_valid(vdiv_valid),
			.vdiv_op(vdiv_op),
			.vdividend(vs2_data),
			.vdivisor(vs1_data),
			.vpu_complete(complete),
			.vdiv_result_x(valu_result)
			);
   	
   	/*VPU_lsu dut_4 ( .clk(clock),
			.rst_l(rst_l),
			.valid_execution(valid),
			.vstart(vstart),
			.vl(vl),
			.ELEN(ELEN),
			.vlsu_valid(vlsu_valid),
			.vlsu_op(vlsu_op),
			.vlsu_rs1_d(vlsu_rs1_d), // base address
			.vlsu_rs2_d(vlsu_rs2_d), // strided offset
			.vlsu_vs2_d(vlsu_vs2_d), // indexed offset
			.vlsu_vs3_d(vlsu_vs3_d), // store data
			.vpu_complete(complete),
			.vlsu_result(vlsu_result),
			.*
			);

	axi_slv  #(.TAGW(3)) lmem(
    .aclk(clock),
    .rst_l(rst_l),
    .arvalid(lsu_axi_arvalid),
    .arready(lsu_axi_arready),
    .araddr(lsu_axi_araddr),
    .arid(lsu_axi_arid),
    .arlen(lsu_axi_arlen),
    .arburst(lsu_axi_arburst),
    .arsize(lsu_axi_arsize),

    .rvalid(lsu_axi_rvalid),
    .rready(lsu_axi_rready),
    .rdata(lsu_axi_rdata),
    .rresp(lsu_axi_rresp),
    .rid(lsu_axi_rid),
    .rlast(lsu_axi_rlast),

    .awvalid(lsu_axi_awvalid),
    .awready(lsu_axi_awready),
    .awaddr(lsu_axi_awaddr),
    .awid(lsu_axi_awid),
    .awlen(lsu_axi_awlen),
    .awburst(lsu_axi_awburst),
    .awsize(lsu_axi_awsize),

    .wdata(lsu_axi_wdata),
    .wstrb(lsu_axi_wstrb),
    .wvalid(lsu_axi_wvalid),
    .wready(lsu_axi_wready),

    .bvalid(lsu_axi_bvalid),
    .bready(lsu_axi_bready),
    .bresp(lsu_axi_bresp),
    .bid(lsu_axi_bid)
);*/
/*	VIU_vec_dec_ctl dut_2 (
			//.VPWR(1'b1),
			//.VGND(1'b0),
			.vpu_active(vpu_active),
			.instr(instr),
			.out(out)
			);
	
	VIU_vpr_ctl dut_3 (
			//.VPWR(1'b1),
			//.VGND(1'b0),
			.clk(clock),
			.rst_l(rst_l),
			.vrden0(rden0),        
			.vrden1(rden1),
			.vrden2(rden2),
			.vraddr0(raddr0),  
			.vraddr1(raddr1),
			.vraddr2(raddr2),
			.vwen0(wen0),
			.vwaddr0(waddr0),
			.vwdata0(wdata0), 
			.vwen1(wen1),
			.vwaddr1(waddr1),
			.vwdata1(wdata1), 
			.vwen2(wen2),
			.vwaddr2(waddr2),
			.vwdata2(wdata2), 
			.vrdata0(rdata0), 
			.vrdata1(rdata1),
			.vrdata2(rdata2)
			);
			
	VIU_csr dut_4 (
			.VPWR(1'b1),
			.VGND(1'b0),
			.clk(clock),
			.rst_l(rst_l),
			.csr_write_1(expected[38]),
			.csr_write_2(expected[39]),
			.csr_read(expected[37]),
			.vpu_complete(complete),
			.vpu_active(vpu_active),
			.vsetvl(expected[10]),
			.set_vlmax(expected[10] & expected[2] & ~expected[0]),
			.vtype_in({{21{1'b0}},instr[30:20]}),   // rs2
			.avl_in(avl),     // rs1
			.valid_execution(valid),
			.vstart(start),
			.vl_out(vl)     // rd
			);
*/


endmodule
`default_nettype wire
