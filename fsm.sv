`define waiting 3'd0
`define state1 3'd1
`define state2 3'd2
`define state3 3'd3
`define state4 3'd4

`define Rm 2'b00
`define Rd 2'b01
`define Rn 2'b10

module FSM_head(clk, s, reset, w, opcode, op, nsel, loada, loadb, asel, bsel, loadc, loads, write, ALUop, vsel);
    input s, reset, clk;
    input [2:0] opcode;
    input [1:0] op, ALUop;
    output reg asel, bsel, loada, loadb, loadc, loads, write, w;
    output reg [1:0] nsel, vsel;

    reg [2:0] state;
    
    FSM statechanges(.clk(clk), .reset(reset), .s(s), .opcode(opcode), .state(state), .ALUop(ALUop), .op(op));
    FSMout FSMoutput (.ALUop(ALUop), .opcode(opcode), .state(state), .op(op), .asel(asel), .bsel(bsel), .loada(loada), .loadb(loadb), .loadc(loadc), .loads(loads), .write(write), .nsel(nsel), .vsel(vsel));


    //FSMout

    always_comb begin 
        case(state) 
            `waiting: w = ((s==0) ? 1'b1 : 1'b0);
            default: w = 1'b0;
            
        endcase
    end

endmodule: FSM_head

module FSM(clk, reset, s, opcode, state, op, ALUop);

    input clk, reset, s;
    input [1:0] op, ALUop;
    input [2:0] opcode;
    output reg [2:0] state;
    
    initial begin
        state <= `waiting;

    end

    always @(posedge clk) begin
            
            if (reset) begin
                state <= `waiting;
            end   
            else if (s) begin
                if (opcode == 3'b110 && op == 2'b10) begin
                    case(state) 
                        `waiting: state <= `state1;
                        `state1: state <= `waiting;
                        default: state <= `waiting;
                    endcase
                end
                else if (opcode == 3'b101 || opcode == 3'b110) begin
                    case(state)
                        `waiting: state <= `state1;
                        `state1: state <= `state2;
                        `state2: state <= `state3;
                        `state3: state <= (ALUop == 2'b01 ? `waiting : `state4);
                        `state4: state <= `waiting;
                        default: state <= `waiting;


                    endcase
                end

            end
            else 
                state <= `waiting;


    end
endmodule: FSM



module FSMout(ALUop, state, opcode, op, asel, bsel, loada, loadb, loadc, loads, write, nsel, vsel);
//00-Rm
//01-Rd
//10-Rn
    input [2:0] opcode, state;
    input [1:0] op, ALUop;
    output reg asel, bsel, loada, loadb, loadc, loads, write;
    output reg [1:0] nsel, vsel;
  

    
    always @(state or opcode or op or ALUop) begin
        
        loada = 1'b0;
        loadb = 1'b0;
        loadc = 1'b0;
        loads = 1'b0;
        write = 1'b0;
        nsel = 2'bxx;
        vsel = 2'bxx;
        asel = 1'b0;
        bsel = 1'b0;  
         
        // MOV Rn, #im8
        if (opcode == 3'b110 && op == 2'b10) begin

            case(state) 
                // Writing into register Rn
                `state1: begin
                    nsel <= `Rn;
                    vsel <= 2'b10;
                    write <= 1'b1; 
                end
                // Write = 0
                default: begin
                    write <= 1'b0;
                    nsel <= 2'bxx;
                    vsel <= 2'bxx;
                    asel <= 1'bx;
                    bsel <= 1'bx;
                end
            endcase
        end
        // MOV Rd, Rm
        else if (opcode == 3'b110 && op == 2'b00) begin
            case(state)
                //selects Rm
                `state1: begin
                    nsel <= `Rm;
                    bsel <= 1'b0;
                    asel <= 1'b1;
                    
                
                end
                //loading Rm into b
                `state2: begin
                    nsel <= `Rm;
                    loadb <= 1'b1;
                    bsel <= 1'b0;
                    asel <= 1'b1;
                    
                end
                // Lets data pass through loadc
                `state3: begin
                    nsel <= `Rm;
                    loadc <= 1'b1;
                    bsel <= 1'b0;
                    asel <= 1'b1;
                    
                end
                // Passes through initial multiplexer and into new value
                `state4: begin
                    nsel <= `Rd;
                    vsel <= 2'b00;
                    write <= 1'b1;
                end
                default: begin
                    write <= 1'b0;
                    nsel <= 2'bxx;
                    vsel <= 2'b00;
                    asel <= 1'b0;
                    bsel <= 1'b1;
                end
            endcase
        end
        // ALU Instructions
        else if (opcode == 3'b101) begin
            case(state)
                // store Rn into A
                `state1: begin
                    nsel <= `Rn;
                    loada <= 1'b1;
                    asel <= 1'b0; 
                    write <= 1'b0; 
                end
                // store Rm into B
                `state2: begin
                    nsel <= `Rm;
                    loada <= 1'b0;
                    loadb <= 1'b1;
                    bsel <= 1'b0;
                // datapath_out = goes through ALU and shifter and C
                end
                `state3: begin
                    loadc <= 1'b1;
                    if (ALUop == 2'b01)
                        loads <= 1'b1;
                    else
                        loads <= 1'b0;

                end
                //writeback into Rd
                `state4: begin
                    nsel <= `Rd;
                    vsel <= 2'b00;
                    write <= 1'b1;

                end
                default: begin
                    write <= 1'b0;
                    nsel <= 2'bxx;
                    vsel <= 2'bxx;
                    asel <= 1'bx;
                    bsel <= 1'bx;

                end
            endcase
        end

    end
endmodule: FSMout