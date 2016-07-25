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
		obstacles: OUT STD_LOGIC_VECTOR(2596 downto 0);
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
--posizioni proiettile
variable bulletPositionV: integer range 0 to 480:=250;
variable bulletPositionH: integer range 0 to 600:=250;
--variabile di gameOver
variable gameO: STD_LOGIC :='0';
variable cntScrittaLampeggiante: integer range 0 to 16000000;
variable scrittaLampeggia: STD_LOGIC;
variable padHorizontalDimension:  integer range 0 to 200:=10;
variable padLeftCorner: integer  range 0 to 600:= 300;
variable padRightCorner: integer  range 0 to 600:=308;

-- bordo schermo
constant leftBorder:integer  range 0 to 50:=45;
constant rightBorder:integer  range 0 to 640:=606; -- 606
constant upBorder: integer  range 0 to 50:=30;	
constant downBorder: integer  range 0 to 500:= 460;

variable cont: INTEGER range 0 to 10 := 0; 
variable youWin: STD_LOGIC:='0';
variable toShooted: std_logic :='0';
variable toSnake: std_logic :='0';
--indicano le direzioni(1 destra, 0 sinistra) degli elementi del serpente
variable dirR0: STD_LOGIC := '1';
variable dirR1: STD_LOGIC := '1';
variable dirR2: STD_LOGIC := '1';
variable dirR3: STD_LOGIC := '1';
variable dirR4: STD_LOGIC := '1';
variable dirR5: STD_LOGIC := '1';
variable dirR6: STD_LOGIC := '1';

--indica se il proiettile ha colpito un fungo
variable mushroomS: STD_LOGIC;
--indica se il proiettile ha colpito il serpente
variable snakeS: STD_LOGIC;
--elementi del serpente
variable centi0: coord_type;
variable centi1: coord_type;
variable centi2: coord_type;
variable centi3: coord_type;
variable centi4: coord_type;
variable centi5: coord_type;
variable centi6: coord_type;

--se il colpo sta viaggiando(sparato)
variable shooted: STD_LOGIC := '0';
variable vScore2: INTEGER range -9 to 9 := 0;
variable vScore1: INTEGER range -9 to 9 := 0; 
variable vScore0: INTEGER range -9 to 9 := 0; 

--variabile di supporto utili per calcolare le coordinate reali della cella del vettore
variable row: integer range 0 to 500;
variable col: integer range 0 to 5000;
variable comp: integer range 0 to 5000;

--vettore con i funghi
variable mushroom: STD_LOGIC_VECTOR(2596 downto 0);

