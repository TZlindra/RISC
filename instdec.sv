`define Rm 2'b00
`define Rd 2'b01
`define Rn 2'b10

module instdec(input [15:0] instregout,
                input [1:0] nsel, 
                output reg [2:0] opcode, 
                output reg [1:0] op, 
                output reg [2:0] writenum, 
                output reg [2:0] readnum, 
                output reg [1:0] shift, 
                output reg [15:0] sximm8, 
                output reg [15:0] sximm5,
                output reg [1:0] ALUop);

    reg [2:0] Rm;
    reg [2:0] Rd;
    reg [2:0] Rn;
    reg [4:0] imm5;
    reg [7:0] imm8;
    

    assign opcode = instregout[15:13];
    assign op = instregout[12:11];
    assign ALUop = instregout[12:11];
    assign Rm = instregout[2:0];
    assign Rd = instregout[7:5];
    assign Rn = instregout[10:8];
    assign shift = instregout[4:3];
    assign imm5 = instregout[4:0];
    assign imm8 = instregout[7:0];
    
    assign sximm5 = (imm5[4] == 0) ? {11'd0, imm5} : {11'b11111111111, imm5}; 
    assign sximm8 = (imm8[7] == 0) ? {8'd0, imm8} : {8'b11111111, imm8};

    

    always @(*) begin
        case(nsel)
            2'b00: begin
                writenum = Rm;
                readnum = Rm;
            end
            2'b01: begin
                writenum = Rd;
                readnum = Rd;
            end
            2'b10: begin
                writenum = Rn;
                readnum = Rn;
            end
            default: begin
                writenum = Rd;
                readnum = Rd;
            end
            
        endcase
    end

endmodule: instdec

