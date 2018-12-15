// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require jquery3
//= require popper
//= require bootstrap

/*global curUSRID */
checkForInvites = () => {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            const responseText = this.responseText;
            if (responseText == "SUCCESS_A") {
                alert("You have successfully joined the group.");
                window.location.reload();
            }
            else if (responseText == "SUCCESS_R") {
                xhttp.open("GET","/group/getInviteMessage",true);
                xhttp.send();
            }
            else if (responseText == "SUCCESS_0") {
                alert("User has successfully been added to the group.");
                xhttp.open("GET","/group/getInviteMessage",true);
                xhttp.send();
            }
            else if (responseText == "SUCCESS_1") {
                xhttp.open("GET","/group/getInviteMessage",true);
                xhttp.send();
            }
            else if (responseText != "BAD") {
                const response = JSON.parse(responseText);
                const id = response.id;
                const groupId = response.groupId;
                const groupName = response.groupName;
                const message = response.message;
                const toJoin = response.toJoin;
                const targetName = response.targetName;
                const creatorName = response.creatorName;
                if (toJoin) {
                    let joinMessage = "You have been invited to join " + groupName;
                    joinMessage += "\n\nMessage from: "+creatorName;
                    joinMessage += "\n\n" + message.replace('%username%',targetName);
                    joinMessage +="\n\nPress OK to join."
                    if (confirm(joinMessage)) {
                        let data={};
                        data["groupID"]=groupId;
                        data["inviteID"]=id;
                        xhttp.open("POST","/group/acceptInvite",true);
                        xhttp.setRequestHeader("Content-Type","application/json");
                        xhttp.send(JSON.stringify(data));
                    }
                    else {
                        let http = new XMLHttpRequest();
                        http.onreadystatechange = function() {
                            if (this.readyState==4 && this.status == 200) {
                                alert(this.responseText);
                            }
                        }
                        let data={};
                        data["groupID"]=groupId;
                        data["inviteID"]=id;
                        xhttp.open("POST","/group/rejectInvite",true);
                        xhttp.setRequestHeader("Content-Type","application/json");
                        xhttp.send(JSON.stringify(data));
                    }
                }
                else {
                    let joinMessage = creatorName + " has requested to join your group.\n\nHere is their message:";
                    joinMessage += "\n\n" + message;
                    joinMessage +="\n\nPress OK to allow them to join."
                    if (confirm(joinMessage)) {
                        let data={};
                        data["groupID"]=groupId;
                        data["inviteID"]=id;
                        xhttp.open("POST","/group/acceptRequest",true);
                        xhttp.setRequestHeader("Content-Type","application/json");
                        xhttp.send(JSON.stringify(data));
                    }
                    else {
                        let http = new XMLHttpRequest();
                        http.onreadystatechange = function() {
                            if (this.readyState==4 && this.status == 200) {
                                alert(this.responseText);
                            }
                        }
                        let data={};
                        data["groupID"]=groupId;
                        data["inviteID"]=id;
                        xhttp.open("POST","/group/rejectRequest",true);
                        xhttp.setRequestHeader("Content-Type","application/json");
                        xhttp.send(JSON.stringify(data));
                    }
                }
            }
        }
    };
    xhttp.open("GET","/group/getInviteMessage",true);
    xhttp.send();
};

verifySearchQuery = () => {
    const content = document.getElementById("searchBarInput").value;
    if (content.length < 1) {
        document.getElementById("searchBarButton").disabled=true;
    }
    else {
        document.getElementById("searchBarButton").disabled=false;
    }
};

searchUser = () => {
    const content = document.getElementById("searchBarInput").value;
    if (content.length < 1) {
        document.getElementById("searchBarButton").disabled=true;
        return;
    }
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            const responseText = this.responseText;
            let div = document.getElementById("userSearchContainer");
            div.innerHTML="";
            if (responseText=="FAILURE") {
                div.innerHTML="Could Not Find Matching User"
            }
            else {
                let jsonData = JSON.parse(responseText);
                if (jsonData.length < 1) {
                    let notice = document.createElement("h4");
                    notice.innerHTML = "No Users Found";
                    div.appendChild(notice);
                }
                for (let i=0; i < jsonData.length; i++) {
                    const data = jsonData[i];
                    const id = data.id;
                    //const email = data.email;
                    const first_name = data.first_name;
                    //const last_name = data.last_name;
                    const friends = data.friends;
                    let hasSentRequest = false; //did the user send a request to this person
                    let hasRequestRecieved = false; //did the user recieve a request from this person
                    let hasRequestApproved = false; //did the request get approved
                    if (friends != undefined) {
                        for (let k=0; k < friends.length; k++) {
                            let friendInfo = friends[k].friends;
                            if (friendInfo != undefined) {
                                for (let x=0; x < friendInfo.length; x++) {
                                    const user_id = friendInfo[x].user_id;
                                    const friend_id = friendInfo[x].friend_id;
                                    const accepted = friendInfo[x].accepted;
                                    if (user_id == curUSRID) {
                                        hasSentRequest = true;
                                    }
                                    if (friend_id == curUSRID) {
                                        hasRequestRecieved = true;
                                    }
                                    if (accepted && (friend_id==curUSRID || user_id==curUSRID)) {
                                        hasRequestApproved = true;
                                    }
                                }
                            }
                        }
                    }
                    let rDiv = document.createElement("div");
                    rDiv.setAttribute("class","row");
                    let fDiv = document.createElement("div");
                    fDiv.setAttribute("class","col-2 text-center");
                    let uSpan = document.createElement("span");
                    uSpan.setAttribute("class","fa fa-user");
                    fDiv.appendChild(uSpan);
                    rDiv.appendChild(fDiv);
                    let contentDiv = document.createElement("div");
                    contentDiv.setAttribute("class","col-5 text-left");
                    let uName = document.createElement("a");
                    uName.setAttribute("href","/profile/show?id="+id.toString());
                    uName.setAttribute("class","white-link");
                    uName.innerHTML="  "+first_name;
                    contentDiv.appendChild(uName);
                    rDiv.appendChild(contentDiv);
                    let addDiv = document.createElement("div");
                    addDiv.setAttribute("class","col-4 text-right");
                    let uAdd = document.createElement("a");
                    uAdd.setAttribute("class","white-link");
                    if (hasRequestApproved) {
                        uAdd.setAttribute("href","/friendships/destroy?id="+id.toString());
                        uAdd.innerHTML="Remove Friend";
                    }
                    else if (hasSentRequest) {
                        uAdd.setAttribute("href","/friendships/destroy?id="+id.toString());
                        uAdd.innerHTML="Cancel Request";
                    }
                    else if (hasRequestRecieved) {
                        uAdd.setAttribute("href","/friendships/update?id="+id.toString());
                        uAdd.innerHTML="Approve Request";
                    }
                    else {
                        uAdd.setAttribute("href","/friendships/create?friend_id="+id.toString());
                        uAdd.innerHTML="Add Friend";
                    }
                    addDiv.appendChild(uAdd);
                    rDiv.appendChild(addDiv);
                    let endDiv = document.createElement("div");
                    endDiv.setAttribute("class","col-2 text-center");
                    rDiv.appendChild(endDiv);
                    div.appendChild(rDiv);
                }
            }
        }
    }
    let data={};
    data["content"]=content;
    xhttp.open("POST","/profile/list",true);
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
};


window.fbAsyncInit = function() {
    FB.init({
      appId      : '2120004598251262',
      cookie     : true,
      xfbml      : true,
      version    : 'v3.2'
    });
      
    FB.AppEvents.logPageView();   
      
  };

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "https://connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
