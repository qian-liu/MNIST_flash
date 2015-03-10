function [  ] = cut2dats2( file_name, train_or_test, start_index)
%   Detailed explanation goes here
    cin = dat2mat(file_name);
    frameLen = 30000; %30ms
%     maxFrame=floor(cin(size(cin,1),1)/frameLen);

    spikes_per_trunk = 50000;

    start_stamp = 1;
    end_stamp = spikes_per_trunk;
    start_frame = 1;
    cuts_num = 0;
    trunk_num = 0;
    
    if strcmp( train_or_test, 'train')
        load('train_label.mat');
    else
        load('test_label.mat');
    end
    
    while (start_stamp + spikes_per_trunk - 1 - size(cin,1)) < 0.9 * spikes_per_trunk 
        trunk_num = trunk_num + 1;
        cut_count = [];
        current_cin = cin(start_stamp:end_stamp, :);
        maxFrame=floor(current_cin(size(current_cin,1),1)/frameLen);
        for j = start_frame:maxFrame           %  loop to read all frames from each file
            spike_count = count_spikes(current_cin, j, frameLen);
            cut_count = [cut_count, spike_count];
        end
        [cuts_num, start_frame, start_stamp] = cut_trunk(current_cin, cut_count, start_stamp, start_frame, cuts_num, frameLen, start_index);
        sprintf('trunk_num = %d, cut_count = %d',trunk_num , cuts_num)
        end_stamp = min(start_stamp + spikes_per_trunk - 1, size(cin,1));
    end

end


function [cuts_num, start_frame, start_stamp] = cut_trunk(cin, cut_count, pre_stamp, pre_frame, pre_cuts, frameLen,  start_index)
    
    global   label_list
    [~,peak_frame] = findpeaks(cut_count,'MinPeakDistance',30,'MINPEAKHEIGHT', 200);
    %Cutting
    plot(cut_count);
    hold on;
    plot(peak_frame, cut_count(peak_frame),'g.');
    hold off;
    
    maxFrame = size(cut_count, 2);
    for i = 1:size(peak_frame,2)-1
        record_start = max(peak_frame(i)-frameLen/2000, 1);
        record_end = min(peak_frame(i)+frameLen/2000, maxFrame);
        cut_mat = get_mat(cin, frameLen, record_start, record_end);
        offset = ceil((i + pre_cuts)/2);
        label = label_list(start_index+offset);
        if mod(i,2) == 0
            flash = 'off';
        else
            flash = 'on';
        end
        mat2dat(cut_mat, sprintf('cuts/1000/cut_%05d_%d_%s.aedat', i+pre_cuts, label,flash));
    end
    last_peak = size(peak_frame,2);
    if peak_frame(last_peak)+frameLen/2000 > maxFrame
        cuts_num = size(peak_frame,2)-1;
        start_frame = max(peak_frame(last_peak)-frameLen/2000, 1);

    else
        record_start = max(peak_frame(last_peak)-frameLen/2000, 1);
        record_end = min(peak_frame(last_peak)+frameLen/2000, maxFrame);
        cut_mat = get_mat(cin, frameLen, record_start, record_end);
        cuts_num = size(peak_frame,2);
        start_frame = peak_frame(last_peak)+frameLen/2000 + 1;
        offset = ceil((last_peak + pre_cuts)/2);
        label = label_list(start_index+offset);
        if mod(i,2) == 0
            flash = 'off';
        else
            flash = 'on';
        end
        mat2dat(cut_mat, sprintf('cuts/1000/cut_%05d_%d_%s.aedat', last_peak+pre_cuts, label,flash));
    end
    start_frame = pre_frame + start_frame - 1;
    start_time = (start_frame - 1) * frameLen;
    start_stamp = find(cin(:,1) > start_time, 1, 'first') + pre_stamp - 1;
    cuts_num = cuts_num + pre_cuts;
    
%     sprintf('start_frame = %d, start_time/frameLen = %f, max_frame = %d', start_frame, cin(find(cin(:,1) > start_time, 1, 'first') ,1)/frameLen, maxFrame)
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