for n = 200:20:200
disp(n)
    for m = 60:5:100
    disp(m)

length_steps = [];
all_c = [];
    %n = 20;
    %m = 5;
tStart = tic;
for k = 1:20
    
    disp(k)
    
    G = CreateRandomTree(n);
    
    source =  randperm(n,m);
    destination = randperm(n,m);
    
    %T = TreePMT(G,source);
    
    % r = source(randi(m));
    % t = r;
    % while t == r
    %     t = randi(n);
    % end

    %T.PrintTree();
    

    [steps, c] = PMT(G, source, destination);

    %r = 1;
    %t = 2;
    
    % [steps, T] = MotionPlanning(T, r, t);
    % steps = [source', steps];

    %[steps, T] = Kornhauser(T, source, destinations);
    %steps=[source', steps];

    g = check_matrix(steps, adjacency(G));

    if not(g)
         disp("errore")
    end

    %if not(isequal(steps(:,1), source'))
    %    disp("errore")
    %end
    
    %if not(isequal(steps(:,end), destination'))
    %    disp("errore")
    %end

    if size(steps,2)>1
        length_steps = [length_steps, size(steps, 2)];
        all_c = [all_c, c];
    end
    
end

tEnd = toc(tStart);

writematrix(length_steps,...
['data/length_sol/length_sol' num2str(m) num2str(n) '.csv'],'Delimiter',',','WriteMode', 'append')

writematrix(all_c,...
['data/all_c/all_c' num2str(m) num2str(n) '.csv'],'Delimiter',',','WriteMode', 'append')

writematrix([mean(length_steps), m, n, tEnd, mean(all_c)],...
'data/data.csv','Delimiter',',','WriteMode', 'append')

     end
 end

%T.PrintTree();