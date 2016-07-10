LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Centipede_CONTROL IS
PORT(   
		clk: 					IN STD_LOGIC;
		cheat: 				IN STD_LOGIC;
		
		keyboardData:		IN STD_LOGIC_VECTOR (7 downto 0);
		goingReady: 		IN STD_LOGIC;
		movepadRight: 		OUT STD_LOGIC;
		shoot : 				OUT STD_LOGIC;
		reloadBullet:		IN STD_LOGIC;
		movepadLeft: 		OUT STD_LOGIC;
		moveSnake: 			OUT STD_LOGIC;
		enable: 				OUT STD_LOGIC;
		boot: 				OUT STD_LOGIC;
		pauseBlinking: 	OUT STD_LOGIC;
		readyBlinking: 	OUT STD_LOGIC);
end  Centipede_CONTROL;

ARCHITECTURE behavior of  Centipede_CONTROL IS

BEGIN
	
	
PROCESS

constant BOOTSTRAP: STD_LOGIC_VECTOR (1 downto 0):="00";
constant PLAYING: STD_LOGIC_VECTOR (1 downto 0):="01";
constant PAUSED: STD_LOGIC_VECTOR (1 downto 0):="11";
constant READY: STD_LOGIC_VECTOR (1 downto 0):="10";

variable state: STD_LOGIC_VECTOR (1 downto 0):=BOOTSTRAP;
variable cheating: STD_LOGIC:='0';



constant padSpeed: integer range 0 to 10000000:=450000;	--MAX 10000000 più grande è, più lenta va.
constant bulletSpeed: integer range 0 to 10000000:=80000; --MAX 10000000 più grande è, più lenta va.
constant snakeSpeed: integer range 0 to 10000000:=350000; --MAX 10000000 più grande è, più lenta va.

variable cntpadSpeed: integer range 0 to 10000000;
variable cntBulletSpeed: integer range 0 to 10000000;
variable cntSnakeSpeed: integer range 0 to 10000000;
variable start: std_logic:='0';

constant keyRESET: std_logic_vector(7 downto 0):="00101101";
constant keySHOOT: std_logic_vector(7 downto 0):="01110101";
constant keyPLAY: std_logic_vector(7 downto 0):="00101001";
constant keyPAUSE: std_logic_vector(7 downto 0):="01001101";
constant keyRIGHT: std_logic_vector(7 downto 0):="01110100";
constant keyLEFT: std_logic_vector(7 downto 0):="01101011";

variable shPress:  STD_LOGIC := '0';

BEGIN
WAIT UNTIL(clk'EVENT) AND (clk = '1');
	
	
	case state IS
		when BOOTSTRAP => 
			boot<='1';
			shoot <= '0';
			shPress := '0';
			IF(keyboardData=keyPLAY) THEN
				state:=PLAYING;
				boot<='0';
				enable<='1';
			END IF;
		
		when PLAYING =>
			IF(cntpadSpeed = padSpeed)THEN
				cntpadSpeed:=0;
				case keyboardData is
					when keyRIGHT => movepadRight<='0'; movepadLeft<='1';
					when keyLEFT => movepadRight<='1'; movepadLeft<='0';
					when others => movepadRight<='1'; movepadLeft<='1';
				end case;	
			ELSE
				cntpadSpeed:=cntpadSpeed+1;
				movepadRight<='1';
				movepadLeft<='1';
			END IF;	
						
			IF(cntSnakeSpeed = snakeSpeed) THEN
				cntSnakeSpeed:=0;
				moveSnake<='1';
			ELSE
				cntSnakeSpeed:=cntSnakeSpeed+1;
				moveSnake<='0';
			END IF;
			if reloadBullet = '1' then
					shPress := '0';
				end if;
			IF(cntBulletSpeed = bulletSpeed)THEN
				cntBulletSpeed:=0;
				
				if keyboardData = keySHOOT AND shPress = '0' then
					shPress := '1';
				end if;
				if shPress = '1' then
					shoot <= '1';
				end if;
			else
				cntBulletSpeed:=cntBulletSpeed+1;
				shoot <= '0';
			END IF;		
		
				
			IF(keyboardData=keyRESET) THEN
				enable<='0';
				boot<='1';
				state:=BOOTSTRAP;
			END IF;
			IF(keyboardData=keyPAUSE) THEN
				enable<='0';
				state:=PAUSED;
			END IF;	
			
			IF (goingReady='1') THEN state:=READY; END IF;
			
		when PAUSED =>
			IF(keyboardData=keyRESET) THEN
				enable<='0';
				boot<='1';
				state:=BOOTSTRAP;
			END IF;
			IF(keyboardData=keyPLAY) THEN
				enable<='1';
				state:=PLAYING;
				boot<='0';
			END IF;	
			IF (goingReady='1') THEN state:=READY; END IF;
			
		when READY => 
			enable<='0';
			IF(keyboardData=keyPLAY) THEN
				state:=PLAYING;
				boot<='0';
				enable<='1';
			END IF;
			IF(keyboardData=keyRESET) THEN
				enable<='0';
				boot<='1';
				state:=BOOTSTRAP;
			END IF;
	END case;
	
	pauseBlinking <= state(1) AND state(0);
	readyBlinking <= NOT state(0);
	
END PROCESS;
END behavior;