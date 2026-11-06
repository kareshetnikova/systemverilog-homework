//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module parallel_to_serial
# (
    parameter width = 8
)
(
    input logic                     clk,
    input logic                     rst,

    input logic                     parallel_valid,
    input logic       [width - 1:0] parallel_data,

    output logic                     busy,
    output logic               serial_valid,
    output logic               serial_data
);
    // Task:
    // Implement a module that converts multi-bit parallel value to the single-bit serial data.
    //
    // The module should accept 'width' bit input parallel data when 'parallel_valid' input is asserted.
    // At the same clock cycle as 'parallel_valid' is asserted, the module should output
    // the least significant bit of the input data. In the following clock cycles the module
    // should output all the remaining bits of the parallel_data.
    // Together with providing correct 'serial_data' value, module should also assert the 'serial_valid' output.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.

    logic [$clog2(width + 1)-1:0] serial_cntr;
    logic [width - 1 : 0] parallel_data_array; // нужен, так как parallel_data может меняться
    
    always_ff @(posedge clk) begin
        if(rst)
        begin
            busy <= 1'b0;
            parallel_data_array <= '0;
            serial_valid <= 1'b0;
        end

        else
        begin
            if (parallel_valid)
            begin
                parallel_data_array <= parallel_data;
                serial_data <= parallel_data[0]; //  сразу выдаем первый бит
                serial_valid <= 1'b1;
                serial_cntr <= 1'd1; // так как уже один бит выдан
                busy <= 1'b1;
            end
            else if (serial_cntr != width)
            begin
                serial_data <= parallel_data_array[serial_cntr]; 
                serial_cntr <= serial_cntr + 1'd1; 
            end
            else if (serial_cntr == width)// выдано все слово
            begin
                busy <= 1'b0;
                parallel_data_array <= '0;
                serial_valid <= 1'b0;
            end


        end
        
    end


endmodule
