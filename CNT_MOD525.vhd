--Contador modulo 525 10 bits
--Luis Angel Terrazas Garcia


library ieee;
use ieee.std_logic_1164.all;


entity CNT_MOD525 is
		port( CLK, RST : in std_logic;--entradas de reloj, reset
				S_V : out std_logic;--Overflow para mandar senal a cont525
				OV: out std_logic;--Overflos para indicar cuando pasa un frame en el vga
				CUENTA : out std_logic_vector(9 downto 0));--Salida cuenta
		end CNT_MOD525;
		
architecture ARC_MOD800 of CNT_MOD525 is
	
	--Componente utilizado es un contador de 10 bits para hacerlo modulo 525
	component CNT_10B is
		port(CLK, RST : in std_logic;
				CO : out std_logic_vector(9 downto 0));--Salida 10 bits
				
		end component CNT_10B;

signal RST_INT : std_logic;--reset interno para controlar cuenta de contador 10 bits
signal Q : std_logic_vector(9 downto 0);--conexion de salida para contador 10 bits

begin 

	I0 : CNT_10B port map (CLK, RST_INT, Q);
	

P1: process (RST, Q)
	begin

		case RST is
			when '0' => RST_INT <= '0';--Si reset esta en 0 el componente y la entidad se resetan
			when others => if (Q = "1000001101") then--Si llega a 800 el contador de 10 bits se reseta
										RST_INT <= '0';
									else
										RST_INT <= '1';
								end if;
		end case;

	end process P1;
	
P2 : process (Q)
	begin  	
			if(Q < "0000000010") then--Baja senal de sincronia a 0
				S_V <= '0';
				Ov <= '0';
				end if;
			if(Q >= "0000000010" and  Q < "1000001100")then--Sube senal de sincronia cuando es 2 hasta 525
				S_V <= '1';
				Ov <= '0';
				end if;
			if(Q = "1000001101") then--Baja senal de sincronia a 0
				S_V <= '0';
				Ov <= '1';--cambio de senal en overflow indicando final de ciclo en contador
				end if;
			
			
		end process P2;
	
	CUENTA <= Q;
	

end ARC_MOD800;
