function pitch = getNote(x, y, dominant)
%GETNOTE Maps x, y position into the aligned pitch mesh structure
%   x - floating-point x position, loosely corresponding to pitch class
%   y - floating-point y position, loosely corresponding to register
%   dominant - boolean indicator of which mesh to select
%
%   Pitches are represented as integers. x=y=0, dominant=1, maps to 62.
%
%   Sketch:
%
%   dominant=0            x
%                  -2 -1  0  1  2
%                        ...
%           1  ...   69 72 76 79  ...
%        y  0  ...   57 60 64 67  ...
%          -1  ...   45 48 52 55  ...
%                        ...
%
%   dominant=1            x
%                  -2 -1  0  1  2
%                        ...
%           1  ... 67 71 74 77 81 ...
%        y  0  ... 55 59 62 65 69 ...
%          -1  ... 43 47 50 53 57 ...
%                        ...
%

if dominant
    if x < -1.5
        pitch = getNote(x + 3, 0, dominant) - 10;
    elseif x < -.5
        pitch = 59;
    elseif x < .5
        pitch = 62;
    elseif x < 1.5
        pitch = 65;
    else
        pitch = getNote(x - 3, 0, dominant) + 10;
    end
else
    if x < -1
        pitch = getNote(x + 3, 0, dominant) - 10;
    elseif x < 0
        pitch = 60;
    elseif x < 1
        pitch = 64;
    elseif x < 2
        pitch = 67;
    else
        pitch = getNote(x - 3, 0, dominant) + 10;
    end
end

pitch=pitch+round(y)*12;
