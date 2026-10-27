module c06_core_tb;
    logic clk, rst_n;
    logic [7:0] sample_in, threshold;
    logic [7:0] window_count;
    logic [8:0] event_count, result_count;
    logic window_done;

    c06_core dut(.*);

    always #5 clk = ~clk;

    task automatic apply_cycle(input logic [7:0] x);
        begin
            sample_in = x;
            @(posedge clk);
            #1;
        end
    endtask

    task automatic reset_dut;
        begin
            rst_n = 0;
            sample_in = 0;
            repeat(2) @(posedge clk);
            rst_n = 1;
            #1;
        end
    endtask

    initial begin
		$dumpfile("waveforms/c06_core.vcd");
        $dumpvars(0, c06_core_tb);

        clk = 0;
        rst_n = 1;
        sample_in = 0;
        threshold = 8'd100;

        reset_dut();
		// --- CA TỰ NGHĨ 1: Lọc nhiễu tĩnh (Mẫu < Ngưỡng) ---
        threshold = 8'd100;
        for (int i=1; i<=256; i++) apply_cycle(8'd50);
        assert(result_count == 9'd0)
            else $fatal(1,"Ca tu nghi 1 that bai: %0d",result_count);

        // --- CA TỰ NGHĨ 2: Biên đáy tuyệt đối (0 > 0) ---
        threshold = 8'd0;
        for (int i=1; i<=256; i++) apply_cycle(8'd0);
        assert(result_count == 9'd0)
            else $fatal(1,"Ca tu nghi 2 that bai: %0d",result_count);

        // --- QUAN TRỌNG: Trả lại ngưỡng 100 cho các ca gốc phía sau ---
        threshold = 8'd100;
        // Window 1:
        // events at cycles 1, 255, 256.
        apply_cycle(8'd101);
        for (int i=2; i<=254; i++) apply_cycle(8'd100);
        apply_cycle(8'd101); // cycle 255
        apply_cycle(8'd101); // cycle 256

        assert(window_done == 1)
            else $fatal(1,"window_done missing at cycle 256");
        assert(result_count == 9'd3)
            else $fatal(1,"cycle-256 result wrong: %0d",result_count);
        assert(window_count == 0)
            else $fatal(1,"window counter did not roll over");
        assert(event_count == 0)
            else $fatal(1,"event counter did not clear");

        // Window 2 starts immediately after rollover.
        apply_cycle(8'd101);
        assert(window_count == 8'd1)
            else $fatal(1,"next window did not start correctly");
        assert(event_count == 9'd1)
            else $fatal(1,"first event of next window missing");

        // Equality must not count for mentor `>` convention.
        for (int i=2; i<=256; i++) apply_cycle(8'd100);
        assert(result_count == 9'd1)
            else $fatal(1,"equality was incorrectly counted");

        // Window 3: all 256 cycles exceed threshold.
        for (int i=1; i<=256; i++) apply_cycle(8'd101);
        assert(result_count == 9'd256)
            else $fatal(1,"maximum count failed: %0d",result_count);

        $display("C06 core verification PASS");
        $finish;
		
    end
endmodule
