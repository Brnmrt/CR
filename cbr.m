    function [] = cbr()

    thresholdSimilarity = 1;
    
    formatSpec = '%f%f%f%f%f%f%f%f%f%f%f';
    bibliotecaCasos = readtable('Datasets/Train.csv', 'Delimiter', ',', 'Format', formatSpec);

    % Guardando os casos com NaN
    casosNaN = bibliotecaCasos(isnan(bibliotecaCasos{:, 11}), :);
    
    disp('Casos com NaN:');
    disp(casosNaN);


    % Removendo os casos com NaN
    bibliotecaCasos = bibliotecaCasos(~isnan(bibliotecaCasos{:, 11}), :);

    % iteratar sobre os casosNaN, prenchere valores stroke com o valore mais provavel

    for i = 1:size(casosNaN, 1)
       
        [indexes, similaridades, casosNaN(i, :)] = retrieve(bibliotecaCasos, casosNaN(i, :), thresholdSimilarity);

        % Caso o set de indexes esteja vazio

        if isempty(indexes)
            while isempty(indexes)
                disp("Nenhum caso verifica o threshold de similaridade, repetindo");
                thresholdSimilarity = thresholdSimilarity - 0.01;
                [indexes, similaridades, casosNaN(i, :)] = retrieve(bibliotecaCasos, casosNaN(i, :), thresholdSimilarity);
            end
        end

        casos_parecidos = bibliotecaCasos(indexes, :);
        casos_parecidos.similaridade = similaridades';
        % Preenchendo os valores NaN atravez da media dos valores mais proximos

        casosNaN{i, 11} = mode(casos_parecidos.stroke);

        bibliotecaCasos = [bibliotecaCasos; casosNaN(i, :)];

    end
    
    % sorteando por id
    bibliotecaCasos = sortrows(bibliotecaCasos, 1);

    disp('Biblioteca filtrada:');
    disp(bibliotecaCasos);

    % Guarda tabela em .csv outravez

    writetable(bibliotecaCasos, 'Datasets/TrainFiltered.csv', 'Delimiter', ';');

end