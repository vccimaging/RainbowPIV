c = zeros(D,3);
scale = zeros(1,D);
for k=1:D  
     c(k,1) = max( max( PSF{k}(:,:,1) ) );
     c(k,2) = max( max( PSF{k}(:,:,2) ) );
     c(k,3) = max( max( PSF{k}(:,:,3) ) );
end
[value, pos] = max( c(:,1).^2+c(:,2).^2+c(:,3).^2 );
scale(pos) = 1;
for i=pos+1:20
   scale(i) =   ( c(i,1).^2 + c(i,2).^2 + c(i,3).^2 ) ./ ...
    ( c(i,1)*c(i-1,1) + c(i,2)*c(i-1,2) + c(i,3)*c(i-1,3)  )* scale(i-1);
end
for i=pos-1:-1:1
   scale(i) = ( c(i,1).^2 + c(i,2).^2 + c(i,3).^2 ) ./ ...
    ( c(i,1)*c(i+1,1) + c(i,2)*c(i+1,2) + c(i,3)*c(i+1,3) )* scale(i+1);
end

weights = ones( npixels, 1);
for i = 1:size(scale,2)
   weights( ((i-1)*H*W+1):i*H*W ) = scale(i); 
end

clear c i k pos PSF scale value;