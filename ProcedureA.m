function [steps, tree] = ProcedureA(tree, r, t)
    
    %disp("PROCEDURE A");

    steps = [];

    p= find(tree.positions==r);

    pi_rt = shortestpath(tree.graph, r, t);
    
    [i, l, j, m, cat] = CaterpillarSets(tree, pi_rt);

    if isempty(cat)
        disp("error")
        return
    end

    if(numel(unique(tree.positions))<numel(tree.positions))
        disp("error")
    end
    [s, tree] = GatherHoles(setdiff(cat{1}, l(1)), tree.T(r,t), tree);
    if(numel(unique(tree.positions))<numel(tree.positions))
        disp("error")
    end

    steps = [steps, s];
    
    l = [l, t];
    [s, tree] = tree.MovePebble(l(1), l(2));
    steps = [steps, s];
    for k = 1:m
    
        from = setdiff(cat{k}, l(k+1));
        to = setdiff(cat{k+1}, l(k+1));
        [s, tree] = MoveHoles(tree, from, to);
        steps = [steps, s];
        [s, tree] = tree.MovePebble(l(k+1), l(k+2));
        steps = [steps, s];
    
    end

    if not(steps(p,end)==t)
       disp("aaaaaaa")
    end

    g = check_matrix(steps, adjacency(tree.graph));
    
end