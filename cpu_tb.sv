module cpu_tb();
    reg clk, reset, s, load;
    reg [15:0] in;
    reg [15:0] out;
    reg N, V, Z, w;

    cpu DUT(.clk(clk),.reset(reset),.s(s),.load(load),.in(in),.out(out),.N(N),.V(V),.Z(Z),.w(w));
    

    task enter; begin clk=1'b1; #2; clk = 1'b0; #2; end endtask;
    task resettask; reset=1'b1; #2; clk=1'b1; #2; clk=1'b0; #2; reset=1'b0; endtask

    initial begin

        #2;
        // MOV R0, #3
        in = 16'b110_10_000_00000011;
        load = 1'b1;
        s = 1'b1;
        clk = 1'b0;

        #2;

        enter; enter; enter; #2

        if (cpu_tb.DUT.DP.REGFILE.R0 == 16'd3)
            $display("MOV R0, #3 [PASSED]");
        else
            $display("MOV R0, #3 [FAILED]");

        // MOV R1, #4
        in = 16'b110_10_001_00000100;
        
        resettask; #2;
        enter; enter; #2;

        if (cpu_tb.DUT.DP.REGFILE.R1 == 16'd4)
            $display("MOV R1, #4 [PASSED]");
        else
            $display("MOV R1, #4 [FAILED]");

        resettask; #2;

        // MOV R3, R1

        in = 16'b110_00_000_011_00_001;

        enter; enter; enter; enter; enter; #2;

        if (cpu_tb.DUT.DP.REGFILE.R3 == 16'd4)
            $display("MOV R2, R1 [PASSED]");
        else
            $display("MOV R2, R1 [FAILED]");

        resettask; #2;

        // ADD R4, R0, R1

        in = 16'b101_00_000_100_00_001;

        enter; enter; enter; enter; enter; #2;

        if (out == 16'd7 && cpu_tb.DUT.DP.REGFILE.R4 == 16'd7)
            $display("ADD R4, R0, R1 [PASSED]");
        else
            $display("ADD R4, R0, R1 [FAILED]");

        resettask; #2;

        // CMP R0, R1 (#3, #4)

        in = 16'b101_01_000_000_00_001;

        enter; enter; enter; enter; #2;

        if (Z == 1'b0 && N == 1'b1 && V == 1'b0 && out == 16'b1111_1111_1111_1111)
            $display("CMP R0, R1 [PASSED]");
        else
            $display("CMP R0, R1 [FAILED]");

        resettask; #2;

        // AND R5, R0, R0

        in = 16'b101_10_000_101_00_000;

        enter; enter; enter; enter; enter; #2;

        if (out == 16'd3 && cpu_tb.DUT.DP.REGFILE.R5 == 16'd3)
            $display("ADD R5, R0, R0 [PASSED]");
        else 
            $display("ADD R5, R0, R0 [FAILED]");
        
        resettask; #2;

        // MVN R6, R0

        in = 16'b101_11_000_110_00_000;

        enter; enter; enter; enter; enter; #2;

        if (out == 16'b1111111111111100 && cpu_tb.DUT.DP.REGFILE.R6 == 16'b1111111111111100)
            $display("MVN R6, R0 [PASSED]");
        else 
            $display("MVN R6, R0 [FAILED]");





        #100;

        $stop;

    end
endmodule
