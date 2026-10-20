clear;
clc;

%% Model
model = 'Model/BrakeController_MBD';

load_system(model);

%% Calibration
k = 2;
BrakePressure_Max = 100;
Ts=0.001;

%% Test cases
TestID = {'TC01'; 'TC02'; 'TC03'; 'TC04'};

VehicleSpeed_Test = [0; 20; 20; 60];
BrakeRequest_Test = [0; 0; 1; 1];
Expected = [0; 0; 40; 100];

Tolerance = 1e-6;

%% Result storage
Actual = zeros(4,1);
Result = cell(4,1);

%% Run tests
for i = 1:4

    % Set inputs
    assignin('base', 'VehicleSpeed', VehicleSpeed_Test(i));
    assignin('base', 'BrakeRequest', BrakeRequest_Test(i));

        simIn = Simulink.SimulationInput(model);

    simIn = simIn.setVariable('VehicleSpeed', VehicleSpeed_Test(i));
    simIn = simIn.setVariable('BrakeRequest', BrakeRequest_Test(i));

    simOut = sim(simIn);

    % Get model output
    %Actual(i) = simOut.get('BrakePressure');


    % Read logged output
    Actual(i) = simOut.BrakePressure_out.Data(end);

    % Compare expected vs actual
    if abs(Actual(i) - Expected(i)) <= Tolerance
        Result{i} = 'PASS';
    else
        Result{i} = 'FAIL';
    end

end

%% Create report
MIL_Report = table( ...
    TestID, ...
    VehicleSpeed_Test, ...
    BrakeRequest_Test, ...
    Expected, ...
    Actual, ...
    Result);

%% Display report
disp(' ');
disp('========================================');
disp('       BRAKE CONTROLLER MIL REPORT');
disp('========================================');

disp(MIL_Report);

%% Summary
Passed = sum(strcmp(Result, 'PASS'));
Failed = sum(strcmp(Result, 'FAIL'));

fprintf('\nTotal Tests : %d\n', 4);
fprintf('Passed      : %d\n', Passed);
fprintf('Failed      : %d\n', Failed);

if Failed == 0
    fprintf('\nMIL RESULT: ALL TESTS PASSED\n');
else
    fprintf('\nMIL RESULT: TEST FAILURES FOUND\n');
end