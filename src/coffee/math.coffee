define([], () -> 

    Math.sign = (x) ->
        if x == 0 then 0 else (if x < 0 then -1 else 1) 
    
    Math.clip = (x,lower_bound,upper_bound) ->
        x = Math.max(x,lower_bound)
        x = Math.min(x,upper_bound)
        return x

    return Math
)
