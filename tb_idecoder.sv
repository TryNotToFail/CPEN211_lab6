module tb_idecoder(output err);
  
  reg [15:0] tir;
  reg [1:0] treg_sel;
  reg [2:0] topcode;
  reg [1:0] tALU_op;
  reg [1:0] tshift_op;
  reg [15:0] tsximm5;
  reg [15:0] tsximm8;
  reg [2:0] tr_addr;
  reg [2:0] tw_addr;

  reg error;

  assign err = error;

  idecoder DUT (
		.ir(tir),
		.reg_sel(treg_sel),
		.opcode(topcode),
		.ALU_op(tALU_op),
		.shift_op(tshift_op),
		.sximm5(tsximm5),
		.sximm8(tsximm8),
		.r_addr(tr_addr),
		.w_addr(tw_addr)
		);
  initial begin
  //random instruction
  tir = 16'b1101100100110001;
  error = 1'b0;
  $display ("Ir is %b", tir);
  //select Rn
  treg_sel = 2'b10;
  $display("reg sel is %b", treg_sel);
  
  //wait 
  #5; 

  //Check
  $display ("opcode is %b, we expected is %b", topcode, tir[15:13]);
  $display ("ALU_op is %b, we expected is %b", tALU_op, tir[12:11]);
  $display ("sximm5 is %b, we expected is %b", tsximm5, (16'b1111111111110001));
  $display ("sximm8 is %b, we expected is %b", tsximm8, (16'b0000000000110001));
  $display ("shift_op is %b, we expected is %b", tshift_op, tir[4:3]);
  $display ("r_addr is %b, we expected is %b", tr_addr, tir[10:8]);
  $display ("w_addr is %b, we expected is %b", tw_addr, tir[10:8]);
  
  if (topcode != tir[15:13]) error = 1'b1;
  else if (tALU_op != tir[12:11]) error = 1'b1;
  else if (tsximm5 != 16'b1111111111110001) error = 1'b1;
  else if (tsximm8 != 16'b0000000000110001) error = 1'b1;
  else if (tshift_op != tir[4:3]) error = 1'b1;
  else if (tr_addr != tir[10:8]) error =  1'b1;
  else if (tw_addr != tir[10:8]) error = 1'b1;
  else error = 1'b0;
  
  //select Rd
  treg_sel = 2'b01;
  $display("reg sel is %b", treg_sel);
  
  #5;
  $display ("r_addr is %b, we expected is %b", tr_addr, tir[7:5]);
  $display ("w_addr is %b, we expected is %b", tw_addr, tir[7:5]);
  if (tr_addr != 3'b001) error =  1'b1;
  else if (tw_addr != 3'b001) error = 1'b1;
  else error = 1'b0;

  //select Rm
  treg_sel = 2'b00;
  $display("reg sel is %b", treg_sel);
  
  #5;
  $display ("r_addr is %b, we expected is %b", tr_addr, tir[2:0]);
  $display ("w_addr is %b, we expected is %b", tw_addr, tir[2:0]);
  if (tr_addr != 3'b001) error =  1'b1;
  else if (tw_addr != 3'b001) error = 1'b1;
  else error = 1'b0;
  
  //changin the number 
  tir = 16'b1011010001011011;
  $display("Ir is %b", (16'b1011010001011011));

  //maintain the previous value
  treg_sel = 2'b11;
  $display("reg sel is %b", treg_sel);
  $display("The r_addr and w_addr should maintain");

  #5;
  $display ("r_addr is %b, we expected is %b", tr_addr, (3'b001));
  $display ("w_addr is %b, we expected is %b", tw_addr, (3'b001));
  if (tr_addr != 3'b001) error =  1'b1;
  else if (tw_addr != 3'b001) error = 1'b1;
  else error = 1'b0;

  //select from Rn
  treg_sel = 2'b10;
  $display("reg sel is %b", treg_sel);

  #5;

  //Check
  $display ("opcode is %b, we expected is %b", topcode, tir[15:13]);
  $display ("ALU_op is %b, we expected is %b", tALU_op, tir[12:11]);
  $display ("sximm5 is %b, we expected is %b", tsximm5, (16'b1111111111111011));
  $display ("sximm8 is %b, we expected is %b", tsximm8, (16'b0000000001011011));
  $display ("shift_op is %b, we expected is %b", tshift_op, tir[12:11]);
  $display ("r_addr is %b, we expected is %b", tr_addr, tir[10:8]);
  $display ("w_addr is %b, we expected is %b", tw_addr, tir[10:8]);

  if (topcode != tir[15:13]) error = 1'b1;
  else if (tALU_op != tir[12:11]) error = 1'b1;
  else if (tsximm5 != 16'b1111111111111011) error = 1'b1;
  else if (tsximm8 != 16'b0000000001011011) error = 1'b1;
  else if (tshift_op != tir[4:3]) error = 1'b1;
  else if (tr_addr != tir[10:8]) error =  1'b1;
  else if (tw_addr != tir[10:8]) error = 1'b1;
  else error = 1'b0;

  //select from Rd
  treg_sel = 2'b01;
  $display("reg sel is %b", treg_sel);
  $display("the value ir is %b", tir[7:5]);
  $display("the value r_addr is %b", tr_addr);
 
  #5;
  $display ("r_addr is %b, we expected is %b", tr_addr, 3'b010);
  $display ("w_addr is %b, we expected is %b", tw_addr, 3'b010);
  #1;
  if (tr_addr != tir[7:5]) error = 1'b1;
  else if (tw_addr != tir[7:5]) error = 1'b1;
  else error = 1'b0;

  //select from Rm
  treg_sel = 2'b00;
  $display("reg sel is %b", treg_sel);

  #5;
  $display ("r_addr is %b, we expected is %b", tr_addr, tir[2:0]);
  $display ("w_addr is %b, we expected is %b", tw_addr, tir[2:0]);

  if (tr_addr != tir[2:0]) error =  1'b1;
  else if (tw_addr != tir[2:0]) error = 1'b1;
  else error = 1'b0;

  $stop; 

  end
endmodule: tb_idecoder
