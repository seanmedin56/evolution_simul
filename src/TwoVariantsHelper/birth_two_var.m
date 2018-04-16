function births = birth_two_var(birth1, birth2, reward1, reward2, ...
    cap1_start, cap1_slope, cap2, cap_all, num_genes, gene, dist, t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

m = str2num(gene);

cap1 = max(cap1_start - t * cap1_slope, .0001);

food1_pop = 0;
food2_pop = 0;
total_pop = 0;
gene_iter = keys(dist);

for i = 1:length(gene_iter)
    gene2 = gene_iter{i};
    total_pop = total_pop + dist(gene2);
    food1_pop = food1_pop + dist(gene2) * str2double(gene2) / num_genes;
    food2_pop = food2_pop + dist(gene2) * (1 - str2double(gene2) / num_genes);
end
r1 = 0;
r2 = 0;
if m == 0
    r2 = reward2;
elseif m == num_genes
    r1 = reward1; 
end
rate = ((m / num_genes) * (birth1 + r1) * exp(-food1_pop / cap1) + ...
    (1 - m / num_genes) * (birth2 + r2) * exp(-food2_pop / cap2)) *  ...
    exp(-total_pop / cap_all);

births = random('bino',dist(gene),rate);

end

