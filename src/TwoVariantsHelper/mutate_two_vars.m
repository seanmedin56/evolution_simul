function new_distrib = mutate_two_vars(mutate_rate, gene, num_genes, births)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

new_distrib = containers.Map('KeyType','char','ValueType','int32');
new_distrib(gene) = births;

for i = 1:num_genes
    gene_iter = keys(new_distrib);
    change_distrib = containers.Map('KeyType','char','ValueType','int32');
    for j = 1:length(gene_iter)
        gene2 = gene_iter{j};
        mutants = random('bino',new_distrib(gene2),mutate_rate);
        num = str2double(gene2);
        if gene2 == '0'
            change_distrib(gene2) = -mutants;
        else
            change_distrib(gene2) = change_distrib(gene2) - mutants;
        end
        if num < i
            change_distrib(string(num + 1)) = mutants;
        else
            change_distrib(string(num-1)) = change_distrib(string(num-1)) + mutants;
        end
    end
    for j = 1:length(gene_iter)
        gene2 = gene_iter{j};
        new_distrib(gene2) = new_distrib(gene2) + change_distrib(gene2);
    end
end

end

