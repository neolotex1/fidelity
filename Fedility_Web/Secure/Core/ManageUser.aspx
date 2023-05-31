<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="ManageUser.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.ManageUser" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <script language="javascript" type="text/javascript">

        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
            pageIdContorlID = "<%= hdnPageId.ClientID %>";
            pageRightsContorlId = "<%= hdnPageRights.ClientID %>";
            btnSubmitControlID = "<%= btnSubmit.ClientID %>";
            btnSaveControlID = "<%= btnSave.ClientID %>";
            hdnCredentialsControlID = "<%= hdnCredentials.ClientID %>";
            btnresetpasswordControlID = "<%= btnresetpassword.ClientID %>";
            hdnOrglinkControlID = "<%= hdnOrglink.ClientID %>";
            chkDomainUserControlID = "<%= chkDomainUser.ClientID %>";
            if (document.getElementById("<%= chkDomainUser.ClientID %>").checked == true) {
                document.getElementById("<%= drpDomain.ClientID %>").disabled = false;
            }
            else {
                document.getElementById("<%= drpDomain.ClientID %>").disabled = true;
            }
        });


        function alerting(Amessage, Mtitle, MType) {
            $.niftyNoty({
                type: MType,
                icon: 'fa fa-bolt fa-2x',
                container: 'page',
                title: Mtitle,
                message: Amessage

            });
        }
        function Notification(Amessage, Mtitle, MType) {
            $.niftyNoty({
                type: MType,
                container: "floating",
                title: Mtitle,
                message: Amessage,
                closeBtn: true,
                timer: 5000
            });
        }
        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }
        function getSelectValues() {
            var select = document.getElementById("<%= drpDepartment.ClientID %>");
            var result = [];
            var Status;
            var options = select && select.options;
            var opt;

            for (var i = 0, iLen = options.length; i < iLen; i++) {
                opt = options[i];

                if (opt.selected) {
                    result.push(opt.value || opt.text);
                    Status = true;
                }
            }
            if (Status != true) {
                result = null;
            }
            return result;
        }
        function Submit() {

            var msgControl = "#<%= divMsg.ClientID %>";
            var action = $("#<%= hdnAction.ClientID %>").val();
            var userName = $.trim($("#<%= txtUserName.ClientID %>").val());
            var description = $.trim($("#<%= txtDescription.ClientID %>").val());
            var userEmailId = $.trim($("#<%= txtUserEmailId.ClientID %>").val());
            var mobileNo = $.trim($("#<%= txtMobileNo.ClientID %>").val());
            var firstName = $.trim($("#<%= txtFirstName.ClientID %>").val());
            var lastName = $.trim($("#<%= txtLastName.ClientID %>").val());
            var currentUserd = $("#<%= hdnCurrentUserId.ClientID %>").val();
            var userGroupId = $("#<%= drpUserGroup.ClientID %>").val();
            var departmentId = getSelectValues();
            if (departmentId == null && userName != "administrator") {
                $(msgControl).html(GetAlertMessages("Please select department!", "Department", "danger"));
                Scrolltop();

                return false;
            }
            //            if (departmentId != null && departmentId.toString().split(",").length > 1) {
            //                $(msgControl).html("Please select only one department!");
            //                return false;
            //            }

            var Domain = $("#<%= drpDomain.ClientID %>").val();

            if (typeof Domain == 'undefined' || Domain == null) {
                Domain = 0;
            }
            var isActive = false;
            var isDomainUser = false;
            if ($("#<%= chkActive.ClientID %>").is(':checked')) isActive = true;
            if ($("#<%= chkDomainUser.ClientID %>").is(':checked')) isDomainUser = true;
            var params = userName + '|' + description + '|' + userEmailId
                + '|' + mobileNo + '|' + firstName + '|' + lastName
                + '|' + userGroupId + '|' + departmentId + '|' + isActive + '|' + currentUserd + '|' + isDomainUser + '|' + Domain;
            if (ValidateInputData(msgControl, action, userName, description, userEmailId, mobileNo, firstName, lastName, isDomainUser, Domain)) {
                document.getElementById("<%= btnSave.ClientID %>").disabled = true;

                return CallPostScalar(msgControl, action, params);
            }
            else {
                return false;
            }
        }
        //********************************************************
        //Enable sumit button
        //********************************************************
        function enable() {
            document.getElementById("<%= btnSave.ClientID %>").disabled = false;

        }
        //********************************************************
        //ValidateInputData Function returns true or false with message to user on contorl specified
        //********************************************************

        function ValidateInputData(msgControl, action, userName, description, userEmailId, mobileNo, firstName, lastName, isDomainUser, Domain) {
            $(msgControl).html("");
            var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

            if (userName.length < 2) {
                $(msgControl).html(GetAlertMessages("User Name Should Contain Atleast Two Characters!"));
                Scrolltop();
                return false;
            }
            else if (firstName.length < 2) {
                $(msgControl).html(GetAlertMessages("First Name Should Contain Atleast Two Characters!"));
                Scrolltop();
                return false;
            }
            else if (userName.toUpperCase() != 'ADMINISTRATOR' && lastName.length < 2) {
                $(msgControl).html(GetAlertMessages("Last Name Should Contain Atleast Two Characters!"));
                Scrolltop();
                return false;
            }
//            else if (reg.test(userEmailId) == false) {
//                $(msgControl).html(GetAlertMessages("Please Verify that Correct Email Address is Entered!"));
//                Scrolltop();
//                return false;
//            }
//            else if (mobileNo.length < 10) {
//                $(msgControl).html(GetAlertMessages("Please Verify that Correct Mobile No is Entered!"));
//                Scrolltop();
//                return false;
//            }
            else if (document.getElementById("<%= drpUserGroup.ClientID  %>").value == "0") {
                $(msgControl).html(GetAlertMessages("Please Select a User Role!"));
                Scrolltop();
                return false;
            }
            else if (document.getElementById("<%= drpDepartment.ClientID  %>").value == "0") {
                $(msgControl).html(GetAlertMessages("Please Select User a Department!"));
                Scrolltop();
                return false;
            }
            else if (isDomainUser == true && Domain == "0") {
                $(msgControl).html(GetAlertMessages("Please Select an Active Directory!"));
                Scrolltop();
                return false;
            }
            else {
                return true;
            }
        }
        //********************************************************
        //ClearData Function clears the form
        //********************************************************

        function ClearData() {
            document.getElementById("<%= txtUserName.ClientID %>").value = "";
            document.getElementById("<%= txtDescription.ClientID  %>").value = "";
            document.getElementById("<%= txtUserEmailId.ClientID  %>").value = "";
            document.getElementById("<%= txtMobileNo.ClientID  %>").value = "";
            document.getElementById("<%= txtFirstName.ClientID  %>").value = "";
            document.getElementById("<%= txtLastName.ClientID  %>").value = "";
            document.getElementById("<%= drpUserGroup.ClientID  %>").value = "";
            document.getElementById("<%= drpDepartment.ClientID  %>").value = "";
            document.getElementById("<%= btnSave.ClientID %>").disabled = false;

        }
        //********************************************************
        //ClearData Function navigate to Homepage
        //********************************************************

        function Close() {
            var type = getParameterByName("action");
            if (type == "edittempuser") {
                location.href = "BulkUploadUsers.aspx";
            }
            else {
                location.href = "SearchUser.aspx";
            }
        }        
         
    </script>
    <script type="text/javascript" language="javascript">

        //        $(document).ready(function () {

        //            divMenuConfig.className = "SubMenuBase";
        //            divMenuDocument.className = "MenuHide";


        //            $("#mnuUsers").slideDown("fast");
        //            MenuUser.className = "SubMenuLinkSelected";
        //            lnkUsers.className = "MenuLInkStyleSelected";
        //            lnkUserAdd.className = "MenuLInkStyleSelected";
        //            mnuUsers.className = "SubMenuBaseSelected";
        //            mmConfig.className = "MenudivSelected";
        //            mUsersAddBase.className = "SubMenuItemLinkSelected";
        //        });

        //texbox validation - Only Characters and '-' Symbol
        function CheckvarcharKeyInfo(event) {
            var char1 = (event.keyCode ? event.keyCode : event.which);
            if ((char1 >= 65 && char1 <= 90) || (char1 >= 97 && char1 <= 122) || char1 == 45 || char1 == 32 || char1 == 8 || char1 == 9) {
                RetVal = true;
            }
            else {
                RetVal = false;
            }
            return RetVal;
        }

        //texbox validation - Only numbers and '-' Symbol
        function CheckNumericKeyInfo(event) {
            var char1 = (event.keyCode ? event.keyCode : event.which);
            if ((char1 >= 48 && char1 <= 57) || char1 == 45 || char1 == 43 || char1 == 8 || char1 == 9) {
                RetVal = true;
            }
            else {
                RetVal = false;
            }
            return RetVal;
        }

        //********************************************************
        // DUEN - Add
        //********************************************************
        function checkdomain() {
            if (document.getElementById("<%= chkDomainUser.ClientID%>").checked == true) {
                document.getElementById("<%= drpDomain.ClientID%>").disabled = false;
            }
            else {
                document.getElementById("<%= drpDomain.ClientID%>").selectedIndex = 0;
                document.getElementById("<%= drpDomain.ClientID%>").disabled = true;
            }
        }

        function ToggleDepartmentSelection() {
            var selectObject = document.getElementById("<%= drpDepartment.ClientID %>");
            var isSelected = selectObject.options[0].selected;
            var checkObj = document.getElementById("<%= chkSelectAllDepartment.ClientID %>");
            checkObj.checked = (!isSelected);
            ToggleSelection(selectObject, isSelected);
        }

        function ToggleSelection(selectObject, isSelected) {
            for (var i = 0, j = selectObject.options.length; i < j; i++) {
                selectObject.options[i].selected = (!isSelected);
            }
        }
            
    </script>
    <style type="text/css">
        .btn-rounded
        {}
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Manage Users</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Manage Users</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="page-content">
    <div class="panel">
        <div class="panel-body">
            <div class="row">
            
            <div id="divMsg" runat="server" >
            </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label CssClass="control-label" ID="lblHeading" runat="server" Text="Edit User"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblUserName" runat="server" CssClass="control-label" Text="User Name"></asp:Label>
                        <asp:Label CssClass="control-label" ID="lblPageDescription1" runat="server" Text="*" ForeColor="red"></asp:Label>
                        <asp:TextBox ID="txtUserName" runat="server" CssClass="form-control" MaxLength="200"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblHead7" runat="server" CssClass="control-label" Text="Description"></asp:Label>
                        <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine"
                            MaxLength="1000"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblHead" runat="server" CssClass="control-label" Text="First Name"></asp:Label>
                        <asp:Label CssClass="control-label" ID="Label2" runat="server" Text="*" ForeColor="red"></asp:Label>
                        <asp:TextBox ID="txtFirstName" runat="server" MaxLength="30" CssClass="form-control"
                            OnKeyPress="return CheckvarcharKeyInfo(event)"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblHead1" runat="server" CssClass="control-label" Text="Last Name"></asp:Label>
                        <asp:Label CssClass="control-label" ID="Label3" runat="server" Text="*" ForeColor="red"></asp:Label>
                        <asp:TextBox ID="txtLastName" runat="server" Style="margin-left: 0px" MaxLength="30"
                            CssClass="form-control" OnKeyPress="return CheckvarcharKeyInfo(event)"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblHead2" runat="server" CssClass="control-label" Text="Email"></asp:Label>
                        <%--<asp:Label CssClass="control-label" ID="Label4" runat="server" Text="*" ForeColor="red"></asp:Label>--%>
                        <asp:TextBox ID="txtUserEmailId" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblHead3" runat="server" CssClass="control-label" Text="Mobile"></asp:Label>
                        <%--<asp:Label CssClass="control-label" ID="Label5" runat="server" Text="*" ForeColor="red"></asp:Label>--%>
                        <asp:TextBox ID="txtMobileNo" runat="server" MaxLength="14" CssClass="form-control"
                            OnKeyPress="return CheckNumericKeyInfo(event)"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <label class="">
                            <asp:CheckBox ID="chkActive" Checked="true" runat="server" Text=" " />Active</label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblHead4" runat="server" CssClass="control-label" Text="User Role"></asp:Label>
                        <asp:Label CssClass="control-label" ID="Label6" runat="server" Text="*" ForeColor="red"></asp:Label>
                        <asp:DropDownList ID="drpUserGroup" CssClass="form-control input-sm" runat="server">
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblHead0" runat="server" CssClass="control-label" Text="Department"></asp:Label>
                        <asp:Label CssClass="control-label" ID="Label7" runat="server" Text="*" ForeColor="red"></asp:Label>
                        <label class="">
                            <asp:CheckBox ID="chkSelectAllDepartment" runat="server" Text=" " />Select All</label>
                        <asp:ListBox ID="drpDepartment" runat="server" CssClass="form-control input-sm" multiple
                            title="Choose one of the following..." data-width="100%" SelectionMode="Multiple">
                        </asp:ListBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <label class="">
                            <asp:CheckBox ID="chkDomainUser" runat="server" onclick="return checkdomain();" />Active
                            Directory User
                        </label>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblDomainName" runat="server" CssClass="control-label" Text="Active Directory"></asp:Label>
                        <asp:DropDownList ID="drpDomain" CssClass="form-control input-sm" runat="server">
                        </asp:DropDownList>
                    </div>
                </div>
            </div>
            <div class="row">
                
                <div class="col-md-6" >
                <div style="float:left; padding-right:3px">
                    
                            <i class="fa fa-save btn-success btn-style white">
                        <asp:Button ID="btnSave" runat="server" Text="Submit" CssClass="btn btn-primary"
                            OnClientClick="Submit(); return false;" TagName="Edit" /></i>
                            <i class="fa fa-close btn-style white btn-danger">
                        <asp:Button ID="btnClose" runat="server" Text="Close" CssClass="btn btn-danger"
                            OnClientClick="Close(); return false;" TagName="Read" /></i></div>
              
                
                            <div style="float:left" id="divhide" runat="server">
                            <i class="fa fa-search btn-style btn-primary white ">
                        <asp:Button ID="btnsearchagain" runat="server" Text="Search Again" CssClass="btn btn-primary"
                            TagName="Read" OnClick="btnsearchagain_Click" /></i>
                            <i class="fa fa-cogs btn-style white btn-primary">
                        <asp:Button ID="btnresetpassword" runat="server" Text="Reset Password" CssClass="btn btn-primary"
                            TagName="Edit" OnClick="btnresetpassword_Click" /></i>
                     <i class="fa fa-user-plus btn-style btn-primary white">
                        <asp:Button ID="btnUserMapping" TagName="Read" CssClass="btn btn-primary"
                            runat="server" Text="User Mapping" onclick="btnUserMapping_Click" /></i></div>
                               <asp:Button ID="btnSubmit" TagName="Read" CssClass="HiddenButton"
                            runat="server" Text="SendEmail" OnClick="btnSubmit_Click" /></div>
                            
                           
            
                        <asp:HiddenField ID="hdnUserName" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnAction" runat="server" Value="" />
                        <asp:HiddenField ID="hdnCredentials" runat="server" Value="" />
                        <asp:HiddenField ID="hdnCurrentUserId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                        <asp:HiddenField ID="hdnOrglink" runat="server" Value="" />
                    
             </div>
        </div>
    </div>
    </div>
</asp:Content>
