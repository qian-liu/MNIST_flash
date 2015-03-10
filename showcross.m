%load('test_set.mat');
load('train_set.mat');
load('train_label.mat');
inter_time = 0.96; % 2 second overall;
record_delay = 0.5;
image_hight = 450;
image_width = 450;
scale_up = 150;

% init display
input_image = double(rgb2gray(imread('cross2.png')));

fig = figure('Position', [0 0 200 200]); % 76    11   700   700
blank = zeros(image_hight, image_width);
imshow(blank);
% PORT = 8997;
% HOST = '130.88.198.188';
pause(inter_time);
% MSSG =sprintf('startlogging E:\\cross');
% MSSG = int8(MSSG);
% judp('SEND',PORT,HOST,MSSG)

imshow(input_image)

for i = 1:45
    pause(0.05)
    h= imrotate(input_image, i, 'crop');
    imshow(h);
end

pause(inter_time);

for i = 45:90
    pause(0.05)
    h= imrotate(input_image, i, 'crop');
    imshow(h);
end


pause(inter_time);

for i = 90:-1:45
    pause(0.05)
    h= imrotate(input_image, i, 'crop');
    imshow(h);
end

pause(inter_time);

for i = 45:-1:0
    pause(0.05)
    h= imrotate(input_image, i, 'crop');
    imshow(h);
end

pause(inter_time);
imshow(blank);

% MSSG = int8('stoplogging');
% judp('SEND',PORT,HOST,MSSG)