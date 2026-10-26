module c06_reference (
    input logic       clk,
    input logic       rst_n,
    input logic [7:0] sample_in,
    input logic [7:0] threshold,
    output logic [8:0] result_count_ref,
    output logic       window_done_ref
);
    logic [8:0] count_ref;
    logic [7:0] pos_ref;
    logic event_ref;

    always_comb begin
        event_ref = (sample_in > threshold);
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            count_ref        <= 9'd0;
            pos_ref          <= 8'd0;
            result_count_ref <= 9'd0;
            window_done_ref  <= 1'b0;
        end else begin
            window_done_ref <= 1'b0;

            if (pos_ref == 8'd255) begin
                result_count_ref <= count_ref + event_ref;
                count_ref <= 9'd0;
                pos_ref <= 8'd0;
                window_done_ref <= 1'b1;
            end else begin
                count_ref <= count_ref + event_ref;
                pos_ref <= pos_ref + 8'd1;
            end
        end
    end
endmodule
