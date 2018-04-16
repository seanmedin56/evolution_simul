function num_dead = death(gene,t,num_orgs)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    if gene == '1'
        if t < 100
            d = .4 + .005 * t;
            num_dead = random('bino',num_orgs,d);
        else
            num_dead = random('bino',num_orgs,.995);
        end
    else
        if t < 100
            d = .7 - .003 * t;
            num_dead = random('bino',num_orgs,d); %cell biology by the numbers
        else
            num_dead = random('bino',num_orgs,.305);
        end
    end
end

