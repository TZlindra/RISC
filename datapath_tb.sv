module datapath_tb();

    reg err;
    reg [15:0] datapath_in;
    reg [2:0] writenum, readnum;
    reg write, clk, loada, loadb, loadc, loads, asel, bsel;

    reg [15:0] data_in, data_out, wireA, wireB, sout, Ain, Bin, out, datapath_out;
    reg Z_out, vsel;
    reg [1:0] ALUop, shift;



    datapath DUT(.clk       (clk),

                // register operand fetch stage
                .readnum    (readnum),
                .vsel       (vsel),
                .loada      (loada),
                .loadb      (loadb),

                // computation stage (sometimes called "execute")
                .shift      (shift),
                .asel       (asel),
                .bsel       (bsel),
                .ALUop      (ALUop),
                .loadc      (loadc),
                .loads      (loads),

                // set when "writing back" to register file
                .writenum   (writenum),
                .write      (write),  
                //.datapath_in(datapath_in),

                // outputs
                .Z_out      (Z_out),
                .datapath_out(datapath_out)
             );

    task enter; begin clk=1'b1; #5; clk = 1'b0; #5; end endtask;

    initial begin 

        // example given by the professor
        // 42 in R5 (loaded in A), 13 in R3 (loaded in B)
        // 42 + 13 = 55
        
        vsel = 1'b1;
        write = 1'b1;
        writenum = 3'd5;
        readnum = 3'b000;
        loada = 1'b0;
        loadb = 1'b0;
        ALUop = 2'b00;
        asel = 1'b0;
        bsel = 1'b0;
        shift = 2'b00;
        loadc = 1'b0;
        loads = 1'b0;
        write = 1'b1;

        err = 1'b0;

        clk = 0;
        #5;
        

        datapath_in = 16'h42;

        #5;
        
        
        enter; #5;


        datapath_in = 16'h13;
        writenum = 3'd7;
        #5;
        enter; #5;

        write = 1'b0;

        readnum = 3'd5;
        #5;
        loada = 1'b1;
        #5;
        
        enter; #5;

        readnum = 3'd7;
        #5;
        loada = 1'b0;
        #5;
        loadb = 1'b1;
        #5;
        enter; #5;
        
        loadb = 1'b0;

        loadc = 1'b1;
        loads = 1'b1;
        enter; #5;

        loadc = 1'b0;
        loads = 1'b0;

    

        if (datapath_out === 16'h55)
            $display("Display 55 [PASSED]");
        else begin
            $display("Display 55 [FAILED]");
            err = 1'b1;
        end


        // A stored into R4 (loaded in A), 4 stored into R6 (loaded in B) and shifted left
        // Should equal A-8 = 2

        vsel = 1'b1;
        write = 1'b1;
        writenum = 3'd4;
        readnum = 3'b000;
        loada = 1'b0;
        loadb = 1'b0;
        ALUop = 2'b01;
        asel = 1'b0;
        bsel = 1'b0;
        shift = 2'b01;
        loadc = 1'b0;
        loads = 1'b0;
        write = 1'b1;


        clk = 0;
        #5;
        

        datapath_in = 16'hA;

        #5;
        
        
        enter; #5;


        datapath_in = 16'h4;
        writenum = 3'd6;
        #5;
        enter; #5;

        write = 1'b0;

        readnum = 3'd4;
        #5;
        loada = 1'b1;
        #5;
        
        enter; #5;

        readnum = 3'd6;
        #5;
        loada = 1'b0;
        #5;
        loadb = 1'b1;
        #5;
        enter; #5;
        
        loadb = 1'b0;

        loadc = 1'b1;
        loads = 1'b1;
        enter; #5;

        loadc = 1'b0;
        loads = 1'b0;

    

        if (datapath_out === 16'h2)
            $display("Display 2 [PASSED]");
        else begin
            $display("Display 2 [FAILED]");
            err = 1'b1;
        end

        // 1 stored into R7 (loaded in A), 2 stored into R0 (loaded in B) and shifted right
        // Operation A&B Should equal 1

        vsel = 1'b1;
        write = 1'b1;
        writenum = 3'd7;
        readnum = 3'd7;
        loada = 1'b0;
        loadb = 1'b0;
        ALUop = 2'b10;
        asel = 1'b0;
        bsel = 1'b0;
        shift = 2'b10;
        loadc = 1'b0;
        loads = 1'b0;
        write = 1'b1;


        clk = 0;
        #5;
        

        datapath_in = 16'h1;

        #5;
        
        
        enter; #5;


        datapath_in = 16'h2;
        writenum = 3'd0;
        #5;
        enter; #5;

        write = 1'b0;

        readnum = 3'd7;
        #5;
        loada = 1'b1;
        #5;
        
        enter; #5;

        readnum = 3'd0;
        #5;
        loada = 1'b0;
        #5;
        loadb = 1'b1;
        #5;
        enter; #5;
        
        loadb = 1'b0;

        loadc = 1'b1;
        loads = 1'b1;
        enter; #5;

        loadc = 1'b0;
        loads = 1'b0;

    

        if (datapath_out === 16'h1)
            $display("Display 1 [PASSED]");
        else begin
            $display("Display 1 [FAILED]");
            err = 1'b1;
        end

        #155;

        $stop;

    end

endmodule: datapath_tb
