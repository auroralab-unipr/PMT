
L = [];
C = [];
N = [];
P = [];
L_M = [];
C_M = [];
N_M = [];
P_M = [];

for n = 20:20:200
    for p = 5:5:3*n/4 %p = max([5, fix(n/50)*5]):5:2*n/3
        try
        l = readmatrix(['data/length_sol/length_sol' num2str(p) num2str(n) '.csv'])';
        c = readmatrix(['data/all_c/all_c' num2str(p) num2str(n) '.csv'])';
        l = l(~isnan(l));
        c = c(~isnan(c));
        if size(c, 1)<10
            continue
        end
        d = [l,c];
        %d = rmoutliers(d,"percentiles",[10,90]);
        L = [L; d(:,1)];
        C = [C; d(:,2)];
        L_M = [L_M; mean(d(:,1))];
        C_M = [C_M; mean(d(:,2))];
        N_M = [N_M; n];
        P_M = [P_M; p];
        N = [N; repmat(n, size(d(:,1)))];
        P = [P; repmat(p, size(d(:,1)))];
        scatter(P.*C,L, 'filled');
        catch
        end
    end
end
% 
% X = [N.*P.*C, L, N.^2];
% X = rmoutliers(X);
% scatter(X(:, 1),X(:, 2), X(:,3), 'filled');
% 
% xlabel('n|P|c');
% ylabel('number of moves');

x = N_M.*P_M.*C_M + N_M.^2;
%z = N_M.^2;
y = L_M-1;
detect = isoutlier([x,y]);
X = [x,y];
%X = rmoutliers(X, 'median');

scatter(X(:,1),X(:,2), 'filled');
title('PMT')
xlabel('n|P|c+n^2');
ylabel('average number of moves');

hold on;
%[M,I] = max(X(:, 2));

l_1 = [0,0];%X(I, :);

[M,I] = max(X(1:10, 2));

l_2 = X(I,:);

l = [l_1;l_2];
m = (l(1,2)-l(2,2))/(l(1,1)-l(2,1));
q = l(1,2)-m*l(1,1);

xlim = get(gca,'XLim');

ylim = xlim*m+q;

plot(xlim, ylim, 'LineWidth', 2);