A1 = spalloc( H*W, npixels, 25*npixels );
A2 = spalloc( H*W, npixels, 25*npixels );
A3 = spalloc( H*W, npixels, 25*npixels );
ind = 1;

plane = zeros(H, W, 3);
for k=1:D
    t_start = tic;
    disp(['k: ' num2str(k)]);
    for j=1:W
        for i=1:H            
         
            plane_filter = plane;
            [m,n] = size( PSF{k}(:,:,1) );
            plane_x_begin = j-ceil(n/2);
            plane_y_begin = i-ceil(m/2);
            plane_x_end = j-ceil(n/2)+n-1;
            plane_y_end = i-ceil(m/2)+m-1;
            
            filter_x_begin = 1; filter_y_begin = 1;
            filter_x_end = n; filter_y_end = m;
            if plane_x_begin<1
               filter_x_begin = floor(n/2)-plane_x_begin;
               plane_x_begin  = 1;
            end
            if plane_y_begin<1
               filter_y_begin = floor(m/2)-plane_y_begin;
               plane_y_begin  = 1;
            end
            if plane_x_end>W
               filter_x_end = n-(plane_x_end-W);
               plane_x_end  = W;
            end
            if plane_y_end>H
               filter_y_end = m-(plane_y_end-H);
               plane_y_end  = H;
            end
            
            plane_filter( plane_y_begin:plane_y_end,  plane_x_begin:plane_x_end,  : ) ...
                = PSF{k}( filter_y_begin:filter_y_end,filter_x_begin:filter_x_end,: );
            
            [index, ~, value] = find( reshape( plane_filter(:,:,1), W*H, 1 ) );
            A1(index,ind) = value;
            [index, ~, value] = find( reshape( plane_filter(:,:,2), W*H, 1 ) );
            A2(index,ind) = value;
            [index, ~, value] = find( reshape( plane_filter(:,:,3), W*H, 1 ) );
            A3(index,ind) = value;                     
            ind = ind + 1; 
            
        end
    end
    toc(t_start)
end

A = [A1;A2;A3];

clear A1 A2 A3 filter* plane* value m n i j k ind index;