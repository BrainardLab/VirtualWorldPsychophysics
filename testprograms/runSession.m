% Run Sessions for the lightness experiment

% Vijay's order: Chosen as psuedo-random by Vijay
% Session 1 : Condition 1 2 3
% Session 2 : Condition 2 3 1
% Session 3 : Condition 3 1 2

% David's order: First run was Condition 1 chosen by Vijay.
% From then on, random permuations
% Session 1 : Condition 1 2 3
% Session 2 : Condition 3 1 2
% Session 3 : Condition 2 3 1
% 
% Johannes's order: Random permuations
% Session 1 : Condition 2 3 1
% Session 2 : Condition 2 1 3
% Session 3 : Condition 3 2 1
%
% DHB NOTES, SESSION 1, 11/28/17: 1) Something locked up for a few trials in second acquisition
% (Condition 2) in Session 1.  The stimulus locked up, and then weird
% stuff happened for a few trials, and then things recovered. 2) Similar
% glitches for third acquisition (Condition 3), several distinct times.  3)
% Because of my strabisimus, could not fuse properly, something that got
% worse as the overall session went on. 4) Condition 3 is very hard.
%
% DHB SESSION 2, 11/29/17. 1) Using eye patch today, eliminates diplopia.  2) First
% acquistion ran fine without glitches.  This was Condition 3, which felt
% less hard than ysterday. Still trials where the change in color makes it
% difficult to make the judgment. 2) No experiment glitches in second
% (Condition 1) acquisition.  Typed clear all both before and after this
% second run. 3) Again, no glitches.  As with Condition 3, I sometimes feel
% I can discriminate the two stimuli but not know what the correct sign of
% the repsonse is.  Apparant saturation seems to covary with apparant
% lightness, differently for different stimulus chromaticities.
%
% DHB SESSION 3, 11/30/17. 1) No glitch for first acquisition, Condition 2.
% Still hard. 2) Glitch on second trial of second acquistion.  I contro-C'd
% out, restarted Matlab, and then ran it.  No additonal glitches.
%
% NOTES ON EXP FROM DHB: 1) Are we storing interval information?  There may be
% temporal order effects and we should at least be able to separate the
% data by interval order. 2) Is the ITI too short?  Sometimes I think I am
% experiencing perceptual "bleed through" across the intervals.  3) Do we
% want to run on a black background, or some neutral gray?  After a while I
% begin to see entoptic phenomena on the black background. 4) Is resolution
% of images high enough? 5) A good control for Condition 2 might be to run
% cases like Condition 1, but with different relative spectra from flat.
% That is, same relative spectra throughout the acquistion, but not flat.
% If we did this for a few such choices, we could separate informational
% from uncertainty effects in Condition 2, perhaps. 6) I wonder if we want
% stimuli on for longer.  Color vision is slow relative to luminance
% vision.  And possibly slow ramp on and off. 7) We should understand this
% message that is printed out. "Size of input table (256) does not match
% hardwware gamma table size (1024). Interpolating using nearest neighbors
% - this should make the gamma table act as expected for an 10 bit display"

session = 3;
condition = 1;
subjectName = 'David';
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

