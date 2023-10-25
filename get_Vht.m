function Vht = get_Vht(v,B)
% v���ٶ�ʸ����ʱ������ B:�ų�ʸ����ʱ������
% v��B�ĸ�ʽΪN��3��
% ���ӣ�
% 1��2��3
% 4��5��6
% 7��8��9
% 10��11��12
% �� �� ��
% N��
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
