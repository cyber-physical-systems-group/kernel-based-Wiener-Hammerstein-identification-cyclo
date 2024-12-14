% Experiment with changing number of data


%% Settings
Settings;
ShowPlots = false;
InputGen;
SystemOutput;

P_true = P;
P_all = 10.^[-2 -1 0]*P_true;
N_all = P_all*T;

% Uncomment for other experiment setups
errors = zeros(1,length(P_all));
errorsANN = zeros(1,length(P_all));
% errorsBootstrap = zeros(1,length(P_all));
% errorsANNlong = zeros(1,length(P_all));
% errorsWithoutMk0 = zeros(1,length(P_all));

ExperimentDiffDataPlots = 5; % Numbers of plots to show

%% Kernel-based
for P_Idx = 1:3
  P = P_all(P_Idx);
  N = N_all(P_Idx);
  tic
  ConvIden;
  LocNonl;
  DeconvIden;
  %Bootstrap; % Contains: ConvIden; LocNonl; DeconvIden;
  NonlIden;
  toc
  ModelPrediction;
  errors(P_Idx) = errorKernel;
  %errorsBootstrap(P_Idx) = errorKernel;
  %errorsWithoutMk0(P_Idx) = errorKernel;
end

%% ANN
for P_Idx = 1:3
  P = P_all(P_Idx);
  N = N_all(P_Idx);
  MAIN;
  errorsANN(P_Idx) = errorANN;
  %errorsANNlong(P_Idx) = errorANN;
end

%% Plots
% General plot
if any(ExperimentDiffDataPlots == 4)
  figure(4);
  hold on;
  plot(N_all,errors,'.--b');
  plot(N_all,errorsBootstrap,'.-.g');
  plot(N_all,errorsANN,'+-r');
  plot(N_all,errorsANNlong,'x:k');
  ylabel('Noise-free output RMSE','Interpreter','LaTeX');
  xlabel('$K$','Interpreter','LaTeX');
  xscale('log');
  grid();
  legend('Kernel-based method','Kernel-based method, bootstrap','ANN, the same time','ANN, longer learning','Location','northeast','Interpreter','Latex');
  set(gcf, 'Position', PlotPositionAndSize);
  hold off;
end

% Plot only errors, errorsANN
if any(ExperimentDiffDataPlots == 5)
  figure(5);
  hold on;
  plot(N_all,errors,'.--b');
  plot(N_all,errorsANN,'+-r');
  ylabel('Noise-free output RMSE','Interpreter','LaTeX');
  xlabel('$K$','Interpreter','LaTeX');
  xscale('log');
  grid();
  legend('Kernel-based method','ANN','Location','northeast','Interpreter','LaTeX');
  set(gcf, 'Position', PlotPositionAndSize);
  hold off;
end

% Plot only errorsBootstrap, errorsANNlong
if any(ExperimentDiffDataPlots == 6)
  figure(6);
  hold on;
  plot(N_all,errorsBootstrap,'.-.g');
  plot(N_all,errorsANNlong,'x:k');
  ylabel('Noise-free output RMSE','Interpreter','LaTeX');
  xlabel('$K$','Interpreter','LaTeX');
  xscale('log');
  grid();
  legend('Kernel-based method, bootstrap','ANN, longer learning','Location','northeast','Interpreter','Latex');
  set(gcf, 'Position', PlotPositionAndSize);
  hold off;
end

% Experiment Mk0
if any(ExperimentDiffDataPlots == 7)
  figure(7);
  hold on;
  plot(N_all,errorsWithMk0,'.--b');
  plot(N_all,errorsWithoutMk0,'+-r');
  ylabel('Noise-free output RMSE','Interpreter','LaTeX');
  xlabel('$K$','Interpreter','LaTeX');
  xscale('log');
  grid();
  legend('Kernel-based method','Kernel-based method, without $\widehat{\mathcal{M}}_{k_0}$',...
    'Location','northeast','Interpreter','Latex');
  set(gcf, 'Position', PlotPositionAndSize);
  hold off;
end

