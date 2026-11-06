//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);
    // Task:
    // Implement a module that converts single-bit serial data to the multi-bit parallel value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits and receiving last 'serial_valid' input,
    // the module should assert the 'parallel_valid' at the same clock cycle
    // and output 'parallel_data' value.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.

    logic [width - 1:0] shift_reg;
    logic [$clog2(width)-1:0] bits_chtr;

    always_ff @(posedge clk) 
    begin
        if(rst)
        begin
            shift_reg <= '0;
            parallel_valid <= 1'b0; 
            bits_chtr <= 1'd0;
        end

        else 
        begin
            if (serial_valid && bits_chtr == width - 1) // заполнится на такте width
            begin
                parallel_data <= {serial_data, shift_reg[width - 1:1]}; // последнее значениие записано на ходу
                parallel_valid <= 1'b1;
                bits_chtr <= 1'd0;
                shift_reg <= '0; // сброс, чтобы новые данные могли прийти уже на след такт
            end
            else if (serial_valid)
            begin
                shift_reg <= {serial_data, shift_reg[width - 1:1]}; // LSB first
                bits_chtr <= bits_chtr + 1'd1;
            end
            if (parallel_valid) // на width+1 такте получатель заберет данные, можно сбросить
            begin
                parallel_valid <= 1'b0;
                parallel_data <= '0;
            end
        end
        
    end


endmodule
