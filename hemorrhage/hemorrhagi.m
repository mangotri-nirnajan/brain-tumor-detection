close all;
clear all;
clc;

% Read the CT scan image
image = imread('E:\Acdemics\EBS CBE\21ES603 - Signal & Image Processing\Term Project\HEMORRHAGE\Hemorrhagic\2_0_69.jpg');

image=imresize(image,[512,512])
% Convert the image to grayscale
grayImage = rgb2gray(image);

% Apply a Gaussian filter for smoothing
smoothedImage = imgaussfilt(double(grayImage), 2);

BW1=edge(smoothedImage,'sobel')
figure;
subplot(1, 5, 1);
imshow(BW1, []);
title('Original Image');
% Thresholding based on intensity for brain identification
brainThreshold = 30; % Adjust the intensity threshold based on your specific case
brainMask = smoothedImage > brainThreshold;

l=watershed(brainMask)
subplot(1,5,2)
jp = imfuse(smoothedImage, l, 'falsecolor', 'ColorChannels', [1 2 0]);
imshow(l,[])
% Remove small regions
brainMask = bwareaopen(brainMask, 100);

% Fill holes in the brain mask
brainMask = imfill(brainMask, 'holes');

% Perform morphological operations to refine the brain mask
se = strel('disk', 5);
brainMask = imopen(brainMask, se);
brainMask = imclose(brainMask, se);

% Display the original image and identified brain region
subplot(1, 5, 3);
imshow(image, []);
title('Original Image');

subplot(1, 5, 4);
imshow(brainMask, []);
title('Identified Brain Region');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Apply a region mask to the original image to focus on the brain
brainRegion = bsxfun(@times, image, cast(brainMask, 'like', image));

% Convert the region of interest to grayscale
grayBrainRegion = rgb2gray(brainRegion);

% Thresholding based on intensity for tumor identification
tumorThreshold = 150; % Adjust the intensity threshold based on your specific case
tumorMask = grayBrainRegion > tumorThreshold;

% Remove small regions in the tumor mask
tumorMask = bwareaopen(tumorMask, 50);

% Perform morphological operations to refine the tumor mask
seTumor = strel('disk', 5);
tumorMask = imopen(tumorMask, seTumor);
tumorMask = imclose(tumorMask, seTumor);

subplot(1, 3, 3);
imshow(tumorMask, []);
title('Identified Tumor Region');

% Optionally overlay the tumor region on the original image
overlayedImage = image;
overlayedImage(repmat(tumorMask, [1, 1, 3])) = 255; % Set tumor region to white
figure;
imshow(overlayedImage);
title('Overlay of Identified Tumor on Original Image');
