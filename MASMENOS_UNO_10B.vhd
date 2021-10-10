--Componente Menos uno 10 bits
--Luis Angel Terrazas Garcia
--Italia Yizreel Suarez Campos
library IEEE;
use ieee.std_logic_1164.all;

entity MASMENOS_UNO_10B is--Entidad menos uno 10 bits
	port ( A : in std_logic_vector (9 downto 0);-- entrada de 10 bits
				S : out std_logic_vector (9 downto 0));-- salida 10 bits
				
		end MASMENOS_UNO_10B;
		
architecture ARC_MASUNO of MASMENOS_UNO_10B is
	
	--componente Half substractor
	component  HS is--Definicion de entradas y salidas
			port ( A, B : in std_logic;
					S, CO : out std_logic);
			end component HS;
			
signal C : std_logic_vector(9 downto 0);


begin 
	
	-- 9 Half substractor y un xor conectados para restar un 1 a la entrada de 10 bits
	I0: Hs port map(A(0), '1', S(0), C(1));
	I1: HS port map(A(1), C(1), S(1), C(2));
	I2: HS port map(A(2), C(2), S(2), C(3));
	I3: HS port map(A(3), C(3), S(3), C(4));
	I4: HS port map(A(4), C(4), S(4), C(5));
	I5: HS port map(A(5), C(5), S(5), C(6));
	I6: HS port map(A(6), C(6), S(6), C(7));
	I7: HS port map(A(7), C(7), S(7), C(8));
	I8: HS port map(A(8), C(8), S(8), C(9));

	S(9) <= A(9) xor C(9);
	
	
end ARC_MASUNO;
