library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity display_basic is
port(
	led_pos : in std_logic_vector(8 downto 0);
	output_ly : out std_logic_vector(47 downto 0)
);
end entity;
architecture display of display_basic is
signal export : std_logic_vector(47 downto 0):="111111111111111111111111111111110000000000000000";
begin
	output_ly <= export;
	process (led_pos)
	begin
		export <= "111111111111111111111111111111110000000000000000";
		if (led_pos(3)='1') then --right
		--collum
		if (led_pos(8)='1') then
					case led_pos(2 downto 0) is
						when "000"=>export(23) <= '0';
						when "001"=>export(22) <= '0';
						when "010"=>export(21) <= '0';
						when "011"=>export(20) <= '0';
						when "100"=>export(19) <= '0';
						when "101"=>export(18) <= '0';
						when "110"=>export(17) <= '0';
						when others=>export(16) <= '0';
					end case;
				end if;
		if (led_pos(7)='1') then
					case led_pos(2 downto 0) is
						when "000"=>export(39) <= '0';
						when "001"=>export(38) <= '0';
						when "010"=>export(37) <= '0';
						when "011"=>export(36) <= '0';
						when "100"=>export(35) <= '0';
						when "101"=>export(34) <= '0';
						when "110"=>export(33) <= '0';
						when others=>export(32) <= '0';
					end case;
				end if;
		--row
		case led_pos(6 downto 4) is
					when "000"=>export(0) <= '1';
					when "001"=>export(1) <= '1';
					when "010"=>export(2) <= '1';
					when "011"=>export(3) <= '1';
					when "100"=>export(7) <= '1';
					when "101"=>export(6) <= '1';
					when "110"=>export(5) <= '1';
					when others=>export(4) <= '1';
				end case;
	else	--left
		if (led_pos(8)='1') then
				case led_pos(2 downto 0) is
					when "000"=>export(31) <= '0';
					when "001"=>export(30) <= '0';
					when "010"=>export(29) <= '0';
					when "011"=>export(28) <= '0';
					when "100"=>export(27) <= '0';
					when "101"=>export(26) <= '0';
					when "110"=>export(25) <= '0';
					when others=>export(24) <= '0';
				end case;
			end if;
		if (led_pos(7)='1') then
				case led_pos(2 downto 0) is
					when "000"=>export(47) <= '0';
					when "001"=>export(46) <= '0';
					when "010"=>export(45) <= '0';
					when "011"=>export(44) <= '0';
					when "100"=>export(43) <= '0';
					when "101"=>export(42) <= '0';
					when "110"=>export(41) <= '0';
					when others=>export(40) <= '0';
				end case;
			end if;
		case led_pos(6 downto 4) is
				when "000"=>export(8) <= '1';
				when "001"=>export(9) <= '1';
				when "010"=>export(10) <= '1';
				when "011"=>export(11) <= '1';
				when "100"=>export(15) <= '1';
				when "101"=>export(14) <= '1';
				when "110"=>export(13) <= '1';
				when others=>export(12) <= '1';
			end case;
	end if;
	end process;
