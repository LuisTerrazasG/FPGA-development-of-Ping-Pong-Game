-- Luis Angel Terrazas Garcia A01377440
-- MAS UNO de cuatro bits para creacion de contador 4 bits


library IEEE;
use ieee.std_logic_1164.all;

entity MASUNO_10B is
	port ( A : in std_logic_vector (9 downto 0);-- entrada de 10 bits
				S : out std_logic_vector (9 downto 0));-- salida 10 bits
				
		end MASUNO_10B;
		
architecture ARC_MASUNO of MASUNO_10B is
	
	--componente Half adder
	component HA1 is
		port ( HA_A, HA_B : in std_logic;
			HA_S, HA_CO : out std_logic);
	end component HA1;
			
signal C : std_logic_vector(9 downto 0);


begin 
	
	-- 4 Half adder y un xor conectados para sumar un 1 a la entrada de 5 bits
	I0: HA1 port map(A(0), '1', S(0), C(1));
	I1: HA1 port map(A(1), C(1), S(1), C(2));
	I2: HA1 port map(A(2), C(2), S(2), C(3));
	I3: HA1 port map(A(3), C(3), S(3), C(4));
	I4: HA1 port map(A(4), C(4), S(4), C(5));
	I5: HA1 port map(A(5), C(5), S(5), C(6));
	I6: HA1 port map(A(6), C(6), S(6), C(7));
	I7: HA1 port map(A(7), C(7), S(7), C(8));
	I8: HA1 port map(A(8), C(8), S(8), C(9));

	S(9) <= A(9) xor C(9);
	
end ARC_MASUNO;