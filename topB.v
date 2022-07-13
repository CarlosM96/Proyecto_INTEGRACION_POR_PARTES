`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2021 03:28:06 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module topB(
    input clk100_fpga_p,
    input clk100_fpga_n,
//    input adn2814_clk_p,
//    input adn2814_clk_n,
//    input adn2814_data_p,
//    input adn2814_data_n,
    input adn2814_lol,
    input adn2814_los,
    input daq_sfp0_los,
    input daq_sfp0_abs,
    input daq_sfp1_los,
    input daq_sfp1_abs,
//    output dbg1,
//    output dbg2,
//    output dbg3,
    output daq_sfp0_txdis,
    output daq_sfp1_txdis,
    
    // 240.474MHz MGTREFCLK for FELIX GTP
     input  wire mgtrefclk0_p,
     input  wire mgtrefclk0_n,

     // Serial data ports for FELIX GTH bank 216 channel 0
     input  wire ch0_gtprxn_in,
     input  wire ch0_gtprxp_in,
     output wire ch0_gtptxn_out,
     output wire ch0_gtptxp_out,
     
     // DAPHNE_EDGAR Version IO
     input wire serial_cts,
	input wire serial_rts,
	output wire serial_tx,
	input wire serial_rx,
	(* dont_touch = "true" *)	input wire clk625_p,
	input wire clk625_n,
	output wire mclk_p,
	output wire mclk_n,
	//(* dont_touch = "true" *)	input wire clk100_p,
	//input wire clk100_n,
	//input wire gtp_clk0_p,
	//input wire gtp_clk0_n,
	input wire afe0_dclkp,
	input wire afe0_dclkn,
	input wire afe0_fclkp,
	input wire afe0_fclkn,
	input wire [7:0] afe0_datap,     // comentado por necesidades de simulación
	input wire [7:0] afe0_datan,
	input wire afe1_dclkn,
	input wire afe1_dclkp,
	input wire afe1_fclkn,
	input wire afe1_fclkp,
	input wire [7:0] afe1_datan,     // comentado por necesidades de simulación
	input wire [7:0] afe1_datap,
	input wire afe2_dclkn,
	input wire afe2_dclkp,
	input wire afe2_fclkn,
	input wire afe2_fclkp,
	input wire [7:0] afe2_datan,     // comentado por necesidades de simulación
	input wire [7:0] afe2_datap,
	input wire afe3_dclkn,
	input wire afe3_dclkp,
	input wire afe3_fclkn,
	input wire afe3_fclkp,
	input wire [7:0] afe3_datan,     // comentado por necesidades de simulación
	input wire [7:0] afe3_datap,
	input wire afe4_dclkn,
	input wire afe4_dclkp,
	input wire afe4_fclkn,
	input wire afe4_fclkp,
	input wire [7:0] afe4_datan,     // comentado por necesidades de simulación
	input wire [7:0] afe4_datap,

     // Serial data ports for FELIX GTH bank 216 channel 1
     input  wire ch1_gtprxn_in,
     input  wire ch1_gtprxp_in,
     output wire ch1_gtptxn_out,
     output wire ch1_gtptxp_out
    );
    
    wire clk100_fpga_pad;
    wire clk100_fpga_pad2;
    wire clk100;
    wire adn2814_clk_pad;
    wire adn2814_clk;
    wire adn2814_data;
      
  
    // Timing system buffering
//    IBUFDS ep_clk_buf_in  (.I(adn2814_clk_p),   .IB(adn2814_clk_n), .O(adn2814_clk_pad));
//    BUFG ep_clk_bufg (.I(adn2814_clk_pad), .O(adn2814_clk));
    
//    IBUFDS ep_data_buf_in (.I(adn2814_data_p), .IB(adn2814_data_n), .O(adn2814_data));
   
   // Timing system
    reg ep_rec_d;
    wire [1:0] ep_rec_d_ddr;
    wire edge_sel;
   
    always @(posedge adn2814_clk) ep_rec_d = ep_rec_d_ddr [edge_sel];
    
   
    
    wire ep_srst_in;
    wire [3:0] ep_stat_out;
    wire ep_clk62p5_out;
    wire ep_rst_out;
    wire ep_ts_rdy_out;
    wire [63:0] ep_ts_out;
    wire ep_pll_locked_in;
    wire ep_sfp_los_in;
    
    wire mmcm_locked;
    wire mmcm_reset_in;
    wire clk_sample;
    
    assign dbg1 = adn2814_clk;
    assign dbg2 = ep_clk62p5_out;

    
    // FELIX 
    wire [31:0] daq_stream; // data to felix
    wire [31:0] daq_stream2; // data to felix
    wire [3:0]  daq_stream_k; // K symbol flags to felix
    wire [3:0]  daq_stream_k2; // K symbol flags to felix
    wire txusrclk;
    wire rxusrclk2;
    wire txrst;
    wire rxrst;
    wire [31:0] rxdata;
    wire [31:0] rxdata2;
    
    wire [31:0] status_bits;
    wire [31:0] counter_DEBUG;
    wire [31:0] state_DEBUG;
    
    
wire [33:0] data_prbs;
wire [31:0] data_i;
wire [1:0] data_type;
wire [31:0] data_o;
wire fifo_re, fifo_we, fifo_empty, fifo_full;
wire usr_clk;
wire tx_init0, rx_init0, tx_init1, rx_init1;
wire [19:0] fromCRC;
wire [31:0] toCRC;
wire crcrst, crcstrobe;
wire k_i;
wire lock, clk_40, clk_120, DRP_P, DRP_N;
wire we;
wire [5:0] selector_w;
wire [1:0] d_type_read_c;
wire [39:0] fifo_e_w;
wire [39:0] fifo_re_w;
wire [39:0] fifo_e_w_1;
wire [39:0] fifo_re_w_1;
wire [33:0] fifo_data0_w;
wire [33:0] fifo_data1_w;
wire [33:0] fifo_data2_w;
wire [33:0] fifo_data3_w;
wire [33:0] fifo_data4_w;
wire [33:0] fifo_data5_w;
wire [33:0] fifo_data6_w;
wire [33:0] fifo_data7_w;
wire [33:0] fifo_data8_w;
wire [33:0] fifo_data9_w;
wire [33:0] fifo_data10_w;
wire [33:0] fifo_data11_w;
wire [33:0] fifo_data12_w;
wire [33:0] fifo_data13_w;
wire [33:0] fifo_data14_w;
wire [33:0] fifo_data15_w;
wire [33:0] fifo_data16_w;
wire [33:0] fifo_data17_w;
wire [33:0] fifo_data18_w;
wire [33:0] fifo_data19_w;
wire [33:0] fifo_data20_w;
wire [33:0] fifo_data21_w;
wire [33:0] fifo_data22_w;
wire [33:0] fifo_data23_w;
wire [33:0] fifo_data24_w;
wire [33:0] fifo_data25_w;
wire [33:0] fifo_data26_w;
wire [33:0] fifo_data27_w;
wire [33:0] fifo_data28_w;
wire [33:0] fifo_data29_w;
wire [33:0] fifo_data30_w;
wire [33:0] fifo_data31_w;
wire [33:0] fifo_data32_w;
wire [33:0] fifo_data33_w;
wire [33:0] fifo_data34_w;
wire [33:0] fifo_data35_w;
wire [33:0] fifo_data36_w;
wire [33:0] fifo_data37_w;
wire [33:0] fifo_data38_w;
wire [33:0] fifo_data39_w;
wire clk_200;


///-----------------------------------------///
daphne2v daphne(
	.serial_cts(serial_cts),
	.serial_rts(serial_rts),
	.serial_tx(serial_tx),
	.serial_rx(serial_rx),
	.clk625_p(clk625_p),
	.clk625_n(clk625_n),
	.mclk_p(mclk_p), 
	.mclk_n(mclk_n),   
	.clk100_p(clk100_fpga_p),
	.clk100_n(clk100_fpga_n),
//	.gtp_clk0_p(mgtrefclk0_p),
//	.gtp_clk0_n(mgtrefclk0_n),
	.afe0_dclkp(afe0_dclkp),
	.afe0_dclkn(afe0_dclkn),
	.afe0_fclkp(afe0_fclkp),
	.afe0_fclkn(afe0_fclkn),
	.afe0_datap(afe0_datap),
	.afe0_datan(afe0_datan),
	.afe1_dclkn(afe1_dclkn),
	.afe1_dclkp(afe1_dclkp),
	.afe1_fclkn(afe1_fclkn),
	.afe1_fclkp(afe1_fclkp),
	.afe1_datan(afe1_datan),
	.afe1_datap(afe1_datap),
	.afe2_dclkn(afe2_dclkn),
	.afe2_dclkp(afe2_dclkp),
	.afe2_fclkn(afe2_fclkn),
	.afe2_fclkp(afe2_fclkp),
	.afe2_datan(afe2_datan),
	.afe2_datap(afe2_datap),
	.afe3_dclkn(afe3_dclkn),
	.afe3_dclkp(afe3_dclkp),
	.afe3_fclkn(afe3_fclkn),
	.afe3_fclkp(afe3_fclkp),
	.afe3_datan(afe3_datan),
	.afe3_datap(afe3_datap),
	.afe4_dclkn(afe4_dclkn),
	.afe4_dclkp(afe4_dclkp),
	.afe4_fclkn(afe4_fclkn),
	.afe4_fclkp(afe4_fclkp),
	.afe4_datan(afe4_datan),
	.afe4_datap(afe4_datap),
	///////////////////////////////////////////Modificaciones para pruebas//////////////////
	// fullmode_clk: read clk de los fifos
	//  fifo_gearbox_14_32n_rden0: read enable de los fifos
	//  gearbox_14_32n_dataout : data out de los fifos
	//  gearbox_14_32n_empty1: fifo empty de los fifos 
	.fullmode_clk(txusrclk),
	.re(fifo_re_w_1),
	.fifo_empty(fifo_e_w_1),
	.fifo_dout_0(fifo_data0_w),
	.fifo_dout_1(fifo_data1_w),
	.fifo_dout_2(fifo_data2_w),
	.fifo_dout_3(fifo_data3_w),
	.fifo_dout_4(fifo_data4_w),
	.fifo_dout_5(fifo_data5_w),
	.fifo_dout_6(fifo_data6_w),
	.fifo_dout_7(fifo_data7_w),
	.fifo_dout_8(fifo_data8_w),
	.fifo_dout_9(fifo_data9_w),
	.fifo_dout_10(fifo_data10_w),
	.fifo_dout_11(fifo_data11_w),
	.fifo_dout_12(fifo_data12_w),
	.fifo_dout_13(fifo_data13_w),
	.fifo_dout_14(fifo_data14_w),
	.fifo_dout_15(fifo_data15_w),
	.fifo_dout_16(fifo_data16_w),
	.fifo_dout_17(fifo_data17_w),
	.fifo_dout_18(fifo_data18_w),
	.fifo_dout_19(fifo_data19_w),
	.fifo_dout_20(fifo_data20_w),
	.fifo_dout_21(fifo_data21_w),
	.fifo_dout_22(fifo_data22_w),
	.fifo_dout_23(fifo_data23_w),
	.fifo_dout_24(fifo_data24_w),
	.fifo_dout_25(fifo_data25_w),
	.fifo_dout_26(fifo_data26_w),
	.fifo_dout_27(fifo_data27_w),
	.fifo_dout_28(fifo_data28_w),
	.fifo_dout_29(fifo_data29_w),
	.fifo_dout_30(fifo_data30_w),
	.fifo_dout_31(fifo_data31_w),
	.fifo_dout_32(fifo_data32_w),
	.fifo_dout_33(fifo_data33_w),
	.fifo_dout_34(fifo_data34_w),
	.fifo_dout_35(fifo_data35_w),
	.fifo_dout_36(fifo_data36_w),
	.fifo_dout_37(fifo_data37_w),
	.fifo_dout_38(fifo_data38_w),
	.fifo_dout_39(fifo_data39_w),
	.clk_200(clk_200)
);

////---------------------------------------////

FullMode_box_single FullMode_box_single(
	.data_FIFO_0(fifo_data0_w),
	.data_FIFO_1(fifo_data1_w),
	.data_FIFO_2(fifo_data2_w),
	.data_FIFO_3(fifo_data3_w),
	.data_FIFO_4(fifo_data4_w),
	.data_FIFO_5(fifo_data5_w),
	.data_FIFO_6(fifo_data6_w),
	.data_FIFO_7(fifo_data7_w),
	.data_FIFO_8(fifo_data8_w),
	.data_FIFO_9(fifo_data9_w),
	.data_FIFO_10(fifo_data10_w),
	.data_FIFO_11(fifo_data11_w),
	.data_FIFO_12(fifo_data12_w),
	.data_FIFO_13(fifo_data13_w),
	.data_FIFO_14(fifo_data14_w),
	.data_FIFO_15(fifo_data15_w),
	.data_FIFO_16(fifo_data16_w),
	.data_FIFO_17(fifo_data17_w),
	.data_FIFO_18(fifo_data18_w),
	.data_FIFO_19(fifo_data19_w),
	.data_FIFO_20(fifo_data20_w),
	.data_FIFO_21(fifo_data21_w),
	.data_FIFO_22(fifo_data22_w),
	.data_FIFO_23(fifo_data23_w),
	.data_FIFO_24(fifo_data24_w),
	.data_FIFO_25(fifo_data25_w),
	.data_FIFO_26(fifo_data26_w),
	.data_FIFO_27(fifo_data27_w),
	.data_FIFO_28(fifo_data28_w),
	.data_FIFO_29(fifo_data29_w),
	.data_FIFO_30(fifo_data30_w),
	.data_FIFO_31(fifo_data31_w),
	.data_FIFO_32(fifo_data32_w),
	.data_FIFO_33(fifo_data33_w),
	.data_FIFO_34(fifo_data34_w),
	.data_FIFO_35(fifo_data35_w),
	.data_FIFO_36(fifo_data36_w),
	.data_FIFO_37(fifo_data37_w),
	.data_FIFO_38(fifo_data38_w),
	.data_FIFO_39(fifo_data39_w),
	.FIFO_empty_IN(fifo_e_w_1),
	.data_to_GTP(daq_stream),
	.k_o(daq_stream_k[0]),
	.link_ready(status_bits[8]),
//    .link_ready(1'b1),
	.FIFO_re_OUT(fifo_re_w_1),
//	.sys_clk(clk100_fpga_pad2),
    .sys_clk(txusrclk),
	.sys_rst(!mmcm_locked)
);

//FullMode_box_dual FullMode_box_dual(
//	.data_FIFO_0(fifo_data0_w),
//	.data_FIFO_1(fifo_data1_w),
//.data_FIFO_2(fifo_data2_w),
//	.data_FIFO_3(fifo_data3_w),
//	.data_FIFO_4(fifo_data4_w),
//	.data_FIFO_5(fifo_data5_w),
//	.data_FIFO_6(fifo_data6_w),
//	.data_FIFO_7(fifo_data7_w),
//	.data_FIFO_8(fifo_data8_w),
//	.data_FIFO_9(fifo_data9_w),
//	.data_FIFO_10(fifo_data10_w),
//	.data_FIFO_11(fifo_data11_w),
//	.data_FIFO_12(fifo_data12_w),
//	.data_FIFO_13(fifo_data13_w),
//	.data_FIFO_14(fifo_data14_w),
//	.data_FIFO_15(fifo_data15_w),
//	.data_FIFO_16(fifo_data16_w),
//	.data_FIFO_17(fifo_data17_w),
//	.data_FIFO_18(fifo_data18_w),
//	.data_FIFO_19(fifo_data19_w),
//	.data_FIFO_20(fifo_data20_w),
//	.data_FIFO_21(fifo_data21_w),
//	.data_FIFO_22(fifo_data22_w),
//	.data_FIFO_23(fifo_data23_w),
//	.data_FIFO_24(fifo_data24_w),
//	.data_FIFO_25(fifo_data25_w),
//	.data_FIFO_26(fifo_data26_w),
//	.data_FIFO_27(fifo_data27_w),
//	.data_FIFO_28(fifo_data28_w),
//	.data_FIFO_29(fifo_data29_w),
//	.data_FIFO_30(fifo_data30_w),
//	.data_FIFO_31(fifo_data31_w),
//	.data_FIFO_32(fifo_data32_w),
//	.data_FIFO_33(fifo_data33_w),
//	.data_FIFO_34(fifo_data34_w),
//	.data_FIFO_35(fifo_data35_w),
//	.data_FIFO_36(fifo_data36_w),
//	.data_FIFO_37(fifo_data37_w),
//	.data_FIFO_38(fifo_data38_w),
//	.data_FIFO_39(fifo_data39_w),
//	.FIFO_empty_IN(fifo_e_w_1),
//	.data_to_GTP_0(daq_stream),
//	.k_o_0(daq_stream_k[0]),
//	.data_to_GTP_1(daq_stream2),
//	.k_o_1(daq_stream_k2[0]),
//	.link_ready(status_bits[8]),
//	.FIFO_re_OUT(fifo_re_w_1),
//	.sys_clk(txusrclk),
//	.sys_rst(!mmcm_locked)
//);
assign daq_stream_k[3:1] = 3'b0;
assign daq_stream_k2[3:1] = 3'b0;
 

    felix_gtp0 felix_gtp_inst 
    (
        .soft_reset_tx_in               (!mmcm_locked),
        .soft_reset_rx_in               (!mmcm_locked),
        .dont_reset_on_data_error_in    (1'b0),
        
        .q0_clk0_gtrefclk_pad_n_in      (mgtrefclk0_n),
        .q0_clk0_gtrefclk_pad_p_in      (mgtrefclk0_p),
        
        // DAQ0 SFP -- TX to FELIX
        .gt0_eyescanreset_in            (1'b0),
        .gt0_eyescantrigger_in          (1'b0),
        .gt0_gttxreset_in               (!mmcm_locked),
        .gt0_txuserrdy_in               (1'b1),
        .gt0_data_valid_in              (1'b1),
        .gt0_tx8b10ben_in               (1'b1),
        .gt0_txdata_in                  (daq_stream),
        .gt0_txcharisk_in               (daq_stream_k), // K symbol byte indicator
        .gt0_gtptxn_out                 (ch0_gtptxn_out),
        .gt0_gtptxp_out                 (ch0_gtptxp_out),
        .gt0_tx_mmcm_lock_out           (status_bits[10]),
        .gt0_tx_fsm_reset_done_out      (status_bits[9]),
//        .gt0_txusrclk_out               (txusrclk),
        .gt0_txusrclk2_out              (txusrclk),
        //.gt0_txoutclkfabric_out         (),
        //.gt0_txoutclkpcs_out            (),
        .gt0_txresetdone_out            (status_bits[8]),
        
        .gt0_gtrxreset_in               (!mmcm_locked),
        .gt0_rxlpmreset_in              (1'b0),
        .gt0_rxuserrdy_in               (1'b1),
        .gt0_drpen_in                   (1'b0),
        .gt0_drpwe_in                   (1'b0),
        .gt0_drpaddr_in                 (9'd0),
        .gt0_drpdi_in                   (16'd0),
        .gt0_gtprxn_in                  (ch0_gtprxn_in),
        .gt0_gtprxp_in                  (ch0_gtprxp_in),
        //.gt0_rxslide_in                 (1'b0),
        .gt0_rxlpmhfhold_in             (1'b0),
        .gt0_rxlpmlfhold_in             (1'b0),
        .gt0_rxmcommaalignen_in         (1'b1),
        .gt0_rxpcommaalignen_in         (1'b1),
        .gt0_rxdata_out                 (rxdata2),
        //.gt0_rx_mmcm_lock_out           (),
        //.gt0_rx_fsm_reset_done_out      (),
        //.gt0_rxusrclk_out               (),
        //.gt0_rxusrclk2_out              (),
        
        // DAQ1 SFP -- TEST RX from loopback
        .gt1_eyescanreset_in            (1'b0),
        .gt1_eyescantrigger_in          (1'b0),
        .gt1_gttxreset_in               (!mmcm_locked),
        .gt1_txuserrdy_in               (1'b1),
        .gt1_data_valid_in              (1'b1),
        .gt1_tx8b10ben_in               (1'b1),
        .gt1_txdata_in                  (daq_stream),
        .gt1_txcharisk_in               (daq_stream_k),
        .gt1_gtptxn_out                 (ch1_gtptxn_out),
        .gt1_gtptxp_out                 (ch1_gtptxp_out),
        .gt1_rxmcommaalignen_in         (1'b1),
        .gt1_rxpcommaalignen_in         (1'b1),
        //.gt1_tx_mmcm_lock_out           (),
        //.gt1_tx_fsm_reset_done_out      (),
        //.gt1_txusrclk_out               (),
        //.gt1_txusrclk2_out              (),
        //.gt1_txoutclkfabric_out         (),
        //.gt1_txoutclkpcs_out            (),
        //.gt1_txresetdone_out            (),   
        
        .gt1_gtrxreset_in               (!mmcm_locked),
        .gt1_rxlpmreset_in              (1'b0),
        .gt1_rxuserrdy_in               (1'b1),
        .gt1_drpen_in                   (1'b0),
        .gt1_drpwe_in                   (1'b0),
        .gt1_drpaddr_in                 (9'd0),
        .gt1_drpdi_in                   (16'd0),
        .gt1_gtprxn_in                  (ch1_gtprxn_in),
        .gt1_gtprxp_in                  (ch1_gtprxp_in),
       // .gt1_rxslide_in                 (1'b0),
        .gt1_rxlpmhfhold_in             (1'b0),
        .gt1_rxlpmlfhold_in             (1'b0),
        .gt1_rxdata_out                 (rxdata),
        .gt1_rx_mmcm_lock_out           (status_bits[5]),
        .gt1_rx_fsm_reset_done_out      (status_bits[4]),
        //.gt1_rxusrclk_out               (),
        .gt1_rxusrclk2_out              (rxusrclk2),

        // Common ports
        .gt0_pll0reset_out              (status_bits[1]),
        //.gt0_pll0outclk_out             (),
        //.gt0_pll0outrefclk_out          (),
        .gt0_pll0lock_out               (status_bits[0]),
        //.gt0_pll0refclklost_out         (),    
        //.gt0_pll1outclk_out             (),
        //.gt0_pll1outrefclk_out          (),
//        .sysclk_in(clk100_fpga_pad2)
        .sysclk_in(clk_120)
    );    
    
    assign status_bits[31] = daq_sfp0_los;
    assign status_bits[30] = daq_sfp0_abs;
    assign status_bits[29] = daq_sfp1_los;
    assign status_bits[28] = daq_sfp1_abs;

    // Debug probes
    ila_0 ila_ep (
        .clk    (clk_sample),
        .probe0 (daq_stream_k[0]),
        .probe1 (we),
        .probe2 (status_bits[8]),
        .probe3 (txusrclk),
        .probe4    (mmcm_locked),
        .probe5    (rxusrclk2),
        .probe6    (rxdata), // 32-bit wide
        .probe7    (daq_stream), // 32-bit wide
        .probe8    (clk_120),
        .probe9    (clk100_fpga_pad2)
//        .probe10    (rxdata), // 32-bit wide
//        .probe11    (daq_stream) // 32-bit wide
    );
    
    vio_0 vio_ep (
        .clk    (clk100_fpga_pad2),
        .probe_in0  (1'b0),
        .probe_in1  (1'b0),
        .probe_in2  (1'b0),
        .probe_in3  (1'b0),
        .probe_in4  (1'b0),
        .probe_in5  (1'b0),
        .probe_in6  (1'b0),
        .probe_in7  (1'b0),
        .probe_out0 (edge_sel),
        .probe_out1 (mmcm_reset_in),
        .probe_out2 (txrst),
        .probe_out3 (rxrst)
//        .probe_out6 (daq_sfp0_txdis),
//        .probe_out7 (daq_sfp1_txdis)

    );
  
  assign daq_sfp0_txdis = 1'b0; 
  assign daq_sfp1_txdis = 1'b0; 
  
   
//    clk_wiz_0 mmcm_ep (
//        .clk_in1_p    (clk100_fpga_p),
//        .clk_in1_n    (clk100_fpga_n),
//        .reset      (mmcm_reset_in),
//        .locked     (mmcm_locked),
//        .clk_out1   (clk_sample),
//        .clk_out120   (clk_120),
//        .clk_out100 (clk100_fpga_pad2)
  MMCM_GTP mmcm_ep (
        .clk_in1    (clk_200),
        .reset      (mmcm_reset_in),
        .locked     (mmcm_locked),
        .clk_out1   (clk_sample),
        .clk_out2   (clk100_fpga_pad2),
        .clk_out3 (clk_120)
    );
    
  
    
endmodule
