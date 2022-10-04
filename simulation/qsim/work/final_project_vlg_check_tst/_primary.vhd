library verilog;
use verilog.vl_types.all;
entity final_project_vlg_check_tst is
    port(
        out2            : in     vl_logic_vector(1 downto 0);
        pin_name1       : in     vl_logic;
        ps2_byte        : in     vl_logic_vector(7 downto 0);
        state           : in     vl_logic_vector(1 downto 0);
        state2          : in     vl_logic_vector(1 downto 0);
        temp_data       : in     vl_logic_vector(7 downto 0);
        test            : in     vl_logic_vector(4 downto 0);
        sampler_rx      : in     vl_logic
    );
end final_project_vlg_check_tst;
