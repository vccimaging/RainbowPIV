addpath('tools');
load PSF.mat;

%% number of frames processed simultaneously (memory size matters)
numFrame = 2;
readImage();

D=20; npixels = H*W*D;

%% construct matrix A and vector w
constructMatrixA();
constructWeights();

%% initialize parameters
ratio = 8;          % ratio of voxel pitch in z axis to x-y plane
maxwarping = 10;    % number of iteration steps for non-linear warping
OUT_ITER = 2;       % outer iterations for the whole joint problem
INNER_ITER = 2;     % inner iterations for velocity estimation
ADMM_ITER = 5;      % ADMM iterations for pressure projection

kappa1 = repmat( weights, numFrame, 1 ).*0.01;
kappa2 = 0.01;
kappa3 = 1e-5; 
kappa4 = 1e-7; 
rho = 1; 

uv = zeros( [H, W, D, 3, numFrame-1] );

for i=1:OUT_ITER
    fprintf('Estimate position:\n');
    if i==1
        frame = estimatePosition( A, b, numFrame, uv, kappa1, 0, 1, 1.8 );
    else        
        frame = estimatePosition( A, b, numFrame, uv, kappa1, kappa2, 1, 1.8 );
    end
    
    fprintf('Estimate flow velocity:\n');
    frame( find(frame<0.01) ) = 0;
    uv = estimateHSflow( frame, kappa3, kappa4, INNER_ITER, ADMM_ITER, ...
        maxwarping, rho, [H,W,D], numFrame, ratio );
    uv(:,:,:,3,:) = uv(:,:,:,3,:)/ratio;
   
end

uv = permute( uv, [3 2 1 4 5]);
plotFlow3(W, D, H, -uv(1:D,1:W,1:H,1,1), -uv(1:D,1:W,1:H,3,1)*ratio,...
    -uv(1:D,1:W,1:H,2,1), [20 4 20], 2);
