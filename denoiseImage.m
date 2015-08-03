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
noiseMag = 0.3;
R = R + noiseMag*rand( size( R) ) - noiseMag/2; % Adds noise to red
G = G + noiseMag*rand( size( G) ) - noiseMag/2; % Adds noise to green
B = B + noiseMag*rand( size( B) ) - noiseMag/2; % Adds noise to blue


[heightr,widthr] = size(R); % Store size of image matrix
[heightg,widthg] = size(G); % Store size of image matrix
[heightb,widthb] = size(B); % Store size of image matrix
denoisedImageRed = zeros(size(R)); % Zero-out final image matrix
denoisedImageGreen = zeros(size(G)); % Zero-out final image matrix
denoisedImageBlue = zeros(size(B)); % Zero-out final image matrix
choice=input('Enter 1 for median, 2 for gaussian, or 3 for mean filtering: '); % Requests user input
kernel=input('Please choose a kernel size: ');
%% Median Filtering
if (choice==1)
    for blocka=idivide(kernel,2):heightr-idivide(kernel,2) % Exclude top/bottom borders
        for blockb=idivide(kernel,2):widthr-idivide(kernel,2) % Exclude side borders
            array = reshape(R(blocka-idivide(kernel,2):blocka+idivide(kernel,2),blockb-idivide(kernel,2):blockb+idivide(kernel,2)),(kernel^2),1); % Reshape matrix into array
            imgmed=median(array); % Find median of array
            denoisedImageRed(blocka,blockb) = imgmed; % Assign median value to given pixel
        end;
        
    end;
    
  for blocka=idivide(kernel,2):heightg-idivide(kernel,2) % Exclude top/bottom borders
        for blockb=idivide(kernel,2):widthg-idivide(kernel,2) % Exclude side borders
            array = reshape(G(blocka-idivide(kernel,2):blocka+idivide(kernel,2),blockb-idivide(kernel,2):blockb+idivide(kernel,2)),(kernel^2),1); % Reshape matrix into array
            imgmed=median(array); % Find median of array
            denoisedImageGreen(blocka,blockb) = imgmed; % Assign median value to given pixel
        end;
        
    end;
    
   for blocka=idivide(kernel,2):heightb-idivide(kernel,2) % Exclude top/bottom borders
        for blockb=idivide(kernel,2):widthb-idivide(kernel,2) % Exclude side borders
            array = reshape(B(blocka-idivide(kernel,2):blocka+idivide(kernel,2),blockb-idivide(kernel,2):blockb+idivide(kernel,2)),(kernel^2),1); % Reshape matrix into array
            imgmed=median(array); % Find median of array
            denoisedImageRed(blocka,blockb) = imgmed; % Assign median value to given pixel
        end;
        
    end;
end;
%% Gaussian Filtering
if (choice==2)
    gauss=fspecial('gaussian',[(kernel^2),(kernel^2)],3); % Create gaussian distribution filter
    denoisedImageRed=imfilter(R,gauss); % Apply filter
    denoisedImageGreen=imfilter(G,gauss); % Apply filter
    denoisedImageBlue=imfilter(B,gauss); % Apply filter
    
end;
%% Mean Filtering
if (choice==3)
    for r=1+kernel:heightr-kernel % Isolates filtering based on kernel (height)
        for c=1+kernel:widthr-kernel % Isolates filtering based on kernel (widht)
            sumr=0;
            for blockr=r-kernel+1:r+kernel-1 % Isolates filtering based on kernel (height)
                for blockc=c-kernel+1:c+kernel-1 % Isolates filtering based on kernel (width)
                    sumr= sumr+ R(blockr,blockc); % Sum up the surrounding pixels
                end;
            end;
            averager=sumr/(kernel^2); % Find the average value of the surrounding pixels
            denoisedImageRed(r,c) = averager; % Assign the average of the surrounding pixels to a given pixel's value
        end;
    end;
    
    for r=1+kernel:heightg-kernel % Isolates filtering based on kernel (height)
        for c=1+kernel:widthg-kernel % Isolates filtering based on kernel (widht)
            sumg=0;
            for blockr=r-kernel+1:r+kernel-1 % Isolates filtering based on kernel (height)
                for blockc=c-kernel+1:c+kernel-1 % Isolates filtering based on kernel (width)
                    sumg= sumg+ G(blockr,blockc); % Sum up the surrounding pixels
                end;
            end;
            averageg=sumg/(kernel^2); % Find the average value of the surrounding pixels
            denoisedImageGreen(r,c) = averageg; % Assign the average of the surrounding pixels to a given pixel's value
        end;
    end;
    
    for r=1+kernel:heightb-kernel % Isolates filtering based on kernel (height)
        for c=1+kernel:widthb-kernel % Isolates filtering based on kernel (widht)
            sumb=0;
            for blockr=r-kernel+1:r+kernel-1 % Isolates filtering based on kernel (height)
                for blockc=c-kernel+1:c+kernel-1 % Isolates filtering based on kernel (width)
                    sumb= sumb+ B(blockr,blockc); % Sum up the surrounding pixels
                end;
            end;
            averageb=sumb/(kernel^2); % Find the average value of the surrounding pixels
            denoisedImageBlue(r,c) = averageb; % Assign the average of the surrounding pixels to a given pixel's value
        end;
    end;
end;
%% Final Image Composition
denoisedImage=cat(3,denoisedImageRed,denoisedImageGreen,denoisedImageBlue);
imshow(denoisedImage); % Display final image
end