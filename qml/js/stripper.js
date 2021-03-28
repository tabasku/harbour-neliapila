WorkerScript.onMessage = function(msg) {

    var postNo = msg.postNo
    var modelToStrip = msg.modelToStrip
    var postsToShow = JSON.parse(msg.postsToShow)

    //Make post that is replied first item.
//    console.log(msg.singlePostNo)
//    if(typeof(msg.singlePostNo) === 'undefined'){
//        console.log("this is first item! " + postNo)
//        postsToShow.unshift(postNo)
//        console.log(postsToShow)
//    }

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

