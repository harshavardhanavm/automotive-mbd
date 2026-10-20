%% TC-002: Throttle Limitation
% Requirement:
% The throttle command shall remain between 0 and 1.

clear;
clc;

%% Model
model = 'Model/CruiseControl_V1';

load_system(model);

%% Initialize parameters
run('Parameters/CC_init.m');

%% Test Inputs
V0 = 0;              % Initial vehicle speed [m/s]
Vtarget = 30;        % Target speed [m/s]
RoadGrade = 0;       % Road grade [deg]

%% Simulation
set_param(model, 'StopTime', '30');

simOut = sim(model);

%% Read logged signals
Throttle_ts = simOut.Throttle;

Throttle = Throttle_ts.data;

%% Calculate results
MaxThrottle = max(Throttle);
MinThrottle = min(Throttle);

%% Pass / Fail
ThrottleLimitPass = ...
    (MaxThrottle <= 1.0) && ...
    (MinThrottle >= 0.0);

%% Print result
fprintf('\n');
fprintf('============================================\n');
fprintf('        TC-002 THROTTLE LIMITATION         \n');
fprintf('============================================\n');

fprintf('Target Speed       : %.2f m/s\n', Vtarget);
fprintf('Maximum Throttle   : %.3f\n', MaxThrottle);
fprintf('Minimum Throttle   : %.3f\n', MinThrottle);

fprintf('--------------------------------------------\n');

if ThrottleLimitPass
    fprintf('RESULT             : PASS\n');
else
    fprintf('RESULT             : FAIL\n');
end

fprintf('============================================\n');