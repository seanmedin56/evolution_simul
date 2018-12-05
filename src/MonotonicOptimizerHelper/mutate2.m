function new_distrib = mutate2(gene, mutate_rate_met, num_met, ...
    mutate_rate_kill, num_kill, births)
%MUTATE Returns the distribution of genotypes resulting from the births
%from organisms with the genotype gene (first order approximation)
%   Detailed explanation goes here
new_distrib = containers.Map('KeyType','char','ValueType','int32');

genotype = strsplit(gene, ' ');
met = str2double(genotype{1});
kill = str2double(genotype{2});

switch_probs = [];
for i = 0:num_met
    for j = 0:num_kill
        switch_prob = 1;
        change_met = i - met;
        change_kill = j - kill;
        if change_met < 0
            switch_prob = switch_prob * ...
                binopdf(-change_met, met, mutate_rate_met) * ...
                (1-mutate_rate_met)^(num_met + change_met);
        elseif change_met >= 0
            switch_prob = switch_prob * ...
                binopdf(change_met, num_met-met, mutate_rate_met) * ...
                (1-mutate_rate_met)^(num_met - change_met);
        end
        if change_kill < 0
            switch_prob = switch_prob * ...
                binopdf(-change_kill, kill, mutate_rate_kill) * ...
                (1-mutate_rate_kill)^(num_kill + change_kill);
        elseif change_kill >= 0
            switch_prob = switch_prob * ...
                binopdf(change_kill, num_kill-kill, mutate_rate_kill) * ...
                (1-mutate_rate_kill)^(num_kill - change_kill);
        end
        switch_probs = [switch_probs switch_prob];
        
    end
end
switch_probs = switch_probs / sum(switch_probs);
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

