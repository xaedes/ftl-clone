define(["utils"], \
        (utils) ->

    handleBundle = (url, bundle) ->
        if bundle == null
            if not @all_assets[url].loaded
                @all_assets[url].load()
        else
            # Ensure bundle exists
            if (bundle not of @bundles)
                @bundles[bundle] = {}

            # Add image to bundle
            @bundles[bundle][url] = @all_assets[url]


    Assets =
        bundles: {}
        all_assets: {}
        image: (url, bundle = null) -> 
            # usage:
            # image('img/...png') gets the image object, if it isn't loaded yet it will start to load
            # image('img/...png', 'bundleXY') gets the image object, if it isn't loaded yet, it will be added to bundleXY and loading need to be started explicitly

            # If not already in all_assets, create it
            if (url not of @all_assets)
                # Create image
                @all_assets[url] = new Image()
                @all_assets[url].url = url
                @all_assets[url].onload = () ->
                    @loaded = true
                @all_assets[url].load = () ->
                    @src = @url

            handleBundle.call(@, url, bundle)

            return @all_assets[url]
        
        json: (url, bundle = null) ->
            # usage:
            # json('data/...json') gets the json object, if it isn't loaded yet it will start to load
            # json('data/...json', 'bundleXY') gets the json object, if it isn't loaded yet, it will be added to bundleXY and loading need to be started explicitly

            # If not already in all_assets, create it
            if (url not of @all_assets)
                # Create image
                @all_assets[url] = {}
                @all_assets[url].url = url
                @all_assets[url].onload = () ->
                    @loaded = true
                @all_assets[url].load = () ->
                    $.getJSON(@url)
                    .done((data) =>
                        utils.extend(@, data)
                        @onload() if @onload?
                    ).fail(() =>
                        @onload() if @onload?
                    )

            handleBundle.call(@, url, bundle)

            return @all_assets[url]

        load: (bundles, callback) ->
            bundles = bundles.split(' ')

            toLoad = 0

            callback_called = false

            for bundle in bundles
                for prop of @bundles[bundle]
                    if not(@bundles[bundle][prop].hasOwnProperty("loaded") and @bundles[bundle][prop].loaded)
                        if @bundles[bundle][prop].hasOwnProperty("load")
                            toLoad++
                            @bundles[bundle][prop].onload = () =>
                                @bundles[bundle][prop].loaded = true
                                toLoad--
                                if(toLoad == 0)
                                    callback() if callback?
                                    callback_called = true
            for bundle in bundles
                for prop of @bundles[bundle]
                    if not(@bundles[bundle][prop].hasOwnProperty("loaded") and @bundles[bundle][prop].loaded)
                        if @bundles[bundle][prop].hasOwnProperty("load")

                            @bundles[bundle][prop].load()
                        # else if @bundles[bundle][prop] 
                            # ...
                        
                            # ...
            if (toLoad == 0) and not callback_called
                callback() if callback?


    return Assets
)