library ieee;
use ieee.std_logic_1164.all;

entity pipelineRegister_ID_EX is
  port(
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    regWriteEnable : in STD_LOGIC;
    
          ID_WB : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
          ID_M : IN STD_LOGIC;
          ID_EX : IN STD_LOGIC;

          ID_regDst: IN STD_LOGIC;
          ID_extOp: IN STD_LOGIC;
          ID_branch: IN STD_LOGIC;
          ID_memRead: IN STD_LOGIC;
          ID_memToReg: IN STD_LOGIC;
          ID_ALUCtr: IN STD_LOGIC_VECTOR(3 downto 0);
          ID_memWrite: IN STD_LOGIC;
          ID_ALUSrc: IN STD_LOGIC;
          ID_regWrite: IN STD_LOGIC;
          ID_j_flag: IN STD_LOGIC;
          ID_jal_flag: IN STD_LOGIC;
          ID_jr_flag: IN STD_LOGIC;
          ID_lui_flag: IN STD_LOGIC;
          ID_slt_u_flag: IN STD_LOGIC;
          ID_pc_write_enable: IN STD_LOGIC;
          ID_bne_flag: IN STD_LOGIC;
          ID_lw_flag: IN STD_LOGIC;
          ID_halt_flag: IN STD_LOGIC;
          ID_shamt_flag: IN STD_LOGIC;
          ID_sign_flag: IN STD_LOGIC;
          
          ID_instruction: in STD_LOGIC_VECTOR(31 downto 0);
          ID_Data1 : IN STD_LOGIC_VECTOR(31 downto 0);
          ID_Data2 : IN STD_LOGIC_VECTOR(31 downto 0);
          ID_luiShifted : IN STD_LOGIC_VECTOR(31 downto 0);
          ID_nextPC : IN STD_LOGIC_VECTOR(31 downto 0);
          ID_branchAddr : IN STD_LOGIC_VECTOR(31 downto 0);
          ID_jumpAddr : IN STD_LOGIC_VECTOR(31 downto 0);
          
          EX_WB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          EX_M : OUT STD_LOGIC;
          EX_EX : OUT STD_LOGIC;
          
          EX_regDst: out STD_LOGIC;
          EX_extOp: out STD_LOGIC;
          EX_branch: out STD_LOGIC;
          EX_memRead: out STD_LOGIC;
          EX_memToReg: out STD_LOGIC;
          EX_ALUCtr: out STD_LOGIC_VECTOR(3 downto 0);
          EX_memWrite: out STD_LOGIC;
          EX_ALUSrc: out STD_LOGIC;
          EX_regWrite: out STD_LOGIC;
          EX_j_flag: out STD_LOGIC;
          EX_jal_flag: out STD_LOGIC;
          EX_jr_flag: out STD_LOGIC;
          EX_lui_flag: out STD_LOGIC;
          EX_slt_u_flag: out STD_LOGIC;
          EX_pc_write_enable: out STD_LOGIC;
          EX_bne_flag: out STD_LOGIC;
          EX_lw_flag: out STD_LOGIC;
          EX_halt_flag: out STD_LOGIC;
          EX_shamt_flag: OUT STD_LOGIC;
          EX_sign_flag: out STD_LOGIC;

          EX_instruction: OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_Data1 : OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_Data2 : OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_luiShifted : OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_nextPC : OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_branchAddr : OUT STD_LOGIC_VECTOR(31 downto 0);
          EX_jumpAddr : OUT STD_LOGIC_VECTOR(31 downto 0)	
    );

end pipelineRegister_ID_EX;

