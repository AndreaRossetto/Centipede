LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.centiarray.ALL;

ENTITY Centipede_DATA IS
PORT(   
		clk		: IN STD_LOGIC;
		padGoRight: IN STD_LOGIC;
		padGoLeft: IN STD_LOGIC;
		shoot: IN STD_LOGIC;
		reloadBullet: OUT STD_LOGIC;
		moveSnake: IN STD_LOGIC;
		enable: IN STD_LOGIC;
		bootstrap: IN STD_LOGIC;
		obstacles: OUT mush_array;
		centipede: OUT centi_array;
		bulletPositionX: OUT INTEGER range 0 to 1000;
		bulletPositionY: OUT INTEGER range 0 to 500;
		padLCorner: OUT INTEGER range 0 to 1000;
		padRCorner: OUT INTEGER range 0 to 1000;
		northBorder: OUT INTEGER range 0 to 500;
		southBorder: OUT INTEGER range 0 to 500;
		westBorder: OUT INTEGER range 0 to 1000;
		eastBorder: OUT INTEGER range 0 to 1000;
		goingReady: OUT STD_LOGIC;
		score2 : OUT INTEGER range -9 to 9;
		score1: OUT INTEGER range -9 to 9;
		score0: OUT INTEGER range -9 to 9;
		gameOver: OUT STD_LOGIC;
		victory: OUT STD_LOGIC);
end  Centipede_DATA;

ARCHITECTURE behavior of  Centipede_DATA IS
BEGIN
	
PROCESS
variable bulletPositionV: integer range 0 to 1000:=250;
variable bulletPositionH: integer range 0 to 1000:=250;
variable gameO: STD_LOGIC :='0';
variable cntScrittaLampeggiante: integer range 0 to 16000000;
variable scrittaLampeggia: STD_LOGIC;
variable padHorizontalDimension:  integer range 0 to 200:=10;
variable padLeftCorner: integer  range 0 to 1000:= 300;
variable padRightCorner: integer  range 0 to 1000:=308;

-- bordo schermo
constant leftBorder:integer  range 0 to 1000:=45;
constant rightBorder:integer  range 0 to 1000:=606;
constant upBorder: integer  range 0 to 500:=30;	
constant downBorder: integer  range 0 to 500:= 460;

variable fungo0: coord_type;
variable fungo1: coord_type;
variable fungo2: coord_type;
variable fungo3: coord_type;
variable fungo4: coord_type;
variable fungo5: coord_type;
variable fungo6: coord_type;
variable fungo7: coord_type;
variable fungo8: coord_type;
variable fungo9: coord_type;
variable fungo10: coord_type;
variable fungo11: coord_type;
variable fungo12: coord_type;
variable fungo13: coord_type;
variable fungo14: coord_type;
variable fungo15: coord_type;
variable fungo16: coord_type;
variable fungo17: coord_type;
variable fungo18: coord_type;
variable fungo19: coord_type;
variable fungo20: coord_type;
variable fungo21: coord_type;
variable fungo22: coord_type;
variable fungo23: coord_type;

variable cont: INTEGER range 0 to 10 := 0; 
variable youWin: STD_LOGIC:='0';
variable toCheck: std_logic :='0';
variable toCheck2: std_logic :='0';
variable indM: INTEGER range 0 to 30 := 2;
variable dirR0: STD_LOGIC := '1';
variable dirR1: STD_LOGIC := '1';
variable dirR2: STD_LOGIC := '1';
variable dirR3: STD_LOGIC := '1';
variable dirR4: STD_LOGIC := '1';
variable dirR5: STD_LOGIC := '1';
variable dirR6: STD_LOGIC := '1';
variable dirR7: STD_LOGIC := '1';
variable mushroomS: STD_LOGIC;
variable snakeS: STD_LOGIC;
variable centi0: coord_type;
variable centi1: coord_type;
variable centi2: coord_type;
variable centi3: coord_type;
variable centi4: coord_type;
variable centi5: coord_type;
variable centi6: coord_type;

variable head0: STD_LOGIC := '1';
variable head1: STD_LOGIC := '0';
variable head2: STD_LOGIC := '0';
variable head3: STD_LOGIC := '0';
variable head4: STD_LOGIC := '0';
variable head5: STD_LOGIC := '0';
variable head6: STD_LOGIC := '0';

variable shooted: STD_LOGIC := '0';
variable vScore2: INTEGER range -9 to 9 := 0;
variable vScore1: INTEGER range -9 to 9 := 0; 
variable vScore0: INTEGER range -9 to 9 := 0; 

