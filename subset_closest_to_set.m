function [subset] = subset_closest_to_set(q, set_to_compare, set_to_take, tree)

    if numel(set_to_take) < q
        disp("errore")
    end

    subset = intersect(set_to_compare, set_to_take);
    
    [ia, ib] = ismember(set_to_take, subset);
    try
        set_to_take(:, ia) = []; %delete nodes that are already in the subset
    catch exception
        disp("error");
    end
    distance = tree.distance(set_to_take, set_to_compare); %distance of the nodes we are looking at
 try
    while isempty(subset) || size(subset,2)<q
        

        if isempty(set_to_take)
            disp("error")
        end

        try
        [value, index] = min(distance(:));
        [row, col] = ind2sub(size(distance), index);
        new_node = set_to_take(row);
        subset = [subset, new_node];
        set_to_take(row) = [];
        distance(row, :) = []; 
        catch
            disp("err")
        end
    end

 catch exception
     disp("error")
 end

    if isempty(subset)
        error('ERROR: SUBSET EMPTY');
    else
        subset = subset(1:q); %size of the subset
    end
end