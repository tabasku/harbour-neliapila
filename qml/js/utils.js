//Regex to match
// any kind of url
var wwwAddress = new RegExp(/\b((?:[a-z][\w\-]+:(?:\/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}\/)(?:[^\s()<>]|\((?:[^\s()<>]|(?:\([^\s()<>]+\)))*\))+(?:\((?:[^\s()<>]|(?:\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:".,<>?«»“”‘’]))/gi);
//tagged url "<a href='url'>somethingsomethng</a>
var htmlTag = new RegExp(/<a[^>]* href="([^"]*)"\>.*?\<\/a\>/g);
//This one collects also 'url.org' but breaks if url has odd characters
//var wwwAddress2 = new RegExp(/[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,6}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi);

function tracebackCatcher(traceback,holder){
    //This determines whats in the butt
    var catchHttpError = new RegExp(/urllib.error.HTTPError: HTTP Error (.*)/)
    //requests.exceptions.ConnectionError: ('Connection aborted.', gaierror(-2, 'Name or service not known'))
    var catchRequestsConnectionError = new RegExp((/requests.exceptions.ConnectionError: \(\'(.*)\'\,/))



    if(traceback.match(catchHttpError)){
        var errTxt = traceback.match(catchHttpError)[1]
        console.log(errTxt)

        holder.text= errTxt
        holder.enabled = true
    }
    else if(traceback.match(catchRequestsConnectionError)){
        var errTxt = traceback.match(catchRequestsConnectionError)[1]
        console.log(errTxt)

        holder.text= errTxt
        holder.enabled = true
    }
    else if(typeof traceback === "undefined"){
        holder.text= "Something broke"
        moreInfoButton.visible = false
        holder.enabled = true
    }
    else{
        holder.text= "I crashed little bit :("
        moreInfoButton.visible = true
        moreInfoButton.errorTitle = "Python error"
        moreInfoButton.fullError = traceback
        holder.enabled = true
    }
}

function openLink(link) {
    var wwwAddress = new RegExp(/[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?/gi)
    var httplink = new RegExp(/^http/)
    //Internal link to another thread, also get board
    var intlink = new RegExp(/^\/[a-z]+\/thread\/[0-9]+\#p[0-9]+/)
    var restolink = new RegExp(/^#p[0-9]+/)

    if (link.match(wwwAddress)){
        //If external link is matched, add http:// if its not there already because otherwise Sailfish doesnt understand to open URL with browser
        if(!link.match(httplink)){
            link = "http://"+link
        }

        infoBanner.alert("Opening link in browser");
        Qt.openUrlExternally(link)
    }
    else if (link.match(intlink)){

        var brd = link.match(/([a-z]+)/)[0]
        var trd = link.match(/([0-9]+)/)[0]

        pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {postNo: trd, boardId: brd } );
    }
    else if (link.match(restolink)){
        var singlePostNo = link = link.replace('#p','');
        var postsToShow = "["+singlePostNo+"]"
        var model

        if(typeof modelToStrip !== 'undefined'){
            model = modelToStrip
        }
        else{
            model = postsModel
        }

        pageStack.push(Qt.resolvedUrl("../pages/PostsPage.qml"), {
                           postNo: postNo,
                           boardId: boardId,
                           modelToStrip: model,
                           postsToShow:postsToShow,
                           singlePostNo: singlePostNo
                       } )
    }

    else{
        console.log("Did not match: "+link)}
}
