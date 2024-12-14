% Bootstrap
% Prepares set of bootstrap pre-estimates and agregates impulse respones

Folds = 10; % Into how many parts data is divided and how many pre-estimates are obtained
ConvImpKwPreest = zeros(R+S+1,T,Folds);
NumAll = zeros(R+S+1,T,Folds);
DenAll = zeros(R+S+1,T,Folds);
SubsetSize = floor(N/Folds);

h_all = a.*N.^(b);
h = [h_all(1); h_all(2)];

for Subset = 1:Folds
  BeginIdx = 1 + SubsetSize * (Subset-1);
  EndIdx = BeginIdx + SubsetSize - 1;
  [~,NumAll(:,:,Subset),DenAll(:,:,Subset)] = ...
    KW(1:T,P/Folds-1,eps(BeginIdx:EndIdx),y(BeginIdx:EndIdx),S+R,h,T,refPoint);
end

ShowPlotsPrev = ShowPlots;
ShowPlots = false;
DoBootstrapLocNonl = true;
LocNonl;
DoBootstrapLocNonl = false;

% Bootstrap repetitions - use that to control computation time by changing number of repetitions
B = 100; 
if N == 1e4
  B = B*5*3.5;
else
  B = B*2;
end
B = round(B/8); % for experiment with many ref points


g_final_all = NaN(R+1,T,B);
l_final_all = NaN(S+1,T,B);
for b = 1:B
  RandomFolds = randi(Folds,Folds,1);
  nonlNum = zeros(points,T);
  nonlDen = zeros(points,T);
  Num = zeros(R+S+1,T);
  Den = zeros(R+S+1,T);
  for FoldsIdx = 1:Folds
    Num = Num + NumAll(:,:,RandomFolds(FoldsIdx));
    Den = Den + DenAll(:,:,RandomFolds(FoldsIdx));
    nonlNum = nonlNum + nonlBnum(:,:,RandomFolds(FoldsIdx));
    nonlDen = nonlDen + nonlBden(:,:,RandomFolds(FoldsIdx));
  end
  ConvImpKw = Num./Den;
  ck0 = ConvImpKw(1,:).';
  nonl = nonlNum./nonlDen;
  DeconvIden;
  g_final_all(:,k_0_idx,b) = permute(grBest,[1 3 2]);
  l_final_all(:,k_0_idx,b) = permute(lrBest,[1 3 2]);
end

ToVarG = permute(g_final_all(2,1:T,:),[3 2 1]);
varG = var(ToVarG,1,1,'omitnan');
ToVarL = permute(l_final_all(2,1:T,:),[3 2 1]);
varL = var(ToVarL,1,1,'omitnan');

ConvIden;
nonlNum = zeros(points,T);
nonlDen = zeros(points,T);
for FoldsIdx = 1:Folds
  nonlNum = nonlNum + nonlBnum(:,:,FoldsIdx);
  nonlDen = nonlDen + nonlBden(:,:,FoldsIdx);
end
nonl = nonlNum./nonlDen;
DeconvIden;

g_final = zeros(R+1,1);
l_final = zeros(S+1,1);
for k_0_iter = 1:T_red
  k_0 = k_0_idx(k_0_iter);
  g_final = g_final + grBest(:,1,k_0_iter)/varG(k_0);
  l_final = l_final + lrBest(:,1,k_0_iter)/varL(k_0);
end
g_final_notNormalized = g_final;
l_final_notNormalized = l_final;
g_final = g_final / g_final(1);
l_final = l_final / l_final(1);

ShowPlots = ShowPlotsPrev;
DoBootstrapLocNonl = false;