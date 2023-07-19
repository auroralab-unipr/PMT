classdef TreePMT
   properties
      graph
      positions
      is_occupied
      holes
      degrees
      distance
      nodes
      corridors
      c
      junctions
      leaves
      root
      levels
   end
   methods

        function obj = TreePMT(graph, source)

            n = numnodes(graph);
            obj.graph = graph;
            obj.positions = source;
            obj.is_occupied = zeros([1,n]);
            obj.is_occupied(source) = 1;
            obj.holes = find(obj.is_occupied==0);
            obj.degrees = degree(graph);
            obj.junctions = find(obj.degrees>2);
            obj.leaves = find(obj.degrees==1);
            obj.distance = distances(graph);
            corridors = {};
            corridors2 = {};
            corr_ends = [obj.junctions; obj.leaves];

            for i = 1:numel(corr_ends)
                for j = i+1:numel(corr_ends)
                    pi = shortestpath(graph, corr_ends(i), corr_ends(j));
                    pi_degrees = obj.degrees(pi);
                    try
                    if all(pi_degrees(2:end-1)==2) && pi_degrees(1)~=2 && pi_degrees(end)~=2
                        corridors{end+1} = pi;
                        if pi_degrees(1)>2 && pi_degrees(end)>2
                            corridors2{end+1} = pi;
                        end
                    end
                    catch exception
                        disp("err")
                    end
                end
            end

            obj.nodes = 1:numnodes(graph);

            c1 = max(cellfun(@length, corridors));
            [c2, index] = max(cellfun(@length, corridors2));

            if not(isempty(corridors2))
                obj.root = corridors2{index(1)}(idivide(int32(numel(corridors2{index})),2));
            else

                obj.root = randi(numnodes(graph));

            end
            
            obj.levels = obj.distance(obj.root, :);

            if isempty(corridors2)
                c2 = 0;
            end

            obj.c = max(c1+1, c2+2);

        end

        function [steps, obj] = MovePebble(obj, start, stop)

            P = shortestpath(obj.graph, start, stop);
            steps = repmat(obj.positions',1,size(P,2)-1);
            try
            steps(obj.positions==start, :) = P(:, 2:end);
            catch
                disp("error")
            end
            obj.positions(obj.positions==start) = stop;
            obj.holes(obj.holes==stop) = [];
            obj.is_occupied(start) = 0;
            obj.holes = [obj.holes, start];
            obj.is_occupied(stop) = 1;

            obj.check();

        end

        function [steps, obj] = BringHole(obj, path)
        
            steps = [];
            for i = numel(path)-1:-1:1
                if obj.is_occupied(path(i))

                    obj.positions(obj.positions==path(i))=path(i+1);
                    obj.holes(obj.holes==path(i+1)) = [];
                    obj.is_occupied(path(i)) = 0;
                    obj.holes = [obj.holes, path(i)];
                    obj.is_occupied(path(i+1)) = 1;
                    steps=[steps, obj.positions'];
                end
            end

            obj.check();
        
        end

        function PrintTree(obj)

           h = plot(obj.graph, 'Layout', 'force');
           highlight(h,obj.positions, 'NodeColor', 'green');

        end

        function check(obj)

            if(numel(unique(obj.holes))<numel(obj.holes))
                disp("error")
            end
        
            if not(isequal(sort(obj.holes), sort(find(obj.is_occupied==0))))
                disp("error")
            end

            if(numel(unique(obj.positions))<numel(obj.positions))
                disp("error")
            end

        end

        function [nodes] = T(obj, x, y)

            n = setdiff(1:numnodes(obj.graph), x);
            SG = subgraph(obj.graph, n);
            
            [components, ~] = conncomp(SG);

            try
            nodes = n(components==components(n==y));
            catch exception
                disp("EEEEEE")
            end
        end
   end
end