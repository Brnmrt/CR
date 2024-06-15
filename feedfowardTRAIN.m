function [precisaoTotal, precisaoTeste, tempo] = feedfowardTRAIN(neuroCamadas,epochs,trainF,divF,evalFArray,Rtrain,Rval,Rtest,savename)


% Verifica se o evalFArray tem o tamanho correto
if length(evalFArray) ~= (length(neuroCamadas)+1)
    disp('O evalFArray tem de ter o mesmo tamanho que o numero de camadas da rede + 1');
    return;
end

if((Rtest + Rval + Rtrain) ~= 1) && ~isempty(divF)
    disp("Ratios devem somar para 1");
    return;
end

if ~isfolder('./Redes')
    mkdir('./Redes')
end

if ~isfolder('./Redes/RedesGlobal')
    mkdir('./Redes/RedesGlobal')
end

if ~isfolder('./Redes/RedesTeste')
    mkdir('./Redes/RedesTeste')
end



% Obtem dados do TrainFiltered.csv

data = readmatrix('Datasets/TrainFiltered.csv',"Delimiter", ";", "DecimalSeparator", ".");
input = data(:, 2:end-1)';
target = data(:,end)'; % data(:,end)' dava resultados impossiveis (sempre 100%), ficou assim)

tempoExecucao = tic;
precisaoTotal = [];
precisaoTeste = [];
iteracoes = 50;



bestTeste = 0;
bestGlobal = 0;
bestGlobalTeste = 0;
bestTesteGlobal = 0;

for k=1 : iteracoes
    % Inicializa a rede

    fprintf("Iteração %d\n",k);
    net = feedforwardnet(neuroCamadas);
    net.trainFcn = trainF;


    if ~isempty(divF)
        net.divideFcn = divF;
        net.divideParam.trainRatio = Rtrain;
        net.divideParam.valRatio = Rval;
        net.divideParam.testRatio = Rtest;
    else
        net.divideFcn = '';
    end

    net.trainParam.epochs = epochs;
    net.trainParam.showWindow=0;

    for i = 1:length(neuroCamadas)+1
        net.layers{i}.transferFcn = evalFArray{i};
    end

    % Treina a rede
    [net,tr] = train(net, input, target);


    % Testa a rede
    output = sim(net, input);

    output = (output >= 0.5);
   
    r = sum(output == target);

    precisao = 100*r/size(target,2);

    precisaoTotal = [precisaoTotal precisao];



    % Conjunto de teste
    
    Tinput = input(:, tr.testInd);
    Ttarget = target(:, tr.testInd);

    output = sim(net, Tinput);
    output = (output >= 0.5);

    r = sum(output == Ttarget);

    precisaoT = 100*r/size(Ttarget,2);

    precisaoTeste = [precisaoTeste precisaoT];

    if(precisao > bestGlobal)
        bestGlobal = precisao;
        bestTesteGlobal = precisaoT; 

        save(['./Redes/RedesGlobal/Rede' savename '.mat'], 'net');
    end

    if(precisaoT > bestTeste)
        bestTeste = precisaoT;
        bestGlobalTeste = precisao;

        save(['./Redes/RedesTeste/Rede' savename '.mat'], 'net');
    end


    
end

precisaoTotal = mean(precisaoTotal);
precisaoTeste = mean(precisaoTeste);

fprintf("Melhor RedeGlobal: [%f, %f]\n", bestGlobal, bestTesteGlobal);
fprintf("Melhor RedeTeste: [%f, %f]\n", bestGlobalTeste, bestTeste);
tempo = toc(tempoExecucao);



% % Importa os dados das redes guardadas
% ficheiroDados = 'DadosNN/Data.csv';
% if ~isfolder('DadosNN')
%     mkdir('DadosNN')
% end
% 
% if ~isfile(ficheiroDados)
%     writematrix([], ficheiroDados, "Delimiter", ";");
% end
% 
% redes = readmatrix(ficheiroDados, "Delimiter", ";", "DecimalSeparator", ".");
% 
% % Se tiver vazio ou tiver menos de 3 redes guarda a precisao total, o erro e o tempo de execucao
% 
% if isempty(redes) || size(redes, 1) < 3
%     redes = [redes; [precisaoTotal precisaoTeste error tempo]];
% 
%     % Guarda a rede neuronal com o nome da linha
%     save(['Rede' num2str(size(redes, 1)) '.mat'], 'net');
% else
%     % Se tiver 3 redes, verifica se a nova rede tem uma precisao total maior que a menor das 3 redes
%     % Se tiver, substitui a rede com a menor precisao total
%     [minimo, index] = min(redes(:, 2));
%     if precisaoTeste > minimo
%         redes(index, :) = [precisaoTotal precisaoTeste error tempo];
% 
%         % Guarda a rede neuronal com o nome da linha
%         save(['Rede' num2str(index) '.mat'], 'net');
%     end
% end
% 
% % Guarda as redes
% writematrix(redes, 'DadosNN/Data.csv', "Delimiter", ";");

end

