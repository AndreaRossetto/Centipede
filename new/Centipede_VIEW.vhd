LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.centiarray.ALL;


ENTITY Centipede_VIEW IS
PORT(   
		clk		: IN STD_LOGIC;	

		bulletPositionX: IN INTEGER range 0 to 1000;
		bulletPositionY: IN INTEGER range 0 to 500;
		obstacles: IN mush_array;
		centipede: IN centi_array;
		padLCorner: IN INTEGER range 0 to 1000;
		padRCorner: IN INTEGER range 0 to 1000;
		northBorder: IN INTEGER range 0 to 500;
		southBorder: IN INTEGER range 0 to 500;
		westBorder: IN INTEGER range 0 to 1000;
		eastBorder: IN INTEGER range 0 to 1000;
		
		bootstrap: IN STD_LOGIC;
		pauseBlinking: IN STD_LOGIC;
		readyBlinking: IN STD_LOGIC;
		victory: IN STD_LOGIC;
		gameOver: IN STD_LOGIC;
		score2 : IN INTEGER range -9 to 9;
		score1: IN INTEGER range -9 to 9;
		score0: IN INTEGER range -9 to 9;
		
		hsync,
		vsync		: OUT STD_LOGIC;
		red, 
		green,
		blue		: out std_logic_vector(3 downto 0);
				
	leds1 : out std_logic_vector(6 downto 0); -- uscita 7 bit x 7 segmenti
	leds2 : out std_logic_vector(6 downto 0); -- uscita 7 bit x 7 segmenti
	leds3 : out std_logic_vector(6 downto 0); -- uscita 7 bit x 7 segmenti
	leds4 : out std_logic_vector(6 downto 0)); -- uscita 7 bit x 7 segmenti		
		
end  Centipede_VIEW;

ARCHITECTURE behavior of  Centipede_VIEW IS
		
BEGIN	
	
PROCESS
--type arrayInt is array (0 to 200) of integer range -1 to 1000; --first define the type of array.

variable cntScrittaLampeggiante: integer range 0 to 16000000;
variable scrittaLampeggia: STD_LOGIC:='0';

constant writePosition: integer range 0 to 500:=300;

constant Pause_p_Position: integer range 0 to 1000:=300;
constant Pause_a_Position: integer range 0 to 1000:=306;
constant Pause_u_Position: integer range 0 to 1000:=312;
constant Pause_s_Position: integer range 0 to 1000:=318;
constant Pause_e_Position: integer range 0 to 1000:=324;

constant Ready_r_Position: integer range 0 to 1000:=300;
constant Ready_e_Position: integer range 0 to 1000:=306;
constant Ready_a_Position: integer range 0 to 1000:=312;
constant Ready_d_Position: integer range 0 to 1000:=318;
constant Ready_y_Position: integer range 0 to 1000:=324;
constant Ready_Q_Position: integer range 0 to 1000:=330;

constant gameOver_g_Position: integer range 0 to 1000:=282;
constant gameOver_a_Position: integer range 0 to 1000:=288;
constant gameOver_m_Position: integer range 0 to 1000:=294;
constant gameOver_e_Position: integer range 0 to 1000:=300;
constant gameOver_o_Position: integer range 0 to 1000:=312;
constant gameOver_v_Position: integer range 0 to 1000:=318;
constant gameOver_e2_Position: integer range 0 to 1000:=324;
constant gameOver_r_Position: integer range 0 to 1000:=330;

constant youWin_w_Position: integer range 0 to 1000:=312;
constant youWin_i_Position: integer range 0 to 1000:=318;
constant youWin_n_Position: integer range 0 to 1000:=324;
constant youWin_e_Position: integer range 0 to 1000:=330;		

-- bordo schermo
variable leftBorder:integer range 0 to 1000;
variable rightBorder:integer range 0 to 1000;
variable upBorder: integer range 0 to 500;	
variable downBorder: integer range 0 to 500;	

variable h_sync: STD_LOGIC;
variable v_sync: STD_LOGIC;
			--Video Enables
variable video_en	: STD_LOGIC; 
variable	horizontal_en	: STD_LOGIC;
variable	vertical_en	: STD_LOGIC;
			-- segnali colori RGB a 4 bit
variable	red_signal		: std_logic_vector(3 downto 0); 
variable	green_signal	: std_logic_vector(3 downto 0);
variable	blue_signal		: std_logic_vector(3 downto 0);
			--Sync Counters
variable h_cnt: integer range 0 to 1000;
variable	v_cnt : integer range 0 to 500;

