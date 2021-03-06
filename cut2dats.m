function [ cut_count, peak_label ] = cut2dats( file_name, train_or_test, start_index)
%CUT2DATS Summary of this function goes here
%   Detailed explanation goes here
    cin = dat2mat(file_name);
    frameLen = 30000; %30ms
    %dsize = 128;
    %fImage = zeros(dsize, dsize);
    maxFrame=floor(cin(size(cin,1),1)/frameLen);
    cut_count = [];
    for j=1:maxFrame           %  loop to read all frames from each file
        spike_count = count_spikes(cin, j, frameLen);
        cut_count = [cut_count, spike_count];
    end
    

    %Find cut points
    [~,peak_label] = findpeaks(cut_count,'MinPeakDistance',20,'MINPEAKHEIGHT', 200);
    plot(cut_count);
    hold on;
    plot(peak_label, cut_count(peak_label),'g.');
    hold off;
    
    %Labelling
    if strcmp( train_or_test, 'train')
        load('train_label.mat');
    else
        load('test_label.mat');
    end
    
    %Cutting
    for i = 1:size(peak_label,2)
        record_start = max(peak_label(i)-17, 1);
        record_end = min(peak_label(i)+16, maxFrame);
        cut_mat = get_mat(cin, frameLen, record_start, record_end);
        offset = ceil(i/2);
        label = label_list(start_index+offset);
        if mod(i,2) == 0
            flash = 'off';
        else
            flash = 'on';
        end
        mat2dat(cut_mat, sprintf('cuts/1000/cut_%05d_%d_%s.aedat', i, label,flash));
    end
    

    
end

function [spike_count] = count_spikes(cin, frameNum, frameLen)
    frameStart = (frameNum - 1) * frameLen;
    frameEnd = frameNum * frameLen;
    low_index = find(cin(:,1) >= frameStart, 1, 'first');
    high_index = find(cin(:,1) >= frameEnd, 1, 'first');
    spike_count = high_index - low_index;
end

function cut_mat = get_mat(cin, frameLen, low_frame, high_frame)
    start_time = (low_frame - 1) * frameLen;
    end_time = high_frame * frameLen;
    low_index = find(cin(:,1) >= start_time, 1, 'first');
    high_index = find(cin(:,1) >= end_time, 1, 'first') - 1;
    cut_mat = cin(low_index:high_index, :);
    %cut_mat(:,1) = cut_mat(:,1) - cut_mat(1,1) + 1;
end