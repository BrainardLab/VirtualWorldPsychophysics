function deleteTrialStructForFinalExperiment(subjectName,iterationNumber, condition)

% This function deletes trial structs.
%
% Vijay Singh wrote this. Jan 04 2019


nameOfTrialStruct = [subjectName,'_Condition_',condition,'_Iteration_',num2str(iterationNumber)];

switch condition
    case '1'
directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantFixedBkGnd';

    case '2'
directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantBetweentrialBkGndVariation';

case '2a'
directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantBetweentrialBkGndVariationNoReflection';

case '3'
directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantWithintrialBkGndVariation';

case '3a'
directoryName = 'StimuliFixedFlatTargetShapeFixedIlluminantWithintrialBkGndVariationNoReflection';

end

pathToTrialStruct = fullfile(getpref('VirtualWorldPsychophysics','stimulusInputBaseDir'),...
                            directoryName,[nameOfTrialStruct '.mat']);
delete(pathToTrialStruct);


end