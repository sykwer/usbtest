module usbtest(
           CLK, TXE_N, RXF_N, OE_N, RD_N, WR_N, DATA, BE,
           counter,
       );
localparam MODE_IDLE = 0;
localparam MODE_WILL_OE_N_DOWN = 1;
localparam MODE_WILL_RD_N_DOWN = 2;
localparam MODE_READING_DATA = 3;
localparam MODE_AFTER_READING = 4;
localparam MODE_SENT_DATA = 5;

input CLK, TXE_N, RXF_N;
output reg OE_N, RD_N, WR_N;
inout [15:0] DATA;
inout [1:0] BE;

reg [15:0] read_buffer;
reg [15:0] write_buffer;
reg data_ready;
reg [4:0] mode_CLK_cycle;

output [7:0] counter;

initial begin
  OE_N = 1;
  RD_N = 1;
  WR_N = 1;
  mode_CLK_cycle <= MODE_IDLE;
  read_buffer = 0;
  write_buffer = 16'b1010101010101010;
  data_ready = 0;
end

always @(negedge CLK) begin
  if (!TXE_N) begin
    WR_N = 0;
  end
end

/*
initial begin
  OE_N = 1;
  RD_N = 1;
  WR_N = 1;
  mode_CLK_cycle <= MODE_IDLE;
  read_buffer = 0;
  write_buffer = 0;
  data_ready = 0;
end

always @(negedge CLK) begin
    if (mode_CLK_cycle == MODE_IDLE) begin
        if (RXF_N == 0) begin
            mode_CLK_cycle <= MODE_WILL_OE_N_DOWN;
        end else if (data_ready) begin
            WR_N <= 0;
            write_buffer <= read_buffer;
            data_ready <= 0;
            mode_CLK_cycle <= MODE_SENT_DATA;
        end
    end

    // Read cycle from here
    if (mode_CLK_cycle == MODE_WILL_OE_N_DOWN) begin
        OE_N <= 0;
        mode_CLK_cycle <= MODE_WILL_RD_N_DOWN;
    end

    if (mode_CLK_cycle == MODE_WILL_RD_N_DOWN) begin
        RD_N <= 0;
        mode_CLK_cycle <= MODE_READING_DATA;
    end

    if (mode_CLK_cycle == MODE_READING_DATA) begin
        read_buffer <= DATA;
        data_ready <= 1;
        mode_CLK_cycle <= MODE_AFTER_READING;
    end

    if (mode_CLK_cycle == MODE_AFTER_READING) begin
        OE_N <= 1;
        RD_N <= 1;
        mode_CLK_cycle <= MODE_IDLE;
    end
    // Read cycle to here

    // Write cycle from here
    if (mode_CLK_cycle == MODE_SENT_DATA) begin
        WR_N <= 1;
        mode_CLK_cycle <= MODE_IDLE;
    end
    // Write cycle to here
end
*/

assign DATA = OE_N ? write_buffer : 16'bZ;
assign BE = OE_N ? 2'b11 : 2'bZ;
assign counter = read_buffer[7:0];
endmodule
