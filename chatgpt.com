module sync_ram (
    input clk,
    input we,               // Write enable
    input [1:0] addr,       // 2-bit address for 4 locations
    input [7:0] din,        // 8-bit data input
    output reg [7:0] dout   // 8-bit data output
);

    reg [7:0] mem [0:3];    // 4 x 8-bit memory

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;      // Write on rising edge
        dout <= mem[addr];         // Synchronous read on rising edge
    end
endmodule

🧪 Testbench for Synchronous RAM

sync_ram_tb.v

module sync_ram_tb;
    reg clk = 0;
    reg we;
    reg [1:0] addr;
    reg [7:0] din;
    wire [7:0] dout;

    sync_ram uut (
        .clk(clk),
        .we(we),
