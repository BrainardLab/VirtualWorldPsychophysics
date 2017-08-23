function [theSubstructArray,index] = SubstructArrayFromStructArray(theStructArray,theSubstruct,filterFieldNames,filterFieldVals,booleanStrings)
% [theSubstructArray,index] = SubstructArrayFromStructArray(theStructArray,theSubstruct,filterFieldNames,filterFieldVals,booleanStrings)
%
% Take a struct array as input, and get the index that returns the
% entries after filtering out any values as specified in the filter info.
% Then return the indicated substruct as an array, concatenated together.  Also return the
% filtering index.
%
% See GetFilteringIndex for information on how the filtering is done.
%
% See also FilterAndGetFieldFromStrucArray
%
% This handles cases where each entry of the field is a scalar or a vector,
% and tries to be smart about what to do with row and column vectors.  In
% the latter two cases, these come back as the rows or as the columns of
% the returned matrix, while in the scalar case you get vector back.
%
% Examples:
% 1) Get the decodeBoth structure field as a struct array, taking all of them with no filtering
%   paintShadowEffectDecodeBoth = SubstructArrayFromStructArray(paintShadowEffect,'decodeBoth');
%
% 4/19/16  dhb  Wrote it.

% Deal with optional arguments.
if (nargin < 3)
    filterFieldNames = {};
end
if (nargin < 4)
    filterFieldVals = {};
end
if (nargin < 5)
    booleanStrings = {};
end

% Get the index
index = GetFilteringIndex(theStructArray,filterFieldNames,filterFieldVals,booleanStrings);

% Get size of the field so we can figure out how to pack it for return
eval(['[m,n] = size(theStructArray(1).' theSubstruct ');'])

% In the vector case, we have to make sure all of the individual sessions
% have the same size, and use the min of those sizes so that the matrix
% comes out OK.  This is a little risky in general, but often what we want.
if (n ~= 1 || m ~= 1)
    for ii = 1:length(index)
        theLengthEvalStr = ['theLengths(ii) = length(theStructArray(index(ii)).' theSubstruct ');'];
        eval(theLengthEvalStr);
    end
    minLength = min(theLengths);
end

% Pull out the entries we want.
for ii = 1:length(index) 
    if (m == 1 & n == 1)
        theArrayEvalStr = ['theSubstructArray(ii) = theStructArray(index(ii)).' theSubstruct ';'];
    elseif (n == 1)
        theArrayEvalStr = ['theSubstructArray(:,ii) = theStructArray(index(ii)).' theSubstruct '(1:minLength);'];
    elseif (m == 1)
        theArrayEvalStr = ['theSubstructArray(ii,:) = theStructArray(index(ii)).' theSubstruct '(1:minLength);'];
    else
        error('This routine cannot handle case where individual session data is a matrix rather than scalar or vector');
    end
    eval(theArrayEvalStr);
end

end

