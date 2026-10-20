%% TC-004: Cruise Control Speed Tracking Downhill
% Requirement:
% Vehicle shall regulate speed toward the requested target speed.
% Steady-state speed error shall be less than 0.5 m/s
% during the final 5 seconds of simulation.

clear;
clc;

%% Model
model = 'Model/CruiseControl_V1';

load_system(model);

%% Set the parameters
run('Parameters/CC_init.m');

%% Test Inputs
V0 = 20;              % Initial vehicle speed [m/s]
Vtarget = 20;        % Target speed [m/s]
RoadGrade = -5;       % Road grade [deg]

%% Simulation
StopTime = 30;
set_param(model, 'StopTime', num2str(StopTime));

simOut = sim(model);

%% Read logged signals
VehicleSpeed_ts = simOut.VehicleSpeed;
Throttle_ts     = simOut.Throttle;

VehicleSpeed = VehicleSpeed_ts.data;
Throttle     = Throttle_ts.data;
Time         = VehicleSpeed_ts.time;

Brake_ts = simOut.Brake;
Brake = Brake_ts.data;

%% Calcuate brake
MaxBrake = max(Brake);
MinBrake = min(Brake);

%% Calculate final speed
FinalSpeed = VehicleSpeed(end);

%% Calculate final speed error
FinalError = abs(Vtarget - FinalSpeed);

%% Calculate throttle limits
MaxThrottle = max(Throttle);
MinThrottle = min(Throttle);

%% Steady-state analysis
% Analyze the final 5 seconds of simulation

SteadyStateWindow = 5;    % seconds
SteadyStateStart = StopTime - SteadyStateWindow;

% Find samples belonging to the final 5 seconds
SS_Index = Time >= SteadyStateStart;

% Extract steady-state vehicle speed
SteadyStateSpeed = VehicleSpeed(SS_Index);

% Calculate absolute speed error
SteadyStateError = abs(Vtarget - SteadyStateSpeed);

% Maximum error during steady-state window
SteadyStateErrorMax = max(SteadyStateError);

%% Pass / Fail criteria

SteadyStateSpeedPass = SteadyStateErrorMax < 0.5;

ThrottleLimitPass = ...
    (MaxThrottle <= 1.0) && ...
    (MinThrottle >= 0.0);

TestPass = SteadyStateSpeedPass && ThrottleLimitPass;

%% Print result

fprintf('\n');
fprintf('============================================\n');
fprintf('           TC-004 CRUISE CONTROL            \n');
fprintf('============================================\n');

fprintf('Target Speed          : %.2f m/s\n', Vtarget);
fprintf('Final Speed           : %.2f m/s\n', FinalSpeed);
fprintf('Final Error           : %.2f m/s\n', FinalError);

fprintf('Steady-State Window   : %.1f s\n', SteadyStateWindow);
fprintf('Steady-State Max Error: %.2f m/s\n', SteadyStateErrorMax);

fprintf('Maximum Throttle      : %.3f\n', MaxThrottle);
fprintf('Minimum Throttle      : %.3f\n', MinThrottle);

fprintf('Maximum Brake         : %.3f\n', MaxBrake);
fprintf('Minimum Brake         : %.3f\n', MinBrake);

fprintf('--------------------------------------------\n');

if TestPass
    fprintf('RESULT                : PASS\n');
else
    fprintf('RESULT                : FAIL\n');
end

fprintf('============================================\n');