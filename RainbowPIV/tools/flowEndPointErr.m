function EPE = flowEndPointErr( gr_u, gr_v, gr_w, u, v, w, bord )
    stu=gr_u(bord+1:end-bord,bord+1:end-bord,bord+1:end-bord);
    stv=gr_v(bord+1:end-bord,bord+1:end-bord,bord+1:end-bord);
    stw=gr_w(bord+1:end-bord,bord+1:end-bord,bord+1:end-bord);
    su=u(bord+1:end-bord,bord+1:end-bord,bord+1:end-bord);
    sv=v(bord+1:end-bord,bord+1:end-bord,bord+1:end-bord);
    sw=w(bord+1:end-bord,bord+1:end-bord,bord+1:end-bord);
    
    SSE = (stu-su).^2 + (stv-sv).^2 + (stw-sw).^2;
    EPE = sum( sqrt(SSE(:)) ) / numel(SSE) ;
end