function new_distrib = mutate3(gene, mutate_rate_met, num_met, ...
    mutate_rate_kill, num_kill, births, table_of_muts)
%MUTATE3 the fasted and most accurate version of mutate, looks up
% probabilities in a pre calculated table
%   Detailed explanation goes here

    new_distrib = containers.Map('KeyType','char','ValueType','int32');

    genotype = strsplit(gene, ' ');
    met = str2double(genotype{1});
    kill = str2double(genotype{2});
    switch_probs = table_of_muts(met * (num_kill+1) + kill + 1).probs;
    idx = 0;
    for i = 0:num_met
        for j = 0:num_kill
            idx = idx + 1;
            new_geno = [num2str(i) ' ' num2str(j)];
            if births == 0
                return
            elseif i == num_met && j == num_kill
                new_distrib(new_geno) = births;
                return
            end

            muts = random('bino', births, switch_probs(idx));
            if muts > 0
                new_distrib(new_geno) = muts;
                births = births - muts;
            end
            switch_probs(idx+1:end) = switch_probs(idx + 1:end) ...
                / sum(switch_probs(idx+1:end));
        end
    end
end

