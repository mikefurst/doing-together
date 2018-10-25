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
}