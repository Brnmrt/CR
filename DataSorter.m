
file = 'Datasets/Train.csv'; % Obter o ficheiro

data = readtable(file);


data.gender = double(data.gender == "Female"); 
data.ever_married = double(data.ever_married == "Yes"); 
data.Residence_type = double(data.Residence_type == "Urban"); 

smoking_mapping = containers.Map(...
    {'never smoked', 'formerly smoked', 'smokes', 'Unknown'}, ...
    {0, 1, 2, 3});
data.smoking_status = cellfun(@(x) smoking_mapping(x), data.smoking_status);

writetable(data, file);




