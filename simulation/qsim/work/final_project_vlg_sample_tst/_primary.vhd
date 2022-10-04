library verilog;
use verilog.vl_types.all;
entity final_project_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        ps2k_clk        : in     vl_logic;
        ps2k_data       : in     vl_logic;
        rst             : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end final_project_vlg_sample_tst;
