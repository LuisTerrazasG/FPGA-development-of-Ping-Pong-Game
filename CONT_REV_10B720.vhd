--Sumador restador 10 bits para primera cordenada de eje horizontal
--Luis Angel Terrazas Garcia
--Italia Yizreel Suarez Campos

--Este contador modular nos sirve para sumar o restar en uno cualquier numero de 10 bits

--En este caso se utilizara para tener un sumador restador
-- para controlar la primera cordenada de dibujo del eje horizontal en vga

--Este contador suma desde 280 hasta 720 o resta de 720 hasta 280

library IEEE;
use ieee.std_logic_1164.all;


entity CONT_REV_10B720 is--Entidad contador modular
		--STOP = 0 resta, STOP = 1 suma
		port(CLK, RST, STOP: in std_logic;-- reloj, reset y senal para indicar si suma o resta
				CO : out std_logic_vector(9 downto 0));--Salida 10 bits
				
		end CONT_REV_10B720;
		
architecture ARC_CNT1 of CONT_REV_10B720 is

	signal D, Q : std_logic_vector (9 downto 0);--Conexion para masuno
	signal Q1, D1 : std_logic_vector(9 downto 0);--conexiones para menos uno

	
	component MASMENOS_UNO_10B is--Uso de component menos uno con una unica entrada de 10 bits
		port(  A : in std_logic_vector (9 downto 0);
				S : out std_logic_vector (9 downto 0));
				
			end component MASMENOS_UNO_10B;
			
	component MASUNO_10B is--Uso de component mas uno con una unica entrada de 10 bits
	port ( A : in std_logic_vector (9 downto 0);-- entrada de 10 bits
				S : out std_logic_vector (9 downto 0));-- salida 10 bits
				
		end component MASUNO_10B;
			
begin 
	--inicializacion de component MASUNO y MENOSUNO con la misma entrada pero diferentes senale de salida
	I0_CNT1: MASMENOS_UNO_10B port map(Q,D);--inicializaicon de component MASUNO
	I1 : MASUNO_10B port map(Q,D1);
	
		

	P1 : process(CLK, RST,STOP, Q)
		begin 
		
			--Al estar en estado de resta(STOP = 0) este contador se reseteara si el reset es 0 o llega al valor especifico de cuenta minima
			if ((RST = '0' or Q = "0100011000") and STOP ='0') then--Punto de reseteo de la resta es 280 (este valor se puede cambiar a disposicion del usuario)
				Q <= "1011010000";

				elsif	(CLK'event and CLK = '0' and STOP = '0') then--Si el reset sigue siendo 1 sigue restando 
				Q <= D;

				end if;
			--Al estar en estado de suma(STOP = 1) este contador se reseteara si el reset es 0 o llega al valor especifico de suma maximo
			if ((RST = '0' or Q = "1011010000") and STOP ='1') then--Punto de reseteo de la suma es 720 (este valor se puede cambiar a disposicion del usuario)
				Q <= "0100011000";
				
				elsif	(CLK'event and CLK = '0' and STOP = '1') then--Si el reset sigue siendo 1 sigue sumando 
				Q <= D1;
	 

			end if;
			
				
	CO <= Q;

			

		end process P1;

	
end ARC_CNT1;