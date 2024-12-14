% Experiment with many reference points

Settings;
InputGen;
SystemOutput;
DoBootstrap = true; % Choose whether to do experiment with or without bootstrap

%%
ShowPlots = false;
M = 8;
g_est = zeros(R+1,M);
l_est = zeros(S+1,M);
P = 2e5;
N = P*T;

tic
for m=1:M
  bin = dec2bin(m-1,3);
  refPoint = 0.1*[str2double(bin(1)); str2double(bin(2)); str2double(bin(3))];
  if DoBootstrap
    Bootstrap;
  else
    ConvIden;
    LocNonl;
    DeconvIden;
  end
  g_est(:,m) = g_final_notNormalized;
  l_est(:,m) = l_final_notNormalized;
end

g_est(isinf(g_est)) = NaN;
l_est(isinf(l_est)) = NaN;

g_final = sum(g_est,2,'omitnan');
l_final = sum(l_est,2,'omitnan');
g_final = g_final/g_final(1);
l_final = l_final/l_final(1);

ShowPlots = true;
NonlIden;
toc
ModelPrediction;

%%
figure(8);
hold on;
plot(N_all,errorsManyRef,'.--b');
plot(N_all,errorsBootstrap,'.-.g');
plot(N_all,errorsANNlong,'x:k');
ylabel('Noise-free output RMSE','Interpreter','LaTeX');
xlabel('$K$','Interpreter','LaTeX');
xscale('log');
grid();
legend('Kernel-based method, bootstrap, 8 ref. points','Kernel-based method, bootstrap','ANN, longer learning','Location','northeast','Interpreter','Latex');
set(gcf, 'Position', PlotPositionAndSize);
hold off;