BEGIN
WAIT UNTIL(clk'EVENT) AND (clk = '1');

		IF(cntScrittaLampeggiante = 10000000)THEN	
				cntScrittaLampeggiante := 0;
				scrittaLampeggia :=NOT scrittaLampeggia;		
			ELSE	
				cntScrittaLampeggiante := cntScrittaLampeggiante  + 1;
		END IF;

		
		IF (bootstrap='1') THEN	-- reset
		
			vScore0 := 0;
			vScore1 := 0;
			vScore2 := 0;
			
			cont := 0;
		
			fungo0.x := 380;
			fungo0.y := 300;
			fungo1.x := 240;
			fungo1.y := 200;
			fungo2.x := 100;
			fungo2.y := 250;
			fungo3.x := 140;
			fungo3.y := 220;
			fungo4.x := 290;
			fungo4.y := 120;
			fungo5.x := 120;
			fungo5.y := 300;
			fungo6.x := 80;
			fungo6.y := 580;
			fungo7.x := 180;
			fungo7.y := 490;
			fungo8.x := 180;
			fungo8.y := 100;
			fungo9.x := 380;
			fungo9.y := 200;
			fungo10.x := 80;
			fungo10.y := 100;
			fungo11.x := 240;
			fungo11.y := 160;
			fungo12.x := 560;
			fungo12.y := 120;
			fungo13.x := 280;
			fungo13.y := 120;
			fungo14.x := 300;
			fungo14.y := 80;
			fungo15.x := 280;
			fungo15.y := 300;
			
			fungo16.x := -1;
			fungo16.y := -1;
			fungo17.x := -1;
			fungo17.y := -1;
			fungo18.x := -1;
			fungo18.y := -1;
			fungo19.x := -1;
			fungo19.y := -1;
			fungo20.x := -1;
			fungo20.y := -1;
			fungo21.x := -1;
			fungo21.y := -1;
			fungo22.x := -1;
			fungo22.y := -1;
			
			fungo23.x := 260;
			fungo23.y := 560;
			
			head0 := '1';
			head1 := '0';
			head2 := '0';
			head3 := '0';
			head4 := '0';
			head5 := '0';
			head6 := '0';
			
			dirR0 := '1';
			dirR1 := '1';
			dirR2 := '1';
			dirR3 := '1';
			dirR4 := '1';
			dirR5 := '1';
			dirR6 := '1';
			dirR7 := '1';
			
			shooted := '0';
						
			centi0.x := 40;
			centi0.y := 0;
			centi1.x := -1;
			centi1.y := -1;
			centi2.x := -1;
			centi2.y := -1;
			centi3.x := -1;
			centi3.y := -1;
			centi4.x := -1;
			centi4.y := -1;
			centi5.x := -1;
			centi5.y := -1;
			centi6.x := -1;
			centi6.y := -1;
			
			bulletPositionV:=435; -- posizione è costante
			padLeftCorner:=300;
			padRightCorner:=308;
			bulletPositionH := padLeftCorner+5;
			gameO :='0'; 
			youWin:='0';
			
			northBorder <= upBorder;
			southBorder <= downBorder;
			westBorder <= leftBorder;
			eastBorder <= rightBorder;
		END IF;
		
		goingReady<='0';
		
		if shooted = '0' then
			bulletPositionH := padLeftCorner+5;
		end if;
		
		if(shoot='1') then 
			toCheck := '1';
			shooted := '1';
		end if;
				
		if(moveSnake='1') then 
			toCheck2:='1'; 
		end if;
		
		IF(toCheck2='1') THEN			
			case cont is
					when 0 => 
						cont := cont + 1;
					when 1 => 
						centi1.x := centi0.x;
						centi1.y := centi0.y - 10;
						cont := cont + 1;
					when 2 => 
						centi2.x := centi1.x;
						centi2.y := centi1.y - 10;
						centi1.x := centi0.x;
						centi1.y := centi0.y - 10;
						cont := cont + 1;
					when 3 => 
						centi3.x := centi2.x;
						centi3.y := centi2.y - 10;
						centi2.x := centi1.x;
						centi2.y := centi1.y - 10;
						centi1.x := centi0.x;
						centi1.y := centi0.y - 10;
						cont := cont + 1;
					when 4 =>
						centi4.x := centi3.x;
						centi4.y := centi3.y - 10;
						centi3.x := centi2.x;
						centi3.y := centi2.y - 10;
						centi2.x := centi1.x;
						centi2.y := centi1.y - 10;
						centi1.x := centi0.x;
						centi1.y := centi0.y - 10;
						cont := cont + 1;
					when 5 =>
						centi5.x := centi4.x;
						centi5.y := centi4.y - 10;
						centi4.x := centi3.x;
						centi4.y := centi3.y - 10;
						centi3.x := centi2.x;
						centi3.y := centi2.y - 10;
						centi2.x := centi1.x;
						centi2.y := centi1.y - 10;
						centi1.x := centi0.x;
						centi1.y := centi0.y - 10;
						cont := cont + 1;
					when 6 =>
						centi6.x := centi5.x;
						centi6.y := centi5.y - 10;
						centi5.x := centi4.x;
						centi5.y := centi4.y - 10;
						centi4.x := centi3.x;
						centi4.y := centi3.y - 10;
						centi3.x := centi2.x;
						centi3.y := centi2.y - 10;
						centi2.x := centi1.x;
						centi2.y := centi1.y - 10;
						centi1.x := centi0.x;
						centi1.y := centi0.y - 10;
						cont := cont + 1;
					when others =>  -- MANCA CONTROLLO SERPENTE: FUNGHI E PISTOLA
						if centi0.x /= -1 then
							if dirR0 = '1' then
								if centi0.y >= rightBorder-18 then
									centi0.x := centi0.x + 12;
									dirR0 := '0';
								else
									if (centi0.y+8 >= fungo0.y+3 AND ((fungo0.x-4 >= centi0.x-2 AND fungo0.x-4 <= centi0.x+8) OR (fungo0.x+4 >= centi0.x-2 AND fungo0.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo1.y+3 AND ((fungo1.x-4 >= centi0.x-2 AND fungo1.x-4 <= centi0.x+8) OR (fungo1.x+4 >= centi0.x-2 AND fungo1.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo2.y+3 AND ((fungo2.x-4 >= centi0.x-2 AND fungo2.x-4 <= centi0.x+8) OR (fungo2.x+4 >= centi0.x-2 AND fungo2.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo3.y+3 AND ((fungo3.x-4 >= centi0.x-2 AND fungo3.x-4 <= centi0.x+8) OR (fungo3.x+4 >= centi0.x-2 AND fungo3.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo4.y+3 AND ((fungo4.x-4 >= centi0.x-2 AND fungo4.x-4 <= centi0.x+8) OR (fungo4.x+4 >= centi0.x-2 AND fungo4.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo5.y+3 AND ((fungo5.x-4 >= centi0.x-2 AND fungo5.x-4 <= centi0.x+8) OR (fungo5.x+4 >= centi0.x-2 AND fungo5.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo6.y+3 AND ((fungo6.x-4 >= centi0.x-2 AND fungo6.x-4 <= centi0.x+8) OR (fungo6.x+4 >= centi0.x-2 AND fungo6.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo7.y+3 AND ((fungo7.x-4 >= centi0.x-2 AND fungo7.x-4 <= centi0.x+8) OR (fungo7.x+4 >= centi0.x-2 AND fungo7.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo8.y+3 AND ((fungo8.x-4 >= centi0.x-2 AND fungo8.x-4 <= centi0.x+8) OR (fungo8.x+4 >= centi0.x-2 AND fungo8.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo9.y+3 AND ((fungo9.x-4 >= centi0.x-2 AND fungo9.x-4 <= centi0.x+8) OR (fungo9.x+4 >= centi0.x-2 AND fungo9.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo10.y+3 AND ((fungo10.x-4 >= centi0.x-2 AND fungo10.x-4 <= centi0.x+8) OR (fungo10.x+4 >= centi0.x-2 AND fungo10.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo11.y+3 AND ((fungo11.x-4 >= centi0.x-2 AND fungo11.x-4 <= centi0.x+8) OR (fungo11.x+4 >= centi0.x-2 AND fungo11.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo12.y+3 AND ((fungo12.x-4 >= centi0.x-2 AND fungo12.x-4 <= centi0.x+8) OR (fungo12.x+4 >= centi0.x-2 AND fungo12.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo13.y+3 AND ((fungo13.x-4 >= centi0.x-2 AND fungo13.x-4 <= centi0.x+8) OR (fungo13.x+4 >= centi0.x-2 AND fungo13.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo14.y+3 AND ((fungo14.x-4 >= centi0.x-2 AND fungo14.x-4 <= centi0.x+8) OR (fungo14.x+4 >= centi0.x-2 AND fungo14.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo15.y+3 AND ((fungo15.x-4 >= centi0.x-2 AND fungo15.x-4 <= centi0.x+8) OR (fungo15.x+4 >= centi0.x-2 AND fungo15.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo16.y+3 AND ((fungo16.x-4 >= centi0.x-2 AND fungo16.x-4 <= centi0.x+8) OR (fungo16.x+4 >= centi0.x-2 AND fungo16.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo17.y+3 AND ((fungo17.x-4 >= centi0.x-2 AND fungo17.x-4 <= centi0.x+8) OR (fungo17.x+4 >= centi0.x-2 AND fungo17.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo18.y+3 AND ((fungo18.x-4 >= centi0.x-2 AND fungo18.x-4 <= centi0.x+8) OR (fungo18.x+4 >= centi0.x-2 AND fungo18.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo19.y+3 AND ((fungo19.x-4 >= centi0.x-2 AND fungo19.x-4 <= centi0.x+8) OR (fungo19.x+4 >= centi0.x-2 AND fungo19.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo20.y+3 AND ((fungo20.x-4 >= centi0.x-2 AND fungo20.x-4 <= centi0.x+8) OR (fungo20.x+4 >= centi0.x-2 AND fungo20.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo21.y+3 AND ((fungo21.x-4 >= centi0.x-2 AND fungo21.x-4 <= centi0.x+8) OR (fungo21.x+4 >= centi0.x-2 AND fungo21.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo22.y+3 AND ((fungo22.x-4 >= centi0.x-2 AND fungo22.x-4 <= centi0.x+8) OR (fungo22.x+4 >= centi0.x-2 AND fungo22.x+4 <= centi0.x+8)))
										OR (centi0.y+8 >= fungo23.y+3 AND ((fungo23.x-4 >= centi0.x-2 AND fungo23.x-4 <= centi0.x+8) OR (fungo23.x+4 >= centi0.x-2 AND fungo23.x+4 <= centi0.x+8))) then
										
										centi0.x := centi0.x + 12;
										dirR0 := '0';
									else
										centi0.y := centi0.y + 1;
									end if;
								end if;
							end if;
							if dirR0 = '0' then
									if (centi0.y <= leftBorder+2) then
										centi0.x := centi0.x + 12;
										dirR0 := '1';
									else
										if (centi0.y <= fungo0.y+8 AND ((fungo0.x-4 >= centi0.x-2 AND fungo0.x-4 <= centi0.x+8) OR (fungo0.x+4 >= centi0.x-2 AND fungo0.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo1.y+8 AND ((fungo1.x-4 >= centi0.x-2 AND fungo1.x-4 <= centi0.x+8) OR (fungo1.x+4 >= centi0.x-2 AND fungo1.x+4 <= centi0.x+8) )) OR 
											(centi0.y <= fungo2.y+8 AND ((fungo2.x-4 >= centi0.x-2 AND fungo2.x-4 <= centi0.x+8) OR (fungo2.x+4 >= centi0.x-2 AND fungo2.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo3.y+8 AND ((fungo3.x-4 >= centi0.x-2 AND fungo3.x-4 <= centi0.x+8) OR (fungo3.x+4 >= centi0.x-2 AND fungo3.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo4.y+8 AND ((fungo4.x-4 >= centi0.x-2 AND fungo4.x-4 <= centi0.x+8) OR (fungo4.x+4 >= centi0.x-2 AND fungo4.x+4 <= centi0.x+8) )) OR 
											(centi0.y <= fungo5.y+8 AND ((fungo5.x-4 >= centi0.x-2 AND fungo5.x-4 <= centi0.x+8) OR (fungo5.x+4 >= centi0.x-2 AND fungo5.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo6.y+8 AND ((fungo6.x-4 >= centi0.x-2 AND fungo6.x-4 <= centi0.x+8) OR (fungo6.x+4 >= centi0.x-2 AND fungo6.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo7.y+8 AND ((fungo7.x-4 >= centi0.x-2 AND fungo7.x-4 <= centi0.x+8) OR (fungo7.x+4 >= centi0.x-2 AND fungo7.x+4 <= centi0.x+8) )) OR 
											(centi0.y <= fungo8.y+8 AND ((fungo8.x-4 >= centi0.x-2 AND fungo8.x-4 <= centi0.x+8) OR (fungo8.x+4 >= centi0.x-2 AND fungo8.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo9.y+8 AND ((fungo9.x-4 >= centi0.x-2 AND fungo9.x-4 <= centi0.x+8) OR (fungo9.x+4 >= centi0.x-2 AND fungo9.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo10.y+8 AND ((fungo10.x-4 >= centi0.x-2 AND fungo10.x-4 <= centi0.x+8) OR (fungo10.x+4 >= centi0.x-2 AND fungo10.x+4 <= centi0.x+8) )) OR 
											(centi0.y <= fungo11.y+8 AND ((fungo11.x-4 >= centi0.x-2 AND fungo11.x-4 <= centi0.x+8) OR (fungo11.x+4 >= centi0.x-2 AND fungo11.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo12.y+8 AND ((fungo12.x-4 >= centi0.x-2 AND fungo12.x-4 <= centi0.x+8) OR (fungo12.x+4 >= centi0.x-2 AND fungo12.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo13.y+8 AND ((fungo13.x-4 >= centi0.x-2 AND fungo13.x-4 <= centi0.x+8) OR (fungo13.x+4 >= centi0.x-2 AND fungo13.x+4 <= centi0.x+8) )) OR 
											(centi0.y <= fungo14.y+8 AND ((fungo14.x-4 >= centi0.x-2 AND fungo14.x-4 <= centi0.x+8) OR (fungo14.x+4 >= centi0.x-2 AND fungo14.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo15.y+8 AND ((fungo15.x-4 >= centi0.x-2 AND fungo15.x-4 <= centi0.x+8) OR (fungo15.x+4 >= centi0.x-2 AND fungo15.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo16.y+8 AND ((fungo16.x-4 >= centi0.x-2 AND fungo16.x-4 <= centi0.x+8) OR (fungo16.x+4 >= centi0.x-2 AND fungo16.x+4 <= centi0.x+8) )) OR 
											(centi0.y <= fungo17.y+8 AND ((fungo17.x-4 >= centi0.x-2 AND fungo17.x-4 <= centi0.x+8) OR (fungo17.x+4 >= centi0.x-2 AND fungo17.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo18.y+8 AND ((fungo18.x-4 >= centi0.x-2 AND fungo18.x-4 <= centi0.x+8) OR (fungo18.x+4 >= centi0.x-2 AND fungo18.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo19.y+8 AND ((fungo19.x-4 >= centi0.x-2 AND fungo19.x-4 <= centi0.x+8) OR (fungo19.x+4 >= centi0.x-2 AND fungo19.x+4 <= centi0.x+8) )) OR 
											(centi0.y <= fungo20.y+8 AND ((fungo20.x-4 >= centi0.x-2 AND fungo20.x-4 <= centi0.x+8) OR (fungo20.x+4 >= centi0.x-2 AND fungo20.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo21.y+8 AND ((fungo21.x-4 >= centi0.x-2 AND fungo21.x-4 <= centi0.x+8) OR (fungo21.x+4 >= centi0.x-2 AND fungo21.x+4 <= centi0.x+8) )) OR
											(centi0.y <= fungo22.y+8 AND ((fungo22.x-4 >= centi0.x-2 AND fungo22.x-4 <= centi0.x+8) OR (fungo22.x+4 >= centi0.x-2 AND fungo22.x+4 <= centi0.x+8) )) OR 
											(centi0.y <= fungo23.y+8 AND ((fungo23.x-4 >= centi0.x-2 AND fungo23.x-4 <= centi0.x+8) OR (fungo23.x+4 >= centi0.x-2 AND fungo23.x+4 <= centi0.x+8) )) then
											
											--centi0.x := centi0.x + 12;
											dirR0 := '1';
										else
											centi0.y := centi0.y - 1;
										end if;
									end if;
							end if;
						end if;
						
						if centi1.x /= -1 then
							if dirR1 = '1' then
								if centi1.y >= rightBorder-18 then
									centi1.x := centi1.x + 12;
									dirR1 := '0';
								else
									if (centi1.y+8 >= fungo0.y+3 AND ((fungo0.x-4 >= centi1.x-2 AND fungo0.x-4 <= centi1.x+8) OR (fungo0.x+4 >= centi1.x-2 AND fungo0.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo1.y+3 AND ((fungo1.x-4 >= centi1.x-2 AND fungo1.x-4 <= centi1.x+8) OR (fungo1.x+4 >= centi1.x-2 AND fungo1.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo2.y+3 AND ((fungo2.x-4 >= centi1.x-2 AND fungo2.x-4 <= centi1.x+8) OR (fungo2.x+4 >= centi1.x-2 AND fungo2.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo3.y+3 AND ((fungo3.x-4 >= centi1.x-2 AND fungo3.x-4 <= centi1.x+8) OR (fungo3.x+4 >= centi1.x-2 AND fungo3.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo4.y+3 AND ((fungo4.x-4 >= centi1.x-2 AND fungo4.x-4 <= centi1.x+8) OR (fungo4.x+4 >= centi1.x-2 AND fungo4.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo5.y+3 AND ((fungo5.x-4 >= centi1.x-2 AND fungo5.x-4 <= centi1.x+8) OR (fungo5.x+4 >= centi1.x-2 AND fungo5.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo6.y+3 AND ((fungo6.x-4 >= centi1.x-2 AND fungo6.x-4 <= centi1.x+8) OR (fungo6.x+4 >= centi1.x-2 AND fungo6.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo7.y+3 AND ((fungo7.x-4 >= centi1.x-2 AND fungo7.x-4 <= centi1.x+8) OR (fungo7.x+4 >= centi1.x-2 AND fungo7.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo8.y+3 AND ((fungo8.x-4 >= centi1.x-2 AND fungo8.x-4 <= centi1.x+8) OR (fungo8.x+4 >= centi1.x-2 AND fungo8.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo9.y+3 AND ((fungo9.x-4 >= centi1.x-2 AND fungo9.x-4 <= centi1.x+8) OR (fungo9.x+4 >= centi1.x-2 AND fungo9.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo10.y+3 AND ((fungo10.x-4 >= centi1.x-2 AND fungo10.x-4 <= centi1.x+8) OR (fungo10.x+4 >= centi1.x-2 AND fungo10.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo11.y+3 AND ((fungo11.x-4 >= centi1.x-2 AND fungo11.x-4 <= centi1.x+8) OR (fungo11.x+4 >= centi1.x-2 AND fungo11.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo12.y+3 AND ((fungo12.x-4 >= centi1.x-2 AND fungo12.x-4 <= centi1.x+8) OR (fungo12.x+4 >= centi1.x-2 AND fungo12.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo13.y+3 AND ((fungo13.x-4 >= centi1.x-2 AND fungo13.x-4 <= centi1.x+8) OR (fungo13.x+4 >= centi1.x-2 AND fungo13.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo14.y+3 AND ((fungo14.x-4 >= centi1.x-2 AND fungo14.x-4 <= centi1.x+8) OR (fungo14.x+4 >= centi1.x-2 AND fungo14.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo15.y+3 AND ((fungo15.x-4 >= centi1.x-2 AND fungo15.x-4 <= centi1.x+8) OR (fungo15.x+4 >= centi1.x-2 AND fungo15.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo16.y+3 AND ((fungo16.x-4 >= centi1.x-2 AND fungo16.x-4 <= centi1.x+8) OR (fungo16.x+4 >= centi1.x-2 AND fungo16.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo17.y+3 AND ((fungo17.x-4 >= centi1.x-2 AND fungo17.x-4 <= centi1.x+8) OR (fungo17.x+4 >= centi1.x-2 AND fungo17.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo18.y+3 AND ((fungo18.x-4 >= centi1.x-2 AND fungo18.x-4 <= centi1.x+8) OR (fungo18.x+4 >= centi1.x-2 AND fungo18.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo19.y+3 AND ((fungo19.x-4 >= centi1.x-2 AND fungo19.x-4 <= centi1.x+8) OR (fungo19.x+4 >= centi1.x-2 AND fungo19.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo20.y+3 AND ((fungo20.x-4 >= centi1.x-2 AND fungo20.x-4 <= centi1.x+8) OR (fungo20.x+4 >= centi1.x-2 AND fungo20.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo21.y+3 AND ((fungo21.x-4 >= centi1.x-2 AND fungo21.x-4 <= centi1.x+8) OR (fungo21.x+4 >= centi1.x-2 AND fungo21.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo22.y+3 AND ((fungo22.x-4 >= centi1.x-2 AND fungo22.x-4 <= centi1.x+8) OR (fungo22.x+4 >= centi1.x-2 AND fungo22.x+4 <= centi1.x+8)))
										OR (centi1.y+8 >= fungo23.y+3 AND ((fungo23.x-4 >= centi1.x-2 AND fungo23.x-4 <= centi1.x+8) OR (fungo23.x+4 >= centi1.x-2 AND fungo23.x+4 <= centi1.x+8))) then
										
										centi1.x := centi1.x + 12;
										dirR1 := '0';
									else
										centi1.y := centi1.y + 1;
									end if;
								end if;
							end if;
							if dirR1 = '0' then
									if (centi1.y <= leftBorder+2) then
										centi1.x := centi1.x + 12;
										dirR1 := '1';
									else
										if (centi1.y <= fungo0.y+8 AND ((fungo0.x-4 >= centi1.x-2 AND fungo0.x-4 <= centi1.x+8) OR (fungo0.x+4 >= centi1.x-2 AND fungo0.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo1.y+8 AND ((fungo1.x-4 >= centi1.x-2 AND fungo1.x-4 <= centi1.x+8) OR (fungo1.x+4 >= centi1.x-2 AND fungo1.x+4 <= centi1.x+8) )) OR 
											(centi1.y <= fungo2.y+8 AND ((fungo2.x-4 >= centi1.x-2 AND fungo2.x-4 <= centi1.x+8) OR (fungo2.x+4 >= centi1.x-2 AND fungo2.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo3.y+8 AND ((fungo3.x-4 >= centi1.x-2 AND fungo3.x-4 <= centi1.x+8) OR (fungo3.x+4 >= centi1.x-2 AND fungo3.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo4.y+8 AND ((fungo4.x-4 >= centi1.x-2 AND fungo4.x-4 <= centi1.x+8) OR (fungo4.x+4 >= centi1.x-2 AND fungo4.x+4 <= centi1.x+8) )) OR 
											(centi1.y <= fungo5.y+8 AND ((fungo5.x-4 >= centi1.x-2 AND fungo5.x-4 <= centi1.x+8) OR (fungo5.x+4 >= centi1.x-2 AND fungo5.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo6.y+8 AND ((fungo6.x-4 >= centi1.x-2 AND fungo6.x-4 <= centi1.x+8) OR (fungo6.x+4 >= centi1.x-2 AND fungo6.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo7.y+8 AND ((fungo7.x-4 >= centi1.x-2 AND fungo7.x-4 <= centi1.x+8) OR (fungo7.x+4 >= centi1.x-2 AND fungo7.x+4 <= centi1.x+8) )) OR 
											(centi1.y <= fungo8.y+8 AND ((fungo8.x-4 >= centi1.x-2 AND fungo8.x-4 <= centi1.x+8) OR (fungo8.x+4 >= centi1.x-2 AND fungo8.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo9.y+8 AND ((fungo9.x-4 >= centi1.x-2 AND fungo9.x-4 <= centi1.x+8) OR (fungo9.x+4 >= centi1.x-2 AND fungo9.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo10.y+8 AND ((fungo10.x-4 >= centi1.x-2 AND fungo10.x-4 <= centi1.x+8) OR (fungo10.x+4 >= centi1.x-2 AND fungo10.x+4 <= centi1.x+8) )) OR 
											(centi1.y <= fungo11.y+8 AND ((fungo11.x-4 >= centi1.x-2 AND fungo11.x-4 <= centi1.x+8) OR (fungo11.x+4 >= centi1.x-2 AND fungo11.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo12.y+8 AND ((fungo12.x-4 >= centi1.x-2 AND fungo12.x-4 <= centi1.x+8) OR (fungo12.x+4 >= centi1.x-2 AND fungo12.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo13.y+8 AND ((fungo13.x-4 >= centi1.x-2 AND fungo13.x-4 <= centi1.x+8) OR (fungo13.x+4 >= centi1.x-2 AND fungo13.x+4 <= centi1.x+8) )) OR 
											(centi1.y <= fungo14.y+8 AND ((fungo14.x-4 >= centi1.x-2 AND fungo14.x-4 <= centi1.x+8) OR (fungo14.x+4 >= centi1.x-2 AND fungo14.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo15.y+8 AND ((fungo15.x-4 >= centi1.x-2 AND fungo15.x-4 <= centi1.x+8) OR (fungo15.x+4 >= centi1.x-2 AND fungo15.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo16.y+8 AND ((fungo16.x-4 >= centi1.x-2 AND fungo16.x-4 <= centi1.x+8) OR (fungo16.x+4 >= centi1.x-2 AND fungo16.x+4 <= centi1.x+8) )) OR 
											(centi1.y <= fungo17.y+8 AND ((fungo17.x-4 >= centi1.x-2 AND fungo17.x-4 <= centi1.x+8) OR (fungo17.x+4 >= centi1.x-2 AND fungo17.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo18.y+8 AND ((fungo18.x-4 >= centi1.x-2 AND fungo18.x-4 <= centi1.x+8) OR (fungo18.x+4 >= centi1.x-2 AND fungo18.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo19.y+8 AND ((fungo19.x-4 >= centi1.x-2 AND fungo19.x-4 <= centi1.x+8) OR (fungo19.x+4 >= centi1.x-2 AND fungo19.x+4 <= centi1.x+8) )) OR 
											(centi1.y <= fungo20.y+8 AND ((fungo20.x-4 >= centi1.x-2 AND fungo20.x-4 <= centi1.x+8) OR (fungo20.x+4 >= centi1.x-2 AND fungo20.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo21.y+8 AND ((fungo21.x-4 >= centi1.x-2 AND fungo21.x-4 <= centi1.x+8) OR (fungo21.x+4 >= centi1.x-2 AND fungo21.x+4 <= centi1.x+8) )) OR
											(centi1.y <= fungo22.y+8 AND ((fungo22.x-4 >= centi1.x-2 AND fungo22.x-4 <= centi1.x+8) OR (fungo22.x+4 >= centi1.x-2 AND fungo22.x+4 <= centi1.x+8) )) OR 
											(centi1.y <= fungo23.y+8 AND ((fungo23.x-4 >= centi1.x-2 AND fungo23.x-4 <= centi1.x+8) OR (fungo23.x+4 >= centi1.x-2 AND fungo23.x+4 <= centi1.x+8) )) then
											
											--centi1.x := centi1.x + 12;
											dirR1 := '1';
										else
											centi1.y := centi1.y - 1;
										end if;
									end if;
							end if;
						end if;
						
						if centi2.x /= -1 then
							if dirR2 = '1' then
								if centi2.y >= rightBorder-18 then
									centi2.x := centi2.x + 12;
									dirR2 := '0';
								else
									if (centi2.y+8 >= fungo0.y+3 AND ((fungo0.x-4 >= centi2.x-2 AND fungo0.x-4 <= centi2.x+8) OR (fungo0.x+4 >= centi2.x-2 AND fungo0.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo1.y+3 AND ((fungo1.x-4 >= centi2.x-2 AND fungo1.x-4 <= centi2.x+8) OR (fungo1.x+4 >= centi2.x-2 AND fungo1.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo2.y+3 AND ((fungo2.x-4 >= centi2.x-2 AND fungo2.x-4 <= centi2.x+8) OR (fungo2.x+4 >= centi2.x-2 AND fungo2.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo3.y+3 AND ((fungo3.x-4 >= centi2.x-2 AND fungo3.x-4 <= centi2.x+8) OR (fungo3.x+4 >= centi2.x-2 AND fungo3.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo4.y+3 AND ((fungo4.x-4 >= centi2.x-2 AND fungo4.x-4 <= centi2.x+8) OR (fungo4.x+4 >= centi2.x-2 AND fungo4.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo5.y+3 AND ((fungo5.x-4 >= centi2.x-2 AND fungo5.x-4 <= centi2.x+8) OR (fungo5.x+4 >= centi2.x-2 AND fungo5.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo6.y+3 AND ((fungo6.x-4 >= centi2.x-2 AND fungo6.x-4 <= centi2.x+8) OR (fungo6.x+4 >= centi2.x-2 AND fungo6.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo7.y+3 AND ((fungo7.x-4 >= centi2.x-2 AND fungo7.x-4 <= centi2.x+8) OR (fungo7.x+4 >= centi2.x-2 AND fungo7.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo8.y+3 AND ((fungo8.x-4 >= centi2.x-2 AND fungo8.x-4 <= centi2.x+8) OR (fungo8.x+4 >= centi2.x-2 AND fungo8.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo9.y+3 AND ((fungo9.x-4 >= centi2.x-2 AND fungo9.x-4 <= centi2.x+8) OR (fungo9.x+4 >= centi2.x-2 AND fungo9.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo10.y+3 AND ((fungo10.x-4 >= centi2.x-2 AND fungo10.x-4 <= centi2.x+8) OR (fungo10.x+4 >= centi2.x-2 AND fungo10.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo11.y+3 AND ((fungo11.x-4 >= centi2.x-2 AND fungo11.x-4 <= centi2.x+8) OR (fungo11.x+4 >= centi2.x-2 AND fungo11.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo12.y+3 AND ((fungo12.x-4 >= centi2.x-2 AND fungo12.x-4 <= centi2.x+8) OR (fungo12.x+4 >= centi2.x-2 AND fungo12.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo13.y+3 AND ((fungo13.x-4 >= centi2.x-2 AND fungo13.x-4 <= centi2.x+8) OR (fungo13.x+4 >= centi2.x-2 AND fungo13.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo14.y+3 AND ((fungo14.x-4 >= centi2.x-2 AND fungo14.x-4 <= centi2.x+8) OR (fungo14.x+4 >= centi2.x-2 AND fungo14.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo15.y+3 AND ((fungo15.x-4 >= centi2.x-2 AND fungo15.x-4 <= centi2.x+8) OR (fungo15.x+4 >= centi2.x-2 AND fungo15.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo16.y+3 AND ((fungo16.x-4 >= centi2.x-2 AND fungo16.x-4 <= centi2.x+8) OR (fungo16.x+4 >= centi2.x-2 AND fungo16.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo17.y+3 AND ((fungo17.x-4 >= centi2.x-2 AND fungo17.x-4 <= centi2.x+8) OR (fungo17.x+4 >= centi2.x-2 AND fungo17.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo18.y+3 AND ((fungo18.x-4 >= centi2.x-2 AND fungo18.x-4 <= centi2.x+8) OR (fungo18.x+4 >= centi2.x-2 AND fungo18.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo19.y+3 AND ((fungo19.x-4 >= centi2.x-2 AND fungo19.x-4 <= centi2.x+8) OR (fungo19.x+4 >= centi2.x-2 AND fungo19.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo20.y+3 AND ((fungo20.x-4 >= centi2.x-2 AND fungo20.x-4 <= centi2.x+8) OR (fungo20.x+4 >= centi2.x-2 AND fungo20.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo21.y+3 AND ((fungo21.x-4 >= centi2.x-2 AND fungo21.x-4 <= centi2.x+8) OR (fungo21.x+4 >= centi2.x-2 AND fungo21.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo22.y+3 AND ((fungo22.x-4 >= centi2.x-2 AND fungo22.x-4 <= centi2.x+8) OR (fungo22.x+4 >= centi2.x-2 AND fungo22.x+4 <= centi2.x+8)))
										OR (centi2.y+8 >= fungo23.y+3 AND ((fungo23.x-4 >= centi2.x-2 AND fungo23.x-4 <= centi2.x+8) OR (fungo23.x+4 >= centi2.x-2 AND fungo23.x+4 <= centi2.x+8))) then
										
										centi2.x := centi2.x + 12;
										dirR2 := '0';
									else
										centi2.y := centi2.y + 1;
									end if;
								end if;
							end if;
							if dirR2 = '0' then
									if (centi2.y <= leftBorder+2) then
										centi2.x := centi2.x + 12;
										dirR2 := '1';
									else
										if (centi2.y <= fungo0.y+8 AND ((fungo0.x-4 >= centi2.x-2 AND fungo0.x-4 <= centi2.x+8) OR (fungo0.x+4 >= centi2.x-2 AND fungo0.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo1.y+8 AND ((fungo1.x-4 >= centi2.x-2 AND fungo1.x-4 <= centi2.x+8) OR (fungo1.x+4 >= centi2.x-2 AND fungo1.x+4 <= centi2.x+8) )) OR 
											(centi2.y <= fungo2.y+8 AND ((fungo2.x-4 >= centi2.x-2 AND fungo2.x-4 <= centi2.x+8) OR (fungo2.x+4 >= centi2.x-2 AND fungo2.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo3.y+8 AND ((fungo3.x-4 >= centi2.x-2 AND fungo3.x-4 <= centi2.x+8) OR (fungo3.x+4 >= centi2.x-2 AND fungo3.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo4.y+8 AND ((fungo4.x-4 >= centi2.x-2 AND fungo4.x-4 <= centi2.x+8) OR (fungo4.x+4 >= centi2.x-2 AND fungo4.x+4 <= centi2.x+8) )) OR 
											(centi2.y <= fungo5.y+8 AND ((fungo5.x-4 >= centi2.x-2 AND fungo5.x-4 <= centi2.x+8) OR (fungo5.x+4 >= centi2.x-2 AND fungo5.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo6.y+8 AND ((fungo6.x-4 >= centi2.x-2 AND fungo6.x-4 <= centi2.x+8) OR (fungo6.x+4 >= centi2.x-2 AND fungo6.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo7.y+8 AND ((fungo7.x-4 >= centi2.x-2 AND fungo7.x-4 <= centi2.x+8) OR (fungo7.x+4 >= centi2.x-2 AND fungo7.x+4 <= centi2.x+8) )) OR 
											(centi2.y <= fungo8.y+8 AND ((fungo8.x-4 >= centi2.x-2 AND fungo8.x-4 <= centi2.x+8) OR (fungo8.x+4 >= centi2.x-2 AND fungo8.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo9.y+8 AND ((fungo9.x-4 >= centi2.x-2 AND fungo9.x-4 <= centi2.x+8) OR (fungo9.x+4 >= centi2.x-2 AND fungo9.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo10.y+8 AND ((fungo10.x-4 >= centi2.x-2 AND fungo10.x-4 <= centi2.x+8) OR (fungo10.x+4 >= centi2.x-2 AND fungo10.x+4 <= centi2.x+8) )) OR 
											(centi2.y <= fungo11.y+8 AND ((fungo11.x-4 >= centi2.x-2 AND fungo11.x-4 <= centi2.x+8) OR (fungo11.x+4 >= centi2.x-2 AND fungo11.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo12.y+8 AND ((fungo12.x-4 >= centi2.x-2 AND fungo12.x-4 <= centi2.x+8) OR (fungo12.x+4 >= centi2.x-2 AND fungo12.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo13.y+8 AND ((fungo13.x-4 >= centi2.x-2 AND fungo13.x-4 <= centi2.x+8) OR (fungo13.x+4 >= centi2.x-2 AND fungo13.x+4 <= centi2.x+8) )) OR 
											(centi2.y <= fungo14.y+8 AND ((fungo14.x-4 >= centi2.x-2 AND fungo14.x-4 <= centi2.x+8) OR (fungo14.x+4 >= centi2.x-2 AND fungo14.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo15.y+8 AND ((fungo15.x-4 >= centi2.x-2 AND fungo15.x-4 <= centi2.x+8) OR (fungo15.x+4 >= centi2.x-2 AND fungo15.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo16.y+8 AND ((fungo16.x-4 >= centi2.x-2 AND fungo16.x-4 <= centi2.x+8) OR (fungo16.x+4 >= centi2.x-2 AND fungo16.x+4 <= centi2.x+8) )) OR 
											(centi2.y <= fungo17.y+8 AND ((fungo17.x-4 >= centi2.x-2 AND fungo17.x-4 <= centi2.x+8) OR (fungo17.x+4 >= centi2.x-2 AND fungo17.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo18.y+8 AND ((fungo18.x-4 >= centi2.x-2 AND fungo18.x-4 <= centi2.x+8) OR (fungo18.x+4 >= centi2.x-2 AND fungo18.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo19.y+8 AND ((fungo19.x-4 >= centi2.x-2 AND fungo19.x-4 <= centi2.x+8) OR (fungo19.x+4 >= centi2.x-2 AND fungo19.x+4 <= centi2.x+8) )) OR 
											(centi2.y <= fungo20.y+8 AND ((fungo20.x-4 >= centi2.x-2 AND fungo20.x-4 <= centi2.x+8) OR (fungo20.x+4 >= centi2.x-2 AND fungo20.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo21.y+8 AND ((fungo21.x-4 >= centi2.x-2 AND fungo21.x-4 <= centi2.x+8) OR (fungo21.x+4 >= centi2.x-2 AND fungo21.x+4 <= centi2.x+8) )) OR
											(centi2.y <= fungo22.y+8 AND ((fungo22.x-4 >= centi2.x-2 AND fungo22.x-4 <= centi2.x+8) OR (fungo22.x+4 >= centi2.x-2 AND fungo22.x+4 <= centi2.x+8) )) OR 
											(centi2.y <= fungo23.y+8 AND ((fungo23.x-4 >= centi2.x-2 AND fungo23.x-4 <= centi2.x+8) OR (fungo23.x+4 >= centi2.x-2 AND fungo23.x+4 <= centi2.x+8) )) then
											
											--centi2.x := centi2.x + 12;
											dirR2 := '1';
										else
											centi2.y := centi2.y - 1;
										end if;
									end if;
							end if;
						end if;
						if centi3.x /= -1 then
							if dirR3 = '1' then
								if centi3.y >= rightBorder-18 then
									centi3.x := centi3.x + 12;
									dirR3 := '0';
								else
									if (centi3.y+8 >= fungo0.y+3 AND ((fungo0.x-4 >= centi3.x-2 AND fungo0.x-4 <= centi3.x+8) OR (fungo0.x+4 >= centi3.x-2 AND fungo0.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo1.y+3 AND ((fungo1.x-4 >= centi3.x-2 AND fungo1.x-4 <= centi3.x+8) OR (fungo1.x+4 >= centi3.x-2 AND fungo1.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo2.y+3 AND ((fungo2.x-4 >= centi3.x-2 AND fungo2.x-4 <= centi3.x+8) OR (fungo2.x+4 >= centi3.x-2 AND fungo2.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo3.y+3 AND ((fungo3.x-4 >= centi3.x-2 AND fungo3.x-4 <= centi3.x+8) OR (fungo3.x+4 >= centi3.x-2 AND fungo3.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo4.y+3 AND ((fungo4.x-4 >= centi3.x-2 AND fungo4.x-4 <= centi3.x+8) OR (fungo4.x+4 >= centi3.x-2 AND fungo4.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo5.y+3 AND ((fungo5.x-4 >= centi3.x-2 AND fungo5.x-4 <= centi3.x+8) OR (fungo5.x+4 >= centi3.x-2 AND fungo5.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo6.y+3 AND ((fungo6.x-4 >= centi3.x-2 AND fungo6.x-4 <= centi3.x+8) OR (fungo6.x+4 >= centi3.x-2 AND fungo6.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo7.y+3 AND ((fungo7.x-4 >= centi3.x-2 AND fungo7.x-4 <= centi3.x+8) OR (fungo7.x+4 >= centi3.x-2 AND fungo7.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo8.y+3 AND ((fungo8.x-4 >= centi3.x-2 AND fungo8.x-4 <= centi3.x+8) OR (fungo8.x+4 >= centi3.x-2 AND fungo8.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo9.y+3 AND ((fungo9.x-4 >= centi3.x-2 AND fungo9.x-4 <= centi3.x+8) OR (fungo9.x+4 >= centi3.x-2 AND fungo9.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo10.y+3 AND ((fungo10.x-4 >= centi3.x-2 AND fungo10.x-4 <= centi3.x+8) OR (fungo10.x+4 >= centi3.x-2 AND fungo10.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo11.y+3 AND ((fungo11.x-4 >= centi3.x-2 AND fungo11.x-4 <= centi3.x+8) OR (fungo11.x+4 >= centi3.x-2 AND fungo11.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo12.y+3 AND ((fungo12.x-4 >= centi3.x-2 AND fungo12.x-4 <= centi3.x+8) OR (fungo12.x+4 >= centi3.x-2 AND fungo12.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo13.y+3 AND ((fungo13.x-4 >= centi3.x-2 AND fungo13.x-4 <= centi3.x+8) OR (fungo13.x+4 >= centi3.x-2 AND fungo13.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo14.y+3 AND ((fungo14.x-4 >= centi3.x-2 AND fungo14.x-4 <= centi3.x+8) OR (fungo14.x+4 >= centi3.x-2 AND fungo14.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo15.y+3 AND ((fungo15.x-4 >= centi3.x-2 AND fungo15.x-4 <= centi3.x+8) OR (fungo15.x+4 >= centi3.x-2 AND fungo15.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo16.y+3 AND ((fungo16.x-4 >= centi3.x-2 AND fungo16.x-4 <= centi3.x+8) OR (fungo16.x+4 >= centi3.x-2 AND fungo16.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo17.y+3 AND ((fungo17.x-4 >= centi3.x-2 AND fungo17.x-4 <= centi3.x+8) OR (fungo17.x+4 >= centi3.x-2 AND fungo17.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo18.y+3 AND ((fungo18.x-4 >= centi3.x-2 AND fungo18.x-4 <= centi3.x+8) OR (fungo18.x+4 >= centi3.x-2 AND fungo18.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo19.y+3 AND ((fungo19.x-4 >= centi3.x-2 AND fungo19.x-4 <= centi3.x+8) OR (fungo19.x+4 >= centi3.x-2 AND fungo19.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo20.y+3 AND ((fungo20.x-4 >= centi3.x-2 AND fungo20.x-4 <= centi3.x+8) OR (fungo20.x+4 >= centi3.x-2 AND fungo20.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo21.y+3 AND ((fungo21.x-4 >= centi3.x-2 AND fungo21.x-4 <= centi3.x+8) OR (fungo21.x+4 >= centi3.x-2 AND fungo21.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo22.y+3 AND ((fungo22.x-4 >= centi3.x-2 AND fungo22.x-4 <= centi3.x+8) OR (fungo22.x+4 >= centi3.x-2 AND fungo22.x+4 <= centi3.x+8)))
										OR (centi3.y+8 >= fungo23.y+3 AND ((fungo23.x-4 >= centi3.x-2 AND fungo23.x-4 <= centi3.x+8) OR (fungo23.x+4 >= centi3.x-2 AND fungo23.x+4 <= centi3.x+8))) then
										
										centi3.x := centi3.x + 12;
										dirR3 := '0';
									else
										centi3.y := centi3.y + 1;
									end if;
								end if;
							end if;
							if dirR3 = '0' then
									if (centi3.y <= leftBorder+2) then
										centi3.x := centi3.x + 12;
										dirR3 := '1';
									else
										if (centi3.y <= fungo0.y+8 AND ((fungo0.x-4 >= centi3.x-2 AND fungo0.x-4 <= centi3.x+8) OR (fungo0.x+4 >= centi3.x-2 AND fungo0.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo1.y+8 AND ((fungo1.x-4 >= centi3.x-2 AND fungo1.x-4 <= centi3.x+8) OR (fungo1.x+4 >= centi3.x-2 AND fungo1.x+4 <= centi3.x+8) )) OR 
											(centi3.y <= fungo2.y+8 AND ((fungo2.x-4 >= centi3.x-2 AND fungo2.x-4 <= centi3.x+8) OR (fungo2.x+4 >= centi3.x-2 AND fungo2.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo3.y+8 AND ((fungo3.x-4 >= centi3.x-2 AND fungo3.x-4 <= centi3.x+8) OR (fungo3.x+4 >= centi3.x-2 AND fungo3.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo4.y+8 AND ((fungo4.x-4 >= centi3.x-2 AND fungo4.x-4 <= centi3.x+8) OR (fungo4.x+4 >= centi3.x-2 AND fungo4.x+4 <= centi3.x+8) )) OR 
											(centi3.y <= fungo5.y+8 AND ((fungo5.x-4 >= centi3.x-2 AND fungo5.x-4 <= centi3.x+8) OR (fungo5.x+4 >= centi3.x-2 AND fungo5.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo6.y+8 AND ((fungo6.x-4 >= centi3.x-2 AND fungo6.x-4 <= centi3.x+8) OR (fungo6.x+4 >= centi3.x-2 AND fungo6.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo7.y+8 AND ((fungo7.x-4 >= centi3.x-2 AND fungo7.x-4 <= centi3.x+8) OR (fungo7.x+4 >= centi3.x-2 AND fungo7.x+4 <= centi3.x+8) )) OR 
											(centi3.y <= fungo8.y+8 AND ((fungo8.x-4 >= centi3.x-2 AND fungo8.x-4 <= centi3.x+8) OR (fungo8.x+4 >= centi3.x-2 AND fungo8.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo9.y+8 AND ((fungo9.x-4 >= centi3.x-2 AND fungo9.x-4 <= centi3.x+8) OR (fungo9.x+4 >= centi3.x-2 AND fungo9.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo10.y+8 AND ((fungo10.x-4 >= centi3.x-2 AND fungo10.x-4 <= centi3.x+8) OR (fungo10.x+4 >= centi3.x-2 AND fungo10.x+4 <= centi3.x+8) )) OR 
											(centi3.y <= fungo11.y+8 AND ((fungo11.x-4 >= centi3.x-2 AND fungo11.x-4 <= centi3.x+8) OR (fungo11.x+4 >= centi3.x-2 AND fungo11.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo12.y+8 AND ((fungo12.x-4 >= centi3.x-2 AND fungo12.x-4 <= centi3.x+8) OR (fungo12.x+4 >= centi3.x-2 AND fungo12.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo13.y+8 AND ((fungo13.x-4 >= centi3.x-2 AND fungo13.x-4 <= centi3.x+8) OR (fungo13.x+4 >= centi3.x-2 AND fungo13.x+4 <= centi3.x+8) )) OR 
											(centi3.y <= fungo14.y+8 AND ((fungo14.x-4 >= centi3.x-2 AND fungo14.x-4 <= centi3.x+8) OR (fungo14.x+4 >= centi3.x-2 AND fungo14.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo15.y+8 AND ((fungo15.x-4 >= centi3.x-2 AND fungo15.x-4 <= centi3.x+8) OR (fungo15.x+4 >= centi3.x-2 AND fungo15.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo16.y+8 AND ((fungo16.x-4 >= centi3.x-2 AND fungo16.x-4 <= centi3.x+8) OR (fungo16.x+4 >= centi3.x-2 AND fungo16.x+4 <= centi3.x+8) )) OR 
											(centi3.y <= fungo17.y+8 AND ((fungo17.x-4 >= centi3.x-2 AND fungo17.x-4 <= centi3.x+8) OR (fungo17.x+4 >= centi3.x-2 AND fungo17.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo18.y+8 AND ((fungo18.x-4 >= centi3.x-2 AND fungo18.x-4 <= centi3.x+8) OR (fungo18.x+4 >= centi3.x-2 AND fungo18.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo19.y+8 AND ((fungo19.x-4 >= centi3.x-2 AND fungo19.x-4 <= centi3.x+8) OR (fungo19.x+4 >= centi3.x-2 AND fungo19.x+4 <= centi3.x+8) )) OR 
											(centi3.y <= fungo20.y+8 AND ((fungo20.x-4 >= centi3.x-2 AND fungo20.x-4 <= centi3.x+8) OR (fungo20.x+4 >= centi3.x-2 AND fungo20.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo21.y+8 AND ((fungo21.x-4 >= centi3.x-2 AND fungo21.x-4 <= centi3.x+8) OR (fungo21.x+4 >= centi3.x-2 AND fungo21.x+4 <= centi3.x+8) )) OR
											(centi3.y <= fungo22.y+8 AND ((fungo22.x-4 >= centi3.x-2 AND fungo22.x-4 <= centi3.x+8) OR (fungo22.x+4 >= centi3.x-2 AND fungo22.x+4 <= centi3.x+8) )) OR 
											(centi3.y <= fungo23.y+8 AND ((fungo23.x-4 >= centi3.x-2 AND fungo23.x-4 <= centi3.x+8) OR (fungo23.x+4 >= centi3.x-2 AND fungo23.x+4 <= centi3.x+8) )) then
											
											--centi3.x := centi3.x + 12;
											dirR3 := '1';
										else
											centi3.y := centi3.y - 1;
										end if;
									end if;
							end if;
						end if;
						
						if centi4.x /= -1 then
							if dirR4 = '1' then
								if centi4.y >= rightBorder-18 then
									centi4.x := centi4.x + 12;
									dirR4 := '0';
								else
									if (centi4.y+8 >= fungo0.y+3 AND ((fungo0.x-4 >= centi4.x-2 AND fungo0.x-4 <= centi4.x+8) OR (fungo0.x+4 >= centi4.x-2 AND fungo0.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo1.y+3 AND ((fungo1.x-4 >= centi4.x-2 AND fungo1.x-4 <= centi4.x+8) OR (fungo1.x+4 >= centi4.x-2 AND fungo1.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo2.y+3 AND ((fungo2.x-4 >= centi4.x-2 AND fungo2.x-4 <= centi4.x+8) OR (fungo2.x+4 >= centi4.x-2 AND fungo2.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo3.y+3 AND ((fungo3.x-4 >= centi4.x-2 AND fungo3.x-4 <= centi4.x+8) OR (fungo3.x+4 >= centi4.x-2 AND fungo3.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo4.y+3 AND ((fungo4.x-4 >= centi4.x-2 AND fungo4.x-4 <= centi4.x+8) OR (fungo4.x+4 >= centi4.x-2 AND fungo4.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo5.y+3 AND ((fungo5.x-4 >= centi4.x-2 AND fungo5.x-4 <= centi4.x+8) OR (fungo5.x+4 >= centi4.x-2 AND fungo5.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo6.y+3 AND ((fungo6.x-4 >= centi4.x-2 AND fungo6.x-4 <= centi4.x+8) OR (fungo6.x+4 >= centi4.x-2 AND fungo6.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo7.y+3 AND ((fungo7.x-4 >= centi4.x-2 AND fungo7.x-4 <= centi4.x+8) OR (fungo7.x+4 >= centi4.x-2 AND fungo7.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo8.y+3 AND ((fungo8.x-4 >= centi4.x-2 AND fungo8.x-4 <= centi4.x+8) OR (fungo8.x+4 >= centi4.x-2 AND fungo8.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo9.y+3 AND ((fungo9.x-4 >= centi4.x-2 AND fungo9.x-4 <= centi4.x+8) OR (fungo9.x+4 >= centi4.x-2 AND fungo9.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo10.y+3 AND ((fungo10.x-4 >= centi4.x-2 AND fungo10.x-4 <= centi4.x+8) OR (fungo10.x+4 >= centi4.x-2 AND fungo10.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo11.y+3 AND ((fungo11.x-4 >= centi4.x-2 AND fungo11.x-4 <= centi4.x+8) OR (fungo11.x+4 >= centi4.x-2 AND fungo11.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo12.y+3 AND ((fungo12.x-4 >= centi4.x-2 AND fungo12.x-4 <= centi4.x+8) OR (fungo12.x+4 >= centi4.x-2 AND fungo12.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo13.y+3 AND ((fungo13.x-4 >= centi4.x-2 AND fungo13.x-4 <= centi4.x+8) OR (fungo13.x+4 >= centi4.x-2 AND fungo13.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo14.y+3 AND ((fungo14.x-4 >= centi4.x-2 AND fungo14.x-4 <= centi4.x+8) OR (fungo14.x+4 >= centi4.x-2 AND fungo14.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo15.y+3 AND ((fungo15.x-4 >= centi4.x-2 AND fungo15.x-4 <= centi4.x+8) OR (fungo15.x+4 >= centi4.x-2 AND fungo15.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo16.y+3 AND ((fungo16.x-4 >= centi4.x-2 AND fungo16.x-4 <= centi4.x+8) OR (fungo16.x+4 >= centi4.x-2 AND fungo16.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo17.y+3 AND ((fungo17.x-4 >= centi4.x-2 AND fungo17.x-4 <= centi4.x+8) OR (fungo17.x+4 >= centi4.x-2 AND fungo17.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo18.y+3 AND ((fungo18.x-4 >= centi4.x-2 AND fungo18.x-4 <= centi4.x+8) OR (fungo18.x+4 >= centi4.x-2 AND fungo18.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo19.y+3 AND ((fungo19.x-4 >= centi4.x-2 AND fungo19.x-4 <= centi4.x+8) OR (fungo19.x+4 >= centi4.x-2 AND fungo19.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo20.y+3 AND ((fungo20.x-4 >= centi4.x-2 AND fungo20.x-4 <= centi4.x+8) OR (fungo20.x+4 >= centi4.x-2 AND fungo20.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo21.y+3 AND ((fungo21.x-4 >= centi4.x-2 AND fungo21.x-4 <= centi4.x+8) OR (fungo21.x+4 >= centi4.x-2 AND fungo21.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo22.y+3 AND ((fungo22.x-4 >= centi4.x-2 AND fungo22.x-4 <= centi4.x+8) OR (fungo22.x+4 >= centi4.x-2 AND fungo22.x+4 <= centi4.x+8)))
										OR (centi4.y+8 >= fungo23.y+3 AND ((fungo23.x-4 >= centi4.x-2 AND fungo23.x-4 <= centi4.x+8) OR (fungo23.x+4 >= centi4.x-2 AND fungo23.x+4 <= centi4.x+8))) then
										
										centi4.x := centi4.x + 12;
										dirR4 := '0';
									else
										centi4.y := centi4.y + 1;
									end if;
								end if;
							end if;
							if dirR4 = '0' then
									if (centi4.y <= leftBorder+2) then
										centi4.x := centi4.x + 12;
										dirR4 := '1';
									else
										if (centi4.y <= fungo0.y+8 AND ((fungo0.x-4 >= centi4.x-2 AND fungo0.x-4 <= centi4.x+8) OR (fungo0.x+4 >= centi4.x-2 AND fungo0.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo1.y+8 AND ((fungo1.x-4 >= centi4.x-2 AND fungo1.x-4 <= centi4.x+8) OR (fungo1.x+4 >= centi4.x-2 AND fungo1.x+4 <= centi4.x+8) )) OR 
											(centi4.y <= fungo2.y+8 AND ((fungo2.x-4 >= centi4.x-2 AND fungo2.x-4 <= centi4.x+8) OR (fungo2.x+4 >= centi4.x-2 AND fungo2.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo3.y+8 AND ((fungo3.x-4 >= centi4.x-2 AND fungo3.x-4 <= centi4.x+8) OR (fungo3.x+4 >= centi4.x-2 AND fungo3.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo4.y+8 AND ((fungo4.x-4 >= centi4.x-2 AND fungo4.x-4 <= centi4.x+8) OR (fungo4.x+4 >= centi4.x-2 AND fungo4.x+4 <= centi4.x+8) )) OR 
											(centi4.y <= fungo5.y+8 AND ((fungo5.x-4 >= centi4.x-2 AND fungo5.x-4 <= centi4.x+8) OR (fungo5.x+4 >= centi4.x-2 AND fungo5.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo6.y+8 AND ((fungo6.x-4 >= centi4.x-2 AND fungo6.x-4 <= centi4.x+8) OR (fungo6.x+4 >= centi4.x-2 AND fungo6.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo7.y+8 AND ((fungo7.x-4 >= centi4.x-2 AND fungo7.x-4 <= centi4.x+8) OR (fungo7.x+4 >= centi4.x-2 AND fungo7.x+4 <= centi4.x+8) )) OR 
											(centi4.y <= fungo8.y+8 AND ((fungo8.x-4 >= centi4.x-2 AND fungo8.x-4 <= centi4.x+8) OR (fungo8.x+4 >= centi4.x-2 AND fungo8.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo9.y+8 AND ((fungo9.x-4 >= centi4.x-2 AND fungo9.x-4 <= centi4.x+8) OR (fungo9.x+4 >= centi4.x-2 AND fungo9.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo10.y+8 AND ((fungo10.x-4 >= centi4.x-2 AND fungo10.x-4 <= centi4.x+8) OR (fungo10.x+4 >= centi4.x-2 AND fungo10.x+4 <= centi4.x+8) )) OR 
											(centi4.y <= fungo11.y+8 AND ((fungo11.x-4 >= centi4.x-2 AND fungo11.x-4 <= centi4.x+8) OR (fungo11.x+4 >= centi4.x-2 AND fungo11.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo12.y+8 AND ((fungo12.x-4 >= centi4.x-2 AND fungo12.x-4 <= centi4.x+8) OR (fungo12.x+4 >= centi4.x-2 AND fungo12.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo13.y+8 AND ((fungo13.x-4 >= centi4.x-2 AND fungo13.x-4 <= centi4.x+8) OR (fungo13.x+4 >= centi4.x-2 AND fungo13.x+4 <= centi4.x+8) )) OR 
											(centi4.y <= fungo14.y+8 AND ((fungo14.x-4 >= centi4.x-2 AND fungo14.x-4 <= centi4.x+8) OR (fungo14.x+4 >= centi4.x-2 AND fungo14.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo15.y+8 AND ((fungo15.x-4 >= centi4.x-2 AND fungo15.x-4 <= centi4.x+8) OR (fungo15.x+4 >= centi4.x-2 AND fungo15.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo16.y+8 AND ((fungo16.x-4 >= centi4.x-2 AND fungo16.x-4 <= centi4.x+8) OR (fungo16.x+4 >= centi4.x-2 AND fungo16.x+4 <= centi4.x+8) )) OR 
											(centi4.y <= fungo17.y+8 AND ((fungo17.x-4 >= centi4.x-2 AND fungo17.x-4 <= centi4.x+8) OR (fungo17.x+4 >= centi4.x-2 AND fungo17.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo18.y+8 AND ((fungo18.x-4 >= centi4.x-2 AND fungo18.x-4 <= centi4.x+8) OR (fungo18.x+4 >= centi4.x-2 AND fungo18.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo19.y+8 AND ((fungo19.x-4 >= centi4.x-2 AND fungo19.x-4 <= centi4.x+8) OR (fungo19.x+4 >= centi4.x-2 AND fungo19.x+4 <= centi4.x+8) )) OR 
											(centi4.y <= fungo20.y+8 AND ((fungo20.x-4 >= centi4.x-2 AND fungo20.x-4 <= centi4.x+8) OR (fungo20.x+4 >= centi4.x-2 AND fungo20.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo21.y+8 AND ((fungo21.x-4 >= centi4.x-2 AND fungo21.x-4 <= centi4.x+8) OR (fungo21.x+4 >= centi4.x-2 AND fungo21.x+4 <= centi4.x+8) )) OR
											(centi4.y <= fungo22.y+8 AND ((fungo22.x-4 >= centi4.x-2 AND fungo22.x-4 <= centi4.x+8) OR (fungo22.x+4 >= centi4.x-2 AND fungo22.x+4 <= centi4.x+8) )) OR 
											(centi4.y <= fungo23.y+8 AND ((fungo23.x-4 >= centi4.x-2 AND fungo23.x-4 <= centi4.x+8) OR (fungo23.x+4 >= centi4.x-2 AND fungo23.x+4 <= centi4.x+8) )) then
											
											--centi4.x := centi4.x + 12;
											dirR4 := '1';
										else
											centi4.y := centi4.y - 1;
										end if;
									end if;
							end if;
						end if;
						if centi5.x /= -1 then
							if dirR5 = '1' then
								if centi5.y >= rightBorder-18 then
									centi5.x := centi5.x + 12;
									dirR5 := '0';
								else
									if (centi5.y+8 >= fungo0.y+3 AND ((fungo0.x-4 >= centi5.x-2 AND fungo0.x-4 <= centi5.x+8) OR (fungo0.x+4 >= centi5.x-2 AND fungo0.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo1.y+3 AND ((fungo1.x-4 >= centi5.x-2 AND fungo1.x-4 <= centi5.x+8) OR (fungo1.x+4 >= centi5.x-2 AND fungo1.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo2.y+3 AND ((fungo2.x-4 >= centi5.x-2 AND fungo2.x-4 <= centi5.x+8) OR (fungo2.x+4 >= centi5.x-2 AND fungo2.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo3.y+3 AND ((fungo3.x-4 >= centi5.x-2 AND fungo3.x-4 <= centi5.x+8) OR (fungo3.x+4 >= centi5.x-2 AND fungo3.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo4.y+3 AND ((fungo4.x-4 >= centi5.x-2 AND fungo4.x-4 <= centi5.x+8) OR (fungo4.x+4 >= centi5.x-2 AND fungo4.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo5.y+3 AND ((fungo5.x-4 >= centi5.x-2 AND fungo5.x-4 <= centi5.x+8) OR (fungo5.x+4 >= centi5.x-2 AND fungo5.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo6.y+3 AND ((fungo6.x-4 >= centi5.x-2 AND fungo6.x-4 <= centi5.x+8) OR (fungo6.x+4 >= centi5.x-2 AND fungo6.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo7.y+3 AND ((fungo7.x-4 >= centi5.x-2 AND fungo7.x-4 <= centi5.x+8) OR (fungo7.x+4 >= centi5.x-2 AND fungo7.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo8.y+3 AND ((fungo8.x-4 >= centi5.x-2 AND fungo8.x-4 <= centi5.x+8) OR (fungo8.x+4 >= centi5.x-2 AND fungo8.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo9.y+3 AND ((fungo9.x-4 >= centi5.x-2 AND fungo9.x-4 <= centi5.x+8) OR (fungo9.x+4 >= centi5.x-2 AND fungo9.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo10.y+3 AND ((fungo10.x-4 >= centi5.x-2 AND fungo10.x-4 <= centi5.x+8) OR (fungo10.x+4 >= centi5.x-2 AND fungo10.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo11.y+3 AND ((fungo11.x-4 >= centi5.x-2 AND fungo11.x-4 <= centi5.x+8) OR (fungo11.x+4 >= centi5.x-2 AND fungo11.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo12.y+3 AND ((fungo12.x-4 >= centi5.x-2 AND fungo12.x-4 <= centi5.x+8) OR (fungo12.x+4 >= centi5.x-2 AND fungo12.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo13.y+3 AND ((fungo13.x-4 >= centi5.x-2 AND fungo13.x-4 <= centi5.x+8) OR (fungo13.x+4 >= centi5.x-2 AND fungo13.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo14.y+3 AND ((fungo14.x-4 >= centi5.x-2 AND fungo14.x-4 <= centi5.x+8) OR (fungo14.x+4 >= centi5.x-2 AND fungo14.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo15.y+3 AND ((fungo15.x-4 >= centi5.x-2 AND fungo15.x-4 <= centi5.x+8) OR (fungo15.x+4 >= centi5.x-2 AND fungo15.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo16.y+3 AND ((fungo16.x-4 >= centi5.x-2 AND fungo16.x-4 <= centi5.x+8) OR (fungo16.x+4 >= centi5.x-2 AND fungo16.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo17.y+3 AND ((fungo17.x-4 >= centi5.x-2 AND fungo17.x-4 <= centi5.x+8) OR (fungo17.x+4 >= centi5.x-2 AND fungo17.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo18.y+3 AND ((fungo18.x-4 >= centi5.x-2 AND fungo18.x-4 <= centi5.x+8) OR (fungo18.x+4 >= centi5.x-2 AND fungo18.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo19.y+3 AND ((fungo19.x-4 >= centi5.x-2 AND fungo19.x-4 <= centi5.x+8) OR (fungo19.x+4 >= centi5.x-2 AND fungo19.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo20.y+3 AND ((fungo20.x-4 >= centi5.x-2 AND fungo20.x-4 <= centi5.x+8) OR (fungo20.x+4 >= centi5.x-2 AND fungo20.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo21.y+3 AND ((fungo21.x-4 >= centi5.x-2 AND fungo21.x-4 <= centi5.x+8) OR (fungo21.x+4 >= centi5.x-2 AND fungo21.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo22.y+3 AND ((fungo22.x-4 >= centi5.x-2 AND fungo22.x-4 <= centi5.x+8) OR (fungo22.x+4 >= centi5.x-2 AND fungo22.x+4 <= centi5.x+8)))
										OR (centi5.y+8 >= fungo23.y+3 AND ((fungo23.x-4 >= centi5.x-2 AND fungo23.x-4 <= centi5.x+8) OR (fungo23.x+4 >= centi5.x-2 AND fungo23.x+4 <= centi5.x+8))) then
										
										centi5.x := centi5.x + 12;
										dirR5 := '0';
									else
										centi5.y := centi5.y + 1;
									end if;
								end if;
							end if;
							if dirR5 = '0' then
									if (centi5.y <= leftBorder+2) then
										centi5.x := centi5.x + 12;
										dirR5 := '1';
									else
										if (centi5.y <= fungo0.y+8 AND ((fungo0.x-4 >= centi5.x-2 AND fungo0.x-4 <= centi5.x+8) OR (fungo0.x+4 >= centi5.x-2 AND fungo0.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo1.y+8 AND ((fungo1.x-4 >= centi5.x-2 AND fungo1.x-4 <= centi5.x+8) OR (fungo1.x+4 >= centi5.x-2 AND fungo1.x+4 <= centi5.x+8) )) OR 
											(centi5.y <= fungo2.y+8 AND ((fungo2.x-4 >= centi5.x-2 AND fungo2.x-4 <= centi5.x+8) OR (fungo2.x+4 >= centi5.x-2 AND fungo2.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo3.y+8 AND ((fungo3.x-4 >= centi5.x-2 AND fungo3.x-4 <= centi5.x+8) OR (fungo3.x+4 >= centi5.x-2 AND fungo3.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo4.y+8 AND ((fungo4.x-4 >= centi5.x-2 AND fungo4.x-4 <= centi5.x+8) OR (fungo4.x+4 >= centi5.x-2 AND fungo4.x+4 <= centi5.x+8) )) OR 
											(centi5.y <= fungo5.y+8 AND ((fungo5.x-4 >= centi5.x-2 AND fungo5.x-4 <= centi5.x+8) OR (fungo5.x+4 >= centi5.x-2 AND fungo5.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo6.y+8 AND ((fungo6.x-4 >= centi5.x-2 AND fungo6.x-4 <= centi5.x+8) OR (fungo6.x+4 >= centi5.x-2 AND fungo6.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo7.y+8 AND ((fungo7.x-4 >= centi5.x-2 AND fungo7.x-4 <= centi5.x+8) OR (fungo7.x+4 >= centi5.x-2 AND fungo7.x+4 <= centi5.x+8) )) OR 
											(centi5.y <= fungo8.y+8 AND ((fungo8.x-4 >= centi5.x-2 AND fungo8.x-4 <= centi5.x+8) OR (fungo8.x+4 >= centi5.x-2 AND fungo8.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo9.y+8 AND ((fungo9.x-4 >= centi5.x-2 AND fungo9.x-4 <= centi5.x+8) OR (fungo9.x+4 >= centi5.x-2 AND fungo9.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo10.y+8 AND ((fungo10.x-4 >= centi5.x-2 AND fungo10.x-4 <= centi5.x+8) OR (fungo10.x+4 >= centi5.x-2 AND fungo10.x+4 <= centi5.x+8) )) OR 
											(centi5.y <= fungo11.y+8 AND ((fungo11.x-4 >= centi5.x-2 AND fungo11.x-4 <= centi5.x+8) OR (fungo11.x+4 >= centi5.x-2 AND fungo11.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo12.y+8 AND ((fungo12.x-4 >= centi5.x-2 AND fungo12.x-4 <= centi5.x+8) OR (fungo12.x+4 >= centi5.x-2 AND fungo12.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo13.y+8 AND ((fungo13.x-4 >= centi5.x-2 AND fungo13.x-4 <= centi5.x+8) OR (fungo13.x+4 >= centi5.x-2 AND fungo13.x+4 <= centi5.x+8) )) OR 
											(centi5.y <= fungo14.y+8 AND ((fungo14.x-4 >= centi5.x-2 AND fungo14.x-4 <= centi5.x+8) OR (fungo14.x+4 >= centi5.x-2 AND fungo14.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo15.y+8 AND ((fungo15.x-4 >= centi5.x-2 AND fungo15.x-4 <= centi5.x+8) OR (fungo15.x+4 >= centi5.x-2 AND fungo15.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo16.y+8 AND ((fungo16.x-4 >= centi5.x-2 AND fungo16.x-4 <= centi5.x+8) OR (fungo16.x+4 >= centi5.x-2 AND fungo16.x+4 <= centi5.x+8) )) OR 
											(centi5.y <= fungo17.y+8 AND ((fungo17.x-4 >= centi5.x-2 AND fungo17.x-4 <= centi5.x+8) OR (fungo17.x+4 >= centi5.x-2 AND fungo17.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo18.y+8 AND ((fungo18.x-4 >= centi5.x-2 AND fungo18.x-4 <= centi5.x+8) OR (fungo18.x+4 >= centi5.x-2 AND fungo18.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo19.y+8 AND ((fungo19.x-4 >= centi5.x-2 AND fungo19.x-4 <= centi5.x+8) OR (fungo19.x+4 >= centi5.x-2 AND fungo19.x+4 <= centi5.x+8) )) OR 
											(centi5.y <= fungo20.y+8 AND ((fungo20.x-4 >= centi5.x-2 AND fungo20.x-4 <= centi5.x+8) OR (fungo20.x+4 >= centi5.x-2 AND fungo20.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo21.y+8 AND ((fungo21.x-4 >= centi5.x-2 AND fungo21.x-4 <= centi5.x+8) OR (fungo21.x+4 >= centi5.x-2 AND fungo21.x+4 <= centi5.x+8) )) OR
											(centi5.y <= fungo22.y+8 AND ((fungo22.x-4 >= centi5.x-2 AND fungo22.x-4 <= centi5.x+8) OR (fungo22.x+4 >= centi5.x-2 AND fungo22.x+4 <= centi5.x+8) )) OR 
											(centi5.y <= fungo23.y+8 AND ((fungo23.x-4 >= centi5.x-2 AND fungo23.x-4 <= centi5.x+8) OR (fungo23.x+4 >= centi5.x-2 AND fungo23.x+4 <= centi5.x+8) )) then
											
											--centi5.x := centi5.x + 12;
											dirR5 := '1';
										else
											centi5.y := centi5.y - 1;
										end if;
									end if;
							end if;
						end if;
						if centi6.x /= -1 then
							if dirR6 = '1' then
								if centi6.y >= rightBorder-18 then
									centi6.x := centi6.x + 12;
									dirR6 := '0';
								else
									if (centi6.y+8 >= fungo0.y+3 AND ((fungo0.x-4 >= centi6.x-2 AND fungo0.x-4 <= centi6.x+8) OR (fungo0.x+4 >= centi6.x-2 AND fungo0.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo1.y+3 AND ((fungo1.x-4 >= centi6.x-2 AND fungo1.x-4 <= centi6.x+8) OR (fungo1.x+4 >= centi6.x-2 AND fungo1.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo2.y+3 AND ((fungo2.x-4 >= centi6.x-2 AND fungo2.x-4 <= centi6.x+8) OR (fungo2.x+4 >= centi6.x-2 AND fungo2.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo3.y+3 AND ((fungo3.x-4 >= centi6.x-2 AND fungo3.x-4 <= centi6.x+8) OR (fungo3.x+4 >= centi6.x-2 AND fungo3.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo4.y+3 AND ((fungo4.x-4 >= centi6.x-2 AND fungo4.x-4 <= centi6.x+8) OR (fungo4.x+4 >= centi6.x-2 AND fungo4.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo5.y+3 AND ((fungo5.x-4 >= centi6.x-2 AND fungo5.x-4 <= centi6.x+8) OR (fungo5.x+4 >= centi6.x-2 AND fungo5.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo6.y+3 AND ((fungo6.x-4 >= centi6.x-2 AND fungo6.x-4 <= centi6.x+8) OR (fungo6.x+4 >= centi6.x-2 AND fungo6.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo7.y+3 AND ((fungo7.x-4 >= centi6.x-2 AND fungo7.x-4 <= centi6.x+8) OR (fungo7.x+4 >= centi6.x-2 AND fungo7.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo8.y+3 AND ((fungo8.x-4 >= centi6.x-2 AND fungo8.x-4 <= centi6.x+8) OR (fungo8.x+4 >= centi6.x-2 AND fungo8.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo9.y+3 AND ((fungo9.x-4 >= centi6.x-2 AND fungo9.x-4 <= centi6.x+8) OR (fungo9.x+4 >= centi6.x-2 AND fungo9.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo10.y+3 AND ((fungo10.x-4 >= centi6.x-2 AND fungo10.x-4 <= centi6.x+8) OR (fungo10.x+4 >= centi6.x-2 AND fungo10.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo11.y+3 AND ((fungo11.x-4 >= centi6.x-2 AND fungo11.x-4 <= centi6.x+8) OR (fungo11.x+4 >= centi6.x-2 AND fungo11.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo12.y+3 AND ((fungo12.x-4 >= centi6.x-2 AND fungo12.x-4 <= centi6.x+8) OR (fungo12.x+4 >= centi6.x-2 AND fungo12.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo13.y+3 AND ((fungo13.x-4 >= centi6.x-2 AND fungo13.x-4 <= centi6.x+8) OR (fungo13.x+4 >= centi6.x-2 AND fungo13.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo14.y+3 AND ((fungo14.x-4 >= centi6.x-2 AND fungo14.x-4 <= centi6.x+8) OR (fungo14.x+4 >= centi6.x-2 AND fungo14.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo15.y+3 AND ((fungo15.x-4 >= centi6.x-2 AND fungo15.x-4 <= centi6.x+8) OR (fungo15.x+4 >= centi6.x-2 AND fungo15.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo16.y+3 AND ((fungo16.x-4 >= centi6.x-2 AND fungo16.x-4 <= centi6.x+8) OR (fungo16.x+4 >= centi6.x-2 AND fungo16.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo17.y+3 AND ((fungo17.x-4 >= centi6.x-2 AND fungo17.x-4 <= centi6.x+8) OR (fungo17.x+4 >= centi6.x-2 AND fungo17.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo18.y+3 AND ((fungo18.x-4 >= centi6.x-2 AND fungo18.x-4 <= centi6.x+8) OR (fungo18.x+4 >= centi6.x-2 AND fungo18.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo19.y+3 AND ((fungo19.x-4 >= centi6.x-2 AND fungo19.x-4 <= centi6.x+8) OR (fungo19.x+4 >= centi6.x-2 AND fungo19.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo20.y+3 AND ((fungo20.x-4 >= centi6.x-2 AND fungo20.x-4 <= centi6.x+8) OR (fungo20.x+4 >= centi6.x-2 AND fungo20.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo21.y+3 AND ((fungo21.x-4 >= centi6.x-2 AND fungo21.x-4 <= centi6.x+8) OR (fungo21.x+4 >= centi6.x-2 AND fungo21.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo22.y+3 AND ((fungo22.x-4 >= centi6.x-2 AND fungo22.x-4 <= centi6.x+8) OR (fungo22.x+4 >= centi6.x-2 AND fungo22.x+4 <= centi6.x+8)))
										OR (centi6.y+8 >= fungo23.y+3 AND ((fungo23.x-4 >= centi6.x-2 AND fungo23.x-4 <= centi6.x+8) OR (fungo23.x+4 >= centi6.x-2 AND fungo23.x+4 <= centi6.x+8))) then
										
										centi6.x := centi6.x + 12;
										dirR6 := '0';
									else
										centi6.y := centi6.y + 1;
									end if;
								end if;
							end if;
							if dirR6 = '0' then
									if (centi6.y <= leftBorder+2) then
										centi6.x := centi6.x + 12;
										dirR6 := '1';
									else
										if (centi6.y <= fungo0.y+8 AND ((fungo0.x-4 >= centi6.x-2 AND fungo0.x-4 <= centi6.x+8) OR (fungo0.x+4 >= centi6.x-2 AND fungo0.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo1.y+8 AND ((fungo1.x-4 >= centi6.x-2 AND fungo1.x-4 <= centi6.x+8) OR (fungo1.x+4 >= centi6.x-2 AND fungo1.x+4 <= centi6.x+8) )) OR 
											(centi6.y <= fungo2.y+8 AND ((fungo2.x-4 >= centi6.x-2 AND fungo2.x-4 <= centi6.x+8) OR (fungo2.x+4 >= centi6.x-2 AND fungo2.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo3.y+8 AND ((fungo3.x-4 >= centi6.x-2 AND fungo3.x-4 <= centi6.x+8) OR (fungo3.x+4 >= centi6.x-2 AND fungo3.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo4.y+8 AND ((fungo4.x-4 >= centi6.x-2 AND fungo4.x-4 <= centi6.x+8) OR (fungo4.x+4 >= centi6.x-2 AND fungo4.x+4 <= centi6.x+8) )) OR 
											(centi6.y <= fungo5.y+8 AND ((fungo5.x-4 >= centi6.x-2 AND fungo5.x-4 <= centi6.x+8) OR (fungo5.x+4 >= centi6.x-2 AND fungo5.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo6.y+8 AND ((fungo6.x-4 >= centi6.x-2 AND fungo6.x-4 <= centi6.x+8) OR (fungo6.x+4 >= centi6.x-2 AND fungo6.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo7.y+8 AND ((fungo7.x-4 >= centi6.x-2 AND fungo7.x-4 <= centi6.x+8) OR (fungo7.x+4 >= centi6.x-2 AND fungo7.x+4 <= centi6.x+8) )) OR 
											(centi6.y <= fungo8.y+8 AND ((fungo8.x-4 >= centi6.x-2 AND fungo8.x-4 <= centi6.x+8) OR (fungo8.x+4 >= centi6.x-2 AND fungo8.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo9.y+8 AND ((fungo9.x-4 >= centi6.x-2 AND fungo9.x-4 <= centi6.x+8) OR (fungo9.x+4 >= centi6.x-2 AND fungo9.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo10.y+8 AND ((fungo10.x-4 >= centi6.x-2 AND fungo10.x-4 <= centi6.x+8) OR (fungo10.x+4 >= centi6.x-2 AND fungo10.x+4 <= centi6.x+8) )) OR 
											(centi6.y <= fungo11.y+8 AND ((fungo11.x-4 >= centi6.x-2 AND fungo11.x-4 <= centi6.x+8) OR (fungo11.x+4 >= centi6.x-2 AND fungo11.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo12.y+8 AND ((fungo12.x-4 >= centi6.x-2 AND fungo12.x-4 <= centi6.x+8) OR (fungo12.x+4 >= centi6.x-2 AND fungo12.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo13.y+8 AND ((fungo13.x-4 >= centi6.x-2 AND fungo13.x-4 <= centi6.x+8) OR (fungo13.x+4 >= centi6.x-2 AND fungo13.x+4 <= centi6.x+8) )) OR 
											(centi6.y <= fungo14.y+8 AND ((fungo14.x-4 >= centi6.x-2 AND fungo14.x-4 <= centi6.x+8) OR (fungo14.x+4 >= centi6.x-2 AND fungo14.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo15.y+8 AND ((fungo15.x-4 >= centi6.x-2 AND fungo15.x-4 <= centi6.x+8) OR (fungo15.x+4 >= centi6.x-2 AND fungo15.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo16.y+8 AND ((fungo16.x-4 >= centi6.x-2 AND fungo16.x-4 <= centi6.x+8) OR (fungo16.x+4 >= centi6.x-2 AND fungo16.x+4 <= centi6.x+8) )) OR 
											(centi6.y <= fungo17.y+8 AND ((fungo17.x-4 >= centi6.x-2 AND fungo17.x-4 <= centi6.x+8) OR (fungo17.x+4 >= centi6.x-2 AND fungo17.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo18.y+8 AND ((fungo18.x-4 >= centi6.x-2 AND fungo18.x-4 <= centi6.x+8) OR (fungo18.x+4 >= centi6.x-2 AND fungo18.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo19.y+8 AND ((fungo19.x-4 >= centi6.x-2 AND fungo19.x-4 <= centi6.x+8) OR (fungo19.x+4 >= centi6.x-2 AND fungo19.x+4 <= centi6.x+8) )) OR 
											(centi6.y <= fungo20.y+8 AND ((fungo20.x-4 >= centi6.x-2 AND fungo20.x-4 <= centi6.x+8) OR (fungo20.x+4 >= centi6.x-2 AND fungo20.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo21.y+8 AND ((fungo21.x-4 >= centi6.x-2 AND fungo21.x-4 <= centi6.x+8) OR (fungo21.x+4 >= centi6.x-2 AND fungo21.x+4 <= centi6.x+8) )) OR
											(centi6.y <= fungo22.y+8 AND ((fungo22.x-4 >= centi6.x-2 AND fungo22.x-4 <= centi6.x+8) OR (fungo22.x+4 >= centi6.x-2 AND fungo22.x+4 <= centi6.x+8) )) OR 
											(centi6.y <= fungo23.y+8 AND ((fungo23.x-4 >= centi6.x-2 AND fungo23.x-4 <= centi6.x+8) OR (fungo23.x+4 >= centi6.x-2 AND fungo23.x+4 <= centi6.x+8) )) then
											
											--centi6.x := centi6.x + 12;
											dirR6 := '1';
										else
											centi6.y := centi6.y - 1;
										end if;
									end if;
							end if;
						end if;

			end case;
		end if;
		
		IF(toCheck2='1') THEN
			if centi0.x >= 435 OR centi1.x >= 435 OR centi2.x >= 435 OR centi3.x >= 435 OR centi4.x >= 435 OR centi5.x >= 435 OR centi6.x >= 435 then
				gameO:='1';
			end if;
		END IF;
		
		toCheck2 := '0';
				
		if toCheck = '1' then
			bulletPositionV := bulletPositionV - 1;
			mushroomS := '0';
			snakeS := '0';
			
			if ( bulletPositionH >= fungo0.y+2 AND bulletPositionH <= fungo0.y+8 ) then
				if (bulletPositionV <= fungo0.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo1.y+2 AND bulletPositionH <= fungo1.y+8 ) then
				if (bulletPositionV <= fungo1.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo2.y+2 AND bulletPositionH <= fungo2.y+8 ) then
				if (bulletPositionV <= fungo2.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo3.y+2 AND bulletPositionH <= fungo3.y+8 ) then
				if (bulletPositionV <= fungo3.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo4.y+2 AND bulletPositionH <= fungo4.y+8 ) then
				if (bulletPositionV <= fungo4.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo5.y+2 AND bulletPositionH <= fungo5.y+8 ) then
				if (bulletPositionV <= fungo5.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo6.y+2 AND bulletPositionH <= fungo6.y+8 ) then
				if (bulletPositionV <= fungo6.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo7.y+2 AND bulletPositionH <= fungo7.y+8 ) then
				if (bulletPositionV <= fungo7.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo8.y+2 AND bulletPositionH <= fungo8.y+8 ) then
				if (bulletPositionV <= fungo8.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo9.y+2 AND bulletPositionH <= fungo9.y+8 ) then
				if (bulletPositionV <= fungo9.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo10.y+2 AND bulletPositionH <= fungo10.y+8 ) then
				if (bulletPositionV <= fungo10.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo11.y+2 AND bulletPositionH <= fungo11.y+8 ) then
				if (bulletPositionV <= fungo11.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			if ( bulletPositionH >= fungo12.y+2 AND bulletPositionH <= fungo12.y+8 ) then
				if (bulletPositionV <= fungo12.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			if ( bulletPositionH >= fungo13.y+2 AND bulletPositionH <= fungo13.y+8 ) then
				if (bulletPositionV <= fungo13.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			if ( bulletPositionH >= fungo14.y+2 AND bulletPositionH <= fungo14.y+8 ) then
				if (bulletPositionV <= fungo14.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			if ( bulletPositionH >= fungo15.y+2 AND bulletPositionH <= fungo15.y+8 ) then
				if (bulletPositionV <= fungo15.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			if ( bulletPositionH >= fungo16.y+2 AND bulletPositionH <= fungo16.y+8 ) then
				if (bulletPositionV <= fungo16.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			if ( bulletPositionH >= fungo17.y+2 AND bulletPositionH <= fungo17.y+8 ) then
				if (bulletPositionV <= fungo17.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo18.y+2 AND bulletPositionH <= fungo18.y+8 ) then
				if (bulletPositionV <= fungo18.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			if ( bulletPositionH >= fungo19.y+2 AND bulletPositionH <= fungo19.y+8 ) then
				if (bulletPositionV <= fungo19.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			if ( bulletPositionH >= fungo20.y+2 AND bulletPositionH <= fungo20.y+8 ) then
				if (bulletPositionV <= fungo20.x+3) then
					mushroomS := '1';
				end if;
			end if;
			if ( bulletPositionH >= fungo21.y+2 AND bulletPositionH <= fungo21.y+8 ) then
				if (bulletPositionV <= fungo21.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			if ( bulletPositionH >= fungo22.y+2 AND bulletPositionH <= fungo22.y+8 ) then
				if (bulletPositionV <= fungo22.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			if ( bulletPositionH >= fungo23.y+2 AND bulletPositionH <= fungo23.y+8 ) then
				if (bulletPositionV <= fungo23.x+3) then
					mushroomS := '1';
				end if;
			end if;	
			
			if( bulletPositionH >= centi0.y AND bulletPositionH <= centi0.y+10 AND bulletPositionV-1 <= centi0.x+8 ) then
				fungo16 := centi0;
				indM := indM + 1;
				snakeS := '1';
				centi0.x := -1;
				centi0.y := -1;
			end if;
			if( bulletPositionH >= centi1.y AND bulletPositionH <= centi1.y+10 AND bulletPositionV-1 <= centi1.x+8 ) then
				
				fungo17 := centi1;
				snakeS := '1';
				centi1.x := -1;
				centi1.y := -1;
			end if;
			if( bulletPositionH >= centi2.y AND bulletPositionH <= centi2.y+10 AND bulletPositionV-1 <= centi2.x+8 ) then

				fungo18 := centi2;
				snakeS := '1';
				centi2.x := -1;
				centi2.y := -1;
			end if;
			if( bulletPositionH >= centi3.y AND bulletPositionH <= centi3.y+10 AND bulletPositionV-1 <= centi3.x+8 ) then

				fungo19 := centi3;
				snakeS := '1';
				centi3.x := -1;
				centi3.y := -1;
			end if;
			if( bulletPositionH >= centi4.y AND bulletPositionH <= centi4.y+10 AND bulletPositionV-1 <= centi4.x+8 ) then

				fungo20 := centi4;
				snakeS := '1';
				centi4.x := -1;
				centi4.y := -1;
			end if;
			if( bulletPositionH >= centi5.y AND bulletPositionH <= centi5.y+10 AND bulletPositionV-1 <= centi5.x+8 ) then

				fungo21 := centi5;
				snakeS := '1';
				centi5.x := -1;
				centi5.y := -1;
			end if;
			if( bulletPositionH >= centi6.y AND bulletPositionH <= centi6.y+10 AND bulletPositionV-1 <= centi6.x+8 ) then
				
				fungo22 := centi6;
				snakeS := '1';
				centi6.x := -1;
				centi6.y := -1;
			end if;
			
			if snakeS = '1' then
				vScore2 := vScore2 + 1;
			end if;
			if mushroomS = '1' then
				-- tolgo 25
				if vScore0 = 0 then
					vScore0 := 5;
					vScore1 := vScore1 - 3;
				else
					vScore0 := 0;
				end if;
				if vScore1 = 0 then
					vScore2 := vScore2 - 1;
					vScore1 := 7;
				else
					vScore1 := vScore1 - 2;
				end if;
			end if;
			
		end if;
		reloadBullet <= '0';
		if bulletPositionV <= upBorder OR mushroomS = '1' or snakeS = '1' then 
			reloadBullet <= '1';
			shooted := '0';
			bulletPositionV := 435;
		end if;
		
		toCheck := '0';
		
		IF(padGoRight = '0' AND padGoLeft = '1') THEN
			if (padRightCorner = rightBorder-15) THEN
					padLeftCorner:=padLeftCorner;
				else padLeftCorner := padLeftCorner+1;
			end if;	
		END IF;
		IF (padGoLeft = '0' AND padGoRight = '1') THEN
			if (padLeftCorner = leftBorder+5) THEN
					padLeftCorner:=leftBorder+5;
				else 
					padLeftCorner := padLeftCorner-1;
			end if;
		END IF;
		
		padRightCorner := padLeftCorner+padHorizontalDimension;		
				
		if centi0.x = -1 AND centi1.x = -1 AND centi2.x = -1 AND centi3.x = -1 AND centi4.x = -1 AND centi5.x = -1 AND centi6.x = -1 then
			youWin := '1';
		end if;
		
-- segnali in uscita
		bulletPositionX <= bulletPositionV;
		bulletPositionY <= bulletPositionH;

		obstacles(0) <= fungo0;
		obstacles(1) <= fungo1;
		obstacles(2) <= fungo2;
		obstacles(3) <= fungo3;
		obstacles(4) <= fungo4;
		obstacles(5) <= fungo5;
		obstacles(6) <= fungo6;
		obstacles(7) <= fungo7;
		obstacles(8) <= fungo8;
		obstacles(9) <= fungo9;
		obstacles(10) <= fungo10;
		obstacles(11) <= fungo11;
		obstacles(12) <= fungo12;
		obstacles(13) <= fungo13;
		obstacles(14) <= fungo14;
		obstacles(15) <= fungo15;
		
		obstacles(16) <= fungo16;
		obstacles(17) <= fungo17;
		obstacles(18) <= fungo18;
		obstacles(19) <= fungo19;
		obstacles(20) <= fungo20;
		obstacles(21) <= fungo21;
		obstacles(22) <= fungo22;
		obstacles(23) <= fungo23;

		centipede(0) <= centi0;
		centipede(1) <= centi1;
		centipede(2) <= centi2;
		centipede(3) <= centi3;
		centipede(4) <= centi4;
		centipede(5) <= centi5;
		centipede(6) <= centi6;

		padLCorner <= padLeftCorner;
		padRCorner <= padRightCorner;

		score2 <= vScore2;
		score1 <= vScore1;
		score0 <= vScore0;
		victory <= youWin;
		gameOver <= gameO;
	
END PROCESS;
END behavior;