end architecture;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity largelymfs is
port(
	r: in std_logic;
	lif : in std_logic_vector(2 downto 0);
	dir_a: in std_logic_vector(15 downto 0);
	dir_b: in std_logic_vector(15 downto 0);
	exist: in std_logic_vector(15 downto 0);
	output : out std_logic_vector(47 downto 0)
);
end entity;
architecture dis of largelymfs is
component display_basic
port(
	led_pos : in std_logic_vector(8 downto 0);
	output_ly : out std_logic_vector(47 downto 0)
);
end component;
shared variable num1:integer range 0 to 17:= 0;
shared variable num2:integer range 0 to 7:= 0;
shared variable life_me:integer range 0 to 7:=0;
signal led_pos_me:std_logic_vector(8 downto 0):="000000000";
begin
	u1:display_basic port map(led_pos=>led_pos_me, output_ly=>output);

	process(lif)
	begin
		case lif(2 downto 0) is
			when "000"=>life_me := 0;
			when "001"=>life_me := 1;
			when "010"=>life_me := 2;
			when "011"=>life_me := 3;
			when "100"=>life_me := 4;
			when "101"=>life_me := 5;
			when "110"=>life_me := 6;
			when others=>life_me := 7;
		end case;
	end process;
	process(r)
	begin
		if (r'event and r='0') then
			if (num1=0) then
				if (num2>life_me) then
					num2 := 0;
					num1 := 1;
				else 
					case num2 is
						when 0=>num2 := 1;
						when 1=>num2 := 2;led_pos_me<="010000000";
						when 2=>num2 := 3;led_pos_me<="110000001";
						when 3=>num2 := 4;led_pos_me<="110000010";
						when 4=>num2 := 5;led_pos_me<="100000011";
						when 5=>num2 := 6;led_pos_me<="100000100";
						when 6=>num2 := 7;led_pos_me<="100000101";
						when others=>num2 := 0;num1 := 1;led_pos_me<="100000110";
					end case;
				end if;
			else
				if (num1=17) then
					num1 := 0;
					num2 := 0;
				else
					if (exist(num1-1)='1') then
							case dir_a(num1-1) is
							when '0'=>case dir_b(num1-1) is
												when '0'=>--up
															 case num1 is
																when 1=> case num2 is
																				when 0=>led_pos_me <= "100111111";num2 := 1;
																				when 1=>led_pos_me <= "101001111";num2 := 2;
																				when 2=>led_pos_me <= "101011111";num2 := 3;
																				when others=>led_pos_me <= "101101111";num2 := 0;num1 := 2;
																			end case;
																when 2=>case num2 is
																				when 0=>led_pos_me <= "100111110";num2 := 1;
																				when 1=>led_pos_me <= "101001110";num2 := 2;
																				when 2=>led_pos_me <= "101011110";num2 := 3;
																				when 3=>led_pos_me <= "101101110";num2 := 4;
																				when others=>led_pos_me <= "101001111";num2 := 0;num1 := 3;
																			end case;
																when 3=>case num2 is
																				when 0=>led_pos_me <= "100111101";num2 := 1;
																				when 1=>led_pos_me <= "101001101";num2 := 2;
																				when 2=>led_pos_me <= "101011101";num2 := 3;
																				when 3=>led_pos_me <= "101101101";num2 := 4;
																				when 4=>led_pos_me <= "101001110";num2 := 5;
																				when others=>led_pos_me <= "101011111";num2 := 0;num1 := 4;
																			end case;
																when 4=>case num2 is
																				when 0=>led_pos_me <= "100111100";num2 := 1;
																				when 1=>led_pos_me <= "101001100";num2 := 2;
																				when 2=>led_pos_me <= "101011100";num2 := 3;
																				when 3=>led_pos_me <= "101101100";num2 := 4;
																				when 4=>led_pos_me <= "101001101";num2 := 5;
																				when others=>led_pos_me <= "101011110";num2 := 0;num1 := 5;
																			end case;
																when 5=>case num2 is
																				when 0=>led_pos_me <= "100111011";num2 := 1;
																				when 1=>led_pos_me <= "101001011";num2 := 2;
																				when 2=>led_pos_me <= "101011011";num2 := 3;
																				when 3=>led_pos_me <= "101101011";num2 := 4;
																				when 4=>led_pos_me <= "101001100";num2 := 5;
																				when others=>led_pos_me <= "101011101";num2 := 0;num1 := 6;
																			end case;
																when 6=>case num2 is
																				when 0=>led_pos_me <= "100111010";num2 := 1;
																				when 1=>led_pos_me <= "101001010";num2 := 2;
																				when 2=>led_pos_me <= "101011010";num2 := 3;
																				when 3=>led_pos_me <= "101101010";num2 := 4;
																				when 4=>led_pos_me <= "101001011";num2 := 5;
																				when others=>led_pos_me <= "101011100";num2 := 0;num1 := 7;
																			end case;
																when 7=>case num2 is
																				when 0=>led_pos_me <= "100111001";num2 := 1;
																				when 1=>led_pos_me <= "101001001";num2 := 2;
																				when 2=>led_pos_me <= "101011001";num2 := 3;
																				when 3=>led_pos_me <= "101101001";num2 := 4;
																				when 4=>led_pos_me <= "101001010";num2 := 5;
																				when others=>led_pos_me <= "101011011";num2 := 0;num1 := 8;
																			end case;
																when 8=>case num2 is
																				when 0=>led_pos_me <= "100111000";num2 := 1;
																				when 1=>led_pos_me <= "101001000";num2 := 2;
																				when 2=>led_pos_me <= "101011000";num2 := 3;
																				when 3=>led_pos_me <= "101101000";num2 := 4;
																				when 4=>led_pos_me <= "101001001";num2 := 5;
																				when others=>led_pos_me <= "101011010";num2 := 0;num1 := 9;
																			end case;
																when 9=>case num2 is
																				when 0=>led_pos_me <= "100110111";num2 := 1;
																				when 1=>led_pos_me <= "101000111";num2 := 2;
																				when 2=>led_pos_me <= "101010111";num2 := 3;
																				when 3=>led_pos_me <= "101100111";num2 := 4;
																				when 4=>led_pos_me <= "101001000";num2 := 5;
																				when others=>led_pos_me <= "101011001";num2 := 0;num1 := 10;
																			end case;
																when 10=>case num2 is
																				when 0=>led_pos_me <= "100110110";num2 := 1;
																				when 1=>led_pos_me <= "101000110";num2 := 2;
																				when 2=>led_pos_me <= "101010110";num2 := 3;
																				when 3=>led_pos_me <= "101100110";num2 := 4;
																				when 4=>led_pos_me <= "101000111";num2 := 5;
																				when others=>led_pos_me <= "101011000";num2 := 0;num1 := 11;
																			end case;
																when 11=>case num2 is
																				when 0=>led_pos_me <= "110110101";num2 := 1;
																				when 1=>led_pos_me <= "111000101";num2 := 2;
																				when 2=>led_pos_me <= "111010101";num2 := 3;
																				when 3=>led_pos_me <= "111100101";num2 := 4;
																				when 4=>led_pos_me <= "111000110";num2 := 5;
																				when others=>led_pos_me <= "111010111";num2 := 0;num1 := 12;
																			end case;
																when 12=>case num2 is
																				when 0=>led_pos_me <= "110110100";num2 := 1;
																				when 1=>led_pos_me <= "111000100";num2 := 2;
																				when 2=>led_pos_me <= "111010100";num2 := 3;
																				when 3=>led_pos_me <= "111100100";num2 := 4;
																				when 4=>led_pos_me <= "111000101";num2 := 5;
																				when others=>led_pos_me <= "111010110";num2 := 0;num1 := 13;
																			end case;
																when 13=>case num2 is
																				when 0=>led_pos_me <= "110110011";num2 := 1;
																				when 1=>led_pos_me <= "111000011";num2 := 2;
																				when 2=>led_pos_me <= "111010011";num2 := 3;
																				when 3=>led_pos_me <= "111100011";num2 := 4;
																				when 4=>led_pos_me <= "111000100";num2 := 5;
																				when others=>led_pos_me <= "111010101";num2 := 0;num1 := 14;
																			end case;
																when 14=>case num2 is
																				when 0=>led_pos_me <= "110110010";num2 := 1;
																				when 1=>led_pos_me <= "111000010";num2 := 2;
																				when 2=>led_pos_me <= "111010010";num2 := 3;
																				when 3=>led_pos_me <= "111100010";num2 := 4;
																				when 4=>led_pos_me <= "111000011";num2 := 5;
																				when others=>led_pos_me <= "111010100";num2 := 0;num1 := 15;
																			end case;
																when 15=>case num2 is
																				when 0=>led_pos_me <= "010110001";num2 := 1;
																				when 1=>led_pos_me <= "011000001";num2 := 2;
																				when 2=>led_pos_me <= "011010001";num2 := 3;
																				when 3=>led_pos_me <= "011100001";num2 := 4;
																				when 4=>led_pos_me <= "011000010";num2 := 5;
																				when others=>led_pos_me <= "011010011";num2 := 0;num1 := 16;
																			end case;
																when others=>case num2 is
																				when 0=>led_pos_me <= "010110000";num2 := 1;
																				when 1=>led_pos_me <= "011000000";num2 := 2;
																				when 2=>led_pos_me <= "011010000";num2 := 3;
																				when 3=>led_pos_me <= "011100000";num2 := 4;
																				when 4=>led_pos_me <= "011000001";num2 := 5;
																				when others=>led_pos_me <= "011010010";num2 := 0;num1 := 0;
																			end case;
															end case;
												when others=>--down
															case num1 is
																when 1=> case num2 is
																				when 0=>led_pos_me <= "100111111";num2 := 1;
																				when 1=>led_pos_me <= "101001111";num2 := 2;
																				when 2=>led_pos_me <= "101011111";num2 := 3;
																				when others=>led_pos_me <= "101101111";num2 := 0;num1 := 2;
																			end case;
																when 2=>case num2 is
																				when 0=>led_pos_me <= "100111110";num2 := 1;
																				when 1=>led_pos_me <= "101001110";num2 := 2;
																				when 2=>led_pos_me <= "101011110";num2 := 3;
																				when 3=>led_pos_me <= "101101110";num2 := 4;
																				when others=>led_pos_me <= "101011111";num2 := 0;num1 := 3;
																			end case;
																when 3=>case num2 is
																				when 0=>led_pos_me <= "100111101";num2 := 1;
																				when 1=>led_pos_me <= "101001101";num2 := 2;
																				when 2=>led_pos_me <= "101011101";num2 := 3;
																				when 3=>led_pos_me <= "101101101";num2 := 4;
																				when 4=>led_pos_me <= "101011110";num2 := 5;
																				when others=>led_pos_me <= "101001111";num2 := 0;num1 := 4;
																			end case;
																when 4=>case num2 is
																				when 0=>led_pos_me <= "100111100";num2 := 1;
																				when 1=>led_pos_me <= "101001100";num2 := 2;
																				when 2=>led_pos_me <= "101011100";num2 := 3;
																				when 3=>led_pos_me <= "101101100";num2 := 4;
																				when 4=>led_pos_me <= "101011101";num2 := 5;
																				when others=>led_pos_me <= "101001110";num2 := 0;num1 := 5;
																			end case;
																when 5=>case num2 is
																				when 0=>led_pos_me <= "100111011";num2 := 1;
																				when 1=>led_pos_me <= "101001011";num2 := 2;
																				when 2=>led_pos_me <= "101011011";num2 := 3;
																				when 3=>led_pos_me <= "101101011";num2 := 4;
																				when 4=>led_pos_me <= "101011100";num2 := 5;
																				when others=>led_pos_me <= "101001101";num2 := 0;num1 := 6;
																			end case;
																when 6=>case num2 is
																				when 0=>led_pos_me <= "100111010";num2 := 1;
																				when 1=>led_pos_me <= "101001010";num2 := 2;
																				when 2=>led_pos_me <= "101011010";num2 := 3;
																				when 3=>led_pos_me <= "101101010";num2 := 4;
																				when 4=>led_pos_me <= "101011011";num2 := 5;
																				when others=>led_pos_me <= "101001100";num2 := 0;num1 := 7;
																			end case;
																when 7=>case num2 is
																				when 0=>led_pos_me <= "100111001";num2 := 1;
																				when 1=>led_pos_me <= "101001001";num2 := 2;
																				when 2=>led_pos_me <= "101011001";num2 := 3;
																				when 3=>led_pos_me <= "101101001";num2 := 4;
																				when 4=>led_pos_me <= "101011010";num2 := 5;
																				when others=>led_pos_me <= "101001011";num2 := 0;num1 := 8;
																			end case;
																when 8=>case num2 is
																				when 0=>led_pos_me <= "100111000";num2 := 1;
																				when 1=>led_pos_me <= "101001000";num2 := 2;
																				when 2=>led_pos_me <= "101011000";num2 := 3;
																				when 3=>led_pos_me <= "101101000";num2 := 4;
																				when 4=>led_pos_me <= "101011001";num2 := 5;
																				when others=>led_pos_me <= "101001010";num2 := 0;num1 := 9;
																			end case;
																when 9=>case num2 is
																				when 0=>led_pos_me <= "100110111";num2 := 1;
																				when 1=>led_pos_me <= "101000111";num2 := 2;
																				when 2=>led_pos_me <= "101010111";num2 := 3;
																				when 3=>led_pos_me <= "101100111";num2 := 4;
																				when 4=>led_pos_me <= "101011000";num2 := 5;
																				when others=>led_pos_me <= "101001001";num2 := 0;num1 := 10;
																			end case;
																when 10=>case num2 is
																				when 0=>led_pos_me <= "100110110";num2 := 1;
																				when 1=>led_pos_me <= "101000110";num2 := 2;
																				when 2=>led_pos_me <= "101010110";num2 := 3;
																				when 3=>led_pos_me <= "101100110";num2 := 4;
																				when 4=>led_pos_me <= "101010111";num2 := 5;
																				when others=>led_pos_me <= "101001000";num2 := 0;num1 := 11;
																			end case;
																when 11=>case num2 is
																				when 0=>led_pos_me <= "110110101";num2 := 1;
																				when 1=>led_pos_me <= "111000101";num2 := 2;
																				when 2=>led_pos_me <= "111010101";num2 := 3;
																				when 3=>led_pos_me <= "111100101";num2 := 4;
																				when 4=>led_pos_me <= "111010110";num2 := 5;
																				when others=>led_pos_me <= "111000111";num2 := 0;num1 := 12;
																			end case;
																when 12=>case num2 is
																				when 0=>led_pos_me <= "110110100";num2 := 1;
																				when 1=>led_pos_me <= "111000100";num2 := 2;
																				when 2=>led_pos_me <= "111010100";num2 := 3;
																				when 3=>led_pos_me <= "111100100";num2 := 4;
																				when 4=>led_pos_me <= "111010101";num2 := 5;
																				when others=>led_pos_me <= "111000110";num2 := 0;num1 := 13;
																			end case;
																when 13=>case num2 is
																				when 0=>led_pos_me <= "110110011";num2 := 1;
																				when 1=>led_pos_me <= "111000011";num2 := 2;
																				when 2=>led_pos_me <= "111010011";num2 := 3;
																				when 3=>led_pos_me <= "111100011";num2 := 4;
																				when 4=>led_pos_me <= "111010100";num2 := 5;
																				when others=>led_pos_me <= "111000101";num2 := 0;num1 := 14;
																			end case;
																when 14=>case num2 is
																				when 0=>led_pos_me <= "110110010";num2 := 1;
																				when 1=>led_pos_me <= "111000010";num2 := 2;
																				when 2=>led_pos_me <= "111010010";num2 := 3;
																				when 3=>led_pos_me <= "111100010";num2 := 4;
																				when 4=>led_pos_me <= "111010011";num2 := 5;
																				when others=>led_pos_me <= "111000100";num2 := 0;num1 := 15;
																			end case;
																when 15=>case num2 is
																				when 0=>led_pos_me <= "010110001";num2 := 1;
																				when 1=>led_pos_me <= "011000001";num2 := 2;
																				when 2=>led_pos_me <= "011010001";num2 := 3;
																				when 3=>led_pos_me <= "011100001";num2 := 4;
																				when 4=>led_pos_me <= "011010010";num2 := 5;
																				when others=>led_pos_me <= "011000011";num2 := 0;num1 := 16;
																			end case;
																when others=>case num2 is
																				when 0=>led_pos_me <= "010110000";num2 := 1;
																				when 1=>led_pos_me <= "011000000";num2 := 2;
																				when 2=>led_pos_me <= "011010000";num2 := 3;
																				when 3=>led_pos_me <= "011100000";num2 := 4;
																				when 4=>led_pos_me <= "011010001";num2 := 5;
																				when others=>led_pos_me <= "011000010";num2 := 0;num1 := 0;
																			end case;
															end case;
										 end case;
							when others=>case dir_b(num1-1) is
												when '0'=>--left
																case num1 is
																when 1=> num2 := 0;num1 := 2;led_pos_me <= "111011111";
																when 2=>case num2 is
																				when 0=>led_pos_me <= "111011110";num2 := 1;
																				when 1=>led_pos_me <= "111011111";num2 := 2;
																				when others=>led_pos_me <= "111001111";num2 := 0;num1 := 3;
																			end case;
																when 3=>case num2 is
																				when 0=>led_pos_me <= "111011101";num2 := 1;
																				when 1=>led_pos_me <= "111011110";num2 := 2;
																				when 2=>led_pos_me <= "111011111";num2 := 3;
																				when 3=>led_pos_me <= "111001110";num2 := 4;
																				when others=>led_pos_me <= "110111111";num2 := 0;num1 := 4;
																			end case;
																when 4=>case num2 is
																				when 0=>led_pos_me <= "111011100";num2 := 1;
																				when 1=>led_pos_me <= "111011101";num2 := 2;
																				when 2=>led_pos_me <= "111011110";num2 := 3;
																				when 3=>led_pos_me <= "111011111";num2 := 4;
																				when 4=>led_pos_me <= "111001101";num2 := 5;
																				when others=>led_pos_me <= "110111110";num2 := 0;num1 := 5;
																			end case;
																when 5=>case num2 is
																				when 0=>led_pos_me <= "111011011";num2 := 1;
																				when 1=>led_pos_me <= "111011100";num2 := 2;
																				when 2=>led_pos_me <= "111011101";num2 := 3;
																				when 3=>led_pos_me <= "111011110";num2 := 4;
																				when 4=>led_pos_me <= "111001100";num2 := 5;
																				when others=>led_pos_me <= "110111101";num2 := 0;num1 := 6;
																			end case;
																when 6=>case num2 is
																				when 0=>led_pos_me <= "111011010";num2 := 1;
																				when 1=>led_pos_me <= "111011011";num2 := 2;
																				when 2=>led_pos_me <= "111011100";num2 := 3;
																				when 3=>led_pos_me <= "111011101";num2 := 4;
																				when 4=>led_pos_me <= "111001011";num2 := 5;
																				when others=>led_pos_me <= "110111100";num2 := 0;num1 := 7;
																			end case;
																when 7=>case num2 is
																				when 0=>led_pos_me <= "111011001";num2 := 1;
																				when 1=>led_pos_me <= "111011010";num2 := 2;
																				when 2=>led_pos_me <= "111011011";num2 := 3;
																				when 3=>led_pos_me <= "111011100";num2 := 4;
																				when 4=>led_pos_me <= "111001010";num2 := 5;
																				when others=>led_pos_me <= "110111011";num2 := 0;num1 := 8;
																			end case;
																when 8=>case num2 is
																				when 0=>led_pos_me <= "111011000";num2 := 1;
																				when 1=>led_pos_me <= "111011001";num2 := 2;
																				when 2=>led_pos_me <= "111011010";num2 := 3;
																				when 3=>led_pos_me <= "111011011";num2 := 4;
																				when 4=>led_pos_me <= "111001001";num2 := 5;
																				when others=>led_pos_me <= "110111010";num2 := 0;num1 := 9;
																			end case;
																when 9=>case num2 is
																				when 0=>led_pos_me <= "111010111";num2 := 1;
																				when 1=>led_pos_me <= "111011000";num2 := 2;
																				when 2=>led_pos_me <= "111011001";num2 := 3;
																				when 3=>led_pos_me <= "111011010";num2 := 4;
																				when 4=>led_pos_me <= "111001000";num2 := 5;
																				when others=>led_pos_me <= "110111001";num2 := 0;num1 := 10;
																			end case;
																when 10=>case num2 is
																				when 0=>led_pos_me <= "111010110";num2 := 1;
																				when 1=>led_pos_me <= "111010111";num2 := 2;
																				when 2=>led_pos_me <= "111011000";num2 := 3;
																				when 3=>led_pos_me <= "111011001";num2 := 4;
																				when 4=>led_pos_me <= "111000111";num2 := 5;
																				when others=>led_pos_me <= "110111000";num2 := 0;num1 := 11;
																			end case;
																when 11=>case num2 is
																				when 0=>led_pos_me <= "111010101";num2 := 1;
																				when 1=>led_pos_me <= "111010110";num2 := 2;
																				when 2=>led_pos_me <= "111010111";num2 := 3;
																				when 3=>led_pos_me <= "111011000";num2 := 4;
																				when 4=>led_pos_me <= "111000110";num2 := 5;
																				when others=>led_pos_me <= "110110111";num2 := 0;num1 := 12;
																			end case;
																when 12=>case num2 is
																				when 0=>led_pos_me <= "111010100";num2 := 1;
																				when 1=>led_pos_me <= "111010101";num2 := 2;
																				when 2=>led_pos_me <= "111010110";num2 := 3;
																				when 3=>led_pos_me <= "111010111";num2 := 4;
																				when 4=>led_pos_me <= "111000101";num2 := 5;
																				when others=>led_pos_me <= "110110110";num2 := 0;num1 := 13;
																			end case;
																when 13=>case num2 is
																				when 0=>led_pos_me <= "111010011";num2 := 1;
																				when 1=>led_pos_me <= "111010100";num2 := 2;
																				when 2=>led_pos_me <= "111010101";num2 := 3;
																				when 3=>led_pos_me <= "111010110";num2 := 4;
																				when 4=>led_pos_me <= "111000100";num2 := 5;
																				when others=>led_pos_me <= "110110101";num2 := 0;num1 := 14;
																			end case;
																when 14=>case num2 is
																				when 0=>led_pos_me <= "111010010";num2 := 1;
																				when 1=>led_pos_me <= "111010011";num2 := 2;
																				when 2=>led_pos_me <= "111010100";num2 := 3;
																				when 3=>led_pos_me <= "111010101";num2 := 4;
																				when 4=>led_pos_me <= "111000011";num2 := 5;
																				when others=>led_pos_me <= "110110100";num2 := 0;num1 := 15;
																			end case;
																when 15=>case num2 is
																				when 0=>led_pos_me <= "111010001";num2 := 1;
																				when 1=>led_pos_me <= "111010010";num2 := 2;
																				when 2=>led_pos_me <= "111010011";num2 := 3;
																				when 3=>led_pos_me <= "111010100";num2 := 4;
																				when 4=>led_pos_me <= "111000010";num2 := 5;
																				when others=>led_pos_me <= "110110011";num2 := 0;num1 := 16;
																			end case;
																when others=>case num2 is
																				when 0=>led_pos_me <= "111010000";num2 := 1;
																				when 1=>led_pos_me <= "111010001";num2 := 2;
																				when 2=>led_pos_me <= "111010010";num2 := 3;
																				when 3=>led_pos_me <= "111010011";num2 := 4;
																				when 4=>led_pos_me <= "111000001";num2 := 5;
																				when others=>led_pos_me <= "110110010";num2 := 0;num1 := 0;
																			end case;
															end case;
												when others=>--right
															case num1 is
																when 1=>num1 := 2;num2 := 0;led_pos_me <= "111011111";
																when 2=>case num2 is
																				when 0=>led_pos_me <= "111011110";num2 := 1;
																				when 1=>led_pos_me <= "111011111";num2 := 2;
																				when others=>led_pos_me <= "110111111";num2 := 0;num1 := 3;
																			end case;
																when 3=>case num2 is
																				when 0=>led_pos_me <= "111011101";num2 := 1;
																				when 1=>led_pos_me <= "111011110";num2 := 2;
																				when 2=>led_pos_me <= "111011111";num2 := 3;
																				when 3=>led_pos_me <= "111001111";num2 := 4;
																				when others=>led_pos_me <= "110111110";num2 := 0;num1 := 4;
																			end case;
																when 4=>case num2 is
																				when 0=>led_pos_me <= "111011100";num2 := 1;
																				when 1=>led_pos_me <= "111011101";num2 := 2;
																				when 2=>led_pos_me <= "111011110";num2 := 3;
																				when 3=>led_pos_me <= "111011111";num2 := 4;
																				when 4=>led_pos_me <= "111001110";num2 := 5;
																				when others=>led_pos_me <= "110111101";num2 := 0;num1 := 5;
																			end case;
																when 5=>case num2 is
																				when 0=>led_pos_me <= "111011011";num2 := 1;
																				when 1=>led_pos_me <= "111011100";num2 := 2;
																				when 2=>led_pos_me <= "111011101";num2 := 3;
																				when 3=>led_pos_me <= "111011110";num2 := 4;
																				when 4=>led_pos_me <= "111001101";num2 := 5;
																				when others=>led_pos_me <= "110111100";num2 := 0;num1 := 6;
																			end case;
																when 6=>case num2 is
																				when 0=>led_pos_me <= "111011010";num2 := 1;
																				when 1=>led_pos_me <= "111011011";num2 := 2;
																				when 2=>led_pos_me <= "111011100";num2 := 3;
																				when 3=>led_pos_me <= "111011101";num2 := 4;
																				when 4=>led_pos_me <= "111001100";num2 := 5;
																				when others=>led_pos_me <= "110111011";num2 := 0;num1 := 7;
																			end case;
																when 7=>case num2 is
																				when 0=>led_pos_me <= "111011001";num2 := 1;
																				when 1=>led_pos_me <= "111011010";num2 := 2;
																				when 2=>led_pos_me <= "111011011";num2 := 3;
																				when 3=>led_pos_me <= "111011100";num2 := 4;
																				when 4=>led_pos_me <= "111001011";num2 := 5;
																				when others=>led_pos_me <= "110111010";num2 := 0;num1 := 8;
																			end case;
																when 8=>case num2 is
																				when 0=>led_pos_me <= "111011000";num2 := 1;
																				when 1=>led_pos_me <= "111011001";num2 := 2;
																				when 2=>led_pos_me <= "111011010";num2 := 3;
																				when 3=>led_pos_me <= "111011011";num2 := 4;
																				when 4=>led_pos_me <= "111001010";num2 := 5;
																				when others=>led_pos_me <= "110111001";num2 := 0;num1 := 9;
																			end case;
																when 9=>case num2 is
																				when 0=>led_pos_me <= "111010111";num2 := 1;
																				when 1=>led_pos_me <= "111011000";num2 := 2;
																				when 2=>led_pos_me <= "111011001";num2 := 3;
																				when 3=>led_pos_me <= "111011010";num2 := 4;
																				when 4=>led_pos_me <= "111001001";num2 := 5;
																				when others=>led_pos_me <= "110111000";num2 := 0;num1 := 10;
																			end case;
																when 10=>case num2 is
																				when 0=>led_pos_me <= "111010110";num2 := 1;
																				when 1=>led_pos_me <= "111010111";num2 := 2;
																				when 2=>led_pos_me <= "111011000";num2 := 3;
																				when 3=>led_pos_me <= "111011001";num2 := 4;
																				when 4=>led_pos_me <= "111001000";num2 := 5;
																				when others=>led_pos_me <= "110110111";num2 := 0;num1 := 11;
																			end case;
																when 11=>case num2 is
																				when 0=>led_pos_me <= "111010101";num2 := 1;
																				when 1=>led_pos_me <= "111010110";num2 := 2;
																				when 2=>led_pos_me <= "111010111";num2 := 3;
																				when 3=>led_pos_me <= "111011000";num2 := 4;
																				when 4=>led_pos_me <= "111000111";num2 := 5;
																				when others=>led_pos_me <= "110110110";num2 := 0;num1 := 12;
																			end case;
																when 12=>case num2 is
																				when 0=>led_pos_me <= "111010100";num2 := 1;
																				when 1=>led_pos_me <= "111010101";num2 := 2;
																				when 2=>led_pos_me <= "111010110";num2 := 3;
																				when 3=>led_pos_me <= "111010111";num2 := 4;
																				when 4=>led_pos_me <= "111000110";num2 := 5;
																				when others=>led_pos_me <= "110110101";num2 := 0;num1 := 13;
																			end case;
																when 13=>case num2 is
																				when 0=>led_pos_me <= "111010011";num2 := 1;
																				when 1=>led_pos_me <= "111010100";num2 := 2;
																				when 2=>led_pos_me <= "111010101";num2 := 3;
																				when 3=>led_pos_me <= "111010110";num2 := 4;
																				when 4=>led_pos_me <= "111000101";num2 := 5;
																				when others=>led_pos_me <= "110110100";num2 := 0;num1 := 14;
																			end case;
																when 14=>case num2 is
																				when 0=>led_pos_me <= "111010010";num2 := 1;
																				when 1=>led_pos_me <= "111010011";num2 := 2;
																				when 2=>led_pos_me <= "111010100";num2 := 3;
																				when 3=>led_pos_me <= "111010101";num2 := 4;
																				when 4=>led_pos_me <= "111000100";num2 := 5;
																				when others=>led_pos_me <= "110110011";num2 := 0;num1 := 15;
																			end case;
																when 15=>case num2 is
																				when 0=>led_pos_me <= "111010001";num2 := 1;
																				when 1=>led_pos_me <= "111010010";num2 := 2;
																				when 2=>led_pos_me <= "111010011";num2 := 3;
																				when 3=>led_pos_me <= "111010100";num2 := 4;
																				when 4=>led_pos_me <= "111000011";num2 := 5;
																				when others=>led_pos_me <= "110110010";num2 := 0;num1 := 16;
																			end case;
																when others=>case num2 is
																				when 0=>led_pos_me <= "111010000";num2 := 1;
																				when 1=>led_pos_me <= "111010001";num2 := 2;
																				when 2=>led_pos_me <= "111010010";num2 := 3;
																				when 3=>led_pos_me <= "111010011";num2 := 4;
																				when 4=>led_pos_me <= "111000010";num2 := 5;
																				when others=>led_pos_me <= "110110001";num2 := 0;num1 := 0;
																			end case;
															end case;
											end case;
						end case;
					else 
						case num1 is
							when 1=>num1 := 2; num2 :=0;
							when 2=>num1 := 3; num2 :=0;
							when 3=>num1 := 4; num2 :=0;
							when 4=>num1 := 5; num2 :=0;
							when 5=>num1 := 6; num2 :=0;
							when 6=>num1 := 7; num2 :=0;
							when 7=>num1 := 8; num2 :=0;
							when 8=>num1 := 9; num2 :=0;
							when 9=>num1 := 10; num2 :=0;
							when 10=>num1 := 11; num2 :=0;
							when 11=>num1 := 12; num2 :=0;
							when 12=>num1 := 13; num2 :=0;
							when 13=>num1 := 14; num2 :=0;
							when 14=>num1 := 15; num2 :=0;
							when 15=>num1 := 16; num2 :=0;
							when others=> num1 := 17; num2 :=0;
						end case;
					end if;
				end if;
			end if;
		end if;
	end process;
end architecture;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hit is
port(
sclk:in std_logic;
tclk:in std_logic;
pause:in std_logic;
tbeat:in std_logic_vector(3 downto 0);
clock : in std_logic;
sco:out std_logic_vector(7 downto 0);
export:out std_logic_vector(47 downto 0)
);
end entity;

architecture run of hit is
signal tis_go:std_logic:='0';
signal tis_hit:std_logic:='0';
signal tis_add:std_logic:='0';
signal is_go:std_logic:='0';
signal is_hit:std_logic:='0';
signal is_add:std_logic:='0';
signal over:std_logic:='1';
signal clk:std_logic;
signal beat:std_logic_vector(3 downto 0);
signal life:std_logic_vector(2 downto 0):="111";
signal typ:std_logic_vector(1 downto 0):="00";
signal info:std_logic_vector(15 downto 0):=x"0000";
signal typ1:std_logic_vector(15 downto 0):=x"0000";
signal typ2:std_logic_vector(15 downto 0):=x"0000";
signal toadd:std_logic_vector(1 downto 0):="00";
signal score:std_logic_vector(7 downto 0):="00000000";
signal len:std_logic_vector(19 downto 0):="01011101001001010100";
shared variable number_len:integer range 0 to 19:=0;
signal random:std_logic_vector(19 downto 0):="00100111010010100011";
shared variable number_index:integer range 0 to 19:=0;
shared variable index:integer range 0 to 7:=0;
shared variable fqy:integer range 0 to 7:=4;
component largelymfs
port(
r: in std_logic;
lif: in std_logic_vector(2 downto 0);
dir_a: in std_logic_vector(15 downto 0);
dir_b: in std_logic_vector(15 downto 0);
exist: in std_logic_vector(15 downto 0);
output: out std_logic_vector(47 downto 0)
);
end component;
begin

sco<=score;
clk<=pause and tclk and over;
beat(0)<=pause and not tbeat(0) and over;
beat(1)<=pause and not tbeat(1) and over;
beat(2)<=pause and not tbeat(2) and over;
beat(3)<=pause and not tbeat(3) and over;
u1: largelymfs port map
(r=>sclk,lif=>life,dir_a=>typ1,dir_b=>typ2,exist=>info,output=>export);

p1:process(clk)
begin
	if clk'event and clk='1' then
		tis_go<=is_go;
	end if;
end process;

pp:process(clock)
begin
	if (clock'event and clock='1') then
		is_go<=not is_go;
	end if;
end process;

p2:process(beat,clk)
begin
	if clk'event and clk='1' then
		tis_hit<=is_hit;
		if is_hit='0' then
			is_hit<='1';
		else
			is_hit<='0';
		end if;
		case beat is
			when "0001"=> typ<="00";
			when "0010"=> typ<="01";
			when "0100"=> typ<="10";
			when others=> typ<="11";
		end case;
	end if;
end process;

p4:process(is_go,is_hit,clk)
variable win:std_logic;
variable lose:std_logic;
begin
	if clk'event and clk='1' then
	if index>=fqy then
		if info(15)='1' then
			case life is
				when"111"=> life<="110";
				when"110"=> life<="101";
				when"101"=> life<="100";
				when"100"=> life<="011";
				when"011"=> life<="010";
				when"010"=> life<="001";
				when others=> life<="000";
			end case;
		end if;
		for i in 1 to 15 loop
			info(16-i)<=info(15-i);
			typ1(16-i)<=typ1(15-i);
			typ2(16-i)<=typ2(15-i);
		end loop;
		info(0)<='1';
		typ1(0)<='0';
		typ2(0)<=random(number_index);
		if number_index=18 then
			number_index:=0;
		else
			number_index:=number_index+1;
		end if;
		if len(number_len)='0' then
			if len(number_len+1)='0' then
				fqy:=4;
			else
				fqy:=5;
			end if;
		else
			if len(number_len+1)='0' then
				fqy:=6;
			else
				fqy:=7;
			end if;
		end if;
		if number_len=18 then
			number_len:=0;
		else
			number_len:=number_len+1;
		end if;
		index:=0;
	elsif tis_go/=is_go then
		if info(15)='1' then
			case life is
				when"111"=> life<="110";
				when"110"=> life<="101";
				when"101"=> life<="100";
				when"100"=> life<="011";
				when"011"=> life<="010";
				when"010"=> life<="001";
				when others=> life<="000";
			end case;
		end if;
		for i in 1 to 15 loop
			info(16-i)<=info(15-i);
			typ1(16-i)<=typ1(15-i);
			typ2(16-i)<=typ2(15-i);
		end loop;
		info(0)<='0';
		index:=index+1;
	elsif is_hit/=tis_hit then
		win:='0';
		lose:='0';
		for i in 1 to 4 loop
			if info(14-i)='1' then
				case typ is
					when "00"=>
						if typ1(14-i)='0' and typ2(14-i)='0' then
							win:='1';
							info(14-i)<='0';
						else
							lose:='1';
						end if;
					when "01"=>
						if typ1(14-i)='0' and typ2(14-i)='1' then
							win:='1';
							info(14-i)<='0';
						else
							lose:='1';
						end if;
					
					when others=>
						if typ1(14-i)='1' and typ2(14-i)='1' then
							--win:='1';
							info(14-i)<='0';
						end if;
				end case;
			end if;
		end loop;
		if win='1' then
			if score(3 downto 0)="1001" and (not ( score(7 downto 4)="1001" ) ) then
				score(3 downto 0)<="0000";
				case score(7 downto 4) is
					when "0000"=> score(7 downto 4)<="0001";
					when "0001"=> score(7 downto 4)<="0010";
					when "0010"=> score(7 downto 4)<="0011";
					when "0011"=> score(7 downto 4)<="0100";
					when "0100"=> score(7 downto 4)<="0101";
					when "0101"=> score(7 downto 4)<="0110";
					when "0110"=> score(7 downto 4)<="0111";
					when "0111"=> score(7 downto 4)<="1000";
					when others=> score(7 downto 4)<="1001";
				end case;
			else
				case score(3 downto 0) is
					when "0000"=> score(3 downto 0)<="0001";
					when "0001"=> score(3 downto 0)<="0010";
					when "0010"=> score(3 downto 0)<="0011";
					when "0011"=> score(3 downto 0)<="0100";
					when "0100"=> score(3 downto 0)<="0101";
					when "0101"=> score(3 downto 0)<="0110";
					when "0110"=> score(3 downto 0)<="0111";
					when "0111"=> score(3 downto 0)<="1000";
					when others=> score(3 downto 0)<="1001";
				end case;
			end if;
		end if;
		if lose='1' then
			score<="00000000";
		end if;
	end if;
	end if;
end process;

p5:process (life,clk)
begin
if clk'event and clk='1' then
if life="000" then
	over<='0';
end if;
end if;
end process;

end architecture;
