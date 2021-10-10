
--Maquina de estados paleta jugador 2
--Luis Angel Terrazas Garcia
--Italia Yizreel Suarez Campos


library ieee;
use ieee.std_logic_1164.all;


entity ME_2_VGA is--Entidad maquina de estados
		port( CLK, RST, STOP : in std_logic;-- Reloj, reset, senal de control movimiento
				OV : in std_logic;-- Entrada de overflow para controlar clock de sumador restador
				CONT800, CONT525 : in std_logic_vector(9 downto 0);
				R, G , B : out std_logic_vector(3 downto 0));--Salida RGB
		end  ME_2_VGA;

architecture ARC_ME_VGA of ME_2_VGA is

	--Declaracion de estados
	type ESTADOS_VGA is (IDLE, E1);
	signal EDO, EDOF : ESTADOS_VGA;
	
	signal BLL_UP, BLL_DOWN: std_logic_vector(9 downto 0);--Conexiones para cordenadas en vertical

	

	component CONT_REV_10B515 is-- reloj, reset y senal para indicar si suma o resta
		port(CLK, RST, STOP: in std_logic;
				CO : out std_logic_vector(9 downto 0));--Entrada 10 bits
				
		end component CONT_REV_10B515;
		
		
	component CONT_REV_10B480 is-- reloj, reset y senal para indicar si suma o resta
		port(CLK, RST, STOP: in std_logic;
				CO : out std_logic_vector(9 downto 0));--Entrada 10 bits
				
		end component CONT_REV_10B480;
	


begin 
	--Declaracion de componentes para controlar cordenadas de dibujo
	R480 : CONT_REV_10B480 port map(OV, RST,STOP, BLL_UP);
	R515 : CONT_REV_10B515 port map(OV, RST,STOP, BLL_DOWN);

	
	
P0: process (CLK, RST) is
			begin 
				if (RST = '0') then
					EDO <= IDLE;
				elsif CLK'event and CLK = '1' then
				EDO <= EDOF;
			end if;
		end process P0;


P1: process(CLK, EDO, CONT525, CONT800, BLL_UP, BLL_DOWN,STOP)
	begin 
		case EDO is 
				when IDLE => --Con este estado conseguimos pintar de negro las cordenadas por donde paso la paleta para que no quede un rastro en frame anterior
							if(CONT525 >= BLL_UP) then--Si la cuenta es mayor a la cordenada vertical superior de la paleta se mueve de estado
								EDOF <=E1;
							else
								EDOF <= IDLE;
								
								R <= "0000";
								G <= "0000";
								B <= "0000";
									
							end if;
				
				when E1 =>--Con este estado se dibuja la paleta en movimiento 
						if(CONT525 >= BLL_DOWN) then--Si la cuenta es mayor a la cordenada vertical superior de la paleta regresa al estado anterior
								EDOF <=IDLE;
							
							else
								EDOF <= IDLE;
								if (CONT800 >= "0000000000" and CONT800 < "0011110000") then --Cordenadas de eje horizontal blockeadas a este parametro, no se puede mover de posicion en eje horizontal
									R <= "0000";
									G <= "0000";--Dibuja de negro el area horizontal donde no se encuentra la paleta
									B <= "0000";
									end if;
									
								if( CONT800 >= "0011110000" and CONT800 < "0100000100") then--Cordenadas de eje horizontal blockeadas a este parametro, no se puede mover de posicion en eje horizontal
									R <= "1111";
									G <= "1111";--Dibuja de negro el area horizontal donde no se encuentra la paleta
									B <= "1111";
									end if;
									

								if(CONT800 >= "0100000100" and CONT800 < "1111111111") then--Cordenadas de eje horizontal blockeadas a este parametro, no se puede mover de posicion en eje horizontal
									R <= "0000";
									G <= "0000";--Dibuja de negro el area horizontal donde no se encuentra la paleta
									B <= "0000";
									end if;
							end if;
						
		
				when others => null;	
				
			end case;
			
		end process P1;


								
		
end ARC_ME_VGA;