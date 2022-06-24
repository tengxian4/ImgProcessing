clear all, close all, clc

exposure=60;
maxAmount_gamma =20; % the program will try the gamma value by increasing 0.5 each time from 0 to 20

I = imread('normal.jpg');
I =im2gray(I); %turn into greyscale image

% usually scanned document will have the problem of blur 
blur = imgaussfilt(I,1);
% usually scanned document will have the problem of overexposed due to lighting problem 
distortedImage=blur +exposure;
% scanned document also will have little noise
distortedImage=imnoise(distortedImage,'salt & pepper',0.01);

% plot all the result in one window
figure
subplot(2,3,1), imshow(distortedImage),title('Distorted Image');
%% adjust the contrast due to lighting problem - Khaw Teng Xian
std_dv = findGamma(distortedImage, maxAmount_gamma); % call the user-defined function 

% if the std deviation between the current and the previous enhanced image 
% did not different more than 0.5, then take the previous gamma value as
% the optimal gamma value
for g= 2:1:2*maxAmount_gamma+1
    diff=std_dv(g,2)-std_dv(g-1,2) %minus the current standard deviation with the previous standard deviation
    if diff <0.5   % if difference less than 0.5, then the previous gamma value is the best gamma
        best_gamma=std_dv(g-1,1) %it will display the best gamma
        break
    end 
end
 

adjustedImage = imadjust(distortedImage,[],[],best_gamma); % do gamma transformation on the distorted image with the best gamma value
subplot(2,3,2), imshow(adjustedImage), title('Gamma Transformation');
%% remove noise using median filtering with the filter size is 3x3 - Reca Seng
m=3;
removedNoise = medfilt2(adjustedImage,[m m]); 
subplot(2,3,3),imshow(removedNoise),title('Noise Removal');





%% Sharpening the image using unsharp masking method - Lim Wen Ni
sharpen_image=imsharpen(removedNoise);
subplot(2,3,4),imshow(sharpen_image),title('Sharpen Image');

%% Plot the graph of Standard deviation versus Gamma Value for every transformation using
% different gamma value

subplot(2,3,5),plot( std_dv(1:end,1),std_dv(1:end,2)),title('Standard Deviation vs Gamma Value');



%% to find the optimal gamma value using graph
for v= 2:1:2*maxAmount_gamma+1
   
    if v==2
    diff_with_previous=[std_dv(v,2)-std_dv(v-1,2)]; % if it is the first element in the array, then need to start with the following
    else
    diff_with_previous=[diff_with_previous,std_dv(v,2)-std_dv(v-1,2)];  % add element into the array 
    end
end

subplot(2,3,6),plot( std_dv(1:end-1,1),diff_with_previous),title('Diff vs Gamma Value');
yline(0.5,'-'); % add line at y=0.5 for finding the best gamma value easily
ylim([0 5]);