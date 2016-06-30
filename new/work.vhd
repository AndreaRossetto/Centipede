library ieee;
use ieee.std_logic_1164.all;

package int_array is
  type int_array is array (0 to 200) of integer range -1 to 1000;
  type centi_array is array (0 to 10) of integer range -1 to 1000;
end package;