BEGIN
WAIT UNTIL(clk'EVENT) AND (clk = '1');

		IF(cntScrittaLampeggiante = 10000000)THEN	
				cntScrittaLampeggiante := 0;
				scrittaLampeggia := NOT scrittaLampeggia;		
			ELSE	
				cntScrittaLampeggiante := cntScrittaLampeggiante  + 1;
		END IF;

		
		IF (bootstrap='1') THEN	-- reset
		
			vScore0 := 0;
			vScore1 := 0;
			vScore2 := 0;
			
			cont := 0;
			
			for i in 0 to 2596 loop
				mushroom(i) := '0';
			end loop;
			
			
			--assegnamento delle posizioni dei funghi
			mushroom(0) := '1';
			mushroom(178) := '1';
			mushroom(436) := '1';			
			mushroom(520) := '1';
			mushroom(593) := '1';
			mushroom(369) := '1';
			mushroom(610) := '1';
			mushroom(652) := '1';
			mushroom(840) := '1';
			mushroom(795) := '1';
			mushroom(964) := '1';
			mushroom(954) := '1';			
			mushroom(1160) := '1';
			mushroom(1050) := '1';
			mushroom(1225) := '1';
			mushroom(1450) := '1';
			mushroom(1480) := '1';
			mushroom(1500) := '1';			
			mushroom(2345) := '1';
			
			dirR0 := '1';
			dirR1 := '1';
			dirR2 := '1';
			dirR3 := '1';
			dirR4 := '1';
			dirR5 := '1';
			dirR6 := '1';
			
			shooted := '0';
			
			--assegnamento posizione iniziale del serpente	
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
			westBorder  <= leftBorder;
			eastBorder  <= rightBorder;
		END IF;
		
		goingReady<='0';
		
		--riposizionamento del proiettile
		if shooted = '0' then
			bulletPositionH := padLeftCorner+5;
		end if;
		
		if(shoot='1') then 
			toShooted := '1';
			shooted := '1';
		end if;
				
		if(moveSnake='1' and gameO = '0') then 
			toSnake:='1'; 
		end if;
		
		--tutta la gestione del movimento del serpente
		IF(toSnake='1') THEN			
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
					when others => 
						if centi0.x /= -1 then
							if dirR0 = '1' then
								if centi0.y >= rightBorder-18 then
									centi0.x := centi0.x + 10;
									dirR0 := '0';
								else
									centi0.y := centi0.y + 1;
								end if;
							else
								if centi0.y <= leftBorder + 2 then
									centi0.x := centi0.x + 10;
									dirR0 := '1';
								else
									centi0.y := centi0.y - 1;
								end if;
							end if;
						end if;
						if centi1.x /= -1 then
							if dirR1 = '1' then
								if centi1.y >= rightBorder-18 then
									centi1.x := centi1.x + 10;
									dirR1 := '0';
								else
									centi1.y := centi1.y + 1;
								end if;
							else
								if centi1.y <= leftBorder + 2 then
									centi1.x := centi1.x + 10;
									dirR1 := '1';
								else
									centi1.y := centi1.y - 1;
								end if;
							end if;
						end if;
						if centi2.x /= -1 then
							if dirR2 = '1' then
								if centi2.y >= rightBorder-18 then
									centi2.x := centi2.x + 10;
									dirR2 := '0';
								else
									centi2.y := centi2.y + 1;
								end if;
							else
								if centi2.y <= leftBorder + 2 then
									centi2.x := centi2.x + 10;
									dirR2 := '1';
								else
									centi2.y := centi2.y - 1;
								end if;
							end if;
						end if;
						if centi3.x /= -1 then
							if dirR3 = '1' then
								if centi3.y >= rightBorder-18 then
									centi3.x := centi3.x + 10;
									dirR3 := '0';
								else
									centi3.y := centi3.y + 1;
								end if;
							else
								if centi3.y <= leftBorder+2 then
									centi3.x := centi3.x + 10;
									dirR3 := '1';
								else
									centi3.y := centi3.y - 1;
								end if;
							end if;
						end if;
						if centi4.x /= -1 then
							if dirR4 = '1' then
								if centi4.y >= rightBorder-18 then
									centi4.x := centi4.x + 10;
									dirR4 := '0';
								else
									centi4.y := centi4.y + 1;
								end if;
							else
								if centi4.y <= leftBorder+2 then
									centi4.x := centi4.x + 10;
									dirR4 := '1';
								else
									centi4.y := centi4.y - 1;
								end if;
							end if;
						end if;
						if centi5.x /= -1 then
							if dirR5 = '1' then
								if centi5.y >= rightBorder-18 then
									centi5.x := centi5.x + 10;
									dirR5 := '0';
								else
									centi5.y := centi5.y + 1;
								end if;
							else
								if centi5.y <= leftBorder + 2 then
									centi5.x := centi5.x + 10;
									dirR5 := '1';
								else
									centi5.y := centi5.y - 1;
								end if;
							end if;
						end if;
						if centi6.x /= -1 then
							if dirR6 = '1' then
								if centi6.y >= rightBorder-18 then
									centi6.x := centi6.x + 10;
									dirR6 := '0';
								else
									centi6.y := centi6.y + 1;
								end if;
							else
								if centi6.y <= leftBorder+2 then
									centi6.x := centi6.x + 10;
									dirR6 := '1';
								else
									centi6.y := centi6.y - 1;
								end if;
							end if;
						end if;

						for i in 0 to 2205 loop
							if mushroom(i) = '1' then
								row := 45 + 10 * (i / 59);
								comp := 59 * (i / 59);
								col := 60 + 10 * (i-comp);
								if centi0.x /= -1 then
									if dirR0 = '1' then
										if centi0.y+8 >= col+2 then
											if centi0.x+8 <= row+3 AND centi0.x-2 >= row-15 then
												centi0.x := centi0.x + 10;
												dirR0 := '0';
											end if;
										end if;
									else
										if centi0.y <= col+9 then
											if centi0.x+8 <= row+3 AND centi0.x-2 >= row-15 then
												centi0.x := centi0.x + 10;
												dirR0 := '1';
											end if;
										end if;
									end if;
								end if;
								
								if centi1.x /= -1 then
									if dirR1 = '1' then
										if centi1.y+8 >= col+2 then
											if centi1.x+8 <= row+3 AND centi1.x-2 >= row-15 then
												centi1.x := centi1.x + 10;
												dirR1 := '0';
											end if;
										end if;
									else
										if centi1.y <= col+9 then
											if centi1.x+8 <= row+3 AND centi1.x-2 >= row-15 then
												centi1.x := centi1.x + 10;
												dirR1 := '1';
											end if;
										end if;
									end if;
								end if;

								if centi2.x /= -1 then
									if dirR2 = '1' then
										if centi2.y+8 >= col+2 then
											if centi2.x+8 <= row+3 AND centi2.x-2 >= row-15 then
												centi2.x := centi2.x + 10;
												dirR2 := '0';
											end if;
										end if;
									else
										if centi2.y <= col+9 then
											if centi2.x+8 <= row+3 AND centi2.x-2 >= row-15 then
												centi2.x := centi2.x + 10;
												dirR2 := '1';
											end if;
										end if;
									end if;
								end if;
								
								if centi3.x /= -1 then
									if dirR3 = '1' then
										if centi3.y+8 >= col+2 then
											if centi3.x+8 <= row+3 AND centi3.x-2 >= row-15 then
												centi3.x := centi3.x + 10;
												dirR3 := '0';
											end if;
										end if;
									else
										if centi3.y <= col+9 then
											if centi3.x+8 <= row+3 AND centi3.x-2 >= row-15 then
												centi3.x := centi3.x + 10;
												dirR3 := '1';
											end if;
										end if;
									end if;
								end if;

								if centi4.x /= -1 then
									if dirR4 = '1' then
										if centi4.y+8 >= col+2 then
											if centi4.x+8 <= row+3 AND centi4.x-2 >= row-15 then
												centi4.x := centi4.x + 10;
												dirR4 := '0';
											end if;
										end if;
									else
										if centi4.y <= col+9 then
											if centi4.x+8 <= row+3 AND centi4.x-2 >= row-15 then
												centi4.x := centi4.x + 10;
												dirR4 := '1';
											end if;
										end if;
									end if;
								end if;

								if centi5.x /= -1 then
									if dirR5 = '1' then
										if centi5.y+8 >= col+2 then
											if centi5.x+8 <= row+3 AND centi5.x-2 >= row-15 then
												centi5.x := centi5.x + 10;
												dirR5 := '0';
											end if;
										end if;
									else
										if centi5.y <= col+9 then
											if centi5.x+8 <= row+3 AND centi5.x-2 >= row-15 then
												centi5.x := centi5.x + 10;
												dirR5 := '1';
											end if;
										end if;
									end if;
								end if;
								
								if centi6.x /= -1 then
									if dirR6 = '1' then
										if centi6.y+8 >= col+2 then
											if centi6.x+8 <= row+3 AND centi6.x-2 >= row-15 then
												centi6.x := centi6.x + 10;
												dirR6 := '0';
											end if;
										end if;
									else
										if centi6.y <= col+9 then
											if centi6.x+8 <= row+3 AND centi6.x-2 >= row-15 then
												centi6.x := centi6.x + 10;
												dirR6 := '1';
											end if;
										end if;
									end if;
								end if;
								
							end if;
						end loop;
			end case;
		end if;
		
		IF(toSnake='1') THEN
			if centi0.x >= 430 OR centi1.x >= 430 OR centi2.x >= 430 OR centi3.x >= 430 
				OR centi4.x >= 430 OR centi5.x >= 430 OR centi6.x >= 430 then
				gameO:='1';
			end if;
		END IF;
		
		toSnake := '0';
				
		if toShooted = '1' then
			bulletPositionV := bulletPositionV - 1;
			mushroomS := '0';
			snakeS := '0';
			
			-- bullet crosses mushrooms
			for i in 0 to 2205 loop
				row := 45 + 10 * (i / 59);
				comp := 59 * (i / 59);
				col := 60 + 10 * (i-comp);
				if mushroom(i) = '1' then
					if ( bulletPositionH >= col+2 AND bulletPositionH <= col+8 ) then
						if (bulletPositionV <= row+3) then
							mushroomS := '1';
						end if;
					end if;
				end if;
			end loop;
			
			if( bulletPositionH >= centi0.y AND bulletPositionH <= centi0.y+10 AND bulletPositionV <= centi0.x+8 ) then
				snakeS := '1';
			end if;
			if( bulletPositionH >= centi1.y AND bulletPositionH <= centi1.y+10 AND bulletPositionV <= centi1.x+8 ) then
				snakeS := '1';
			end if;
			if( bulletPositionH >= centi2.y AND bulletPositionH <= centi2.y+10 AND bulletPositionV <= centi2.x+8 ) then
				snakeS := '1';
			end if;
			if( bulletPositionH >= centi3.y AND bulletPositionH <= centi3.y+10 AND bulletPositionV <= centi3.x+8 ) then
				snakeS := '1';
			end if;
			if( bulletPositionH >= centi4.y AND bulletPositionH <= centi4.y+10 AND bulletPositionV <= centi4.x+8 ) then
				snakeS := '1';
			end if;
			if( bulletPositionH >= centi5.y AND bulletPositionH <= centi5.y+10 AND bulletPositionV <= centi5.x+8 ) then
				snakeS := '1';
			end if;
			if( bulletPositionH >= centi6.y AND bulletPositionH <= centi6.y+10 AND bulletPositionV <= centi6.x+8 ) then
				snakeS := '1';
			end if;

			-- ogni pezzo del serpente fornisce 100 punti
			if snakeS = '1' then
				vScore2 := vScore2 + 1;
				if centi6.x /= -1 then
					mushroom(1829) := '1';
					mushroom(1832) := '1';
					mushroom(1833) := '1';
					centi6.x := -1;
					centi6.y := -1;
				elsif centi5.x /= -1 then
					mushroom(1973) := '1';
					mushroom(1977) := '1';
					mushroom(1978) := '1';
					centi5.x := -1;
					centi5.y := -1;
				elsif centi4.x /= -1 then
					mushroom(2105) := '1';
					mushroom(2106) := '1';
					mushroom(2108) := '1';
					centi4.x := -1;
					centi4.y := -1;
				elsif centi3.x /= -1 then
					mushroom(2158) := '1';
					mushroom(2160) := '1';
					mushroom(2161) := '1';
					centi3.x := -1;
					centi3.y := -1;
				elsif centi2.x /= -1 then
					mushroom(2190) := '1';
					mushroom(2192) := '1';
					mushroom(2194) := '1';
					centi2.x := -1;
					centi2.y := -1;
				elsif centi1.x /= -1 then
					mushroom(2201) := '1';
					mushroom(2202) := '1';
					mushroom(2204) := '1';
					centi1.x := -1;
					centi1.y := -1;
				elsif centi0.x /= -1 then
					centi0.x := -1;
					centi0.y := -1;
				end if;
				
			end if;

			if mushroomS = '1' then
				-- ogni fungo toglie 20 punti
				if vScore1 = 0 AND vScore2 > 0 then
					vScore1 := 8;
					vScore2 := vScore2 - 1;
				else
					vScore1 := vScore1 - 2; 
				end if;
			end if;
			
			if vScore2 < 0 then
				vScore2 := 0;
			end if;
			if vScore1 < 0 then
				vScore1 := 0;
			end if;
			if vScore0 < 0 then
				vScore0 := 0;
			end if;
			
		end if;
		reloadBullet <= '0';
		if bulletPositionV <= upBorder OR mushroomS = '1' or snakeS = '1' then 
			reloadBullet <= '1';
			shooted := '0';
			bulletPositionV := 435;
		end if;
		
		toShooted := '0';
		
		IF(padGoRight = '0' AND padGoLeft = '1') THEN
			if (padRightCorner = rightBorder-106) THEN
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

		obstacles <= mushroom;

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
