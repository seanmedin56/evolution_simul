function new_distrib = mutate_two_vars(mutate_rate, gene, num_genes, births)
% There are num_genes genes. This function draws from a binomial
% distribution to determine how many mutate for each newborn organsism.
%   Detailed explanation goes here

new_distrib = containers.Map('KeyType','char','ValueType','int32');
new_distrib(gene) = births;

for i = 1:num_genes
    gene_iter = keys(new_distrib);
    change_distrib = containers.Map('KeyType','char','ValueType','int32');
    for j = 1:length(gene_iter)
        gene2 = gene_iter{j};
        mutants = random('bino',double(new_distrib(gene2)),mutate_rate);
        num = str2double(gene2);
        if ~isKey(change_distrib, gene2)
            change_distrib(gene2) = -mutants;
        else
            change_distrib(gene2) = change_distrib(gene2) - mutants;
        end
        if num < i
            if ~isKey(change_distrib,num2str(num+1))
                change_distrib(num2str(num + 1)) = mutants;
            else
                change_distrib(num2str(num+1)) = change_distrib(num2str(num+1)) + mutants;
            end
        else
            if ~isKey(change_distrib,num2str(num-1))
                change_distrib(num2str(num-1)) = mutants;
            else
                
                change_distrib(num2str(num-1)) = change_distrib(num2str(num-1)) + mutants;
            end
        end
    end
    gene_iter = keys(change_distrib);
    for j = 1:length(gene_iter)
        gene2 = gene_iter{j};
        if ~isKey(new_distrib,gene2)
            new_distrib(gene2) = change_distrib(gene2);
        else
            new_distrib(gene2) = new_distrib(gene2) + change_distrib(gene2);
        end
    end
end

end

