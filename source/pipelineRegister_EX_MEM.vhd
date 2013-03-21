library ieee;
use ieee.std_logic_1164.all;

entity pipelineRegister_EX_MEM is
  port(
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    regWriteEnable : in STD_LOGIC;
 
          EX_WB : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
          EX_M : IN STD_LOGIC;

          EX_regDst: IN STD_LOGIC;
          EX_extOp: IN STD_LOGIC;
          EX_branch: IN STD_LOGIC;
          EX_memRead: IN STD_LOGIC;
          EX_memToReg: IN STD_LOGIC;
          EX_ALUCtr: IN STD_LOGIC_VECTOR(3 downto 0);
          EX_memWrite: IN STD_LOGIC;
          EX_ALUSrc: IN STD_LOGIC;
          EX_regWrite: IN STD_LOGIC;
          EX_j_flag: IN STD_LOGIC;
          EX_jal_flag: IN STD_LOGIC;
          EX_jr_flag: IN STD_LOGIC;
          EX_lui_flag: IN STD_LOGIC;
          EX_slt_u_flag: IN STD_LOGIC;
          EX_pc_write_enable: IN STD_LOGIC;
          EX_bne_flag: IN STD_LOGIC;
          EX_lw_flag: IN STD_LOGIC;
          EX_halt_flag: IN STD_LOGIC;
          EX_shamt_flag: IN STD_LOGIC;
          EX_sign_flag: IN STD_LOGIC;
          
          EX_instruction: in STD_LOGIC_VECTOR(31 downto 0);
          EX_Data1 : IN STD_LOGIC_VECTOR(31 downto 0);
          EX_Data2 : IN STD_LOGIC_VECTOR(31 downto 0);
          EX_luiShifted : IN STD_LOGIC_VECTOR(31 downto 0);
          EX_nextPC : IN STD_LOGIC_VECTOR(31 downto 0);
          EX_branchAddr : IN STD_LOGIC_VECTOR(31 downto 0);
          EX_jumpAddr : IN STD_LOGIC_VECTOR(31 downto 0);

          EX_zeroFlagMuxed : IN STD_LOGIC;
          EX_negativeFlag : IN STD_LOGIC;
          EX_ALURes : IN STD_LOGIC_VECTOR(31 downto 0);

          EX_jalFlagMuxOutput : IN STD_LOGIC_VECTOR(4 downto 0);
          
          MEM_WB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
          MEM_M : OUT STD_LOGIC;
          
          MEM_regDst: out STD_LOGIC;
          MEM_extOp: out STD_LOGIC;
          MEM_branch: out STD_LOGIC;
          MEM_memRead: out STD_LOGIC;
          MEM_memToReg: out STD_LOGIC;
          MEM_ALUCtr: out STD_LOGIC_VECTOR(3 downto 0);
          MEM_memWrite: out STD_LOGIC;
          MEM_ALUSrc: out STD_LOGIC;
          MEM_regWrite: out STD_LOGIC;
          MEM_j_flag: out STD_LOGIC;
          MEM_jal_flag: out STD_LOGIC;
          MEM_jr_flag: out STD_LOGIC;
          MEM_lui_flag: out STD_LOGIC;
       	  MEM_slt_u_flag: out STD_LOGIC;
       	  MEM_pc_write_enable: out STD_LOGIC;
       	  MEM_bne_flag: out STD_LOGIC;
       	  MEM_lw_flag: out STD_LOGIC;
       	  MEM_halt_flag: out STD_LOGIC;
       	  MEM_shamt_flag: out STD_LOGIC;
       	  MEM_sign_flag: out STD_LOGIC;

          MEM_instruction: OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_Data1 : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_Data2 : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_luiShifted : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_nextPC : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_branchAddr : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_jumpAddr : OUT STD_LOGIC_VECTOR(31 downto 0);	

          MEM_zeroFlagMuxed : OUT STD_LOGIC;
          MEM_negativeFlag : OUT STD_LOGIC;
          MEM_ALURes : OUT STD_LOGIC_VECTOR(31 downto 0);
          MEM_jalFlagMuxOutput : OUT STD_LOGIC_VECTOR(4 downto 0)
    );

end pipelineRegister_EX_MEM;

architecture arch_pipelineRegister_EX_MEM of pipelineRegister_EX_MEM is
          signal present_val_WB : std_logic_vector(1 downto 0);
          signal next_val_WB : std_logic_vector(1 downto 0);
          signal present_val_M : std_logic;
          signal next_val_M : std_logic;

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

          signal present_val_zeroFlagMuxed : STD_LOGIC;
          signal next_val_zeroFlagMuxed : STD_LOGIC;
          signal present_val_negativeFlag : STD_LOGIC;
          signal next_val_negativeFlag : STD_LOGIC;
          signal present_val_ALURes : STD_LOGIC_VECTOR(31 downto 0);
          signal next_val_ALURes : STD_LOGIC_VECTOR(31 downto 0);
          signal present_val_jalFlagMuxOutput : STD_LOGIC_VECTOR(4 downto 0);
          signal next_val_jalFlagMuxOutput : STD_LOGIC_VECTOR(4 downto 0);
