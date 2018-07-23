clear; close all; clc;
%% setup 
% motion length
motion_len = 5;
% dataset -- 'VOC', 'CamVid', 'SUNRGBD'
dataset = 'VOC';

%% do not change
out_pth = sprintf('/home/dg/Dropbox/Datasets/%s/Degraded_Images/Blur_Motion', dataset);

train_images_pth = sprintf('/home/dg/Dropbox/Datasets/%s/Original_Images/%s_train_images', dataset, dataset);
test_images_pth = sprintf('/home/dg/Dropbox/Datasets/%s/Original_Images/%s_test_images', dataset, dataset);

train_out_folder = fullfile(out_pth, sprintf('degraded_parameter_%d/%s_train_images', motion_len, dataset));
test_out_folder = fullfile(out_pth, sprintf('degraded_parameter_%d/%s_test_images', motion_len, dataset));

if ~exist(train_out_folder, 'dir')
    mkdir(train_out_folder);
end
if ~exist(test_out_folder, 'dir')
    mkdir(test_out_folder);
end
% images files
train_images = dir(fullfile(train_images_pth, '*.jpg'));
if size(train_images,1) == 0
    train_images = dir(fullfile(train_images_pth, '*.png'));
end
test_images = dir(fullfile(test_images_pth, '*.jpg'));
if size(test_images, 1) == 0
    test_images = dir(fullfile(test_images_pth, '*.png'));
end

% Game on
parfor i = 1:size(train_images, 1)
   fprintf('Now: %d/%d\n', i, size(train_images,1));
   I = imread(fullfile(train_images_pth, train_images(i).name));
   random_angle = randi([0,180]);
   H = fspecial('motion',motion_len,random_angle);
   Iblur = imfilter(I, H, 'replicate');
   output_filename = fullfile(train_out_folder, train_images(i).name);
   imwrite(Iblur, output_filename);
end

parfor i = 1:size(test_images, 1)
   fprintf('Now: %d/%d\n', i, size(test_images,1));
   I = imread(fullfile(test_images_pth, test_images(i).name));
   random_angle = randi([0,180]);
   H = fspecial('motion',motion_len,random_angle);
   Iblur = imfilter(I, H, 'replicate');
   output_filename = fullfile(test_out_folder, test_images(i).name);
   imwrite(Iblur, output_filename);
end