%%testMakeTrialStruct test script for makeTrialStruct function

makeTrialStruct('directoryName','FixedTargetShapeFixedIlluminantFixedBkGnd',...
    'LMSstructName', 'LMSStruct',...
    'outputFileName', 'exampleTrial',...
    'nTrials', 10,...
    'stdY', 5, ...
    'cmpY', (1:10));