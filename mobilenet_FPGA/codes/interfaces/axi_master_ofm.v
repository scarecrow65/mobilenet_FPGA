//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2026 04:36:05 PM
// Design Name: 
// Module Name: axi_master_ofm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// AXI MASTER OFM WRITER - OFM BUFFER → DDR
//////////////////////////////////////////////////////////////////////////////////

module axi_master_ofm #(

    parameter AXI_ADDR_W = 32,
    parameter AXI_DATA_W = 128,
    parameter BUF_ADDR_W = 10,
    parameter BURST_LEN  = 128    // ≤ 256 for AXI4

)(
    input  wire clk,
    input  wire rst_n,

    //--------------------------------------------------
    // Control
    //--------------------------------------------------
    input  wire start_write,
    input  wire [AXI_ADDR_W-1:0] base_addr,
    output reg  done,

    //--------------------------------------------------
    // AXI WRITE ADDRESS CHANNEL
    //--------------------------------------------------
    output reg  [AXI_ADDR_W-1:0] awaddr,
    output reg                   awvalid,
    input  wire                  awready,

    output reg  [7:0]            awlen,
    output reg  [2:0]            awsize,
    output reg  [1:0]            awburst,

    //--------------------------------------------------
    // AXI WRITE DATA CHANNEL
    //--------------------------------------------------
    output reg  [AXI_DATA_W-1:0] wdata,
    output reg                   wvalid,
    input  wire                  wready,
    output reg                   wlast,
    output reg  [(AXI_DATA_W/8)-1:0] wstrb,

    //--------------------------------------------------
    // AXI WRITE RESPONSE
    //--------------------------------------------------
    input  wire bvalid,
    output reg  bready,

    //--------------------------------------------------
    // OFM BUFFER READ PORT
    //--------------------------------------------------
    output reg  [BUF_ADDR_W-1:0] rd_addr,
    input  wire [AXI_DATA_W-1:0] axi_out_data,
    input  wire [(AXI_DATA_W/8)-1:0] axi_wstrb
);

    // =========================================================
    // FSM STATES
    // =========================================================

    localparam IDLE  = 0,
               ADDR  = 1,
               WRITE = 2,
               RESP  = 3,
               DONE  = 4;

    reg [2:0] state, next_state;

    // =========================================================
    // Beat Counter
    // =========================================================

    reg [$clog2(BURST_LEN):0] beat_cnt;

    // =========================================================
    // PIPELINE REGISTERS (BRAM LATENCY ALIGNMENT)
    // =========================================================

    reg [AXI_DATA_W-1:0] data_reg;
    reg [(AXI_DATA_W/8)-1:0] strb_reg;

    always @(posedge clk) begin
        data_reg <= axi_out_data;
        strb_reg <= axi_wstrb;
    end

    // =========================================================
    // FSM SEQUENTIAL
    // =========================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // =========================================================
    // FSM COMBINATIONAL
    // =========================================================

    always @(*) begin
        next_state = state;

        case (state)

            IDLE:
                if (start_write)
                    next_state = ADDR;

            ADDR:
                if (awready)
                    next_state = WRITE;

            // Burst ends on last accepted beat
            WRITE:
                if (wready && beat_cnt == BURST_LEN-1)
                    next_state = RESP;

            RESP:
                if (bvalid)
                    next_state = DONE;

            DONE:
                next_state = IDLE;

        endcase
    end

    // =========================================================
    // ADDRESS CHANNEL
    // =========================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            awaddr  <= 0;
            awvalid <= 0;
            awlen   <= 0;
            awsize  <= 0;
            awburst <= 0;
        end
        else begin
            case (state)

                IDLE: begin
                    awaddr  <= base_addr;
                    awvalid <= 0;

                    awlen   <= BURST_LEN - 1;
                    awsize  <= $clog2(AXI_DATA_W/8);
                    awburst <= 2'b01; // INCR burst
                end

                ADDR: begin
                    awvalid <= 1;
                    if (awready)
                        awvalid <= 0;
                end

            endcase
        end
    end

    // =========================================================
    // WRITE DATA PATH (FINAL - STALL SAFE + ALIGNED)
    // =========================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wvalid   <= 0;
            wdata    <= 0;
            wstrb    <= 0;
            wlast    <= 0;
            rd_addr  <= 0;
            beat_cnt <= 0;
        end
        else begin

            //----------------------------------------------
            // Reset counter at burst start
            //----------------------------------------------
            if (state == IDLE && start_write)
                beat_cnt <= 0;


            // Buffer read control (aligned + primed)
            //----------------------------------------------
            if (state == ADDR)
                rd_addr <= 0;
            else if (state == WRITE)
                rd_addr <= beat_cnt;
            
            //----------------------------------------------
            // AXI write drive
            //----------------------------------------------
            if (state == WRITE) begin

                wvalid <= 1;

                // Use pipelined buffer data
                wdata  <= data_reg;
                wstrb  <= strb_reg;

                // Last beat marker
                wlast  <= (beat_cnt == BURST_LEN-1);

                // Increment only on accepted beat
                if (wready)
                    beat_cnt <= beat_cnt + 1;
            end
            else begin
                wvalid <= 0;
                wlast  <= 0;
            end

        end
    end

    // =========================================================
    // WRITE RESPONSE CHANNEL
    // =========================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bready <= 0;
        else
            bready <= (state == RESP);
    end

    // =========================================================
    // DONE FLAG
    // =========================================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            done <= 0;
        else
            done <= (state == DONE);
    end

endmodule
