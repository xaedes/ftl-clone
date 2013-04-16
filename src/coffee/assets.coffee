define([""], \
        () ->

    Assets =
        images: []
        image: (url) -> 
            if url of @images
                return @images[url]


            @images[url] = new Image()
            @images[url].src = url

            return @images[url]
    

    return Assets
)