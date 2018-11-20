getNewActivities = () => {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            const responseText = this.responseText;
            if (responseText != "Nothing New") {
                //parse JSON response
                const response = JSON.parse(responseText);
                const activityName = response.name;
                const activityID = response.id;
                const userName = response.userName;
                const duration = response.duration;
                const fullDuration = response.full_duration;
                const createdAt = response.created_at;
                const timestamp = response.timestamp;
                const datestamp = response.datestamp;
                const updated = response.updated;
                const currentUser = response.current_user;
                //load table
                let table = document.getElementById("activitytable");
                if (table.style.display=="none") {
                    table.style.display="";
                }
                //create new row
                let row = table.insertRow(1);
                if (currentUser) {
                    row.setAttribute("class","table-primary");
                }
                else {
                    row.setAttribute("class","table-info");
                }
                //create cell with activity name
                let nameCell = row.insertCell(0);
                let nameP = document.createElement("p");
                nameP.setAttribute("class","name");
                let a = document.createElement('a');
                const linkText = document.createTextNode(activityName);
                a.appendChild(linkText);
                a.title = activityName;
                a.href = "javascript:void(0)";
                a.click = function(){getActivity(activityID)};
                a.setAttribute("name","activityName");
                a.setAttribute("data-toggle","modal");
                a.setAttribute("data-target","#viewActivityModal");
                nameP.appendChild(a);
                nameCell.appendChild(nameP);
                //create cell with duration
                let durationCell = row.insertCell(1);
                let durationP = document.createElement('p');
                durationP.setAttribute("class","duration");
                durationP.setAttribute("name",duration);
                durationP.innerHTML = fullDuration;
                durationCell.appendChild(durationP);
                let userCell = row.insertCell(2);
                let userP = document.createElement("p");
                userP.setAttribute("class","user");
                userP.innerHTML = userName;
                userCell.appendChild(userP);
                //create cell with timestamp
                let timestampCell = row.insertCell(3);
                let timestampP = document.createElement("p");
                timestampP.setAttribute("class","timestamp");
                timestampP.setAttribute("id",createdAt);
                timestampP.innerHTML = timestamp;
                timestampCell.appendChild(timestampP);
                //create cell with datestamp
                let datestampCell = row.insertCell(4);
                let datestampP = document.createElement("p");
                datestampP.setAttribute("class","timestamp");
                datestampP.innerHTML = datestamp;
                datestampCell.appendChild(datestampP);
                setActivityTableRows(1,25);
                updatePageLinks(25);
            }
        }
    };
    xhttp.open("GET","/activity/getNewActivities",true);
    xhttp.send();
};

deleteActivity = (actID,activityName,rowI) => {
    if (confirm("Are you sure you want to delete "+activityName+"?")) {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState ==4 && this.status == 200) {
                if (this.responseText == "Success") {
                    document.getElementById("activitytable").deleteRow(rowI);
                }
            }
        };
        xhttp.open("delete","/activity/delete",true);
        let data = {};
        data["id"] = actID;
        xhttp.setRequestHeader("Content-Type","application/json");
        xhttp.send(JSON.stringify(data));
        getNewActivities();
        if (document.getElementById("activitytable").rows.length <= 1) {
            document.getElementById("activitytable").style.display="none";
        }
    }
};

getFullDuration = (duration) => {
    if (duration <= 0) {
        return "User did not do this."
    }
    const hours = Math.floor(duration / 60);
    const rawMinutes = (duration - (hours*60));
    const minutes = Math.floor(rawMinutes);
    seconds = Math.round((rawMinutes-minutes)*60)
    msg = ""
    if (hours > 0) {
        if (hours == 1) {
            msg+=hours.toString() + " hour";
        }
        else {
            msg+=hours.toString() + " hours";
        }
        if (minutes > 0 && seconds > 0) {
            msg += ", ";
        }
        else if (minutes >0 || seconds > 0) {
            msg += " and ";
        }
    }
    if (minutes > 0) {
        if (minutes == 1) {
            msg+=minutes.toString() + " minute";
        }
        else {
            msg+=minutes.toString() + " minutes";
        }
        if (hours >0 && seconds >0) {
            msg += ", and ";
        }
        else if (seconds > 0) {
            msg += " and ";
        }
    }
    if (seconds > 0) {
        if (seconds==1) {
            msg += seconds.toString() + " second";
        }
        else {
            msg += seconds.toString() + " seconds";
        }
    }
    return msg;
};

