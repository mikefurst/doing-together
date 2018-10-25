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