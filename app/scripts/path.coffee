define(['lodash',],  (_) ->
    'use strict';
    ctxt = null
    points = []
    init = (_ctxt, _points) ->
        ctxt = _ctxt
        if _.isArray(_points) and _.isArray(_points[0])
            points = _points
        else if _.isArray(_points)
            points = [_points]
        console.log points
    render = (offset, close, fill, stroke) ->
        _.each(points, (pointSet, psIndex) ->
            ctxt.beginPath()
            _.each(pointSet, (point, index) ->
                x = offset.x + point.x
                y = offset.y + point.y
                if index is 0
                    ctxt.moveTo(x, y)
                else
                    ctxt.lineTo(x, y)
            )
            if close
                ctxt.closePath()
            if fill
                ctxt.fill()
            if stroke
                ctxt.stroke()
        )
    return {init: init,render: render};
);