%% Vehicle Parameters
Mass = 1500;              % kg
Cd = 0.3;                 % -
A = 2.2;                  % m^2
rho = 1.225;              % kg/m^3
Crr = 0.01;               % -
g = 9.81;                 % m/s^2

%% Powertrain
Fmax = 5000;               % N

%% Initial Conditions
V0 = 0;                    % m/s

%% Simulation
Ts = 0.01;                 % 10 ms

%% PID controller 
kp= 0.0928;
ki=0.012;
Kaw=1;

%% Brake pedal max force 
FbrakeMax=8000; %N