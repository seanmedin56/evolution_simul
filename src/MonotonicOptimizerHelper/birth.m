function births = birth(gene, dist, max_rate, cap_param)
%BIRTH Tells how many births will come from this particular genotype gene during
%time step t with the population distribution given by dist
%   Detailed explanation goes here
    gene_iter = keys(dist);
    total_pop = 0;
    for i = 1:length(gene_iter)
        total_pop = total_pop + dist(gene_iter{i});
    end
    birth_rate = max_rate * exp(- cap_param * total_pop);
    births = random('bino', dist(gene), birth_rate);
end

