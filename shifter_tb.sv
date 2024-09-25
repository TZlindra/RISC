module shifter_tb();
  // your implementation here

  reg [15:0] in;
  reg [1:0] shift;
  reg [15:0] sout;
  reg err;
  shifter DUT(.in, .shift, .sout);

  initial begin

    err = 1'b0;

    in=16'b1111000011001111;

    shift=2'b00;
    #10;

    if(sout===16'b1111000011001111)
      $display("no shift [PASSED]");

    else begin
      $display("no shift [FAILED]");
      err=1'b1;
    end

    shift=2'b01;
    #10;

    if(sout===16'b1110000110011110)
      $display("left shift [PASSED]");

    else begin
      $display("left shift [FAILED]");
      err=1'b1;
    end

    shift=2'b10;
    #10;

    if(sout===16'b0111100001100111)
      $display("logical right shift [PASSED]");

    else begin
      $display("logical right shift[FAILED]");
      err=1'b1;
    end

    shift=2'b11;
    #10;

    if(sout===16'b1111100001100111)
      $display("arithmetic right shift [PASSED]");

    else begin
      $display("arithmetic right shift [FAILED]");
      err=1'b1;
    end
  #460;
  $stop;
  end

endmodule: shifter_tb