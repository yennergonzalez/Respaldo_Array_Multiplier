module full_adder (
    input A, // Sumando 1
    input B, // Sumando 2
    input reset, // Señal de reset
    input Cin, // Acarreo de entrada
    output Sum, // Resultado de la suma
    output Cout // Acarreo de salida
);
    wire L, K;

    assign L = A & B;
    assign K = A ^ B;

    assign Sum = (K ^ Cin) & reset;
    assign Cout = (L | (K & Cin)) & reset;

endmodule


module arr_multiplier_4b (InA, InB, Reset, Out);

parameter INPUT_BIT_SIZE = 32;
parameter OUTPUT_BIT_SIZE = (2*INPUT_BIT_SIZE);
parameter ROW_SIZE = INPUT_BIT_SIZE-1;

// Entradas y salidas del modulo
input [INPUT_BIT_SIZE-1:0]          InA;
input [INPUT_BIT_SIZE-1:0]          InB;
input                Reset;
output [OUTPUT_BIT_SIZE-1:0]         Out;


// Senales internas
wire [INPUT_BIT_SIZE:0] C [INPUT_BIT_SIZE-2:0];            // Carry de cada sumador
wire [INPUT_BIT_SIZE-1:0] Adder_Result [INPUT_BIT_SIZE-1:0];    // Resultado de cada sumador
wire zero;                                              // Senal conectada a cero permanentemente

assign zero = 1'b0;

genvar row, col;
generate
    for (row=0; row<ROW_SIZE; row=row+1) 
    begin:ROW
        if (row == 0) 
        begin
            for (col=0; col<INPUT_BIT_SIZE; col=col+1)
            begin:COL
                if (col == 0)   // Columna 0, Cin=0
                begin
                    full_adder adder (.A(InA[col+1] & InB[row]), .B(InA[col] & InB[row+1]), .Cin(zero), .Cout(C[row][col+1]), .Sum(Adder_Result[row][col]), .reset(Reset));
                    assign Out[row+1] = Adder_Result[row][col];
                end
                else if (col > 0 && col < INPUT_BIT_SIZE-1)   // Columnas 1 y 2
                begin
                    full_adder adder (.A(InA[col+1] & InB[row]), .B(InA[col] & InB[row+1]), .Cin(C[row][col]), .Cout(C[row][col+1]), .Sum(Adder_Result[row][col]), .reset(Reset));
                end
                else    // Columna 3, entrada A del sumador es cero
                begin
                    full_adder adder (.A(zero), .B(InA[col] & InB[row+1]), .Cin(C[row][col]), .Cout(C[row][col+1]), .Sum(Adder_Result[row][col]), .reset(Reset));
                end
            end
        end

        else
        begin
            for (col=0; col<INPUT_BIT_SIZE; col=col+1)
            begin:COL
                if (col == 0) // Columna 0, Cin = 0
                begin
                    full_adder adder (.A(Adder_Result[row-1][col+1]), .B(InA[col] & InB[row+1]), .Cin(zero), .Cout(C[row][col+1]), .Sum(Adder_Result[row][col]), .reset(Reset));
                    assign Out[row+1] = Adder_Result[row][col];
                end
                else if (col > 0 && col < INPUT_BIT_SIZE-1)   // Columnas 1 y 2
                begin
                    full_adder adder (.A(Adder_Result[row-1][col+1]), .B(InA[col] & InB[row+1]), .Cin(C[row][col]), .Cout(C[row][col+1]), .Sum(Adder_Result[row][col]), .reset(Reset));
                end
                else    // Columna 3, entrada A del sumador es C[row-1][col+1]
                begin
                    full_adder adder (.A(C[row-1][col+1]), .B(InA[col] & InB[row+1]), .Cin(C[row][col]), .Cout(C[row][col+1]), .Sum(Adder_Result[row][col]), .reset(Reset));
                end
            end
        end
    end
endgenerate

// Asignar resultado final
assign Out[OUTPUT_BIT_SIZE-1: ROW_SIZE] = {C[ROW_SIZE-1][INPUT_BIT_SIZE], Adder_Result[ROW_SIZE-1][INPUT_BIT_SIZE-1:0]};
assign Out [0] = InA[0]&InB[0];
endmodule