BEGIN
WAIT UNTIL(clk'EVENT) AND (clk = '1');
	
		IF (bootstrap='1') THEN	--reset
			leds1<="0000000";
			leds2<="0000000";
			leds3<="0000000";
			leds4<="0000000";	
			
			upBorder:= northBorder;
			downBorder:= southBorder;
			leftBorder:= westBorder;
			rightBorder:= eastBorder;
		END IF;
		
		

		--Horizontal Sync
		
			--Reset Horizontal Counter	(resettato al valore 799, anzichè 640, per rispettare i tempi di Front Porch)
			-- Infatti (799-639)/25000000 = 3.6 us = 3.8(a)+1.9(b)+0.6(d)	
		IF (h_cnt = 799) THEN
				h_cnt := 0;
			ELSE
				h_cnt := h_cnt + 1;
		END IF;

			--Sfondo
		IF (v_cnt >= 0) AND (v_cnt <= 479) THEN
			red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';		
			green_signal(3) := '0'; green_signal(2) := '0'; green_signal(1) := '0'; green_signal(0) := '0';
			blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';	
		END IF;

	--pad drawing
		-- bullet
		IF (v_cnt >= bulletPositionX) AND (v_cnt <= bulletPositionX+2) AND (h_cnt = bulletPositionY) THEN
				red_signal(3) := '1';	red_signal(2) := '1';	red_signal(1) := '1';	red_signal(0) := '1';
				green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
				blue_signal(3) := '1';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';			
		END IF;
		-- fine bullet drawing
		--clear screen

		-- fine clear screen
		-- gun		
			IF (v_cnt = 430) AND (h_cnt >= padLCorner+5) AND (h_cnt <= padRCorner-5) THEN
					red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
					green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
					blue_signal(3) := '1';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';			
				END IF;
			IF (v_cnt = 431) AND (h_cnt >= padLCorner+5) AND (h_cnt <= padRCorner-5) THEN
					red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
					green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
					blue_signal(3) := '1';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';		
				END IF;	
			IF (v_cnt = 432) AND (h_cnt >= padLCorner+3) AND (h_cnt <= padRCorner-3) THEN
					red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
					green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
					blue_signal(3) := '1';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';	
				END IF;
			IF (v_cnt = 433) AND (h_cnt >= padLCorner+2) AND (h_cnt <= padRCorner-2) THEN
					red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
					green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
					blue_signal(3) := '1';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';
				END IF;
			IF (v_cnt = 434) AND (h_cnt >= padLCorner+1) AND (h_cnt <= padRCorner-1) THEN
					red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
					green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
					blue_signal(3) := '1';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';	
				END IF;
			IF (v_cnt >= 435) AND (v_cnt <= 438) AND (h_cnt >= padLCorner) AND (h_cnt <= padRCorner) THEN
					red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
					green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
					blue_signal(3) := '1';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';	
				END IF;
			IF (v_cnt = 439) AND (h_cnt >= padLCorner+1) AND (h_cnt <= padRCorner-1) THEN
					red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
					green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
					blue_signal(3) := '1';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';
				END IF;
			IF (v_cnt = 440) AND (h_cnt >= padLCorner+2) AND (h_cnt <= padRCorner-2) THEN
					red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
					green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
					blue_signal(3) := '1';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';	
				END IF;
		
	-- fine gun drawing	
	-- mushroom drawing
		for i in 0 to 30 loop
			IF (obstacles(i).x /= -1) AND (obstacles(i).y /= -1) THEN
				IF (v_cnt = obstacles(i).x-4) AND (h_cnt >= obstacles(i).y+4) AND (h_cnt <= obstacles(i).y+6) THEN
						red_signal(3) := '1';	red_signal(2) := '1';	red_signal(1) := '1';	red_signal(0) := '1';
						green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
						blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
					END IF;
				IF (v_cnt = obstacles(i).x-3) AND (h_cnt >= obstacles(i).y+3) AND (h_cnt <= obstacles(i).y+7) THEN
						red_signal(3) := '1';	red_signal(2) := '1';	red_signal(1) := '1';	red_signal(0) := '1';
						green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
						blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
					END IF;
				IF (v_cnt = obstacles(i).x-2) AND (h_cnt >= obstacles(i).y+2) AND (h_cnt <= obstacles(i).y+8) THEN
						red_signal(3) := '1';	red_signal(2) := '1';	red_signal(1) := '1';	red_signal(0) := '1';
						green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
						blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
					END IF;
				IF (v_cnt = obstacles(i).x-1) AND (h_cnt >= obstacles(i).y+2) AND (h_cnt <= obstacles(i).y+8) THEN
						red_signal(3) := '1';	red_signal(2) := '1';	red_signal(1) := '1';	red_signal(0) := '1';
						green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
						blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
					END IF;
				IF (v_cnt >= obstacles(i).x) AND (v_cnt <= obstacles(i).x+3) AND (h_cnt >= obstacles(i).y+4) AND (h_cnt <= obstacles(i).y+6) THEN
						red_signal(3) := '1';	red_signal(2) := '1';	red_signal(1) := '1';	red_signal(0) := '1';
						green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
						blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
					END IF;				
			END IF;
		end loop;
	-- fine mushroom drawing
	-- snake
		for i in 0 to 7 loop
			IF (centipede(i).x /= -1) AND (centipede(i).y /= -1) THEN
				IF (v_cnt = centipede(i).x-2) AND (h_cnt >= centipede(i).y+2) AND (h_cnt <= centipede(i).y+6) THEN
						red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
						green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
						blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
				END IF;
				IF (v_cnt = centipede(i).x-1) AND (h_cnt >= centipede(i).y+1) AND (h_cnt <= centipede(i).y+7) THEN
						red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
						green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
						blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
					END IF;
				IF (v_cnt >= centipede(i).x) AND (v_cnt <= centipede(i).x+6) AND (h_cnt >= centipede(i).y) AND (h_cnt <= centipede(i).y+8) THEN
						red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
						green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
						blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
					END IF;
				IF (v_cnt = centipede(i).x+7) AND (h_cnt >= centipede(i).y+1) AND (h_cnt <= centipede(i).y+7) THEN
						red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
						green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
						blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
					END IF;
				IF (v_cnt = centipede(i).x+8) AND (h_cnt >= centipede(i).y+2) AND (h_cnt <= centipede(i).y+6) THEN
						red_signal(3) := '0';	red_signal(2) := '0';	red_signal(1) := '0';	red_signal(0) := '0';
						green_signal(3) := '1';	green_signal(2) := '1';	green_signal(1) := '1';	green_signal(0) := '1';
						blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
					END IF;
			END IF;
		end loop;
	-- fine snake drawing
		
		IF (readyBlinking='1' and victory='0') THEN
			IF(cntScrittaLampeggiante = 10000000)THEN	
				cntScrittaLampeggiante := 0;
				scrittaLampeggia :=NOT scrittaLampeggia;
			ELSE	
				cntScrittaLampeggiante := cntScrittaLampeggiante  + 1;
			END IF;
			IF(scrittaLampeggia='1') THEN
		--READY draw
			--R
			IF ((v_cnt >= writePosition AND v_cnt<=310) AND ((h_cnt = Ready_r_Position))) OR
				((v_cnt = writePosition OR v_cnt = writePosition+5  OR v_cnt = writePosition+7 ) AND ((h_cnt = Ready_r_Position+1))) OR
				((v_cnt = writePosition OR v_cnt = writePosition+5  OR v_cnt = writePosition+8 ) AND ((h_cnt = Ready_r_Position+2))) OR
				((v_cnt = writePosition OR v_cnt = writePosition+4  OR v_cnt = writePosition+9 ) AND ((h_cnt = Ready_r_Position+3))) OR
				((v_cnt = writePosition+1 OR v_cnt = writePosition+2 OR v_cnt = writePosition+3  OR v_cnt = 310 ) AND ((h_cnt = Ready_r_Position+4))) THEN	
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';
				END IF;			
			-- fine R

			--E
				IF (((v_cnt = writePosition OR v_cnt = 310)) AND ((h_cnt >= Ready_e_Position) AND (h_cnt <= Ready_e_Position+4))) OR
				(((v_cnt = writePosition+5)) AND ((h_cnt >= Ready_e_Position) AND (h_cnt <= Ready_e_Position+3))) OR
				(((h_cnt = Ready_e_Position)) AND ((v_cnt >= writePosition) AND (v_cnt <= 310))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
			-- fine E

			--A
				IF (((v_cnt = writePosition OR v_cnt = writePosition+5)) AND ((h_cnt >= Ready_a_Position+1) AND (h_cnt <= Ready_a_Position+3))) OR
				(((h_cnt = Ready_a_Position OR h_cnt = Ready_a_Position+4)) AND ((v_cnt >= writePosition+1) AND (v_cnt <= 310))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;

			-- fine A

			--D
				IF (((v_cnt = writePosition OR v_cnt = 310)) AND ((h_cnt >= Ready_d_Position) AND (h_cnt <= Ready_d_Position+3))) OR 
					(((h_cnt = Ready_d_Position)) AND ((v_cnt >= writePosition) AND (v_cnt <= 310))) OR
					(((h_cnt = Ready_d_Position+4)) AND ((v_cnt >= writePosition+1) AND (v_cnt <= writePosition+9)))THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '1';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '1';			
				END IF;
			-- fine D

			--Y
				IF (((v_cnt = writePosition)) AND ((h_cnt = Ready_y_Position) OR (h_cnt = Ready_y_Position+4))) OR
				(((v_cnt = writePosition+1)) AND ((h_cnt = Ready_y_Position+1) OR (h_cnt = Ready_y_Position+3)))OR 
				(((h_cnt = Ready_y_Position+2)) AND ((v_cnt >= writePosition+2) AND (v_cnt <= 310)))THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
			-- fine Y
			
			--?
				IF (((v_cnt = writePosition)) AND ((h_cnt >= Ready_Q_Position+1 AND h_cnt<=Ready_Q_Position+3))) OR (h_cnt = Ready_Q_Position+3 AND (v_cnt=writePosition+9 OR v_cnt=writePosition+7 OR v_cnt=writePosition+6)) OR
				(h_cnt = Ready_Q_Position AND (v_cnt=writePosition+1 OR v_cnt=writePosition+2)) OR (h_cnt = Ready_Q_Position+3 AND (v_cnt=writePosition+4 OR v_cnt=writePosition+5)) OR 
				(h_cnt = Ready_Q_Position+4 AND (v_cnt>=writePosition+1 AND v_cnt<=writePosition+3)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
			-- fine ?			
			END IF;

			-- fine READY draw
			END IF;
			
				
		if(pauseBlinking='1' and victory='0') THEN
			IF(cntScrittaLampeggiante = 10000000)THEN	
				cntScrittaLampeggiante := 0;
				scrittaLampeggia :=NOT scrittaLampeggia;
			ELSE	
				cntScrittaLampeggiante := cntScrittaLampeggiante  + 1;
			END IF;
			IF(scrittaLampeggia='1') THEN
			--PAUSE draw
			--P
				IF (((v_cnt = writePosition)) AND ((h_cnt >= Pause_p_Position) AND (h_cnt <= Pause_p_Position+3))) OR
					(((h_cnt = Pause_p_Position)) AND ((v_cnt >= writePosition) AND (v_cnt <= writePosition+10))) OR
					(((v_cnt >= writePosition+1) AND (v_cnt <=writePosition+2 )) AND ((h_cnt = Pause_p_Position+4))) OR
					((v_cnt = writePosition+3) AND ((h_cnt = Pause_p_Position+3))) OR
					((v_cnt = writePosition+4) AND ((h_cnt >= Pause_p_Position+1)AND (h_cnt <= Pause_p_Position+2)))	
				  THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';
				END IF;			
			-- fine P
			--A
				IF (((v_cnt = writePosition OR v_cnt = writePosition+5)) AND ((h_cnt >= Pause_a_Position+1) AND (h_cnt <= Pause_a_Position+3))) OR
				(((h_cnt = Pause_a_Position OR h_cnt = Pause_a_Position+4)) AND ((v_cnt >= writePosition+1) AND (v_cnt <= writePosition+10))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;

			-- fine A
			--U
				IF (((v_cnt = writePosition+10)) AND ((h_cnt >= Pause_u_Position+1) AND (h_cnt <= Pause_u_Position+3))) OR
				(((h_cnt = Pause_u_Position OR h_cnt = Pause_u_Position+4)) AND ((v_cnt >= writePosition) AND (v_cnt <= writePosition+9))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
			-- fine U		
			--S
				IF (((v_cnt = writePosition OR v_cnt = writePosition+5 OR v_cnt =writePosition+10)) AND ((h_cnt >= Pause_s_Position+1) AND (h_cnt <= Pause_s_Position+3))) OR
					(((v_cnt >= writePosition+1 AND v_cnt<=writePosition+4) OR v_cnt =writePosition+9) AND (h_cnt = Pause_s_Position)) OR
					(((v_cnt >= writePosition+6 AND v_cnt<=writePosition+9) OR v_cnt = writePosition+1) AND (h_cnt = Pause_s_Position+4))THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
			-- fine S
			--E
				IF (((v_cnt = writePosition OR v_cnt = writePosition+10)) AND ((h_cnt >= Pause_e_Position) AND (h_cnt <= Pause_e_Position+4))) OR
				(((v_cnt = writePosition+5)) AND ((h_cnt >= Pause_e_Position) AND (h_cnt <= Pause_e_Position+3))) OR
				(((h_cnt = Pause_e_Position)) AND ((v_cnt >= writePosition) AND (v_cnt <= writePosition+10))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
			-- fine E
			END IF;
		-- fine PAUSE draw
		
		END IF;
	

		
		
-----------------------------------------------------------------------TESTI

		IF(gameOver = '1') THEN
		-- GAME OVER draw
		--G
			IF (((v_cnt = writePosition OR v_cnt = 310)) AND ((h_cnt >= gameOver_g_Position+1) AND (h_cnt <= gameOver_g_Position+3))) OR
				(((h_cnt = gameOver_g_Position+4 )) AND ((v_cnt = writePosition+1) OR (v_cnt = writePosition+9) OR (v_cnt = writePosition+8) OR (v_cnt = writePosition+7))) OR
				(((h_cnt = gameOver_g_Position )) AND ((v_cnt >= writePosition+1) AND (v_cnt <= writePosition+9))) OR
				(((v_cnt = writePosition+7 )) AND ((h_cnt >= gameOver_g_Position+2) AND (h_cnt <= gameOver_g_Position+4))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
			END IF;
		-- fine G
		--A
			IF (((v_cnt = writePosition OR v_cnt = writePosition+5)) AND ((h_cnt >= gameOver_a_Position+1) AND (h_cnt <= gameOver_a_Position+3))) OR
			(((h_cnt = gameOver_a_Position OR h_cnt = gameOver_a_Position+4)) AND ((v_cnt >= writePosition+1) AND (v_cnt <= 310))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
			END IF;
		-- fine A
		--M
			IF (((h_cnt = gameOver_m_Position OR h_cnt = gameOver_m_Position+4)) AND ((v_cnt >= writePosition) AND (v_cnt <= 310))) OR
			(((h_cnt = gameOver_m_Position+1 OR h_cnt = gameOver_m_Position+3) AND (v_cnt >= writePosition+1) AND (v_cnt <= writePosition+2)) )OR
			((h_cnt = gameOver_m_Position+2) AND (v_cnt >= writePosition+2) AND (v_cnt <= writePosition+3)) OR 
			((h_cnt = gameOver_m_Position+2) AND (v_cnt >= writePosition+2) AND (v_cnt <= writePosition+3)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
			END IF;
		-- fine M
		--E
			IF (((v_cnt = writePosition OR v_cnt = 310)) AND ((h_cnt >= gameOver_e_Position) AND (h_cnt <= gameOver_e_Position+4))) OR
			(((v_cnt = writePosition+5)) AND ((h_cnt >= gameOver_e_Position) AND (h_cnt <= gameOver_e_Position+3)))OR 
			(((h_cnt = gameOver_e_Position)) AND ((v_cnt >= writePosition) AND (v_cnt <= 310)))THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
			END IF;
		-- fine E
		--0
			IF (((v_cnt = writePosition OR v_cnt = 310)) AND ((h_cnt >= gameOver_o_Position+1) AND (h_cnt <= gameOver_o_Position+3))) OR
				(((h_cnt = gameOver_o_Position OR h_cnt = gameOver_o_Position+4)) AND ((v_cnt >= writePosition+1) AND (v_cnt <= writePosition+9))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
			END IF;
		-- fine 0
		--V
			IF ((v_cnt >= writePosition AND v_cnt <= writePosition+5) AND ((h_cnt = gameOver_v_Position) OR (h_cnt = gameOver_v_Position+4))) OR
				((v_cnt >= writePosition+5 AND v_cnt <= writePosition+7) AND ((h_cnt = gameOver_v_Position+1) OR (h_cnt = gameOver_v_Position+3))) OR 
				((v_cnt >= writePosition+8 AND v_cnt <= 310) AND ((h_cnt = gameOver_v_Position+2))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
			END IF;
		-- fine V
		--E
			IF (((v_cnt = writePosition OR v_cnt = 310)) AND ((h_cnt >= gameOver_e2_Position) AND (h_cnt <= gameOver_e2_Position+4))) OR
			(((v_cnt = writePosition+5)) AND ((h_cnt >= gameOver_e2_Position) AND (h_cnt <= gameOver_e2_Position+3))) OR
			(((h_cnt = gameOver_e2_Position)) AND ((v_cnt >= writePosition) AND (v_cnt <= 310))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
			END IF;
		-- fine E
		--R
			IF ((v_cnt >= writePosition AND v_cnt<=310) AND ((h_cnt = gameOver_r_Position))) OR
				((v_cnt = writePosition OR v_cnt = writePosition+5  OR v_cnt = writePosition+7 ) AND ((h_cnt = gameOver_r_Position+1))) OR
				((v_cnt = writePosition OR v_cnt = writePosition+5  OR v_cnt = writePosition+8 ) AND ((h_cnt = gameOver_r_Position+2))) OR
				((v_cnt = writePosition OR v_cnt = writePosition+4  OR v_cnt = writePosition+9 ) AND ((h_cnt = gameOver_r_Position+3))) OR
				((v_cnt = writePosition+1 OR v_cnt = writePosition+2 OR v_cnt = writePosition+3  OR v_cnt = 310 ) AND ((h_cnt = gameOver_r_Position+4))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
			END IF;
		-- fine R

		-- fine GAME OVER draw
		END IF;
		-- You Win
			IF(victory='1') THEN	
			--W
				IF (((h_cnt = youWin_w_Position OR h_cnt = youWin_w_Position+4)) AND ((v_cnt >= writePosition) AND (v_cnt <= writePosition+9))) OR
					(((h_cnt = youWin_w_Position+1 OR h_cnt = youWin_w_Position+3)) AND ((v_cnt = 310)))OR 
					(((h_cnt = youWin_w_Position+2)) AND ((v_cnt >= writePosition+6) AND v_cnt<=writePosition+9))THEN
						red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
						green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
						blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;

			-- fine W	
			--I
				IF (((v_cnt = writePosition OR v_cnt = 310)) AND ((h_cnt >= youWin_i_Position+1) AND (h_cnt <= youWin_i_Position+3))) OR
					(((h_cnt = youWin_i_Position+2)) AND ((v_cnt >= writePosition) AND (v_cnt <= 310))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
			-- fine I	
			--N
				IF (((h_cnt = youWin_n_Position OR h_cnt = youWin_n_Position+4)) AND ((v_cnt >=writePosition) AND (v_cnt <= 310))) OR
					((h_cnt = youWin_n_Position+1) AND (v_cnt >= writePosition+1) AND (v_cnt <= writePosition+2)) OR
					(((h_cnt = youWin_n_Position+2) AND (v_cnt >= writePosition+3) AND (v_cnt <= writePosition+4))) OR
					((h_cnt = youWin_n_Position+3) AND (v_cnt >= writePosition+5) AND (v_cnt <= writePosition+6)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';	
				END IF;
			-- fine N			
			--!
				IF (((v_cnt >= writePosition AND v_cnt<writePosition+8)) AND ((h_cnt = youWin_e_Position+3) )) OR
					(((v_cnt = 310)) AND ((h_cnt = youWin_e_Position+3) )) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '1';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
			-- fine !
							
			END IF;
		--You Win
	
-------------------------------------------------------------------------FINE TESTI		



	

---BORDO SCHERMO
				--LEFT
				IF ((h_cnt = leftBorder-10)  AND ((v_cnt >= upBorder-4) AND (v_cnt <= downBorder+4))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';		
				END IF;
				IF ((h_cnt = leftBorder-9)  AND ((v_cnt >= upBorder-6) AND (v_cnt <= downBorder+6))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;
				IF ((h_cnt = leftBorder-8)  AND ((v_cnt >= upBorder-7) AND (v_cnt <= downBorder+7))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '1';			
				END IF;
				IF ((h_cnt = leftBorder-7)  AND ((v_cnt >= upBorder-5) AND (v_cnt <= downBorder+5))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((h_cnt = leftBorder-6)  AND ((v_cnt >= upBorder-5) AND (v_cnt <= downBorder+5))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((h_cnt = leftBorder-5)  AND ((v_cnt >= upBorder-4) AND (v_cnt <= downBorder+4))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((h_cnt = leftBorder-4)  AND ((v_cnt >= upBorder-3) AND (v_cnt <= downBorder+3))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((h_cnt = leftBorder-3)  AND ((v_cnt >= upBorder-2) AND (v_cnt <= downBorder+2))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((h_cnt = leftBorder-2)  AND ((v_cnt >= upBorder-1) AND (v_cnt <= downBorder+1))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '1';		
				END IF;
				IF ((h_cnt = leftBorder-1)  AND ((v_cnt >= upBorder) AND (v_cnt <= downBorder))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
				END IF;
				IF ((h_cnt = leftBorder)  AND ((v_cnt >= upBorder) AND (v_cnt <= downBorder))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';			
				END IF;
				-- fine LEFT
				
				
				-- RIGHT
				IF ((h_cnt = RightBorder)  AND ((v_cnt >= upBorder-4) AND (v_cnt <= downBorder+4))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';			
				END IF;
				IF ((h_cnt = RightBorder-1)  AND ((v_cnt >= upBorder-6) AND (v_cnt <= downBorder+6))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;
				IF ((h_cnt = RightBorder-2)  AND ((v_cnt >= upBorder-7) AND (v_cnt <= downBorder+7))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '1';					
				END IF;--
				IF ((h_cnt = RightBorder-3)  AND ((v_cnt >= upBorder-5) AND (v_cnt <= downBorder+5))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;
				IF ((h_cnt = RightBorder-4)  AND ((v_cnt >= upBorder-6) AND (v_cnt <= downBorder+6))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;
				IF ((h_cnt = RightBorder-5)  AND ((v_cnt >= upBorder-5) AND (v_cnt <= downBorder+5))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;
				IF ((h_cnt = RightBorder-6)  AND ((v_cnt >= upBorder-4) AND (v_cnt <= downBorder+4))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;
				IF ((h_cnt = RightBorder-7)  AND ((v_cnt >= upBorder-3) AND (v_cnt <= downBorder+3))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;
				IF ((h_cnt = RightBorder-8)  AND ((v_cnt >= upBorder-2) AND (v_cnt <= downBorder+2))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '1';			
				END IF;
				IF ((h_cnt = RightBorder-9)  AND ((v_cnt >= upBorder-1) AND (v_cnt <= downBorder+1))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
				END IF;
				IF ((h_cnt = RightBorder-10)  AND ((v_cnt >= upBorder) AND (v_cnt <= downBorder))) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';				
				END IF;
				-- fine RIGHT
				
				-- UP				
				IF ((v_cnt = upBorder-10 )) AND ((h_cnt >= leftBorder-4) AND (h_cnt <= rightBorder-6)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';			
				END IF;
				IF ((v_cnt = upBorder-9 )) AND ((h_cnt >= leftBorder-6) AND (h_cnt <= rightBorder-4)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
				END IF;
				IF ((v_cnt = upBorder-8 )) AND ((h_cnt >= leftBorder-7) AND (h_cnt <= rightBorder-3)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '1';				
				END IF;
				IF ((v_cnt = upBorder-7 )) AND ((h_cnt >= leftBorder-8) AND (h_cnt <= rightBorder-3)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
				END IF;
				IF ((v_cnt = upBorder-6 )) AND ((h_cnt >= leftBorder-7) AND (h_cnt <= rightBorder-3)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;
				IF ((v_cnt = upBorder-5 )) AND ((h_cnt >= leftBorder-5) AND (h_cnt <= rightBorder-6)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((v_cnt = upBorder-4 )) AND ((h_cnt >= leftBorder-4) AND (h_cnt <= rightBorder-7)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((v_cnt = upBorder-3 )) AND ((h_cnt >= leftBorder-3) AND (h_cnt <= rightBorder-8)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((v_cnt = upBorder-2 )) AND ((h_cnt >= leftBorder-2) AND (h_cnt <= rightBorder-9)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '1';	
				END IF;
				IF ((v_cnt = upBorder-1 )) AND ((h_cnt >= leftBorder-1) AND (h_cnt <= rightBorder-10)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';	
				END IF;
				IF ((v_cnt = upBorder )) AND ((h_cnt >= leftBorder) AND (h_cnt <= rightBorder-10)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';		
				END IF;
				-- fine UP

				--DOWN
				IF ((v_cnt = downBorder+10)) AND ((h_cnt >= leftBorder-4) AND (h_cnt <= rightBorder-6)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';			
				END IF;
				IF ((v_cnt = downBorder+9 )) AND ((h_cnt >= leftBorder-6) AND (h_cnt <= rightBorder-4)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';				
				END IF;
				IF ((v_cnt = downBorder+8 )) AND ((h_cnt >= leftBorder-7) AND (h_cnt <= rightBorder-3)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '1';			
				END IF;
				IF ((v_cnt = downBorder+7 )) AND ((h_cnt >= leftBorder-8) AND (h_cnt <= rightBorder-3)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';
				END IF;
				IF ((v_cnt = downBorder+6 )) AND ((h_cnt >= leftBorder-7) AND (h_cnt <= rightBorder-3)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((v_cnt = downBorder+5 )) AND ((h_cnt >= leftBorder-5) AND (h_cnt <= rightBorder-6)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((v_cnt = downBorder+4 )) AND ((h_cnt >= leftBorder-4) AND (h_cnt <= rightBorder-7)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((v_cnt = downBorder+3 )) AND ((h_cnt >= leftBorder-3) AND (h_cnt <= rightBorder-8)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';			
				END IF;
				IF ((v_cnt = downBorder+2 )) AND ((h_cnt >= leftBorder-2) AND (h_cnt <= rightBorder-9)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '1';		
				END IF;
				IF ((v_cnt = downBorder+1 )) AND ((h_cnt >= leftBorder-1) AND (h_cnt <= rightBorder-10)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '1';	blue_signal(2) := '0';	blue_signal(1) := '0';	blue_signal(0) := '0';		
				END IF;
				IF ((v_cnt = downBorder )) AND ((h_cnt >= leftBorder) AND (h_cnt <= rightBorder-10)) THEN
					red_signal(3) := '0';		red_signal(2) := '0';		red_signal(1) := '0';		red_signal(0) := '0';		
					green_signal(3) := '0';	green_signal(2) := '0';	green_signal(1) := '0';	green_signal(0) := '0';
					blue_signal(3) := '0';	blue_signal(2) := '1';	blue_signal(1) := '1';	blue_signal(0) := '1';	
				END IF;
				-- fine DOWN

--- fine BORDO SCHERMO	

			--Generazione segnale hsync (rispettando la specifica temporale di avere un ritardo "a" di 3.8 us fra un segnale e l'altro)
			--Infatti (659-639)/25000000 = 0.6 us, ossia il tempo di Front Porch "d". (755-659)/25000000 = 3.8, ossia il tempo "a"
		IF (h_cnt <= 755) AND (h_cnt >= 659) THEN
			h_sync := '0';
		ELSE
			h_sync := '1';
		END IF;
		
		--Vertical Sync

			--Reset Vertical Counter. Non ci si ferma a 480 per rispettare le specifiche temporali
			--Infatti (524-479)= 45 = 2(a)+33(b)+10(d) righe
		IF (v_cnt >= 524) AND (h_cnt >= 699) THEN
			v_cnt := 0;
		ELSIF (h_cnt = 699) THEN
			v_cnt := v_cnt + 1;
		END IF;
		
			--Generazione segnale vsync (rispettando la specifica temporale di avere un ritardo "a" di due volte il tempo di riga us fra un segnale e l'altro)
		IF (v_cnt = 490 OR v_cnt = 491) THEN
			v_sync := '0';	
			
		ELSE
			v_sync := '1';
		END IF;
		
			--Generazione Horizontal Data Enable (dati di riga validi, ossia nel range orizzontale 0-639)
		IF (h_cnt <= 639) THEN
			horizontal_en := '1';
		ELSE
			horizontal_en := '0';
		END IF;
		
			--Generazione Vertical Data Enable (dati di riga validi, ossia nel range verticale 0-479)
		IF (v_cnt <= 479) THEN
			vertical_en := '1';
		ELSE
			vertical_en := '0';
		END IF;
		
			video_en := horizontal_en AND vertical_en;

		
	-- Assegnamento segnali fisici a VGA
	red(0)		<= red_signal(0) AND video_en;
	green(0)  	<= green_signal(0) AND video_en;
	blue(0)		<= blue_signal(0) AND video_en;
	red(1)		<= red_signal(1) AND video_en;
	green(1)  	<= green_signal(1) AND video_en;
	blue(1)		<= blue_signal(1) AND video_en;
	red(2)		<= red_signal(2) AND video_en;
	green(2)    <= green_signal(2) AND video_en;
	blue(2)		<= blue_signal(2) AND video_en;
	red(3)		<= red_signal(3) AND video_en;
	green(3) 	<= green_signal(3) AND video_en;
	blue(3)		<= blue_signal(3) AND video_en;
	hsync		<= h_sync;
	vsync		<= v_sync;

	if score0 = 0 then
		leds1 <= not"0111111";
	else
		leds1 <= not"1101101";
	end if;
	
	case score2 is
		when 0 => leds3 <= not"0111111";
		when 1 => leds3 <= not"0000110";
		when 2 => leds3 <= not"1011011";
		when 3 => leds3 <= not"1001111";
		when 4 => leds3 <= not"1100110";
		when 5 => leds3 <= not"1101101";
		when 6 => leds3<= not"1111101";
		when 7 => leds3 <= not"0000111";
		when 8 => leds3 <= not"1111111";
		when 9 => leds3 <= not"1100111";
		when others => leds3 <= not"1111111";
	end case;
	case score1 is
		when 0 => leds2 <= not"0111111";
		when 1 => leds2 <= not"0000110";
		when 2 => leds2 <= not"1011011";
		when 3 => leds2 <= not"1001111";
		when 4 => leds2 <= not"1100110";
		when 5 => leds2 <= not"1101101";
		when 6 => leds2 <= not"1111101";
		when 7 => leds2 <= not"0000111";
		when 8 => leds2 <= not"1111111";
		when 9 => leds2 <= not"1100111";
		when others => leds2 <= not"1111111";
	end case;
	case score0 is
		when 0 => leds1 <= not"0111111";
		when 1 => leds1 <= not"0000110";
		when 2 => leds1 <= not"1011011";
		when 3 => leds1 <= not"1001111";
		when 4 => leds1 <= not"1100110";
		when 5 => leds1 <= not"1101101";
		when 6 => leds1 <= not"1111101";
		when 7 => leds1 <= not"0000111";
		when 8 => leds1 <= not"1111111";
		when 9 => leds1 <= not"1100111";
		when others => leds1 <= not"1111111";
	end case;
	
	leds4 <= not"1110011"; -- P
	
END PROCESS;
END behavior;