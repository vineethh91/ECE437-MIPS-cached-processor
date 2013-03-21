library ieee;
use ieee.std_logic_1164.all;

entity pipelineRegister_MEM_WB is
  port(
    clk : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    regWriteEnable : in STD_LOGIC;


          MEM_WB : in STD_LOGIC_VECTOR(1 DOWNTO 0);
          
          MEM_regDst: in STD_LOGIC;
          MEM_extOp: in STD_LOGIC;
          MEM_branch: in STD_LOGIC;
          MEM_memRead: in STD_LOGIC;
          MEM_memToReg: in STD_LOGIC;
          MEM_ALUCtr: in STD_LOGIC_VECTOR(3 downto 0);
          MEM_memWrite: in STD_LOGIC;
          MEM_ALUSrc: in STD_LOGIC;
          MEM_regWrite: in STD_LOGIC;
          MEM_j_flag: in STD_LOGIC;
          MEM_jal_flag: in STD_LOGIC;
          MEM_jr_flag: in STD_LOGIC;
          MEM_lui_flag: in STD_LOGIC;
	  MEM_slt_u_flag: in STD_LOGIC;
	  MEM_pc_write_enable: in STD_LOGIC;
	  MEM_bne_flag: in STD_LOGIC;
	  MEM_lw_flag: in STD_LOGIC;
	  MEM_halt_flag: in STD_LOGIC;
	  MEM_shamt_flag: in STD_LOGIC;
	  MEM_sign_flag: in STD_LOGIC;

          MEM_luiShifted : in STD_LOGIC_VECTOR(31 downto 0);
          MEM_nextPC : in STD_LOGIC_VECTOR(31 downto 0);

          MEM_negativeFlag : in STD_LOGIC;
          MEM_ALURes : in STD_LOGIC_VECTOR(31 downto 0);

          MEM_readData : in STD_LOGIC_VECTOR(31 downto 0);

          MEM_jalFlagMuxOutput : IN STD_LOGIC_VECTOR(4 downto 0);
          
          WB_WB : out STD_LOGIC_VECTOR(1 DOWNTO 0);
          
          WB_regDst: out STD_LOGIC;
          WB_extOp: out STD_LOGIC;
          WB_branch: out STD_LOGIC;
          WB_memRead: out STD_LOGIC;
          WB_memToReg: out STD_LOGIC;
          WB_ALUCtr: out STD_LOGIC_VECTOR(3 downto 0);
          WB_memWrite: out STD_LOGIC;
          WB_ALUSrc: out STD_LOGIC;
          WB_regWrite: out STD_LOGIC;
          WB_j_flag: out STD_LOGIC;
          WB_jal_flag: out STD_LOGIC;
          WB_jr_flag: out STD_LOGIC;
          WB_lui_flag: out STD_LOGIC;
	  WB_slt_u_flag: out STD_LOGIC;
	  WB_pc_write_enable: out STD_LOGIC;
	  WB_bne_flag: out STD_LOGIC;
	  WB_lw_flag: out STD_LOGIC;
	  WB_halt_flag: out STD_LOGIC;
	  WB_shamt_flag: out STD_LOGIC;
	  WB_sign_flag: out STD_LOGIC;

          WB_luiShifted : out STD_LOGIC_VECTOR(31 downto 0);
          WB_nextPC : out STD_LOGIC_VECTOR(31 downto 0);

          WB_negativeFlag : out STD_LOGIC;
          WB_ALURes : out STD_LOGIC_VECTOR(31 downto 0);

          WB_readData : out STD_LOGIC_VECTOR(31 downto 0);
          WB_jalFlagMuxOutput : OUT STD_LOGIC_VECTOR(4 downto 0)
    );

end ;

architecture arch_pipelineRegister_MEM_WB of pipelineRegister_MEM_WB is
          signal present_val_WB : std_logic_vector(1 downto 0);
          signal next_val_WB : std_logic_vector(1 downto 0);

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
          
          signal present_val_luiShifted : std_logic_vector(31 downto 0);
          signal next_val_luiShifted : std_logic_vector(31 downto 0);
          signal present_val_nextPC : std_logic_vector(31 downto 0);
          signal next_val_nextPC : std_logic_vector(31 downto 0);

          signal present_val_negativeFlag : STD_LOGIC;
          signal next_val_negativeFlag : STD_LOGIC;
          signal present_val_ALURes : STD_LOGIC_VECTOR(31 downto 0);
          signal next_val_ALURes : STD_LOGIC_VECTOR(31 downto 0);
          signal present_val_readData : STD_LOGIC_VECTOR(31 downto 0);
          signal next_val_readData : STD_LOGIC_VECTOR(31 downto 0);
          signal present_val_jalFlagMuxOutput : STD_LOGIC_VECTOR(4 downto 0);
          signal next_val_jalFlagMuxOutput : STD_LOGIC_VECTOR(4 downto 0);
