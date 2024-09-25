module regfile(data_in,writenum,write,readnum,clk,data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write, clk;
    output reg [15:0] data_out;
    
    reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
   
    WriteData writetoreg(.clk(clk), .write(write), .writenum(writenum), .data_in(data_in), .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7));
    ReadData readreg(.readnum(readnum), .R0(R0), .R1(R1), .R2(R2), .R3(R3), .R4(R4), .R5(R5), .R6(R6), .R7(R7), .data_out(data_out));


endmodule: regfile

module WriteData(clk, write, writenum, data_in, R0, R1, R2, R3, R4, R5, R6, R7);
    input clk, write;
    input [2:0] writenum;
    input [15:0] data_in;
    output reg [15:0] R0, R1, R2, R3, R4, R5, R6, R7;

    always_ff @ (posedge clk) begin
        case({writenum, write})
            {3'b000, 1'b1}: R0 <= data_in;
            {3'b001, 1'b1}: R1 <= data_in;
            {3'b010, 1'b1}: R2 <= data_in;
            {3'b011, 1'b1}: R3 <= data_in;
            {3'b100, 1'b1}: R4 <= data_in;
            {3'b101, 1'b1}: R5 <= data_in;
            {3'b110, 1'b1}: R6 <= data_in;
            {3'b111, 1'b1}: R7 <= data_in;
            default: begin //nothing changes
                R0 <= R0;
                R1 <= R1;
                R2 <= R2;
                R3 <= R3;
                R4 <= R4;
                R5 <= R5;
                R6 <= R6;
                R7 <= R7;
            end
        endcase
    end

endmodule: WriteData

module ReadData(readnum, R0, R1, R2, R3, R4, R5, R6, R7, data_out);
    input [2:0] readnum;
    input [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    output reg [15:0] data_out;

    always @(*) begin
       case(readnum)

            3'b000: data_out <= R0;
            3'b001: data_out <= R1;
            3'b010: data_out <= R2;
            3'b011: data_out <= R3;
            3'b100: data_out <= R4;
            3'b101: data_out <= R5;
            3'b110: data_out <= R6;
            3'b111: data_out <= R7;
            default: data_out <= {16{1'b1}};
            // idk if we need to do casex for this

       endcase 

    end
endmodule: ReadData