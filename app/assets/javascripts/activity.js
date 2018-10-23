/* global sortTableByColumn */
sortTableByColumn = (columnid,hasLink = false) => {
    let table, rows, switching, i, x, y, shouldSwitch;
    table = document.getElementById("activitytable");
    switching = true;
    let goingUp = table.getElementsByTagName("th")[columnid].getElementsByTagName("a")[0].className == "UP"
    if (goingUp) {
        table.getElementsByTagName("th")[columnid].getElementsByTagName("a")[0].className = "DOWN"
    }
    else {
        table.getElementsByTagName("th")[columnid].getElementsByTagName("a")[0].className = "UP"
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
            let x,y
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
}
/* global sortTableByTime */
sortTableByTime = () => {
    let table, rows, switching, i, x, y, shouldSwitch;
    table = document.getElementById("activitytable");
    switching = true;
    let goingUp = table.getElementsByTagName("th")[3].getElementsByTagName("a")[0].className == "UP"
    if (goingUp) {
        table.getElementsByTagName("th")[3].getElementsByTagName("a")[0].className = "DOWN"
    }
    else {
        table.getElementsByTagName("th")[3].getElementsByTagName("a")[0].className = "UP"
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
            let x = rows[i].getElementsByTagName("td")[3].getElementsByTagName("p")[0].id;
            let y = rows[i + 1].getElementsByTagName("td")[3].getElementsByTagName("p")[0].id;
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
}