begin
  reg: process(clk, rst_n, regWriteEnable)
  begin
    if(rst_n = '0') then
          present_val_WB <= "00";

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
          
          present_val_luiShifted <= x"00000000";
          present_val_nextPC <= x"00000000";

          present_val_negativeFlag <= '0';
          present_val_ALURes <= x"00000000"; 
          present_val_readData <= x"00000000"; 
          
          present_val_jalFlagMuxOutput <= "00000";
          
    elsif(rising_edge(clk)) then
      if(regWriteEnable = '1') then
          present_val_WB <= next_val_WB;

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
          
          present_val_luiShifted <= next_val_luiShifted;
          present_val_nextPC <= next_val_nextPC;

          present_val_negativeFlag <= next_val_negativeFlag;
          present_val_ALURes <= next_val_ALURes; 
          present_val_readData <= next_val_readData; 
          
          present_val_jalFlagMuxOutput <= next_val_jalFlagMuxOutput;
      end if;
    end if;
  end process;
  
          next_val_WB <= MEM_WB;

          next_val_regDst <= MEM_regDst;
          next_val_extOp <= MEM_extOp;
          next_val_branch <= MEM_branch;
          next_val_memRead <= MEM_memRead;
          next_val_memToReg <= MEM_memToReg;
          next_val_ALUCtr <= MEM_ALUCtr;
          next_val_memWrite <= MEM_memWrite;
          next_val_ALUSrc <= MEM_ALUSrc;
          next_val_regWrite <= MEM_regWrite;
          next_val_j_flag <= MEM_j_flag;
          next_val_jal_flag <= MEM_jal_flag;
          next_val_jr_flag <= MEM_jr_flag;
          next_val_lui_flag <= MEM_lui_flag;
          next_val_slt_u_flag <= MEM_slt_u_flag;
          next_val_pc_write_enable <= MEM_pc_write_enable;
          next_val_bne_flag <= MEM_bne_flag;
          next_val_lw_flag <= MEM_lw_flag;
          next_val_halt_flag <= MEM_halt_flag;
          next_val_shamt_flag <= MEM_shamt_flag;
          next_val_sign_flag <= MEM_sign_flag;
       
          next_val_luiShifted <= MEM_luiShifted;
          next_val_nextPC <= MEM_nextPC;

          next_val_negativeFlag <= MEM_negativeFlag;
          next_val_ALURes <= MEM_ALURes; 
          next_val_readData <= MEM_readData; 

         next_val_jalFlagMuxOutput <= MEM_jalFlagMuxOutput;
         
          WB_WB <= present_val_WB;

          WB_regDst <= present_val_regDst;
          WB_extOp <= present_val_extOp;
          WB_branch <= present_val_branch;
          WB_memRead <= present_val_memRead;
          WB_memToReg <= present_val_memToReg;
          WB_ALUCtr <= present_val_ALUCtr;
          WB_memWrite <= present_val_memWrite;
          WB_ALUSrc <= present_val_ALUSrc;
          WB_regWrite <= present_val_regWrite;
          WB_j_flag <= present_val_j_flag;
          WB_jal_flag <= present_val_jal_flag;
          WB_jr_flag <= present_val_jr_flag;
          WB_lui_flag <= present_val_lui_flag;
          WB_slt_u_flag <= present_val_slt_u_flag;
          WB_pc_write_enable <= present_val_pc_write_enable;
          WB_bne_flag <= present_val_bne_flag;
          WB_lw_flag <= present_val_lw_flag;
          WB_halt_flag <= present_val_halt_flag;
          WB_shamt_flag <= present_val_shamt_flag;
          WB_sign_flag <= present_val_sign_flag;
        
          WB_luiShifted <= present_val_luiShifted;
          WB_nextPC <= present_val_nextPC;

          WB_negativeFlag <= present_val_negativeFlag;
          WB_ALURes <= present_val_ALURes; 
          WB_readData <= present_val_readData; 

          WB_jalFlagMuxOutput <= present_val_jalFlagMuxOutput;
end arch_pipelineRegister_MEM_WB;