editActivity = (optVal,duration,actID,rowActElement,rowActName,rowDurElement) => {
    if (duration <=0) {
        alert("You cannot have an activity with a duration less than 0");
    }
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState ==4 && this.status == 200) {
            if (this.responseText == "Success") {
                rowActElement.name = rowActName;
                rowActElement.innerHTML = rowActName;
                rowDurElement.innerHTML = getFullDuration(duration);
            }
        }
    };
    xhttp.open("POST","/activity/update",true);
    let data = {};
    data["activity"]={};
    data["activity"]["actid"]=optVal;
    data["activity"]["duration"]=duration;
    data["activity"]["aid"]=actID;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
    getNewActivities();
};

getActivity = (actID) => {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            const responseText = this.responseText
            if (responseText != "Does Not Exist") {
                const response = JSON.parse(responseText)
                const activityName = response.name;
                const activityID = response.id;
                const userName = response.userName;
                const duration = response.duration;
                const fullDuration = response.full_duration;
                const createdAt = response.created_at;
                const updatedAt = response.updated_at;
                const timestamp = response.timestamp;
                const datestamp = response.datestamp;
                const updatedTimestamp = response.timestamp_u;
                const updatedDatestamp = response.datestamp_u;
                const updated = response.updated;
                const currentUser = response.current_user;
                
                let activityTitle = document.getElementById("activityTitle");
                activityTitle.innerHTML=activityName+" performed by "+userName;
                
                let activityDuration = document.getElementById("activityDuration");
                activityDuration.innerHTML = userName+" engaged in <strong>"+activityName+"</strong> for "+fullDuration.toString()+", at "+timestamp+" on "+datestamp+".";
                
                let activityTimestampMessage = document.getElementById("activityTimestampMessage");
                if (updated) {
                    activityTimestampMessage.innerHTML="Activity was last updated at "+updatedTimestamp+" on "+updatedDatestamp+" by "+userName+".";
                }
                else {
                    activityTimestampMessage.innerHTML=userName+" registered this activity at "+timestamp+" on "+datestamp+".";
                }
                document.getElementById("currentUserContainer").innerHTML="";
                if (currentUser) {
                    let table = document.getElementById("activitytable");
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
                    const rowDurElement = rowElements[1].getElementsByTagName("p")[0];
                    let rowActDuration = rowElements[1].getElementsByTagName("p")[0].innerHTML;
                    let uContainer = document.getElementById("currentUserContainer");
                    let editButton = document.createElement("button");
                    editButton.innerHTML="Edit Entry";
                    editButton.setAttribute("class","btn btn-primary btn-large");
                    editButton.setAttribute("type","button");
                    editButton.setAttribute("data-toggle","collapse");
                    editButton.setAttribute("data-target","#editDIV");
                    let deleteButton = document.createElement("button");
                    deleteButton.innerHTML="Delete Entry";
                    deleteButton.setAttribute("class","btn btn-danger btn-large");
                    deleteButton.setAttribute("type","submit");
                    deleteButton.setAttribute("data-dismiss","modal");
                    deleteButton.onclick=function() {deleteActivity(actID,activityName,rowI)};
                    let editDIV = document.createElement("div");
                    editDIV.setAttribute("class","collapse gradient-buttons justify-content-left block-left text-left")
                    editDIV.id="editDIV";
                    let form = document.createElement("form");
                    form.id = "edit_activity_"+actID.toString();
                    let div1 = document.createElement("div");
                    div1.setAttribute("class","form-group");
                    let actIDLabel = document.createElement("label");
                    actIDLabel.setAttribute("for","activity_actid");
                    actIDLabel.innerHTML = "Choose Activity Type";
                    div1.appendChild(actIDLabel);
                    let actIDSelect = document.createElement("select");
                    actIDSelect.id="activity_actid";
                    actIDSelect.setAttribute("class","form-control");
                    let options = document.getElementsByClassName("activityOption");
                    for (let i=0;i<options.length;i++) {
                        let option = options[i].cloneNode(true);
                        actIDSelect.appendChild(option);
                        if (option.innerHTML.includes(rowActName)) {
                            actIDSelect.selectedIndex=i;   
                        }
                    }
                    div1.appendChild(actIDSelect);
                    form.appendChild(div1);
                    let div2 = document.createElement("div");
                    div2.setAttribute("class","form-group");
                    let activityDurationLabel = document.createElement("activityDurationLabel");
                    activityDurationLabel.setAttribute("for","activity_duration");
                    activityDurationLabel.innerHTML = "Edit Activity Duration";
                    div2.append(activityDurationLabel);
                    let activityDurationInput = document.createElement("input");
                    activityDurationInput.id = "activity_duration";
                    activityDurationInput.setAttribute("class","form-control");
                    activityDurationInput.setAttribute("step","any");
                    activityDurationInput.setAttribute("type","number");
                    activityDurationInput.setAttribute("min","1");
                    activityDurationInput.min = 1;
                    activityDurationInput.value = parseInt(rowActDuration,10);
                    div2.appendChild(activityDurationInput);
                    form.appendChild(div2);
                    let div3 = document.createElement("div");
                    div3.setAttribute("class","form-group gradient-buttons justify-content-center block-center text-center");
                    let button = document.createElement("button");
                    button.setAttribute("class","btn btn-primary btn-large");
                    button.setAttribute("type","button");
                    button.setAttribute("data-dismiss","modal");
                    button.onclick = (function() {
                        const duration = document.getElementById("activity_duration").value;
                        const opt = document.getElementById("activity_actid");
                        const optVal = opt[opt.selectedIndex].value;
                        const rAName = opt[opt.selectedIndex].innerHTML;
                        editActivity(optVal,duration,actID,rowActElement,rAName,rowDurElement);
                    });
                    button.innerHTML="Submit Edit";
                    div3.appendChild(button);
                    form.appendChild(div3);
                    editDIV.appendChild(form);
                    uContainer.appendChild(editDIV);
                    uContainer.appendChild(editButton);
                    uContainer.appendChild(deleteButton);
                }
                
                
            }
        }
    };
    xhttp.open("post","/activity/getActivity",true);
    let data={};
    data["actid"]=actID;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
};

