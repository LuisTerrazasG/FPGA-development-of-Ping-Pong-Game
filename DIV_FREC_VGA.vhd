library ieee;
use IEEE.std_logic_1164.all;


entity DIV_FREC_VGA is
		port( CLK: in std_logic;
				CO : out std_logic);
			end entity DIV_FREC_VGA;
			
architecture ARC_DIV of DIV_FREC_VGA is

		component HA1 is 
			port ( HA_A, HA_B : in std_logic;
			HA_S, HA_CO : out std_logic);
			end component HA1;
			
	signal S, CNT : std_logic;
	

	begin 
		A0 : HA1 port map(CNT, '1', S, CO);
	
		P_DIV : process(CLK)
			begin 
				if(CLK'event and CLK= '1') then
						CNT <= S;

					end if;
			end process;
			
	
end ARC_DIV;
