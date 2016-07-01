library ieee;
use ieee.std_logic_1164.all;

package int_array is
  type coord_type is record
		x  : integer range -1 to 1000;
		y  : integer range -1 to 1000;
  end record;
  type int_array is array (0 to 50) of coord_type;
  type centi_array is array (0 to 10) of coord_type;
end package;
 