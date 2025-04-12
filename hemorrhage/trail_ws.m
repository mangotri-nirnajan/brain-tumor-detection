originalImage = imread('E:\Acdemics\EBS CBE\21ES603 - Signal & Image Processing\Term Project\HEMORRHAGE\Hemorrhagic\2_0_69.jpg');  % Replace with your image file

% Preprocessing Techniques
grayImage = rgb2gray(originalImage);
resizedImage = imresize(grayImage, [512, 512]);  % Adjust the size as needed
smoothedImage = imgaussfilt(resizedImage, 2);  % Gaussian smoothing

edges = edge(smoothedImage, 'Sobel');


se = strel('disk', 5);
openedImage = imopen(smoothedImage, se);
distanceTransform = bwdist(~openedImage);
watershedLines = watershed(-distanceTransform); % Image Segmentation using Watershed Algorithm
segmentedResults = label2rgb(watershedLines,'jet','w');


subplot(3, 3, 1), imshow(originalImage), title('Original Image');
subplot(3, 3, 2), imshow(resizedImage), title('Resized Image');
subplot(3, 3, 3), imshow(smoothedImage), title('Smoothed Image');
subplot(3, 3, 4), imshow(edges), title('Edge Detection');
subplot(3, 3, 5), imshow(openedImage), title('Opened Image');
