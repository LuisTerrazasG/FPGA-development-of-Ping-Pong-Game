--Maquina de estados pelota
--Luis Angel Terrazas Garcia
--Italia Yizreel Suarez Campos



library ieee;
use ieee.std_logic_1164.all;


entity ME_VGA is
		port( CLK, RST, STOP1, STOP2 : in std_logic;--reloj y reset
				OV : in std_logic;--entrada de clock para contadores modulares
				CONT800, CONT525 : in std_logic_vector(9 downto 0);--entrada de contadores 800 y 525
				R, G , B : out std_logic_vector(3 downto 0));--salida RGB
		end  ME_VGA;

architecture ARC_ME_VGA of ME_VGA is

	--Cantidad de estados en maquina de estados
	type ESTADOS_VGA is (IDLE, E1);
	signal EDO, EDOF : ESTADOS_VGA;
	
	signal BLL_UP, BLL_DOWN, BLL_LEFT, BLL_RIGHT : std_logic_vector(9 downto 0);--Conexiones para cordenadas en vertical y horizontal
	
	
	component CONT_REV_10B515 is
		port(CLK, RST, STOP: in std_logic;--Entidad sumador restador 10 bits eje vertical, segunda cordenada
				CO : out std_logic_vector(9 downto 0));--Entrada 10 bits
				
		end component CONT_REV_10B515;
		
	component CONT_REV_10B480 is--Entidad sumador restador 10 bits eje vertical, primera cordenada
		port(CLK, RST, STOP: in std_logic;
				CO : out std_logic_vector(9 downto 0));--Entrada 10 bits
				
		end component CONT_REV_10B480;
	
	component  CONT_REV_10B720 is--Entidad sumador restador 10 bits eje horizontal, segunda cordenada
		port(CLK, RST, STOP: in std_logic;
				CO : out std_logic_vector(9 downto 0));--Entrada 10 bits
				
		end component CONT_REV_10B720;
		
	component  CONT_REV_10B700 is--Entidad sumador restador 10 bits eje horizontal, primera cordenada
		port(CLK, RST, STOP: in std_logic;
				CO : out std_logic_vector(9 downto 0));--Entrada 10 bits
				
		end component CONT_REV_10B700;
		
begin 
	--Declaracion de componentes para controlar cordenadas de dibujo
	R480 : CONT_REV_10B480 port map(OV, RST,STOP1, BLL_UP);
	R515 : CONT_REV_10B515 port map(OV, RST,STOP1, BLL_DOWN);
	M700 : CONT_REV_10B700 port map(OV, RST,STOP2, BLL_LEFT);
	M720 : CONT_REV_10B720 port map(OV, RST,STOP2, BLL_RIGHT);
	
	
P0: process (CLK, RST) is
			begin 
				if (RST = '0') then
					EDO <= IDLE;
				elsif CLK'event and CLK = '1' then
				EDO <= EDOF;
			end if;
		end process P0;


P1: process(CLK, EDO, CONT525, CONT800, BLL_UP,BLL_DOWN,BLL_LEFT,BLL_RIGHT)
	begin 
		case EDO is 
				when IDLE => --Con este estado conseguimos pintar de negro las cordenadas por donde paso la pelota para que no quede un rastro en frame anterior
							if(CONT525 >= BLL_UP) then--Si la cuenta es mayor a la cordenada vertical superior de la pelota se mueve de estado
								EDOF <=E1;

							else
								EDOF <= IDLE;

							end if;
				
				when E1 =>--Con este estado se dibuja la pelota en movimiento 
						if(CONT525 >= BLL_DOWN) then--Si la cuenta es mayor a la cordenada vertical superior de la pelota regresa al estado anterior
								EDOF <=IDLE;

							else
								EDOF <= IDLE;


								if (CONT800 >= "0011110000" and CONT800 < BLL_LEFT) then --Dibuja de negro el area horizontal donde no se encuentra la pelota
									R <= "0000";
									G <= "0000";
									B <= "0000";
									end if;
									
								if( CONT800 >= BLL_LEFT and CONT800 < BLL_RIGHT) then--Dibuja de blanco el area horizontal donde se encuentra la pelota
									R <= "1111";
									G <= "1111";
									B <= "1111";
									end if;
									
								if (CONT800 >= BLL_RIGHT and CONT800 < "1111111111") then --Dibuja de negro el area horizontal donde no se encuentra la pelota
									R <= "0000";
									G <= "0000";
									B <= "0000";
									end if;

							end if;
						
				when others => null;
				
			end case;
			
		end process P1;



								
		
end ARC_ME_VGA;