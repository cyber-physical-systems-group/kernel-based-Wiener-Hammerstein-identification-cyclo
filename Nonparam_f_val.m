function [val] = Nonparam_f_val(x, y, arg)
% Nonparametric nonlinear function value
points = length(x);
wide_mode = 2; % 0 - no wide mode, 1 - wide mode, 2 - zeroed value extension on sides
if(wide_mode == 1)
    over = 9E+10;
else
    over = 0;
end
val_num = length(arg);
val = zeros(val_num,1);
if ~isempty(x)
for j=1:val_num
    if (((arg(j) > (x(points)+over))) || ((arg(j) < (x(1)-over))))
      if wide_mode == 2
        if arg(j) > x(points)
          val(j) = 0;
        end
        if arg(j) < x(points)
          val(j) = 0;
        end
      else
        val(j) = NaN;
      end
        % Uncomment for other behavior than zero by default 
        % msgbox('function argument out of range!', 'Error','error');
        % warning('function argument out of range!');
    else
        if ((arg(j) > x(points)) && (arg(j) <= (x(points)+over)))
            nr = 41;
        elseif ((arg(j) < x(1)) && (arg(j) >= (x(1)-over)))
            nr = 2;
        else
        nr = 2;
            for i=2:points
                if(x(i)>=arg(j)) 
                    nr = i;
                    break;
                end
            end
        end
        y1 = y(nr-1);
        y2 = y(nr);
        x1 = x(nr-1);
        x2 = x(nr);
        tga = (y2 - y1) / (x2 - x1);
        val(j) = y1 + (arg(j) - x1)*tga;
    end
end
end
end