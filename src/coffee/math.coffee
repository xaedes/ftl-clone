define([], () -> 

    Math.sign = (x) ->
        if x == 0 then 0 else (if x < 0 then -1 else 1) 
    
    Math.clip = (x,lower_bound,upper_bound) ->
        x = Math.max(x,lower_bound)
        x = Math.min(x,upper_bound)
        return x

    Math.randomIntBounds = (lower_bound,upper_bound) ->
    	return Math.round(Math.random()*(upper_bound-lower_bound)+lower_bound)

    return Math
)
