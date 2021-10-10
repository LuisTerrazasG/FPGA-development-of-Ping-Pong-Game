--HALF SUBSTRACTOR
--Luis Angel Terrazas Garcia
--Italia Yizreel Suarez Campos

--Creacion de half substractor para creacion de un restador menos uno

library IEEE;
use ieee.std_logic_1164.all;

entity HS is--Definicion de entradas y salidas
port ( A, B : in std_logic;
			S, CO : out std_logic);
end HS;

architecture ARC of HS is--Arquitectura
begin

	S<= A xor B;
	CO <= not(A) and B;

end ARC;