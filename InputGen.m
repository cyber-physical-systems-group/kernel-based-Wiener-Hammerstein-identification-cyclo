% Input generation

Eu = sin(2*pi*(1:N)/T).' + sin(2*pi*(1:N)/(T/2))'; 
Eu = Eu.^(3)+1;
Eu_test = 0.5*sin(2*pi*(1:N)/(4*T))';
Eu_test = Eu_test.^(3)+1;
if isscalar(eps_amp)
 eps = 2*(rand(N,1)-0.5)*eps_amp;
elseif length(z_amp) == 2
  if N/2 - round(N/2) ~= 0
    warning('N is not even!');
  end
  eps = zeros(N,1);
  eps_test = zeros(N,1);
  if strcmp(eps_PDF,'uniform')
    eps(1:(N/2)) = 2*(rand(N/2,1)-0.5)*eps_amp(1);
    eps((N/2+1):end) = 2*(rand(N/2,1)-0.5)*eps_amp(2);
    eps_test(1:(N/2)) = 2*(rand(N/2,1)-0.5)*eps_amp(1);
    eps_test((N/2+1):end) = 2*(rand(N/2,1)-0.5)*eps_amp(2);
  elseif  strcmp(eps_PDF,'triangular')
    eps(1:(N/2)) = (rand(N/2,1)+rand(N/2,1)-1)*eps_amp(1);
    eps((N/2+1):end) = (rand(N/2,1)+rand(N/2,1)-1)*eps_amp(2);
    eps_test(1:(N/2)) = (rand(N/2,1)+rand(N/2,1)-1)*eps_amp(1);
    eps_test((N/2+1):end) = (rand(N/2,1)+rand(N/2,1)-1)*eps_amp(2);
  else % Gaussian
    eps(1:(N/2)) = randn(N/2,1)*eps_amp(1);
    eps((N/2+1):end) = randn(N/2,1)*eps_amp(2);
    eps_test(1:(N/2)) = randn(N/2,1)*eps_amp(1);
    eps_test((N/2+1):end) = randn(N/2,1)*eps_amp(2);
  end
end

u = Eu + eps;
u_test = Eu_test + eps_test;