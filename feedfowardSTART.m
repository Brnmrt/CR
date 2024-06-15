function [] = feedfowardSTART()

    tempoExecucao = tic;
    % Obtem dados do Start.csv
    file = 'Datasets/Start.csv';
    data = readmatrix(file, 'Delimiter', ';', 'DecimalSeparator', '.');

    input = data(:, 2:end-1)';
    target = data(:, end)';

    iter = 50;

    precisaoTotal = [];
    error = 0;

    for i = 1 : iter
    % Inicializa a rede
    net = feedforwardnet(10);
    net.divideFcn = ''; % Sem divisão de dados 

    net.trainFcn = 'trainlm';
    net.trainParam.showWindow = 0;

    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'logsig';

    % Treina a rede
    net = train(net, input, target);


    % Testa a rede
    output = sim(net, input);
    output = (output >= 0.5);

    errorT = mse(net, target, output);

    r = sum(output == target);
    precisao = 100*r/size(target,2);
    precisaoTotal = [precisaoTotal precisao];

    error = error + errorT;


end

    precisaoTotal = mean(precisaoTotal);
    error = error/iter;

    disp('Precisão total:');
    disp(precisaoTotal);

    disp('Erro:');
    disp(error);


    disp('Tempo de execução:');
    disp(toc(tempoExecucao));


    
end