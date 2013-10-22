require.config({
    paths: {
        jquery: '../bower_components/jquery/jquery',
        d3: '../bower_components/d3/d3',
        threejs: '../bower_components/threejs/build/three',
        lodash: '../bower_components/lodash/dist/lodash',
        raf: "../bower_components/raf.js/raf",
        //tweenjs: "../bower_components/TweenJS/lib/tweenjs-0.5.0.min"
        //tweenjs: "../bower_components/tween.js/src/Tween"
        tweenjs: "../bower_components/tween.js/Tween"
    },
    shim: {
        d3: {
            exports: 'd3'
        },
        threejs: {
        	exports:  "THREE"
        },
        tweenjs: {
            exports: "TWEEN"
        }
    }
});

require(['app'], function (app) {
    'use strict';
    // use app here
    
});
