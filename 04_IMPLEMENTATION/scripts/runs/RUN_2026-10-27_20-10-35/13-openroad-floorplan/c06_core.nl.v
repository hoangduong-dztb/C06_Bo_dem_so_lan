module c06_core (clk,
    rst_n,
    window_done,
    event_count,
    result_count,
    sample_in,
    threshold,
    window_count);
 input clk;
 input rst_n;
 output window_done;
 output [8:0] event_count;
 output [8:0] result_count;
 input [7:0] sample_in;
 input [7:0] threshold;
 output [7:0] window_count;

 wire _000_;
 wire _001_;
 wire _002_;
 wire _003_;
 wire _004_;
 wire _005_;
 wire _006_;
 wire _007_;
 wire _008_;
 wire _009_;
 wire _010_;
 wire _011_;
 wire _012_;
 wire _013_;
 wire _014_;
 wire _015_;
 wire _016_;
 wire _017_;
 wire _018_;
 wire _019_;
 wire _020_;
 wire _021_;
 wire _022_;
 wire _023_;
 wire _024_;
 wire _025_;
 wire _026_;
 wire _027_;
 wire _028_;
 wire _029_;
 wire _030_;
 wire _031_;
 wire _032_;
 wire _033_;
 wire _034_;
 wire _035_;
 wire _036_;
 wire _037_;
 wire _038_;
 wire _039_;
 wire _040_;
 wire _041_;
 wire _042_;
 wire _043_;
 wire _044_;
 wire _045_;
 wire _046_;
 wire _047_;
 wire _048_;
 wire _049_;
 wire _050_;
 wire _051_;
 wire _052_;
 wire _053_;
 wire _054_;
 wire _055_;
 wire _056_;
 wire _057_;
 wire _058_;
 wire _059_;
 wire _060_;
 wire _061_;
 wire _062_;
 wire _063_;
 wire _064_;
 wire _065_;
 wire _066_;
 wire _067_;
 wire _068_;
 wire _069_;
 wire _070_;
 wire _071_;
 wire _072_;
 wire _073_;
 wire _074_;
 wire _075_;
 wire _076_;
 wire _077_;
 wire _078_;
 wire _079_;
 wire _080_;
 wire _081_;
 wire _082_;
 wire _083_;
 wire _084_;
 wire _085_;
 wire _086_;

 sky130_fd_sc_hd__inv_2 _087_ (.A(threshold[5]),
    .Y(_066_));
 sky130_fd_sc_hd__inv_2 _088_ (.A(sample_in[4]),
    .Y(_067_));
 sky130_fd_sc_hd__inv_2 _089_ (.A(threshold[0]),
    .Y(_068_));
 sky130_fd_sc_hd__inv_2 _090_ (.A(event_count[8]),
    .Y(_069_));
 sky130_fd_sc_hd__and3_2 _091_ (.A(window_count[0]),
    .B(window_count[1]),
    .C(window_count[2]),
    .X(_070_));
 sky130_fd_sc_hd__and2_2 _092_ (.A(window_count[3]),
    .B(_070_),
    .X(_071_));
 sky130_fd_sc_hd__and3_2 _093_ (.A(window_count[4]),
    .B(window_count[5]),
    .C(_071_),
    .X(_072_));
 sky130_fd_sc_hd__and2_2 _094_ (.A(window_count[6]),
    .B(_072_),
    .X(_073_));
 sky130_fd_sc_hd__a21boi_2 _095_ (.A1(window_count[7]),
    .A2(_073_),
    .B1_N(rst_n),
    .Y(_074_));
 sky130_fd_sc_hd__and2b_2 _096_ (.A_N(window_count[0]),
    .B(_074_),
    .X(_000_));
 sky130_fd_sc_hd__o21ai_2 _097_ (.A1(window_count[0]),
    .A2(window_count[1]),
    .B1(_074_),
    .Y(_075_));
 sky130_fd_sc_hd__a21oi_2 _098_ (.A1(window_count[0]),
    .A2(window_count[1]),
    .B1(_075_),
    .Y(_001_));
 sky130_fd_sc_hd__a21o_2 _099_ (.A1(window_count[0]),
    .A2(window_count[1]),
    .B1(window_count[2]),
    .X(_076_));
 sky130_fd_sc_hd__and3b_2 _100_ (.A_N(_070_),
    .B(_074_),
    .C(_076_),
    .X(_002_));
 sky130_fd_sc_hd__or2_2 _101_ (.A(window_count[3]),
    .B(_070_),
    .X(_077_));
 sky130_fd_sc_hd__and3b_2 _102_ (.A_N(_071_),
    .B(_074_),
    .C(_077_),
    .X(_003_));
 sky130_fd_sc_hd__o21ai_2 _103_ (.A1(window_count[4]),
    .A2(_071_),
    .B1(_074_),
    .Y(_078_));
 sky130_fd_sc_hd__a21oi_2 _104_ (.A1(window_count[4]),
    .A2(_071_),
    .B1(_078_),
    .Y(_004_));
 sky130_fd_sc_hd__a31o_2 _105_ (.A1(window_count[3]),
    .A2(window_count[4]),
    .A3(_070_),
    .B1(window_count[5]),
    .X(_079_));
 sky130_fd_sc_hd__and3b_2 _106_ (.A_N(_072_),
    .B(_079_),
    .C(rst_n),
    .X(_005_));
 sky130_fd_sc_hd__o21ai_2 _107_ (.A1(window_count[6]),
    .A2(_072_),
    .B1(rst_n),
    .Y(_080_));
 sky130_fd_sc_hd__nor2_2 _108_ (.A(_073_),
    .B(_080_),
    .Y(_006_));
 sky130_fd_sc_hd__o21a_2 _109_ (.A1(window_count[7]),
    .A2(_073_),
    .B1(_074_),
    .X(_007_));
 sky130_fd_sc_hd__and2b_2 _110_ (.A_N(sample_in[6]),
    .B(threshold[6]),
    .X(_081_));
 sky130_fd_sc_hd__nand2b_2 _111_ (.A_N(sample_in[5]),
    .B(threshold[5]),
    .Y(_082_));
 sky130_fd_sc_hd__inv_2 _112_ (.A(_082_),
    .Y(_083_));
 sky130_fd_sc_hd__and2b_2 _113_ (.A_N(sample_in[7]),
    .B(threshold[7]),
    .X(_084_));
 sky130_fd_sc_hd__nand2b_2 _114_ (.A_N(sample_in[7]),
    .B(threshold[7]),
    .Y(_085_));
 sky130_fd_sc_hd__and2b_2 _115_ (.A_N(threshold[6]),
    .B(sample_in[6]),
    .X(_086_));
 sky130_fd_sc_hd__and2b_2 _116_ (.A_N(threshold[7]),
    .B(sample_in[7]),
    .X(_027_));
 sky130_fd_sc_hd__a2bb2o_2 _117_ (.A1_N(_067_),
    .A2_N(threshold[4]),
    .B1(_066_),
    .B2(sample_in[5]),
    .X(_028_));
 sky130_fd_sc_hd__or4_2 _118_ (.A(_081_),
    .B(_084_),
    .C(_086_),
    .D(_027_),
    .X(_029_));
 sky130_fd_sc_hd__a2111o_2 _119_ (.A1(_067_),
    .A2(threshold[4]),
    .B1(_083_),
    .C1(_028_),
    .D1(_029_),
    .X(_030_));
 sky130_fd_sc_hd__and2b_2 _120_ (.A_N(threshold[3]),
    .B(sample_in[3]),
    .X(_031_));
 sky130_fd_sc_hd__and2b_2 _121_ (.A_N(threshold[2]),
    .B(sample_in[2]),
    .X(_032_));
 sky130_fd_sc_hd__nand2b_2 _122_ (.A_N(sample_in[3]),
    .B(threshold[3]),
    .Y(_033_));
 sky130_fd_sc_hd__nand2b_2 _123_ (.A_N(sample_in[2]),
    .B(threshold[2]),
    .Y(_034_));
 sky130_fd_sc_hd__or4bb_2 _124_ (.A(_031_),
    .B(_032_),
    .C_N(_033_),
    .D_N(_034_),
    .X(_035_));
 sky130_fd_sc_hd__nand2b_2 _125_ (.A_N(threshold[1]),
    .B(sample_in[1]),
    .Y(_036_));
 sky130_fd_sc_hd__nand2b_2 _126_ (.A_N(sample_in[1]),
    .B(threshold[1]),
    .Y(_037_));
 sky130_fd_sc_hd__o211ai_2 _127_ (.A1(sample_in[0]),
    .A2(_068_),
    .B1(_036_),
    .C1(_037_),
    .Y(_038_));
 sky130_fd_sc_hd__a21oi_2 _128_ (.A1(_036_),
    .A2(_038_),
    .B1(_035_),
    .Y(_039_));
 sky130_fd_sc_hd__a21o_2 _129_ (.A1(_032_),
    .A2(_033_),
    .B1(_031_),
    .X(_040_));
 sky130_fd_sc_hd__o21ba_2 _130_ (.A1(_039_),
    .A2(_040_),
    .B1_N(_030_),
    .X(_041_));
 sky130_fd_sc_hd__and3b_2 _131_ (.A_N(_081_),
    .B(_082_),
    .C(_028_),
    .X(_042_));
 sky130_fd_sc_hd__o31a_2 _132_ (.A1(_086_),
    .A2(_027_),
    .A3(_042_),
    .B1(_085_),
    .X(_043_));
 sky130_fd_sc_hd__a2111o_2 _133_ (.A1(sample_in[0]),
    .A2(_068_),
    .B1(_030_),
    .C1(_035_),
    .D1(_038_),
    .X(_044_));
 sky130_fd_sc_hd__o21a_2 _134_ (.A1(_041_),
    .A2(_043_),
    .B1(_044_),
    .X(_045_));
 sky130_fd_sc_hd__xor2_2 _135_ (.A(event_count[0]),
    .B(_045_),
    .X(_046_));
 sky130_fd_sc_hd__and2_2 _136_ (.A(_074_),
    .B(_046_),
    .X(_008_));
 sky130_fd_sc_hd__o2111a_2 _137_ (.A1(_041_),
    .A2(_043_),
    .B1(_044_),
    .C1(event_count[0]),
    .D1(event_count[1]),
    .X(_047_));
 sky130_fd_sc_hd__a21oi_2 _138_ (.A1(event_count[0]),
    .A2(_045_),
    .B1(event_count[1]),
    .Y(_048_));
 sky130_fd_sc_hd__nor2_2 _139_ (.A(_047_),
    .B(_048_),
    .Y(_049_));
 sky130_fd_sc_hd__and2_2 _140_ (.A(_074_),
    .B(_049_),
    .X(_009_));
 sky130_fd_sc_hd__xor2_2 _141_ (.A(event_count[2]),
    .B(_047_),
    .X(_050_));
 sky130_fd_sc_hd__and2_2 _142_ (.A(_074_),
    .B(_050_),
    .X(_010_));
 sky130_fd_sc_hd__and2_2 _143_ (.A(event_count[2]),
    .B(event_count[3]),
    .X(_051_));
 sky130_fd_sc_hd__nand2_2 _144_ (.A(_047_),
    .B(_051_),
    .Y(_052_));
 sky130_fd_sc_hd__a21o_2 _145_ (.A1(event_count[2]),
    .A2(_047_),
    .B1(event_count[3]),
    .X(_053_));
 sky130_fd_sc_hd__and2_2 _146_ (.A(_052_),
    .B(_053_),
    .X(_054_));
 sky130_fd_sc_hd__and3_2 _147_ (.A(_074_),
    .B(_052_),
    .C(_053_),
    .X(_011_));
 sky130_fd_sc_hd__xnor2_2 _148_ (.A(event_count[4]),
    .B(_052_),
    .Y(_055_));
 sky130_fd_sc_hd__and2_2 _149_ (.A(_074_),
    .B(_055_),
    .X(_012_));
 sky130_fd_sc_hd__and2_2 _150_ (.A(event_count[4]),
    .B(event_count[5]),
    .X(_056_));
 sky130_fd_sc_hd__nand3_2 _151_ (.A(_047_),
    .B(_051_),
    .C(_056_),
    .Y(_057_));
 sky130_fd_sc_hd__a31o_2 _152_ (.A1(event_count[4]),
    .A2(_047_),
    .A3(_051_),
    .B1(event_count[5]),
    .X(_058_));
 sky130_fd_sc_hd__and2_2 _153_ (.A(_057_),
    .B(_058_),
    .X(_059_));
 sky130_fd_sc_hd__and3_2 _154_ (.A(_074_),
    .B(_057_),
    .C(_058_),
    .X(_013_));
 sky130_fd_sc_hd__xnor2_2 _155_ (.A(event_count[6]),
    .B(_057_),
    .Y(_060_));
 sky130_fd_sc_hd__and2_2 _156_ (.A(_074_),
    .B(_060_),
    .X(_014_));
 sky130_fd_sc_hd__nand2_2 _157_ (.A(event_count[6]),
    .B(event_count[7]),
    .Y(_061_));
 sky130_fd_sc_hd__a41o_2 _158_ (.A1(event_count[6]),
    .A2(_047_),
    .A3(_051_),
    .A4(_056_),
    .B1(event_count[7]),
    .X(_062_));
 sky130_fd_sc_hd__o21a_2 _159_ (.A1(_057_),
    .A2(_061_),
    .B1(_062_),
    .X(_063_));
 sky130_fd_sc_hd__and2_2 _160_ (.A(_074_),
    .B(_063_),
    .X(_015_));
 sky130_fd_sc_hd__o21ai_2 _161_ (.A1(_057_),
    .A2(_061_),
    .B1(_069_),
    .Y(_064_));
 sky130_fd_sc_hd__or3_2 _162_ (.A(_069_),
    .B(_057_),
    .C(_061_),
    .X(_065_));
 sky130_fd_sc_hd__and3_2 _163_ (.A(_074_),
    .B(_064_),
    .C(_065_),
    .X(_016_));
 sky130_fd_sc_hd__and3_2 _164_ (.A(window_count[7]),
    .B(rst_n),
    .C(_073_),
    .X(_026_));
 sky130_fd_sc_hd__a22o_2 _165_ (.A1(result_count[0]),
    .A2(_074_),
    .B1(_046_),
    .B2(_026_),
    .X(_017_));
 sky130_fd_sc_hd__a22o_2 _166_ (.A1(result_count[1]),
    .A2(_074_),
    .B1(_049_),
    .B2(_026_),
    .X(_018_));
 sky130_fd_sc_hd__a22o_2 _167_ (.A1(result_count[2]),
    .A2(_074_),
    .B1(_050_),
    .B2(_026_),
    .X(_019_));
 sky130_fd_sc_hd__a22o_2 _168_ (.A1(result_count[3]),
    .A2(_074_),
    .B1(_054_),
    .B2(_026_),
    .X(_020_));
 sky130_fd_sc_hd__a22o_2 _169_ (.A1(result_count[4]),
    .A2(_074_),
    .B1(_055_),
    .B2(_026_),
    .X(_021_));
 sky130_fd_sc_hd__a22o_2 _170_ (.A1(result_count[5]),
    .A2(_074_),
    .B1(_059_),
    .B2(_026_),
    .X(_022_));
 sky130_fd_sc_hd__a22o_2 _171_ (.A1(result_count[6]),
    .A2(_074_),
    .B1(_060_),
    .B2(_026_),
    .X(_023_));
 sky130_fd_sc_hd__a22o_2 _172_ (.A1(result_count[7]),
    .A2(_074_),
    .B1(_063_),
    .B2(_026_),
    .X(_024_));
 sky130_fd_sc_hd__a32o_2 _173_ (.A1(_064_),
    .A2(_065_),
    .A3(_026_),
    .B1(_074_),
    .B2(result_count[8]),
    .X(_025_));
 sky130_fd_sc_hd__dfxtp_2 _174_ (.CLK(clk),
    .D(_000_),
    .Q(window_count[0]));
 sky130_fd_sc_hd__dfxtp_2 _175_ (.CLK(clk),
    .D(_001_),
    .Q(window_count[1]));
 sky130_fd_sc_hd__dfxtp_2 _176_ (.CLK(clk),
    .D(_002_),
    .Q(window_count[2]));
 sky130_fd_sc_hd__dfxtp_2 _177_ (.CLK(clk),
    .D(_003_),
    .Q(window_count[3]));
 sky130_fd_sc_hd__dfxtp_2 _178_ (.CLK(clk),
    .D(_004_),
    .Q(window_count[4]));
 sky130_fd_sc_hd__dfxtp_2 _179_ (.CLK(clk),
    .D(_005_),
    .Q(window_count[5]));
 sky130_fd_sc_hd__dfxtp_2 _180_ (.CLK(clk),
    .D(_006_),
    .Q(window_count[6]));
 sky130_fd_sc_hd__dfxtp_2 _181_ (.CLK(clk),
    .D(_007_),
    .Q(window_count[7]));
 sky130_fd_sc_hd__dfxtp_2 _182_ (.CLK(clk),
    .D(_008_),
    .Q(event_count[0]));
 sky130_fd_sc_hd__dfxtp_2 _183_ (.CLK(clk),
    .D(_009_),
    .Q(event_count[1]));
 sky130_fd_sc_hd__dfxtp_2 _184_ (.CLK(clk),
    .D(_010_),
    .Q(event_count[2]));
 sky130_fd_sc_hd__dfxtp_2 _185_ (.CLK(clk),
    .D(_011_),
    .Q(event_count[3]));
 sky130_fd_sc_hd__dfxtp_2 _186_ (.CLK(clk),
    .D(_012_),
    .Q(event_count[4]));
 sky130_fd_sc_hd__dfxtp_2 _187_ (.CLK(clk),
    .D(_013_),
    .Q(event_count[5]));
 sky130_fd_sc_hd__dfxtp_2 _188_ (.CLK(clk),
    .D(_014_),
    .Q(event_count[6]));
 sky130_fd_sc_hd__dfxtp_2 _189_ (.CLK(clk),
    .D(_015_),
    .Q(event_count[7]));
 sky130_fd_sc_hd__dfxtp_2 _190_ (.CLK(clk),
    .D(_016_),
    .Q(event_count[8]));
 sky130_fd_sc_hd__dfxtp_2 _191_ (.CLK(clk),
    .D(_017_),
    .Q(result_count[0]));
 sky130_fd_sc_hd__dfxtp_2 _192_ (.CLK(clk),
    .D(_018_),
    .Q(result_count[1]));
 sky130_fd_sc_hd__dfxtp_2 _193_ (.CLK(clk),
    .D(_019_),
    .Q(result_count[2]));
 sky130_fd_sc_hd__dfxtp_2 _194_ (.CLK(clk),
    .D(_020_),
    .Q(result_count[3]));
 sky130_fd_sc_hd__dfxtp_2 _195_ (.CLK(clk),
    .D(_021_),
    .Q(result_count[4]));
 sky130_fd_sc_hd__dfxtp_2 _196_ (.CLK(clk),
    .D(_022_),
    .Q(result_count[5]));
 sky130_fd_sc_hd__dfxtp_2 _197_ (.CLK(clk),
    .D(_023_),
    .Q(result_count[6]));
 sky130_fd_sc_hd__dfxtp_2 _198_ (.CLK(clk),
    .D(_024_),
    .Q(result_count[7]));
 sky130_fd_sc_hd__dfxtp_2 _199_ (.CLK(clk),
    .D(_025_),
    .Q(result_count[8]));
 sky130_fd_sc_hd__dfxtp_2 _200_ (.CLK(clk),
    .D(_026_),
    .Q(window_done));
endmodule
