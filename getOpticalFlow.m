function flow = getOpticalFlow(movie, beatDuration, totalDuration)
%GETOPTICALFLOW Get optical flow of movie
%   movie - path to video file
%   beatDuration - number of seconds between frames sampled
%   totalDuration - the number of seconds of video to use. Defaults to the
%   length of the movie.

obj = VideoReader(movie);

if nargin < 3
    totalDuration = obj.Duration;
end

if nargin < 2
    beatDuration = .1;
end

times = beatDuration:beatDuration:totalDuration;
flow = zeros(obj.Height,obj.Width,2,length(times));
w=waitbar(0,'Wait...');
oldFrame = obj.read(1);
for j = 1:length(times)
    newFrame = obj.read(round(times(j) * obj.FrameRate));
    flow(:, :, :, j) = estimate_flow_interface(oldFrame(:, :, :, 1), newFrame(:, :, :, 1));
    waitbar(j/length(times),w);
    oldFrame=newFrame;
end
delete(w);
