% Christopher Turner, www.christopherturner.io
% SPCS 2015: Computer Engineering
function finalProject()
close all; % Closing all windows, clearing all variables
clear all; %#ok<CLFUN>
disp('Image Denoising - Christopher Turner'); % Display function intro
original = double( imread( 'images/bac.jpg' ) ) / 255; % Retrieves original image
R = original(:,:,1);
G = original(:,:,2);
B = original(:,:,3);
R = R + rand( size( R) ) - 0.5; % Adds noise to grayscale
G = G + rand( size( G) ) - 0.5; % Adds noise to grayscale
B = B + rand( size( B) ) - 0.5; % Adds noise to grayscale

% To use a normal image and add noise:
% original = rgb2gray( original ); % Converts image to grayscale
% original = original + rand( size( original) ) - 0.5; % Adds noise to grayscale


[height,width] = size(original); % Store size of image matrix
denoisedImage = zeros(size(original)); % Zero-out final image matrix
choice=input('Enter 1 for median, 2 for gaussian, or 3 for mean filtering: '); % Requests user input
%% Median Filtering
if (choice==1)
    for blocka=2:height-1 % Exclude top/bottom borders
        for blockb=2:width-1 % Exclude side borders
            array = reshape(original(blocka-1:blocka+1,blockb-1:blockb+1),9,1); % Reshape matrix into array
            imgmed=median(array); % Find median of array
            denoisedImage(blocka,blockb) = imgmed; % Assign median value to given pixel
        end;
        
    end;
end;
%% Gaussian Filtering
if (choice==2)
    gauss=fspecial('gaussian',[9 9],3); % Create gaussian distribution filter
    denoisedImageRed=imfilter(R,gauss); % Apply filter
    denoisedImageGreen=imfilter(G,gauss); % Apply filter
    denoisedImageBlue=imfilter(B,gauss); % Apply filter
    
end;
%% Mean Filtering
if (choice==3)
    kernel=input('Please choose a kernel size: ');
    for r=1+kernel:height-kernel % Isolates filtering based on kernel (height)
        for c=1+kernel:width-kernel % Isolates filtering based on kernel (widht)
            sum=0;
            for blockr=r-kernel+1:r+kernel-1 % Isolates filtering based on kernel (height)
                for blockc=c-kernel+1:c+kernel-1 % Isolates filtering based on kernel (width)
                    sum= sum+ original(blockr,blockc); % Sum up the surrounding pixels
                end;
            end;
            average=sum/(kernel^2); % Find the average value of the surrounding pixels
            denoisedImage(r,c) = average; % Assign the average of the surrounding pixels to a given pixel's value
        end;
    end;
    
end;
%% Final Image Composition
denoisedImage=cat(3,denoisedImageRed,denoisedImageGreen,denoisedImageBlue);
imshow(denoisedImage,[]); % Display final image
end