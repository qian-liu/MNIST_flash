function [] = display_record( file_name, pause_time)
%DISPLAY_RECORD Summary of this function goes here
%   Detailed explanation goes here
    cin = dat2mat(file_name);
    frameLen = 30000; %30ms
    dsize = 128;
    fImage = zeros(dsize, dsize);
    maxFrame=floor(cin(size(cin,1),1)/frameLen);
    for j=1:maxFrame           %  loop to read all frames from each file
        title(int2str(j));
        fImage=get_frame(cin,j,frameLen);
        imagesc( fImage);
        title(j);
        pause(pause_time);
        
    end
end

function frameImg=get_frame(cin,frameNum,frameLen)
    frameStart = (frameNum - 1) * frameLen;
    frameEnd = frameNum * frameLen;
    low_index = find(cin(:,1) > frameStart, 1, 'first');
    high_index = find(cin(:,1) >= frameEnd, 1, 'first');
    frameImg=zeros(128,128);
    for i = low_index : high_index - 1
        index_y=cin(i,4)+1;
        index_x=cin(i,5)+1;
        frameImg(index_x,index_y)=frameImg(index_x,index_y)+1;
    end
      
end