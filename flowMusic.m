function music = flowMusic(movie, consonance, beatDuration, flow)
%FISH2MUSIC Summary of this function goes here
%   Detailed explanation goes here

obj = VideoReader(movie);

if nargin < 2
    consonance = 20;
end

if nargin < 3
    beatDuration = .25;
end

if nargin < 4
    flow = getOpticalFlow(movie, beatDuration, obj.TotalDuration);
end

hist=zeros(128,8);
magnitude = squeeze(sqrt(flow(:,:,1,:).^2 + flow(:,:,2,:).^2));

flow = flow/max(magnitude(:));

magnitude = squeeze(sqrt(flow(:,:,1,:).^2 + flow(:,:,2,:).^2));

music = zeros(0,2);
for i = 1:size(flow, 4)
    smoothed = medfilt2(magnitude(:,:,i),[5 5]);
    [r,c] = find(smoothed > imdilate(smoothed, [1 1 1; 1 0 1; 1 1 1]));
    pause(.5);
    for j=1:length(r)
        x=c(j);
        y=r(j);
        dominant=flow(:,:,2,i)>0;
        vel=min([round(smoothed(y,x)*1000),127]);
        normX = (x-obj.Width/2)/consonance;
        normY = -(y-obj.Height/2)/(consonance/2);
        pitch = getNoteHorizontal(normX,normY,dominant);
        hold on;
        if (vel>sum(hist(pitch,:)) && vel>10)
            hist(pitch,size(hist,2))=vel;
            music = [music ; pitch vel];
            scatter(normX+rand/10,normY+rand/10);
        end
    end
    music = [music ; -1 -1];
    hist(:,1:(size(hist,2)-1))=hist(:,2:size(hist,2));
    hist(:,size(hist,2))=0;
end
