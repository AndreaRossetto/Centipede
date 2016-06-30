LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.int_array.ALL;

ENTITY Centipede_DATA IS
PORT(   
		clk		: IN STD_LOGIC;
		padGoRight: IN STD_LOGIC;
		padGoLeft: IN STD_LOGIC;
		moveBall: IN STD_LOGIC;
		shoot: IN STD_LOGIC;
		moveSnake: IN STD_LOGIC;
		enable: IN STD_LOGIC;
		bootstrap: IN STD_LOGIC;
		forceNextLevel: IN STD_LOGIC;

		fixed: OUT STD_LOGIC_VECTOR(0 to 120);
		obstaclesX: OUT int_array;
		obstaclesY: OUT int_array;
		centipedeX: OUT centi_array;
		centipedeY: OUT centi_array;
		bulletPositionX: OUT INTEGER range 0 to 1000;
		bulletPositionY: OUT INTEGER range 0 to 500;
		padLCorner: OUT INTEGER range 0 to 1000;
		padRCorner: OUT INTEGER range 0 to 1000;
		mushroomL: OUT INTEGER range 0 to 1000;
		mushroomR: OUT INTEGER range 0 to 1000;
		level: OUT INTEGER range 0 to 10;
		lives: OUT INTEGER range 0 to 10;
		northBorder: OUT INTEGER range 0 to 500;
		southBorder: OUT INTEGER range 0 to 500;
		westBorder: OUT INTEGER range 0 to 1000;
		eastBorder: OUT INTEGER range 0 to 1000;
		goingReady: OUT STD_LOGIC;
		victory: OUT STD_LOGIC);
end  Centipede_DATA;

ARCHITECTURE behavior of  Centipede_DATA IS

BEGIN
	
PROCESS
variable bulletPositionV: integer range 0 to 1000:=250;
variable bulletPositionH: integer range 0 to 1000:=250;
variable ballMovementH: integer  range 0 to 2:=1;
variable ballMovementV: integer  range 0 to 2 :=1;
variable oldBallMovementV: integer  range 0 to 2 :=1;
variable oldBallMovementH: integer  range 0 to 2 :=1;

variable gameOver: STD_LOGIC :='0';
variable cntScrittaLampeggiante: integer range 0 to 16000000;
variable scrittaLampeggia: STD_LOGIC;
variable padHorizontalDimension:  integer range 0 to 200:=10;
variable padLeftCorner: integer  range 0 to 1000:= 300;
variable padRightCorner: integer  range 0 to 1000:=308;
variable mushroomLeftCorner: integer  range 0 to 1000:= 300;
variable mushroomRightCorner: integer  range 0 to 1000:=310;

-- bordo schermo
constant leftBorder:integer  range 0 to 1000:=45;
constant rightBorder:integer  range 0 to 1000:=606;
constant upBorder: integer  range 0 to 500:=30;	
constant downBorder: integer  range 0 to 500:= 460;

variable dead: STD_LOGIC :='0';
variable angle: integer range 1 to 3:=1;
type arrayInt is array (0 to 200) of integer range -1 to 1000;
variable ostacoliX : arrayInt;
variable ostacoliY : arrayInt;
variable centiX : centi_array;
variable centiY : centi_array;
variable fissi : STD_LOGIC_VECTOR(0 to 120);
variable youWin: STD_LOGIC:='0';
variable vite: integer range 0 to 10:=3;

variable livello: integer range 0 to 10:=1;

variable toCheck: std_logic :='0';
variable toCheck2: std_logic :='0';
variable checkBlocks: std_logic :='0';


variable ballDirectionIsRight: STD_LOGIC:='1';

variable currentN: integer range 0 to 500;
variable currentS: integer range 0 to 500;
variable currentW: integer range 0 to 1000;
variable currentE: integer range 0 to 1000;
variable i: integer range 0 to 128:=0;
variable ind: INTEGER range 0 to 10;
variable cont: INTEGER range 0 to 10 := 0;
variable mushroomS: STD_LOGIC;
variable snakeS: STD_LOGIC;
variable snakeHead: STD_LOGIC;
variable inserted: STD_LOGIC;

