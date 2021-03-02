function [rez] = afla_omega(a, b, omeg)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

for i = 1: 1000
    if( omeg(i) >= a )
        if( omeg(i) <= b )
        disp(i);
        rez = i;
        end
    end
    
end

end

