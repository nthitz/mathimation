define(['lodash','canvas','raf','tweenjs','timelineController'],  (_,canvas,raf,tweenjs,timeline) ->
    'use strict';
    console.log canvas
    dim = 500
    console.log tweenjs
    ctxt = canvas.init('canvas',dim,dim,true)
    ctxt.fillStyle = 'red';
    ctxt.fillRect(10,20,30,40)

    console.log 'timeline'
    console.log(raf)
    
    rectProperties = {
        x:40
        y: 50
    }
    setTweens = () ->
        tweenjs.removeAll()
        new tweenjs.Tween(rectProperties).to({y:80},1000).start(0)
        new tweenjs.Tween(rectProperties).delay(1200).to({y:150}).start(0)
        new tweenjs.Tween(rectProperties).delay(2200).to({x:10}).start(0)
    w = $(document).width()
    $(document).on('mousemove',(event) ->
        pct = event.clientX / w
        pct *= 5000
        reset(pct)
    )
    presetStartTime = 0
    firstTime = null
    originalProps = null
    animate = (time) ->
        if firstTime is null
            originalProps = _.clone(rectProperties)
            firstTime = time
        
        t = (time + presetStartTime) - firstTime
        if t > 5000
            return reset(0)
        tweenjs.update(t)
        ctxt.clearRect(0,0,dim,dim)
        ctxt.fillStyle = 'red';
        ctxt.fillRect(rectProperties.x, rectProperties.y ,30, 40)
        requestAnimationFrame(animate)

    reset = (setTime) ->
        #rectProperties.x = 40;
        #rectProperties.y = 50;
        rectProperties = originalProps
        firstTime = null
        setTweens()
        presetStartTime = setTime
        requestAnimationFrame(animate)
    setTweens()
    requestAnimationFrame(animate)

    
    return {reset: reset};
);