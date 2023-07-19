function [good_solution] = check_matrix(all_sol, A)
  good_solution = 1;
  s = size(all_sol, 2);
  j = 1;
  
  while j<=s-1
    for i = 1:size(all_sol,1)  

      if ~A(all_sol(i, j), all_sol(i,j+1)) && all_sol(i,j)~=all_sol(i,j+1)

        disp("archi non esistenti");
        disp(i);
        disp(j);
        good_solution = 0;
      end

    end

    if isequal(all_sol(:, j), all_sol(:, j+1))

      disp("navette che non si muovono");
      disp(j);

    end 

    if length(all_sol(:, j)) ~= length(unique(all_sol(:, j)))

      disp("navette sullo stesso nodo");
      disp(j);
      good_solution = 0;

    end
    
        i = j+1;
    while i <= s

    if isequal(all_sol(:, j), all_sol(:, i))

      all_sol(:, j+1:i) = [];
      s = size(all_sol, 2);
      i = j+1;
    end

    i = i+1;

    end
    j = j+1;
  end

end