function music = data2Music(beat, x, y, velocity, dominant)
%DATA2MUSIC - generate music from input matrix
%   Arguments are vectors of identical length. All but x may be replaced
%   with [].
%   beat - positive integers in ascending order representing the beats on
%   which to play the notes.
%   x - floating point numbers loosely corresponding to pitch class of
%   notes. The higher the range of x, the more dissonant the music will be.
%   A range of -3 to 3 may work well.
%   y - floating point numbers loosely corresponding to register. Again, a
%   range of -3 to 3 may work well.
%   velocity - integers in range -127 to 127 specifying the velocity. The
%   absolute value will set the velocity, and the sign will be used to
%   specify dominant if dominant is not specified.
%   dominant - vector of 0 and 1 or -1 and 1, where a value of 1 indicates
%   that the corresponding note will be drawn from the dominant structure,
%   and otherwise, the note will be drawn from the tonic structure.

if isempty(beat)
    beat=ones(size(x));
end

if isempty(y)
    y=zeros(size(x));
end

if isempty(velocity)
    velocity=zeros(size(x))+100;
end

if isempty(dominant)
    dominant=sign(velocity);
end

velocity=abs(velocity);

music=zeros(length(beat)+max(beat), 2);

i=1;
b=1;
for j=1:length(x)
    while beat(j)>b
        music(i, :)=[-1 -1];
        i=i+1;
        b=b+1;
        continue;
    end
    pitch=getNote(x(j), y(j), dominant(j)>0);
    music(i, :)=[pitch velocity(j)];
    i=i+1;
end
