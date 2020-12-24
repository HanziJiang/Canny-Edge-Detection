% Reference: https://towardsdatascience.com/canny-edge-detection-step-by-step-in-python-computer-vision-b49c3a2d8123

mycam = webcam;
frames = 30;

for fr=1:frames
    % Capture image.
    I = snapshot(mycam);
    I = rgb2gray(I);
    I = im2double(I);

    % Blur the image using a Gaussian filter.
    I = imgaussfilt(I, 2);
    sizeI = size(I);

    % Find magnitude and orientation of gradient.
    Ix = zeros(sizeI);
    Iy = zeros(sizeI);
    mask_grad_h = [-1, 0, 1; -2, 0, 2; -1, 0, 1]; 
    mask_grad_v = [1, 2, 1; 0, 0, 0; -1, -2, -1];
    for i=2:size(I, 1)-1
        for j=2:size(I, 2)-1
            portion = I(i-1:i+1, j-1:j+1);
            Ix(i, j) = Ix(i, j) + sum(mask_grad_h .* portion, 'all');
            Iy(i, j) = Iy(i, j) + sum(mask_grad_v .* portion, 'all');
        end 
    end 
    strength = sqrt(Iy.^2 + Ix.^2);
    direction = atan2(Iy, Ix);
    direction = direction .* 180 ./ pi;
    direction = mod(direction + 360, 360);

    % Perform non-max supression.
    I_supressed = zeros(sizeI);
    for i=2:sizeI(1, 1)-1
        for j=2:sizeI(1, 2)-1
            if (direction(i, j) >= 0 ) && (direction(i, j) < 22.5) || ...
                    (direction(i, j) >= 157.5) && (direction(i, j) <= 202.5) || ...
                    (direction(i, j) >= 337.5) && (direction(i, j) <= 360)
                a = strength(i, j+1);
                b = strength(i, j-1);
            elseif (direction(i, j) >= 22.5) && (direction(i, j) < 67.5) || ...
                    (direction(i, j) >= 202.5) && (direction(i, j) < 247.5)
                a = strength(i+1, j-1);
                b = strength(i-1, j+1);
            elseif (direction(i, j) >= 67.5 && direction(i, j) < 112.5) || ...
                    (direction(i, j) >= 247.5 && direction(i, j) < 292.5)
                a = strength(i+1, j);
                b = strength(i-1, j);
            elseif (direction(i, j) >= 112.5 && direction(i, j) < 157.5) || ...
                    (direction(i, j) >= 292.5 && direction(i, j) < 337.5)
                a = strength(i-1, j-1);
                b = strength(i+1, j+1);
            end

            if (strength(i, j) >= a) && (strength(i, j) >= b)
                I_supressed(i, j) = strength(i, j);
            else
                I_supressed(i, j) = 0.0;
            end
        end 
    end 

    % Double thresholding.
    final = zeros(sizeI);
    Tau_l = 0.01 * max(I_supressed, [], 'all');
    Tau_h = 0.09 * max(I_supressed, [], 'all');
    for i=1:sizeI(1, 1)
        for j=1:sizeI(1, 2)
            if (I_supressed(i, j) < Tau_l)
                final(i, j) = 0.0;
            elseif (I_supressed(i, j) > Tau_h)
                final(i, j) = 1.0;
            elseif ((I_supressed(i+1, j) > Tau_h) || (I_supressed(i-1, j) > Tau_h) ...
                    || (I_supressed(i, j+1) > Tau_h) || (I_supressed(i, j-1) > Tau_h) ...
                    || (I_supressed(i-1, j-1) > Tau_h) || (I_supressed(i-1, j+1) > Tau_h) ...
                    || (I_supressed(i+1, j+1) > Tau_h) || (I_supressed(i+1, j-1) > Tau_h))
                final(i, j) = 1.0;
            end
        end
    end

    imshow(final);
end
