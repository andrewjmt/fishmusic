% Demonstrates generation of music from video of fish

movie = 'lq.mp4';
beatDuration = .2;

% estimate optical flow for first 30 seconds of movie
flow = getOpticalFlow(movie, beatDuration, 30);

videoReader = VideoReader(movie);

% magnitude of optical flow
magnitude = squeeze(sqrt(flow(:,:,1,:).^2 + flow(:,:,2,:).^2));

% normalize optical flow so that max magnitude is 1
flow = flow/max(magnitude(:));

% recalculate magnitude
magnitude = squeeze(sqrt(flow(:,:,1,:).^2 + flow(:,:,2,:).^2));

% data2Music argument vectors
beats = [];
x = [];
y = [];
velocity = [];
dominant = [];

% for every frame of optical flow calculated...
for i = 1:size(flow, 4)
    % produce the smoothed magnitude of the flow (median, 5x5 neighborhood)
    smoothed = medfilt2(magnitude(:,:,i),[5 5]);
    % r, c: row, col indices of local peaks of the magnitude
    [r,c] = find(smoothed > imdilate(smoothed, [1 1 1; 1 0 1; 1 1 1]));
    % for every index...
    for j=1:length(r)
        % linearly scale the peak magnitude to a MIDI velocity
        vel = min([round(smoothed(r(j), c(j)) * 1000), 127]);
        % if this is sufficiently high, add this data point
        if (vel > 5)
            beats = [beats i];
            % add the normalized column to the x vector
            x = [x ((c(j) - 1) / (videoReader.Width - 1) - .5) * 2];
            % add the normalized row to the y vector
            y = [y -((r(j) - 1) / (videoReader.Height - 1) - .5) * 2];
            % dominant reflects the direction of the flow
            dominant = [dominant flow(:,:,1,i)>0];
            % add vel to the velocity vector
            velocity = [velocity vel];
        end
    end
end

% produce a music matrix
music = data2Music(beats, x*2, y*2, velocity, dominant);
% filter out repeated notes due to continuous motion
music = filterRepeats(music, 5);

% play it
play(music, beatDuration, pickMidiReceiver)
