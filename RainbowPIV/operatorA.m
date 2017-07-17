function A_cal = operatorA( x, uv )
    
    s = size( uv(:,:,:,1,1) );
    [H, W, D] = size( uv(:,:,:,1,1) );
    [x1, y1, z1] = meshgrid(1:W,1:H,1:D);

    m = H*W*D;
    numFrame = size( uv, 5 ) + 1;
    A_cal = zeros( m*numFrame, 1 );
       
    x1_tmp = x1+uv(:,:,:,1,1);
    y1_tmp = y1+uv(:,:,:,2,1);
    z1_tmp = z1+uv(:,:,:,3,1);

    % 2*P_1.*(P_1-P_2(phi_2)) + (P_1-P_2(phi_2)).^2
    A_cal(1:m) = 2*x( 1:m ).*( x( 1:m ) - reshape( interp_valid( reshape( x(m+1:2*m), s ), ...
        x1_tmp, y1_tmp, z1_tmp, 'cubic'), m, 1) ) + ...
        ( x( 1:m ) - reshape( interp_valid( reshape( x(m+1:2*m), s ), ...
        x1_tmp, y1_tmp, z1_tmp, 'cubic'), m, 1) ).^2 ;

    for i=2:numFrame-1
       x1_tmp = x1+uv(:,:,:,1,i-1);
       y1_tmp = y1+uv(:,:,:,2,i-1);
       z1_tmp = z1+uv(:,:,:,3,i-1);  
       x2_tmp = x1+uv(:,:,:,1,i);
       y2_tmp = y1+uv(:,:,:,2,i);
       z2_tmp = z1+uv(:,:,:,3,i);
       
        A_cal( (i-1)*m+1:i*m ) = 2*x( (i-2)*m+1:(i-1)*m ).*( reshape( interp_valid( reshape( x( (i-1)*m+1:i*m ), s ), ...
        x1_tmp, y1_tmp, z1_tmp, 'cubic'), m, 1) - x( (i-2)*m+1:(i-1)*m ) ) ...
        + 2*x( (i-1)*m+1:i*m ).*( x( (i-1)*m+1:i*m ) - reshape( interp_valid( reshape( x( i*m+1:(i+1)*m ), s ), ...
        x2_tmp, y2_tmp, z2_tmp, 'cubic'), m, 1) ) + ...
        ( x( (i-1)*m+1:i*m ) - reshape( interp_valid( reshape( x( i*m+1:(i+1)*m ), s ), ...
        x2_tmp, y2_tmp, z2_tmp, 'cubic'), m, 1) ).^2;
       
    end
    x1_tmp = x1+uv(:,:,:,1,numFrame-1);
    y1_tmp = y1+uv(:,:,:,2,numFrame-1);
    z1_tmp = z1+uv(:,:,:,3,numFrame-1); 
    
    A_cal( (numFrame-1)*m+1:numFrame*m ) = 2*x( (numFrame-2)*m+1:(numFrame-1)*m ).* ...
    ( reshape( interp_valid( reshape( x( (numFrame-1)*m+1:numFrame*m ), s ), ...
    x1_tmp, y1_tmp, z1_tmp, 'cubic'), m, 1) - x( (numFrame-2)*m+1:(numFrame-1)*m ) );

end