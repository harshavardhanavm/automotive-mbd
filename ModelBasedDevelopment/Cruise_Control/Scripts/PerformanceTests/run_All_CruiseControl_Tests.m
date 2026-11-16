
function [Results, Summary] = run_All_CruiseControl_Tests()

% =========================================================
% CRUISE CONTROL - MASTER MIL TEST RUNNER
% =========================================================

model = 'CruiseControl_V1';

% Load Simulink model
load_system(model);

% Load initialization parameters
if exist('CC_init.m', 'file')
    run('CC_init.m');
end

% Get test cases
cases = CC_TestCases();

% Store results in cell array
% This avoids structure assignment errors.
resultList = cell(length(cases), 1);

% ---------------------------------------------------------
% Execute all test cases
% ---------------------------------------------------------

for k = 1:length(cases)

    fprintf('\nRunning %s: %s\n', ...
        cases(k).ID, cases(k).Description);

    try

        resultList{k} = run_CruiseControl_Test(cases(k), model);

    catch ME

        % Record failed simulation
        resultList{k}.ID = cases(k).ID;
        resultList{k}.Description = cases(k).Description;
        resultList{k}.Pass = false;
        resultList{k}.Message = ME.message;
        resultList{k}.FinalMode = NaN;
        resultList{k}.FinalEnable = NaN;
        resultList{k}.FaultDetected = false;

    end

    fprintf('%s\n', resultList{k}.Message);

end

% ---------------------------------------------------------
% Generate report
% ---------------------------------------------------------

Results = struct2table([resultList{:}]);

disp(Results);

Summary.Total = height(Results);
Summary.Passed = sum(Results.Pass);
Summary.Failed = Summary.Total - Summary.Passed;

fprintf('\n================================\n');
fprintf('TOTAL TESTS : %d\n', Summary.Total);
fprintf('PASSED      : %d\n', Summary.Passed);
fprintf('FAILED      : %d\n', Summary.Failed);
fprintf('================================\n');

% Save results
writetable(Results, 'CruiseControl_MIL_Report.csv');

save('CruiseControl_MIL_Report.mat', ...
    'Results', 'Summary');

end
