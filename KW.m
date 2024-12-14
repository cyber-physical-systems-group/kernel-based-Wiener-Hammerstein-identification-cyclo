function [lambda, Num, Den] = KW(k_0,P_max,eps,y_real,memory,h_all,T,refPoint)
% Local linearization and cross-correlation
h = h_all(1);
if length(h_all) == 2
  h_M = h_all(2);
else
  h_M = h_all(1);
end
M = M_est(k_0,P_max,eps,y_real,memory,h_M,T,refPoint); % Estimator of $\mathcal{M}_{k_0}$
lambda = zeros(memory+1,length(k_0));
Num = zeros(memory+1,length(k_0));
Den = zeros(memory+1,length(k_0));
for i=1:length(k_0)
    for j=0:memory
        numerator = 0;
        denominator = 0;
        for p = 1:P_max % p=0 omitted for initialization
            numerator = numerator + eps(k_0(i)+p*T-j)*(y_real(k_0(i)+p*T)-1*M(i))*K(Dk(eps,k_0(i)+p*T,memory,refPoint),h);
            denominator = denominator + (eps(k_0(i)+p*T-j)^2)*K(Dk(eps,k_0(i)+p*T,memory,refPoint),h);
        end
        lambda(j+1,i) = numerator/denominator;
        Num(j+1,i) = numerator;
        Den(j+1,i) = denominator;
    end
end
end