architecture arch_pipelineRegister_ID_EX of pipelineRegister_ID_EX is
          signal present_val_WB : std_logic_vector(1 downto 0);
          signal next_val_WB : std_logic_vector(1 downto 0);
          signal present_val_M : std_logic;
          signal next_val_M : std_logic;
          signal present_val_EX : std_logic;
          signal next_val_EX : std_logic;

          signal present_val_regDst : std_logic;
          signal next_val_regDst : std_logic;
          signal present_val_extOp : std_logic;
          signal next_val_extOp : std_logic;
          signal present_val_branch : std_logic;
          signal next_val_branch : std_logic;
          signal present_val_memRead : std_logic;
          signal next_val_memRead : std_logic;
          signal present_val_memToReg : std_logic;
          signal next_val_memToReg : std_logic;
          signal present_val_ALUCtr : std_logic_vector(3 downto 0);
          signal next_val_ALUCtr : std_logic_vector(3 downto 0);
          signal present_val_memWrite : std_logic;
          signal next_val_memWrite : std_logic;
          signal present_val_ALUSrc : std_logic;
          signal next_val_ALUSrc : std_logic;
          signal present_val_regWrite : std_logic;
          signal next_val_regWrite : std_logic;
          signal present_val_j_flag : std_logic;
          signal next_val_j_flag : std_logic;
          signal present_val_jal_flag : std_logic;
          signal next_val_jal_flag : std_logic;
          signal present_val_jr_flag : std_logic;
          signal next_val_jr_flag : std_logic;
          signal present_val_lui_flag : std_logic;
          signal next_val_lui_flag : std_logic;
          signal present_val_slt_u_flag : std_logic;
          signal next_val_slt_u_flag : std_logic;
          signal present_val_pc_write_enable : std_logic;
          signal next_val_pc_write_enable : std_logic;
          signal present_val_bne_flag : std_logic;
          signal next_val_bne_flag : std_logic;
          signal present_val_lw_flag : std_logic;
          signal next_val_lw_flag : std_logic;
          signal present_val_halt_flag : std_logic;
          signal next_val_halt_flag : std_logic;
          signal present_val_shamt_flag : std_logic;
          signal next_val_shamt_flag : std_logic;
          signal present_val_sign_flag : std_logic;
          signal next_val_sign_flag : std_logic;
          
          signal present_val_instruction : std_logic_vector(31 downto 0);
          signal next_val_instruction : std_logic_vector(31 downto 0);
          signal present_val_Data1 : std_logic_vector(31 downto 0);
          signal next_val_Data1 : std_logic_vector(31 downto 0);
          signal present_val_Data2 : std_logic_vector(31 downto 0);
          signal next_val_Data2 : std_logic_vector(31 downto 0);
          signal present_val_luiShifted : std_logic_vector(31 downto 0);
          signal next_val_luiShifted : std_logic_vector(31 downto 0);
          signal present_val_nextPC : std_logic_vector(31 downto 0);
          signal next_val_nextPC : std_logic_vector(31 downto 0);
          signal present_val_branchAddr : std_logic_vector(31 downto 0);
          signal next_val_branchAddr : std_logic_vector(31 downto 0);
          signal present_val_jumpAddr : std_logic_vector(31 downto 0);
          signal next_val_jumpAddr : std_logic_vector(31 downto 0);