BEGIN
WAIT UNTIL(clk'EVENT) AND (clk = '1');

		IF(cntScrittaLampeggiante = 10000000)THEN	
				cntScrittaLampeggiante := 0;
				scrittaLampeggia :=NOT scrittaLampeggia;
				
			ELSE	
				cntScrittaLampeggiante := cntScrittaLampeggiante  + 1;
		END IF;

		
		IF (bootstrap='1') THEN	-- reset
			livello:=1;
			for i in 0 to 200 loop
				ostacoliX(i) := -1;
				ostacoliY(i) := -1;
			end loop;
			ostacoliX(0) := 300;
			ostacoliY(0) := 308;
			ostacoliX(1) := 350;
			ostacoliY(1) := 200;
			
			for i in 0 to 10 loop
				centiX(i) := -1;
				centiY(i) := -1;
			end loop;
			centiX(0) := 200;
			centiY(0) := 150;
			--centiX(1) := 212;
			--centiY(1) := 150;
			--centiX(2) := 224;
			--centiY(2) := 150;
			bulletPositionV:=435; -- posizione è costante
			padLeftCorner:=300;
			padRightCorner:=308;
			bulletPositionH := padLeftCorner+padHorizontalDimension/2;
			mushroomLeftCorner := 300;
			mushroomRightCorner := 310;
			ballMovementH:=1;
			ballMovementV:=1;
			gameOver :='0'; 
			angle:=1;
			vite:=3;
			youWin:='0';
			
			fissi:= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
			northBorder <= upBorder;
			southBorder <= downBorder;
			westBorder <= leftBorder;
			eastBorder <= rightBorder;
		END IF;
		
		IF (forceNextLevel='1' and gameOver='0') THEN
			if(livello=3 and gameOver='0') then 
				youWin:='1'; 
				goingReady<='0'; 
			else
				livello:= livello+1;
				goingReady<='1';
			end if;	
		else 
				goingReady<='0';
		END IF;
		
		if(shoot='1') then 
			toCheck := '1';
		end if;
				
		if(moveSnake='1') then 
			toCheck2:='1'; 
			--checkBlocks2:='1'; 
			--i:=0; 
		end if;
		
		IF(toCheck2='1') THEN

		END IF;
		
		IF(enable='1' AND youWin='0' AND gameOver='0') THEN
			if(toCheck = '1') then
				bulletPositionV := bulletPositionV - 1;
				mushroomS := '0';
				for i in 0 to 200 loop
					if ( bulletPositionH >= ostacoliY(i)-2 AND bulletPositionH <= ostacoliY(i)+8 ) then
						if (bulletPositionV <= ostacoliX(i)+1) then
							mushroomS := '1';
						end if;
					end if;
				end loop;
				if bulletPositionV <= upBorder  OR mushroomS = '1' then 
					toCheck := '0';
					mushroomS := '0';
					bulletPositionV := 435;
				end if;
				snakeS := '0';
				cont := 0;
				snakeHead := '0';
				for i in 0 to 10 loop
					if (centiX(i) /= -1) AND (centiY(i) /= -1) then
						if ( bulletPositionH >= centiY(i)-1 AND bulletPositionH <= centiY(i)+8 ) then
							if (bulletPositionV <= centiX(i)+1) then
								snakeS := '1';
								ind := i;
							end if;
						end if;
					else
						cont := cont + 1;
					end if;
				end loop;
				if cont = 0 then
					snakeHead := '1';
				else
					snakeHead := '0';
				end if;
				if (snakeS = '1') then
					if (snakeHead = '1') then
						inserted := '0';
						for i in 0 to 200 loop
							if (ostacoliX(i) /= -1) AND (ostacoliY(i) /= -1) AND inserted = '0' then
								--ostacoliX(i) := centiX(ind);
								--ostacoliY(i) := centiY(ind);
								inserted := '1';
							end if;
						end loop;
					else
						
					end if;
					
					centiX(ind) := -1;
					centiY(ind) := -1;
					toCheck := '0';
					mushroomS := '0';
					bulletPositionV := 435;
				end if;
			end if;
			IF(padGoRight = '0' AND padGoLeft = '1') THEN
				if (padRightCorner = rightBorder-15) THEN
						padLeftCorner:=padLeftCorner;
					else padLeftCorner := padLeftCorner+1;
				end if;	
			END IF;
			IF (padGoLeft = '0' AND padGoRight = '1') THEN
				if (padLeftCorner = leftBorder+5) THEN
						padLeftCorner:=leftBorder+5;
					else padLeftCorner := padLeftCorner-1;
					end if;
			END IF;
		padRightCorner :=padLeftCorner+padHorizontalDimension;		
		bulletPositionH:= padLeftCorner+padHorizontalDimension/2;
	END IF;
		

-- segnali in uscita
		bulletPositionX <= bulletPositionV;
		bulletPositionY <= bulletPositionH;
		for i in 0 to 200 loop
				obstaclesX(i) <= ostacoliX(i);
				obstaclesY(i) <= ostacoliY(i);
		end loop;
		for i in 0 to 10 loop
				centipedeX(i) <= centiX(i);
				centipedeY(i) <= centiY(i);
		end loop;
		padLCorner <= padLeftCorner;
		padRCorner <= padRightCorner;
		mushroomL <= mushroomLeftCorner;
		mushroomR <= mushroomRightCorner;
		fixed <= fissi;
		lives<=vite;
		level<=livello;
		victory<=youWin;
	
END PROCESS;
END behavior;