function uv = estimateHSflow(frame, kappa3, kappa4, INNER_ITER, ADMM_ITER, ...
    maxwarping, rho, s, numFrame, iniRatio)
% estimate the HS flow
t_start = tic;

pyramid_levels  = 3;
smooth_sigma = 0.8;   
f3 = fspecial3('gaussian', 2*round(1.5*smooth_sigma) +1 );
m = prod(s);

ratio = zeros(pyramid_levels, 1);
pyramid_size = zeros( pyramid_levels, 3 );
pyramid = cell(pyramid_levels,1);

% build the first layer image
pyramid_size(1,:) = s;
pyramid{1} = zeros( [pyramid_size(1,:), numFrame] );
for i=1:numFrame
    ratio(i) = iniRatio;
       pyramid{1}( :,:,:,i ) = reshape( frame( (i-1)*m+1:i*m ), s );
       pyramid{1}( :,:,:,i ) = imfilter( pyramid{1}( :,:,:,i ),f3 );
end

% build pyramid
for k=2:pyramid_levels
   
    ratio(k) = ratio(k-1)*0.5;
    pyramid_size(k,:) = pyramid_size(k-1,:).*[0.5 0.5 1]; 
    
    pyramid{k} = zeros( [pyramid_size(k,:), numFrame] );
    for i=1:numFrame
       pyramid{k-1}( :,:,:,i ) = imfilter( pyramid{k-1}( :,:,:,i ),f3 );
       pyramid{k}( :,:,:,i ) = resize( pyramid{k-1}( :,:,:,i ), pyramid_size(k,:) );
    end
end

uv = zeros( [s,3,numFrame-1] );
for levels = pyramid_levels:-1:1
    fprintf('level: %d \n',levels);
    uv_tmp = zeros( [ pyramid_size(levels,:), 3, numFrame-1 ] );
    for i=1:numFrame-1
       uv_tmp(:,:,:,:,i) = resample_flow( uv(:,:,:,:,i), pyramid_size(levels,:) );
    end
    uv = estimateHSflowlayerSequence(pyramid{levels}, uv_tmp, kappa3, kappa4,...
        INNER_ITER, ADMM_ITER, maxwarping, rho, 1, ratio(levels));
end

toc(t_start)

end