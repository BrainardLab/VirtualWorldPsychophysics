% Run Sessions for the lightness experiment

% Vijay's order: Chosen as psuedo-random by Vijay
% Session 1 : Condition 1 2 3
% Session 2 : Condition 2 3 1
% Session 2 : Condition 3 1 2

% David's order: First run was Condition 1 chosen by Vijay.
% From then on, random permuations
% Session 1 : Condition 1 2 3
% Session 2 : Condition 3 1 2
% Session 2 : Condition 2 3 1
% 
% Johannes's order: Random permuations
% Session 1 : Condition 2 3 1
% Session 2 : Condition 2 1 3
% Session 2 : Condition 3 2 1
%
% DHB NOTES: 1) Something locked up for a few trials in second acquisition
% (Condition 2) in Session 1.  The stimulus locked up, and then weird
% stuff happened for a few trials, and then things recovered. 2) Similar
% glitches for third acquisition (Condition 3), several distinct times.  3)
% Because of my strabisimus, could not fuse properly, something that got
% worse as the overall session went on. 4) Condition 3 is very hard.

session = 3;
condition = 2;
subjectName = 'Vijay';
nameOfTrialStruct = [subjectName,'Session',num2str(session),'_StdY_0_40_dY_0_01'];

switch condition
    case 1
        directoryName = 'FlatFixedTargetShapeFixedIlluminantFixedBkGnd';
    case 2
        directoryName = 'RandomSameTargetFixedIlluminantFixedBkGnd';
    case 3
        directoryName = 'RandomDifferentTargetFixedIlluminantFixedBkGnd';
end

runLightnessExperiment('directoryName', directoryName,...
    'nameOfTrialStruct', nameOfTrialStruct, ...
    'controlSignal', 'gamePad', ...
    'interval1Key', 'GP:1', ...
    'interval2Key', 'GP:2', ...
    'feedback', 1, ...
    'subjectName', nameOfTrialStruct);

