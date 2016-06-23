LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY Breakout_DATA IS
PORT(   
		clk		: IN STD_LOGIC;
		padGoRight: IN STD_LOGIC;
		padGoLeft: IN STD_LOGIC;
		moveBall: IN STD_LOGIC;
		enable: IN STD_LOGIC;
		bootstrap: IN STD_LOGIC;
		forceNextLevel: IN STD_LOGIC;

		obstacles: OUT STD_LOGIC_VECTOR(0 to 120);
		fixed: OUT STD_LOGIC_VECTOR(0 to 120);
		ballPositionX: OUT INTEGER range 0 to 1000;
		ballPositionY: OUT INTEGER range 0 to 500;
		padLCorner: OUT INTEGER range 0 to 1000;
		padRCorner: OUT INTEGER range 0 to 1000;
		level: OUT INTEGER range 0 to 10;
		lives: OUT INTEGER range 0 to 10;
		northBorder: OUT INTEGER range 0 to 500;
		southBorder: OUT INTEGER range 0 to 500;
		westBorder: OUT INTEGER range 0 to 1000;
		eastBorder: OUT INTEGER range 0 to 1000;
		goingReady: OUT STD_LOGIC;
		victory: OUT STD_LOGIC);
end  Breakout_DATA;

ARCHITECTURE behavior of  Breakout_DATA IS

BEGIN
	
PROCESS
variable ballPositionV: integer range 0 to 500:=250;
variable ballPositionH: integer range 0 to 1000:=250;
variable ballMovementH: integer  range 0 to 2:=1;
variable ballMovementV: integer  range 0 to 2 :=1;
variable oldBallMovementV: integer  range 0 to 2 :=1;
variable oldBallMovementH: integer  range 0 to 2 :=1;

variable gameOver: STD_LOGIC :='0';
variable cntScrittaLampeggiante: integer range 0 to 16000000;
variable scrittaLampeggia: STD_LOGIC;
variable padHorizontalDimension:  integer range 0 to 200:=60;
variable padLeftCorner: integer  range 0 to 1000:= 290;
variable padRightCorner: integer  range 0 to 1000:=350;

-- bordo schermo
constant leftBorder:integer  range 0 to 1000:=45;
constant rightBorder:integer  range 0 to 1000:=606;
constant upBorder: integer  range 0 to 500:=30;	
constant downBorder: integer  range 0 to 500:= 460;

variable dead: STD_LOGIC :='0';
variable angle: integer range 1 to 3:=1;

variable ostacoli : STD_LOGIC_VECTOR(0 to 120);
variable fissi : STD_LOGIC_VECTOR(0 to 120);
variable youWin: STD_LOGIC:='0';
variable vite: integer range 0 to 10:=3;

variable livello: integer range 0 to 10:=1;

variable toCheck: std_logic :='0';
variable checkBlocks: std_logic :='0';


variable ballDirectionIsRight: STD_LOGIC:='1';

