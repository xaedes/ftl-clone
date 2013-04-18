define([""], \
        () ->

    Assets =
        bundles: {}
        all_images: {}
        image: (url, bundle = null) -> 
            # usage:
            # image('img/...png') gets the image object, if it isn't loaded yet it will start to load
            # image('img/...png', 'bundleXY') gets the image object, if it isn't loaded yet, it will be added to bundleXY and loading need to be started explicitly

            if (url not of @all_images)
                @all_images[url] = new Image()
                if bundle == null
                    @all_images[url].src = url 
                else
                    if (bundle not of @bundles)
                        @bundles[bundle] = {}

                    @all_images[url].url = url # loading can be started by setting src to the value of url
                    @bundles[bundle][url] = @all_images[url]

            return @all_images[url]
        
        load: (bundles, callback) ->
            bundles = bundles.split(' ')

            toLoad = 0
            for bundle in bundles
                for prop of @bundles[bundle]
                    if @bundles[bundle][prop].hasOwnProperty('url')
                        toLoad++
                        @bundles[bundle][prop].src = @bundles[bundle][prop].url # start loading of this image
                        @bundles[bundle][prop].onload = () =>
                            toLoad--
                            if(toLoad == 0)
                                callback() if callback?


    return Assets
)