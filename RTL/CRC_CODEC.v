//Author: Huang Chaofan
//Function:CRC CODEC
module CRC_CODEC(
	input wire			clk,
	input wire			rst_n,
	input wire[15:0]		data_in,
	input wire			valid_i,
	input wire			mode,		//1: code		0: decode

	output reg[15:0]		data_out,
	output reg			valid_o

);
	//variable
	reg [4:0] cnt;		//counter

	reg d0;
	reg d1;
	reg d2;
	reg d3;
	reg d4;
	reg d5;
	reg d6;
	reg d7;

	//logic
	always @(posedge clk or negedge rst_n)//cnt
	begin
		if(!rst_n)
			cnt <= 0;
		else if( cnt == 9 )
			cnt <= 1;
		else if(valid_i || cnt > 0)
			cnt <= cnt + 1;
		else
			cnt <= cnt;
	end

	always @(posedge clk or negedge rst_n)//d0
	begin
		if(!rst_n)
			d0 <= 0;
		else if( cnt >= 1 && cnt <= 8 )
			d0 <= data_in[16-cnt] ^ d7;
		else if( cnt == 9 )
			d0 <= 0;
		else
			d0 <= d0;
	end

	always @(posedge clk or negedge rst_n)//d1
	begin
		if(!rst_n)
			d1 <= 0;
		else if( cnt >= 1 && cnt <= 8 )
			d1 <= data_in[16-cnt] ^ d7 ^ d0;
		else if( cnt == 9 )
			d1 <= 0;
		else
			d1 <= d1;
	end

	always @(posedge clk or negedge rst_n)//d2
	begin
		if(!rst_n)
			d2 <= 0;
		else if( cnt >= 1 && cnt <= 8 )
			d2 <= data_in[16-cnt] ^ d7 ^ d1;
		else if( cnt == 9 )
			d2 <= 0;
		else
			d2 <= d2;
	end
	
	always @(posedge clk or negedge rst_n)//d3
	begin
		if(!rst_n)
			d3 <= 0;
		else if( cnt >= 1 && cnt <= 8 )
			d3 <= d2;
		else if( cnt == 9 )
			d3 <= 0;
		else
			d3 <= d3;
	end

	always @(posedge clk or negedge rst_n)//d4
	begin
		if(!rst_n)
			d4 <= 0;
		else if( cnt >= 1 && cnt <= 8 )
			d4 <= d3;
		else if( cnt == 9 )
			d4 <= 0;
		else
			d4 <= d4;
	end

	always @(posedge clk or negedge rst_n)//d5
	begin
		if(!rst_n)
			d5 <= 0;
		else if( cnt >= 1 && cnt <= 8 )
			d5 <= d4;
		else if( cnt == 9 )
			d5 <= 0;
		else
			d5 <= d5;
	end

	always @(posedge clk or negedge rst_n)//d6
	begin
		if(!rst_n)
			d6 <= 0;
		else if( cnt >= 1 && cnt <= 8 )
			d6 <= d5;
		else if( cnt == 9 )
			d6 <= 0;
		else
			d6 <= d6;
	end

	always @(posedge clk or negedge rst_n)//d7
	begin
		if(!rst_n)
			d7 <= 0;
		else if( cnt >= 1 && cnt <= 8 )
			d7 <= d6;
		else if( cnt == 9 )
			d7 <= 0;
		else
			d7 <= d7;
	end

	always @(posedge clk or negedge rst_n)//valid_o
	begin
		if(!rst_n)
			valid_o <= 0;
		else if(  cnt == 9 )
			valid_o <= 1;
		else
			valid_o <= 0;
	end

	always @(posedge clk or negedge rst_n)//data_out
	begin
		if(!rst_n)
			data_out <= 0;
		else if( cnt == 8 )
		begin
			if(mode)//code
				data_out[15:8] <= data_in[15:8]; 
			else//decode
				data_out <= data_in;
		end
		else if( cnt == 9 )
		begin
			if(mode)//code
			begin
				data_out[7] <= d7;
				data_out[6] <= d6;
				data_out[5] <= d5;
				data_out[4] <= d4;
				data_out[3] <= d3;
				data_out[2] <= d2;
				data_out[1] <= d1;
				data_out[0] <= d0;
			end
			else//decode
			begin
				case({d7^data_out[7], d6^data_out[6], d5^data_out[5], d4^data_out[4], d3^data_out[3], d2^data_out[2], d1^data_out[1],d0^data_out[0]})
					8'b1000_1001: data_out[15] <= ~data_out[15];
					8'b1100_0111: data_out[14] <= ~data_out[14];
					8'b1110_0000: data_out[13] <= ~data_out[13];
					8'b0111_0000: data_out[12] <= ~data_out[12];
					8'b0011_1000: data_out[11] <= ~data_out[11];
					8'b0001_1100: data_out[10] <= ~data_out[10];
					8'b0000_1110: data_out[9] <= ~data_out[9];
					8'b0000_0111: data_out[8] <= ~data_out[8];
					8'b1000_0000: data_out[7] <= ~data_out[7];
					8'b0100_0000: data_out[6] <= ~data_out[6];
					8'b0010_0000: data_out[5] <= ~data_out[5];
					8'b0001_0000: data_out[4] <= ~data_out[4];
					8'b0000_1000: data_out[3] <= ~data_out[3];
					8'b0000_0100: data_out[2] <= ~data_out[2];
					8'b0000_0010: data_out[1] <= ~data_out[1];
					8'b0000_0001: data_out[0] <= ~data_out[0];
					default: data_out <= data_out;
				endcase
			end
		end
		else
			data_out <= data_out;
	end
endmodule
