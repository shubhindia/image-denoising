% Christopher Turner, www.christopherturner.io
% SPCS 2015: Computer Engineering
function denoiseImage()
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
% RGBnoisy=cat(3,R,G,B);
% imshow(RGBnoisy);

% To use a normal image and add noise:
% original = rgb2gray( original ); % Converts image to grayscale
% original = original + rand( size( original) ) - 0.5; % Adds noise to grayscale


[heightr,widthr] = size(R); % Store size of image matrix
[heightg,widthg] = size(G); % Store size of image matrix
[heightb,widthb] = size(B); % Store size of image matrix
denoisedImageRed = zeros(size(R)); % Zero-out final image matrix
denoisedImageGreen = zeros(size(G)); % Zero-out final image matrix
denoisedImageBlue = zeros(size(B)); % Zero-out final image matrix
choice=input('Enter 1 for median, 2 for gaussian, or 3 for mean filtering: '); % Requests user input
kernel=input('Please choose a kernel size: ');
if (mod(kernel,2)==1)
    halfkern=(kernel-1)/2;
else
    halfkern=kernel/2;
end
kernsquare=kernel^2
%% Median Filtering
if (choice==1)
    for blocka=1+halfkern:heightr-halfkern % Exclude top/bottom borders
        for blockb=1+halfkern:widthr-halfkern % Exclude side borders
            array = reshape(R(blocka-halfkern:blocka+halfkern,blockb-halfkern:blockb+halfkern),kernsquare,1); % Reshape matrix into array
            imgmed=median(array); % Find median of array
            denoisedImageRed(blocka,blockb) = imgmed; % Assign median value to given pixel
        end;
        
    end;
    
    for blocka=1+halfkern:heightg-halfkern % Exclude top/bottom borders
        for blockb=1+halfkern:widthg-halfkern % Exclude side borders
            array = reshape(G(blocka-halfkern:blocka+halfkern,blockb-halfkern:blockb+halfkern),kernsquare,1); % Reshape matrix into array
            imgmed=median(array); % Find median of array
            denoisedImageGreen(blocka,blockb) = imgmed; % Assign median value to given pixel
        end;
        
    end;
    
    for blocka=1+halfkern:heightb-halfkern % Exclude top/bottom borders
        for blockb=1+halfkern:widthb-halfkern % Exclude side borders
            array = reshape(B(blocka-halfkern:blocka+halfkern,blockb-halfkern:blockb+halfkern),kernsquare,1); % Reshape matrix into array
            imgmed=median(array); % Find median of array
            denoisedImageBlue(blocka,blockb) = imgmed; % Assign median value to given pixel
        end;
        
    end;
end;
%% Gaussian Filtering
if (choice==2)
    gauss=fspecial('gaussian',[kernel,kernel],3); % Create gaussian distribution filter
    denoisedImageRed=imfilter(R,gauss); % Apply filter
    denoisedImageGreen=imfilter(G,gauss); % Apply filter
    denoisedImageBlue=imfilter(B,gauss); % Apply filter
    
end;
%% Mean Filtering
if (choice==3)
    for r=1+halfkern:heightr-halfkern % Isolates filtering based on kernel (height)
        for c=1+halfkern:widthr-halfkern % Isolates filtering based on kernel (widht)
            sumr=0;
            for blockr=r-halfkern:r+halfkern % Isolates filtering based on kernel (height)
                for blockc=c-halfkern:c+halfkern% Isolates filtering based on kernel (width)
                    sumr= sumr+ R(blockr,blockc); % Sum up the surrounding pixels
                end;
            end;
            averager=sumr/(kernel^2); % Find the average value of the surrounding pixels
            denoisedImageRed(r,c) = averager; % Assign the average of the surrounding pixels to a given pixel's value
        end;
    end;
    
    for r=1+halfkern:heightg-halfkern % Isolates filtering based on kernel (height)
        for c=1+halfkern:widthg-halfkern % Isolates filtering based on kernel (widht)
            sumg=0;
            for blockr=r-halfkern:r+halfkern % Isolates filtering based on kernel (height)
                for blockc=c-halfkern:c+halfkern% Isolates filtering based on kernel (width)
                    sumg= sumg+ G(blockr,blockc); % Sum up the surrounding pixels
                end;
            end;
            averageg=sumg/(kernel^2); % Find the average value of the surrounding pixels
            denoisedImageGreen(r,c) = averageg; % Assign the average of the surrounding pixels to a given pixel's value
        end;
    end;
    
    for r=1+halfkern:heightb-halfkern % Isolates filtering based on kernel (height)
        for c=1+halfkern:widthb-halfkern % Isolates filtering based on kernel (widht)
            sumb=0;
            for blockr=r-halfkern:r+halfkern % Isolates filtering based on kernel (height)
                for blockc=c-halfkern:c+halfkern% Isolates filtering based on kernel (width)
                    sumb= sumb+ B(blockr,blockc); % Sum up the surrounding pixels
                end;
            end;
            averageb=sumb/(kernel^2); % Find the average value of the surrounding pixels
            denoisedImageBlue(r,c) = averageb; % Assign the average of the surrounding pixels to a given pixel's value
        end;
    end;
    %% Final Image Composition
    denoisedImage=cat(3,denoisedImageRed,denoisedImageGreen,denoisedImageBlue);
    imshow(denoisedImage); % Display final image
    imwrite(denoisedImage,'images/output.jpg');
end