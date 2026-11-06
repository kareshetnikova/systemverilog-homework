//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module posedge_detector (input clk, rst, a, output detected);

  logic a_r;

  // Note:
  // The a_r flip-flop input value d propogates to the output q
  // only on the next clock cycle.

  always_ff @ (posedge clk)
    if (rst)
      a_r <= '0;
    else
      a_r <= a;

  assign detected = ~ a_r & a;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module one_cycle_pulse_detector (input clk, rst, a, output detected);

  // Task:
  // Create an one cycle pulse (010) detector.
  //
  // Note:
  // See the testbench for the output format ($display task).

  logic out1, out2;

  always_ff @(posedge clk) begin

    if (rst) begin
      out1 <= 0;
      out2 <= 0;
      //detected <= 0;
    end

    else begin
      out1 <= a;
      out2 <= out1;
      //detected <= ~a & out1 & ~out2;
    end

  end

  assign detected = ~(a | ~out1 | out2);
 
endmodule
