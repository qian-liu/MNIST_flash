function [cutted ] = cut10(file_label)
%CUT10 Summary of this function goes here
%   Detailed explanation goes here
    file_name = sprintf('/home/liuq/Documents/sharedVM/MNIST_flash/%s.aedat', file_label);
    cin = dat2mat(file_name);
    if isempty(cin)
        cutted = -1;
        return
    else
        cutted = 0;
        frameLen = 30000; 
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


        %Cutting
        if length(peak_label) <= 11
            cutted = -2;
            return
        end
        for i = 1:10
            record_start = max(peak_label(i)-17, 1);
            record_end = min(peak_label(i)+16, maxFrame);
            cut_mat = get_mat(cin, frameLen, record_start, record_end);

            if mod(i,2) == 0
                flash = 'off';
            else
                flash = 'on';
            end
            cutfile_name = sprintf('/home/liuq/Documents/sharedVM/MNIST_cut/%s_%s_%d.aedat', file_label, flash, ceil(i/2));
            mat2dat(cut_mat,  cutfile_name);
    %         display_record(cutfile_name, frameLen/1000000);
        end
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