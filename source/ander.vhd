library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ander is
    port ( 
        input1: IN STD_LOGIC;
        input2: IN STD_LOGIC;
        andOutput: OUT STD_LOGIC
        );
end ander;

architecture arch_ander of ander is

    
begin

  andOutput <= input1 and input2;

end arch_ander;