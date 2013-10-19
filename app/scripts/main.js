require.config({
    paths: {
        jquery: '../bower_components/jquery/jquery',
        d3: '../bower_components/d3/d3',
        threejs: '../bower_components/threejs/build/three',
        lodash: '../bower_components/lodash/dist/lodash'
    },
    shim: {
        d3: {
            exports: 'd3'
        },
        threejs: {
        	exports:  "THREE"
        }
    }
});

require(['app'], function (app) {
    'use strict';
    // use app here
    
});
