# Digital-electronics-1-Project

## Team members: 
Nanko     Matej <br>
Nikolic   Predrag <br>
Ondriš    Mário <br>
Opluštil  Filip <br>
Pijáček   Štěpán <br>

[Our project folder](https://github.com/xnanko00/Digital-electronics-1-Project)

## Project objectives:
In this project we are supposed to make a program in VHDL for door lock system with PIN (4-digit) terminal, 4x3 push buttons, 4-digit 7-segment display, relay for door lock control. As an extra feature we also added delete/reset button that resets keyboard sequence.

### Diagram

![Diagram](images/diagram.png)

## Hardware description 

### Board schematic of our project(for higher resolution you need to open it in microcap):

![Schematic](images/schematic.png)

## VHDL modules description 

### Keyboard
We programmed our keyboard to ...

### VHDL lock:
```vhdl
entity lock is
    port(
        clk     : in  std_logic;
        reset   : in  std_logic;
        keypad_i: in std_logic_vector(4 - 1 downto 0);
        data0_o : out  std_logic_vector(4 - 1 downto 0);
        data1_o : out  std_logic_vector(4 - 1 downto 0);
        data2_o : out  std_logic_vector(4 - 1 downto 0);
        data3_o : out  std_logic_vector(4 - 1 downto 0);
        door_o  : out  std_logic

    );
end lock;
```

## TOP module description and simulations
TODO

### Simulation of a keypad:
![KeypadSimulation](images/simulation_keypad.png)

### Simulation of a lock:
![LockSimulation](images/simulation1.png)

## Video
TODO

## References 

https://reference.digilentinc.com/_media/reference/programmable-logic/arty-a7/arty_a7_sch.pdf <br>
https://reference.digilentinc.com/_media/reference/pmod/pmodkypd/pmodkypd_sch.pdf <br>
http://fpga.fm4dd.com/?pmod/7seg4 <br>
https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board/ <br>
https://store.digilentinc.com/pmod-ssr-solid-state-relay-electronic-switch/ <br>
https://store.digilentinc.com/pmod-kypd-16-button-keypad/ <br>
