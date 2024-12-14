function [M] = M_est(k_0,P_max,eps,y_real,memory,h,T,refPoint)
% Estimator of $\mu(E{x}|\phi_k=0)$, i.e., $\mathcal{M}_{k_0}$
M = zeros(length(k_0),1);
for i=1:length(k_0)
    numerator = 0;
    denominator = 0;
    for p = 1:P_max % p=0 omitted for initialization
        numerator = numerator + y_real(k_0(i)+p*T)*K(Dk(eps,k_0(i)+p*T,memory,refPoint),h);
        denominator = denominator + K(Dk(eps,k_0(i)+p*T,memory,refPoint),h);
    end
    M(i) = numerator/denominator;
end
end