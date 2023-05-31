<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="ManageGroup.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.ManageGroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Scripts/jquery-1.7-vsdoc.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Scripts/jquery-1.7.min.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Scripts/jquery-1.7.js") %>"></script>
    <script type="text/javascript" language="javascript" src="<%=Page.ResolveClientUrl("~/Assets/Scripts/AjaxPostScripts.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Assets/Scripts/master.js") %>"></script>
    <script language="javascript" type="text/javascript">
        var rightsArray = new Array();
        var rightsIdentity = 0;
        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
            pageIdContorlID = "<%= hdnPageId.ClientID %>";
            pageRightsContorlId = "<%= hdnPageRights.ClientID %>"

        });

        function Submit() {
            var msgControl = "#<%= divMsg.ClientID %>";
            var action = $("#<%= hdnAction.ClientID %>").val();
            var currentGroupId = $("#<%= hdnCurrentGroupId.ClientID %>").val();
            var groupName = $.trim($("#<%= txtGroupName.ClientID %>").val());
            var description = $("#<%= txtDescription.ClientID %>").val();

            var params = groupName + '|' + description + '|' + currentGroupId;
            if (ValidateInputData(msgControl, action, groupName, description)) {
                AddPageRights();
                var data = GetRightsText();
                return CallPostTable(msgControl, action, params, data);
            }
            else {
                return false;
            }
        }
        //********************************************************
        //ValidateInputData Function returns true or false with message to user on contorl specified
        //********************************************************

        function ValidateInputData(msgControl, action, groupName, description) {
            $(msgControl).html("");
            if (action == "AddGroup" || action == "EditGroup") {
                $(msgControl).html("");
                var retval;

                if (groupName.length < 2) {
                    $(msgControl).html(GetAlertMessages("Role Name Should Contain Atleast Two Characters!"));
                    Scrolltop();
                    return false;
                }
                else {
                    if (action == "EditGroup") {
                        var pageSelected = false;
                        var selectPages = document.getElementById("<%= lstPages.ClientID %>");
                        for (var i = 0, j = selectPages.options.length; i < j; i++) {
                            if (selectPages.options[i].selected) {
                                pageSelected = true;
                            }
                        }
                        var rightSelected = false;
                        var selectRights = document.getElementById("<%= lstRights.ClientID %>");
                        for (var i = 0, j = selectRights.options.length; i < j; i++) {
                            if (selectRights.options[i].selected) {
                                rightSelected = true;
                            }
                        }
                        if (pageSelected == true && rightSelected == false) {
                            $(msgControl).html(GetAlertMessages("Please select at least one right for the page selected"));
                            Scrolltop();




                            return false;
                        }
                        if (pageSelected == false && rightSelected == true) {
                            $(msgControl).html(GetAlertMessages("Please select at least one page for the right selected."));
                            Scrolltop();
                            return false;
                        }
                        if (rightsArray.length == 0) {
                            if (pageSelected == true && rightSelected == true) {
                                return true;
                            }
                            $(msgControl).html(GetAlertMessages("Please select at least one page."));
                            Scrolltop();
                            return false;
                        }
                        return true;
                    }
                    var pageSelected = false;
                    var selectPages = document.getElementById("<%= lstPages.ClientID %>");
                    for (var i = 0, j = selectPages.options.length; i < j; i++) {
                        if (selectPages.options[i].selected) {
                            pageSelected = true;
                        }
                    }
                    if (!pageSelected) {
                        $(msgControl).html(GetAlertMessages("Please select at least one page."));
                        Scrolltop();
                        return false;
                    }
                    else {
                        var rightSelected = false;
                        var selectRights = document.getElementById("<%= lstRights.ClientID %>");
                        for (var i = 0, j = selectRights.options.length; i < j; i++) {
                            if (selectRights.options[i].selected) {
                                rightSelected = true;
                            }
                        }
                        if (!rightSelected) {
                            $(msgControl).html(GetAlertMessages("Please select at least one right."));
                            Scrolltop();
                            return false;
                        }
                    }
                }
                return true;
            }
        }
        //********************************************************
        //ClearData Function clears the form
        //********************************************************

        function ClearData() {
            document.getElementById("<%= txtGroupName.ClientID %>").value = "";
            document.getElementById("<%= txtDescription.ClientID  %>").value = "";
            document.getElementById("<%= lstPages.ClientID %>").selectedIndex = -1;
            document.getElementById("<%= lstRights.ClientID %>").selectedIndex = -1;
            document.getElementById("<%=chkSelectAllPages.ClientID %>").checked = false;
            document.getElementById("<%=chkSelectAllRights.ClientID %>").checked = false;
            $("#divGrid").html("");
            document.getElementById("<%= txtGroupName.ClientID %>").focus();
        }
        //********************************************************
        //ClearData Function navigate to Homepage
        //********************************************************

        function Close() {
            location.href = "SearchGroup.aspx";
        }
        //********************************************************
        //ClearData Function navigate to Homepage
        //********************************************************

        function AddPageRights() {

            var dataArray = rightsArray;
            if (dataArray == null) {
                var dataArray = new Array();
            }
            var selectPages = document.getElementById("<%= lstPages.ClientID %>");
            for (var m = 0, n = selectPages.options.length; m < n; m++) {
                if (selectPages.options[m].selected) {
                    var pageName = selectPages.options[m].value;
                    //check whetether the pagename already exists
                    if (CheckRightsSelected()) {
                        var selectObject = document.getElementById("<%= lstRights.ClientID %>");
                        if (CheckPageRightExists(pageName)) {
                            for (var i = 0, j = dataArray.length; i < j; i++) {
                                var data = dataArray[i];
                                if (data[1] == pageName) {// for the page date
                                    for (var x = 0, y = selectObject.options.length; x < y; x++) {
                                        if (selectObject.options[x].selected) {
                                            for (var k = 0, l = data.length; k < l; k++) {
                                                if (data[k] == selectObject.options[x].value) {
                                                    break;
                                                }
                                                else {
                                                    if (data[k] == "") {
                                                        data[k] = selectObject.options[x].value;
                                                        break;
                                                    }
                                                }
                                            }
                                        }
                                    }

                                }
                            }
                        }
                        else {
                            rightsIdentity = rightsIdentity + 1;
                            var item = [rightsIdentity, pageName];
                            for (var i = 0, j = selectObject.options.length; i < j; i++) {
                                if (selectObject.options[i].selected) {
                                    item.push(selectObject.options[i].value);
                                }
                            }
                            if (item.length < (selectObject.options.length + 2)) {
                                for (var i = item.length, j = (selectObject.options.length + 2); i < j; i++) {
                                    item.push("");
                                }
                            }
                            dataArray.push(item);
                        }
                    }
                }
            }
            rightsArray = dataArray;
            ShowRightsTable();

        }
        function CheckPageRightExists(pageName) {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var dataArray = rightsArray;
            var isExists = false;
            if (dataArray == null) {
                var dataArray = new Array();
            }
            if (dataArray.length > 0) {

                for (var i = 0, j = dataArray.length; i < j; i++) {
                    var data = dataArray[i];
                    if (data[1] == pageName) {
                        isExists = true;
                    }
                }
            }
            //            if (isExists) {
            //                $(msgControl).html("The page(s) already exists in the table");
            //            }
            return (isExists);
        }
        function CheckRightsSelected() {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var itemSelected = false;
            var selectObject = document.getElementById("<%= lstRights.ClientID %>");
            for (var i = 0, j = selectObject.options.length; i < j; i++) {
                if (selectObject.options[i].selected) {
                    itemSelected = true;
                }
            }

            if (!itemSelected) {
                $(msgControl).html(GetAlertMessages("Please select rights."));
                Scrolltop();

            }
            return (itemSelected);
        }
        function DeleteRights(id) {

            var dataArray = new Array();

            if (rightsArray != null) {
                if (rightsArray.length > 0) {

                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        if (data[0] != id) {
                            dataArray.push(data);
                        }
                    }
                    rightsArray = dataArray;
                    ShowRightsTable();
                }
            }

        }
        function CheckValue(value) {
            if (typeof (value) == 'undefined')
                return "";
            else
                return value;
        }
        function ShowRightsTable() {
            dataArray = rightsArray;
            $("#divGrid").html("");
            var table = "";
            if (dataArray.length > 0) {
                // Table Creation from Json Collection
                table = '<table border= \"1\" class=\"table table-striped table-bordered dataTable no-footer dtr-inline\" AlternatingRowStyle-CssClass=\"alt\"  summary=\"User Rights\" ><tr>';
                table += '<th>Delete</th>';
                table += '<th>Page</th>';
                table += '<th>Right 1</th>';
                table += '<th>Right 2</th>';
                table += '<th>Right 3</th>';
                table += '<th>Right 4</th>';
                table += '<th>Right 5</th>';
                table += '<th>Right 6</th>';
                table += '<th>Right 7</th>';
                table += '<th>Right 8</th>';
                table += '<th>Right 9</th>';
                table += '<th>Right 10</th></tr>';

                for (var i = 0, j = dataArray.length; i < j; i++) {
                    var data = dataArray[i];
                    table += '<tr><td>&nbsp;' + '<a href=\"javascript:void(0)\" onclick=\"DeleteRights(\'' + data[0] + '\')\"><img border=\"0\" src = \"' + authority + '/Assets/Skin/Images/del.gif" alt=\"delete\" /> </a>'
                    + '</td><td>&nbsp;' + CheckValue(data[1])
                    + '</td><td>&nbsp;' + CheckValue(data[2])
                    + '</td><td>&nbsp;' + CheckValue(data[3])
                    + '</td><td>&nbsp;' + CheckValue(data[4])
                    + '</td><td>&nbsp;' + CheckValue(data[5])
                    + '</td><td>&nbsp;' + CheckValue(data[6])
                    + '</td><td>&nbsp;' + CheckValue(data[7])
                    + '</td><td>&nbsp;' + CheckValue(data[8])
                    + '</td><td>&nbsp;' + CheckValue(data[9])
                    + '</td><td>&nbsp;' + CheckValue(data[10])
                    + '</td><td>&nbsp;' + CheckValue(data[11])
                    + '</td></tr>';
                }
                table += '</table>';
            }
            /* insert the html string*/
            $("#divGrid").html(table);
        }
        function ToggleSelection(selectObject, isSelected) {
            for (var i = 0, j = selectObject.options.length; i < j; i++) {
                selectObject.options[i].selected = (!isSelected);
            }
        }

        function ToggleApplicationSelection() {
            var selectObject = document.getElementById("<%= lstApplications.ClientID %>");
            var isSelected = selectObject.options[0].selected;
            var checkObj = document.getElementById("<%= chkApplicationSelect.ClientID %>");
            checkObj.checked = (!isSelected);
            ToggleSelection(selectObject, isSelected);
            //Call code behind index changed event
            document.getElementById("<%= btnApplicationSelect.ClientID %>").click();
        }

        function TogglePageSelection() {
            try {
                var selectObject = document.getElementById("<%= lstPages.ClientID %>");
                var isSelected = selectObject.options[0].selected;
                var checkObj = document.getElementById("<%= chkSelectAllPages.ClientID %>");
                checkObj.checked = (!isSelected);
                ToggleSelection(selectObject, isSelected);
            } catch (e) { }
        }
        function ToggleRightsSelection() {
            try {
                var selectObject = document.getElementById("<%= lstRights.ClientID %>");
                var isSelected = selectObject.options[0].selected;
                var checkObj = document.getElementById("<%= chkSelectAllRights.ClientID %>");
                checkObj.checked = (!isSelected);
                ToggleSelection(selectObject, isSelected);
            } catch (e) { }
        }

        function GetRightsText() {
            var rightsData = "";
            if (rightsArray != null) {
                if (rightsArray.length > 0) {

                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        if (rightsData != "") {
                            rightsData = rightsData + "#"
                        }
                        rightsData = rightsData + data[0] + "|" + data[1] + "|" + data[2] + "|" + data[3] + "|" + data[4] + "|" + data[5] + "|" + data[6] + "|" + data[7] + "|" + data[8] + "|" + data[9] + "|" + data[10] + "|" + data[11];
                    }
                }
            }
            return rightsData;
        }
        function ShowGroupRights(rightText) {
            rightsArray = new Array();
            var dataArray = rightText.split("#");
            if (dataArray != null) {
                if (dataArray.length > 0) {

                    for (var i = 0, j = dataArray.length; i < j; i++) {
                        var data = dataArray[i];
                        subitemArray = data.split("|")
                        if (subitemArray.length < 8) {
                            for (m = subitemArray.length, n = 8; m < n; m++) {
                                subitemArray.push("");
                            }
                        }
                        rightsArray.push(subitemArray);
                    }
                }
            }
            rightsIdentity = i;
            ShowRightsTable();
            return true;
        }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Manage Group</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Manage Group</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="page-content">
        <div class="panel">
            <div class="panel-body">
                <div class="form-group">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label CssClass="PageHeadings" ID="lblHeading" runat="server" Text="Add New User Role"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                           
                                <div class="form-group">
                                    <div id="divMsg" runat="server" style="color: Red">
                                    </div>
                                </div>
                           
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="Label1" runat="server" CssClass="LabelStyle" Text="Role"></asp:Label><span
                                        class="AstrickStyle"style="color:Red">&nbsp;*</span>
                                    <asp:TextBox ID="txtGroupName" runat="server" TextMode="SingleLine" MaxLength="30"
                                        CssClass="form-control" Text="" OnKeyPress="return CheckvarcharKeyInfo(event)"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="Label2" runat="server" CssClass="LabelStyle" Text="Description" />
                                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" MaxLength="1000"
                                        CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-4">
                                <div class="form-group">
                                <asp:Label ID="blbapplications" runat="server" CssClass="LabelStyle" Text="Select Applications" />
                                    <asp:CheckBox ID="chkApplicationSelect" runat="server" Text="Select Applications (Select All)"
                                        CssClass="" onclick="ToggleApplicationSelection();"  style="display:none"/>
                                </div>
                                <div class="form-group">
                                    <asp:ListBox ID="lstApplications" runat="server" Width="258px" SelectionMode="Multiple"
                                        AutoPostBack="True" Height="150px" OnSelectedIndexChanged="lstApplications_SelectedIndexChanged"
                                        class="list-group" onclick="$('[id$=chkSelectAllPages]').attr('checked', false); $('[id$=chkSelectAllRights]').attr('checked', false);">
                                    </asp:ListBox>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="form-group">
                                    <asp:CheckBox ID="chkSelectAllPages" runat="server" Text="Select Pages(Select All)"
                                        CssClass="" onclick="TogglePageSelection();" />
                                        </div>
                                           <div class="form-group">
                                    <asp:ListBox ID="lstPages" runat="server" Width="258px" SelectionMode="Multiple"
                                        class="list-group" Height="150px" onclick="$('[id$=chkSelectAllPages]').attr('checked',
                        false);"></asp:ListBox>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="form-group">
                                   
                                    <asp:CheckBox ID="chkSelectAllRights" runat="server" CssClass=""
                                        Text="Select Rights(Select All)" onclick="ToggleRightsSelection();" />
                                        </div>
                                         <div class="form-group">
                                   
                                    <asp:ListBox ID="lstRights" runat="server" SelectionMode="Multiple" Width="258px"
                                        class="list-group" Height="150px" onclick="$('[id$=chkSelectAllRights]').attr('checked',
                    false);"></asp:ListBox>
                                </div>
                            </div>
                            <asp:HiddenField ID="hdnUserName" runat="server" Value="" />
                            <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                            <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                            <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                            <asp:HiddenField ID="hdnAction" runat="server" Value="" />
                            <asp:HiddenField ID="hdnCurrentGroupId" runat="server" Value="" />
                            <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                            </div>
                             <div class="row">
                
                <div class="col-md-6" >
                <div style="float:left; padding-right:3px">
                            <i class="white btn-primary btn-style fa fa-plus ">
                                <asp:Button ID="btnAdd" runat="server" Text="Add" OnClientClick="AddPageRights();return
                    false" CssClass="btn btn-primary" TagName="Read" /></i>
                           
                            <i class="fa fa-save btn-success btn-style white">
                                <asp:Button ID="btnUpdate" runat="server" Text="Submit" OnClientClick="Submit(); return false;"
                                    CssClass="btn btn-primary" TagName="Edit" /></i> <i class="btn-danger btn-style fa fa-eraser white">
                                        <asp:Button ID="btnClear" CssClass="btn btn-danger" runat="server" Text="Clear" OnClientClick="ClearData();
                    return false;" TagName="Edit" /></i> <i class="btn-danger white btn-style fa fa-ban">
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-danger"
                            TagName="Read" OnClick="btnCancel_Click" /></i></div>
                            <div style="float:left" id="divhide" runat="server">
                            <i class="fa fa-search btn-style btn-primary white ">
                             <asp:Button ID="btnsearchagain" runat="server" Text="Search Again" TagName="Read"
                                CssClass="btn btn-primary" OnClick="btnsearchagain_Click" /></i></div>
                            <asp:Button ID="btnApplicationSelect" runat="server" OnClick="lstApplications_SelectedIndexChanged"
                                Style="visibility: hidden" />
                                </div>
                      
                    </ContentTemplate>
                </asp:UpdatePanel>

                </div>
                    <div class="form-group">
                <div class="row">
                <div   class="table-responsive">
                    <div id="divGrid" class="col-sm-12">

                    </div>
                    </div>
                </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
