`define waiting 3'd0
`define state1 3'd1
`define state2 3'd2
`define state3 3'd3
`define state4 3'd4

`define Rm 2'b00
`define Rd 2'b01
`define Rn 2'b10


module FSM_head_tb();
    reg s, reset, clk;
    reg [2:0] opcode;
    reg [1:0] op, ALUop;
    reg asel, bsel, loada, loadb, loadc, loads, write, w;
    reg [1:0] nsel, vsel;

    FSM_head DUT(.w(w), .clk(clk), .reset(reset), .s(s), .op(op), .ALUop(ALUop), .opcode(opcode), .asel(asel), .bsel(bsel), .loada(loada), .loadb(loadb), .loadc(loadc), .loads(loads), .write(write), .nsel(nsel), .vsel(vsel));

    task enter; begin clk=1'b1; #5; clk = 1'b0; #5; end endtask;
    task resettask; reset=1'b1; #5; clk=1'b1; #5; clk=1'b0; #5; reset=1'b0; endtask

    initial begin

      #5;
      //resettask;
      #5;
      s = 1'b0;

      #5;
      
      if (w == 1'b1)
        $display("w [PASSED]");
      else 
        $display("w [FAILED]");

        #5;

      ALUop = 2'b00;
      opcode = 3'b110;
      op = 2'b10;
      s = 1'b1;


      #5;

      enter;

      #5;

      if (vsel == 2'b10 && nsel == `Rn && write == 1'b1)
        $display("MOV Rn, #imm8 [PASSED]");
      else
        $display("MOV Rn, #imm8 [FAILED]");

      #5;

      // MOV Rd, Rn test

      opcode = 3'b110;
      op = 2'b00;

      resettask; enter;

      #5;
/*
      if (nsel == `Rm && bsel == 1'b0 && write == 1'b0)
        $display("MOV Rd, Rm state 1 [PASSED]");
      else 
        $display("MOV Rd, Rm state 1 [FAILED]");
*/
      #5;

      enter;

      #5;

      if (loadb == 1'b1 && bsel == 1'b0 && asel == 1'b1)
        $display("MOV Rd, Rm state 2 [PASSED]");
      else 
        $display("MOV Rd, Rm state 2 [FAILED]");

      #5;

      enter;

      #5;

      if (loadc == 1'b1)
        $display("MOV Rd, Rm state 3 [PASSED]");
      else 
        $display("MOV Rd, Rm state 3 [FAILED]");

      #5;

     enter;

     #5;

      if (nsel == `Rd && vsel == 2'b00)
        $display("MOV Rd, Rm state 4 [PASSED]");
      else 
        $display("MOV Rd, Rm state 4 [FAILED]");

      #5;


      // Other Instruction Tests

      opcode = 3'b101;

      resettask; enter;

      #5;

      if (nsel == `Rn && loada == 1'b1 && asel == 1'b0)
        $display("Other Instructions state 1 [PASSED]");
      else 
        $display("Other Instructions state 1 [FAILED]");

      #5;

      enter;

      #5;

      if (nsel == `Rm && loada == 1'b0 && loadb == 1'b1 && bsel == 1'b0)
        $display("Other Instructions state 2 [PASSED]");
      else 
        $display("Other Instructions state 2 [FAILED]");

      #5;

      enter;

      #5;

      if (loadc == 1'b1 && loads == 1'b1)
        $display("Other Instructions state 3 [PASSED]");
      else 
        $display("Other Instructions state 3 [FAILED]");

      #5;

      enter;

      #5;

      if (nsel == `Rd && vsel == 2'b00 && write == 1'b1)
        $display("Other Instructions state 4 [PASSED]");
      else 
        $display("Other Instructions state 4 [FAILED]");

      #5;


      $stop;
    end




endmodule


module FSM_tb();

    reg clk, reset, s;
    reg [1:0] op, ALUop;
    reg [2:0] opcode;
    reg [2:0] state;
  
    FSM DUT(.clk(clk), .reset(reset), .s(s), .op(op), .ALUop(ALUop), .opcode(opcode), .state(state));

    task enter; begin clk=1'b1; #5; clk = 1'b0; #5; end endtask;
    task resettask; reset=1'b1; #5; clk=1'b1; #5; clk=1'b0; #5; reset=1'b0; endtask


    initial begin
        ALUop = 2'b00;
        opcode = 3'b110;
        op = 2'b10;
        s = 1'b0;

        // s = 0

        enter;

        if (state == `waiting)
            $display("s = 0 [PASSED]");
        else 
            $display("s = 0 [FAILED]");

        s = 1'b1;

        enter;

        // MOV Rd, #number

        if (state == `state1)
            $display("Regular MOV to state1 [PASSED]");
        else 
            $display("Regular MOV to state1 [FAILED]");
        
        enter;

        if (state == `waiting)
            $display("Regular MOV back to waiting [PASSED]");
        else
            $display("Regular MOV back to waiting [FAILED]");

        
        // Any other instruction except CMP

        opcode = 3'b101;

        resettask; enter;

        if (state == `state1)
            $display("Instruction to state1 [PASSED]");
        else 
            $display("Instruction to state1 [FAILED]");
        
        enter;

        if (state == `state2)
            $display("Instruction to state2 [PASSED]");
        else
            $display("Instruction to state2 [FAILED]");

        enter;

        if (state == `state3)
            $display("Instruction to state3 [PASSED]");
        else
            $display("Instruction to state3 [FAILED]");

        enter;

        if (state == `state4)
            $display("Instruction to state4 [PASSED]");
        else
            $display("Instruction to state4 [FAILED]");
        
        enter;

        if (state == `waiting)
            $display("Instruction to waiting [PASSED]");
        else
            $display("Instruction to waiting [FAILED]");

        resettask;
        // CMP 
        ALUop = 2'b01;

        enter;

        if (state == `state1)
            $display("ALUop = 01 to state1 [PASSED]");
        else 
            $display("ALUop = 01 to state1 [FAILED]");
        
        enter;

        if (state == `state2)
            $display("ALUop = 01 to state2 [PASSED]");
        else
            $display("ALUop = 01 to state2 [FAILED]");

        enter;

        if (state == `state3)
            $display("ALUop = 01 to state3 [PASSED]");
        else
            $display("ALUop = 01 to state3 [FAILED]");

        enter;

        if (state == `waiting)
            $display("ALUop = 01 to waiting [PASSED]");
        else
            $display("ALUop = 01 to waiting [FAILED]");

        // reset test
        opcode = 3'b110;

        enter; resettask;

        if (state == `waiting)
            $display("Reset Test [PASSED]");
        else
            $display("Reset Test [FAILED]");



        
        $stop;
     end


endmodule

module FSMout_tb();
  // your implementation here

    reg [2:0] opcode, state;
    reg [1:0] op;
    reg asel, bsel, loada, loadb, loadc, loads, write;
    reg [1:0] nsel, vsel;


  FSMout DUT (.opcode(opcode), .state(state), .op(op), .asel(asel), .bsel(bsel), .loada(loada), .loadb(loadb), .loadc(loadc), .loads(loads), .write(write), .nsel(nsel), .vsel(vsel));


  initial begin
    // MOV Rn, #imm8 test
    opcode = 3'b110;
    op = 2'b10;

    #5;

    state = `state1;

    #5;

    if (vsel == 2'b10 && nsel == `Rn && write == 1'b1)
      $display("MOV Rn, #imm8 [PASSED]");
    else
      $display("MOV Rn, #imm8 [FAILED]");

    #5;

    // MOV Rd, Rn test

    opcode = 3'b110;
    op = 2'b00;

    state = `waiting;

    #5;
    state = `state1;

    #5;

    if (nsel == `Rm && vsel == 2'b10 && write == 1'b1)
      $display("MOV Rd, Rm state 1 [PASSED]");
    else 
      $display("MOV Rd, Rm state 1 [FAILED]");

    #5;

    state = `state2;

    #5;

    if (loadb == 1'b1 && bsel == 1'b0 && asel == 1'b1)
      $display("MOV Rd, Rm state 2 [PASSED]");
    else 
      $display("MOV Rd, Rm state 2 [FAILED]");

    #5;

    state = `state3;

    #5;

    if (loadc == 1'b1)
      $display("MOV Rd, Rm state 3 [PASSED]");
    else 
      $display("MOV Rd, Rm state 3 [FAILED]");

    #5;

    state = `state4;

    #5;

    if (nsel == `Rd && vsel == 2'b00)
      $display("MOV Rd, Rm state 4 [PASSED]");
    else 
      $display("MOV Rd, Rm state 4 [FAILED]");

    #5;


    // Other Instruction Tests

    opcode = 3'b101;

    state = `waiting;

    #5;
    state = `state1;

    #5;

    if (nsel == `Rn && loada == 1'b1 && asel == 1'b0)
      $display("Other Instructions state 1 [PASSED]");
    else 
      $display("Other Instructions state 1 [FAILED]");

    #5;

    state = `state2;

    #5;

    if (nsel == `Rm && loada == 1'b0 && loadb == 1'b1 && bsel == 1'b0)
      $display("Other Instructions state 2 [PASSED]");
    else 
      $display("Other Instructions state 2 [FAILED]");

    #5;

    state = `state3;

    #5;

    if (loadc == 1'b1 && loads == 1'b1)
      $display("Other Instructions state 3 [PASSED]");
    else 
      $display("Other Instructions state 3 [FAILED]");

    #5;

    state = `state4;

    #5;

    if (nsel == `Rd && vsel == 2'b00 && write == 1'b1)
      $display("Other Instructions state 4 [PASSED]");
    else 
      $display("Other Instructions state 4 [FAILED]");

    #5;


    
    $stop;
  end


endmodule