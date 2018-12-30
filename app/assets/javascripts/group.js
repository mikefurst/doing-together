function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

groupIndexPageOnLoad = () => {
    setGroupTableRows(1,25);
}

changeLabel = () => {
    document.getElementById("templateLabel").innerHTML=document.getElementById("group_select")[document.getElementById("group_select").selectedIndex].value;
}

verifyNewGroup = () => {
    let passwordCheck = document.getElementById('group_password').value;
    let password_confirmation = document.getElementById('group_password_confirmation').value;
    let description = document.getElementById('group_description').value;
    let name = document.getElementById('group_name').value;
    let passAlert = document.getElementById('groupPasswordAlert');
    let descAlert = document.getElementById('groupDescriptionAlert');
    let button = document.getElementById('group_submit_button');
    button.disabled=false;
    if (passwordCheck != password_confirmation) {
        passAlert.style.visibility="visible";
        button.disabled=true;
    }
    else {
        passAlert.style.visibility="hidden";
    }
    
    if (description==name) {
        descAlert.style.visibility="visible";
        button.disabled=true;
    }
    else {
        descAlert.style.visibility="hidden";
    }
    
    if (description=="" || name =="" || passwordCheck=="" || password_confirmation=="") {
        button.disabled=true;
    }
    if (description.length < 15 || description.length > 150 ) {
        button.disabled = true;
    }
    if (name.length < 10 || name.length > 50 ) {
        button.disabled = true;
    }
    return !button.disabled;
};

groupSearch = () => {
    const input = document.getElementById('groupSearchInput');
    const filter = input.value.toLowerCase();
    const table = document.getElementById('grouptable');
    let rows = table.rows;
    for (let i = 1; i < rows.length; i++) {
        let td = rows[i].getElementsByTagName('td');
        let found = false;
        let x = 0;
        switch (document.getElementById('groupSearchSelect').value) {
            case 'Group Name':
                x = 0;
                break;
            case 'Group Description':
                x=1;
                break;
            case 'Number of Members':
                x=2;
                break;
            default:
                x=0;
                break;
        }
        let t = td[x];
        let val;
        if (t.className=="name") {
            val = t.getElementsByTagName('a')[0].innerHTML.toLowerCase();
        }
        else {
            val = t.innerHTML.toLowerCase();
        }
        if (val.indexOf(filter) > -1) {
            rows[i].style.display="";
            found = true;
        }
        else {
            rows[i].style.display="none";
        }
    }
};

sortGroupTableByColumn = (columnid,tableID,hasLink = false,sortByID=false) => {
    let table, rows, switching, i, x, y, shouldSwitch;
    table = document.getElementById(tableID);
    switching = true;
    let goingUp = table.getElementsByTagName("th")[columnid].getElementsByTagName("a")[0].className == "UP";
    if (goingUp) {
        table.getElementsByTagName("th")[columnid].getElementsByTagName("a")[0].className = "DOWN";
    }
    else {
        table.getElementsByTagName("th")[columnid].getElementsByTagName("a")[0].className = "UP";
    }
    /*Make a loop that will continue until
    no switching has been done:*/
    while (switching) {
        //start by saying: no switching is done:
        switching = false;
        rows = table.rows;
        /*Loop through all table rows (except the
        first, which contains table headers):*/
        for (i = 1; i < (rows.length - 1); i++) {
            //start by saying there should be no switching:
            shouldSwitch = false;
            /*Get the two elements you want to compare,
            one from current row and one from the next:*/
            let x,y;
            if (hasLink) {
                x = rows[i].getElementsByTagName("td")[columnid].getElementsByTagName("a")[0].innerHTML.toLowerCase();
                y = rows[i + 1].getElementsByTagName("td")[columnid].getElementsByTagName("a")[0].innerHTML.toLowerCase();
            }
            else if (sortByID) {
                x = rows[i].getElementsByTagName("td")[columnid].id;
                y = rows[i+1].getElementsByTagName("td")[columnid].id;
            }
            else {
                x = rows[i].getElementsByTagName("td")[columnid].innerHTML.toLowerCase();
                y = rows[i + 1].getElementsByTagName("td")[columnid].innerHTML.toLowerCase();
            }
            if (!isNaN(x) && !isNaN(y)) {
                x = parseInt(x,10);
                y = parseInt(y,10);
            }
            //check if the two rows should switch place:))
            if (goingUp) {
                if (x > y) {
                    //if so, mark as a switch and break the loop:
                    shouldSwitch = true;
                    break;
                }
            }
            else {
                if (x < y) {
                    //if so, mark as a switch and break the loop:
                    shouldSwitch = true;
                    break;
                }
            }
        }
        if (shouldSwitch) {
            /*If a switch has been marked, make the switch
            and mark that a switch has been done:*/
            rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
            switching = true;
        }
    }
    setGroupTableRows(1,25);
};

