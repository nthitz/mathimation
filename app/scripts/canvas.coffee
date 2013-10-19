define(['jquery','d3'],  ($,d3) ->
    'use strict';
    canvasCtxt = null
    d3Canvas = null
    init = (canvasID,w,h,create) ->

    	if create
    		d3Canvas = d3.select('body').append('canvas').attr('id',canvasID)
    	else
    		d3Canvas = d3.select('#' + canvasID)
    	
    	d3Canvas.attr('width',w).attr('height',h);
    	return document.getElementById(canvasID).getContext('2d')

    return {init: init}
);