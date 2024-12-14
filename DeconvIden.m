% Devonvolution of impulse responses

if (S ~= 1) || (R ~= 1)
  error('DeconvIden is not implemented for other [R, S] than [1, 1]!');
end

l = zeros(2,2,T);
g = zeros(2,2,T);
g0 = zeros(2,2,T);
for k_0 = 1:T
  if all(~isnan(ConvImpKw(:,k_0)))
    RootsK0 = roots(ConvImpKw(:,k_0));
  else
    RootsK0 = [-1i 1i]; % Such roots will be ignored anyway
  end
  l(:,:,k_0) = [1 1;-RootsK0(1) -RootsK0(2)];
  g(:,:,k_0) = [1 1;-RootsK0(2) -RootsK0(1)];
  g0(:,:,k_0) = g(:,:,k_0);
  % ck0 elimination
  g(1,:,k_0) = g(1,:,k_0)/ck0(k0FromK(k_0,T));
  g(2,:,k_0) = g(2,:,k_0)/ck0(k0FromK(k_0-1,T));
  % normalization
  g(:,1,k_0) = g(:,1,k_0)/g(1,1,k_0);
  g(:,2,k_0) = g(:,2,k_0)/g(1,2,k_0);
end
% Elimination of complex-valued results
lr = l;
gr = g;
T_red = T;
k_0_idx = 1:T;
if ~isreal(l) || ~isreal(g)
  for k_0 = T:(-1):1
    if ~isreal(l(:,:,k_0)) || ~isreal(g(:,:,k_0))
      lr(:,:,k_0) = [];
      gr(:,:,k_0) = [];
      T_red = T_red - 1;
      k_0_idx(k_0) = [];
    end
  end
end

% NaNless nonl
xNonlNaNless = cell(T,1);
nonlNaNless = cell(T,1);
for k_0 = 1:T
  NotNaNIdx = ~isnan(nonl(:,k_0));
  xNonlNaNless{k_0} = xNonl(NotNaNIdx);
  nonlNaNless{k_0} = nonl(NotNaNIdx,k_0);
end

% Uncomment for test and check nonlinearity without NaNs
%plot(xNonlNaNless{13},nonlNaNless{13});

% MSE estimation
Ntest = N;
yTest = y(1:Ntest);
grBest = zeros(2,1,T_red);
lrBest = zeros(2,1,T_red);
for t_red = 1:T_red
  y_est = zeros(Ntest,2);
  for prop = 1:2
    gLoc = gr(:,prop,t_red);
    lLoc = lr(:,prop,t_red);
    k_0 = k_0_idx(t_red);
    xLoc_est = conv(eps(1:Ntest),lLoc,'full');
    xLoc_est = xLoc_est(1:Ntest);
    for k = 3:Ntest
      y_est(k,prop) = M(k0FromK(k,T)) ...
        + gLoc(1)*Nonparam_f_val(xNonlNaNless{k0FromK(k-1,T)},nonlNaNless{k0FromK(k-1,T)},xLoc_est(k)) ...
        + gLoc(2)*Nonparam_f_val(xNonlNaNless{k0FromK(k-1,T)},nonlNaNless{k0FromK(k-1,T)},xLoc_est(k-1));
      % Uncomment for test with true nonlinearity
      % y_est(k,prop) = gLoc(1)*mu(x_bar(k0FromK(k,T))+xLoc_est(k)) + gLoc(2)*mu(x_bar(k0FromK(k-1,T))+xLoc_est(k-1));
      % y_est(k,prop) = gLoc(1)*mu(xLoc_est(k)) + gLoc(2)*mu(xLoc_est(k-1));
    end
  end
  NotNan1 = ~isnan(y_est(:,1));
  NotNan2 = ~isnan(y_est(:,2));
  NotNanBoth = NotNan1 & NotNan2;
  if rmse(y_est(NotNanBoth,1),yTest(NotNanBoth)) >= rmse(y_est(NotNanBoth,2),yTest(NotNanBoth))
    bestProp = 2;
  else
    bestProp = 1;
  end
  grBest(:,1,t_red) = gr(:,bestProp,t_red);
  lrBest(:,1,t_red) = lr(:,bestProp,t_red);
end
g_final = zeros(2,1);
l_final = zeros(2,1);
for t_red = 1:T_red
  g_final = g_final + grBest(:,1,t_red);
  l_final = l_final + lrBest(:,1,t_red);
end
g_final = g_final / T_red;
l_final = l_final / T_red;

% Plot nonlNanless
PlotAllLocNonl = true; % Show all local nonl. or only these for $k_0$ without NaN after Deconv. 
if ShowPlots
  if PlotAllLocNonl
    k_0_idxPlot = 1:T;
    T_redPlot = T;
  else
    k_0_idxPlot = k_0_idx;
    T_redPlot = T_red;
  end
  figure(1);
  hold on;
  style = ['-b';'-r';'-g';'-k';'-c'];
  for k_0_iter=1:min(T_redPlot,length(style))
    k_0 = k_0_idxPlot(k_0_iter);
    plot(xNonlNaNless{k_0},nonlNaNless{k_0},style(k_0,:));
    plot(xNonlNaNless{k_0},mu(xNonlNaNless{k_0}+x_bar(k_0))-mu(x_bar(k_0)),strcat(':',style(k_0,2)),...
      'LineWidth',1);
  end
  grid;
  xlabel('$\chi$','Interpreter','Latex');
  ylabel('$\widehat{\mu}^{(k_0)}_{\rm{loc}}(\chi)$','Interpreter','Latex');
  legendTiles = {'$k_0=1$';'$k_0=1$ (true)';...
                 '$k_0=2$';'$k_0=2$ (true)';...
                 '$k_0=3$';'$k_0=3$ (true)';...
                 '$k_0=4$';'$k_0=4$ (true)';...
                 '$k_0=5$';'$k_0=5$ (true)'};
  for k_0_iter = 1:T_redPlot
    if all(k_0_idxPlot~=k_0_iter)
      legendTiles((2*k_0_iter-1):(2*k_0_iter)) = [];
    end
  end
  legend(legendTiles(:,:),...
    'Interpreter','Latex','NumColumns',3,'Location','North');
  set(gcf, 'Position', PlotPositionAndSize);
  hold off;
end

% Plot deconvoluted responses
if ShowPlots
  figure(4);
  hold on;
  plot(lambda/lambda(1),'x-b');
  plot(l_final,'.-r');
  plot(gamma/gamma(1),'x-g');
  plot(g_final,'.-k');
  grid;
  xlabel('$i$','Interpreter','Latex');
  ylabel('Impulse response coefficients','Interpreter','Latex');
  title('Impusle response deconvolution','Interpreter','Latex');
  legend('$\lambda_i$ (normalized)','$\widehat{\lambda}_i$','$\gamma_i$ (normalized)',...
    '$\widehat{\gamma}_i$','Interpreter','Latex');
  hold off;
end