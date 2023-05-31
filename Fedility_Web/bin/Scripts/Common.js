
function Message(Mtype, Mtitle, Mmessgae) {
    $.niftyNoty({
        type: Mtype,
        container: "floating",
        title: Mtitle,
        message: Mmessgae,
        closeBtn: false,
        timer: 5000
    });
}

function GetAlertMessages(message) {
    var Rmessage = '';

    if (message.length > 1) {
        Rmessage = "<div class='alert alert-danger fade in'><button data-dismiss='alert' class='close'><span>X</span></button><strong>" + message
+ "</strong></div>";        
        //setTimeout("$('.alert-danger').hide();", 10000);
    }
    return Rmessage;
}

function GetAlertSuccessMessages(message) {
   var Rmessage = '';
   if (message.length > 1) {
        Rmessage = "<div class='alert alert-success fade in'><button data-dismiss='alert' class='close'><span>X</span></button><strong>" + message
+ "</strong></div>";
        setTimeout("$('.alert-success').hide();", 5000);

   }
    return Rmessage;

}



function onlyNumbers(e, t) {
    try {
        if (window.event) {
            var evt = e || window.event; // compliant with ie6
            var charCode = window.event.keyCode; 
        }
        else if (e) {
            var charCode = e.which;
        }
        else { return true; }
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            return false;
        }
        return true;
    }
    catch (err) {
        alert(err.Description);
    }
}



function getMonth(anum) {
    var month = "";

    var number = parseInt(anum)
    switch (number) {
        case 01:
            month = "Jan";
            break;
        case 02:
            month = "Feb";
            break;
        case 03:
            month = "Mar";
            break;
        case 04:
            month = "Apr";
            break;
        case 05:
            month = "May";
            break;
        case 06:
            month = "Jun";
            break;
        case 07:
            month = "Jul";
            break;
        case 08:
            month = "Aug";
            break;
        case 09:
            month = "Sep";
            break;
        case 10:
            month = "Oct";
            break;
        case 11:
            month = "Nov";
            break;
        case 12:
            month = "Dec";
            break;
        default:
            month = "Error";
            break;
    }
    return month;
}
function formatdate(elemVal) {

    var Date = "";
    var Day = elemVal.substring(0, 2);
    var Month = elemVal.substring(3, 5);
    var Year = elemVal.substring(6, 11);
    var month = getMonth(Month);
    if (month != "Error" && Day <= 31) {
        Date = Day + "-" + getMonth(Month) + "-" + Year;
    }
    else {
        Date = "";
        alert("Please enter Valid Date");
    }

    return Date;
}
function getDate(event, elem) {

    var elemVal = elem.value;
    var elemId = elem.id;
    var legth = elemVal.length
    var charCode = (event.keyCode ? event.keyCode : event.which);
    if (charCode != 8) {
        switch (elemVal.length) {
            case 2:
                elemVal = elemVal + "-";

                break;
            case 5:
                elemVal = elemVal + "-";

                break;
            case 10:
                elemVal = formatdate(elemVal);
                break;

        }

        document.getElementById(elemId).value = elemVal;
    }
    else {
        document.getElementById(elemId).value = "";
    }

    return true;
}
function formatCurrentDate(elemVal) {

    var date = "";
    var Day = elemVal.substring(0, 2);
    var Month = elemVal.substring(3, 5);
    var Year = elemVal.substring(6, 11);
    var month = getMonth(Month);
    if (month != "Error" && Day <= 31) {
        date = Day + "-" + getMonth(Month) + "-" + Year;
        if (Year != null) {
            var inputDate = Date.parse(date);
            if (inputDate > Date.now()) {
                date = "";
                alert("Future date not allowed !!!");
            }

        }
    }
    else {
        date = "";
        alert("Please enter Valid Date");
    }

    return date;
}
function getCurrentDate(event, elem) {

    var elemVal = elem.value;
    var elemId = elem.id;
    var legth = elemVal.length
    evt = event || window.event;
    // var charCode = window.event.keyCode;
    var charCode = (event.keyCode ? event.keyCode : event.which);

    if (charCode != 8) {
        switch (elemVal.length) {
            case 2:
                elemVal = elemVal + "-";

                break;
            case 5:
                elemVal = elemVal + "-";

                break;
            case 10:
                elemVal = formatCurrentDate(elemVal);
                break;

        }

        document.getElementById(elemId).value = elemVal;
    }
    else {
        document.getElementById(elemId).value = "";
    }

    return true;
}

