activityTypeSearch = () => {
    const input = document.getElementById('activityTypeSearchInput');
    const filter = input.value.toLowerCase();
    const table = document.getElementById('activitytypetable');
    let rows = table.rows;
    for (let i = 1; i < rows.length; i++) {
        let td = rows[i].getElementsByTagName('td');
        let found = false;
        let x = 0;
        switch (document.getElementById('activityTypeSearchSelect').value) {
            case 'Name':
                x = 0;
                break;
            case 'Score':
                x=1;
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

sortActivityTypeTableByColumn = (columnid,hasLink = false) => {
    let table, rows, switching, i, x, y, shouldSwitch;
    table = document.getElementById("activitytypetable");
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
                x = rows[i].getElementsByTagName("td")[columnid].getElementsByTagName("a")[0];
                y = rows[i + 1].getElementsByTagName("td")[columnid].getElementsByTagName("a")[0];
            }
            else {
                x = rows[i].getElementsByTagName("td")[columnid];
                y = rows[i + 1].getElementsByTagName("td")[columnid];
            }
            //check if the two rows should switch place:))
            if (goingUp) {
                if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                    //if so, mark as a switch and break the loop:
                    shouldSwitch = true;
                    break;
                }
            }
            else {
                if (x.innerHTML.toLowerCase() < y.innerHTML.toLowerCase()) {
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
};

verifyActivityType = () => {
    let actTypeName = document.getElementById("activitytypes_name").value;
    let actTypeMod = document.getElementById("activitytypes_score").value;
    let button = document.getElementById("submitNewActivityTypeButton");
    if (actTypeName.length < 5 || actTypeName.length > 50) {
        button.disabled=true;
        return false;
    }
    if (actTypeMod.length==0) {
        button.disabled=true;
        return false;
    }
    button.disabled=false;
    return true;
}

submitNewActivityType = () => {
    let actTypeName = document.getElementById("activitytypes_name").value;
    let actTypeMod = document.getElementById("activitytypes_score").value;
    if (!verifyActivityType()) {
        alert("Activity Type is not valid.")
        return;
    }
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            if (this.responseText=="Failure_E") {
                alert("Error creating activity type. An activity type already exists with that name.");
            }
            else if (this.responseText=="Success_V") {
                window.location.reload();  
            }
            else if (this.responseText=="Success") {
                window.location.reload();
            }
            else if (this.responseText=="Failure") {
                alert("Failed to create the activity type. Please verify what you have entered is valid.");
            }
        }
    };
    xhttp.open("POST","/activity_type/create",true);
    let data = {};
    data["activitytypes"]={};
    data["activitytypes"]["name"]=actTypeName;
    data["activitytypes"]["score"]=actTypeMod;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
};

verifyActivity = (actID,rActtVer) => {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState ==4 && this.status == 200) {
            if (this.responseText == "Success") {
                rActtVer.innerHTML = "Approved and Ready For Use";
            }
        }
    };
    xhttp.open("POST","/activity_type/verify",true);
    let data = {};
    data["id"] = actID;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
};

editActivityType = (actID,acttName,acttScore,rActtName,rActtScore,rActtVer=undefined) => {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState ==4 && this.status == 200) {
            if (this.responseText == "Success") {
                rActtName.innerHTML = acttName;
                rActtScore.innerHTML = acttScore;
                if (rActtVer != undefined) {
                    rActtVer.innerHTML = "Approved and Ready For Use";
                }
            }
        }
    };
    xhttp.open("POST","/activity_type/update",true);
    let data = {};
    data["id"] = actID;
    data["activity_type"]={};
    data["activity_type"]["name"]=acttName;
    data["activity_type"]["score"]=acttScore;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
};

