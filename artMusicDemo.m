% A demonstration of sonification of a piece of art.

image=imread('starrynight.jpg');

% we'll use the original image for visualization
imOriginal=image;
% a downsampled image in hsv space is used for music generation
HSV=rgb2hsv(imresize(image,.05));
music=zeros(0,2);
pitchRange=8;
registerRange=4;
% sweep accross every column of pixels, one beat per column
for c=1:size(HSV,2)
    % for every pixel in the column...
    for r=1:size(HSV,1)
        h=HSV(r,c,1);
        s=HSV(r,c,2);
        v=HSV(r,c,3);
        % if not bright or not colorful, ignore
        if (v<.5||s<.5)
            continue;
        end
        % otherwise, get a note from getNoteHorizontal
        % x param (pitch class) defined by saturation
        % y param (register) defined by position in the column
        % dominant param defined by hue
        pitch=getNote((s-.5)*pitchRange,-((r-1)/(size(HSV,1)-1)-.5)*registerRange,h>.5);
        % velocity defined by value (akin to brightness)
        % add note to music
        music=[music ; pitch round((v-.5)*127*2)];
    end
    % insert beat division (we've covered the whole column)
    music=[music ; -1 -1];
end

% play the music

import javax.sound.midi.*
midiReceiver=pickMidiReceiver;
beatDuration=.8;
note = ShortMessage;
beat = 1;
% dim the image
imOriginal=imOriginal/2;
imHighlighted=imOriginal;
% highlight the first column
imHighlighted(:, 1:round(size(imHighlighted,2)/size(HSV,2)), :) = imHighlighted(:, 1:round(size(imHighlighted,2)/size(HSV,2)), :)*2;
imshow(imHighlighted);
hold on;
tic;
% for each note
for j = 1:size(music, 1)
    % if a beat divider...
    if (music(j, 1) == -1)
        try
            % highlight the next column (but don't draw yet)
            imHighlighted=imOriginal;
            imHighlighted(:, ceil(beat*size(imHighlighted,2)/size(HSV,2)):floor((beat+1)*size(imHighlighted,2)/size(HSV,2)), :) = imHighlighted(:, ceil(beat*size(imHighlighted,2)/size(HSV,2)):floor((beat+1)*size(imHighlighted,2)/size(HSV,2)), :)*2;
        catch
        end
        
        % wait for the duration of the beat
        pause(beat * beatDuration - toc);
        % draw
        imshow(imHighlighted);
        beat = beat + 1;
    else % otherwise, play the note
        note.setMessage(ShortMessage.NOTE_ON, 1,...
            music(j, 1), music(j, 2));
        midiReceiver.send(note, -1);
    end
end
