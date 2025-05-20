module prog_counter(
    input logic clk,
    input logic reset,
    input logic load_e,
    input logic out_e,
    input logic [7:0] load_val,
    output logic [7:0] out_data
);

logic [7:0] counter;

always_ff @(posedge clk) begin //synch reset
    if (reset) begin
        counter <= 8'b0;
    end else if (load_e) begin
        counter <= load_val;
    end else begin
        counter <= counter + 1;
    end
end

assign out_data = out_e ? counter : 8'bz;

endmodule