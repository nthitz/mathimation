define(['lodash','canvas'],  (_,canvas) ->
    'use strict';
    console.log canvas
    ctxt = canvas.init('canvas',500,500,true)
    ctxt.fillStyle = 'red';
    ctxt.fillRect(10,20,30,40)
    return '\'Allo \'Allo!';
);