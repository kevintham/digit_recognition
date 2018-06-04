var $range = $(".js-range-slider");

var canvas = new fabric.Canvas("canvas");
canvas.isDrawingMode = true;

$range.ionRangeSlider({
    onChange: function(data) {
        canvas.freeDrawingBrush.width = $range.data("from");
    }
});

canvas.freeDrawingBrush.width = $range.data("from");
canvas.freeDrawingBrush.color = "#000000";
canvas.backgroundColor = "#ffffff";
canvas.renderAll();

$("#clear").click(function(){
    canvas.clear();
    canvas.backgroundColor = "#ffffff";
    canvas.renderAll();
});

$("#predict").click(function(){
    var img_array = canvas.getContext().getImageData(0, 0, 
                                     canvas.width, canvas.height).data;
    Shiny.onInputChange("img_array", img_array);
    //console.log(img_array);
});