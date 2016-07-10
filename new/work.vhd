library ieee;
use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

package centiarray is

 type coord_type is record
	x  : integer range -1 to 1000;
	y  : integer range -1 to 1000;
 end record;	

 type centi_array is array (0 to 7) of coord_type;
 type mush_array is array (0 to 30) of coord_type;
 
end package;


 