module cpu(clk,reset,s,load,in,out,N,V,Z,w);
    input clk, reset, s, load;
    input [15:0] in;
    output reg [15:0] out;
    output reg N, V, Z, w;

    reg [15:0] mdata;
    reg [15:0] sximm8;
    reg [15:0] sximm5;
    reg [7:0] PC;
    reg [2:0] writenum, readnum, opcode;
    reg [1:0] ALUop, shift, vsel, op, nsel;
    reg write, clk, loada, loadb, loadc, loads, asel, bsel;

    reg [15:0] instructionout;
    minireg instructionreg(.in(in), .out(instructionout), .load(load), .clk(clk));

    FSM_head statemachine(.w(w), .clk(clk), .reset(reset), .s(s), .op(op), .ALUop(ALUop), .opcode(opcode), .asel(asel), .bsel(bsel), .loada(loada), .loadb(loadb), .loadc(loadc), .loads(loads), .write(write), .nsel(nsel), .vsel(vsel));

    instdec instructiondecoder(.instregout(instructionout), .nsel(nsel), .opcode(opcode), .op(op), .writenum(writenum), .readnum(readnum), .shift, .sximm8(sximm8), .sximm5(sximm5), .ALUop(ALUop));


    datapath DP ( .clk         (clk), // recall from Lab 4 that KEY0 is 1 when NOT pushed

                // register operand fetch stage
                .readnum     (readnum),
                .vsel        (vsel),
                .loada       (loada),
                .loadb       (loadb),

                // computation stage (sometimes called "execute")
                .shift       (shift),
                .asel        (asel),
                .bsel        (bsel),
                .ALUop       (ALUop),
                .loadc       (loadc),
                .loads       (loads),

                // set when "writing back" to register file
                .writenum    (writenum),
                .write       (write),  

                //other inputs
                .mdata(mdata),
                .sximm8(sximm8),
                .sximm5(sximm5),
                .PC(PC),

                // outputs 
                .Z_out       ({Z, N, V}),
                .datapath_out(out)
             );

    //instdec instructiondecoder
endmodule: cpu