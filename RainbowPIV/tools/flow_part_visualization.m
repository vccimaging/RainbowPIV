function flow_part_visualization( uv, gr_uv, slice )

    min_1 = max( min(min(gr_uv(:,:,slice,1))), min(min(uv(:,:,slice,1))) );
    max_1 = max( max(max(gr_uv(:,:,slice,1))), max(max(uv(:,:,slice,1))) );
    min_2 = max( min(min(gr_uv(:,:,slice,2))), min(min(uv(:,:,slice,2))) );
    max_2 = max( max(max(gr_uv(:,:,slice,2))), max(max(uv(:,:,slice,2))) );
    min_3 = max( min(min(gr_uv(:,:,slice,3))), min(min(uv(:,:,slice,3))) );
    max_3 = max( max(max(gr_uv(:,:,slice,3))), max(max(uv(:,:,slice,3))) );

%     min_1 = -3;
%     max_1 = 1;
%     min_2 = -2;
%     max_2 = 4;
%     min_3 = -1;
%     max_3 = 3;
    figure
    subplot(3,2,1);
    imshow( gr_uv(:,:,slice,1),[min_1 max_1] );
    subplot(3,2,2);
    imshow( uv(:,:,slice,1),[min_1 max_1] );
    subplot(3,2,3);
    imshow( gr_uv(:,:,slice,2),[min_2 max_2] );
    subplot(3,2,4);
    imshow( uv(:,:,slice,2),[min_2 max_2] );
    subplot(3,2,5);
    imshow( gr_uv(:,:,slice,3),[min_3 max_3] );
    subplot(3,2,6);
    imshow( uv(:,:,slice,3),[min_3 max_3] );

end