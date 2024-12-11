//Author: Huang Chaofan
//Function: CRC CODEC testbench
module CRC_CODEC_tb;
	parameter SIZE = 100;

	//variable define
	reg 		clk;
	reg 		rst_n;
	reg [15:0] 	data_in;
	reg 		valid_i;
	reg 		mode;

	wire[15:0] 	data_out;
	wire 		valid_o;

	reg [15:0]  data_input [SIZE-1:0];
	reg [4:0]	cnt;
	reg [6:0]	end_cnt;
	reg [6:0]	addr;
	integer		file;
	//instance
	CRC_CODEC CRC_CODEC0
	(
	.clk		(clk),
	.rst_n		(rst_n),
	.data_in	(data_in),
	.valid_i	(valid_i),
	.mode		(mode),
	.data_out	(data_out),
	.valid_o	(valid_o)
	);

	//logic
	initial //initialize
	begin
		file = $fopen("CRC_encoder_o.txt","w");
		$readmemb("CRC_encoder_i.txt", data_input);
		clk = 0;
		rst_n = 0;
		#100
		rst_n = 1;
		mode = 1;
	end

	always #5 clk = ~clk;

	always @(posedge clk or negedge rst_n)//cnt
	begin
		if(!rst_n)
			cnt <= 0;
		else if( cnt == 9 )
			cnt <= 1;
		else
			cnt <= cnt + 1;
	end

	always @(posedge clk or negedge rst_n)//end_cnt
	begin
		if(!rst_n)
			end_cnt <= 0;
		else if(valid_o)
			end_cnt <= end_cnt + 1;
		else
			end_cnt <= end_cnt;
	end

	always @(posedge clk or negedge rst_n)//addr
	begin
		if(!rst_n)
			addr <= 0;
		else if( cnt == 9 )
			addr <= addr + 1;
		else
			addr <= addr;
	end

	always @(*)//data_in
	begin
		if(!rst_n)
			data_in = 0;
		else
			data_in = data_input[addr]; 
	end

	always @(*)//valid_i
	begin
		if(!rst_n)
			valid_i = 0;
		else
			valid_i = 1;
	end

	always @(posedge clk)//file
	begin
		if(end_cnt == 100)
		begin
			#100
			$display("\n##### Done ####\n"); 
			$stop();
		end
		else if(valid_o)
			$fwrite(file,"%b\n", data_out);
	end
	
endmodule
