function visualizePoints( frame, A, thres, dimensions, blue,red,green )

H = dimensions(1);
W = dimensions(2);

frame = reshape( frame, prod(dimensions(1:3)),1 );

ind = find( frame > thres );
[a1, a2, a3] = ind2sub( dimensions(1:3), ind );

figure
subplot(1, 2, 1);
if nargin == 4
    scatter3( a1(:), a2(:), a3(:), 40, frame(ind), 'filled' );
elseif nargin == 7
    scatter3( a1(:), a2(:), a3(:), 20, wavelength2RGB((a3(:)'-1)*200/20+480,blue,red,green), 'filled' );
end
axis([ 0 dimensions(1) 0 dimensions(2) 0 dimensions(3)]);
% caxis([0, max(frame)]);
caxis([0, 1]);
colormap hsv
colorbar

% ob_img = zeros( dimensions(1), dimensions(2), 3 );
% ob_img(:,:,1) = reshape( A{1}*frame, dimensions(1), dimensions(2) );
% ob_img(:,:,2) = reshape( A{2}*frame, dimensions(1), dimensions(2) );
% ob_img(:,:,3) = reshape( A{3}*frame, dimensions(1), dimensions(2) );
ob_img = zeros( dimensions(1), dimensions(2), 3 );
ob_img(:,:,1) = reshape( A(1:H*W,:)*frame, dimensions(1), dimensions(2) );
ob_img(:,:,2) = reshape( A(H*W+1:H*W*2,:)*frame, dimensions(1), dimensions(2) );
ob_img(:,:,3) = reshape( A(H*W*2+1:H*W*3,:)*frame, dimensions(1), dimensions(2) );
subplot(1, 2, 2);
imshow( ob_img, [] );
% set(gca, 'Position', [0.5 0 1 1] );

end