function [subjectNames,protocolNumbers,protocolNames,conditionStructs] = SetParametricConditions2
% [subjectNames,protocolNumbers,protocolNames,conditionStructs] = SetParametricConditions2
%
% Set up the conditions for analysis of parametericConditions2
%
% 5/12/14  dhb  Pulled out

%% Condition numbering initialize
theBaseConditionNumber = 30;

%% Subject names initialize
subjectNames = {};
theSubjectNumber = 0;

%% Subject AQR
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'aqr'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c31_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c32_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c33_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c34_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c35_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen100_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 6;
protocolNames{theSubjectNumber,theConditionNumber} = 'c36_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen100_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];
theConditionNumber = theConditionNumber + 1;

protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 7;
protocolNames{theSubjectNumber,theConditionNumber} = 'c37_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 8;
protocolNames{theSubjectNumber,theConditionNumber} = 'c38_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 9;
protocolNames{theSubjectNumber,theConditionNumber} = 'c39_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk60_cen27_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 10;
protocolNames{theSubjectNumber,theConditionNumber} = 'c40_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk60_cen27_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 11;
protocolNames{theSubjectNumber,theConditionNumber} = 'c41_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk60_cen33_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'c42_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk60_cen33_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'c43_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'c44_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'c45_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t2';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 16;
protocolNames{theSubjectNumber,theConditionNumber} = 'c46_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t2';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 17;
protocolNames{theSubjectNumber,theConditionNumber} = 'c47_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t3';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 18;
protocolNames{theSubjectNumber,theConditionNumber} = 'c48_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t3';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

%% Subject BAF

theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'baf'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c31_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c32_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c33_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c34_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c35_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen100_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 6;
protocolNames{theSubjectNumber,theConditionNumber} = 'c36_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen100_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];
theConditionNumber = theConditionNumber + 1;

protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 7;
protocolNames{theSubjectNumber,theConditionNumber} = 'c37_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 8;
protocolNames{theSubjectNumber,theConditionNumber} = 'c38_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 9;
protocolNames{theSubjectNumber,theConditionNumber} = 'c39_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk60_cen27_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 10;
protocolNames{theSubjectNumber,theConditionNumber} = 'c40_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk60_cen27_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 11;
protocolNames{theSubjectNumber,theConditionNumber} = 'c41_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk60_cen33_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'c42_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk60_cen33_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'c43_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'c44_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'c45_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t2';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 16;
protocolNames{theSubjectNumber,theConditionNumber} = 'c46_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t2';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 17;
protocolNames{theSubjectNumber,theConditionNumber} = 'c47_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t3';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 18;
protocolNames{theSubjectNumber,theConditionNumber} = 'c48_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t3';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];


%% Subject CNJ

theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'cnj'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c31_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c32_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c33_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c34_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c35_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen100_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 6;
protocolNames{theSubjectNumber,theConditionNumber} = 'c36_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen100_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];
theConditionNumber = theConditionNumber + 1;

protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 7;
protocolNames{theSubjectNumber,theConditionNumber} = 'c37_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 8;
protocolNames{theSubjectNumber,theConditionNumber} = 'c38_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 9;
protocolNames{theSubjectNumber,theConditionNumber} = 'c39_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk60_cen27_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 10;
protocolNames{theSubjectNumber,theConditionNumber} = 'c40_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk60_cen27_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 11;
protocolNames{theSubjectNumber,theConditionNumber} = 'c41_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk60_cen33_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'c42_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk60_cen33_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'c43_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'c44_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'c45_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t2';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 16;
protocolNames{theSubjectNumber,theConditionNumber} = 'c46_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t2';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 17;
protocolNames{theSubjectNumber,theConditionNumber} = 'c47_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk20_cen80_t3';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 18;
protocolNames{theSubjectNumber,theConditionNumber} = 'c48_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk20_cen80_t3';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];