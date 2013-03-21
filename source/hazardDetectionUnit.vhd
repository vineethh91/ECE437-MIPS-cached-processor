library ieee;
use ieee.std_logic_1164.all;

entity hazardDetectionUnit is
  port(
      EX_Rt : in std_logic_vector(4 downto 0);
      ID_Rs : in std_logic_vector(4 downto 0);
      ID_Rt : in std_logic_vector(4 downto 0);
      EX_memRead : in std_logic;
      
      IFID_writeEnable : out std_logic;
      IDEX_writeEnable : out std_logic;
      EXMEM_writeEnable : out std_logic;
      MEMWB_writeEnable : out std_logic;     -- to the pipeline registers

      pcWriteEnable : out std_logic;         -- go straight to the pcWriteEnableControl block, add code there to handle this case
      disableControlSignals : out std_logic  -- add code in controller.vhd to zero everything out if this is high
    );

end hazardDetectionUnit;

architecture arch_hazardDetectionUnit of hazardDetectionUnit is
begin
  IFID_writeEnable <= '0' when ((EX_memRead = '1') and ((EX_Rt = ID_Rs) or (EX_Rt = ID_Rt))) else '1';
  IDEX_writeEnable <= '1';--'0' when ((EX_memRead = '1') and ((EX_Rt = ID_Rs) or (EX_Rt = ID_Rt))) else '1';
  EXMEM_writeEnable <= '1';
  MEMWB_writeEnable <= '1';

  
  pcWriteEnable <= '0' when ((EX_memRead = '1') and ((EX_Rt = ID_Rs) or (EX_Rt = ID_Rt))) else '1';
  
  disableControlSignals <= '1' when ((EX_memRead = '1') and ((EX_Rt = ID_Rs) or (EX_Rt = ID_Rt))) else '0';  -- inject NOP in case theres a LW followed by a use
  
end arch_hazardDetectionUnit;