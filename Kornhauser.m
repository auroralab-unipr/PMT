function [steps, tree] = Kornhauser(tree, S, D)

    steps = [];
    if numnodes(tree.graph)==1
        return
    end

    V = 1:numnodes(tree.graph);

    %leaves = find(tree.degrees==1);
    v = tree.leaves(1);

    if ismember(v, intersect(S,D)) || not(ismember(v, [S,D]))

        S(S==v) = [];
        D(D==v) = []; %%%%%%

    elseif ismember(v, D)
        
        w = subset_closest_to_set(1, v, S, tree);
        [steps, tree] = tree.MovePebble(w, v);

        if isequal(steps(:,1)', S)
            disp("errore")
        end
        S(S==w) = [];
        D(D==v) = []; %%%%%%%

    elseif ismember(v, S)

        u = subset_closest_to_set(1, v, tree.holes, tree);
        pi_vu = shortestpath(tree.graph, v, u);
        [steps, tree] = tree.BringHole(pi_vu);


        if isequal(steps(:,1)', S)
            disp("errore")
        end

        S(S==v) = [];
        S = [S, u];

    end

    V(V==v) = [];

    sg = subgraph(tree.graph, V);

    [tf,ND] = ismember(D,V);

    [tf,NS] = ismember(S,V);

    subtree =  TreePMT(sg, NS);

    [s, subtree] = Kornhauser(subtree, NS, ND); 

    %if isequal(s(:,1), NS)
    %    disp("errore")
    %end
    
    %g = check_matrix(s, adjacency(subtree.graph));

    for i = 1:size(s, 2)

        if numel(unique(s(:, i)))<numel(s(:, i))

            disp("errore");

        end

    end

    if not(isempty(s))
        [steps2, tree] = UpdateTree(s, V, tree, S);
         g = check_matrix(steps, adjacency(tree.graph));
        steps = [steps, steps2];
    end

    g = check_matrix(steps, adjacency(tree.graph));
    
end