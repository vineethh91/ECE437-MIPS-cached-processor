library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux21BitTo21Bit is
    port ( 
        muxEnable: IN STD_LOGIC;
          IDin_regDst: IN STD_LOGIC;
          IDin_extOp: IN STD_LOGIC;
          IDin_branch: IN STD_LOGIC;
          IDin_memRead: IN STD_LOGIC;
          IDin_memToReg: IN STD_LOGIC;
          IDin_ALUCtr: IN STD_LOGIC_VECTOR(3 downto 0);
          IDin_memWrite: IN STD_LOGIC;
          IDin_ALUSrc: IN STD_LOGIC;
          IDin_regWrite: IN STD_LOGIC;
          IDin_j_flag: IN STD_LOGIC;
          IDin_jal_flag: IN STD_LOGIC;
          IDin_jr_flag: IN STD_LOGIC;
          IDin_lui_flag: IN STD_LOGIC;
          IDin_slt_u_flag: IN STD_LOGIC;
          IDin_pc_write_enable: IN STD_LOGIC;
          IDin_bne_flag: IN STD_LOGIC;
          IDin_lw_flag: IN STD_LOGIC;
          IDin_halt_flag: IN STD_LOGIC;
          IDin_shamt_flag: IN STD_LOGIC;
          IDin_sign_flag: IN STD_LOGIC;

          
          IDout_regDst: out STD_LOGIC;
          IDout_extOp: out STD_LOGIC;
          IDout_branch: out STD_LOGIC;
          IDout_memRead: out STD_LOGIC;
          IDout_memToReg: out STD_LOGIC;
          IDout_ALUCtr: out STD_LOGIC_VECTOR(3 downto 0);
          IDout_memWrite: out STD_LOGIC;
          IDout_ALUSrc: out STD_LOGIC;
          IDout_regWrite: out STD_LOGIC;
          IDout_j_flag: out STD_LOGIC;
          IDout_jal_flag: out STD_LOGIC;
          IDout_jr_flag: out STD_LOGIC;
          IDout_lui_flag: out STD_LOGIC;
          IDout_slt_u_flag: out STD_LOGIC;
          IDout_pc_write_enable: out STD_LOGIC;
          IDout_bne_flag: out STD_LOGIC;
          IDout_lw_flag: out STD_LOGIC;
          IDout_halt_flag: out STD_LOGIC;
          IDout_shamt_flag: out STD_LOGIC;
          IDout_sign_flag: out STD_LOGIC

        );
end mux21BitTo21Bit;

architecture arch_mux21BitTo21Bit of mux21BitTo21Bit is

    
begin
          IDout_regDst <= IDin_regDst when (muxEnable = '0') else '0';
          IDout_extOp <= IDin_extOp when (muxEnable = '0') else '0';
          IDout_branch <= IDin_branch when (muxEnable = '0') else '0';
          IDout_memRead <= IDin_memRead when (muxEnable = '0') else '0';
          IDout_memToReg <= IDin_memToReg when (muxEnable = '0') else '0';
          IDout_ALUCtr <= IDin_ALUCtr when (muxEnable = '0') else "0000";
          IDout_memWrite <= IDin_memWrite when (muxEnable = '0') else '0';
          IDout_ALUSrc <= IDin_ALUSrc when (muxEnable = '0') else '0';
          IDout_regWrite <= IDin_regWrite when (muxEnable = '0') else '0';
          IDout_j_flag <= IDin_j_flag when (muxEnable = '0') else '0';
          IDout_jal_flag <= IDin_jal_flag when (muxEnable = '0') else '0';
          IDout_jr_flag <= IDin_jr_flag when (muxEnable = '0') else '0';
          IDout_lui_flag <= IDin_lui_flag when (muxEnable = '0') else '0';
          IDout_slt_u_flag <= IDin_slt_u_flag when (muxEnable = '0') else '0';
          IDout_pc_write_enable <= IDin_pc_write_enable when (muxEnable = '0') else '0';
          IDout_bne_flag <= IDin_bne_flag when (muxEnable = '0') else '0';
          IDout_lw_flag <= IDin_lw_flag when (muxEnable = '0') else '0';
          IDout_halt_flag <= IDin_halt_flag when (muxEnable = '0') else '0';
          IDout_shamt_flag <= IDin_shamt_flag when (muxEnable = '0') else '0';
          IDout_sign_flag <= IDin_sign_flag when (muxEnable = '0') else '0';


end arch_mux21BitTo21Bit;