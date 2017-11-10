library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity esc_pwm_control_sim is
end esc_pwm_control_sim;

architecture behavior of esc_pwm_control_sim is

    component esc_pwm_control
        port ( clk_i : in std_logic;
           reset_i : in std_logic;
           pwm_duty_i : in std_logic_vector (7 downto 0);
           pwm_o : out std_logic);
    end component;

    signal clk_i : std_logic := '0';
    signal reset_i : std_logic := '0';
    signal pwm_duty_i : std_logic_vector(7 downto 0);
    signal pwm_o : std_logic := '0';
    constant clk_period : time := 0.1 us;

begin
    -- instantiate the unit under test (uut)
    uut: esc_pwm_control port map (
         clk_i => clk_i,
          reset_i => reset_i,
          pwm_duty_i => pwm_duty_i,
          pwm_o => pwm_o
        );

   -- clock process definitions( clock with 50% duty cycle is generated here.
    clk_process :process
    begin
        clk_i <= '0';
        wait for clk_period/2;  --for 0.5 us signal is '0'.
        clk_i <= '1';
        wait for clk_period/2;  --for next 0.5 us signal is '1'.
    end process;

    -- stimulus process
    stim_proc: process
    begin
        reset_i <='1';
        pwm_duty_i <= x"00";
        wait for 60 ms;
        reset_i <='0';
        wait for 5 ms;
    end process;

end;