setGroupTableRows = (page,interval) => {
    let table = document.getElementById('grouptable');
    let rows = table.rows;
    const len = rows.length
    const start = (interval * (page-1))+1;
    const end = ((interval*page)<len) ? (interval*page) : (len);
    if (len >= interval*page) {
        for (let i=1; i<=len-1; i++) {
            if (start <= i && i <= end) {
                rows[i].style.display="";
            }
            else {
                rows[i].style.display="none";
            }
        }
    }
    updateGroupPageLinks(interval,page);
};

updateGroupPageLinks = (interval,page) => {
    let ul = document.getElementById("pageLinks");
    ul.innerHTML="";
    const pages = Math.ceil((document.getElementById('grouptable').rows.length-1) / interval);
    if (pages > 1) {
        for (let i=1;i<=pages;i++) {
            let li = document.createElement('li');
            if (i==page) {
                li.className = "page-item active";
            }
            else {
                li.className = "page-item";
            }
            li.id=i.toString();
            let a = document.createElement("a");
            let linkText = document.createTextNode(i.toString()+" ");
            a.appendChild(linkText);
            a.title = i.toString();
            a.className = "page-link";
            a.href = "javascript:void(0)";
            a.onclick = function() {
                setGroupTableRows(i,interval);
            };
            li.appendChild(a);
            ul.appendChild(li);
        }
    }
};



/*Code for group messaging*/
registerGroupMessagingActivity = () =>{
    window.setInterval(loadNewMessage,1000);
};

loadNewMessage = () => {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            const responseText = this.responseText
            if (responseText != "Nothing New") {
                const response = JSON.parse(responseText)
                const message = response.message;
                const userName = response.userName;
                const createdAt = response.createElement;
                const timestamp = response.timestamp;
                const currentUser = response.current_user
                let table = document.getElementById("messageTable");
                let row = table.insertRow(-1);
                let nameCell = row.insertCell(0);
                nameCell.className = "username";
                if (currentUser) {
                    nameCell.innerHTML="You:";
                }
                else {
                    nameCell.innerHTML=userName;
                }
                let messageCell=row.insertCell(1);
                messageCell.setAttribute("class","message col-sm-10 text-sm-left");
                messageCell.innerHTML=message;
            }
        }
        else if (this.readyState == 4 && this.status == 400) {
            
        }
    };
    xhttp.open("POST","/group/getNewMessage",true);
    let data = {};
    data["id"] = getUrlVars()["id"];
    xhttp.send();
};

submitMessage = () => {
    let submitInput = document.getElementById("messageInput");
    if (submitInput.value.length > 140) {
        alert("You cannot send a message with a length exceeding 140 characters.");
        return;
    }
    if (submitInput.value.length <= 0) {
        alert("You cannot send a blank message.");
        return;
    }
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {};
    xhttp.open("POST","/group/submitmessage",true);
    let data = {};
    data["message"]=submitInput.value;
    data["id"]=getUrlVars()["id"];;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
    submitInput.value="";
};

