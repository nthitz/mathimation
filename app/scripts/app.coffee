
define(['lodash','canvas','raf','tweenjs','timelineController','d3','path'],  (_,canvas,raf,tweenjs,timeline,d3,path) ->
    'use strict';
    console.log canvas
    dim = 500
    console.log 'rjs tween'
    console.log tweenjs
    console.log 'window tween'
    console.log TWEEN
    ctxt = canvas.init('canvas',dim,dim,true)
    ctxt.fillStyle = 'red';
    ctxt.fillRect(10,20,30,40)

    console.log 'timeline'
    console.log(raf)
    
    w = $(document).width()
    resetTime = 6000
    $(document).on('mousemove',(event) ->
        pct = event.clientX / w
        pct *= resetTime
        reset(pct)
    )
    unitSize = 50
    circleRadius = 0.5
    leftPadding = 50

    yAxisPos = 200
    xScaleMin = 0
    xScaleMax = 4
    xScaleDiff = xScaleMax - xScaleMin
    xScale = d3.scale.linear().domain([xScaleMin, xScaleMax]).range([leftPadding, leftPadding + unitSize * xScaleDiff])
    scale = d3.scale.linear().domain([xScaleMin, xScaleMax]).range([0, unitSize * xScaleDiff])
    xScaleTickArray = [xScaleMin..xScaleMax]

    numWheelPoints = 50
    angleScale = d3.scale.linear().domain([0,numWheelPoints]).range([0, Math.PI * 2])
    wheelStrokeSize = 0.1
    wheelPoints = null

    
    animationProps = {
        circle: {
            x: circleRadius
        },
        scaleToDraw: 0
        drawScaleCircle: 1
        rollingCircle: {
            x: 0
            draw: 0
            rotation: Math.PI / 2
            originalRotation: Math.PI / 2
            rolledPoints: numWheelPoints
        }
    }
    generateWheelPoints = (offset) ->
        if typeof offset is 'undefined'
            offset = {x:0, y:0}
        if wheelPoints is null
            wheelPoints = _.map(_.range(0, numWheelPoints + 1), (index) ->
                return {x:0, y:0}
            )
        _.each(wheelPoints, (point, index) ->
            x = y = 0
            if index > animationProps.rollingCircle.rolledPoints
                r = circleRadius - wheelStrokeSize / 2
                x = 0 #wait what?
                y = Math.sin(animationProps.rollingCircle.originalRotation) * r
                
                x = xScale(x)
                y = scale(y)

                y += offset.y
            else
                angle = angleScale(index) + animationProps.rollingCircle.rotation
                
                r = circleRadius - wheelStrokeSize / 2
                #if index % 2 is 0
                #f    r -= wheelStrokeSize
                x = Math.cos(angle) * r
                y = Math.sin(angle) * r
                x = scale(x)
                y = scale(y)
                x += offset.x 
                y += offset.y 
            #return {x: x, y: y}
            point.x = x
            point.y = y
        )
        
    generateWheelPoints()
    path.init(ctxt, wheelPoints)
    
    scaleToDrawTo = 4;
    setTweens = () ->
        tweenjs.removeAll()
        new tweenjs.Tween(animationProps).to({scaleToDraw: scaleToDrawTo},2000).start(0)
        new tweenjs.Tween(animationProps).delay(2600).to({drawScaleCircle: 0},0).start(0)
        new tweenjs.Tween(animationProps.rollingCircle).delay(2600).to({draw: 1},0).start(0)
        new tweenjs.Tween(animationProps.rollingCircle).delay(3000).to({
            x: Math.PI * 1,
            rotation: Math.PI * 2 + animationProps.rollingCircle.rotation
            rolledPoints: 0
        },2000).start(0)

        generateWheelPoints()
        #new tweenjs.Tween(animationProps).to({y:80},1000).start(0)
        #new tweenjs.Tween(animationProps).delay(1200).to({y:150}).start(0)
        #new tweenjs.Tween(animationProps).delay(2200).to({x:10}).start(0)
    drawScale = () ->
        ctxt.strokeStyle = "grey"
        ctxt.beginPath()
        ctxt.moveTo(xScale(0), yAxisPos)
        ctxt.lineTo(xScale(4), yAxisPos)
        ctxt.textAlign = "center"
        ctxt.fillStyle = "black"
        ctxt.font = "12pt Verdana"
        tickArray = xScaleTickArray
        
        if animationProps.scaleToDraw < 4
            tickArray = [0.. Math.floor(animationProps.scaleToDraw)]
        for x in tickArray
            ctxt.moveTo(xScale(x), yAxisPos + unitSize)
            ctxt.lineTo(xScale(x), yAxisPos - unitSize)
            ctxt.fillText("" + x, xScale(x), yAxisPos - unitSize - 10)
        ctxt.stroke()

        drawScaleCircle()
    drawCircle = (x, y, angle, radius) ->
        ctxt.fillStyle = "silver"
        ctxt.beginPath()
        ctxt.arc x, y, radius, 0, Math.PI * 2, false
        ctxt.fill()
        
        ctxt.fillStyle = "grey"
        ctxt.beginPath()
        ctxt.arc x, y, radius - 5, 0, Math.PI * 2, false
        ctxt.fill()
        numSpokes = 7
        angleInterpolate = d3.interpolate(0, Math.PI * 2)

        for i in [0..numSpokes - 1]
            angleSpoke = angleInterpolate(i / numSpokes) + angle
            xSpoke = x + Math.cos(angleSpoke) * radius
            ySpoke = y + Math.sin(angleSpoke) * radius
            ctxt.strokeStyle = "silver"
            ctxt.beginPath()
            ctxt.moveTo(x, y)
            ctxt.lineTo(xSpoke,ySpoke)
            ctxt.stroke();

        generateWheelPoints({x: x, y: y})
        drawWheel()

    drawScaleCircle = () ->
        if animationProps.drawScaleCircle is 0 
            return
        xPos = Math.floor(animationProps.scaleToDraw)
        if xPos is 0
            return
        xPos = xScale(xPos - circleRadius)
        ctxt.beginPath()
        pxRadius = Math.floor(scale(circleRadius)) - 1
        yPos = yAxisPos - pxRadius
        drawCircle(xPos,yPos, 0, pxRadius)
    drawWheel = () ->
        ctxt.strokeStyle = 'black'
        ctxt.lineWidth =  Math.ceil(scale(wheelStrokeSize))
        path.render(false,false, true)

    drawRollingCircle = () ->
        if animationProps.rollingCircle.draw is 0
            return
        pxRadius = Math.floor(scale(circleRadius)) - 1

        xPos = xScale(animationProps.rollingCircle.x)
        yPos = yAxisPos - pxRadius
        drawCircle(xPos, yPos, animationProps.rollingCircle.rotation, pxRadius)

    presetStartTime = 0
    firstTime = null
    originalProps = null

    animate = (time) ->
        if firstTime is null
            originalProps = _.clone(animationProps,true)
            firstTime = time
        
        t = (time + presetStartTime) - firstTime
        if t > resetTime
            return reset(0)

        tweenjs.update(t)
        ctxt.clearRect(0,0,dim,dim)

        drawScale()
        drawRollingCircle()
        requestAnimationFrame(animate)

    reset = (setTime) ->
        animationProps = originalProps
        firstTime = null
        setTweens()
        presetStartTime = setTime
        requestAnimationFrame(animate)
    setTweens()
    requestAnimationFrame(animate)

    
    return {reset: reset};
);