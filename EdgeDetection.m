mycam = webcam;

frames = 2;

for i = 1:frames
    img = im2double(snapshot(mycam));
    img_cpy = img;
    
    mask_h = [1, 0, -1; 1, 0, -1; 1, 0, -1]; 
    mask_v = [1, 1, 1; 0, 0, 0; -1, -1, -1]; 
    mask_d = [0, -1, -1; 1, 0, -1; 1, 1, 0]; 
    mask_dd = [1, 1, 0; 1, 0, -1; 0, -1, -1]; 
    
    mask_h = flipud(mask_h);  
    mask_h = fliplr(mask_h); 
    mask_h = repmat(mask_h, 1, 1, 3);
    mask_v = flipud(mask_v);  
    mask_v = fliplr(mask_v); 
    mask_v = repmat(mask_v, 1, 1, 3);
    mask_d = flipud(mask_d);  
    mask_d = fliplr(mask_d); 
    mask_d = repmat(mask_d, 1, 1, 3);
    mask_dd = flipud(mask_dd);  
    mask_dd = fliplr(mask_dd); 
    mask_dd = repmat(mask_dd, 1, 1, 3);
    
    for i=2:size(img, 1)-1
        for j=2:size(img, 2)-1
            portion = img_cpy(i-1:i+1, j-1:j+1, :);
            
            masked_h = mask_h .* portion;  
            avg_h = sum(masked_h(:), [1 2]); 
            
            masked_v = mask_v .* portion;  
            avg_v = sum(masked_v(:), [1 2]); 
            
            masked_d = mask_d .* portion;  
            avg_d = sum(masked_d(:), [1 2]); 
            
            masked_dd = mask_dd .* portion;  
            avg_dd = sum(masked_dd(:), [1 2]); 
            
            img(i, j, :) = max([avg_h, avg_v, avg_d, avg_dd]);
        end 
    end 
    
    imagesc(img);
    axis image;
    axis off;
    
end
    