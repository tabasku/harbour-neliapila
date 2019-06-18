WorkerScript.onMessage = function(msg) {

    var postNo = msg.postNo
    var modelToStrip = msg.modelToStrip
    var postsToShow = JSON.parse(msg.postsToShow)
    var count = modelToStrip.count

    for(var i=0; i < count; i++){

        for(var x=0; x < postsToShow.length; x++){
            if(postsToShow[x].toString() === modelToStrip.get(i).no.toString()) {
                msg.model.append(modelToStrip.get(i))
            }
        }
    }
    msg.model.sync();

    //console.log("STRIPPED "+postNo+ " "+ modelToStrip)

    WorkerScript.sendMessage({'busy':false})
}

