function [steps, tree] = UpdateTree(s, nodes, tree, pos)  
    
    for i = 1:size(s, 2)
        s(:,i) = nodes(s(:,i)');
    end

    steps = repmat(tree.positions',1,size(s,2));
    pos2 = tree.positions;

    for i = 1:size(s,1)
        steps(pos2==pos(i), :) = s(i,:);
        tree.positions(pos2==pos(i)) = s(i, end);
        tree.holes = [tree.holes, pos(i)];
        tree.is_occupied(pos(i)) = 0;
    end

    for i = 1:size(s,1)
        try
            tree.holes(tree.holes==s(i,end)) = [];
        catch exception
            disp("error")
        end
        tree.is_occupied(s(i,end)) = 1;
    end

    tree.check()

    g = check_matrix(steps, adjacency(tree.graph));

end