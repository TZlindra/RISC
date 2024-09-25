module ALU_tb();
  // your implementation here

  reg [15:0] Ain;
  reg [15:0] Bin;
  reg [1:0] ALUop;
  reg [15:0] out;
  reg [2:0] Z;
  reg err;
  
  ALU DUT(.Ain, .Bin, .ALUop, .out, .Z);


  initial begin

    err = 1'b0;


    Ain = 16'b1111111111111111;
    Bin = 16'b0000000000000001;

    ALUop = 2'b00;
    #10;

    if(out==16'd0 && Z == 3'b101)
      $display("Case 1 PASSED");
    else begin 
      $display("Case 1 FAILED");
      err = 1'b1;
    end

    Ain = 16'b0111111111111111;
    Bin = 16'b0000000000000001;

    #10;

    if(out==16'b1000000000000000 && Z == 3'b010)
      $display("Case 2 PASSED");
    else begin 
      $display("Case 2 FAILED");
      err = 1'b1;
    end

    Ain = 16'b0000000000000011;
    Bin = 16'b0000000000000100;

    #10;

    if(out==16'd7 && Z == 3'b000)
      $display("Case 3 PASSED");
    else begin 
      $display("Case 3 FAILED");
      err = 1'b1;
    end

    ALUop = 2'b01;

    #10;

    if(out==16'b1111111111111111 && Z == 3'b010)
      $display("Case 4 PASSED");
    else begin 
      $display("Case 4 FAILED");
      err = 1'b1;
    end

  $stop;
  end


endmodule: ALU_tb