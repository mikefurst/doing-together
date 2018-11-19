// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

updateProfile = () => {
    const first_name = document.getElementById("user_first_name").value;
    const last_name = document.getElementById("user_last_name").value;
    const isPrivate = document.getElementById("user_isPrivate").value;
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status=="200") {
            if (this.responseText=="Success") {
                window.location.reload();
            }
        }
    };
    xhttp.open("POST","/profile/update",true);
    let data = {};
    data["id"] = document.getElementById("user_userid").value;
    data["user"]={};
    data["user"]["first_name"]=first_name;
    data["user"]["last_name"]=last_name;
    data["user"]["isPrivate"]=isPrivate;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
}