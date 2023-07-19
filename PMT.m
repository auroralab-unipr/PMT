function [steps, c] = PMT(G, source, destination)

    steps = source';
    tree = TreePMT(G,source);
    c = tree.c;

    if numel(tree.holes)<tree.c
        disp("ERROR NUMBER OF HOLES");
        return
    end

    int_tree = TreePMT(G,destination);
    t_V1 = [];

    l = max(tree.levels);
    n = 1:numnodes(tree.graph);
    while numel(t_V1)<numel(source)
        t_V1 = [t_V1, n(tree.levels==l)]; %%%%%%%%
        l = l-1;
    end
    if numel(t_V1)>numel(source)
        t_V1 = t_V1(1:numel(source));
    end

    
    [g, int_tree] = Kornhauser(int_tree, destination, t_V1);
    g = [destination', g];
    int_conf = g(:,end)';
    subtree = tree;
    V0 = 1:numnodes(G);
    nodes = V0;

    order_p = [];
    pos = tree.positions;
    for i=1:numel(pos)
        order_p = [order_p, find(int_conf==t_V1(i))];
    end

    for k = 1:numel(source)

        sg = subgraph(G, nodes);

        s0 = [];
        for i = 1:numel(source)

            try
            s0 = [s0, find(nodes==tree.positions(i))];
            catch
                disp("err")
            end
        end
        pos = tree.positions(ismember(tree.positions, nodes));

        if not(numel(s0)==numel(pos))

            disp("err")
        end

        subtree = TreePMT(sg, s0);

        if subtree.c>tree.c
            disp("help")
        end

        source0 = find(nodes==tree.positions(order_p(k)));
        target0 = find(nodes==t_V1(k));

        if not(source0 == target0)

            if isempty(subtree.c)
                disp("aaaaa")
            end

        [s, subtree] = MotionPlanning(subtree, source0, target0);

        if isempty(s)
            disp("ERR")
        end


        [steps2, tree] = UpdateTree(s, nodes, tree, pos);

        steps = [steps, steps2];

        good = check_matrix(steps, adjacency(tree.graph));
        
        end

        nodes = setdiff(V0, t_V1(1:k));

    end

    steps = [steps, g(:, end-1:-1:1)];

end