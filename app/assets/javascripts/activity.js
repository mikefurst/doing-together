/*global sortActivityTableByColumn*/
sortActivityTableByColumn = (columnid,hasLink = false) => {
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
                x = rows[i].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0].getElementsByTagName("a")[0];
                y = rows[i + 1].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0].getElementsByTagName("a")[0];
            }
            else {
                x = rows[i].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0];
                y = rows[i + 1].getElementsByTagName("td")[columnid].getElementsByTagName("p")[0];
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
};

/*global activitySearch*/
activitySearch = () => {
    const input = document.getElementById('activitySearchInput');
    const filter = input.value.toLowerCase();
    const table = document.getElementById('activitytable');
    let rows = table.rows;
    for (let i = 1; i < rows.length; i++) {
        let td = rows[i].getElementsByTagName('td');
        let found = false;
        let x = 0;
        switch (document.getElementById('activitySearchSelect').value) {
            case 'Activity Type':
                x = 0;
                break;
            case 'Duration':
                x=1;
                break;
            case 'Person Who Done It':
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
            found = true;
        }
        else {
            rows[i].style.display="none";
        }
    }
};