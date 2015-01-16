document.ontouchstart = function(event){
    x = event.targetTouches[0].clientX;
    y = event.targetTouches[0].clientY;
    document.location = "myweb:touch:start:" + x + ":" + y;
};

document.ontouchmove = function(event){
    x = event.targetTouches[0].clientX;
    y = event.targetTouches[0].clientY;
    document.location = "myweb:touch:move:" + x + ":" + y;
};

document.ontouchcancel = function(event){
    document.location = "myweb:touch:cancel";
};

document.ontouchend = function(event){
    document.location = "myweb:touch:end";
};




	
