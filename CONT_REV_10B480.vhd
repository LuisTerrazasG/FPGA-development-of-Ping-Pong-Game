--Sumador restador 10 bits para segunda cordenada de eje vertical
--Luis Angel Terrazas Garcia
--Italia Yizreel Suarez Campos

--Este contador modular nos sirve para sumar o restar en uno cualquier numero de 10 bits

--En este caso se utilizara para tener un sumador restador
-- para controlar la segunda cordenada de dibujo del eje vertical en vga

--Este contador suma desde 36 hasta 480 o resta de 480 hasta 36


library IEEE;
use ieee.std_logic_1164.all;


entity CONT_REV_10B480 is--Entidad contador 10 bits
		--STOP = 0 resta, STOP = 1 suma
		port(CLK, RST, STOP: in std_logic;-- reloj, reset y senal para indicar si suma o resta
				CO : out std_logic_vector(9 downto 0));--Entrada 10 bits
				
		end CONT_REV_10B480;
		
architecture ARC_CNT1 of CONT_REV_10B480 is

	signal D, Q : std_logic_vector (9 downto 0);--Conexion para masuno
	signal Q1, D1 : std_logic_vector(9 downto 0);--conexiones para menos uno

	
	component MASMENOS_UNO_10B is--Uso de component mas uno con una unica entrada de 10 bits
		port(  A : in std_logic_vector (9 downto 0);
				S : out std_logic_vector (9 downto 0));
				
			end component MASMENOS_UNO_10B;
			
	component MASUNO_10B is--Uso de component mas uno con una unica entrada de 10 bits
	port ( A : in std_logic_vector (9 downto 0);-- entrada de 10 bits
				S : out std_logic_vector (9 downto 0));-- salida 10 bits
				
		end component MASUNO_10B;
			
begin 
	
	--inicializacion de component MASUNO y MENOSUNO con la misma entrada pero diferentes senale de salida
	I0_CNT1: MASMENOS_UNO_10B port map(Q,D);--inicializaicon de component MENOSUNO
	I1 : MASUNO_10B port map(Q,D1);--inicializaicon de component MASUNO
	
		

	P1 : process(CLK, RST,STOP, Q)
		begin 
		
			--Al estar en estado de resta(STOP = 0) este contador se reseteara si el reset es 0 o llega al valor especifico de cuenta minima
			if ((RST = '0' or Q = "0000100100") and STOP ='0') then--Punto de reseteo de la resta es 36 (este valor se puede cambiar a disposicion del usuario)-
				Q <= "0111100000";

				elsif	(CLK'event and CLK = '0' and STOP = '0') then--Si el reset sigue siendo 1 sigue restando 
				Q <= D;
				Q <= D;

				end if;
				
			
			--Al estar en estado de suma(MAS_MENOS = 1) este contador se reseteara si el reset es 0 o llega al valor especifico de suma maximo
			if ((RST = '0' or Q = "0111100000") and STOP ='1') then--Punto de reseteo de la suma es 480 (este valor se puede cambiar a disposicion del usuario)
				Q <= "0000100100";
				
				elsif	(CLK'event and CLK = '0' and STOP = '1') then--Si el reset sigue siendo 1 sigue sumando 
				Q <= D1;
	

			end if;
			
				
	CO <= Q;

			

		end process P1;

	
end ARC_CNT1;