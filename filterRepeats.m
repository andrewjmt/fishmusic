function filtered = filterRepeats(music, distance)
%FILTERREPEATS Clean up abruptly repeated notes.
%   If music contains two notes on the same pitch within distance of each
%   other, only the one with the higher velocity will be retained. Operates
%   greedily from back to front.

filtered = music;
beats = zeros(size(music,1),1);
b = 1;

for i = 1:size(filtered, 1)
    if (filtered(i, 1) == -1)
        b = b+1;
    else
        beats(i)=b;
    end
end

for i = size(filtered, 1):-1:1
    if filtered(i, 1) == -1
        continue;
    end
    rows = find((filtered(:, 1) == filtered(i, 1)) & (filtered(:, 2) >= filtered(i, 2)) & (beats >= beats(i) - distance) & (beats <= beats(i) + distance));
    if numel(rows) > 1
        filtered(i, :) = [];
        beats(i) = [];
    end
end
