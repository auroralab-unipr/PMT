function [steps, tree] = MotionPlanning(tree, r, t)

    %steps=tree.positions';
    steps = [];
    p = find(tree.positions==r);
    
    if numel(tree.holes)<tree.c
        disp("ERROR NUMBER OF HOLES");
        return
    end

    tree.check()

    bcc = tree.T(r, t);

    n_holes = numel(intersect(bcc, tree.holes));

    if n_holes >= tree.c

        tree.check();

       [s, tree] = ProcedureA(tree, r, t);

       steps = [steps,s];

       g = check_matrix(steps, adjacency(tree.graph));

       if not(steps(p,end)==t)
           disp("aaaaaaa")
       end

    else

        %disp("PROCEDURE B");

        j = 1;

        q = tree.c-n_holes;

        bcc = tree.T(r, t);

        z = setdiff(neighbors(tree.graph, r), bcc);

        H = [];

        for i=1:numel(z)

            Vj = tree.T(r, z(i));

            qj = numel(intersect(tree.holes, Vj));

            if qj==0 
                continue
            end

            if(qj<=q)

                Hj = subset_closest_to_set(qj, r, setdiff(Vj,r), tree);

                H = [H, Hj];
                
                [s, tree] = GatherHoles(Hj, Vj, tree);

                if not(tree.is_occupied(r))
                    disp("error");
                end

                steps = [steps, s];
                
                q = q-qj;
            else

                Hj = subset_closest_to_set(q, r, setdiff(Vj,r), tree);

                H = [H, Hj];

                [s, tree] = GatherHoles(Hj, Vj, tree);

                if not(tree.is_occupied(r))
                    disp("error");
                end
                
                steps = [steps, s];

                break;
            
            end

            if q == 0
                break
            end

        end

        if isempty(H)
            disp("error")
            return
        end

        [m, i] = max(tree.distance(r, H));
        v = H(i);

        if not(tree.is_occupied(r))
            disp("error");
        end
        [s, tree] = tree.MovePebble(r, v);
        steps = [steps, s];

        if(v==t)
            disp("error")
        end
        
        g = check_matrix(steps, adjacency(tree.graph));

        [s, tree] = ProcedureA(tree, v, t);
        steps = [steps, s];

        g = check_matrix(steps, adjacency(tree.graph));

       if not(steps(p,end)==t)
           disp("aaaaaaa")
       end

    end
    
    
    
end