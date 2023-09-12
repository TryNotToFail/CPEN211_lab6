module tb_datapath(output err);
  
  reg tclk;
  reg [15:0] test_in;
  reg [7:0] tpc;
  reg [15:0] test_out;
  reg [1:0] twb_sel;
  reg [2:0] tw_addr;
  reg tw_en;
  reg [2:0] tr_addr;
  reg ten_A;
  reg ten_B;
  reg [1:0] tshift_op;
  reg tsel_A;
  reg tsel_B;
  reg [1:0] tALU_op;
  reg ten_C;
  reg ten_status;
  reg [15:0] tsximm8;
  reg [15:0] tsximm5;
  reg tN_out;
  reg tV_out;
  reg tZ_out;

  reg err1;
  assign err = err1;

  datapath DUT (
		    .clk(tclk),
		    .mdata(test_in),
	   	    .pc(tpc),
		    .wb_sel(twb_sel),
		    .w_addr(tw_addr),
		    .w_en(tw_en),
		    .r_addr(tr_addr),
		    .en_A(ten_A),
		    .en_B(ten_B),
		    .shift_op(tshift_op),
		    .sel_A(tsel_A),
		    .sel_B(tsel_B),
		    .ALU_op(tALU_op),
		    .en_C(ten_C),
		    .en_status(ten_status),
  		    .sximm8(tsximm8),
		    .sximm5(tsximm5),
		    .datapath_out(test_out),
		    .Z_out(tZ_out),
		    .N_out(tN_out),
		    .V_out(tV_out)
		   );

   initial begin
	test_in = 16'b1111111111111111; //-1 value
    	twb_sel = 2'b11;
	tw_addr = 3'b001; // write to R1
	tw_en = 1'b1;
	tclk = 1'b1;
  	#5;
  	tclk = 1'b0;
	#5;
	
	$display("%b", test_in + (16'b1));
	$stop;

	


//testing from the lab instruction
	//Load a value to R2
	test_in = 16'b0000000000001000;
	twb_sel = 2'b11;	
	tw_addr = 3'b010;
	tw_en = 1'b1;
	tclk = 1'b1;
	#5;
	tw_en = 1'b0;
	tclk = 1'b0;
	#5;
	$display ("The value %b has written to R2" , (16'b0000000000001000));
	
	//Load a value to R3
	tw_addr = 3'b011;
	test_in = 16'b0000000000000100;
	tw_en = 1'b1;
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;
	$display ("The value %b has written to R3" , (16'b0000000000000100));

	//cycle 1 Load R2 value to A
	tr_addr = 3'b010;
	ten_A = 1'b1;
	ten_B = 1'b0;
	tw_en = 1'b0;
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	//cycle 2
	tr_addr = 3'b011;
	ten_A = 1'b0;
	ten_B = 1'b1;
	tw_en = 1'b0;
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	//cycle 3
	ten_B = 1'b0;
	ten_A = 1'b0;
	tshift_op = 2'b00;
	tsel_A = 1'b0;
	tsel_B = 1'b0;
	tALU_op = 2'b00;
	ten_C = 1'b1;
	ten_status = 1'b1;
	tw_en = 1'b0;
	$display ("Do addition");
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	// cycle 4
	ten_B = 1'b0;
	ten_A = 1'b0;
	tw_en = 1'b1;
	twb_sel = 2'b0;
	tw_addr = 3'b101;
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	$display ("The data out is %b, we expected %b", test_out, (16'b0000000000001000 + 16'b0000000000000100));
        if (test_out == 16'b0000000000001100)
        	 err1 = 1'b0;
        else
        	err1 = 1'b1;
        #5;

        
        $display ("err is %b, we expected %b", err, (1'b0));
        #5;
	#5;

//Substraction
	//Load a value to R2
	test_in = 16'b0000000000001000;
	twb_sel = 2'b11;	
	tw_addr = 3'b010;
	tw_en = 1'b1;
	tclk = 1'b1;
	#5;
	tw_en = 1'b0;
	tclk = 1'b0;
	#5;
	$display ("The value %b has written to R2" , (16'b0000000000001000));
	
	//Load a value to R3
	tw_addr = 3'b011;
	test_in = 16'b0000000000000100;
	tw_en = 1'b1;
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;
	$display ("The value %b has written to R3" , (16'b0000000000000100));

	//cycle 1 Load R2 value to A
	tr_addr = 3'b010;
	ten_A = 1'b1;
	ten_B = 1'b0;
	tw_en = 1'b0;
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	//cycle 2
	tr_addr = 3'b011;
	ten_A = 1'b0;
	ten_B = 1'b1;
	tw_en = 1'b0;
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

        //cycle 3 with substraction
	ten_B = 1'b0;
	ten_A = 1'b0;
	tshift_op = 2'b00;
	tsel_A = 1'b0;
	tsel_B = 1'b0;
	tALU_op = 2'b01;
	ten_C = 1'b1;
	ten_status = 1'b1;
	tw_en = 1'b0;
	$display ("Do substraction");
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	// cycle 4
	ten_B = 1'b0;
	ten_A = 1'b0;
	tw_en = 1'b1;
	twb_sel = 2'b0;
	tw_addr = 3'b101;
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	$display ("The data out is %b, we expected %b", test_out, (16'b0000000000001000 - 16'b0000000000000100));
	#5;

        if (test_out == 16'b0000000000001000 - 16'b0000000000000100)
        err1 = 1'b0;
        else
        err1 = 1'b1;
        #5;

        
        $display ("err is %b, we expected %b", err, (1'b0));
        #5;
	#5;

//cycle 3 with bitwise &
	ten_B = 1'b0;
	ten_A = 1'b0;
	tshift_op = 2'b00;
	tsel_A = 1'b0;
	tsel_B = 1'b0;
	tALU_op = 2'b10;
	ten_C = 1'b1;
	ten_status = 1'b1;
	tw_en = 1'b0;
	$display ("Do bitwise &");
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	// cycle 4
	ten_B = 1'b0;
	ten_A = 1'b0;
	tw_en = 1'b1;
	twb_sel = 2'b0;
	tw_addr = 3'b101;
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	$display ("The data out is %b, we expected %b", test_out, (16'b0000000000001000 & 16'b0000000000000100));
	#5;
        
        if (test_out == 16'b0000000000000000)
        err1 = 1'b0;
        else
        err1 = 1'b1;
        #5;

        
        $display ("err is %b, we expected %b", err, (1'b0));
        #5;
	#5;

//cycle 3 with bitwise negation for B
	ten_B = 1'b0;
	ten_A = 1'b0;
	tshift_op = 2'b00;
	tsel_A = 1'b0;
	tsel_B = 1'b0;
	tALU_op = 2'b11;
	ten_C = 1'b1;
	ten_status = 1'b1;
	tw_en = 1'b0;
	$display ("Do bitwise negation for B");
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	// cycle 4
	ten_B = 1'b0;
	ten_A = 1'b0;
	tw_en = 1'b1;
	twb_sel = 2'b0;
	tw_addr = 3'b101;
	tclk = 1'b1;
	#5;
	tclk = 1'b0;
	#5;

	$display ("The data out is %b, we expected %b", test_out, (~16'b0000000000000100));

        if (test_out == ~16'b0000000000000100)
        err1 = 1'b0;
        else
        err1 = 1'b1;
        #5;

        
        $display ("err is %b, we expected %b", err, (1'b0));
        #5;
	#5;
	$stop;
  end
endmodule: tb_datapath

