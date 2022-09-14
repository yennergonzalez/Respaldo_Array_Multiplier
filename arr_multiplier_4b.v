/*`define INPUT_BIT_SIZE 4
`define OUTPUT_BIT_SIZE 2*INPUT_BIT_SIZE
`define ROW_SIZE INPUT_BIT_SIZE-1*/

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


// Entradas y salidas del modulo
input [3:0]          InA;
input [3:0]          InB;
input                Reset;
output [7:0]         Out;


// Senales internas
wire [4:0] C [2:0];            // Carry de cada sumador
wire [3:0] Adder_Result [3:0];    // Resultado de cada sumador
wire zero;                                              // Senal conectada a cero permanentemente
wire adder_carry;

assign zero = 1'b0;
assign adder_carry = 1'b1;

genvar row, col;
generate
    for (row=0; row<3; row=row+1) 
    begin:ROW
        if (row == 0) 
        begin
            for (col=0; col<4; col=col+1)
            begin:COL
                if (col == 0)   // Columna 0, Cin=0
                begin
                    full_adder adder (.A(InA[col+1] & InB[row]), .B(InA[col] & InB[row+1]), .Cin(zero), .Cout(C[row][col+1]), .Sum(Adder_Result[row][col]), .reset(Reset) );
                end
                else if (col == 1 || col == 2)   // Columnas 1 y 2
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
            for (col=0; col<4; col=col+1)
            begin:COL
                if (col == 0) // Columna 0, Cin = 0
                begin
                    full_adder adder (.A(Adder_Result[row-1][col+1]), .B(InA[col] & InB[row+1]), .Cin(zero), .Cout(C[row][col+1]), .Sum(Adder_Result[row][col]), .reset(Reset));
                end
                else if (col == 1 || col == 2)   // Columnas 1 y 2
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
assign Out = {C[2][4], Adder_Result[2][3], Adder_Result[2][2], Adder_Result[2][1], Adder_Result[2][0], Adder_Result[1][0], Adder_Result[0][0], InA[0]&InB[0]};
//assign Out = {C[ROW_SIZE][INPUT_BIT_SIZE], Adder_Result[ROW_SIZE-1], Adder_Result[ROW_SIZE-2][0], Adder_Result[ROW_SIZE-3][0], (InA[0]&InB[0])};
endmodule




