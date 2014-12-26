function play(music, beatDuration, midiReceiver)
%PLAY Play a matrix of notes.
%   music - a nx3 matrix where every row specifies [pitch velocity channel]
%   and the division between beats is indicated by a row beginning with -1.
%   Every note will be played exactly on the beat. The channel column, or
%   both the velocity and the channel column, may be omitted.
%   beatDuration - the duration of a beat, in seconds.
%   midiReceiver - a midi output object returned by pickMidiReceiver. If
%   omitted, the user will be prompted to pick an output device.

if (nargin < 3)
    midiReceiver = pickMidiReceiver;
end

if (size(music, 2) == 1)
    music = [music, zeros(size(music, 1), 1) + 100];
end

if (size(music, 2) == 2)
    music = [music, zeros(size(music, 1), 1)];
end

import javax.sound.midi.*
note = ShortMessage;
beat = 1;

tic;
for j = 1:size(music, 1)
    if (music(j, 1) == -1)
        pause(beat * beatDuration - toc);
        beat = beat + 1;
    else
        note.setMessage(ShortMessage.NOTE_ON, music(j, 3),...
            music(j, 1), music(j, 2));
        midiReceiver.send(note, -1);
    end
end
