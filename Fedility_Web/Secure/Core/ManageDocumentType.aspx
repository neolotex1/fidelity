<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ManageDocumentType.aspx.cs"
    Inherits="Lotex.EnterpriseSolutions.WebUI.ManageDocumentType" MasterPageFile="~/doQman.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <style type="text/css">
        #btnAddGroup
        {
            background-image: url("Images/UI_addbutton.png");
        }
        #btnRemoveGroup
        {
            background-image: url("Images/UI_remove.png");
        }
         
            
    </style>
    <script language="javascript" type="text/javascript">

        var msgControl = null;
        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
            pageIdContorlID = "<%= hdnPageId.ClientID %>";
            pageRightsContorlId = "<%= hdnPageRights.ClientID %>"
            msgControl = "#<%= divMsg.ClientID %>";

            btnSubmitControlID = "<%= btnRemoveSubmit.ClientID %>";
            hdnDocTypeCheckStatus = "<%= hdnDocTypeCheckStatus.ClientID %>";

        });
        var rightsArray = new Array();
        var editId;


        var rightsIdentity = 0;
        //var editArray = new Array();
        //new {


        function SetDepTemplate() {
            rightsArray = new Array();
            var dataArray = "<%= strTemplateIDs %>".split('#');
            if (dataArray != null) {
                if (dataArray.length > 0) {

                    for (var i = 0, j = dataArray.length; i < j; i++) {
                        var data = dataArray[i];
                        subitemArray = data.split(",")

                        rightsArray.push(subitemArray);
                        //editArray.push(subitemArray);
                    }
                }
            }


            if (rightsArray.length > 0) {
                var dataArray1 = rightsArray;
                if (dataArray1 == null) {
                    var dataArray1 = new Array();
                }
                for (var i = 0, j = dataArray1.length; i < j; i++) {
                    var data1 = dataArray1[i];
                    RemoveDeptForEdit(data1[1]);
                }
                ShowRightsTable();

            }

        }

        function Pushtolistbox() {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var dataArray = rightsArray;
            if (dataArray == null) {
                var dataArray = new Array();
            }

            var Department = document.getElementById("<%= DDLDepartment.ClientID %>");
            var template = document.getElementById("<%= DDLtemplate.ClientID %>");

            var DepartmentText = Department.options[Department.selectedIndex].text;
            var DepartmentValue = Department.options[Department.selectedIndex].value;
            var templateText = template.options[template.selectedIndex].text;
            var templateValue = template.options[template.selectedIndex].value;
            var ArchivalD = document.getElementById("<%= txtArchival.ClientID %>").value;
            var WaterMarkText = document.getElementById("<%= txtwatermark.ClientID %>").value;
            var makerchecker = false;



            if (DepartmentText != '<Select>' && templateText != '<Select>') {
                if (document.getElementById("<%= btnaddtemp.ClientID %>").value == "Add") {
                    rightsIdentity = rightsIdentity + 1;
                    var item = [rightsIdentity, DepartmentValue, DepartmentText, templateValue, templateText, ArchivalD, WaterMarkText, makerchecker];
                    dataArray.push(item);
                    rightsArray = dataArray;


                }
                else {

                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        if (data[0] == editId) {

                            data[5] = ArchivalD;
                            data[6] = WaterMarkText;
                            data[7] = makerchecker;
                            editId = "";
                            document.getElementById("<%= btnaddtemp.ClientID %>").value = "Add";

                        }


                    }
                    document.getElementById("<%= DDLDepartment.ClientID %>").disabled = false;
                    document.getElementById("<%= DDLtemplate.ClientID %>").disabled = false;
                }
                document.getElementById("<%= txtArchival.ClientID %>").value = "";
                document.getElementById("<%= txtwatermark.ClientID %>").value = "";
                RemoveDept();
                ShowRightsTable();
                template.value = 0;

            }
            else {
                $(msgControl).css("color", "Red");
                $(msgControl).html(GetAlertMessages("Please Select Department & Corresponding Template!"));

            }


        }
        function RemoveDeptForEdit(Data) {


            var Department = document.getElementById("<%= DDLDepartment.ClientID %>");
            var i;
            for (i = Department.options.length - 1; i > 0; i--) {
                if (Department.options[i].value == Data)
                    Department.remove(i);
            }

        }
        function RemoveDept() {


            var Department = document.getElementById("<%= DDLDepartment.ClientID %>");
            var i;
            for (i = Department.options.length - 1; i > 0; i--) {
                if (Department.options[i].selected)
                    Department.remove(i);
            }

        }




        function CheckBeforeRemove(DepId, Dataid) {

            var msgControl = "#<%= divMsg.ClientID %>";
            editId = Dataid;


            var action = 'DocTypeCheckBeforeRemove';
            var currentDocmentTypeId = $("#<%= hdnCurrentDocumentTypeId.ClientID %>").val();
            if (DepId.length > 0) {


                DepId = DepId;
                var params = DepId + '|' + currentDocmentTypeId;
                var status = CallPostScalar(msgControl, action, params);
            }
        }

        function Removefromlstbox() {


            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");


            var dataArray = new Array();

            // CheckBeforeRemove();
            var hdnDocTypeCheckStatus = $("#<%= hdnDocTypeCheckStatus.ClientID %>").val();


            if (hdnDocTypeCheckStatus == 'DELETE') {

                document.getElementById("<%= hdnDocTypeCheckStatus.ClientID %>").value = "";
                if (rightsArray != null) {
                    if (rightsArray.length > 0) {

                        for (var i = 0, j = rightsArray.length; i < j; i++) {
                            var data = rightsArray[i];
                            if (data[0] != editId) {
                                dataArray.push(data);

                            }
                            else {
                                var valdep = data[1];
                                var txtdep = data[2];
                                var ddl = document.getElementById("<%= DDLDepartment.ClientID %>")
                                ddl.options.add(new Option(txtdep, valdep));
                                editId = "";

                            }
                        }
                        rightsArray = dataArray;
                        ShowRightsTable();
                    }
                }
            }
            else {
                $(msgControl).css("color", "Red");
                $(msgControl).html(GetAlertMessages("Can not be removed as it is already used!"));
                document.getElementById("<%= hdnDocTypeCheckStatus.ClientID %>").value = "";
                return false;
            }

        }
        function ConvertToBit(Data) {
            var Data1 = '1';
            if (Data == true || Data == 'true') {
                Data1 = '1';
            }
            else {
                Data1 = '0';
            }
            return Data1;
        }
        function Gettemplatedetails() {
            var rightsData = "";
            if (rightsArray != null) {
                if (rightsArray.length > 0) {

                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        if (rightsData != "") {
                            rightsData = rightsData + "#"
                        }
                        rightsData = rightsData + data[0] + "|" + data[1] + "|" + data[3] + "|" + data[5] + "|" + data[6] + "|" + ConvertToBit(data[7]); //MD -Nodified
                    }
                }
            }
            return rightsData;
        }


        //new }
        function Submit() {
            var msgControl = "#<%= divMsg.ClientID %>";
            var action = $("#<%= hdnAction.ClientID %>").val();
            var documentTypeName = $("#<%= txtDocumentType.ClientID %>").val();
            var description = $("#<%= txtDescription.ClientID %>").val();
            var currentDocmentTypeId = $("#<%= hdnCurrentDocumentTypeId.ClientID %>").val();
            var groupIds = GetSelectedGroupIds();
            var templatedetails = Gettemplatedetails();
            var isActive = false;
            if ($("#<%= chkActive.ClientID %>").is(':checked')) isActive = true;
            var params = documentTypeName + '|' + description + '|' + isActive
            + '|' + groupIds + '|' + currentDocmentTypeId + '!' + templatedetails;
            if (ValidateInputData(msgControl, action, documentTypeName, description, currentDocmentTypeId, groupIds, templatedetails)) {
                return CallPostScalar(msgControl, action, params);
            }
            else {
                return false;
            }
        }
        //********************************************************
        //ValidateInputData Function returns true or false with message to user on contorl specified
        //********************************************************

        function ValidateInputData(msgControl, action, documentTypeName, description, currentDocmentTypeId, groupIds, templateId) {
            $(msgControl).css("color", "red");
            $(msgControl).html("");
            var templatelist;
            if (action == "AddDocumentType" || action == "EditDocumentType") {
                $(msgControl).html("");
                var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
                var retval;

                if (document.getElementById("<%= txtDocumentType.ClientID %>").value.length < 2) {
                    $(msgControl).html(GetAlertMessages("Project Type Name Should Contain Atleast Two Characters!"));
                    return false;
                }
                //new
                else if (templateId.length == 0) {
                    $(msgControl).css("color", "Red");
                    $(msgControl).html(GetAlertMessages("Please add the department and template!"));
                    return false;

                }
                //new
                else {
                    var selectGroup = document.getElementById("<%= lstSelGroups.ClientID %>");
                    var result = false;
                    if (selectGroup.options.length != 0) {
                        result = true;
                    }
                    if (result == false) {
                        $(msgControl).css("color", "Red");
                        $(msgControl).html(GetAlertMessages("Please Select atleast one Group!"));
                        return false;
                    }

                }
            }
            return true;
        }
        //********************************************************
        //ClearData Function clears the form
        //********************************************************

        function ClearData() {
            document.getElementById("<%= txtDocumentType.ClientID %>").value = "";
        }

        function AddGroup() {
            $(msgControl).css("color", "red");
            var lstGroups = document.getElementById("<%= lstGroups.ClientID %>");
            var lstSelGroups = document.getElementById("<%= lstSelGroups.ClientID %>");
            for (var m = 0, n = lstGroups.options.length; m < n; m++) {
                if (lstGroups.options[m].selected) {
                    if (!CheckGroupAdded(lstGroups.options[m].value)) {
                        newElem = document.createElement("option");
                        newElem.text = lstGroups.options[m].text;
                        newElem.value = lstGroups.options[m].value;
                        lstSelGroups.options.add(newElem)
                        // $(msgControl).css("color", "green");

                        $(msgControl).html(GetAlertSuccessMessages("Groups are added successfully."));
                    }
                    else {
                        //$(msgControl).css("color", "green");
                        $(msgControl).html(GetAlertMessages("Selected group(s) is/are already added."));
                    }
                }
            }
        }
        function CheckGroupAdded(groupId) {
            var isExists = false;
            var lstSelGroups = document.getElementById("<%= lstSelGroups.ClientID %>");
            for (var m = 0, n = lstSelGroups.options.length; m < n; m++) {
                if (groupId == lstSelGroups.options[m].value) {
                    isExists = true;
                }
            }
            return isExists;
        }
        function GetSelectedGroupIds() {
            var groupIds = "";
            var lstSelGroups = document.getElementById("<%= lstSelGroups.ClientID %>");
            for (var m = 0, n = lstSelGroups.options.length; m < n; m++) {
                if (groupIds == "") {
                    groupIds += lstSelGroups.options[m].value;
                }
                else {
                    groupIds += ',' + lstSelGroups.options[m].value;
                }
            }
            return groupIds;
        }
        function RemoveGroup() {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var lstValue = document.getElementById("<%= lstSelGroups.ClientID %>");
            var j = lstValue.options.length;
            for (var i = 0; i < j; i++) {
                if (lstValue.options[i].selected) {
                    lstValue.remove(i);
                    j = lstValue.options.length;
                    i = 0;
                    continue;
                }
            }
        }
        function RowColor(obj) {


            var tbl = document.getElementById("tblIndex");
            rlen = tbl.rows.length
            var tr = document.getElementById(obj);
            var clen = tr.cells.length;
            var color = "#ffffff";
            for (j = 1; j < rlen; j++) {
                trTemp = tbl.rows[j];
                if (trTemp.id == obj) {
                    color = "#ffffff"
                }
                else {
                    color = "#F5DEB3"
                }
                for (i = 0; i < clen; i++) {
                    trTemp.cells[i].style.backgroundColor = color;

                }

                lastrowid = (trTemp.id);
            }



        }
        function ShowRightsTable() {

            dataArray = rightsArray;

            // editArray = dataArray;
            $("#divGrid").html("");
            var table = "";
            if (dataArray.length > 0) {
                // Table Creation from Json Collection
                table = '<table border= \"1\" class=\"table table-striped table-bordered dataTable no-footer dtr-inline\" AlternatingRowStyle-CssClass=\"alt\" summary=\"Index Fields\" id="tblIndex"><tr>';
                //                table += '<th>Edit</th>';
                table += '<th>Delete</th>';
                table += '<th>Department Name</th>';
                table += '<th>Template</th>';
                table += '<th>Archival Period</th>';
                table += '<th>WaterMark Text</th></tr>';

                for (var i = 0, j = dataArray.length; i < j; i++) {
                    var data = dataArray[i];
                    //check
                    table += '<tr id = "tr' + data[0] + '" onclick = "RowColor(this.id)">'
                                                    + '<td>&nbsp;' + '<a href=\"javascript:void(0)\" onclick=\"CheckBeforeRemove(\'' + data[1] + '\',\'' + data[0] + '\')\"><img border=\"0\" src = \"' + authority + '\\Assets\\Skin\\Images\\del.gif\" alt=\"delete\" /> </a>'
                                                    + '</td><td>&nbsp;' + data[2]
                                                    + '</td><td>&nbsp;' + data[4]
                                                    + '</td><td>&nbsp;' + data[5]
                                                    + '</td><td>&nbsp;' + data[6]

                                                    + '</td></tr>';
                }

            }
            table += '</table>';


            /* insert the html string*/
            $("#divGrid").html(table);
        }
        function EditIndexField(DataId) {
            if (document.getElementById("<%= btnaddtemp.ClientID %>").value == "Add") {
                editId = DataId;
                document.getElementById("<%= btnaddtemp.ClientID %>").value = "Save";
                var Action = getParameterByName("action");
                dataArray = rightsArray;
                if (rightsArray != null) {
                    if (rightsArray.length > 0) {

                        for (var i = 0, j = rightsArray.length; i < j; i++) {
                            var data = rightsArray[i];
                            if (data[0] == DataId) {
                                var valdep = data[1];
                                var txtdep = data[2];
                                var makerchecked = data[7];
                                var ddltemplate = document.getElementById("<%= DDLtemplate.ClientID %>");
                                var ddl = document.getElementById("<%= DDLDepartment.ClientID %>");
                                ddl.options.add(new Option(txtdep, valdep));
                                document.getElementById("<%= txtArchival.ClientID %>").value = data[5];
                                document.getElementById("<%= txtwatermark.ClientID %>").value = data[6];

                                ddl.value = data[1];
                                ddltemplate.value = data[3];
                            }



                        }
                        //                        if (Action == "edit") {
                        document.getElementById("<%= DDLDepartment.ClientID %>").disabled = true;
                        document.getElementById("<%= DDLtemplate.ClientID %>").disabled = true;
                        //                        }
                    }
                }
            }
            else {

                $(msgControl).css("color", "Red");
                $(msgControl).html(GetAlertMessages("Please Save the current one!"));
                return false;
            }
        }
        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Manage Document Type</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Manage Document Type</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%-- <asp:Label CssClass="CurrentPath" ID="lblPagePath" runat="server" Text="Home  &gt; Project Types"></asp:Label>--%>
    <div id="page-content">
        <div class="panel">
            <asp:UpdatePanel ID="UpdatePanel41" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                <ContentTemplate>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label CssClass="control-label" ID="lblHeading" runat="server" Text="Edit Project Types"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            
                                <div class="form-group">
                                    <div id="divMsg" runat="server" style="color: Red; font-family: Calibri; font-size: small">
                                    </div>
                                </div>
                           
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="Label1" runat="server" CssClass="control-label" Text=" Project Type"></asp:Label>
                                    <span class="AstrickStyle" style="color:Red">&nbsp;*</span>
                                    <asp:TextBox ID="txtDocumentType" runat="server" MaxLength="50" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:CheckBox ID="chkActive" runat="server"  Checked="true" />
                                    <label for="chkActive">
                                        <span></span>Active</label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="lblDescription0" runat="server" CssClass="control-label" Text="Description"></asp:Label>
                                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" MaxLength="1000"
                                        CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <asp:Label ID="lblDescription1" runat="server" CssClass="control-label" Text="Groups * (Select the group to access the Project Type)"></asp:Label>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-4">
                                <div class="form-group">
                                    <asp:ListBox ID="lstGroups" runat="server" SelectionMode="Multiple" class="list-group">
                                    </asp:ListBox>
                                </div>
                            </div>
                            <div class="col-sm-2  text-center">
                                <div class="form-group">
                                    &nbsp<i class="fa fa-arrow-circle-right btn-style btn-primary white">
                                        <asp:Button ID="btnAddGroup" runat="server" Text="Add"
                                            CssClass="btn white btn-primary btn-icon icon-lg fa fa-plus" Width="80px" OnClientClick="AddGroup(); return false;"
                                            TagName="Read" /></i> <i class="fa fa-arrow-circle-left btn-style btn-primary white">
                                                <asp:Button ID="btnRemoveGroup" runat="server" Text="Remove" Width="80px" CssClass="btn white btn-primary btn-icon icon-lg fa fa-minus"
                                                    OnClientClick="RemoveGroup(); return false;" TagName="Read" /></i>
                                </div>
                            </div>
                            <div class="col-sm-4">
                                <div class="form-group">
                                    <asp:ListBox ID="lstSelGroups" runat="server" SelectionMode="Multiple" class="list-group">
                                    </asp:ListBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="lblwatermark" runat="server" CssClass="control-label" Text="WaterMark Text"></asp:Label><span
                                        class="AstrickStyle">&nbsp;</span>
                                    <asp:TextBox ID="txtwatermark" runat="server" MaxLength="150" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="lblarchival" runat="server" CssClass="control-label" Text="Archival"
                                        ToolTip="Archival period in days"></asp:Label>
                                    <span class="AstrickStyle">&nbsp;</span>&nbsp;&nbsp;&nbsp;
                                    <asp:TextBox ID="txtArchival" runat="server" OnKeyPress="return CheckNumericKeyInfo(event)"
                                        MaxLength="3" CssClass="form-control"></asp:TextBox>
                                    <asp:Label CssClass="CurrentPath" ID="Label2" runat="server" Text="(in days)"></asp:Label>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="lbldepartment" runat="server" CssClass="control-label" Text="Department"></asp:Label><span
                                        class="AstrickStyle" style="color:Red">&nbsp;*</span>
                                    <asp:DropDownList ID="DDLDepartment" CssClass="form-control input-sm" runat="server">
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="lbltemplate" runat="server" CssClass="control-label" Text="Template"></asp:Label><span
                                        class="AstrickStyle" style="color:Red">&nbsp;*</span>
                                    <asp:DropDownList ID="DDLtemplate" CssClass="form-control input-sm" runat="server">
                                        <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <%--<div class="row">
                   <div class="col-sm-6">
                    <div class="form-group">
                        <label class="">
                            <asp:CheckBox ID="lblmakerchecker" runat="server" />
                            Maker & Checker</label>
                    </div>
                </div>
                  </div>--%>
                        <div class="row">
                            <div class="col-sm-4">
                                <div class="form-group">
                                    <!--<asp:Button ID="btnRemoveSubmit" runat="server" Style="visibility: hidden" Text="&lt;&lt; Remove"
                            OnClientClick="Removefromlstbox(); return false;" TagName="Read" />-->
                                    <i class="fa fa-plus btn-style white btn-primary">
                                        <asp:Button ID="btnaddtemp" runat="server" CssClass="btn btn-primary" Text="Add"
                                            OnClientClick="Pushtolistbox(); return false;" TagName="Read" /></i>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnAction" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnCurrentDocumentTypeId" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnDocTypeCheckStatus" runat="server" Value="" />
                                    <div id="divGrid" style="height: 150px; overflow-y: auto; width: 484px;">
                                    </div>
                                   
                                
                                   
                                    <div style="float:left; padding-right:3px">
                                     <i class="fa fa-floppy-o btn-style white btn-primary">
                                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary"
                                            OnClientClick="Submit();return false;" TagName="Edit" /></i> <i class="fa fa-ban  btn-style btn-danger white">
                                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-danger"
                                                    OnClick="btnCancel_Click" TagName="Read" /></i>

                                    </div>
                                         <div style="float:left" id="divhide" runat="server">
                                         <i class="fa fa-search btn-style btn-primary white ">
                                    <asp:Button ID="btnsearchagain" runat="server" Text="Search again" Class="btn btn-primary"
                                        TagName="Edit" OnClick="btnsearchagain_Click" /></i>
                                   </div>
                                
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
</asp:Content>
