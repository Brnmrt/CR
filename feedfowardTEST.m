function feedfowardTEST()
    feedfowardTeste('./Redes/RedesGlobal/Rede1-10.mat');
end

function [] = feedfowardTeste(redeFile)

% Obtem dados do TrainFiltered.csv
file = 'Datasets/Test.csv';
data = readmatrix(file, "Delimiter", ";", "DecimalSeparator", ".");

input = data(:, 2:end-1)';
target = data(:,end)';

tempoExecucao = tic;

% Inicializa a rede
load(redeFile);

% Testa a rede
output = sim(net, input);
output = (output >= 0.5);

error = mse(net, target, output);


r = sum(output == target);
precisaoTotal = 100*r/size(target,2);

disp('Precisão total:');
disp(precisaoTotal);

disp('Erro:');
disp(error);

tempo = toc(tempoExecucao);
disp('Tempo de execução:');
disp(tempo);




end

