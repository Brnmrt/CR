function experiencia()
     
     [precisaoTotal, precisaoTeste, tempo] = feedfowardTRAIN([50,50], 1000, 'traincgf','divideint', ...
                                                            {'poslin','poslin', 'purelin'}, ...
                                                            0.9, 0.05, 0.05, 'Bla');
     
     disp('Precisão total:');
     disp(precisaoTotal);
     disp('precisaoTeste:');
     disp(precisaoTeste);
     disp('Tempo de execução (50 iterações):');
     disp(tempo);
     disp('---------------------------------');
end