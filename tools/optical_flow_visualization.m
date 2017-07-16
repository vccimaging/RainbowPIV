function col_img = optical_flow_visualization(Fx, Fy, Fz, max_o)

col_img = zeros(size(Fx));

% phase = atan2(Fy,Fx);
% phase = atan2( Fz, sqrt( Fx.^2 + Fy.^2 ) );
% [azimuth,elevation,r] = cart2sph(Fx, Fy, Fz);
[azimuth,elevation,r] = cart2pol(Fx, Fy, Fz);

if nargin<=3
    azimuth = azimuth - min(azimuth(:));
    elevation = elevation - min(elevation(:));

    col_img(:,:,1) = azimuth./max(azimuth(:));
    col_img(:,:,2) = elevation./max(elevation(:));
    col_img(:,:,3) = r./max(r(:));
    figure     
    imshow(hsv2rgb(col_img),[],'init','fit');        
    colormap(hsv);
else
    azimuth = azimuth - min(azimuth(:));
    elevation = elevation - min(elevation(:));

    col_img(:,:,1) = azimuth./max(azimuth(:));
    col_img(:,:,2) = elevation./max(elevation(:));
    col_img(:,:,3) = r./max_o;
    figure     
    imshow(hsv2rgb(col_img),[],'init','fit');       
    colormap(hsv);
end