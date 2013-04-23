define([""],() -> 
	class PriorityQueue
		constructor : (@keyname) ->
			@list = []

			# descending order of keyname 
			@compareFunction = (a,b) =>
				return b[@keyname]-a[@keyname]

		peek: () ->
			return @list[@list.length - 1]

		dequeue: () ->
			return @list.pop()

		enqueue: (item) ->
			@list.push(item)
			@list.sort(@compareFunction)

		contains: (item, equalityFunction) ->
			for i in @list
				if( equalityFunction(i,item) )
					return true
			
			return false

		keyChanged: (item) ->
			@list.sort(@compareFunction)

		isEmpty: () ->
			return @list.length == 0

	return PriorityQueue
)