function uv = estimateHSflowlayerSequence(frame, uv, kappa3, kappa4, ...
    INNER_ITER, ADMM_ITER, maxwarping, rho, alpha, ratio)

% compute Horn Shunck optical flow
[H, w, D] = size(frame(:,:,:,1));
numFrame  = size(frame, 4);

npixels = H*w*D;
[x, y, z] = meshgrid(1:w,1:H,1:D);

% build differential matrix and Laplacian matrix according to image size
e = ones(npixels, 1);
dy = spdiags([-e e],0:1,npixels,npixels);
dx = spdiags([-e e],[0, H],npixels,npixels);
dz = spdiags([-e e],[0, H*w],npixels,npixels);

dy(H:H:npixels,:) = 0;
for i=1:D
   dx( H*(w*i-1)+1 : 1 : H*w*i, : ) = 0; 
end
dz( H*w*(D-1)+1:1:H*w*D , : ) = 0;
L = dx.'*dx + dy.'*dy + dz.'*dz;

Rp = ichol(L);
Rpt = Rp';

% Kernel to get gradient
h = [1 -8 0 8 -1]/12;

for s=1:INNER_ITER
    fprintf( 'Inner iteration: %d/%d\n', s, INNER_ITER );
    fprintf( 'Frame: ');
for i=1:numFrame-1
    fprintf( '%d ', i);
    Z = zeros(npixels,3);
    Q = zeros(npixels,3);
    deltauv = zeros(npixels,3);
    for k = 1:ADMM_ITER
        for ite = 1:maxwarping
            x1 = x + uv(:,:,:,1,i);
            y1 = y + uv(:,:,:,2,i);
            z1 = z + uv(:,:,:,3,i)/ratio;
            warpimg2 = interp_valid(frame(:,:,:,i+1),x1,y1,z1,'cubic');
            F = spdiags( reshape( frame(:,:,:,i), npixels, 1 ),0,npixels,npixels);
            It = reshape( warpimg2 - frame(:,:,:,i), npixels, 1 );
            Ix = spdiags( reshape( imfilter(warpimg2,h, 'symmetric'), npixels, 1 ),0,npixels,npixels);
            Iy = spdiags( reshape( imfilter(warpimg2,h','symmetric'), npixels, 1 ),0,npixels,npixels);
            Iz_tmp = imfilter( permute( warpimg2, [3 1 2]), h',  'symmetric');
            Iz_tmp = permute( Iz_tmp, [2 3 1] );
            Iz = spdiags( reshape(Iz_tmp,npixels,1 ),0,npixels,npixels);
            
            [A,b] = conParaForLinSys(F, Ix, Iy, Iz, It, uv, Q, Z, dx, dy, dz,...
                Rp, Rpt, L, kappa3, kappa4, rho, npixels, s, i, k, numFrame, ratio );
            
            L1 = ichol(A);
            [deltauv,~] = pcg(A, b, 1e-4, 100, L1, L1');
%             deltauv = L1\(L1'\b);
%             deltauv = pcg(A, b, 1e-6, 100,L1,L1',reshape( deltauv, npixels*3,1) );
            deltauv = reshape( deltauv, size(uv(:,:,:,:,1)) );
            deltauv(deltauv>1) = 1;
            deltauv(deltauv<-1) = -1;
            uv(:,:,:,1:2,i) = uv(:,:,:,1:2,i) + deltauv(:,:,:,1:2);
            uv(:,:,:,3,  i) = uv(:,:,:,3,  i) + deltauv(:,:,:,3)*ratio;
        end
        
        zold = Z;
        x_hat = alpha.* reshape(uv(:,:,:,:,i),npixels,3) + (1 - alpha).*zold;
        
        Z = flowProjection( L, x_hat+Q, dx, dy, dz, Rp, Rpt );
        Q = Q + (x_hat - Z);
        
    end 
    
    uv(:,:,:,:,i) = reshape(Z, size(deltauv) );
    
    %% evaluate
%     x1 = x + uv(:,:,:,1,i);
%     y1 = y + uv(:,:,:,2,i);
%     z1 = z + uv(:,:,:,3,i)/ratio;
%     warpimg2 = interp_valid(frame(:,:,:,i+1),x1,y1,z1,'cubic');
%     F = spdiags( reshape( frame(:,:,:,i), npixels, 1 ),0,npixels,npixels);
%     It = reshape( warpimg2 - frame(:,:,:,i), npixels, 1 );
%     
%     Ix = reshape( imfilter(uv(:,:,:,1,i),h, 'symmetric'), npixels, 1 );
%     Iy = reshape( imfilter(uv(:,:,:,1,i),h','symmetric'), npixels, 1 );
%     Iz = imfilter( permute(uv(:,:,:,1,i), [3 1 2]), h',  'symmetric');
%     Iz = permute( Iz, [2 3 1] );
%     fprintf( 'data fitting: %10.4f, gradient: %10.4f, ', sum(F*(It.^2)), sum(Ix(:).^2+Iy(:).^2+Iz(:).^2)...
%         );
%     
%     if i<=numFrame-2
%         x1 = x + uv(:,:,:,1,i+1);
%         y1 = y + uv(:,:,:,2,i+1);
%         z1 = z + uv(:,:,:,3,i+1)/ratio;
%         
%         warpBackUV = cat(4, interp_valid(uv(:,:,:,1,i+1),x1,y1,z1,'cubic'),...
%             interp_valid(uv(:,:,:,2,i+1),x1,y1,z1,'cubic'), ...
%             interp_valid(uv(:,:,:,3,i+1),x1,y1,z1,'cubic') );
%         warpBackUV = reshape( warpBackUV, npixels, 3 );
%         warpBackUV = flowProjection( warpBackUV, dx, dy, dz, Rp, Rpt );
%         warpBackUV(:,3) = warpBackUV(:,3)./ratio;
%         
%         mask = zeros( H, w, D );
%         mask( 5:end-5, 5:end-5, 3:end-3 ) = 1;
% %         mask = ones( H, w, D );
%         mask = spdiags( reshape(mask,npixels,1), 0, npixels, npixels );
%         
%         fprintf('temporal difference: %10.4f\n', sum( mask*( ( reshape(uv(:,:,:,1,i), npixels, 1) - warpBackUV(:,1) ).^2 +...
%             ( reshape(uv(:,:,:,2,i), npixels, 1) - warpBackUV(:,2) ).^2 +...
%             ( reshape(uv(:,:,:,3,i), npixels, 1)/ratio - warpBackUV(:,3) ).^2 ) ) );
%     end
end  
    fprintf('\n');

end

end
