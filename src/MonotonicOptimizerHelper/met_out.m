function conc = met_out(gene, met_prod_rate)
%MET_OUT Summary of this function goes here
%   Detailed explanation goes here
    genotype = strsplit(gene, ' ');
    conc = str2double(genotype{1}) * met_prod_rate;
end

