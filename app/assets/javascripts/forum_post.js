// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
vote = (fPostId,thumbsUp) => {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            if (this.responseText=="SUCCESS_N") {
                score = parseInt(document.getElementById("fpScore"+fPostId.toString()).innerHTML,10);
                if (thumbsUp) {
                    document.getElementById("fpScore"+fPostId.toString()).innerHTML = (score+1).toString();
                    document.getElementById("thumbsUp"+fPostId.toString()).setAttribute("class","fa fa-thumbs-up green-link");
                    document.getElementById("thumbsDown"+fPostId.toString()).setAttribute("class","fa fa-thumbs-down red-link-faded");
                }
                else {
                    document.getElementById("fpScore"+fPostId.toString()).innerHTML = (score-1).toString();
                    document.getElementById("thumbsUp"+fPostId.toString()).setAttribute("class","fa fa-thumbs-up green-link-faded");
                    document.getElementById("thumbsDown"+fPostId.toString()).setAttribute("class","fa fa-thumbs-down red-link");
                }
            }
            if (this.responseText=="SUCCESS_E") {
                score = parseInt(document.getElementById("fpScore"+fPostId.toString()).innerHTML,10);
                if (thumbsUp) {
                    document.getElementById("fpScore"+fPostId.toString()).innerHTML = (score+2).toString();
                    document.getElementById("thumbsUp"+fPostId.toString()).setAttribute("class","fa fa-thumbs-up green-link");
                    document.getElementById("thumbsDown"+fPostId.toString()).setAttribute("class","fa fa-thumbs-down red-link-faded");
                }
                else {
                    document.getElementById("fpScore"+fPostId.toString()).innerHTML = (score-2).toString();
                    document.getElementById("thumbsUp"+fPostId.toString()).setAttribute("class","fa fa-thumbs-up green-link-faded");
                    document.getElementById("thumbsDown"+fPostId.toString()).setAttribute("class","fa fa-thumbs-down red-link");
                }
            }
            if (this.responseText=="SUCCESS_S") {
                if (thumbsUp) {
                    document.getElementById("thumbsUp"+fPostId.toString()).setAttribute("class","fa fa-thumbs-up green-link");
                    document.getElementById("thumbsDown"+fPostId.toString()).setAttribute("class","fa fa-thumbs-down red-link-faded");
                }
                else {
                    document.getElementById("thumbsUp"+fPostId.toString()).setAttribute("class","fa fa-thumbs-up green-link-faded");
                    document.getElementById("thumbsDown"+fPostId.toString()).setAttribute("class","fa fa-thumbs-down red-link");
                }
            }
        }
    };
    xhttp.open("post","/forum_post/vote",true);
    let data={};
    data["postID"] = fPostId;
    data["thumbsUp"] = thumbsUp;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
};