begin
  reg: process(clk, rst_n, regWriteEnable)
  begin
    if(rst_n = '0') then
          present_val_WB <= "00";
          present_val_M <= '0';

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

          present_val_zeroFlagMuxed <= '0';
          present_val_negativeFlag <= '0';
          present_val_ALURes <= x"00000000"; 
          present_val_jalFlagMuxOutput <= "00000";
          
    elsif(rising_edge(clk)) then
      if(regWriteEnable = '1') then
          present_val_WB <= next_val_WB;
          present_val_M <= next_val_M;

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

          present_val_zeroFlagMuxed <= next_val_zeroFlagMuxed;
          present_val_negativeFlag <= next_val_negativeFlag;
          present_val_ALURes <= next_val_ALURes; 
          
          present_val_jalFlagMuxOutput <= next_val_jalFlagMuxOutput;
          
      end if;
    end if;
  end process;
  
          next_val_WB <= EX_WB;
          next_val_M <= EX_M;

          next_val_regDst <= EX_regDst;
          next_val_extOp <= EX_extOp;
          next_val_branch <= EX_branch;
          next_val_memRead <= EX_memRead;
          next_val_memToReg <= EX_memToReg;
          next_val_ALUCtr <= EX_ALUCtr;
          next_val_memWrite <= EX_memWrite;
          next_val_ALUSrc <= EX_ALUSrc;
          next_val_regWrite <= EX_regWrite;
          next_val_j_flag <= EX_j_flag;
          next_val_jal_flag <= EX_jal_flag;
          next_val_jr_flag <= EX_jr_flag;
          next_val_lui_flag <= EX_lui_flag;
          next_val_slt_u_flag <= EX_slt_u_flag;
          next_val_pc_write_enable <= EX_pc_write_enable;
          next_val_bne_flag <= EX_bne_flag;
          next_val_lw_flag <= EX_lw_flag;
          next_val_halt_flag <= EX_halt_flag;
          next_val_shamt_flag <= EX_shamt_flag;
          next_val_sign_flag <= EX_sign_flag;
       
          next_val_instruction <= EX_instruction;
          next_val_Data1 <= EX_Data1;
          next_val_Data2 <= EX_Data2;
          next_val_luiShifted <= EX_luiShifted;
          next_val_nextPC <= EX_nextPC;
          next_val_branchAddr <= EX_branchAddr;
          next_val_jumpAddr <= EX_jumpAddr;

          next_val_zeroFlagMuxed <= EX_zeroFlagMuxed;
          next_val_negativeFlag <= EX_negativeFlag;
          next_val_ALURes <= EX_ALURes; 

          next_val_jalFlagMuxOutput <= EX_jalFlagMuxOutput;
          
          MEM_WB <= present_val_WB;
          MEM_M <= present_val_M;

          MEM_regDst <= present_val_regDst;
          MEM_extOp <= present_val_extOp;
          MEM_branch <= present_val_branch;
          MEM_memRead <= present_val_memRead;
          MEM_memToReg <= present_val_memToReg;
          MEM_ALUCtr <= present_val_ALUCtr;
          MEM_memWrite <= present_val_memWrite;
          MEM_ALUSrc <= present_val_ALUSrc;
          MEM_regWrite <= present_val_regWrite;
          MEM_j_flag <= present_val_j_flag;
          MEM_jal_flag <= present_val_jal_flag;
          MEM_jr_flag <= present_val_jr_flag;
          MEM_lui_flag <= present_val_lui_flag;
          MEM_slt_u_flag <= present_val_slt_u_flag;
          MEM_pc_write_enable <= present_val_pc_write_enable;
          MEM_bne_flag <= present_val_bne_flag;
          MEM_lw_flag <= present_val_lw_flag;
          MEM_halt_flag <= present_val_halt_flag;
          MEM_shamt_flag <= present_val_shamt_flag;
          MEM_sign_flag <= present_val_sign_flag;
         
          MEM_instruction <= present_val_instruction;
          MEM_Data1 <= present_val_Data1;
          MEM_Data2 <= present_val_Data2;
          MEM_luiShifted <= present_val_luiShifted;
          MEM_nextPC <= present_val_nextPC;
          MEM_branchAddr <= present_val_branchAddr;
          MEM_jumpAddr <= present_val_jumpAddr;

          MEM_zeroFlagMuxed <= present_val_zeroFlagMuxed;
          MEM_negativeFlag <= present_val_negativeFlag;
          MEM_ALURes <= present_val_ALURes; 

          MEM_jalFlagMuxOutput <= present_val_jalFlagMuxOutput;
          
end arch_pipelineRegister_EX_MEM;
