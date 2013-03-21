library ieee;
use ieee.std_logic_1164.all;

entity forwardingUnit is
  port(
    MEM_regWrite : in std_logic;
    WB_regWrite : in std_logic;
    EX_memRead : in std_logic;
    MEM_registerBeingWrittenTo : in std_logic_vector(4 downto 0);
    WB_registerBeingWrittenTo : in std_logic_vector(4 downto 0);
    EX_Rs : in std_logic_vector(4 downto 0);
    EX_Rt : in std_logic_vector(4 downto 0);
    ALUSrc : in std_logic;
    
    MUXA_enable : out std_logic_vector(1 downto 0);
    MUXB_enable : out std_logic_vector(1 downto 0);
    MUXC_enable : out std_logic_vector(1 downto 0)
    );

end forwardingUnit;

architecture arch_forwardingUnit of forwardingUnit is
begin
    MUXA_enable <= --"10" when ((Ex_memRead = '1') and (MEM_registerBeingWrittenTo /= "00000") and (MEM_registerBeingWrittenTo = EX_Rs)) 
                   "10" when ((MEM_regWrite = '1') and (MEM_registerBeingWrittenTo /= "00000") and (MEM_registerBeingWrittenTo = EX_Rs)) 
                   else "01" when ((WB_regWrite = '1') and (WB_registerBeingWrittenTo /= "00000") and (not ((MEM_regWrite = '1') and (MEM_registerBeingWrittenTo /= "00000"))) and (MEM_registerBeingWrittenTo /= EX_Rs) and (WB_registerBeingWrittenTo = EX_Rs))
                   else "01" when ((WB_regWrite = '1') and (WB_registerBeingWrittenTo /= "00000") and (not ((MEM_regWrite = '0') and (MEM_registerBeingWrittenTo /= "00000"))) and (MEM_registerBeingWrittenTo /= EX_Rs) and (WB_registerBeingWrittenTo = EX_Rs)) ------ multAlgorithm.asm fails without this check. Why the fuck?
                   else "01" when ((WB_regWrite = '1') and (WB_registerBeingWrittenTo /= "00000") and (WB_registerBeingWrittenTo = EX_Rs))
                   else "00";
                     
    MUXB_enable <= "00" when (ALUSrc = '1')
                   else "10" when ((MEM_regWrite = '1') and (MEM_registerBeingWrittenTo /= "00000") and (MEM_registerBeingWrittenTo = EX_Rt)) 
                   else "01" when ((WB_regWrite = '1') and (WB_registerBeingWrittenTo /= "00000") and (not ((MEM_regWrite = '1') and (MEM_registerBeingWrittenTo /= "00000"))) and (MEM_registerBeingWrittenTo /= EX_Rt) and (WB_registerBeingWrittenTo = EX_Rt))
                   else "01" when ((WB_regWrite = '1') and (WB_registerBeingWrittenTo /= "00000") and (not ((MEM_regWrite = '0') and (MEM_registerBeingWrittenTo /= "00000"))) and (MEM_registerBeingWrittenTo /= EX_Rt) and (WB_registerBeingWrittenTo = EX_Rt)) ------ test.forwarding1.asm fails without this check. Why the fuck?
                   else "01" when ((WB_regWrite = '1') and (WB_registerBeingWrittenTo /= "00000") and (WB_registerBeingWrittenTo = EX_Rt))
                   else "00";

    MUXC_enable <= "10" when ((MEM_regWrite = '1') and (MEM_registerBeingWrittenTo /= "00000") and (MEM_registerBeingWrittenTo = EX_Rt))
                    else "01" when ((WB_regWrite = '1') and (WB_registerBeingWrittenTo /= "00000") and (WB_registerBeingWrittenTo = EX_Rt))
                    else "00";
                  
end arch_forwardingUnit;