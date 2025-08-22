clc; clear;

% Coefficients de la fonction objectif (Z = 1200x1 + 1000x2)
C = [-1200 -1000 0 0 0]; % On met les coefficients n?gatifs pour minimiser -Z

% Matrice des contraintes avec variables de slack (s1, s2, s3)
A = [
    10  5  1 0 0;   % M1
    2   3  0 1 0;   % M2
    1  34  0 0 1    % M3
];

% Second membre (ressources disponibles)
b = [200; 60; 34];

% Initialisation du tableau du simplexe
tableau = [A b];
tableau = [tableau; C 0]; % Ligne de la fonction objectif

[m, n] = size(tableau);

% Boucle du simplexe
while any(tableau(end,1:end-1) < 0)
    [~, pivot_col] = min(tableau(end,1:end-1)); % Variable entrante
    ratios = tableau(1:end-1,end) ./ tableau(1:end-1,pivot_col);
    ratios(ratios <= 0) = inf;
    [~, pivot_row] = min(ratios); % Variable sortante
    
    % Pivot
    tableau(pivot_row,:) = tableau(pivot_row,:) / tableau(pivot_row,pivot_col);
    for i = 1:m
        if i ~= pivot_row
            tableau(i,:) = tableau(i,:) - tableau(i,pivot_col)*tableau(pivot_row,:);
        end
    end
end

% Affichage du tableau final
fprintf('Tableau final du simplexe :\n');
disp(tableau);

% Extraction de la solution
solution = zeros(1,n-1);
for j = 1:n-1
    col = tableau(1:end-1,j);
    if sum(col == 1) == 1 && sum(col) == 1
        idx = find(col == 1);
        solution(j) = tableau(idx, end);
    end
end

% R?sultats
fprintf('\nR?sultat optimal :\n');
fprintf('x1 = %.2f\n', solution(1));
fprintf('x2 = %.2f\n', solution(2));
fprintf('B?n?fice maximum Z = %.2f Dhs\n', tableau(end,end)); % Affiche Z directement