submitNewActivity = () => {
    let activitySelect=document.getElementById("activities_actid");
    let activitySelectValue = activitySelect[activitySelect.selectedIndex].value;
    activitySelect.selectedIndex = 0;
    let activityInput = document.getElementById("activities_duration");
    let activityInputValue = activityInput.value;
    if (activityInput.value <= 0) {
        alert("You cannot have an activity with a duration less than 0");
    }
    activityInput.value = "";
    let userId = document.getElementById("activities_userid");
    let userIdValue = userId.value;
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {};
    xhttp.open("POST","/activity/create",true);
    let data = {};
    data["activities"]={};
    data["activities"]["actid"]=activitySelectValue;
    data["activities"]["duration"]=activityInputValue;
    data["activities"]["userid"]=userIdValue;
    xhttp.setRequestHeader("Content-Type","application/json");
    xhttp.send(JSON.stringify(data));
    getNewActivities();
}


updatePageLinks = (interval,page=1) => {
    let ul = document.getElementById("pageLinks");
    ul.innerHTML="";
    const pages = Math.ceil((document.getElementById('activitytable').rows.length-1) / interval);
    if (pages > 1) {
        for (let i=1;i<pages;i++) {
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
                setActivityTableRows(i,interval);
            };
            li.appendChild(a);
            ul.appendChild(li);
        }
    }
};
removePageLinks = () => {
    document.getElementById("pageLinks").innerHTML="";
};

