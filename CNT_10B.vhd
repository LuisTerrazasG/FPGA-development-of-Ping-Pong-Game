-- Luis Angel Terrazas Garcia A01377440
-- Contador de 10 bits

library IEEE;
use ieee.std_logic_1164.all;


entity CNT_10B is--Entidad contador 10 bits
		port(CLK, RST: in std_logic;
				CO : out std_logic_vector(9 downto 0));--Entrada 10 bits
				
		end CNT_10B;
		
architecture ARC_CNT1 of CNT_10B is

	signal D, Q : std_logic_vector (9 downto 0);--Conexion
	
	component MASUNO_10B is--Uso de component mas uno con una unica entrada de 10 bits
		port(  A : in std_logic_vector (9 downto 0);
				S : out std_logic_vector (9 downto 0));
				
			end component MASUNO_10B;
			
begin 

	I0_CNT1: MASUNO_10B port map(Q,D);--inicializaicon de component MASUNO

	P1 : process(CLK, RST)
		begin 
			if (RST = '0') then
				Q <= "0000000000";
			elsif	(CLK'event and CLK = '0') then
				Q <= D;
				
			end if;

		end process P1;
	CO <= Q;--Asigna cuenta al contador
	
end ARC_CNT1;