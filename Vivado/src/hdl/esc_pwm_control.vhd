----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/30/2017 12:43:06 PM
-- Design Name: 
-- Module Name: esc_pwm_control - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity esc_pwm_control is
    generic ( CLK_FREQ : integer := 10000000;
         PWM_FREQ : integer := 50);
    
    Port ( clk_i : in STD_LOGIC;
           reset_i : in STD_LOGIC;
           pwm_duty_i : in STD_LOGIC_VECTOR (7 downto 0);
           pwm_o : out std_logic);
end esc_pwm_control;

architecture Behavioral of esc_pwm_control is
    constant scaled_clk_freq : integer := 1*256*1000;  -- range = 1ms (between 1ms and 2ms), resolution = 8bit (256), 
    constant scaled_clk_period : integer := CLK_FREQ / PWM_FREQ; -- Period of the scaled clock
    
    signal clk_cnt : integer := 0;
begin

-- Clock prescaler process with asynchronous reset
clk_prescaler:  process(clk_i, reset_i)
                begin 
                    if reset_i = '0' then   -- AXI reset is active low 
                        clk_cnt <= 0;
                        pwm_o <= '1';
                    elsif rising_edge(clk_i) then
                        clk_cnt <= clk_cnt + 1;
                        if clk_cnt = scaled_clk_period then
                            clk_cnt <= 0; 
                            pwm_o <= '1';
                        elsif clk_cnt = scaled_clk_period/2 then
                            pwm_o <= '0';
                        end if;
                    end if;    
                end process;
end Behavioral;

