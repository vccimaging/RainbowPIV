function warpimg = interp_valid( frame, x1, y1, z1, interp_mode,  x, y, z)
    
    if nargin == 5
        warpimg = interp3(frame,x1,y1,z1,interp_mode);
    else
        warpimg = interp3(x, y, z, frame,x1,y1,z1,interp_mode);
    end
    warpimg(isnan(warpimg)) = 0;

end