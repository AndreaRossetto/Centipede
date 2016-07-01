library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all; 

package LFSR_pkg is

	component LFSR_GENERIC is

	generic(Width: positive := 8);		-- length of pseudo-random sequence
	port 	(	clock: in std_logic;
				resetn: in std_logic;	-- active low reset
				load: in std_logic;		-- active high load
				seed: in std_logic_vector(Width-1 downto 0);	-- parallel seed input
		 		parallel_out: out std_logic_vector(Width-1 downto 0); -- parallel data out
				serial_out: out std_logic	-- serial data out (From last shift register)
			);

	end component LFSR_GENERIC;

end package LFSR_pkg;