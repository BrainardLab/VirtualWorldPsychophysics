function [subjectNames,protocolNumbers,protocolNames,conditionStructs] = SetParametricConditions3
% [subjectNames,protocolNumbers,protocolNames,conditionStructs] = SetParametricConditions3
%
% Set up the conditions for analysis of parametericConditions3
%
% 5/12/14  dhb  Pulled out

%% Condition numbering initialize
theBaseConditionNumber = 50;

%% Subject names initialize
subjectNames = {};
theSubjectNumber = 0;

%% Subject DHB
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'dhb'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c51_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c52_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c53_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 ];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c54_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c55_shd_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

%% Subject AQR
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'aqr'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c51_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c52_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c53_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c54_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c55_shd_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

%% Subject CNJ
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'cnj'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c51_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c52_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c53_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c54_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c55_shd_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

%% Subject EJE
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'eje'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c51_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [3 4];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c52_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c53_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c54_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c55_shd_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];
