--Luis Angel Terrazas Garcia A01377440
--HA

library IEEE;
use ieee.std_logic_1164.all;

entity HA1 is--Definicion de entradas y salidas
port ( HA_A, HA_B : in std_logic;
			HA_S, HA_CO : out std_logic);
end HA1;

architecture ARC of HA1 is--Arquitectura
begin

	HA_S<= HA_A xor HA_B;
	HA_CO <= HA_A and HA_B;

end ARC;