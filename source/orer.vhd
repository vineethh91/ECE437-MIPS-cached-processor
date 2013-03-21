library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity orer is
    port ( 
        input1: IN STD_LOGIC;
        input2: IN STD_LOGIC;
        orOutput: OUT STD_LOGIC
        );
end orer;

architecture arch_orer of orer is

    
begin

  orOutput <= input1 or input2;

end arch_orer;