
% =========================================================
% AUTOMATED CRUISE CONTROL PERFORMANCE TEST RUNNER
% TC-001 to TC-005
% =========================================================

clear;
clc;

fprintf('\n');
fprintf('============================================\n');
fprintf('   CRUISE CONTROL PERFORMANCE TEST SUITE    \n');
fprintf('============================================\n');

% ---------------------------------------------------------
% 1. Identify project folders
% ---------------------------------------------------------

thisFolder = fileparts(mfilename('fullpath'));

% This assumes the script is in Tests/Performance
projectRoot = fileparts(fileparts(thisFolder));

addpath(genpath(projectRoot));

% ---------------------------------------------------------
% 2. Initialize project parameters
% ---------------------------------------------------------

initFile = fullfile(projectRoot, ...
    'Parameters', 'CC_init.m');

if ~isfile(initFile)
    error('CC_init.m not found: %s', initFile);
end

run(initFile);

% ---------------------------------------------------------
% 3. Load Simulink model
% ---------------------------------------------------------

modelFile = fullfile(projectRoot, ...
    'Model', 'CruiseControl_V1.slx');

if ~isfile(modelFile)
    error('CruiseControl_V1.slx not found: %s', modelFile);
end

load_system(modelFile);

model = 'CruiseControl_V1';

% ---------------------------------------------------------
% 4. Load test cases
% ---------------------------------------------------------

TestCases = TC_TestCases();

NumberOfTests = length(TestCases);

fprintf('\nTotal Performance Test Cases: %d\n', NumberOfTests);

% ---------------------------------------------------------
% 5. Execute all test cases
% ---------------------------------------------------------

for k = 1:NumberOfTests

    fprintf('\n\nExecuting Test %d of %d\n', ...
        k, NumberOfTests);

    result = run_TC_Test(TestCases(k), model);

    if k == 1
        Results = result;
    else
        Results(k) = result;
    end

end

% ---------------------------------------------------------
% 6. Generate summary
% ---------------------------------------------------------

PassedTests = sum([Results.Pass]);
FailedTests = NumberOfTests - PassedTests;

PassPercentage = ...
    (PassedTests / NumberOfTests) * 100;

fprintf('\n\n');
fprintf('============================================\n');
fprintf('       PERFORMANCE TEST SUMMARY             \n');
fprintf('============================================\n');

fprintf('Total Tests       : %d\n', NumberOfTests);
fprintf('Passed Tests      : %d\n', PassedTests);
fprintf('Failed Tests      : %d\n', FailedTests);
fprintf('Pass Percentage   : %.2f %%\n', PassPercentage);

fprintf('============================================\n');

% ---------------------------------------------------------
% 7. Create results table
% ---------------------------------------------------------

ResultsTable = struct2table(Results);

disp(ResultsTable);

% ---------------------------------------------------------
% 8. Save result files
% ---------------------------------------------------------

resultsFolder = fullfile(projectRoot, ...
    'results', 'Performance');

if ~exist(resultsFolder, 'dir')
    mkdir(resultsFolder);
end

% Save CSV
csvFile = fullfile(resultsFolder, ...
    'CruiseControl_Performance_Results.csv');

writetable(ResultsTable, csvFile);

% Save MATLAB data
matFile = fullfile(resultsFolder, ...
    'CruiseControl_Performance_Results.mat');

Summary.TotalTests = NumberOfTests;
Summary.PassedTests = PassedTests;
Summary.FailedTests = FailedTests;
Summary.PassPercentage = PassPercentage;

save(matFile, 'Results', 'ResultsTable', ...
    'Summary', 'TestCases');

fprintf('\nResults saved successfully:\n');
fprintf('%s\n', csvFile);
fprintf('%s\n', matFile);

% ---------------------------------------------------------
% 9. Close model
% ---------------------------------------------------------

close_system(model, 0);

fprintf('\nPerformance test execution completed.\n');
