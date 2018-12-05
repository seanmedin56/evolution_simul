function deaths = death(gene, dist, activator_param, ...
    toxic_prod_rate, met_prod_rate, met_coop, met_diss, basal_death, death_param)
%DEATH Calculates death rate for organism
%   Detailed explanation goes here
    genotype = strsplit(gene);
    met_prod = str2double(genotype{1}) * met_prod_rate;
    repressor_param = (met_prod / met_diss) ^ met_coop;
    toxic_prod = str2double(genotype{2}) * toxic_prod_rate * (1 + activator_param) / ...
        (1 + activator_param + repressor_param + activator_param * repressor_param);
    death_rate = 1 - (1 - basal_death) * exp(- death_param * toxic_prod);
    deaths = random('bino', dist(gene), death_rate);

end

