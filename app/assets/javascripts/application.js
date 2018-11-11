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

checkForInvites = (hasMessages) => {
    if (!hasMessages) {
        return;
    }
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
            else if (responseText != "BAD") {
                const response = JSON.parse(responseText);
                const id = response.id;
                const groupId = response.groupId;
                const groupName = response.groupName;
                const message = response.message;
                let joinMessage = "You have been invited to join " + groupName;
                joinMessage += "\n\n" + message;
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
        }
    };
    xhttp.open("GET","/group/getInviteMessage",true);
    xhttp.send();
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
