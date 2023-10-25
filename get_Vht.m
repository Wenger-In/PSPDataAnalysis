function Vht = get_Vht(v,B)
% v：速度矢量的时间序列 B:磁场矢量的时间序列
% v和B的格式为N行3列
% 例子：
% 1，2，3
% 4，5，6
% 7，8，9
% 10，11，12
% 。 。 。
% N行
    norm_B = sqrt(sum(B.^2,2));
    for i = 1:3
        for j= 1:3
           K(i,j) = mean(norm_B.^2.*kroneckerDelta(sym(i),sym(j))-B(:,i).*B(:,j));
           K_dot_v(i,j) = mean((norm_B.^2.*kroneckerDelta(sym(i),sym(j))-B(:,i).*B(:,j)).*v(:,j));
        end
    end
    K_dot_v = sum(K_dot_v,2);
    Vht = K^(-1)*K_dot_v;
end