setActivityTableRows = (page,interval) => {
    let table = document.getElementById('activitytable');
    if (table==undefined) {
        return false;
    }
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
    updatePageLinks(interval,page);
    return true;
};

automateActivityAJAX = () => {
    if (setActivityTableRows(1,25)) {
        window.setInterval(getNewActivities,5000);
    }
};

/*global sortActivityTableByColumn*/
sortActivityTableByColumn = (columnid,hasLink = false,number=false,timeStamp=false) => {
    let table, rows, switching, i, x, y, shouldSwitch;
    table = document.getElementById("activitytable");
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
                x = rows[i].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0].getElementsByTagName("a")[0].innerHTML.toLowerCase();
                y = rows[i + 1].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0].getElementsByTagName("a")[0].innerHTML.toLowerCase();
            }
            else if (timeStamp) {
                x = rows[i].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0].id;
                y = rows[i + 1].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0].id;
            }
            else if (number) {
                x = parseInt(rows[i].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0].getAttribute("name"),10);
                y = parseInt(rows[i + 1].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0].getAttribute("name"),10);
            }
            else {
                x = rows[i].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0].innerHTML.toLowerCase();
                y = rows[i + 1].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0].innerHTML.toLowerCase();
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
    setActivityTableRows(1,25);
};
/*global sortActivityTableByTime*/
sortActivityTableByTime = () => {
    let table, rows, switching, i, x, y, shouldSwitch;
    table = document.getElementById("activitytable");
    switching = true;
    let goingUp = table.getElementsByTagName("th")[3].getElementsByTagName("a")[0].className == "UP";
    if (goingUp) {
        table.getElementsByTagName("th")[3].getElementsByTagName("a")[0].className = "DOWN";
    }
    else {
        table.getElementsByTagName("th")[3].getElementsByTagName("a")[0].className = "UP";
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
            const x = rows[i].getElementsByTagName("td")[3].getElementsByTagName("p")[0].id;
            const y = rows[i + 1].getElementsByTagName("td")[3].getElementsByTagName("p")[0].id;
            //check if the two rows should switch place:))
            if (goingUp) {
                if (x < y) {
                    shouldSwitch = true;
                    break;
                }
            }
            else {
                if (x > y) {
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
    setActivityTableRows(1,25);
};

/*global activitySearch*/
activitySearch = () => {
    const input = document.getElementById('activitySearchInput');
    const filter = input.value.toLowerCase();
    if (filter.length > 0) {
        const table = document.getElementById('activitytable');
        let rows = table.rows;
        for (let i = 1; i < rows.length; i++) {
            let td = rows[i].getElementsByTagName('td');
            let x = 0;
            switch (document.getElementById('activitySearchSelect').value) {
                case 'Activity Type':
                    x = 0;
                    break;
                case 'Duration':
                    x=1;
                    break;
                case 'Performer':
                    x=2;
                    break;
                default:
                    x=0;
                    break;
            }
            let p = td[x].getElementsByTagName('p')[0];
            let val;
            if (p.className=="name") {
                val = p.getElementsByTagName('a')[0].innerHTML.toLowerCase();
            }
            else {
                val = p.innerHTML.toLowerCase();
            }
            if (val.indexOf(filter) > -1) {
                rows[i].style.display="";
            }
            else {
                rows[i].style.display="none";
            }
        }
    }
    if (filter.length < 1) {
        setActivityTableRows(1,25);
    }
    else {
        removePageLinks();
    }
};
