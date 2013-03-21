library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity twoInputAdder is
    port ( 
        val1, val2: IN STD_LOGIC_VECTOR (31 downto 0);
        addRes: OUT STD_LOGIC_VECTOR (31 downto 0)
        );
end twoInputAdder;

architecture arch_twoInputAdder of twoInputAdder is
    
begin

  addRes <= std_logic_vector(signed(val1) + signed(val2));

end arch_twoInputAdder;