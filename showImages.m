load('all.mat');
% load('train_set.mat');
% load('train_label.mat');
inter_time = 0.96; % 2 second overall;
record_delay = 0.5;
image_hight = 28;
image_width = 28;
scale_up = 2500;

% init display
fig = figure('Position', [0 0 200 200]); % 76    11   700   700
blank = zeros(28, 28);
PORT = 8997;
HOST = '130.88.198.188';
% dlmwrite('err_msg.mat', error_msg);
error_msg=dlmread('err_msg.mat');
i =  59373;
% for i = 17665 : length(label_list)
while i <= length(label_list)
    i
    % start logging
    label = label_list(i);
    imshow(blank,[0 255],'Border','tight','InitialMagnification',scale_up);
    pause(inter_time);
    MSSG =sprintf('startlogging E:\\MNIST_flash\\%d_%05d', label, i);
    MSSG = int8(MSSG);
    judp('SEND',PORT,HOST,MSSG)
    
    for loop_num = 1 : 5

        % flash on
        pause(inter_time);
        imshow(fliplr( image_list{1, i}),[0 255],'Border','tight','InitialMagnification',scale_up);
        pause(inter_time);
        imshow(blank,[0 255],'Border','tight','InitialMagnification',scale_up);
    end
    
    pause(inter_time);
    imshow(fliplr( image_list{1, i}),[0 255],'Border','tight','InitialMagnification',scale_up);
    pause(1);
    % stop logging
    MSSG = int8('stoplogging');
    judp('SEND',PORT,HOST,MSSG)
    
    pause(inter_time);
    file_label = sprintf('%d_%05d', label, i);
    cutted = cut10(file_label);
    if cutted < 0
        error_msg = [error_msg; cutted, i];
    else
        i = i + 1;
        
    end
end


% for i = 1 : 1%length(label_list)
%     i
%     % start logging
%     label = label_list(i);
%     MSSG =sprintf('startlogging E:\\MNIST_flash\\%d_%s_%05d',  label, 'ON', i);
%     MSSG = int8(MSSG);
%     judp('SEND',PORT,HOST,MSSG)
% %     wait a small wile
% %     pause(record_delay);
%     
%     % flash on
% %     pause(inter_time);
%     imshow(fliplr( image_list{1, i}),[0 255],'Border','tight','InitialMagnification',scale_up);
%     pause(inter_time);
%     
%     % stop logging
%     MSSG = int8('stoplogging');
%     judp('SEND',PORT,HOST,MSSG)
% %     wait a small wile
%     pause(record_delay);
%     
%     % start logging
%     MSSG =sprintf('startlogging E:\\MNIST_flash\\%d_%s_%05d',  label, 'OFF', i);
%     MSSG = int8(MSSG);
%     judp('SEND',PORT,HOST,MSSG)
% %     wait a small wile
% %     pause(record_delay);
%     
%     % flash on
% %     pause(inter_time);
%     imshow(temp,[0 255],'Border','tight','InitialMagnification',scale_up);
%     pause(inter_time);
%     
%     % stop loggin
%     MSSG = int8('stoplogging');
%     judp('SEND',PORT,HOST,MSSG)
%     % wait a small wile
%     pause(record_delay);
% end
