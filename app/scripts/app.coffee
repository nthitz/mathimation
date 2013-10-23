define(['lodash','canvas','raf','tweenjs','timelineController','d3'],  (_,canvas,raf,tweenjs,timeline,d3) ->
    'use strict';
    console.log canvas
    dim = 500
    console.log tweenjs
    ctxt = canvas.init('canvas',dim,dim,true)
    ctxt.fillStyle = 'red';
    ctxt.fillRect(10,20,30,40)

    console.log 'timeline'
    console.log(raf)
    
    w = $(document).width()
    $(document).on('mousemove',(event) ->
        pct = event.clientX / w
        pct *= 5000
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
    xScaleTickArray = [xScaleMin..xScaleMax]

    
    animationProps = {
        circle: {
            x: circleRadius
        },
        scaleToDraw: 0
        drawScaleCircle: 1
    }
    setTweens = () ->
        tweenjs.removeAll()
        new tweenjs.Tween(animationProps).to({scaleToDraw: 4},2000).start(0)
        new tweenjs.Tween(animationProps).delay(2600).to({drawScaleCircle: 0},0).start(0)

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
        ctxt.font = "20pt Verdana"
        tickArray = xScaleTickArray
        
        if animationProps.scaleToDraw < 4
            tickArray = [0.. Math.floor(animationProps.scaleToDraw)]
        for x in tickArray
            ctxt.moveTo(xScale(x), yAxisPos + unitSize)
            ctxt.lineTo(xScale(x), yAxisPos - unitSize)
            ctxt.fillText("" + x, xScale(x), yAxisPos - unitSize - 10)
        ctxt.stroke()
    drawScaleCircle = () ->
        ctxt.fillStyle = 'black'
        if animationProps.drawScaleCircle is 0 
            return
        xPos = Math.floor(animationProps.scaleToDraw)
        if xPos is 0
            return
        xPos = xScale(xPos - circleRadius)
        ctxt.beginPath()
        pxRadius = xScale(circleRadius) - leftPadding
        ctxt.arc xPos, yAxisPos - pxRadius, pxRadius, 0, Math.PI * 2, false
        ctxt.fill()

    presetStartTime = 0
    firstTime = null
    originalProps = null

    animate = (time) ->
        if firstTime is null
            originalProps = _.clone(animationProps)
            firstTime = time
        
        t = (time + presetStartTime) - firstTime
        if t > 5000
            return reset(0)

        tweenjs.update(t)
        ctxt.clearRect(0,0,dim,dim)

        drawScale()
        drawScaleCircle()
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