createGroup = () => {
    if (verifyNewGroup()) {
        let passwordCheck = document.getElementById('group_password').value;
        let password_confirmation = document.getElementById('group_password_confirmation').value;
        let description = document.getElementById('group_description').value;
        let name = document.getElementById('group_name').value;
        let select = document.getElementById("group_select");
        let option = select[select.selectedIndex].id;
        let button = document.getElementById('group_submit_button');
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status=="200") {
                if (this.responseText == "ERROR") {
                    document.getElementById("ERROR").innerHTML="There was an error creating your group. Please try again.";
                }
                else {
                    window.location.replace("/group/view?id="+this.responseText);
                    window.location.href("/group/view?id="+this.responseText);
                }
            }
        };
        xhttp.open("POST","/group/create",true);
        let data = {};
        data["group"] = {};
        data["group"]["name"]=name;
        data["group"]["description"]=description;
        data["group"]["password"]=passwordCheck;
        data["group"]["password_confirmation"]=password_confirmation;
        data["group"]["template"]=option;
        xhttp.setRequestHeader("Content-Type","application/json");
        xhttp.send(JSON.stringify(data));
    }
};

checkEmail = () => {
    const email = document.getElementById("userEmail").value;
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if (!re.test(String(email).toLowerCase())) {
        alert("Invalid Email");
        document.getElementById("userEmail").style.borderColor="red";
        document.getElementById("userEmail").style.borderWidth=5;
        document.getElementById("emailButton").style.borderColor="red";
        document.getElementById("emailButton").style.borderWidth=5;
        document.getElementById("createInviteButton").disabled=true;
        return false;
    }
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status=="200") {
            const rText = this.responseText;
            if (rText == "User can be invited") {
                document.getElementById("userEmail").style.borderColor="green";
                document.getElementById("userEmail").style.borderWidth=5;
                document.getElementById("emailButton").style.borderColor="green";
                document.getElementById("emailButton").style.borderWidth=5;
                document.getElementById("createInviteButton").disabled=false;
                return true;
            }
            else {
                alert(rText);
                document.getElementById("userEmail").style.borderColor="red";
                document.getElementById("userEmail").style.borderWidth=5;
                document.getElementById("emailButton").style.borderColor="red";
                document.getElementById("emailButton").style.borderWidth=5;
                document.getElementById("createInviteButton").disabled=true;
                return false;
            }
        }
    };
    xhttp.open("POST","/group/verifyUserCanBeAddedToGroup",true);
    let data = {};
    data["userEmail"] = email;
    data["id"] = getUrlVars()["id"];
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
};
createNewInvite = () => {
    if (!checkEmail()) {
        if (document.getElementById("createInviteButton").disabled) {
            return;
        }
    }
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status=="200") {
            if (this.responseText=="Success") {
                alert(document.getElementById("userEmail").value+" has been invited to join the group.")
                document.getElementById("inviteMessage").value="%username%,\nCome join our group to engage in activities together.";
                document.getElementById("userEmail").value="";
            }
            else {
                alert("Error inviting the user to join your group. Please try again later");
            }
        }
    };
    xhttp.open("POST","/group/createNewInvite",true);
    let data = {};
    data["email"] = document.getElementById("userEmail").value;
    data["message"] = document.getElementById("inviteMessage").value;
    data["id"] = getUrlVars()["id"];
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
};

submitRequestToJoin = (groupId) => {
    var xhttp = new XMLHttpRequest();
    if (document.getElementById("joinMessage"+groupId.toString()).value.length <= 0) {
        alert("You must enter a message with your request to join.");
        return;
    }
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status=="200") {
            if (this.responseText=="Success") {
                alert("Your request to join has been sent.");
                window.location.reload();
            }
            else {
                alert("Error Requesting to Join");
            }
        }
    };
    xhttp.open("POST","/group/requestNewInvite",true);
    let data = {};
    data["groupID"] = groupId;
    data["message"] = document.getElementById("joinMessage"+groupId.toString()).value;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
};