function [G] = CreateRandomTree(n)

    py.importlib.import_module('networkx');
    py.importlib.import_module('scipy');
    
    import py.networkx.*
    
    G = random_tree(int32(n));
    edgeL = edges(G);
    edgeL = py.list(edgeL);
    Edges = cell(edgeL);
    
    A = zeros(n);
    
    for i=1:size(Edges,2)
        A(int32(Edges{i}{1})+1, int32(Edges{i}{2})+1) = 1;
        A(int32(Edges{i}{2})+1, int32(Edges{i}{1})+1) = 1;
    end
    
    G = graph(A);

end