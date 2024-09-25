module instdec_tb();

    reg [15:0] instregout;
    reg [1:0] nsel;
    reg [2:0] opcode;
    reg [1:0] op;
    reg [2:0] writenum;
    reg [2:0] readnum;
    reg [1:0] shift;
    reg [15:0] sximm8;
    reg [15:0] sximm5;
    reg [1:0] ALUop;

    instdec DUT(
                .instregout(instregout), 
                .nsel(nsel), 
                .opcode(opcode), 
                .op(op), 
                .writenum(writenum), 
                .readnum(readnum), 
                .shift(shift), 
                .sximm8(sximm8), 
                .sximm5(sximm5), 
                .ALUop(ALUop));

    initial begin

         $display("MOVE INSTRUCTIONS");

        //MOV Rn,#<im8>
        instregout=16'b110_10_000_11101111;
        nsel=2'b10;
        #10;
        $display("mov1 opcode %s", (opcode == 3'b110) ? "[PASSED]" : "[FAILED]");
        $display("mov1 op %s", (op == 3'b10) ? "[PASSED]" : "[FAILED]");
        $display("mov1 writenum %s", (writenum == 3'b000) ? "[PASSED]" : "[FAILED]");
        $display("mov1 readnum %s", (readnum == 3'b000) ? "[PASSED]" : "[FAILED]");
        $display("mov1 shift %s", (shift == 3'b01) ? "[PASSED]" : "[FAILED]");
        $display("mov1 sximm8 %s", (sximm8 == 16'b1111111111101111) ? "[PASSED]" : "[FAILED]");
        $display("mov1 sximm5 %s", (sximm5 == 16'b0000000000001111) ? "[PASSED]" : "[FAILED]");
        $display("mov1 ALUop %s", (ALUop == 3'b10) ? "[PASSED]" : "[FAILED]");

        //MOV Rd,Rm{,<sh_op>}
        instregout=16'b110_00_000_001_10_010;
        nsel=2'b01;
        #10;
        $display("mov1 opcode %s", (opcode == 3'b110) ? "[PASSED]" : "[FAILED]");
        $display("mov1 op %s", (op == 3'b00) ? "[PASSED]" : "[FAILED]");
        $display("mov1 writenum %s", (writenum == 3'b001) ? "[PASSED]" : "[FAILED]");
        $display("mov1 readnum %s", (readnum == 3'b001) ? "[PASSED]" : "[FAILED]");
        $display("mov1 shift %s", (shift == 3'b10) ? "[PASSED]" : "[FAILED]");
        $display("mov1 sximm8 %s", (sximm8 == 16'b0000000000110010) ? "[PASSED]" : "[FAILED]");
        $display("mov1 sximm5 %s", (sximm5 == 16'b1111111111110010) ? "[PASSED]" : "[FAILED]");
        $display("mov1 ALUop %s", (ALUop == 3'b00) ? "[PASSED]" : "[FAILED]");

        $display("ALU INSTRUCTIONS");
        


        $stop();
    end

endmodule: instdec_tb