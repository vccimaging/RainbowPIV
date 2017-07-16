function uv = flowProjection( uv_tmp, dx, dy, dz, Rp, Rpt )

     div = dx'*uv_tmp(:,1) + dy'*uv_tmp(:,2) + dz'*uv_tmp(:,3);     
     P = Rp\(Rpt\div);
     uv_tmp(:,1) = uv_tmp(:,1) - dx*P;
     uv_tmp(:,2) = uv_tmp(:,2) - dy*P;
     uv_tmp(:,3) = uv_tmp(:,3) - dz*P;
     uv = uv_tmp;
     
end