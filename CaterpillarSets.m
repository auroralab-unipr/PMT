function [i, l, j, m, cat] = CaterpillarSets(tree, pi_rt)
    
    r = pi_rt (1);
    t = pi_rt(end);
    l = r;
    i = intersect(neighbors(tree.graph, r), pi_rt);

    m = 0; %%%%%%%
    cat = {};

    if tree.distance(i, t) < tree.c

        j = t;
        cat{1} = pi_rt;
    
    else

        j = intersect(pi_rt, find(tree.distance(i,:)==tree.c-2));
        k = 0;
        j = [i, j];

        while tree.distance(i, t) > tree.c-1

            pi_j = shortestpath(tree.graph, j(end-1), j(end));
            jun = intersect(pi_j(2:end), tree.junctions);
            if isempty(jun)
                error('ERROR: NO JUNCTIONS');
            end
            i_k1 = subset_closest_to_set(1, j(end), jun', tree);
            cat_set = shortestpath(tree.graph, i(end), j(end));
            i = [i, i_k1];
            neig = setdiff(neighbors(tree.graph,i_k1), pi_rt);
            l = [l, neig(1)];
            cat_set = [cat_set, l(end-1), l(end)];

            if not(numel(cat_set)==tree.c+1)
                disp("error")
            end
            cat{end+1} = cat_set;
            
            if tree.distance(i(end), t) < tree.c
                
                j = [j,t];
                m = m+1;
                cat_set = shortestpath(tree.graph, i(end), t);
                cat_set = [cat_set, l(end)];
                cat{end+1} = cat_set;
                break
            else

                pi_it = shortestpath(tree.graph, i(end), t);
                j =  [j, intersect(pi_it, find(tree.distance(i(end),:)==tree.c-2))];
                m = m+1;

            end

        end


    end

    if isempty(cat)

        disp("error")

    end


end