% System output generation

x = conv(u,lambda,'full');
x_test = conv(u_test,lambda,'full');
x = x(1:N);
x_test = x_test(1:N);

v = mu(x);
v_test = mu(x_test);

w = conv(v,gamma,'full');
w_test = conv(v_test,gamma,'full');
w = w(1:N);
w_test = w_test(1:N);

if isscalar(z_amp)
  z = 2*(rand(N,1)-0.5)*z_amp;
elseif length(z_amp) == 2
  z = zeros(N,1);
  z_test = zeros(N,1);
  z(1:(N/2)) = 2*(rand(N/2,1)-0.5)*z_amp(1);
  z((N/2+1):end) = 2*(rand(N/2,1)-0.5)*z_amp(2);
  z_test(1:(N/2)) = 2*(rand(N/2,1)-0.5)*z_amp(1);
  z_test((N/2+1):end) = 2*(rand(N/2,1)-0.5)*z_amp(2);
end

y = w + z;
y_test = w_test + z_test;

if ShowPlots
  figure(11);
  hold on;
  plot([u x v w y]);
  grid;
  legend('u','x','v','w','y');
  hold off;
end