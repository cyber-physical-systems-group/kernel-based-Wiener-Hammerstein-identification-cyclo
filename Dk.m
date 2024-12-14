function val = Dk(eps,k,memory,refPoint)
% $Delta_k$ - local linearization condition
if(k>memory)
    val = max(abs(eps((k-memory):k)-refPoint));
else
    val = NaN;
    msgbox('Delta K Function: not enough eps values!', 'Error', 'error');
end
end

