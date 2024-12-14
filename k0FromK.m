function k_0 = k0FromK(k,T)
% Exctracts phase k_0 from k
k_0 = k - T*floor((k-1)/T);
end