module ALU(Ain, Bin, ALUop, out, Z);
    input [15:0] Ain;
    input [15:0] Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output reg [2:0] Z;
    // fill out the rest

    // bit [2] = zero flag
    // bit [1] = negative flag
    // bit [0] = overflow flag


    always_comb begin
        Z[0] = 1'b0;
        case(ALUop)
            2'b00: begin
                out = Ain+Bin;
                //overflow
                if ({1'b0, Ain} + {1'b0, Bin} != {1'b0,out})
                    Z[0] = 1'b1;
            end
            2'b01: begin
                out=Ain-Bin;
                if(Bin[15]==0 && Ain[15]==1 && out[15] == 0)
                    Z[0]=1'b1;
                else if(Bin[15]==1 && Ain[15]==0 && out[15] == 1)
                    Z[0]=1'b1;
            end
            2'b10: begin
                out=Ain&Bin;
                //Z[0] = 1'b0;
            end
            2'b11: begin
                out=~Bin;
                //Z[0] = 1'b0;
            end
            default: begin
                out=0;
                //Z[0] = 1'b0;
            end

        endcase
    end
  
    //check if out is zero
    assign Z[2] = (out == 16'd0) ? 1'b1 : 1'b0;
    //check if out is negative
    assign Z[1] = (out[15] == 1'b1) ? 1'b1 : 1'b0;
endmodule


