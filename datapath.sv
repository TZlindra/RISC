module datapath( clk         , // recall from Lab 4 that KEY0 is 1 when NOT pushed

                // register operand fetch stage
                readnum     ,
                vsel        ,
                loada       ,
                loadb       ,

                // computation stage (sometimes called "execute")
                shift       ,
                asel        ,
                bsel        ,
                ALUop       ,
                loadc       ,
                loads       ,

                // set when "writing back" to register file
                writenum    ,
                write       ,  

                //other inputs
                mdata,
                sximm5,
                sximm8,
                PC,

                // outputs
                Z_out       ,
                datapath_out
                
             );


            input [15:0] mdata, sximm8, sximm5;
            input [7:0] PC;
            input [2:0] writenum, readnum;
            input [1:0] ALUop, shift, vsel;
            input write, clk, loada, loadb, loadc, loads, asel, bsel;

            reg [15:0] data_in, data_out, wireA, wireB, sout, Ain, Bin, out;
            reg [2:0] Z;


            output reg [2:0] Z_out;
            output reg [15:0] datapath_out;

                                         
            Mux4 MuxInit(.select(vsel), .mdata(mdata), .sximm8(sximm8), .PC(PC), .C(datapath_out), .out(data_in));
            
            regfile REGFILE(.data_in(data_in), .writenum(writenum), .write(write), .readnum(readnum), .clk(clk), .data_out(data_out));
            minireg regA(.in(data_out), .out(wireA), .load(loada), .clk(clk));
            minireg regB(.in(data_out), .out(wireB), .load(loadb), .clk(clk));

            shifter mainShifter(.in(wireB), .shift(shift), .sout(sout));
              
            
            Mux2 MuxA(.select(asel), .input1({16{1'b0}}), .input0(wireA), .out(Ain));
            //Mux MuxB(.select(bsel), .input1({11{1'b0}, datapath_in[4:0]}), .input0(sout), .out(Bin));
            Mux2 MuxB(.select(bsel), .input1(sximm5), .input0(sout), .out(Bin));
            
            ALU ALUMain(.Ain(Ain), .Bin(Bin), .ALUop(ALUop), .out(out), .Z(Z));

            minireg regC(.in(out), .out(datapath_out), .load(loadc), .clk(clk));

            

            statusreg regZ(.in(Z), .out(Z_out), .load(loads), .clk(clk));



endmodule: datapath

module Mux4 (input [1:0] select, input [15:0] mdata, input [15:0] sximm8, input [7:0] PC, input [15:0] C, output reg [15:0] out);
    always@(*) begin
        case(select)
            2'b00: out <= C;
            2'b01: out <= {8'b0, PC};
            2'b10: out <= sximm8;
            2'b11: out <= mdata;

            default: out <= {16{1'bx}};
        endcase
    end

endmodule: Mux4


module Mux2 (input select, input [15:0] input1, input [15:0] input0, output reg [15:0] out);
    always@(*) begin
        case(select)
            1'b0: out <= input0;
            1'b1: out <= input1;
            default: out <= {16{1'b1}};
        endcase
    end

endmodule: Mux2

//Used in this file for register A, register B, register C
module minireg(input [15:0] in, output reg [15:0] out, input load, input clk);
    always_ff @(posedge clk) if (load) out <= in;

endmodule:minireg

//Used in status register
module statusreg(input [2:0] in, output reg [2:0] out, input load, input clk);
    always_ff @(posedge clk) if (load) out <= in;

endmodule:statusreg