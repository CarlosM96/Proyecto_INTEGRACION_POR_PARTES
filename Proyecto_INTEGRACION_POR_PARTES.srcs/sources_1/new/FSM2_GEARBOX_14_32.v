/* Machine-generated using Migen */
module FSM2_GEARBOX_14_32(
	output reg waveform_ready0,
	input enable,
	input [13:0] datain,
	output [33:0] dataout,
	input rden,
	input rdclk,
	output empty,
	input adc_frame_clk,  //este reloj
	input adc_frame_rst,
	input sys_clk, // y este reloj deberia de ser lo mismo
	input sys_rst
);

reg [3:0] cnt_rst0 = 4'd0;
reg fifo_0_ready = 1'd0;
reg [223:0] data_buffer = 224'd0;
reg buffer_valid = 1'd0;
reg [3:0] contador = 4'd0;
reg [223:0] reg_1 = 224'd0;
reg [2:0] contador6 = 3'd0;
reg [1:0] flag_kd = 2'd0;
wire almostempty;
wire almostfull;
wire [33:0] do_1;
wire empty1;
wire full;
wire [8:0] rdcount;
wire rderr;
wire [8:0] wrcount;
wire wrerr;
reg [33:0] di = 34'd0;
wire rdclk1;
wire rden1;
wire wrclk;
wire wren;
reg rst = 1'd0;
reg [1:0] state = 2'd0;
reg [1:0] next_state;
reg [3:0] cnt_rst0_t_next_value0;
reg cnt_rst0_t_next_value_ce0;
reg rst_t_next_value1;
reg rst_t_next_value_ce1;
reg fifo_0_ready_t_next_value2;
reg fifo_0_ready_t_next_value_ce2;
reg [3:0] contador_f_next_value0;
reg contador_f_next_value_ce0;
reg buffer_valid_f_next_value1;
reg buffer_valid_f_next_value_ce1;
reg [223:0] data_buffer_f_next_value2;
reg data_buffer_f_next_value_ce2;
reg [223:0] reg_1_t_next_value3;
reg reg_1_t_next_value_ce3;
reg [2:0] contador6_t_next_value4;
reg contador6_t_next_value_ce4;

// synthesis translate_off
reg dummy_s;
initial dummy_s <= 1'd0;
// synthesis translate_on

assign wren = buffer_valid;
assign rden1 = rden;
//assign rdclk1 = sys_clk;
assign wrclk = adc_frame_clk;
assign dataout = do_1;
assign empty = empty1;

