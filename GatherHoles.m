function [steps, tree] = GatherHoles(to, from, tree)

    M_holes = subset_closest_to_set(numel(to), to, intersect(tree.holes, from), tree);
    [ia, ib] = ismember(M_holes, to);
    M_holes(ia) = [];
    Vp = intersect(tree.positions, to);

    steps = [];
    
    while ~isempty(Vp)

        v = M_holes(1); %node of a hole

        if tree.is_occupied(v)
            disp("error")
        end

        u = subset_closest_to_set(1, v, Vp, tree); %closest occupied node

        pi_uv = shortestpath(tree.graph, u, v); %path from u to v

        if numel(intersect(pi_uv,to))<=1
        
            [s, tree] = tree.BringHole(pi_uv);
            
            steps = [steps, s];
        
        else

            w = subset_closest_to_set(1, v, intersect(pi_uv,to), tree);
    
            [s, tree] = tree.MovePebble(u, w);
            steps = [steps,s];
            if(numel(unique(tree.positions))<numel(tree.positions))
                disp("error")
            end

            pi_wv = shortestpath(tree.graph, w, v);

            [s, tree] = tree.BringHole(pi_wv);
            if(numel(unique(tree.positions))<numel(tree.positions))
                disp("error")
            end

            steps = [steps, s];

        end

        %@ u unoccupied

        if numel(find(tree.positions==u))

            disp("ERRORE");

        end

        Vp(Vp==u) = [];

        M_holes(1) = [];
        

    end

    tree.check()
    g = check_matrix(steps, adjacency(tree.graph));
    

end