/*global verifyNewGroup*/
verifyNewGroup = () => {
    const password = document.getElementById('group_password').value;
    const password_confirmation = document.getElementById('group_password_confirmation').value;
    const description = document.getElementById('group_description').value;
    const name = document.getElementById('group_name').value;
    let passAlert = document.getElementById('groupPasswordAlert');
    let descAlert = document.getElementById('groupDescriptionAlert');
    let button = document.getElementById('group_submit_button');
    button.disabled=false;
    if (password != password_confirmation) {
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
    
    if (description=="" || name =="" || password=="" || password_confirmation=="") {
        button.disabled=true;
    }
};

/*global search*/
search = () => {
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
/*global sortTableByColumn*/
sortTableByColumn = (columnid,hasLink = false) => {
    let table, rows, switching, i, x, y, shouldSwitch;
    table = document.getElementById("grouptable");
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