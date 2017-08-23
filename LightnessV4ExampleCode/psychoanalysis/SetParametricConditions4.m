function [subjectNames,protocolNumbers,protocolNames,conditionStructs] = SetParametricConditions4
% [subjectNames,protocolNumbers,protocolNames,conditionStructs] = SetParametricConditions4
%
% Set up the conditions for analysis of parametericConditions4
%
% 5/12/14  dhb  Pulled out

%% Condition numbering initialize
theBaseConditionNumber = 60;

%% Subject names initialize
subjectNames = {};
theSubjectNumber = 0;

%% Subject AQR
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'aqr'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c61_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c62_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c63_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c64_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c65_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 6;
protocolNames{theSubjectNumber,theConditionNumber} = 'c66_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 7;
protocolNames{theSubjectNumber,theConditionNumber} = 'c67_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 8;
protocolNames{theSubjectNumber,theConditionNumber} = 'c68_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 9;
protocolNames{theSubjectNumber,theConditionNumber} = 'c69_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 10;
protocolNames{theSubjectNumber,theConditionNumber} = 'c70_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 11;
protocolNames{theSubjectNumber,theConditionNumber} = 'c71_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen20_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'c72_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen20_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'c73_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'c74_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'c75_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 16;
protocolNames{theSubjectNumber,theConditionNumber} = 'c76_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 17;
protocolNames{theSubjectNumber,theConditionNumber} = 'c77_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen60_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 18;
protocolNames{theSubjectNumber,theConditionNumber} = 'c78_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen60_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

%% Subject CNJ
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'cnj'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c61_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c62_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c63_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c64_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c65_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 6;
protocolNames{theSubjectNumber,theConditionNumber} = 'c66_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 7;
protocolNames{theSubjectNumber,theConditionNumber} = 'c67_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 8;
protocolNames{theSubjectNumber,theConditionNumber} = 'c68_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 9;
protocolNames{theSubjectNumber,theConditionNumber} = 'c69_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 10;
protocolNames{theSubjectNumber,theConditionNumber} = 'c70_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 11;
protocolNames{theSubjectNumber,theConditionNumber} = 'c71_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen20_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'c72_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen20_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'c73_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'c74_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'c75_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 16;
protocolNames{theSubjectNumber,theConditionNumber} = 'c76_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 17;
protocolNames{theSubjectNumber,theConditionNumber} = 'c77_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen60_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 18;
protocolNames{theSubjectNumber,theConditionNumber} = 'c78_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen60_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

%% Subject EJE
theSubjectNumber = theSubjectNumber+1;
theConditionNumber = theBaseConditionNumber;
subjectNames = {subjectNames{1:end} 'eje'};

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 1;
protocolNames{theSubjectNumber,theConditionNumber} = 'c61_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 2;
protocolNames{theSubjectNumber,theConditionNumber} = 'c62_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 3;
protocolNames{theSubjectNumber,theConditionNumber} =  'c63_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 4;
protocolNames{theSubjectNumber,theConditionNumber} = 'c64_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 5;
protocolNames{theSubjectNumber,theConditionNumber} = 'c65_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 6;
protocolNames{theSubjectNumber,theConditionNumber} = 'c66_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 7;
protocolNames{theSubjectNumber,theConditionNumber} = 'c67_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 8;
protocolNames{theSubjectNumber,theConditionNumber} = 'c68_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen10_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1 2];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 9;
protocolNames{theSubjectNumber,theConditionNumber} = 'c69_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 10;
protocolNames{theSubjectNumber,theConditionNumber} = 'c70_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen40_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [1];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 11;
protocolNames{theSubjectNumber,theConditionNumber} = 'c71_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen20_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 12;
protocolNames{theSubjectNumber,theConditionNumber} = 'c72_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen20_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 13;
protocolNames{theSubjectNumber,theConditionNumber} = 'c73_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 14;
protocolNames{theSubjectNumber,theConditionNumber} = 'c74_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen30_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 15;
protocolNames{theSubjectNumber,theConditionNumber} = 'c75_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 16;
protocolNames{theSubjectNumber,theConditionNumber} = 'c76_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen50_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 17;
protocolNames{theSubjectNumber,theConditionNumber} = 'c77_pnt_rot0_shad4_blk40_cen40_vs_pnt_rot0_shad4_blk40_cen60_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];

theConditionNumber = theConditionNumber + 1;
protocolNumbers{theSubjectNumber,theConditionNumber} = theBaseConditionNumber + 18;
protocolNames{theSubjectNumber,theConditionNumber} = 'c78_pnt_rot0_shad4_blk40_cen40_vs_shd_rot0_shad4_blk40_cen60_t1';
conditionStructs{theSubjectNumber,theConditionNumber,1} = protocolNames{theSubjectNumber,theConditionNumber};
conditionStructs{theSubjectNumber,theConditionNumber,2} = [];
