module controller(input clk, input rst_n, input start,
                  input [2:0] opcode, input [1:0] ALU_op, input [1:0] shift_op,
                  input Z, input N, input V,
                  output waiting,
                  output [1:0] reg_sel, output [1:0] wb_sel, output w_en,
                  output en_A, output en_B, output en_C, output en_status,
                  output sel_A, output sel_B);

`define wait_state 	4'b0000
`define decode		4'b0001
`define immediate	4'b0010
`define load_A		4'b0011
`define load_B		4'b0100
`define ADD		4'b0101
`define CMP		4'b0110
`define AND		4'b0111
`define MVN		4'b1000
`define MOV		4'b1001
`define write_C 	4'b1010
		
  reg [3:0] state;
  reg [3:0] next_state;
  reg in_waiting;
  reg [1:0] in_reg_sel;
  reg [1:0] in_wb_sel;
  reg in_w_en;
  reg in_en_A;
  reg in_en_B;
  reg in_en_C;
  reg in_en_status;
  reg in_sel_A;
  reg in_sel_B;

  assign waiting = in_waiting;
  assign reg_sel = in_reg_sel;
  assign wb_sel = in_wb_sel;
  assign w_en = in_w_en;
  assign en_A = in_en_A;
  assign en_B = in_en_B;
  assign en_C = in_en_C;
  assign en_status = in_en_status;
  assign sel_A = in_sel_A;
  assign sel_B = in_sel_B;

  always @ (posedge clk) begin
    if(~rst_n) begin
	state = `wait_state;
      	next_state = `wait_state;
	in_waiting = 1'b1;
	in_reg_sel = 2'b11;
	in_wb_sel = 2'b00;
	in_w_en = 1'b0;
	in_en_A = 1'b0;
	in_en_B = 1'b0;
	in_en_C = 1'b0;
	in_en_status = 1'b0;
	in_sel_A = 1'b0;
	in_sel_B = 1'b0;
    end 
    else begin
      case(state)
	`wait_state: if (start) begin
		next_state = `decode;
		in_waiting = 1'b0; //turn off waiting
		in_reg_sel = 2'b10;
		in_wb_sel = 2'b11;
		in_w_en = 1'b0;
		in_en_A = 1'b0;
		in_en_B = 1'b0;
		in_en_C = 1'b0;
		in_en_status = 1'b0;
		in_sel_A = 1'b0;
		in_sel_B = 1'b0;
	        end 
		else begin
		next_state = `wait_state;
		in_waiting = 1'b1; //turn on waiting
		in_reg_sel = 2'b11;
		in_wb_sel = 2'b00;
		in_w_en = 1'b0;
		in_en_A = 1'b0;
		in_en_B = 1'b0;
		in_en_C = 1'b0;
		in_en_status = 1'b0;
		in_sel_A = 1'b0;
		in_sel_B = 1'b0;
	       end
	`decode: begin 
		  if ({opcode,ALU_op} == 5'b11010) begin // simple mov only Rn and im8
			next_state = `immediate;
		  end 
		  else if (({opcode,ALU_op} == 5'b11000) | ({opcode,ALU_op} == 5'b10111)) begin // mov shift or negative mov shift
			next_state = `load_B;
		  end 
		  else begin 
			next_state = `load_A; //add, cmp and and
		  end
		 end //end decode state
	`immediate: begin //enters only through simple move and turn on w_en
			in_reg_sel = 2'b10; //select Rn
			in_wb_sel = 2'b10; //select sximm8
			in_w_en = 1'b1; //enable write to Rn selected
			next_state = `wait_state; //go back to wait state
		    end
	`load_A: begin 	//enters only through complex
		 	in_reg_sel = 2'b10; //select Rn
			in_en_A = 1'b1; //enable A
			next_state = `load_B; //go to load_B
		 end //end load_A
	`load_B: begin //enters through load_A, mov shift and mov negative
			in_reg_sel = 2'b00; //select Rm
			in_en_A = 1'b0; //keep value A
			in_en_B = 1'b1; //Rm goes into B
			if ({opcode,ALU_op} == 5'b10100) next_state = `ADD;
			else if ({opcode,ALU_op} == 5'b10101) next_state = `CMP;
			else if ({opcode,ALU_op} == 5'b10110) next_state = `AND;
			else if ({opcode,ALU_op} == 5'b10111) next_state = `MVN;
			else next_state = `MOV;
		    end //end shifted_B
	`ADD: begin //enters from load_B
		in_en_B = 1'b0; //keep value B
		in_sel_A = 1'b0; //select A
		in_sel_B = 1'b0; //select B
		in_en_C = 1'b1; //open C
		next_state = `write_C;
	      end
	`CMP: begin //enters from load_B, only this state has en_status
		in_en_B = 1'b0; // keep value B
		in_sel_A = 1'b0; //select A
		in_sel_B = 1'b0; //select B
		in_en_C = 1'b1; //open C
		in_en_status = 1'b1; //turn on status
		next_state = `write_C;
	      end
	`AND: begin //enters from load_B
		in_en_B = 1'b0;
		in_sel_A = 1'b0; //select A
		in_sel_B = 1'b0; //select B
		in_en_C = 1'b1; //open C
		next_state = `write_C;
 	      end
	`MVN: begin //enters from load_B, negative shifted value B
		in_en_B = 1'b0;
		in_sel_A = 1'b1; //set value A to zero
		in_sel_B = 1'b0; //select value B
		in_en_C = 1'b1;
		next_state = `write_C;
	      end
	`MOV: begin //enters from load_B, shifted value B
		in_en_B = 1'b0;
		in_sel_A = 1'b1; //set value A to zero
		in_sel_B = 1'b0; //select value B
		in_en_C = 1'b1;
		next_state = `write_C;
   	      end
	`write_C: begin //last state and the only state when w_en is 1
			in_w_en = 1'b1; // turn on w_en
			in_reg_sel = 2'b01; // select the reg Rd
			in_wb_sel = 2'b00; // select the value output
			next_state = `wait_state; //go back to wait
		  end
	default: begin
		  state = `wait_state;
		  next_state = `wait_state;
		 end
      endcase
    end
   state <= next_state;
 end
endmodule: controller