getActivityType = (actID) => {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            const responseText = this.responseText
            if (responseText == "Does Not Exist") {
                alert("Unable to find the activity type you selected.")
            }
            else if (responseText=="Cannot Access") {
                alert("You do not have access to the activity type you selected.");
            }
            else {
                const response = JSON.parse(responseText)
                const activityTypeName = response.name;
                const activityTypeID = response.id;
                const modifier = response.modifier;
                const verified = response.verified;
                const groupAdmin = response.groupAdmin;
                const selfOwned = response.selfOwned;
                let activityTitle = document.getElementById("activityTypeTitle");
                activityTitle.innerHTML=activityTypeName;
                
                document.getElementById("adminContainer").innerHTML="";
                if (groupAdmin || selfOwned) {
                    let table = document.getElementById("activitytypetable");
                    let rows = table.rows;
                    let row;
                    let rowI;
                    for (let i=0;i<rows.length;i++) {
                        if (rows[i].id == "act"+actID.toString()) {
                            row = rows[i];
                            rowI = i;
                            break;
                        }
                    }
                    let rowElements = row.getElementsByTagName("td");
                    const rowActElement = rowElements[0].getElementsByTagName("a")[0];
                    let rowActName = rowElements[0].getElementsByTagName("a")[0].name;
                    const rowScoreElement = rowElements[1];
                    let rowActScore = rowElements[1].innerHTML;
                    let rowVerElement = undefined;
                    let rowActVer = undefined;
                    if (groupAdmin) {
                        rowVerElement = rowElements[2];
                        rowActVer = rowElements[2].innerHTML;
                    }
                    let adminContainer = document.getElementById("adminContainer");
                    let editButton = document.createElement("button");
                    editButton.innerHTML="Edit Entry";
                    editButton.setAttribute("class","btn btn-primary btn-large");
                    editButton.setAttribute("type","button");
                    editButton.setAttribute("data-toggle","collapse");
                    editButton.setAttribute("data-target","#editDIV");
                    let editDIV = document.createElement("div");
                    editDIV.setAttribute("class","collapse gradient-buttons justify-content-left block-left text-left");
                    editDIV.id="editDIV";
                    let message = document.createElement("p");
                    if (groupAdmin) {
                        message.innerHTML = "As group administrator any changes you make to this activity type automaticaly are aproved and verified for all users in your group.";
                    }
                    else {
                        message.innerHTML = "Since you are currently not in any group, the changes you make to this activity type will be restricted solely to you."
                    }
                    editDIV.appendChild(message);
                    editDIV.appendChild(document.createElement('br'));
                    let form = document.createElement("form");
                    form.id = "edit_activity_type"+actID.toString();
                    let div1 = document.createElement("div");
                    div1.setAttribute("class","form-group");
                    let activityTypeNameLabel = document.createElement("label");
                    activityTypeNameLabel.setAttribute("for","activity_type_name");
                    activityTypeNameLabel.innerHTML = "Activity Type Name";
                    div1.appendChild(activityTypeNameLabel);
                    let activityTypeNameInput = document.createElement("input");
                    activityTypeNameInput.id="activity_type_name";
                    activityTypeNameInput.setAttribute("class","form-control");
                    activityTypeNameInput.setAttribute("maxlength","50");
                    activityTypeNameInput.setAttribute("minlength","5");
                    activityTypeNameInput.value = activityTypeName;
                    div1.appendChild(activityTypeNameInput);
                    form.appendChild(div1);
                    let div2 = document.createElement("div");
                    div2.setAttribute("class","form-group");
                    let activityTypeScoreLabel = document.createElement("label");
                    activityTypeScoreLabel.setAttribute("for","activity_type_score");
                    activityTypeScoreLabel.innerHTML = "Edit Activity Score Modifier";
                    div2.append(activityTypeScoreLabel);
                    let activityTypeScore = document.createElement("input");
                    activityTypeScore.id = "activity_type_score";
                    activityTypeScore.setAttribute("class","form-control");
                    activityTypeScore.setAttribute("step","any");
                    activityTypeScore.setAttribute("type","number");
                    activityTypeScore.value = parseFloat(modifier);
                    div2.appendChild(activityTypeScore);
                    form.appendChild(div2);
                    let div3 = document.createElement("div");
                    div3.setAttribute("class","form-group gradient-buttons justify-content-center block-center text-center");
                    let button = document.createElement("button");
                    button.setAttribute("class","btn btn-primary btn-large");
                    button.setAttribute("type","button");
                    button.setAttribute("data-dismiss","modal");
                    button.onclick = (function() {
                        const mod = document.getElementById("activity_type_score");
                        const modVal = mod.value;
                        const acttName = document.getElementById("activity_type_name");
                        const acttNameVal = acttName.value;
                        editActivityType(actID,acttNameVal,modVal,rowActElement,rowScoreElement,rowVerElement);
                    });
                    button.innerHTML="Submit Edit";
                    div3.appendChild(button);
                    form.appendChild(div3);
                    editDIV.appendChild(form);
                    adminContainer.appendChild(editDIV);
                    adminContainer.appendChild(editButton);
                    if (!verified && groupAdmin) {
                        let verifyButton = document.createElement("button");
                        verifyButton.innerHTML="Verify Entry";
                        verifyButton.id = "verifyButton";
                        verifyButton.setAttribute("class","btn btn-danger btn-large");
                        verifyButton.setAttribute("type","submit");
                        verifyButton.setAttribute("data-dismiss","modal");
                        verifyButton.onclick=function() {verifyActivity(actID,rowVerElement)};
                        adminContainer.appendChild(verifyButton);
                    }
                }
                else {
                    let h4 = document.createElement("H4");
                    if (verified) {
                        h4.innerHTML="This activity type has been verified and can be used on the activity log to register new activites.";
                    }
                    else {
                        h4.innerHTML="This activity type is not yet verified. Once your group's administrator has verified it you will be able to use it on the activity log to register new activities.";
                    }
                    document.getElementById("adminContainer").appendChild(h4);
                }
                
            }
        }
    };
    xhttp.open("post","/activity_type/getActivityType",true);
    let data={};
    data["actid"]=actID;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
};