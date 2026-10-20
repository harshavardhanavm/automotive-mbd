%% Cruise Control - Master Test Runner

clear;
clc;
%% Load the parameters 
run('../Parameters/CC_init.m');


%% Model
model = 'Model/CruiseControl_V1';

load_system(model);

fprintf('\n');
fprintf('====================================================\n');
fprintf('        CRUISE CONTROL REGRESSION TEST             \n');
fprintf('====================================================\n');

%% Test cases

TestCases = {
    'TC-001', 0,  20,  0,  30;
    'TC-002', 30,  30,  0,  30;
    'TC-003', 20, 20,  5,  30;
    'TC-004', 20, 20, -5,  30
    };

NumTests = size(TestCases, 1);

%% Preallocate results

Results = cell(NumTests, 8);

%% Execute tests

for i = 1:NumTests

    TestID      = TestCases{i,1};
    V0          = TestCases{i,2};
    Vtarget     = TestCases{i,3};
    RoadGrade   = TestCases{i,4};
    StopTime    = TestCases{i,5};

    fprintf('\nRunning %s...\n', TestID);

    result = run_CruiseControl_Test( ...
        TestID, ...
        V0, ...
        Vtarget, ...
        RoadGrade, ...
        StopTime);

    %% Store results

    Results{i,1} = result.TestID;
    Results{i,2} = result.FinalSpeed;
    Results{i,3} = result.FinalError;
    Results{i,4} = result.SteadyStateErrorMax;
    Results{i,5} = result.MaxThrottle;
    Results{i,6} = result.MaxBrake;
    Results{i,7} = result.RoadGrade;

    if result.Pass
        Results{i,8} = 'PASS';
    else
        Results{i,8} = 'FAIL';
    end

end

%% Create summary table

ResultTable = cell2table(Results, ...
    'VariableNames', { ...
    'TestID', ...
    'FinalSpeed', ...
    'FinalError', ...
    'SteadyStateMaxError', ...
    'MaxThrottle', ...
    'MaxBrake', ...
    'RoadGrade', ...
    'Result'});

%% Count results

PassCount = sum(strcmp(ResultTable.Result, 'PASS'));
FailCount = sum(strcmp(ResultTable.Result, 'FAIL'));

%% Print summary

fprintf('\n');
fprintf('\n====================================================\n');
fprintf('              TEST SUMMARY                          \n');
fprintf('====================================================\n');

disp(ResultTable);

fprintf('----------------------------------------------------\n');
fprintf('Total Tests : %d\n', NumTests);
fprintf('Passed      : %d\n', PassCount);
fprintf('Failed      : %d\n', FailCount);

if FailCount == 0
    fprintf('Overall     : PASS\n');
else
    fprintf('Overall     : FAIL\n');
end

fprintf('====================================================\n');