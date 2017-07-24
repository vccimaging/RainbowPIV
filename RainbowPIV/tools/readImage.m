obImg = cell(numFrame,1);

%% change to '../data/twoVortex/twoVortex', '../data/drop/drop', '../data/jet/jet'
%% for the other dataset
directory = '../data/vortex/vortex';
for i=1:numFrame
    ob_img = im2double( imread( [directory num2str(i) '.png' ] ) );
    ob_img = imfilter(ob_img,fspecial('Gaussian',8, 1.2));
    ob_img = downsample(ob_img,8);
    ob_img = downsample( permute(ob_img, [2 1 3] ) ,8 );
    obImg{i} = permute( ob_img,[2 1 3] );
end

% figure;
% imshow( obImg{1}, [], 'init', 'fit' );

H = size(obImg{1},1);
W = size(obImg{1},2);

b = zeros(H*W*3, numFrame);

for i=1:numFrame
    b_1 = reshape(obImg{i}(:,:,1), H*W, 1) ;
    b_2 = reshape(obImg{i}(:,:,2), H*W, 1) ;
    b_3 = reshape(obImg{i}(:,:,3), H*W, 1) ;
    b(:,i) = [b_1; b_2; b_3];
end

clear directory b_1 b_2 b_3 obImg ob_img;
