function [steps, tree] = MoveHoles(tree, from, to)

    nodes = unique([to, from], 'stable');
    try
        subtree = subgraph(tree.graph, nodes);
    catch exception
        disp(exception.message);
    end
    source = [];

    for i = 1:numel(tree.positions)
        source = [source, find(nodes == tree.positions(i))];
    end

    pos = nodes(source);

    ST = TreePMT(subtree,source);

    tree.check();

    [s, ST] = GatherHoles(1:numel(to), 1:numel(nodes), ST);

    tree.check();

    [steps, tree] = UpdateTree(s, nodes, tree, pos);
    g = check_matrix(steps, adjacency(tree.graph));
    

end