begin
  reg: process(clk, rst_n, regWriteEnable)
  begin
    if(rst_n = '0') then
          present_val_WB <= "00";
          present_val_M <= '0';
          present_val_EX <= '0';

          present_val_regDst <= '0';
          present_val_extOp <= '0';
          present_val_branch <= '0';
          present_val_memRead <= '0';
          present_val_memToReg <= '0';
          present_val_ALUCtr <= "0000";
          present_val_memWrite <= '0';
          present_val_ALUSrc <= '0';
          present_val_regWrite <= '0';
          present_val_j_flag <= '0';
          present_val_jal_flag <= '0';
          present_val_jr_flag <= '0';
          present_val_lui_flag <= '0';
          present_val_slt_u_flag <= '0';
          present_val_pc_write_enable <= '0';
          present_val_bne_flag <= '0';
          present_val_lw_flag <= '0';
          present_val_halt_flag <= '0';
          present_val_shamt_flag <= '0';
          present_val_sign_flag <= '0';
          
          present_val_instruction <= x"00000000";
          present_val_Data1 <= x"00000000";
          present_val_Data2 <= x"00000000";
          present_val_luiShifted <= x"00000000";
          present_val_nextPC <= x"00000000";
          present_val_branchAddr <= x"00000000";
          present_val_jumpAddr <= x"00000000";
          
    elsif(rising_edge(clk)) then
      if(regWriteEnable = '1') then
          present_val_WB <= next_val_WB;
          present_val_M <= next_val_M;
          present_val_EX <= next_val_EX;

          present_val_regDst <= next_val_regDst;
          present_val_extOp <= next_val_extOp;
          present_val_branch <= next_val_branch;
          present_val_memRead <= next_val_memRead;
          present_val_memToReg <= next_val_memToReg;
          present_val_ALUCtr <= next_val_ALUCtr;
          present_val_memWrite <= next_val_memWrite;
          present_val_ALUSrc <= next_val_ALUSrc;
          present_val_regWrite <= next_val_regWrite;
          present_val_j_flag <= next_val_j_flag;
          present_val_jal_flag <= next_val_jal_flag;
          present_val_jr_flag <= next_val_jr_flag;
          present_val_lui_flag <= next_val_lui_flag;
          present_val_slt_u_flag <= next_val_slt_u_flag;
          present_val_pc_write_enable <= next_val_pc_write_enable;
          present_val_bne_flag <= next_val_bne_flag;
          present_val_lw_flag <= next_val_lw_flag;
          present_val_halt_flag <= next_val_halt_flag;
          present_val_shamt_flag <= next_val_shamt_flag;
          present_val_sign_flag <= next_val_sign_flag;
          
          present_val_instruction <= next_val_instruction;
          present_val_Data1 <= next_val_Data1;
          present_val_Data2 <= next_val_Data2;
          present_val_luiShifted <= next_val_luiShifted;
          present_val_nextPC <= next_val_nextPC;
          present_val_branchAddr <= next_val_branchAddr;
          present_val_jumpAddr <= next_val_jumpAddr;
          
      end if;
    end if;
  end process;
  
          next_val_WB <= ID_WB;
          next_val_M <= ID_M;
          next_val_EX <= ID_EX;

          next_val_regDst <= ID_regDst;
          next_val_extOp <= ID_extOp;
          next_val_branch <= ID_branch;
          next_val_memRead <= ID_memRead;
          next_val_memToReg <= ID_memToReg;
          next_val_ALUCtr <= ID_ALUCtr;
          next_val_memWrite <= ID_memWrite;
          next_val_ALUSrc <= ID_ALUSrc;
          next_val_regWrite <= ID_regWrite;
          next_val_j_flag <= ID_j_flag;
          next_val_jal_flag <= ID_jal_flag;
          next_val_jr_flag <= ID_jr_flag;
          next_val_lui_flag <= ID_lui_flag;
          next_val_slt_u_flag <= ID_slt_u_flag;
          next_val_pc_write_enable <= ID_pc_write_enable;
          next_val_bne_flag <= ID_bne_flag;
          next_val_lw_flag <= ID_lw_flag;
          next_val_halt_flag <= ID_halt_flag;
          next_val_shamt_flag <= ID_shamt_flag;
          next_val_sign_flag <= ID_sign_flag;
       
          next_val_instruction <= ID_instruction;
          next_val_Data1 <= ID_Data1;
          next_val_Data2 <= ID_Data2;
          next_val_luiShifted <= ID_luiShifted;
          next_val_nextPC <= ID_nextPC;
          next_val_branchAddr <= ID_branchAddr;
          next_val_jumpAddr <= ID_jumpAddr;

          EX_WB <= present_val_WB;
          EX_M <= present_val_M;
          EX_EX <= present_val_EX;

          EX_regDst <= present_val_regDst;
          EX_extOp <= present_val_extOp;
          EX_branch <= present_val_branch;
          EX_memRead <= present_val_memRead;
          EX_memToReg <= present_val_memToReg;
          EX_ALUCtr <= present_val_ALUCtr;
          EX_memWrite <= present_val_memWrite;
          EX_ALUSrc <= present_val_ALUSrc;
          EX_regWrite <= present_val_regWrite;
          EX_j_flag <= present_val_j_flag;
          EX_jal_flag <= present_val_jal_flag;
          EX_jr_flag <= present_val_jr_flag;
          EX_lui_flag <= present_val_lui_flag;
          EX_slt_u_flag <= present_val_slt_u_flag;
          EX_pc_write_enable <= present_val_pc_write_enable;
          EX_bne_flag <= present_val_bne_flag;
          EX_lw_flag <= present_val_lw_flag;
          EX_halt_flag <= present_val_halt_flag;
          EX_shamt_flag <= present_val_shamt_flag;
          EX_sign_flag <= present_val_sign_flag;
          
          EX_instruction <= present_val_instruction;
          EX_Data1 <= present_val_Data1;
          EX_Data2 <= present_val_Data2;
          EX_luiShifted <= present_val_luiShifted;
          EX_nextPC <= present_val_nextPC;
          EX_branchAddr <= present_val_branchAddr;
          EX_jumpAddr <= present_val_jumpAddr;
  
end arch_pipelineRegister_ID_EX;
