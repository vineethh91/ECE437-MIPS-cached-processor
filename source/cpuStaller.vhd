LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

entity cpuStaller is

   port ( 
    arbiterPipelineIFIDStall  : in std_logic;
    arbiterPipelineIDEXStall  : in std_logic;
    arbiterPipelineEXMEMStall : in std_logic;
    arbiterPipelineMEMWBStall : in std_logic;
    
    iMemWait : in std_logic;
    dMemWait : in std_logic;
    memState : in std_logic_vector(1 downto 0);

    hazardDetectionIFIDWriteEnable : in std_logic;
    hazardDetectionIDEXWriteEnable : in std_logic;
    hazardDetectionEXMEMWriteEnable : in std_logic;
    hazardDetectionMEMWBWriteEnable : in std_logic;

    hazardDetectionPCWriteEnable : in std_logic; 
 
    stallIFID  : out std_logic;
    stallIDEX  : out std_logic;
    stallEXMEM : out std_logic;
    stallMEMWB : out std_logic;
    stallPC    : out std_logic
	) ;

end cpuStaller;

architecture arch_cpuStaller of cpuStaller is
begin
    stallIFID <= '0' when (hazardDetectionIFIDWriteEnable = '0') else
                 '1' when (((arbiterPipelineIFIDStall = '1') and (hazardDetectionIFIDWriteEnable = '1')) or ((iMemWait = '0') and (dMemWait = '0')))
                 else '0';
                   
    stallIDEX <= '1' when (((arbiterPipelineIDEXStall = '1') and (hazardDetectionIDEXWriteEnable = '1')) or ((iMemWait = '0') and (dMemWait = '0')))
                 else '0';

    stallEXMEM <= '1' when (((arbiterPipelineEXMEMStall = '1') and (hazardDetectionEXMEMWriteEnable = '1')) or ((iMemWait = '0') and (dMemWait = '0')))
                 else '0';

    stallMEMWB <= '1' when (((arbiterPipelineMEMWBStall = '1') and (hazardDetectionMEMWBWriteEnable = '1')) or ((iMemWait = '0') and (dMemWait = '0')))
                 else '0';
                   
    stallPC <= iMemWait;
end arch_cpuStaller;

