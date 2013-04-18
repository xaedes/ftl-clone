define(["init"], \
        (init) ->

    Utils = 
        extend: () -> 
            # Extend function from oCanvas2.4.0 converted with http://js2coffee.org/

            # Get first two args
            args = Array::slice.call(arguments)
            last = args[args.length - 1]
            destination = args.splice(0, 1)[0]
            current = args.splice(0, 1)[0]
            x = undefined
            exclude = []
            descriptor = undefined

            # If the last object is an exclude object, get the properties
            exclude = last.exclude  if last.exclude and (JSON.stringify(last) is JSON.stringify(exclude: last.exclude))

            # Do the loop unless this object is an exclude object
            if current isnt last or exclude.length is 0

                # Add members from second object to the first
                for x of current
                  
                    # Exclude specified properties
                    continue  if ~exclude.indexOf(x)
                    descriptor = Object.getOwnPropertyDescriptor(current, x)
                    if descriptor.get or descriptor.set
                        Object.defineProperty destination, x, descriptor
                    else
                        destination[x] = current[x]

            # If there are more objects passed in, run once more, otherwise return the first object
            if args.length > 0
                Utils.extend.apply this, [destination].concat(args)
            else
                destination
    return Utils
)