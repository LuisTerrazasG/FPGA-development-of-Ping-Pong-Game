--------------------------------------------------------------------------------------------------------------
-- Company:		ITESM
-- Engineer:		--------
-- Create Date:	 11/03/2021
-- Design Name:	Top Level Entity
-- Module Name: 	Top - Behavioral
-- Project Name: 	--------
-- Target Devices: 	DE 10 LITE
-- Tool Versions: 
-- Description: 	PING PONG GAME
-- Use 1 most significant and 1 least significant switche to control paddles 
-- RST is the second most significan switch, must be in state 0 before starting
-- Connect VGA output to a monitor or TV
-- Dependencies: HS, HA, MASUNO, MENOSUNO, CONT10B, CONTMOD800, CONTMOD500, ME_2_VGA, ME_1_VGA, ME_VGA, DIV_FREC_VGA, CONT_REV_10B515,480,700,720
-- Revisión:
-- Revision 0.01
 -- Additional Comments:
--------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity VGA_FINAL is
		port( CLK, RST: in std_logic;-- reloc y reset
				SWITCH_1, SWITCH_2, SWITCH_3, SWITCH_4 : in std_logic;--switches de control
				S_v, S_H : out std_logic;--salida de sincronia horizontal y vertical
				R, G, B : out std_logic_vector(3 downto 0));-- salida de RGB
				
			end VGA_FINAL;
			
architecture ARQ of VGA_FINAL is
		
				
		component DIV_FREC_VGA is--Componente divisor de frecuencia
				port( CLK: in std_logic;
						CO : out std_logic);
					end component DIV_FREC_VGA;
					
				
		component CNT_CASCADA800_525 is--Componente contadores en cascada
			port(CLK, RST, STRT: in std_logic;
					S_V, S_H : out std_logic;
					OV : out std_logic;
					CUENTA_800, CUENTA_525 : out std_logic_vector(9 downto 0));
				end component CNT_CASCADA800_525;
		
		component ME_2_VGA is--Maquina de estados paleta jugador 2
			port( CLK, RST, STOP : in std_logic;
					OV : in std_logic;
					CONT800, CONT525 : in std_logic_vector(9 downto 0);
					R, G , B : out std_logic_vector(3 downto 0));
			end component ME_2_VGA;
			
		component  ME_1_VGA is--Maquina de estados paleta jugador 1
			port( CLK, RST, STOP : in std_logic;
					OV : in std_logic;
					CONT800, CONT525 : in std_logic_vector(9 downto 0);
					R, G , B : out std_logic_vector(3 downto 0));
		end component ME_1_VGA;
		
		
		component ME_VGA is--Maquina de estados de pelota
			port( CLK, RST, STOP1, STOP2 : in std_logic;
					OV : in std_logic;
					CONT800, CONT525 : in std_logic_vector(9 downto 0);
					R, G , B : out std_logic_vector(3 downto 0));
		end component ME_VGA;
		
		signal C5, C8 : std_logic_vector(9 downto 0);--Conexion de contador 800 y 525
		signal S1, S2 : std_logic;--Sincronia Horizontal y Vertical
		signal HCLK : std_logic;--Salida de divisor de frecuencia
		signal OV1 : std_logic;--Overflow de contador cascada para controlar clock de dibujo en maquina de estados
		signal R1, R2, R3, G1, G2, G3, B1, B2,  B3: std_logic_vector(3 downto 0);--Salidas RGB para cada maquina de estados

begin 
	
	--Declaracion de divisor de frecuencia
	D1: DIV_FREC_VGA port map(CLK,HCLK);
	
	--Declaracion de contador cascada
	C1: CNT_CASCADA800_525 port map(HCLK, RST,'1', S1, S2,OV1, C8, C5);
	
	-- Declaracion de maquinas de estado 
	M1: ME_2_VGA port map(HCLK, RST, SWITCH_1, OV1, C8, C5, R2, G2, B2);
	M2: ME_VGA port map(HCLK, RST, SWITCH_3, SWITCH_4, OV1, C8, C5, R3, G3, B3);
	M3: ME_1_VGA port map(HCLK, RST, SWITCH_2, OV1, C8, C5, R1, G1, B1);
	
	
	--Salida de todas las maquinas de estado conectada por puertas or
	R <= R1 or R2 or R3;
	G <= G1 or G2 or G3;
	B <= B1 or B2 or B3;
	
	--Salida de sincronia vertical y horizontal
	S_v <= S1;
	S_H <= S2;
	
end ARQ;