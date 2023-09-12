module tb_controller(output err);
  
  //input
  reg tclk;
  reg trst_n;
  reg tstart;
  reg [2:0] topcode;
  reg [1:0] tALU_op;
  reg [1:0] tshift_op;
  reg tZ;
  reg tN;
  reg tV;

  //output
  reg twaiting;
  reg [1:0] treg_sel;
  reg [1:0] twb_sel;
  reg tw_en;
  reg ten_A;
  reg ten_B;
  reg ten_C;
  reg ten_status;
  reg tsel_A;
  reg tsel_B;

  reg error;

  assign err = error;

  controller DUT (
		.clk(tclk),
		.rst_n(trst_n),
		.start(tstart),
		.opcode(topcode),
		.ALU_op(tALU_op),
		.shift_op(tshift_op),
		.Z(tZ),
		.N(tN),		
		.V(tV),
		.waiting(twaiting),
		.reg_sel(treg_sel),
		.wb_sel(twb_sel),
		.w_en(tw_en),
		.en_A(ten_A),
		.en_B(ten_B),
		.en_C(ten_C),
		.en_status(ten_status),
		.sel_A(tsel_A),
		.sel_B(tsel_B)
		);

 initial begin
  //reset everything
  trst_n = 1'b0; //active low

  //cycle 1
  tclk = 1'b1; 

   if (twaiting != 1'b1) error = 1'b1;
  else if (treg_sel != 2'b11) error = 1'b1;
  else if (twb_sel != 2'b00) error = 1'b1;
  else if (tw_en != 1'b0) error = 1'b1;
  else if (ten_A != 1'b0) error = 1'b1;
  else if (ten_B != 1'b0) error = 1'b1;
  else if (ten_C != 1'b0) error = 1'b1;
  else if (ten_status != 1'b0) error = 1'b1;
  else if (tsel_A != 1'b0) error = 1'b1;
  else if (tsel_B != 1'b0) error = 1'b1;
  else error = 1'b0;

  #5;

  tclk = 1'b0;
  #5;
  $display("after reset");
  $display("waiting is %b", twaiting);
  $display("reg_sel is %b", treg_sel);
  $display("wb_sel is %b", twb_sel);
  $display("w_en is $b", tw_en);
  $display("en_A is $b", ten_A);
  $display("en_B is $b", ten_B);
  $display("en_C is $b", ten_C);
  $display("en_status is $b", ten_status);
  $display("sel_A is $b", tsel_A);
  $display("sel_B is $b", tsel_B);


//simple MOV inst
   trst_n = 1'b1; //reset off
   tclk = 1'b1; //cycle 1
   topcode = 3'b110;
   tALU_op = 2'b10;
   tshift_op = 2'b00; //no shift
   tZ = 1'b0; //Z value is 0
   tN = 1'b0; //N value is 0
   tV = 1'b0; //V value is 0
   tstart = 1'b1; //start
   #5;
   
   tclk = 1'b0;
   #5; 

   //cycle 1
   tclk = 1'b1;
   tstart = 1'b0;
   #5;

   tclk = 1'b0;
   #5; 
   
   //cycle 2
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5; 
   
   //cycle 3
   tclk = 1'b1;
   #5;
 
   tclk = 1'b0;

   if (twaiting != 1'b1) error = 1'b1;
  else if (treg_sel != 2'b11) error = 1'b1;
  else if (twb_sel != 2'b0) error = 1'b1;
  else if (tw_en != 1'b0) error = 1'b1;
  else if (ten_A != 1'b0) error = 1'b1;
  else if (ten_B != 1'b0) error = 1'b1;
  else if (ten_C != 1'b0) error = 1'b1;
  else if (ten_status != 1'b0) error = 1'b1;
  else if (tsel_A != 1'b0) error = 1'b1;
  else if (tsel_B != 1'b0) error = 1'b1;
  else error = 1'b0;

   #5; 

//MOV shift not pushing start
   tALU_op = 2'b0;
   tclk = 1'b1;   //cycle 1
   #5;
 
   tclk = 1'b0;
   #5;

   //cycle 2
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

//pushing start
   tstart = 1'b1;
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 1
   tclk = 1'b1;
   tstart = 1'b0;
   #5;
 
   tclk = 1'b0;
   #5;

   //cycle 1
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 3
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 4
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 5 waiting begin
   tclk = 1'b1;
   #5;

   tclk = 1'b0;

  if (twaiting != 1'b1) error = 1'b1;
  else if (treg_sel != 2'b11) error = 1'b1;
  else if (twb_sel != 2'b0) error = 1'b1;
  else if (tw_en != 1'b0) error = 1'b1;
  else if (ten_A != 1'b0) error = 1'b1;
  else if (ten_B != 1'b0) error = 1'b1;
  else if (ten_C != 1'b0) error = 1'b1;
  else if (ten_status != 1'b0) error = 1'b1;
  else if (tsel_A != 1'b0) error = 1'b1;
  else if (tsel_B != 1'b0) error = 1'b1;
  else error = 1'b0;
 
   #5;
   
//ADD
   topcode = 3'b101;
   tALU_op = 2'b00;
   tstart = 1'b1;
   tclk = 1'b1; 
   #5;

   tclk = 1'b0;
   #5;

   tstart = 1'b0;
   //cycle 1
   tclk = 1'b1;
   tstart = 1'b0;
   #5;
 
   tclk = 1'b0;
   #5;

   //cycle 2
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 3
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 4
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 5 
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

  //cycle 6 waiting begin
   tclk = 1'b1;
   #5;

   tclk = 1'b0;

  if (twaiting != 1'b1) error = 1'b1;
  else if (treg_sel != 2'b11) error = 1'b1;
  else if (twb_sel != 2'b0) error = 1'b1;
  else if (tw_en != 1'b0) error = 1'b1;
  else if (ten_A != 1'b0) error = 1'b1;
  else if (ten_B != 1'b0) error = 1'b1;
  else if (ten_C != 1'b0) error = 1'b1;
  else if (ten_status != 1'b0) error = 1'b1;
  else if (tsel_A != 1'b0) error = 1'b1;
  else if (tsel_B != 1'b0) error = 1'b1;
  else error = 1'b0;

   #5;

//CMP 
   tALU_op = 2'b01;
   tstart = 1'b1;
   tclk = 1'b1; 
   #5;

   tclk = 1'b0;
   #5;

   tstart = 1'b0;
   //cycle 1
   tclk = 1'b1;
   tstart = 1'b0;
   #5;
 
   tclk = 1'b0;
   #5;

   //cycle 2
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 3
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 4
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 5 
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

  //cycle 6 waiting begin
   tclk = 1'b1;
   #5;

   tclk = 1'b0;

   if (twaiting != 1'b1) error = 1'b1;
  else if (treg_sel != 2'b11) error = 1'b1;
  else if (twb_sel != 2'b0) error = 1'b1;
  else if (tw_en != 1'b0) error = 1'b1;
  else if (ten_A != 1'b0) error = 1'b1;
  else if (ten_B != 1'b0) error = 1'b1;
  else if (ten_C != 1'b0) error = 1'b1;
  else if (ten_status != 1'b0) error = 1'b1;
  else if (tsel_A != 1'b0) error = 1'b1;
  else if (tsel_B != 1'b0) error = 1'b1;
  else error = 1'b0;

   #5;
 
//AND 
   tALU_op = 2'b10;
   tstart = 1'b1;
   tclk = 1'b1; 
   #5;

   tclk = 1'b0;
   #5;

   tstart = 1'b0;
   //cycle 1
   tclk = 1'b1;
   tstart = 1'b0;
   #5;
 
   tclk = 1'b0;
   #5;

   //cycle 2
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 3
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 4
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 5 
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

  //cycle 6 waiting begin
   tclk = 1'b1;
   #5;

   tclk = 1'b0;

   if (twaiting != 1'b1) error = 1'b1;
  else if (treg_sel != 2'b11) error = 1'b1;
  else if (twb_sel != 2'b0) error = 1'b1;
  else if (tw_en != 1'b0) error = 1'b1;
  else if (ten_A != 1'b0) error = 1'b1;
  else if (ten_B != 1'b0) error = 1'b1;
  else if (ten_C != 1'b0) error = 1'b1;
  else if (ten_status != 1'b0) error = 1'b1;
  else if (tsel_A != 1'b0) error = 1'b1;
  else if (tsel_B != 1'b0) error = 1'b1;
  else error = 1'b0;

   #5;

//MVN 
   tALU_op = 2'b11;
   tstart = 1'b1;
   tclk = 1'b1; 
   #5;

   tclk = 1'b0;
   #5;

   tstart = 1'b0;
   //cycle 1
   tclk = 1'b1;
   tstart = 1'b0;
   #5;
 
   tclk = 1'b0;
   #5;

   //cycle 2
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 3
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 4
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 5 
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

  //cycle 6 waiting begin
   tclk = 1'b1;
   #5;

   tclk = 1'b0;

   if (twaiting != 1'b1) error = 1'b1;
  else if (treg_sel != 2'b11) error = 1'b1;
  else if (twb_sel != 2'b0) error = 1'b1;
  else if (tw_en != 1'b0) error = 1'b1;
  else if (ten_A != 1'b0) error = 1'b1;
  else if (ten_B != 1'b0) error = 1'b1;
  else if (ten_C != 1'b0) error = 1'b1;
  else if (ten_status != 1'b0) error = 1'b1;
  else if (tsel_A != 1'b0) error = 1'b1;
  else if (tsel_B != 1'b0) error = 1'b1;
  else error = 1'b0;

   #5;

//interupt with reset
   $display("Testing interupt reset");
   topcode = 3'b110;
   tALU_op = 2'b10;
   tclk = 1'b1;
   tstart = 1'b1; //start
   #5;
   
   tclk = 1'b0;
   #5; 

   //cycle 1
   tclk = 1'b1;
   tstart = 1'b0;
   #5;

   tclk = 1'b0;
   #5; 
   
   //cycle 2 assert reset
   trst_n = 1'b0;
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5; 

   //cycle 3
   trst_n = 1'b1;
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 4
   tclk = 1'b1;
   #5;

   tclk = 1'b0;
   #5;

   //cycle 5 
   tclk = 1'b1;
   #5;

   tclk = 1'b0;

   if (twaiting != 1'b1) error = 1'b1;
  else if (treg_sel != 2'b11) error = 1'b1;
  else if (twb_sel != 2'b0) error = 1'b1;
  else if (tw_en != 1'b0) error = 1'b1;
  else if (ten_A != 1'b0) error = 1'b1;
  else if (ten_B != 1'b0) error = 1'b1;
  else if (ten_C != 1'b0) error = 1'b1;
  else if (ten_status != 1'b0) error = 1'b1;
  else if (tsel_A != 1'b0) error = 1'b1;
  else if (tsel_B != 1'b0) error = 1'b1;
  else error = 1'b0;

   #5;

  $stop;

 end
endmodule: tb_controller
