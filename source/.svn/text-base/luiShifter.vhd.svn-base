library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity luiShifter is
    port ( 
        imm16: IN STD_LOGIC_VECTOR (15 downto 0);
        shiftedOut: OUT STD_LOGIC_VECTOR (31 downto 0)
        );
end luiShifter;

architecture arch_luiShifter of luiShifter is
    
begin
  shiftedOut <= imm16 & "0000000000000000";

end arch_luiShifter;