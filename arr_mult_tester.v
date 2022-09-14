module arr_mult_tester (InA, InB, Reset, Out);

parameter INPUT_BIT_SIZE = 32;
parameter OUTPUT_BIT_SIZE = (2*INPUT_BIT_SIZE);
parameter ROW_SIZE = INPUT_BIT_SIZE-1;

// Entradas y salidas del modulo
output reg [INPUT_BIT_SIZE-1:0]          InA;
output reg [INPUT_BIT_SIZE-1:0]          InB;
output     reg                           Reset;
input wire [OUTPUT_BIT_SIZE-1:0]    Out;


parameter CLK_CYCLE = 10;   // Duracion de un ciclo de reloj

initial begin
    Reset = 1'b1;
    
    #CLK_CYCLE;     // Se da un ciclo para cargar el valor en Q
    InA = 'h00001111;
    InB = 'h00000111;
    #CLK_CYCLE;     // Se da un ciclo para cargar el valor en Q
    InA = 'h01001111;
    InB = 'h10000111;
    #CLK_CYCLE;     // Se da un ciclo para cargar el valor en Q
    InA = 'h11001111;
    InB = 'h10000011;

    
    
    
    /*InA = 4'b1111;
    InB = 4'b1111;
    #CLK_CYCLE;     // Se da un ciclo para cargar el valor en Q
    InA = 4'b0011;
    InB = 4'b1010;
    #CLK_CYCLE;     // Se da un ciclo para cargar el valor en Q
    InA = 4'b0010;
    InB = 4'b1111;
    #CLK_CYCLE;     // Se da un ciclo para cargar el valor en Q
    InA = 4'b0010;
    InB = 4'b0011;
    #CLK_CYCLE;     // Se da un ciclo para cargar el valor en Q
    InA = 4'b0110;
    InB = 4'b0100;
    #CLK_CYCLE;     // Se da un ciclo para cargar el valor en Q
    InA = 4'b0110;
    InB = 4'b1000;
    #CLK_CYCLE;     // Se da un ciclo para cargar el valor en Q
    InA = 4'b0110;
    InB = 4'b1111;
    */
    
end
endmodule


`include "/home/yenner/Documents/IE0424/Lab2/arr_multiplier_4b_param.v"


// ---------- INICIO MODULO TESTBENCH ----------



module arr_mult_testbench;  // Se definen los cables del testbench

parameter INPUT_BIT_SIZE = 32;
parameter OUTPUT_BIT_SIZE = (2*INPUT_BIT_SIZE);
parameter ROW_SIZE = INPUT_BIT_SIZE-1;

wire   [INPUT_BIT_SIZE-1:0]       InA;
wire  [INPUT_BIT_SIZE-1:0]        InB;
wire          Reset;
wire [OUTPUT_BIT_SIZE-1:0]          Out;

// Instancia del registro desplazable y sus conexiones correspondientes
arr_multiplier_4b dut (.InA(InA), .InB(InB), .Reset(Reset), .Out(Out));

// Instancia del probador y sus conexiones correspondientes
arr_mult_tester tester (.InA(InA), .InB(InB), .Reset(Reset), .Out(Out));

// Salida de resultados para gtkwave
initial begin
    $dumpfile ("Sim_arr_mult_4b.vcd");
    $dumpvars(-1, dut);
end
endmodule
// ---------- FIN MODULO TESTBENCH ----------