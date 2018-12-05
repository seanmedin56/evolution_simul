function new_distrib = mutate(gene, mutate_rate_met, num_met, ...
    mutate_rate_kill, num_kill, births)
%MUTATE Returns the distribution of genotypes resulting from the births
%from organisms with the genotype gene
%   Detailed explanation goes here
new_distrib = containers.Map('KeyType','char','ValueType','int32');
new_distrib(gene) = births;

num_genes = [num_met num_kill];
mutate_rates = [mutate_rate_met, mutate_rate_kill];

for h = 1:length(num_genes)
    num = num_genes(h);
    for i = 1:num
        gene_iter = keys(new_distrib);
        change_distrib = containers.Map('KeyType','char','ValueType','int32');
        for j = 1:length(gene_iter)
            gene2 = gene_iter{j};
            mutants = random('bino',double(new_distrib(gene2)),mutate_rates(h));
            genotype = strsplit(gene2);
            if ~isKey(change_distrib, gene2)
                change_distrib(gene2) = -mutants;
            else
                change_distrib(gene2) = change_distrib(gene2) - mutants;
            end
            if str2double(genotype{h}) < i
                new_geno_cell = genotype;
                new_geno_cell{h} = num2str(str2double(genotype{h}) + 1);
                new_geno = strjoin(new_geno_cell, ' ');
                if ~isKey(change_distrib,new_geno)
                    change_distrib(new_geno) = mutants;
                else
                    change_distrib(new_geno) = change_distrib(new_geno) + mutants;
                end
            else
                new_geno_cell = genotype;
                new_geno_cell{h} = num2str(str2double(genotype{h}) - 1);
                new_geno = strjoin(new_geno_cell, ' ');
                if ~isKey(change_distrib,new_geno)
                    change_distrib(new_geno) = mutants;
                else

                    change_distrib(new_geno) = change_distrib(new_geno) + mutants;
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
end

