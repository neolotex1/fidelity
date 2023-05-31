<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="ChanagePassword.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Assets/Scripts/master.js") %>"></script>
    <script language="javascript" type="text/javascript">

        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
        });

        function ValidateUser() {
            var msgControl = "#<%= divMsg.ClientID %>";
            var action = "ChangePassword";
            var username = $("#<%= hdnUserName.ClientID %>").val();
            var password = $("#<%= txtOldPassword.ClientID %>").val();
            var newPassword = $("#<%= txtNewPassword.ClientID %>").val();
            var retryPassword = $("#<%= txtRetryNewPassord.ClientID %>").val();
            var params = username + '|' + password + '|' + newPassword;
            if (ValidateInputData(msgControl, action, password, newPassword, retryPassword)) {
                CallPostScalar(msgControl, action, params);
                $("#<%= txtOldPassword.ClientID %>").val() ="";
                $("#<%= txtNewPassword.ClientID %>").val()="";
                 $("#<%= txtRetryNewPassord.ClientID %>").val()="";
                return false;
            }
            else {
                return false;
            }
        }
        //********************************************************
        //ValidateInputData Function returns true or false with message to user on contorl specified
        //********************************************************

        function ValidateInputData(msgControl, action, password, newPassword, retryPassword) {
            $(msgControl).html("");
            var isbool = true;
            var regularExpression = /^(?=.*[0-9])(?=.*[!@#$%^&_)(*.,><~?])[a-zA-Z0-9!@#$%^&_)(*.,><~?]{8,20}$/;
            if (action == "ChangePassword") {
                if (password == "") {
                    $(msgControl).html(GetAlertMessages("Password fields cannot be blank."));

                    document.getElementById("<%= txtOldPassword.ClientID %>").focus();
                    isbool = false;
                }
                else if (newPassword == "") {
                    $(msgControl).html(GetAlertMessages("Password fields cannot be blank"));
                    document.getElementById("<%= txtNewPassword.ClientID %>").focus();
                    isbool = false;
                }
                else if (password == newPassword) {
                    $(msgControl).html(GetAlertMessages("New Password cannot be same as Current Password"));
                    document.getElementById("<%= txtNewPassword.ClientID %>").value = "";
                    document.getElementById("<%= txtNewPassword.ClientID %>").focus();
                    isbool = false;
                }
                else if (newPassword.length < 8 || newPassword.length > 20) {
                    $(msgControl).html(GetAlertMessages("New Password should be 8-20 characters long. Please re-enter the password"));
                    document.getElementById("<%= txtNewPassword.ClientID %>").focus();
                    isbool = false;
                }
                else if (retryPassword == "") {
                    $(msgControl).html(GetAlertMessages("Password fields cannot be blank"));
                    document.getElementById("<%= txtRetryNewPassord.ClientID %>").focus();
                    isbool = false;
                }
                else if (newPassword != retryPassword) {
                    $(msgControl).html(GetAlertMessages("New password and Re-Enter new password does not match. Please try again."));
                    document.getElementById("<%= txtNewPassword.ClientID %>").value = "";
                    document.getElementById("<%= txtRetryNewPassord.ClientID %>").value = "";
                    document.getElementById("<%= txtNewPassword.ClientID %>").focus();
                    isbool = false;
                }
                else if (!regularExpression.test(newPassword)) {
                    $(msgControl).html(GetAlertMessages("New Password should contain atleast one number and one special character."));
                    isbool = false;
                }
                
                return isbool;
            }
           
        }
        //********************************************************
        //ClearData Function clears the form
        //********************************************************

        function ClearData() {
            document.getElementById("<%= txtOldPassword.ClientID %>").value = ""
            document.getElementById("<%= txtNewPassword.ClientID %>").value = ""
            document.getElementById("<%= txtRetryNewPassord.ClientID %>").value = ""
            document.getElementById("<%= txtOldPassword.ClientID %>").focus();
        }
        //********************************************************
        //ClearData Function navigate to Homepage
        //********************************************************



        $(document).ready(function () {
            $(this).keydown(function (event) {
                if (event.keyCode == 13) {
                    event.preventDefault();
                   // document.getElementById("btnSubmit").click();
                }
            });

        });

    </script>
    <style type="text/css">
        .table1
        {
            height: 157px;
            width: 450px;
            border: 0px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Change Password</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Change Password</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="page-content">
    	<div class="panel">
        	<div class="panel-body">
            <div class="row">
                
                    <div class="form-group">
                        <div id="divMsg" runat="server" >
                        </div>
                    </div>
                
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="Label4" runat="server" CssClass="control-label" Text="(Password should contain 8-20 characters, at least one special character and one numeric value.)"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="Label1" CssClass="control-label" runat="server" Text="Current Password :"></asp:Label>
                        <asp:TextBox ID="txtOldPassword" runat="server" CssClass="form-control" MaxLength="50" Text="" EnableViewState="False"
                            TextMode="Password"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="Label2" CssClass="control-label" runat="server" Text="New Password :"></asp:Label>
                        <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control" MaxLength="50" Text="" TextMode="Password"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="Label3" CssClass="control-label" runat="server" Text="Re-Enter New Password :"></asp:Label>
                        <asp:TextBox ID="txtRetryNewPassord" CssClass="form-control" runat="server" MaxLength="50" Text="" TextMode="Password"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:HiddenField ID="hdnUserName" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />

                        <button name="btnSubmit" class="btn btn-success btn-labeled fa fa-save white" onclick="return ValidateUser();">Save</button>
                        <button name="btnClear" class="btn btn-danger btn-labeled fa fa-eraser white" onclick="ClearData(); return false;">Clear</button>
                        <button name="btnCancel" runat="server" onserverclick="btnCancel_Click" class="btn btn-danger btn-labeled fa fa-close white">Close</button>
                    </div>
                </div>
            </div>
       		</div>
      </div>
 </div>
</asp:Content>
