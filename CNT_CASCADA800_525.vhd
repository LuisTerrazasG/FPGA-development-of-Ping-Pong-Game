--Contador en cascada 800 y 525
--Luis Angel Terrazas Garcia
--Italia Yizreel Suarez Campos



library ieee;
use ieee.std_logic_1164.all;


entity CNT_CASCADA800_525 is
		port(CLK, RST, STRT: in std_logic;--entradas de reloj, reset
				S_V, S_H : out std_logic;--Senales de sincronia
				OV : out std_logic;--Overflow para indicar el proximo frame
				CUENTA_800, CUENTA_525 : out std_logic_vector(9 downto 0));--salida de cuentas
			end CNT_CASCADA800_525;
			
architecture ARC of CNT_CASCADA800_525 is

	component CNT_MOD800 is--componente modulo 800
		 port( CLK, RST , STRT: in std_logic;
				OV : out std_logic;
				S_H : out std_logic;
				CUENTA : out std_logic_vector(9 downto 0));
		end component CNT_MOD800;
				
	component CNT_MOD525 is--componente modulo 525
		 port( CLK, RST: in std_logic;
				S_V : out std_logic;
				OV : out std_logic;
				CUENTA : out std_logic_vector(9 downto 0));
		end component CNT_MOD525;
		
signal Q : std_logic;
			
	
begin	
	--Conexiones de contadores, overflow de contador modulo 800 conectado a clock de contador modulo 525
	E0: CNT_MOD800 port map(CLK, RST,STRT,Q, S_H, CUENTA_800);
	E1: CNT_MOD525 port map(Q,RST, S_V,OV, CUENTA_525);


end ARC;
