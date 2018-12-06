function mut_probs = calc_mutate_probs(num_met, num_kill, ...
    met_mut_rate, kill_mut_rate)
%CALC_MUTATE_PROBS pre calculates mutation probabilities
%   Detailed explanation goes here

    mut_probs = struct;
    
    num_met_mut_probs = zeros(1, num_met + 1);
    num_kill_mut_probs = zeros(1, num_kill + 1);
    
    for i = 0:num_met
        num_met_mut_probs(i+1) = binopdf(i, num_met, met_mut_rate);
    end
    
    for j = 0:num_kill
        num_kill_mut_probs(j+1) = binopdf(j, num_kill, kill_mut_rate);
    end
    
    for i = 0:num_met % starting number of met genes
        for j = 0:num_kill % starting number of kill genes
            sp_mut_probs = zeros(1, (num_met + 1) * (num_kill + 1));
            sp_met_mut_probs = zeros(1, num_met + 1);
            sp_kill_mut_probs = zeros(1, num_kill + 1);
            
            for p = 0:num_met % number of changes in met genes
                total_combos = nchoosek(num_met, p);
                for q = abs(i-p):2:min(2*num_met-i-p,i+p) % new number of met genes

                    if q > i
                        sp_met_mut_probs(q+1) = sp_met_mut_probs(q+1) + ...
                            nchoosek(num_met-i,(q-i) + (p-(q-i))/2) * ...
                            nchoosek(i, (p-(q-i))/2) * ...
                            num_met_mut_probs(p+1) / total_combos;
                    else
                        sp_met_mut_probs(q+1) = sp_met_mut_probs(q+1) + ...
                            nchoosek(i,(i-q) + (p-(i-q))/2) * ...
                            nchoosek(num_met-i, (p-(i-q))/2) * ...
                            num_met_mut_probs(p+1) / total_combos;
                    end
                end
            end
            
            for p = 0:num_kill % number of changes in kill genes
                total_combos = nchoosek(num_kill, p);
                for q = abs(j-p):2:min(2*num_kill-j-p,j+p) % new number of kill genes

                    if q > j
                        sp_kill_mut_probs(q+1) = sp_kill_mut_probs(q+1) + ...
                            nchoosek(num_kill-j,(q-j) + (p-(q-j))/2) * ...
                            nchoosek(j, (p-(q-j))/2) * ...
                            num_kill_mut_probs(p+1) / total_combos;
                    else
                        sp_kill_mut_probs(q+1) = sp_kill_mut_probs(q+1) + ...
                            nchoosek(j,(j-q) + (p-(j-q))/2) * ...
                            nchoosek(num_kill-j, (p-(j-q))/2) * ...
                            num_kill_mut_probs(p+1) / total_combos;
                    end
                end
            end
            
            for i2 = 0:num_met
                for j2 = 0:num_kill
                    sp_mut_probs(i2 * (num_kill + 1) + j2 + 1) = ...
                        sp_met_mut_probs(i2+1) * sp_kill_mut_probs(j2+1);
                end
            end
            mut_probs(i * (num_kill + 1) + j + 1).probs = sp_mut_probs;
        end
    end
end

