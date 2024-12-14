% Nonlinearity identification

x_est = conv(u,l_final,'full');
x_est = x_est(1:N);

Inv_filter = tf([1 0],g_final.',1);
v_est = lsim(Inv_filter,y(1:N),1:N);

xRange = 0.1*[-1 1]*26*3;
dx = 0.05;
xNonlAll = xRange(1):dx:xRange(2);
points = length(xNonlAll);
nonlAll = zeros(points,1);

hNonl = a(4)*N^(b(4));
if isscalar(eps_amp) || (eps_amp(1) == eps_amp(2))
  TotalN = N;
else
  TotalN = N/2;
end

for Idx = 1:points
  numerator = 0;
  denominator = 0;
  for k = 3:TotalN
    K_val = K(abs(x_est(k) - xNonlAll(Idx)),hNonl);
    numerator = numerator + K_val*(v_est(k));
    denominator = denominator + K_val;
  end
  nonlAll(Idx) = numerator/denominator;
end

NonlAllNotNaNIdx = ~isnan(nonlAll);
xNonlAllNaNless = xNonlAll(NonlAllNotNaNIdx);
nonlAllNaNless = nonlAll(NonlAllNotNaNIdx);

if ShowPlots
  figure(2);
  hold on;
  plot(0,0,'-b');
  plot(xNonlAll,mu(xNonlAll),'-r','LineWidth',2);
  plot(xNonlAll,nonlAll,'-b');
  grid;
  xlabel('$x$','Interpreter','latex');
  ylabel('$\widehat{\mu}(x)$','Interpreter','latex');
  legend('Identified nonlinerity','True nonlinearity', 'Interpreter','latex');
  set(gcf, 'Position', PlotPositionAndSize);
  hold off;
end
