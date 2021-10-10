--Contador modulo 800 10 bits
--Luis Angel Terrazas Garcia
--Italia Yizreel Suarez Campos

library ieee;
use ieee.std_logic_1164.all;


entity CNT_MOD800 is
		port( CLK, RST , STRT: in std_logic;--entradas de reloj, reset
				OV : out std_logic;--Overflow para mandar senal a cont525
				S_H : out std_logic;--Overflos para indicar cuando pasa un frame en el vga
				CUENTA : out std_logic_vector(9 downto 0));--Salida cuenta
		end CNT_MOD800;
		
architecture ARC_MOD800 of CNT_MOD800 is
	
	--Componente utilizado es un contador de 10 bits para hacerlo modulo 800
	component CNT_10B is
		port(CLK, RST : in std_logic;
				CO : out std_logic_vector(9 downto 0));--Salida 10 bits
				
		end component CNT_10B;

signal RST_INT : std_logic;--reset interno para controlar cuenta de contador 10 bits
signal Q : std_logic_vector(9 downto 0);--conexion de salida para contador 10 bits


begin 

	I0 : CNT_10B port map (CLK, RST_INT, Q);
	

P1: process (RST, Q, STRT)

	begin
		
		if (STRT = '1') then--Si start esta en uno funciona la entidad
			case RST is
				when '0' => RST_INT <= '0';--Si reset esta en 0 el componente y la entidad se resetan
				when others => if (Q = "1100100000") then--Si llega a 800 el contador de 10 bits se reseta
											RST_INT <= '0';
										else
											RST_INT <= '1';
									end if;
				end case;
		end if;
	end process P1;
	
P2 : process (Q)--Revisa senal de overflow
	begin  	
			case Q is 
					when "1100100000" => OV <= '1';--Si se cumple un ciclo de 800 en el contador manda senal de uno
					when others => OV <= '0';
			end case;
		end process P2;
		
P3 : process (Q)--Saca senal de sincronia
	begin  	
			if(Q = "0000000000") then--Baja senal de sincronia a 0
				S_H <= '0';
				end if;
			if(Q= "0001011110")then--Sube senal de sincronia cuando es 94
				S_H <= '1';
				end if;


			
		end process P3;
	
	CUENTA <= Q;

end ARC_MOD800;
				