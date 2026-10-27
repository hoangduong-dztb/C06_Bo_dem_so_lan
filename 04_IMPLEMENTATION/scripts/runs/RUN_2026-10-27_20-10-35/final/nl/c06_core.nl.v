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
 wire net18;
 wire net19;
 wire net20;
 wire net21;
 wire net22;
 wire net23;
 wire net24;
 wire net25;
 wire net26;
 wire net27;
 wire net28;
 wire net29;
 wire net30;
 wire net31;
 wire net32;
 wire net33;
 wire net34;
 wire net35;
 wire net1;
 wire net2;
 wire net3;
 wire net4;
 wire net5;
 wire net6;
 wire net7;
 wire net8;
 wire net9;
 wire net10;
 wire net11;
 wire net12;
 wire net13;
 wire net14;
 wire net15;
 wire net16;
 wire net17;
 wire net36;
 wire net37;
 wire net38;
 wire net39;
 wire net40;
 wire net41;
 wire net42;
 wire net43;
 wire net44;
 wire net45;
 wire clknet_0_clk;
 wire clknet_1_0__leaf_clk;
 wire clknet_1_1__leaf_clk;

 sky130_fd_sc_hd__decap_3 FILLER_0_100 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_103 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_113 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_18 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_39 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_42 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_45 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_88 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_11 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_14 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_22 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_35 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_47 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_50 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_53 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_56 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_59 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_62 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_65 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_68 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_71 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_74 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_88 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_91 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_100 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_11 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_14 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_17 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_20 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_23 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_26 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_35 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_80 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_83 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_100 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_121 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_21 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_24 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_58 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_61 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_64 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_67 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_81 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_100 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_103 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_29 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_51 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_60 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_87 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_90 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_100 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_103 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_106 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_11 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_32 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_35 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_45 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_71 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_74 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_100 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_103 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_106 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_109 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_11 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_119 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_122 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_14 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_22 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_28 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_31 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_34 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_37 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_40 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_51 ();
 sky130_fd_sc_hd__fill_2 FILLER_15_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_57 ();
 sky130_fd_sc_hd__fill_2 FILLER_15_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_79 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_82 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_97 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_103 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_12 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_121 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_15 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_18 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_35 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_41 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_44 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_59 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_62 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_106 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_109 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_33 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_66 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_69 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_96 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_117 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_120 ();
 sky130_fd_sc_hd__fill_2 FILLER_18_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_63 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_66 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_91 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_24 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_33 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_39 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_42 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_45 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_66 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_86 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_89 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_92 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_100 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_103 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_111 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_65 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_68 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_102 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_105 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_108 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_111 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_12 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_15 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_18 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_21 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_24 ();
 sky130_fd_sc_hd__fill_1 FILLER_20_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_37 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_40 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_43 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_46 ();
 sky130_fd_sc_hd__fill_2 FILLER_20_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_67 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_70 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_73 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_93 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_96 ();
 sky130_fd_sc_hd__decap_3 FILLER_20_99 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_3 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_46 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_49 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_92 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_95 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_113 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_12 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_3 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_39 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_46 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_49 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_52 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_60 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_70 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_94 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_100 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_103 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_106 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_12 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_15 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_18 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_21 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_24 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_35 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_41 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_44 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_6 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_64 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_71 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_74 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_11 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_111 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_33 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_39 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_42 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_45 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_51 ();
 sky130_fd_sc_hd__fill_2 FILLER_5_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_72 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_84 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_87 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_90 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_93 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_96 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_121 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_26 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_35 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_6 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_83 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_92 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_31 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_34 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_37 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_57 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_95 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_98 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_100 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_103 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_35 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_38 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_41 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_60 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_79 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_82 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_97 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_11 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_113 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_33 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_39 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_42 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_45 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_66 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_87 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_90 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_93 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_96 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Left_21 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Right_0 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Left_31 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Right_10 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_11_Left_32 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_11_Right_11 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_12_Left_33 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_12_Right_12 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_13_Left_34 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_13_Right_13 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_14_Left_35 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_14_Right_14 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_15_Left_36 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_15_Right_15 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_16_Left_37 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_16_Right_16 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_17_Left_38 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_17_Right_17 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_18_Left_39 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_18_Right_18 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_19_Left_40 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_19_Right_19 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Left_22 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Right_1 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_20_Left_41 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_20_Right_20 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Left_23 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Right_2 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Left_24 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Right_3 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Left_25 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Right_4 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Left_26 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Right_5 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Left_27 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Right_6 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Left_28 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Right_7 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Left_29 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Right_8 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Left_30 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Right_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_43 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_45 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_65 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_67 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_68 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_69 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_70 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_71 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_72 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_73 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_15_74 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_15_75 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_76 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_77 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_17_78 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_17_79 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_80 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_81 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_82 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_83 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_47 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_84 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_85 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_86 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_20_87 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_61 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_63 ();
 sky130_fd_sc_hd__inv_2 _087_ (.A(net15),
    .Y(_066_));
 sky130_fd_sc_hd__inv_2 _088_ (.A(net6),
    .Y(_067_));
 sky130_fd_sc_hd__inv_2 _089_ (.A(net10),
    .Y(_068_));
 sky130_fd_sc_hd__inv_2 _090_ (.A(net26),
    .Y(_069_));
 sky130_fd_sc_hd__and3_2 _091_ (.A(net36),
    .B(net37),
    .C(net38),
    .X(_070_));
 sky130_fd_sc_hd__and2_2 _092_ (.A(net39),
    .B(_070_),
    .X(_071_));
 sky130_fd_sc_hd__and3_2 _093_ (.A(net40),
    .B(net41),
    .C(_071_),
    .X(_072_));
 sky130_fd_sc_hd__and2_2 _094_ (.A(net42),
    .B(_072_),
    .X(_073_));
 sky130_fd_sc_hd__a21boi_2 _095_ (.A1(net43),
    .A2(_073_),
    .B1_N(net1),
    .Y(_074_));
 sky130_fd_sc_hd__and2b_2 _096_ (.A_N(net36),
    .B(net45),
    .X(_000_));
 sky130_fd_sc_hd__o21ai_2 _097_ (.A1(net36),
    .A2(net37),
    .B1(net45),
    .Y(_075_));
 sky130_fd_sc_hd__a21oi_2 _098_ (.A1(net36),
    .A2(net37),
    .B1(_075_),
    .Y(_001_));
 sky130_fd_sc_hd__a21o_2 _099_ (.A1(net36),
    .A2(net37),
    .B1(net38),
    .X(_076_));
 sky130_fd_sc_hd__and3b_2 _100_ (.A_N(_070_),
    .B(net45),
    .C(_076_),
    .X(_002_));
 sky130_fd_sc_hd__or2_2 _101_ (.A(net39),
    .B(_070_),
    .X(_077_));
 sky130_fd_sc_hd__and3b_2 _102_ (.A_N(_071_),
    .B(net45),
    .C(_077_),
    .X(_003_));
 sky130_fd_sc_hd__o21ai_2 _103_ (.A1(net40),
    .A2(_071_),
    .B1(net45),
    .Y(_078_));
 sky130_fd_sc_hd__a21oi_2 _104_ (.A1(net40),
    .A2(_071_),
    .B1(_078_),
    .Y(_004_));
 sky130_fd_sc_hd__a31o_2 _105_ (.A1(net39),
    .A2(net40),
    .A3(_070_),
    .B1(net41),
    .X(_079_));
 sky130_fd_sc_hd__and3b_2 _106_ (.A_N(_072_),
    .B(_079_),
    .C(net1),
    .X(_005_));
 sky130_fd_sc_hd__o21ai_2 _107_ (.A1(net42),
    .A2(_072_),
    .B1(net1),
    .Y(_080_));
 sky130_fd_sc_hd__nor2_2 _108_ (.A(_073_),
    .B(_080_),
    .Y(_006_));
 sky130_fd_sc_hd__o21a_2 _109_ (.A1(net43),
    .A2(_073_),
    .B1(_074_),
    .X(_007_));
 sky130_fd_sc_hd__and2b_2 _110_ (.A_N(net8),
    .B(net16),
    .X(_081_));
 sky130_fd_sc_hd__nand2b_2 _111_ (.A_N(net7),
    .B(net15),
    .Y(_082_));
 sky130_fd_sc_hd__inv_2 _112_ (.A(_082_),
    .Y(_083_));
 sky130_fd_sc_hd__and2b_2 _113_ (.A_N(net9),
    .B(net17),
    .X(_084_));
 sky130_fd_sc_hd__nand2b_2 _114_ (.A_N(net9),
    .B(net17),
    .Y(_085_));
 sky130_fd_sc_hd__and2b_2 _115_ (.A_N(net16),
    .B(net8),
    .X(_086_));
 sky130_fd_sc_hd__and2b_2 _116_ (.A_N(net17),
    .B(net9),
    .X(_027_));
 sky130_fd_sc_hd__a2bb2o_2 _117_ (.A1_N(_067_),
    .A2_N(net14),
    .B1(_066_),
    .B2(net7),
    .X(_028_));
 sky130_fd_sc_hd__or4_2 _118_ (.A(_081_),
    .B(_084_),
    .C(_086_),
    .D(_027_),
    .X(_029_));
 sky130_fd_sc_hd__a2111o_2 _119_ (.A1(_067_),
    .A2(net14),
    .B1(_083_),
    .C1(_028_),
    .D1(_029_),
    .X(_030_));
 sky130_fd_sc_hd__and2b_2 _120_ (.A_N(net13),
    .B(net5),
    .X(_031_));
 sky130_fd_sc_hd__and2b_2 _121_ (.A_N(net12),
    .B(net4),
    .X(_032_));
 sky130_fd_sc_hd__nand2b_2 _122_ (.A_N(net5),
    .B(net13),
    .Y(_033_));
 sky130_fd_sc_hd__nand2b_2 _123_ (.A_N(net4),
    .B(net12),
    .Y(_034_));
 sky130_fd_sc_hd__or4bb_2 _124_ (.A(_031_),
    .B(_032_),
    .C_N(_033_),
    .D_N(_034_),
    .X(_035_));
 sky130_fd_sc_hd__nand2b_2 _125_ (.A_N(net11),
    .B(net3),
    .Y(_036_));
 sky130_fd_sc_hd__nand2b_2 _126_ (.A_N(net3),
    .B(net11),
    .Y(_037_));
 sky130_fd_sc_hd__o211ai_2 _127_ (.A1(net2),
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
 sky130_fd_sc_hd__a2111o_2 _133_ (.A1(net2),
    .A2(_068_),
    .B1(_030_),
    .C1(_035_),
    .D1(_038_),
    .X(_044_));
 sky130_fd_sc_hd__o21a_2 _134_ (.A1(_041_),
    .A2(_043_),
    .B1(_044_),
    .X(_045_));
 sky130_fd_sc_hd__xor2_2 _135_ (.A(net18),
    .B(_045_),
    .X(_046_));
 sky130_fd_sc_hd__and2_2 _136_ (.A(net45),
    .B(_046_),
    .X(_008_));
 sky130_fd_sc_hd__o2111a_2 _137_ (.A1(_041_),
    .A2(_043_),
    .B1(_044_),
    .C1(net18),
    .D1(net19),
    .X(_047_));
 sky130_fd_sc_hd__a21oi_2 _138_ (.A1(net18),
    .A2(_045_),
    .B1(net19),
    .Y(_048_));
 sky130_fd_sc_hd__nor2_2 _139_ (.A(_047_),
    .B(_048_),
    .Y(_049_));
 sky130_fd_sc_hd__and2_2 _140_ (.A(net45),
    .B(_049_),
    .X(_009_));
 sky130_fd_sc_hd__xor2_2 _141_ (.A(net20),
    .B(_047_),
    .X(_050_));
 sky130_fd_sc_hd__and2_2 _142_ (.A(net45),
    .B(_050_),
    .X(_010_));
 sky130_fd_sc_hd__and2_2 _143_ (.A(net20),
    .B(net21),
    .X(_051_));
 sky130_fd_sc_hd__nand2_2 _144_ (.A(_047_),
    .B(_051_),
    .Y(_052_));
 sky130_fd_sc_hd__a21o_2 _145_ (.A1(net20),
    .A2(_047_),
    .B1(net21),
    .X(_053_));
 sky130_fd_sc_hd__and2_2 _146_ (.A(_052_),
    .B(_053_),
    .X(_054_));
 sky130_fd_sc_hd__and3_2 _147_ (.A(net45),
    .B(_052_),
    .C(_053_),
    .X(_011_));
 sky130_fd_sc_hd__xnor2_2 _148_ (.A(net22),
    .B(_052_),
    .Y(_055_));
 sky130_fd_sc_hd__and2_2 _149_ (.A(net45),
    .B(_055_),
    .X(_012_));
 sky130_fd_sc_hd__and2_2 _150_ (.A(net22),
    .B(net23),
    .X(_056_));
 sky130_fd_sc_hd__nand3_2 _151_ (.A(_047_),
    .B(_051_),
    .C(_056_),
    .Y(_057_));
 sky130_fd_sc_hd__a31o_2 _152_ (.A1(net22),
    .A2(_047_),
    .A3(_051_),
    .B1(net23),
    .X(_058_));
 sky130_fd_sc_hd__and2_2 _153_ (.A(_057_),
    .B(_058_),
    .X(_059_));
 sky130_fd_sc_hd__and3_2 _154_ (.A(_074_),
    .B(_057_),
    .C(_058_),
    .X(_013_));
 sky130_fd_sc_hd__xnor2_2 _155_ (.A(net24),
    .B(_057_),
    .Y(_060_));
 sky130_fd_sc_hd__and2_2 _156_ (.A(net45),
    .B(_060_),
    .X(_014_));
 sky130_fd_sc_hd__nand2_2 _157_ (.A(net24),
    .B(net25),
    .Y(_061_));
 sky130_fd_sc_hd__a41o_2 _158_ (.A1(net24),
    .A2(_047_),
    .A3(_051_),
    .A4(_056_),
    .B1(net25),
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
 sky130_fd_sc_hd__and3_2 _164_ (.A(net43),
    .B(net1),
    .C(_073_),
    .X(_026_));
 sky130_fd_sc_hd__a22o_2 _165_ (.A1(net27),
    .A2(net45),
    .B1(_046_),
    .B2(_026_),
    .X(_017_));
 sky130_fd_sc_hd__a22o_2 _166_ (.A1(net28),
    .A2(net45),
    .B1(_049_),
    .B2(_026_),
    .X(_018_));
 sky130_fd_sc_hd__a22o_2 _167_ (.A1(net29),
    .A2(net45),
    .B1(_050_),
    .B2(_026_),
    .X(_019_));
 sky130_fd_sc_hd__a22o_2 _168_ (.A1(net30),
    .A2(net45),
    .B1(_054_),
    .B2(_026_),
    .X(_020_));
 sky130_fd_sc_hd__a22o_2 _169_ (.A1(net31),
    .A2(net45),
    .B1(_055_),
    .B2(_026_),
    .X(_021_));
 sky130_fd_sc_hd__a22o_2 _170_ (.A1(net32),
    .A2(_074_),
    .B1(_059_),
    .B2(_026_),
    .X(_022_));
 sky130_fd_sc_hd__a22o_2 _171_ (.A1(net33),
    .A2(net45),
    .B1(_060_),
    .B2(_026_),
    .X(_023_));
 sky130_fd_sc_hd__a22o_2 _172_ (.A1(net34),
    .A2(_074_),
    .B1(_063_),
    .B2(_026_),
    .X(_024_));
 sky130_fd_sc_hd__a32o_2 _173_ (.A1(_064_),
    .A2(_065_),
    .A3(_026_),
    .B1(_074_),
    .B2(net35),
    .X(_025_));
 sky130_fd_sc_hd__dfxtp_2 _174_ (.CLK(clknet_1_0__leaf_clk),
    .D(_000_),
    .Q(net36));
 sky130_fd_sc_hd__dfxtp_2 _175_ (.CLK(clknet_1_0__leaf_clk),
    .D(_001_),
    .Q(net37));
 sky130_fd_sc_hd__dfxtp_2 _176_ (.CLK(clknet_1_0__leaf_clk),
    .D(_002_),
    .Q(net38));
 sky130_fd_sc_hd__dfxtp_2 _177_ (.CLK(clknet_1_0__leaf_clk),
    .D(_003_),
    .Q(net39));
 sky130_fd_sc_hd__dfxtp_2 _178_ (.CLK(clknet_1_0__leaf_clk),
    .D(_004_),
    .Q(net40));
 sky130_fd_sc_hd__dfxtp_2 _179_ (.CLK(clknet_1_0__leaf_clk),
    .D(_005_),
    .Q(net41));
 sky130_fd_sc_hd__dfxtp_2 _180_ (.CLK(clknet_1_0__leaf_clk),
    .D(_006_),
    .Q(net42));
 sky130_fd_sc_hd__dfxtp_2 _181_ (.CLK(clknet_1_0__leaf_clk),
    .D(_007_),
    .Q(net43));
 sky130_fd_sc_hd__dfxtp_2 _182_ (.CLK(clknet_1_0__leaf_clk),
    .D(_008_),
    .Q(net18));
 sky130_fd_sc_hd__dfxtp_2 _183_ (.CLK(clknet_1_0__leaf_clk),
    .D(_009_),
    .Q(net19));
 sky130_fd_sc_hd__dfxtp_2 _184_ (.CLK(clknet_1_1__leaf_clk),
    .D(_010_),
    .Q(net20));
 sky130_fd_sc_hd__dfxtp_2 _185_ (.CLK(clknet_1_1__leaf_clk),
    .D(_011_),
    .Q(net21));
 sky130_fd_sc_hd__dfxtp_2 _186_ (.CLK(clknet_1_1__leaf_clk),
    .D(_012_),
    .Q(net22));
 sky130_fd_sc_hd__dfxtp_2 _187_ (.CLK(clknet_1_1__leaf_clk),
    .D(_013_),
    .Q(net23));
 sky130_fd_sc_hd__dfxtp_2 _188_ (.CLK(clknet_1_1__leaf_clk),
    .D(_014_),
    .Q(net24));
 sky130_fd_sc_hd__dfxtp_2 _189_ (.CLK(clknet_1_1__leaf_clk),
    .D(_015_),
    .Q(net25));
 sky130_fd_sc_hd__dfxtp_2 _190_ (.CLK(clknet_1_1__leaf_clk),
    .D(_016_),
    .Q(net26));
 sky130_fd_sc_hd__dfxtp_2 _191_ (.CLK(clknet_1_0__leaf_clk),
    .D(_017_),
    .Q(net27));
 sky130_fd_sc_hd__dfxtp_2 _192_ (.CLK(clknet_1_0__leaf_clk),
    .D(_018_),
    .Q(net28));
 sky130_fd_sc_hd__dfxtp_2 _193_ (.CLK(clknet_1_1__leaf_clk),
    .D(_019_),
    .Q(net29));
 sky130_fd_sc_hd__dfxtp_2 _194_ (.CLK(clknet_1_1__leaf_clk),
    .D(_020_),
    .Q(net30));
 sky130_fd_sc_hd__dfxtp_2 _195_ (.CLK(clknet_1_1__leaf_clk),
    .D(_021_),
    .Q(net31));
 sky130_fd_sc_hd__dfxtp_2 _196_ (.CLK(clknet_1_1__leaf_clk),
    .D(_022_),
    .Q(net32));
 sky130_fd_sc_hd__dfxtp_2 _197_ (.CLK(clknet_1_1__leaf_clk),
    .D(_023_),
    .Q(net33));
 sky130_fd_sc_hd__dfxtp_2 _198_ (.CLK(clknet_1_1__leaf_clk),
    .D(_024_),
    .Q(net34));
 sky130_fd_sc_hd__dfxtp_2 _199_ (.CLK(clknet_1_1__leaf_clk),
    .D(_025_),
    .Q(net35));
 sky130_fd_sc_hd__dfxtp_2 _200_ (.CLK(clknet_1_0__leaf_clk),
    .D(_026_),
    .Q(net44));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_0_clk (.A(clk),
    .X(clknet_0_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .X(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .X(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__clkbuf_4 clkload0 (.A(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input1 (.A(rst_n),
    .X(net1));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input10 (.A(threshold[0]),
    .X(net10));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input11 (.A(threshold[1]),
    .X(net11));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input12 (.A(threshold[2]),
    .X(net12));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input13 (.A(threshold[3]),
    .X(net13));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input14 (.A(threshold[4]),
    .X(net14));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input15 (.A(threshold[5]),
    .X(net15));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input16 (.A(threshold[6]),
    .X(net16));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input17 (.A(threshold[7]),
    .X(net17));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input2 (.A(sample_in[0]),
    .X(net2));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input3 (.A(sample_in[1]),
    .X(net3));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input4 (.A(sample_in[2]),
    .X(net4));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input5 (.A(sample_in[3]),
    .X(net5));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input6 (.A(sample_in[4]),
    .X(net6));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input7 (.A(sample_in[5]),
    .X(net7));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input8 (.A(sample_in[6]),
    .X(net8));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input9 (.A(sample_in[7]),
    .X(net9));
 sky130_fd_sc_hd__buf_4 max_cap45 (.A(_074_),
    .X(net45));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output18 (.A(net18),
    .X(event_count[0]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output19 (.A(net19),
    .X(event_count[1]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output20 (.A(net20),
    .X(event_count[2]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output21 (.A(net21),
    .X(event_count[3]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output22 (.A(net22),
    .X(event_count[4]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output23 (.A(net23),
    .X(event_count[5]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output24 (.A(net24),
    .X(event_count[6]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output25 (.A(net25),
    .X(event_count[7]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output26 (.A(net26),
    .X(event_count[8]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output27 (.A(net27),
    .X(result_count[0]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output28 (.A(net28),
    .X(result_count[1]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output29 (.A(net29),
    .X(result_count[2]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output30 (.A(net30),
    .X(result_count[3]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output31 (.A(net31),
    .X(result_count[4]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output32 (.A(net32),
    .X(result_count[5]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output33 (.A(net33),
    .X(result_count[6]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output34 (.A(net34),
    .X(result_count[7]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output35 (.A(net35),
    .X(result_count[8]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output36 (.A(net36),
    .X(window_count[0]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output37 (.A(net37),
    .X(window_count[1]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output38 (.A(net38),
    .X(window_count[2]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output39 (.A(net39),
    .X(window_count[3]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output40 (.A(net40),
    .X(window_count[4]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output41 (.A(net41),
    .X(window_count[5]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output42 (.A(net42),
    .X(window_count[6]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output43 (.A(net43),
    .X(window_count[7]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output44 (.A(net44),
    .X(window_done));
endmodule
