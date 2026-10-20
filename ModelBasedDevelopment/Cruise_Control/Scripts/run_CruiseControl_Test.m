function result = run_CruiseControl_Test( ...
    TestID, V0, Vtarget, RoadGrade, StopTime)

%% Generic Cruise Control Test Runner
%
% Inputs:
%   TestID      - Test case identifier
%   V0          - Initial vehicle speed [m/s]
%   Vtarget     - Target vehicle speed [m/s]
%   RoadGrade   - Road grade [deg]
%   StopTime    - Simulation duration [s]
%
% Output:
%   result      - Structure containing test results

%% Model
model = 'CruiseControl_V1';

load_system(model);

%% Initialize parameters
run('CC_init.m');

%% Set test inputs
% These variables must be used by the Simulink model.
V0 = V0;
Vtarget = Vtarget;
RoadGrade = RoadGrade;

%% Simulation
set_param(model, 'StopTime', num2str(StopTime));

simOut = sim(model);

%% Read simulation results

VehicleSpeed_ts = simOut.VehicleSpeed;
Throttle_ts     = simOut.Throttle;
Brake_ts        = simOut.Brake;

VehicleSpeed = VehicleSpeed_ts.data;
Throttle     = Throttle_ts.data;
Brake        = Brake_ts.data;
Time         = VehicleSpeed_ts.time;

%% Basic metrics

FinalSpeed = VehicleSpeed(end);

FinalError = abs(Vtarget - FinalSpeed);

MaxThrottle = max(Throttle);
MinThrottle = min(Throttle);

MaxBrake = max(Brake);
MinBrake = min(Brake);

%% Steady-state analysis

SteadyStateWindow = 5;

SteadyStateStart = StopTime - SteadyStateWindow;

SS_Index = Time >= SteadyStateStart;

SteadyStateSpeed = VehicleSpeed(SS_Index);

SteadyStateError = abs(Vtarget - SteadyStateSpeed);

SteadyStateErrorMax = max(SteadyStateError);

%% Pass / Fail criteria

SteadyStateSpeedPass = ...
    SteadyStateErrorMax < 0.5;

ThrottleLimitPass = ...
    (MaxThrottle <= 1.0) && ...
    (MinThrottle >= 0.0);

BrakeLimitPass = ...
    (MaxBrake <= 1.0) && ...
    (MinBrake >= 0.0);

TestPass = ...
    SteadyStateSpeedPass && ...
    ThrottleLimitPass && ...
    BrakeLimitPass;

%% Store results

result.TestID = TestID;

result.V0 = V0;
result.Vtarget = Vtarget;
result.RoadGrade = RoadGrade;
result.StopTime = StopTime;

result.FinalSpeed = FinalSpeed;
result.FinalError = FinalError;

result.SteadyStateErrorMax = SteadyStateErrorMax;

result.MaxThrottle = MaxThrottle;
result.MinThrottle = MinThrottle;

result.MaxBrake = MaxBrake;
result.MinBrake = MinBrake;

result.Pass = TestPass;

%% Print result

fprintf('\n');
fprintf('============================================\n');
fprintf('        %s CRUISE CONTROL TEST             \n', TestID);
fprintf('============================================\n');

fprintf('Initial Speed         : %.2f m/s\n', V0);
fprintf('Target Speed          : %.2f m/s\n', Vtarget);
fprintf('Road Grade            : %.2f deg\n', RoadGrade);

fprintf('--------------------------------------------\n');

fprintf('Final Speed           : %.2f m/s\n', FinalSpeed);
fprintf('Final Error           : %.2f m/s\n', FinalError);

fprintf('Steady-State Window   : %.1f s\n', ...
    SteadyStateWindow);

fprintf('Steady-State Max Error: %.2f m/s\n', ...
    SteadyStateErrorMax);

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

end