

d = readtable("data/motion_planning/data.csv");

T = rmmissing(d);

y = table2array(T(:,1))-1;
p = table2array(T(:,2));
n = table2array(T(:,3));
c = table2array(T(:,5));

x = n.*c;
X = [x,y];
a = find(X(:,2)==220.25);
b = find(X(:,1)==300);
%X(X(:,1)==300, :) = [];
%X = rmoutliers(X, 'median');
X = sortrows(X,1);

[M,I] = max(X(1:100, 2));

l_1 = X(I, :);

%[M,I] = max(X(1:100, 2));

l_2 = [0,0];

l = [l_1;l_2];

scatter(X(:,1),X(:,2), 'filled');
title('Motion Planning')
xlabel('nc');
ylabel('average number of moves');
hold on;

m = (l(1,2)-l(2,2))/(l(1,1)-l(2,1));
q = l(1,2)-m*l(1,1);

xlim = get(gca,'XLim');

ylim = xlim*m+q;

plot(xlim, ylim, 'LineWidth', 2);