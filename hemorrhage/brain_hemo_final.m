close all
inputImage = imread("E:\Acdemics\EBS CBE\21ES603 - Signal & Image Processing\Term Project\archive\NO_validation\26 no.jpg"); % Provide the actual image path

%imagePath = 'E:\Acdemics\EBS CBE\21ES603 - Signal & Image Processing\Term Project\archive\no\17 no.jpg'

%image pre processing
image = imread(imagePath);
image=imresize(inputImage,[512,512])
grayImage = rgb2gray(image);
smoothedImage = imgaussfilt(grayImage, 2); % Gaussian smoothing

edgeImage = edge(smoothedImage, 'Sobel'); % Sobel filter

% Use morphological operations to enhance edges
se = strel('disk', 5);
edgeImage = imdilate(edgeImage, se);

% Thresholding to segment the image
threshold =150; % threshold based on trial and error
segmentedImage = smoothedImage > threshold;


stats = regionprops(segmentedImage, 'Area');%  area of the segmented regions identified with region props


figure;
imshow(inputImage);
title('Original CT Scan Image');

figure;
imshow(segmentedImage);
title('Segmented Image (Hemorrhage Regions)');


% Print the areas of the identified segments
totalArea = 0;
for i = 1:length(stats)
    fprintf('Segment %d Area: %d\n', i, stats(i).Area);
    totalArea = totalArea + stats(i).Area;
end
fprintf('Total Area of all Segments: %d\n', totalArea);

% Use a threshold to determine if there is hemorrhage
areaThreshold = 19000; % Adjust this threshold based on your observations
if any(totalArea> areaThreshold)
    disp('The brain sample has hemorrhage.');
else
    disp('No hemorrhage detected.');
end
