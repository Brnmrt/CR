function [indexes, similarities, caso_I] = retrieve(bibliotecaCasos, caso_I, thresholdSimilarity)

% 1 - gender
% 2 - age
% 3 - hypertension
% 4 - heart_disease
% 5 - ever_married
% 6 - Residence_type
% 7 - avg_glucose_level
% 8 - bmi
% 9 - smoking_status
weight_factors = [2 4 4 3 1 1 3 3 4];

max_values = get_max_values(bibliotecaCasos);
indexes = [];
similarities = [];

for i=1:size(bibliotecaCasos,1)
    distances = zeros(1,9);
    
    distances(1,1) = linear_distance(bibliotecaCasos{i,'gender'}/max_values('gender'),...
        caso_I.gender / max_values('gender'));
    
    distances(1,2) = linear_distance(bibliotecaCasos{i,'age'}/max_values('age'),...
        caso_I.age / max_values('age'));
    
    distances(1,3) = linear_distance(bibliotecaCasos{i,'hypertension'}/max_values('hypertension'),...
        caso_I.hypertension / max_values('hypertension'));
    
    distances(1,4) = linear_distance(bibliotecaCasos{i,'heart_disease'}/max_values('heart_disease'),...
        caso_I.heart_disease / max_values('heart_disease'));
    
    distance(1,5) = linear_distance(bibliotecaCasos{i,'ever_married'}/max_values('ever_married'),...
        caso_I.ever_married / max_values('ever_married'));
    
    distances(1,6) = linear_distance(bibliotecaCasos{i,'Residence_type'}/max_values('Residence_type'),...
        caso_I.Residence_type / max_values('Residence_type'));
    
    
    distances(1,7) = linear_distance(bibliotecaCasos{i,'avg_glucose_level'}/max_values('avg_glucose_level'),...
        caso_I.avg_glucose_level / max_values('avg_glucose_level'));
    
    distances(1,8) = linear_distance(bibliotecaCasos{i,'bmi'}/max_values('bmi'),...
        caso_I.bmi / max_values('bmi'));
    
    distances(1,9) = smoking_status_distance(bibliotecaCasos{i,'smoking_status'}/max_values('smoking_status'),...
        caso_I.smoking_status / max_values('smoking_status'));
    
    DG = (distances * weight_factors')/sum(weight_factors);
    similaridadeFinal = 1 - DG;
    
    if similaridadeFinal >= thresholdSimilarity
        indexes = [indexes i];
        similarities = [similarities similaridadeFinal];
    end
    


    
end



end

function [distance] = linear_distance(val1,val2)
    distance = sum(abs(val1 - val2));
end


function [distance] = smoking_status_distance(val1,val2)
if val1 == 3 || val2 == 3
    distance = 4;
else
    distance = abs(val1 - val2);
end
end


function [max_values] = get_max_values(case_library)

key_set = {'gender', 'age', 'hypertension', 'heart_disease', 'ever_married', 'Residence_type', 'avg_glucose_level', 'bmi', 'smoking_status'};
value_set = {max(case_library{:,'gender'}), max(case_library{:,'age'}), max(case_library{:,'hypertension'}), max(case_library{:,'heart_disease'}), max(case_library{:,'ever_married'}), max(case_library{:,'Residence_type'}), max(case_library{:,'avg_glucose_level'}), max(case_library{:,'bmi'}), max(case_library{:,'smoking_status'})};
max_values = containers.Map(key_set, value_set);
end
