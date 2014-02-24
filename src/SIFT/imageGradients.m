function grd = imageGradients(J,sigma)
% Image gradients at given scale

J = vl_imsmooth(J, sqrt(sigma^2 - 0.5^2));
[Jx, Jy] = vl_grad(J);
mod = sqrt(Jx.^2 + Jy.^2);
ang = atan2(Jy,Jx);
grd = shiftdim(cat(3,mod,ang),2);
grd = single(grd);

end