variable currentN: integer range 0 to 500;
variable currentS: integer range 0 to 500;
variable currentW: integer range 0 to 1000;
variable currentE: integer range 0 to 1000;
variable i: integer range 0 to 128:=0;

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
		ballPositionH:=250;
		ballPositionV:=350;
		padLeftCorner:=290;
		padRightCorner:=350;
		ballMovementH:=1;
		ballMovementV:=1;
		gameOver :='0'; 
		angle:=1;
		vite:=3;
		youWin:='0';
		
		ostacoli:= "1111111111111111111111111111111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000";
		fissi:= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
		northBorder <= upBorder;
		southBorder <= downBorder;
		westBorder <= leftBorder;
		eastBorder <= rightBorder;
		
		END IF;
		
		dead:='0';
		
		IF ((ostacoli-fissi="000000000000000000000000000000000000000000000000000000000000000000" or forceNextLevel='1') and gameOver='0') THEN
			if(livello=3 and gameOver='0') then
				youWin:='1';
				goingReady<='0';
			else
				livello:= livello+1;
				goingReady<='1';
				case livello is
					when 2 => 	ostacoli:= "1000000000011000000000111000000001111000000011111000000111111000001111111000011111111000111111111001111111111011111111111";
								fissi:= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111110";
					when 3 => 	ostacoli:= "1100010001111100100111011101011100011101110000011111000111011101110001111100000111011100011100011101110000011111000000011";
								fissi:= "0000010000000000100000000001000000000000000000000000000111000001110000000000000000000000000000000000000000000000000000000";
					when others =>	 	ostacoli:= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
										fissi:= "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";		
				end case;	
				ballPositionH:=250;
				ballPositionV:=350;
				padLeftCorner:=290;
				padRightCorner:=350;
				ballMovementH:=1;
				ballMovementV:=1;
				angle:=1;
							
				goingReady<='1';
	
			end if;	
			else goingReady<='0';
		END IF;
		
		if(moveBall='1') then toCheck:='1'; checkBlocks:='1'; i:=0; end if;
		
		IF(enable='1' AND youWin='0' AND gameOver='0') THEN		
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
			IF(toCheck='1') THEN
		--movimento pallina verticale
				IF(ballMovementV = 1) THEN
						--Pallina Colpisce fondo schermo -->Game OVER
						if (ballPositionV >= 450 AND ballPositionV <= 456) THEN
							oldBallMovementV:=ballMovementV;
							oldBallMovementH:=ballMovementH;
							ballMovementV:=2;--STOP
							ballMovementH:=2;--STOP
							ballPositionV:=450;
							vite:=vite-1;
						end if;
															
						if (ballPositionV >= 420 and ballPositionV <= 425) AND (ballPositionH>=padLeftCorner+3 OR ballPositionH+2>=padLeftCorner+3) AND (ballPositionH<=padRightCorner-3 OR ballPositionH-3<=padRightCorner-3)THEN
							--effetto pallina
							
								IF( padGoRight='0' AND ballDirectionIsRight='1' ) THEN
									IF(angle<3) THEN
										angle:=angle+1;
									ELSE angle:=3;
									END IF;
								END IF;
								IF(padGoRight='0' AND ballDirectionIsRight='0' ) THEN
									IF(angle>1) THEN
										angle:=angle-1;
									ELSE angle:=angle;
									END IF;
								END IF;
								IF(padGoLeft='0' AND ballDirectionIsRight='1' ) THEN
									IF(angle>1) THEN
										angle:=angle-1;
									ELSE angle:=angle;
									END IF;
								END IF;
								IF( padGoLeft='0' AND ballDirectionIsRight='0' ) THEN
									IF(angle<3) THEN
										angle:=angle+1;
									ELSE angle:=3;
									END IF;
								END IF;							
								-- fine effetto pallina				

							--nessun effetto
							ballMovementV:=0;
						else ballPositionV:=ballPositionV+angle;
						end if;
						--collisione angoli pad
						if ((ballPositionV+9 = 430 AND ballPositionH+4>=padLeftCorner+3 AND ballPositionH+4<=padLeftCorner+6) OR 
								(ballPositionV+9 = 431 AND ballPositionH+4>=padLeftCorner+2 AND ballPositionH+4<=padLeftCorner+5) OR
								(ballPositionV+9 = 432 AND ballPositionH+4>=padLeftCorner+1 AND ballPositionH+4<=padLeftCorner+4) OR
								(ballPositionV+9 = 433 AND ballPositionH+4>=padLeftCorner AND ballPositionH+4<=padLeftCorner+3) OR
								(ballPositionV+9 = 434 AND ballPositionH+4>=padLeftCorner-1 AND ballPositionH+4<=padLeftCorner+2) OR
								(ballPositionV+9 = 435 AND ballPositionH+4>=padLeftCorner-2 AND ballPositionH+4<=padLeftCorner+1) OR
								(ballPositionV+9 = 436 AND ballPositionH+4>=padLeftCorner-3 AND ballPositionH+4<=padLeftCorner) OR
								(ballPositionV+9 = 437 AND ballPositionH+4>=padLeftCorner-4 AND ballPositionH+4<=padLeftCorner-1) OR
								(ballPositionV+9 = 438 AND ballPositionH+4>=padLeftCorner-5 AND ballPositionH+4<=padLeftCorner-2) OR
								(ballPositionV+9 = 439 AND ballPositionH+4>=padLeftCorner-5 AND ballPositionH+4<=padLeftCorner-2) OR
								(ballPositionV+9 = 440 AND ballPositionH+4>=padLeftCorner-5 AND ballPositionH+4<=padLeftCorner-2) OR
						
								(ballPositionV+8 = 430 AND ballPositionH+4>=padLeftCorner+3 AND ballPositionH+4<=padLeftCorner+6) OR 
								(ballPositionV+8 = 431 AND ballPositionH+4>=padLeftCorner+2 AND ballPositionH+4<=padLeftCorner+5) OR
								(ballPositionV+8 = 432 AND ballPositionH+4>=padLeftCorner+1 AND ballPositionH+4<=padLeftCorner+4) OR
								(ballPositionV+8 = 433 AND ballPositionH+4>=padLeftCorner AND ballPositionH+4<=padLeftCorner+3) OR
								(ballPositionV+8 = 434 AND ballPositionH+4>=padLeftCorner-1 AND ballPositionH+4<=padLeftCorner+2) OR
								(ballPositionV+8 = 435 AND ballPositionH+4>=padLeftCorner-2 AND ballPositionH+4<=padLeftCorner+1) OR
								(ballPositionV+8 = 436 AND ballPositionH+4>=padLeftCorner-3 AND ballPositionH+4<=padLeftCorner) OR
								(ballPositionV+8 = 437 AND ballPositionH+4>=padLeftCorner-4 AND ballPositionH+4<=padLeftCorner-1) OR
								(ballPositionV+8 = 438 AND ballPositionH+4>=padLeftCorner-5 AND ballPositionH+4<=padLeftCorner-2) OR
								(ballPositionV+8 = 439 AND ballPositionH+4>=padLeftCorner-5 AND ballPositionH+4<=padLeftCorner-2) OR
								(ballPositionV+8 = 440 AND ballPositionH+4>=padLeftCorner-5 AND ballPositionH+4<=padLeftCorner-2) OR
								
								(ballPositionV+7 = 430 AND ballPositionH+5>=padLeftCorner+3 AND ballPositionH+5<=padLeftCorner+6) OR 
								(ballPositionV+7 = 431 AND ballPositionH+5>=padLeftCorner+2 AND ballPositionH+5<=padLeftCorner+5) OR
								(ballPositionV+7 = 432 AND ballPositionH+5>=padLeftCorner+1 AND ballPositionH+5<=padLeftCorner+4) OR
								(ballPositionV+7 = 433 AND ballPositionH+5>=padLeftCorner AND ballPositionH+5<=padLeftCorner+3) OR
								(ballPositionV+7 = 434 AND ballPositionH+5>=padLeftCorner-1 AND ballPositionH+5<=padLeftCorner+2) OR
								(ballPositionV+7 = 435 AND ballPositionH+5>=padLeftCorner-2 AND ballPositionH+5<=padLeftCorner+1) OR
								(ballPositionV+7 = 436 AND ballPositionH+5>=padLeftCorner-3 AND ballPositionH+5<=padLeftCorner) OR
								(ballPositionV+7 = 437 AND ballPositionH+5>=padLeftCorner-4 AND ballPositionH+5<=padLeftCorner-1) OR
								(ballPositionV+7 = 438 AND ballPositionH+5>=padLeftCorner-5 AND ballPositionH+5<=padLeftCorner-2) OR
								(ballPositionV+7 = 439 AND ballPositionH+5>=padLeftCorner-5 AND ballPositionH+5<=padLeftCorner-2) OR
								(ballPositionV+7 = 440 AND ballPositionH+5>=padLeftCorner-5 AND ballPositionH+5<=padLeftCorner-2) OR
								
								(ballPositionV+10 = 430 AND ballPositionH+3>=padLeftCorner+3 AND ballPositionH+3<=padLeftCorner+6) OR 
								(ballPositionV+10 = 431 AND ballPositionH+3>=padLeftCorner+2 AND ballPositionH+3<=padLeftCorner+5) OR
								(ballPositionV+10 = 432 AND ballPositionH+3>=padLeftCorner+1 AND ballPositionH+3<=padLeftCorner+4) OR
								(ballPositionV+10 = 433 AND ballPositionH+3>=padLeftCorner AND ballPositionH+3<=padLeftCorner+3) OR
								(ballPositionV+10 = 434 AND ballPositionH+3>=padLeftCorner-1 AND ballPositionH+3<=padLeftCorner+2) OR
								(ballPositionV+10 = 435 AND ballPositionH+3>=padLeftCorner-2 AND ballPositionH+3<=padLeftCorner+1) OR
								(ballPositionV+10 = 436 AND ballPositionH+3>=padLeftCorner-3 AND ballPositionH+3<=padLeftCorner) OR
								(ballPositionV+10 = 437 AND ballPositionH+3>=padLeftCorner-4 AND ballPositionH+3<=padLeftCorner-1) OR
								(ballPositionV+10 = 438 AND ballPositionH+3>=padLeftCorner-5 AND ballPositionH+3<=padLeftCorner-2) OR
								(ballPositionV+10 = 439 AND ballPositionH+3>=padLeftCorner-5 AND ballPositionH+3<=padLeftCorner-2) OR
								(ballPositionV+10 = 440 AND ballPositionH+3>=padLeftCorner-5 AND ballPositionH+3<=padLeftCorner-2)
						) THEN
							
							
								ballMovementV:=0;	
								ballMovementH:=0;
						
						end if;
						
						
						if ((ballPositionV+9 = 430 AND ballPositionH-5>=padRightCorner-6 AND ballPositionH-5<=padRightCorner-3) OR 
								(ballPositionV+9 = 431 AND ballPositionH-5>=padRightCorner-5  AND ballPositionH-5<=padRightCorner-2) OR
								(ballPositionV+9 = 432 AND ballPositionH-5>=padRightCorner-4  AND ballPositionH-5<=padRightCorner-1) OR
								(ballPositionV+9 = 433 AND ballPositionH-5>=padRightCorner-3  AND ballPositionH-5<=padRightCorner) OR
								(ballPositionV+9 = 434 AND ballPositionH-5>=padRightCorner-2  AND ballPositionH-5<=padRightCorner+1) OR
								(ballPositionV+9 = 435 AND ballPositionH-5>=padRightCorner-1 AND ballPositionH-5<=padRightCorner+2 )OR
								(ballPositionV+9 = 436 AND ballPositionH-5>=padRightCorner  AND ballPositionH-5<=padRightCorner+3 )OR
								(ballPositionV+9 = 437 AND ballPositionH-5>=padRightCorner+1  AND ballPositionH-5<=padRightCorner+4 )OR
								(ballPositionV+9 = 438 AND ballPositionH-5>=padRightCorner+2 AND ballPositionH-5<=padRightCorner+5 )OR
								(ballPositionV+9 = 439 AND ballPositionH-5>=padRightCorner+2 AND ballPositionH-5<=padRightCorner+5 )OR
								(ballPositionV+9 = 440 AND ballPositionH-5>=padRightCorner+2 AND ballPositionH-5<=padRightCorner+5 )OR
								
								(ballPositionV+8 = 430 AND ballPositionH-5>=padRightCorner-6 AND ballPositionH-5<=padRightCorner-3) OR 
								(ballPositionV+8 = 431 AND ballPositionH-5>=padRightCorner-5  AND ballPositionH-5<=padRightCorner-2) OR
								(ballPositionV+8 = 432 AND ballPositionH-5>=padRightCorner-4  AND ballPositionH-5<=padRightCorner-1) OR
								(ballPositionV+8 = 433 AND ballPositionH-5>=padRightCorner-3  AND ballPositionH-5<=padRightCorner) OR
								(ballPositionV+8 = 434 AND ballPositionH-5>=padRightCorner-2  AND ballPositionH-5<=padRightCorner+1) OR
								(ballPositionV+8 = 435 AND ballPositionH-5>=padRightCorner-1 AND ballPositionH-5<=padRightCorner+2 )OR
								(ballPositionV+8 = 436 AND ballPositionH-5>=padRightCorner  AND ballPositionH-5<=padRightCorner+3 )OR
								(ballPositionV+8 = 437 AND ballPositionH-5>=padRightCorner+1  AND ballPositionH-5<=padRightCorner+4 )OR
								(ballPositionV+8 = 438 AND ballPositionH-5>=padRightCorner+2 AND ballPositionH-5<=padRightCorner+5 )OR
								(ballPositionV+8 = 439 AND ballPositionH-5>=padRightCorner+2 AND ballPositionH-5<=padRightCorner+5 )OR
								(ballPositionV+8 = 440 AND ballPositionH-5>=padRightCorner+2 AND ballPositionH-5<=padRightCorner+5 )OR
								
								
								(ballPositionV+7 = 430 AND ballPositionH-6>=padRightCorner-6 AND ballPositionH-6<=padRightCorner-3) OR 
								(ballPositionV+7 = 431 AND ballPositionH-6>=padRightCorner-5  AND ballPositionH-6<=padRightCorner-2) OR
								(ballPositionV+7 = 432 AND ballPositionH-6>=padRightCorner-4  AND ballPositionH-6<=padRightCorner-1) OR
								(ballPositionV+7 = 433 AND ballPositionH-6>=padRightCorner-3  AND ballPositionH-6<=padRightCorner) OR
								(ballPositionV+7 = 434 AND ballPositionH-6>=padRightCorner-2  AND ballPositionH-6<=padRightCorner+1) OR
								(ballPositionV+7 = 435 AND ballPositionH-6>=padRightCorner-1 AND ballPositionH-6<=padRightCorner+2 )OR
								(ballPositionV+7 = 436 AND ballPositionH-6>=padRightCorner  AND ballPositionH-6<=padRightCorner+3 )OR
								(ballPositionV+7 = 437 AND ballPositionH-6>=padRightCorner+1  AND ballPositionH-6<=padRightCorner+4 )OR
								(ballPositionV+7 = 438 AND ballPositionH-6>=padRightCorner+2 AND ballPositionH-6<=padRightCorner+5 )OR
								(ballPositionV+7 = 439 AND ballPositionH-6>=padRightCorner+2 AND ballPositionH-6<=padRightCorner+5 )OR
								(ballPositionV+7 = 440 AND ballPositionH-6>=padRightCorner+2 AND ballPositionH-6<=padRightCorner+5 ) OR

								(ballPositionV+10 = 430 AND ballPositionH-3>=padRightCorner-6 AND ballPositionH-3<=padRightCorner-3) OR 
								(ballPositionV+10 = 431 AND ballPositionH-3>=padRightCorner-5  AND ballPositionH-3<=padRightCorner-2) OR
								(ballPositionV+10 = 432 AND ballPositionH-3>=padRightCorner-4  AND ballPositionH-3<=padRightCorner-1) OR
								(ballPositionV+10 = 433 AND ballPositionH-3>=padRightCorner-3  AND ballPositionH-3<=padRightCorner) OR
								(ballPositionV+10 = 434 AND ballPositionH-3>=padRightCorner-2  AND ballPositionH-3<=padRightCorner+1) OR
								(ballPositionV+10 = 435 AND ballPositionH-3>=padRightCorner-1 AND ballPositionH-3<=padRightCorner+2 )OR
								(ballPositionV+10 = 436 AND ballPositionH-3>=padRightCorner  AND ballPositionH-3<=padRightCorner+3 )OR
								(ballPositionV+10 = 437 AND ballPositionH-3>=padRightCorner+1  AND ballPositionH-3<=padRightCorner+4 )OR
								(ballPositionV+10 = 438 AND ballPositionH-3>=padRightCorner+2 AND ballPositionH-3<=padRightCorner+5 )OR
								(ballPositionV+10 = 439 AND ballPositionH-3>=padRightCorner+2 AND ballPositionH-3<=padRightCorner+5 )OR
								(ballPositionV+10 = 440 AND ballPositionH-3>=padRightCorner+2 AND ballPositionH-3<=padRightCorner+5 )
						
						)THEN
								
								ballMovementV:=0;	
								ballMovementH:=1;
						end if;
						-- fine collisione angoli pad
				ELSIF(ballMovementV = 0) 	THEN
						if (ballPositionV >= upBorder-5 AND ballPositionV <= upBorder) THEN
							ballMovementV:=1;
						else ballPositionV:=ballPositionV-angle;
						end if;
								
				ELSE 
					ballPositionV:=ballPositionV;
					
					IF(vite=0) THEN
					gameOver:='1';
					ELSE
							ballPositionH:=250;
							ballPositionV:=350;
							padLeftCorner:=290;
							padRightCorner:=350;
							ballMovementH:=1;
							ballMovementV:=1;
							angle:=1;
							
							goingReady<='1';
						
					END IF;
				END IF;			
		-- finemovimento pallina verticale

		--movimento pallina orizzontale
				IF(ballMovementH = 1) THEN
						if (ballPositionH = rightBorder-10) THEN
									ballMovementH:=0;
									ballPositionH:=ballPositionH-1;
						else ballPositionH:=ballPositionH+1;
						end if;

				ELSIF(ballMovementH = 0) THEN	
						if (ballPositionH = leftBorder) THEN

									ballMovementH:=1;
									ballPositionH:=ballPositionH+1;
						else ballPositionH:=ballPositionH-1;
						end if;

				ELSE
					ballPositionH:=ballPositionH;
				END IF;	
		-- fine movimento pallina orizzontale	
		
			toCheck:='0';
			
			END IF;
		
	-- controllo collisioni blocchi
		if(checkBlocks='1') then	
		IF (i=121) THEN
			i:=0;
			checkBlocks:='0';
		ELSE
			currentN:= 1+upBorder+10*(i / 11)+1;
			currentS:= 1+upBorder+10*(i / 11)+9;
			currentW:= 1+leftBorder+50*(i mod 11)+1;
			currentE:= 1+leftBorder+50*(i mod 11)+48;

			IF(ballMovementV = 1) THEN
				IF ((ballPositionV+11 >=currentN) AND (ballPositionV+11 <= currentS) AND (ballPositionH >= currentW) AND (ballPositionH <= currentE) AND (ostacoli(i)='1')) THEN
					ballMovementV:=0;
					ballPositionV:=ballPositionV+1;		
					IF (fissi(i)='0') THEN ostacoli(i):='0'; END IF;
				END IF;				
			ELSIF(ballMovementV = 0) THEN
				if ((ballPositionV >=currentN) AND (ballPositionV <= currentS) AND (ballPositionH >= currentW) AND (ballPositionH <= currentE) AND (ostacoli(i)='1')) THEN
					ballMovementV:=1;
					ballPositionV:=ballPositionV-1;		
					IF (fissi(i)='0') THEN ostacoli(i):='0'; END IF;
				end if;			
			END IF;	
			IF(ballMovementH = 1) THEN
				if ((ballPositionV+5 >=currentN) AND (ballPositionV+5 <= currentS) AND (ballPositionH+5 >= currentW) AND (ballPositionH+5 <= currentE) AND (ostacoli(i)='1'))THEN
					ballMovementH:=0;
					ballPositionH:=ballPositionH+1;	
					IF (fissi(i)='0') THEN ostacoli(i):='0'; END IF;	
				end if;				
			ELSIF(ballMovementH = 0) THEN	
				if ((ballPositionV+5 >=currentN) AND (ballPositionV+5 <= currentS) AND (ballPositionH-6 >= currentW) AND (ballPositionH-6 <= currentE) AND (ostacoli(i)='1')) THEN
					ballMovementH:=1;
					ballPositionH:=ballPositionH-1;	
					IF (fissi(i)='0') THEN ostacoli(i):='0'; END IF;
				end if;	
			END IF;	
			i := i+1;
		END IF;
			
		END IF;
	-- fine controllo collisioni blocchi	
	
	END IF;
		

-- segnali in uscita
		ballPositionX <= ballPositionH;
		ballPositionY <= ballPositionV;
		padLCorner <= padLeftCorner;
		padRCorner <= padRightCorner;
		obstacles <= ostacoli;
		fixed <= fissi;
		lives<=vite;
		level<=livello;
		victory<=youWin;
	
END PROCESS;
END behavior;