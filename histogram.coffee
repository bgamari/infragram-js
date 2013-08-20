class Histogram
        constructor: (@image) ->
                @hist = (histogram(d.data, [0,255], 255) for d in get_channels(@image))
                margin =
                        top: 20
                        right: 20
                        bottom: 30
                        left: 50
                width = 600
                height = 300
                
                xScale = d3.scale.linear().range([0, width])
                yScale = d3.scale.linear().range([height, 0])
                xAxis = d3.svg.axis()
                        .scale(xScale)
                        .orient("bottom")
                yAxis = d3.svg.axis()
                        .scale(yScale)
                        .orient("left")

                maxY = 10000 # FIXME
                xScale.domain([0, 255])
                yScale.domain([0, maxY])
                        
                area = d3.svg.area()
                        .x((d) -> xScale(d[0]))
                        .y0(height)
                        .y1((d) -> yScale(d[1]))

                d3.select("#hist").selectAll("svg").remove()
                svg = d3.select("#hist").append("svg")
                        .attr("width", width + margin.left + margin.right)
                        .attr("height", height + margin.top + margin.bottom)
                        .append("g")
                        .attr("transform", "translate("+margin.left+","+margin.top+")")
                
                svg.append("g")
                        .attr("class", "x axis")
                        .attr("transform", "translate(0," + height + ")")
                        .call(xAxis);

                svg.append("g")
                        .attr("class", "y axis")
                        .call(yAxis)

                colors = ["red", "green", "blue"]
                for h,i in @hist
                        d = ([x,y] for y,x in h)
                        svg.append("path")
                                .datum(d)
                                .attr("class", "hist "+colors[i])
                                .attr("d", area)

