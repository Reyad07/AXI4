`include "axi4l_pkg.sv"

module axi4l_mem #(
    parameter int  ADDR_WIDTH   = 32,
    parameter int  DATA_WIDTH   = 64,
    parameter int MEM_DEPTH = 1024,
    parameter type axi4l_req_t  = axi4l_pkg::axi4l_req_t,
    parameter type axi4l_resp_t = axi4l_pkg::axi4l_resp_t
) (
    input logic clk_i,
    input logic arst_ni,

    input  axi4l_req_t  axi4l_req_i,
    output axi4l_resp_t axi4l_resp_o
);

    localparam int StrbWidth = DATA_WIDTH/8;
    // bits needed to select a byte within a word
    localparam int ByteOffsetBits = $clog2(DATA_WIDTH/8);

    // bits need to select the word within the array
    localparam int WordIndxBits = $clog2(MEM_DEPTH);

    // Byte Addressable memory: MEM_DEPTH words, each word StrbWidth bytes of 8 bits.
    // memory[word_index][byte_index] gives direct access to a single byte
    logic [StrbWidth-1:0][7:0] memory [MEM_DEPTH];

    // --------------------------------------------------------------------------------------------
    // Write channel
    // --------------------------------------------------------------------------------------------
    typedef enum logic [1:0] {
        W_IDLE,
        W_DATA,
        W_RESP
     } write_chan_t;

     write_chan_t wstate, wstate_next;

    logic [ADDR_WIDTH-1:0] awaddr_reg;

    logic [WordIndxBits-1:0] aw_word_idx = awaddr_reg[WordIndxBits+ByteOffsetBits-1:ByteOffsetBits];

    always_ff @(posedge clk_i or negedge arst_ni) begin
        if(~arst_ni) begin
            wstate <= W_IDLE;
            awaddr_reg <= '0;
        end
        else begin
            wstate <= wstate_next;
            if (wstate == W_IDLE && axi4l_req_i.aw_valid && axi4l_resp_o.aw_ready) begin
                awaddr_reg <= axi4l_req_i.aw.addr;
            end
        end
    end

    always_comb begin
        wstate_next = wstate;
        axi4l_resp_o.aw_ready = '0;
        axi4l_resp_o.w_ready = '0;
        axi4l_resp_o.b_valid = '0;
        unique case (wstate)
            W_IDLE: begin
                axi4l_resp_o.aw_ready = 1'b1;
                if (axi4l_req_i.aw_valid)
                    wstate_next = W_DATA;
            end
            W_DATA: begin
                axi4l_resp_o.w_ready = 1'b1;
                if (axi4l_req_i.w_valid)
                    wstate_next = W_RESP;
            end
            W_RESP: begin
                axi4l_resp_o.b_valid = 1'b1;
                if (axi4l_req_i.b_ready)
                    wstate_next = W_IDLE;
            end
        default: wstate_next = W_IDLE;
        endcase
    end

    always_comb axi4l_resp_o.b.resp = 2'b00;    // OKAY

    always_ff @(posedge clk_i) begin
        if (wstate == W_DATA && axi4l_req_i.w_valid && axi4l_resp_o.w_ready) begin
            for (int i = 0; i < StrbWidth; i++) begin
                if (axi4l_req_i.w.strb[i]) memory [aw_word_idx][i] <= axi4l_req_i.w.data[i*8+:i];
            end
        end
    end


endmodule
