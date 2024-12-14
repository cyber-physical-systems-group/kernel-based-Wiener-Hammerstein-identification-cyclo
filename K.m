function K_val = K(x,h)
% Kernel function with rectangular window
K_val = (abs(x)<=h)*1;
end