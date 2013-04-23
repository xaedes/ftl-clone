define([""],() -> 
	class Set
		constructor : (@equalityFunction) ->
			@list = []


		contains: (item) ->
			for i in @list
				if( @equalityFunction(i,item) )
					return true
			
			return false

		remove: (item) ->
			for idx in [0..@list.length-1]
				if( @equalityFunction(@list[idx],item) )
					@list.splice(idx,1)
					return true

			return false

		add: (item) ->
			if not @contains(item)
				@list.push(item)

		isEmpty: () ->
			return @list.length == 0


	return Set
)