// synthesis translate_off
reg dummy_d;
// synthesis translate_on
always @(*) begin
	next_state <= 2'd0;
	cnt_rst0_t_next_value0 <= 4'd0;
	cnt_rst0_t_next_value_ce0 <= 1'd0;
	rst_t_next_value1 <= 1'd0;
	rst_t_next_value_ce1 <= 1'd0;
	fifo_0_ready_t_next_value2 <= 1'd0;
	fifo_0_ready_t_next_value_ce2 <= 1'd0;
	contador_f_next_value0 <= 4'd0;
	contador_f_next_value_ce0 <= 1'd0;
	buffer_valid_f_next_value1 <= 1'd0;
	buffer_valid_f_next_value_ce1 <= 1'd0;
	data_buffer_f_next_value2 <= 224'd0;
	data_buffer_f_next_value_ce2 <= 1'd0;
	reg_1_t_next_value3 <= 224'd0;
	reg_1_t_next_value_ce3 <= 1'd0;
	contador6_t_next_value4 <= 3'd0;
	contador6_t_next_value_ce4 <= 1'd0;
	next_state <= state;
	case (state)
		1'd1: begin
			if ((cnt_rst0 <= 3'd5)) begin
				rst_t_next_value1 <= 1'd1;
				rst_t_next_value_ce1 <= 1'd1;
			end else begin
				rst_t_next_value1 <= 1'd0;
				rst_t_next_value_ce1 <= 1'd1;
			end
			if ((cnt_rst0 == 4'd12)) begin
				fifo_0_ready_t_next_value2 <= 1'd1;
				fifo_0_ready_t_next_value_ce2 <= 1'd1;
				next_state <= 2'd2;
			end
			cnt_rst0_t_next_value0 <= (cnt_rst0 - 1'd1);
			cnt_rst0_t_next_value_ce0 <= 1'd1;
		end
		2'd2: begin
			if (enable) begin
				next_state <= 2'd3;
			end else begin
				contador_f_next_value0 <= 1'd0;
				contador_f_next_value_ce0 <= 1'd1;
				buffer_valid_f_next_value1 <= 1'd0;
				buffer_valid_f_next_value_ce1 <= 1'd1;
				data_buffer_f_next_value2 <= 1'd0;
				data_buffer_f_next_value_ce2 <= 1'd1;
			end
		end
		2'd3: begin
			if ((~waveform_ready0)) begin
				data_buffer_f_next_value2 <= ((datain <<< 8'd210) | (data_buffer >>> 4'd14));
				data_buffer_f_next_value_ce2 <= 1'd1;
				contador_f_next_value0 <= (contador + 1'd1);
				contador_f_next_value_ce0 <= 1'd1;
				if ((contador == 4'd15)) begin
					reg_1_t_next_value3 <= data_buffer;
					reg_1_t_next_value_ce3 <= 1'd1;
					buffer_valid_f_next_value1 <= 1'd1;
					buffer_valid_f_next_value_ce1 <= 1'd1;
				end
				if (buffer_valid) begin
					contador6_t_next_value4 <= (contador6 + 1'd1);
					contador6_t_next_value_ce4 <= 1'd1;
					if ((contador6 == 3'd6)) begin
						buffer_valid_f_next_value1 <= 1'd0;
						buffer_valid_f_next_value_ce1 <= 1'd1;
						contador6_t_next_value4 <= 1'd0;
						contador6_t_next_value_ce4 <= 1'd1;
					end
				end else begin
					contador6_t_next_value4 <= 1'd0;
					contador6_t_next_value_ce4 <= 1'd1;
				end
			end else begin
				next_state <= 2'd2;
			end
		end
		default: begin
			if ((enable & (fifo_0_ready == 1'd0))) begin
				cnt_rst0_t_next_value0 <= 4'd10;
				cnt_rst0_t_next_value_ce0 <= 1'd1;
				next_state <= 1'd1;
			end else begin
				cnt_rst0_t_next_value0 <= 1'd0;
				cnt_rst0_t_next_value_ce0 <= 1'd1;
			end
		end
	endcase
// synthesis translate_off
	dummy_d <= dummy_s;
// synthesis translate_on
end

always @(posedge adc_frame_clk) begin
	state <= next_state;
	if (cnt_rst0_t_next_value_ce0) begin
		cnt_rst0 <= cnt_rst0_t_next_value0;
	end
	if (rst_t_next_value_ce1) begin
		rst <= rst_t_next_value1;
	end
	if (fifo_0_ready_t_next_value_ce2) begin
		fifo_0_ready <= fifo_0_ready_t_next_value2;
	end
	if (contador_f_next_value_ce0) begin
		contador <= contador_f_next_value0;
	end
	if (buffer_valid_f_next_value_ce1) begin
		buffer_valid <= buffer_valid_f_next_value1;
	end
	if (data_buffer_f_next_value_ce2) begin
		data_buffer <= data_buffer_f_next_value2;
	end
	if (reg_1_t_next_value_ce3) begin
		reg_1 <= reg_1_t_next_value3;
	end
	if (contador6_t_next_value_ce4) begin
		contador6 <= contador6_t_next_value4;
	end
	if (adc_frame_rst) begin
		cnt_rst0 <= 4'd0;
		fifo_0_ready <= 1'd0;
		data_buffer <= 224'd0;
		buffer_valid <= 1'd0;
		contador <= 4'd0;
		reg_1 <= 224'd0;
		contador6 <= 3'd0;
		rst <= 1'd0;
		state <= 2'd0;
	end
end

always @(posedge sys_clk) begin
	if (((wrcount - rdcount) == 7'd83)) begin
		waveform_ready0 <= 1'd1;
	end else begin
		if (((wrcount - rdcount) == 7'd82)) begin
			flag_kd <= 2'd2;
		end else begin
			if (((wrcount - rdcount) < 1'd1)) begin
				waveform_ready0 <= 1'd0;
				flag_kd <= 1'd1;
			end else begin
				flag_kd <= 1'd0;
			end
		end
	end
	case (contador6)
		1'd0: begin
			di <= ((flag_kd <<< 6'd32) | reg_1[31:0]);
		end
		1'd1: begin
			di <= ((flag_kd <<< 6'd32) | reg_1[63:32]);
		end
		2'd2: begin
			di <= ((flag_kd <<< 6'd32) | reg_1[95:64]);
		end
		2'd3: begin
			di <= ((flag_kd <<< 6'd32) | reg_1[127:96]);
		end
		3'd4: begin
			di <= ((flag_kd <<< 6'd32) | reg_1[159:128]);
		end
		3'd5: begin
			di <= ((flag_kd <<< 6'd32) | reg_1[191:160]);
		end
		3'd6: begin
			di <= ((flag_kd <<< 6'd32) | reg_1[223:192]);
		end
		default: begin
			di <= ((flag_kd <<< 6'd32) | reg_1[31:0]);
		end
	endcase
	if (sys_rst) begin
		waveform_ready0 <= 1'd0;
		flag_kd <= 2'd0;
		di <= 34'd0;
	end
end

FIFO_DUALCLOCK_MACRO #(
	.ALMOST_EMPTY_OFFSET(3'd6),
	.ALMOST_FULL_OFFSET(4'd12),
	.DATA_WIDTH(6'd34),
	.DEVICE("7SERIES"),
	.FIFO_SIZE("18Kb"),
	.FIRST_WORD_FALL_THROUGH("FALSE")
) FIFO_DUALCLOCK_MACRO (
	.DI(di),
	.RDCLK(rdclk1),
	.RDEN(rden1),
	.RST(rst),
	.WRCLK(wrclk),
	.WREN(wren),
	.ALMOSTEMPTY(almostempty),
	.ALMOSTFULL(almostfull),
	.DO(do_1),
	.EMPTY(empty1),
	.FULL(full),
	.RDCOUNT(rdcount),
	.RDERR(rderr),
	.WRCOUNT(wrcount),
	.WRERR(wrerr)
);

endmodule
