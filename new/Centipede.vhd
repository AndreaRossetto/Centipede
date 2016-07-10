LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.centiarray.ALL;
entity Centipede is
    port(
		clk_50Mhz		: IN  STD_LOGIC;
		cheatKey			: IN  STD_LOGIC;
		PS2_CLK			: IN  STD_LOGIC;
		PS2_DAT			: IN  STD_LOGIC;
			
		hsync,
		vsync				: OUT  STD_LOGIC;		
		red, 
		green,
		blue				: OUT STD_LOGIC_VECTOR(3 downto 0);				
		leds1 			: OUT STD_LOGIC_VECTOR(6 downto 0); 
		leds2 			: OUT STD_LOGIC_VECTOR(6 downto 0);
		leds3 			: OUT STD_LOGIC_VECTOR(6 downto 0); 
		leds4 			: OUT STD_LOGIC_VECTOR(6 downto 0)
		);
end Centipede;

architecture Behavioral of Centipede is
			
	component Centipede_CLKGENERATOR is
	port(
		clock				: IN  STD_LOGIC;
		clock_mezzi		: OUT STD_LOGIC
		);
	end component;

	component Centipede_KEYBOARD is
	port(
		clk				: IN  STD_LOGIC;
		keyboardClock	: IN STD_LOGIC;
		keyboardData	: IN STD_LOGIC;
		keyCode			: OUT STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;

	component Centipede_CONTROL is
	port(
		clk					: IN STD_LOGIC;
		cheat					: IN STD_LOGIC;
		
		keyboardData		: IN STD_LOGIC_VECTOR (7 downto 0);
		goingReady			: IN STD_LOGIC;
		movepadRight		: OUT STD_LOGIC;
		movepadLeft			: OUT STD_LOGIC;
		shoot 				: OUT STD_LOGIC;
		reloadBullet		: IN STD_LOGIC;
		moveSnake			: OUT STD_LOGIC;
		enable				: OUT STD_LOGIC;
		boot					: OUT STD_LOGIC;
		pauseBlinking		: OUT STD_LOGIC;
		readyBlinking		: OUT STD_LOGIC
		);
	end component;

	component Centipede_DATA is
	port(
		clk					: IN STD_LOGIC;
		padGoRight			: IN STD_LOGIC;
		padGoLeft			: IN STD_LOGIC;
		shoot 				: IN STD_LOGIC;
		reloadBullet		: OUT STD_LOGIC;
		moveSnake			: IN STD_LOGIC;
		enable				: IN STD_LOGIC;
		bootstrap			: IN STD_LOGIC;
		score2				: OUT INTEGER range -9 to 9;
		score1				: OUT INTEGER range -9 to 9;
		score0				: OUT INTEGER range -9 to 9;
		centipede			: OUT centi_array;
		bulletPositionX	: OUT INTEGER range 0 to 1000;
		bulletPositionY	: OUT INTEGER range 0 to 500;
		obstacles			: OUT mush_array;
		padLCorner			: OUT INTEGER range 0 to 1000;
		padRCorner			: OUT INTEGER range 0 to 1000;
		northBorder			: OUT INTEGER range 0 to 500;
		southBorder			: OUT INTEGER range 0 to 500;
		westBorder			: OUT INTEGER range 0 to 1000;
		eastBorder			: OUT INTEGER range 0 to 1000;
		goingReady			: OUT STD_LOGIC;
		victory				: OUT STD_LOGIC;
		gameOver				: OUT STD_LOGIC
		);
	end component;

	component Centipede_VIEW is
	port(
		clk					: IN STD_LOGIC;

		bulletPositionX	: IN INTEGER range 0 to 1000;
		bulletPositionY	: IN INTEGER range 0 to 500;
		obstacles			: IN mush_array;
		centipede			: IN centi_array;
		padLCorner			: IN INTEGER range 0 to 1000;
		padRCorner			: IN INTEGER range 0 to 1000;
		northBorder			: IN INTEGER range 0 to 500;
		southBorder			: IN INTEGER range 0 to 500;
		westBorder			: IN INTEGER range 0 to 1000;
		eastBorder			: IN INTEGER range 0 to 1000;
		score2				: IN INTEGER range -9 to 9;
		score1				: IN INTEGER range -9 to 9;
		score0				: IN INTEGER range -9 to 9;
		bootstrap			: IN STD_LOGIC;
		pauseBlinking		: IN STD_LOGIC;
		readyBlinking		: IN STD_LOGIC;
		victory				: IN STD_LOGIC;
		gameOver				: IN STD_LOGIC;
		
		hsync,
		vsync					: OUT STD_LOGIC;
		red, 
		green,
		blue					: OUT STD_LOGIC_VECTOR(3 downto 0);	
				
		leds1 				: OUT STD_LOGIC_VECTOR(6 downto 0); 
		leds2 				: out STD_LOGIC_VECTOR(6 downto 0); 
		leds3 				: out STD_LOGIC_VECTOR(6 downto 0); 
		leds4 				: out STD_LOGIC_VECTOR(6 downto 0) 	
		);
	end component;

signal clock_25Mhz		: STD_LOGIC;
signal keyCode				: STD_LOGIC_VECTOR(7 downto 0);			
signal goingReady			: STD_LOGIC;
signal movepadRight		: STD_LOGIC;
signal movepadLeft		: STD_LOGIC;
signal moveSnake			: STD_LOGIC;
signal shoot				: STD_LOGIC;
signal reloadBullet		: STD_LOGIC;
signal enable				: STD_LOGIC;
signal boot					: STD_LOGIC;
signal gameOver			: STD_LOGIC;
signal pauseBlinking		: STD_LOGIC;
signal readyBlinking		: STD_LOGIC;
signal bulletPositionX	: INTEGER range 0 to 1000;
signal bulletPositionY	: INTEGER range 0 to 500;
signal obstacles			: mush_array;
signal centipede			: centi_array;
signal score2				: INTEGER range -9 to 9;
signal score1				: INTEGER range -9 to 9;
signal score0				: INTEGER range -9 to 9;
signal padLCorner			: INTEGER range 0 to 1000;
signal padRCorner			: INTEGER range 0 to 1000;
signal northBorder		: INTEGER range 0 to 500;
signal southBorder		: INTEGER range 0 to 500;
signal westBorder			: INTEGER range 0 to 1000;
signal eastBorder			: INTEGER range 0 to 1000;
signal victory				: STD_LOGIC;

BEGIN

ClockGenerator: Centipede_CLKGENERATOR
	port map(
		clock				=> clk_50Mhz,
		clock_mezzi 	=> clock_25Mhz
		);

KeyboardController: Centipede_KEYBOARD
	port map(
		clk				=> clock_25Mhz,
		keyboardClock	=> PS2_CLK,
		keyboardData	=> PS2_DAT,	
		keyCode			=> keyCode		
		);

ControlUnit: Centipede_CONTROL
	port map(
		clk		=> clock_25Mhz,
		cheat		=> cheatKey,
		
		keyboardData	=> keyCode,	
		goingReady		=> goingReady, 
		movepadRight	=> movepadRight,
		movepadLeft		=> movepadLeft,
		shoot				=> shoot,
		reloadBullet	=> reloadBullet,
		moveSnake		=> moveSnake,
		enable			=> enable,		
		boot				=> boot,		
		pauseBlinking	=> pauseBlinking,	
		readyBlinking	=> readyBlinking
		);

Datapath: Centipede_DATA
	port map(
		clk					=> clock_25Mhz,
		padGoRight			=> movepadRight,
		padGoLeft			=> movepadLeft,
		shoot					=> shoot,
		reloadBullet		=> reloadBullet,
		moveSnake			=> moveSnake,
		enable				=> enable,
		bootstrap			=> boot,
		score2 				=> score2,
		score1 				=> score1,
		score0 				=> score0,
		obstacles			=> obstacles,
		centipede			=> centipede,
		bulletPositionX	=> bulletPositionX,
		bulletPositionY	=> bulletPositionY,
		padLCorner			=> padLCorner,
		padRCorner			=> padRCorner,
		northBorder			=> northBorder,
		southBorder			=> southBorder,
		westBorder			=> westBorder,
		eastBorder			=> eastBorder,
		goingReady			=> goingReady,
		gameOver				=> gameOver,
		victory				=> victory	
		);

View: Centipede_VIEW
	port map(
		clk					=> clock_25Mhz,

		bulletPositionX	=> bulletPositionX,
		bulletPositionY	=> bulletPositionY,
		obstacles			=> obstacles,
		centipede			=> centipede,
		padLCorner			=> padLCorner,
		padRCorner			=> padRCorner,
		northBorder			=> northBorder,
		southBorder			=> southBorder,
		westBorder			=> westBorder,
		eastBorder			=> eastBorder,
		score2					=> score2,
		score1 				=> score1,
		score0 				=> score0,
		bootstrap			=> boot,
		pauseBlinking		=> pauseBlinking,
		readyBlinking		=> readyBlinking,
		victory				=> victory,
		gameOver				=> gameOver,
		
		hsync					=> hsync,		
		vsync					=> vsync,		
		red					=> red,	
		green					=> green,		
		blue					=> blue,		
		
				
		leds1					=> leds1,		
		leds2 				=> leds2,
		leds3 				=> leds3, 
		leds4 				=> leds4 
		);



end Behavioral;