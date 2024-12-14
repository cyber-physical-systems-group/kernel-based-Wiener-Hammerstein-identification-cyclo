% Model prediction
x_test_est = conv(u_test(1:N),l_final,'full');
x_test_est = x_test_est(1:N);

v_est = Nonparam_f_val(xNonlAllNaNless, nonlAllNaNless, x_test_est);

w_test_est = conv(v_est,g_final,'full');
w_test_est = w_test_est(1:N);

if ShowPlots
  figure(3);
  hold on;
  plot(1,1,'-b');
  plot(w_test(1:200),'-r','LineWidth',2);
  plot(w_test_est(1:200),'-b');
  xlabel('$k$','Interpreter','Latex');
  ylabel('$w_k$','Interpreter','Latex');
  legend('Model prediction','Noise-free system output','Interpreter','Latex');
  set(gcf, 'Position', PlotPositionAndSize);
  grid();
  hold off;
end

errorKernel = rmse(w_test(1:N),w_test_est(1:N))