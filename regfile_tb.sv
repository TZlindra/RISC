module regfile_tb();
  // your implementation here

    reg err;
    reg [2:0] writenum, readnum;
    reg clk, write;
    reg [15:0] data_in, data_out;

    regfile DUT(.clk(clk), .write(write), .data_in(data_in), .writenum(writenum), .readnum(readnum), .data_out(data_out));

    task enter; begin clk=1'b1; #10; clk = 1'b0; #10; end endtask;

    initial begin

        err = 1'b0;

        // Read Empty R2

        write = 1'b0;
        writenum = 3'd0;
        readnum = 3'd2;
        /*
        #10;

        if (data_out == 16{1'bx})
            $display ("Regfile R2 Read Nothing [PASSED]");
        else begin
            $display("Regfile R2 Read Nothing [FAILED]");
            err = 1'b1;
        end
        #10;  
        */
        readnum = 3'bxxx;  
        
        // Write Regfiles

        write = 1'b1;

        data_in = 16'd10;
        writenum = 3'd0; // R0
        enter; #10;

        data_in = 16'd11;
        writenum = 3'd1; // R1
        enter; #10;

        data_in = 16'd12;
        writenum = 3'd2; // R2
        enter; #10;

        data_in = 16'd13;
        writenum = 3'd3; // R3
        enter; #10;

        data_in = 16'd14;
        writenum = 3'd4; // R4
        enter; #10;

        data_in = 16'd15;
        writenum = 3'd5; // R5
        enter; #10;

        data_in = 16'd16;
        writenum = 3'd6; // R6
        enter; #10;

        data_in = 16'd17;
        writenum = 3'd7; // R7
        enter; #10;

        write = 1'b0;
        data_in = 16'd18;
        writenum = 3'd0; // R0 = 18 BUT WRITE = 0
        enter; #10;   

        
        // Read Regfiles

        readnum = 3'd0; #10;


        if (data_out == 16'd10)
            $display("Regfile R0 Read + Write [PASSED]");
        else begin
            $display("Regfile R0 Read + Write [FAILED]");
            err = 1'b1;
        end

        #10; readnum = 3'd1; #10;

        if (data_out == 16'd11)
            $display("Regfile R1 Read + Write [PASSED]");
        else begin
            $display("Regfile R1 Read + Write [FAILED]");
            err = 1'b1;
        end
        #10; readnum = 3'd2; #10;

        if (data_out == 16'd12)
            $display("Regfile R2 Read + Write [PASSED]");
        else begin
            $display("Regfile R2 Read + Write [FAILED]");
            err = 1'b1;
        end

        #10; readnum = 3'd3; #10;

        if (data_out == 16'd13)
            $display("Regfile R3 Read + Write [PASSED]");
        else begin
            $display("Regfile R3 Read + Write [FAILED]");
            err = 1'b1;
        end
            
        #10; readnum = 3'd4; #10;

        if (data_out == 16'd14)
            $display("Regfile R4 Read + Write [PASSED]");
        else begin
            $display("Regfile R4 Read + Write [FAILED]");
            err = 1'b1;
        end

        #10; readnum = 3'd5; #10;

        if (data_out == 16'd15)
            $display("Regfile R5 Read + Write [PASSED]");
        else begin
            $display("Regfile R5 Read + Write [FAILED]");
            err = 1'b1;
        end
        #10; readnum = 3'd6; #10;

        if (data_out == 16'd16)
            $display("Regfile 6 Read + Write [PASSED]");
        else begin
            $display("Regfile R6 Read + Write [FAILED]");
            err = 1'b1;
        end
        #10; readnum = 3'd7; #10;

        if (data_out == 16'd17)
            $display("Regfile R7 Read + Write [PASSED]");
        else begin
            $display("Regfile R7 Read + Write [FAILED]");
            err = 1'b1;
        end

        #80;

        
    $stop;
    end

endmodule: regfile_tb