% Local nonlinearities identification

alpha = zeros(S+R+1,1);
alpha(1) = 1;

xRange = 2*0.1*[-1 1]*12;
dx = 0.05;
xNonl = xRange(1):dx:xRange(2);
points = length(xNonl);

hNonl = a(3)*N^(b(3));
refPoint = zeros(R+S+1,1); % The best estimate is for the biggest density
M = M_est(1:T,P-1,eps(1:N),y(1:N),R+S,hNonl,T,refPoint);
refPointFront = flip(refPoint);
Reduced = 2;
if isscalar(eps_amp) || (eps_amp(1) == eps_amp(2))
  Reduced = 1;
end

if ~exist('DoBootstrapLocNonl','var') || DoBootstrapLocNonl == false
  nonl = zeros(points,T);
  for k_0 = 1:T
    for Idx = 1:points
      numerator = 0;
      denominator = 0;
      for p = 1:floor((P-1)/Reduced)
        k = k_0 + p*T;
        K_val = K(max(abs(eps(k:-1:(k-S-R))-refPointFront-alpha*xNonl(Idx))),hNonl);
        numerator = numerator + K_val*(y(k) - M(k_0));
        denominator = denominator + K_val;
      end
      nonl(Idx,k_0) = numerator/denominator;
    end
  end
else
  nonlBnum = zeros(points,T,Folds);
  nonlBden = zeros(points,T,Folds);
  SubsetPSize = floor(P/Folds);
  for FoldsIdx = 1:Folds
    for k_0 = 1:T
      for Idx = 1:points
        numerator = 0;
        denominator = 0;
        pBegin = 1+(FoldsIdx-1)*SubsetPSize;
        pEnd = pBegin + SubsetPSize - 2;
        for p = pBegin:pEnd
          k = k_0 + p*T;
          K_val = K(max(abs(eps(k:-1:(k-S-R))-refPointFront-alpha*xNonl(Idx))),hNonl);
          numerator = numerator + K_val*(y(k) - M(k_0));
          denominator = denominator + K_val;
        end
        nonlBnum(Idx,k_0,FoldsIdx) = numerator;
        nonlBden(Idx,k_0,FoldsIdx) = denominator;
      end
    end
  end
end

% Uncomment for test and check estimates
% plot(xNonl,nonl(:,5),'.');
% plot(xNonl,nonl(:,1:3),'-');