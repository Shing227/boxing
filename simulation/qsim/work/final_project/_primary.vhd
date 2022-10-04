library verilog;
use verilog.vl_types.all;
entity final_project is
    port(
        pin_name1       : out    vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ps2k_clk        : in     vl_logic;
        ps2k_data       : in     vl_logic;
        out2            : out    vl_logic_vector(1 downto 0);
        ps2_byte        : out    vl_logic_vector(7 downto 0);
        state           : out    vl_logic_vector(1 downto 0);
        state2          : out    vl_logic_vector(1 downto 0);
        temp_data       : out    vl_logic_vector(7 downto 0);
        test            : out    vl_logic_vector(4 downto 0)
    );
end final_project;
