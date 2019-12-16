%-------------------------------------------------------------------------%
% Copyright (c) 2016 Modenese L.                                          %
%                                                                         %
% Licensed under the Apache License, Version 2.0 (the "License");         %
% you may not use this file except in compliance with the License.        %
% You may obtain a copy of the License at                                 %
% http://www.apache.org/licenses/LICENSE-2.0.                             %
%                                                                         % 
% Unless required by applicable law or agreed to in writing, software     %
% distributed under the License is distributed on an "AS IS" BASIS,       %
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or         %
% implied. See the License for the specific language governing            %
% permissions and limitations under the License.                          %
%                                                                         %
%    Author:   Luca Modenese, May 2016                                    %
%    email:    l.modenese@sheffield.ac.uk                                 % 
% ----------------------------------------------------------------------- %
%
% Fuction that takes as input one character, 'x', 'y' or 'z' and returns
% the corresponding vector (as a row)
%---------------------------
% last modified: 18/05/2016
% Author: Luca Modenese

function v = getAxisVecFromStringLabel(axisLabel)

% TO DO: needs a check on single character

% make it case independent
axisLabel = lower(axisLabel);

switch axisLabel
    case 'x'
        v = [1 0 0];
    case 'y'
        v = [0 1 0];
    case 'z'
        v = [0 0 1];
end

end   