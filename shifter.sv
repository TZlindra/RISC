module shifter(in, shift, sout);
    input [15:0] in;
    input [1:0] shift;
    output reg [15:0] sout;
    // fill out the rest

    always_comb begin
        case(shift)
            2'b00:
            sout=in;
            2'b01:
            sout=in<<1;
            2'b10:
            sout=in>>1;
            2'b11:
            sout= $signed(in)>>>1;
        endcase
  end
    
endmodule
