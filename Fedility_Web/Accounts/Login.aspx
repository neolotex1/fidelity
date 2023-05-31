<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true"
    CodeBehind="Login.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Login" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <script language="javascript" type="text/javascript">
        ///check for keyDownFunction()
        $(document).ready(function () {
           
           // document.location.href = "../maintenance.htm";

            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
            loginmessage = "<%= hdnmessage.ClientID %>";
           
            btnSubmitControlID = "<%= btnSubmit.ClientID %>";
            if (document.getElementById("<%= chkDomainUser.ClientID%>").checked == false) {
                document.getElementById("<%= drpDomain.ClientID%>").disabled = true;
            }
            else {
                document.getElementById("<%= drpDomain.ClientID%>").disabled = false;
            }
            btnrefreshCaptcha = "<%= btnrefreshcapta.ClientID %>";

        });

        function ValidateUser() {
          // document.getElementById("<%= txtCaptcha.ClientID %>").value = document.getElementById("<%= hdnCapta.ClientID %>").value;
            var msgControl = "#<%= divMsg.ClientID %>";
            var action = "ValidateUser";

            var password = $("#<%= txtPassword.ClientID %>").val();
            var loginOrgCode = $("#<%= hdnLoginOrgCode.ClientID %>").val();
            var username = $("#<%= txtUsername.ClientID %>").val();
            var password = $("#<%= txtPassword.ClientID %>").val();
            var isDomainUser = false; // DUEN - Add
            var Domain = $("#<%= drpDomain.ClientID %>").val();
            if (typeof Domain == 'undefined' || Domain == null) {
                Domain = 0;
            }
            if (Domain > 0) isDomainUser = true;
            var params = loginOrgCode + '|' + username + '|' + password + '|' + isDomainUser + '|' + Domain;

            if (ValidateInputData(msgControl, action, loginOrgCode, username, password)) {
                return CallPostScalar(msgControl, action, params);
            }
            else {
                return false;
            }
        }
        //********************************************************
        //ValidateInputData Function returns true or false with message to user on contorl specified
        //********************************************************

        function ValidateInputData(msgControl, action, loginOrgCode, username, password) {
            $(msgControl).html("");

            var txtCapta = $("#<%= txtCaptcha.ClientID %>").val();
            var capta = $("#<%= hdnCapta.ClientID %>").val();
            if (action == "ValidateUser") {
                if (username == "" || username == "username") {


                    $(msgControl).html(GetAlertMessages("Please enter a user name"));
                    //$(msgControl).show("slow").delay(2000).hide("slow");
                    document.getElementById("<%= txtUsername.ClientID %>").focus();
                    return false;
                }
                else if (password == "" || password == "password") {
                    $(msgControl).html(GetAlertMessages("Please enter a password"));
                    //$(msgControl).show("slow").delay(2000).hide("slow");
                    document.getElementById("<%= txtPassword.ClientID %>").focus();
                    return false;
                }
                /*else if (document.getElementById("<%= chkDomainUser.ClientID%>").checked == true && $("#<%= drpDomain.ClientID %>").val() == "0") {
                $(msgControl).html("<div class='alert alert-danger fade in'><button data-dismiss='alert' class='close'><span>X</span></button><strong>Please select domain</strong></div>");
                document.getElementById("<%= drpDomain.ClientID %>").focus();
                return false;
                }*/
                else if (txtCapta == "") {
                    $(msgControl).html(GetAlertMessages("Please enter captcha"));
                    //$(msgControl).show("slow").delay(2000).hide("slow");
                    document.getElementById("<%= txtCaptcha.ClientID %>").focus();
                    return false;
                }
                else if (capta != txtCapta) {
                    $(msgControl).html(GetAlertMessages("Invalid captcha..!"));
                    document.getElementById("<%= txtCaptcha.ClientID %>").focus();
                    //document.getElementById("<%= hdnmessage.ClientID %>").value = "Invalid captcha..!";
                  //  document.getElementById("<%= btnrefreshcapta.ClientID %>").click();
                    return false;

                }



                return true;
            }
        }

        /*---Added newly by sabina to login on enter key press from password textbox to make compatibile with firefox and chrome----*/
        $(document).ready(function () {
            $("#<%= txtPassword.ClientID %>,#<%= txtUsername.ClientID %>,#<%= txtCaptcha.ClientID %>").keydown(function (event) {
                if (event.keyCode == 13) {
                    event.preventDefault();
                    document.getElementById("btnValidate").click();

                }
            });

        });



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

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="sm1" runat="server" AsyncPostBackTimeout="1600" />
    <!--===================================================-->
    <!-- LOGIN FORM -->
    <!--===================================================-->
    <div class="cls-content">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
            <ContentTemplate>
                <div class="col-md-4 col-lg-push-8 ">
                   <%-- <div id="divMsg" runat="server" class="MessageMediumStyle">--%>
                    </div>
                </div>
                <div class="cls-content-sm login-box panel">
                
                    <div class="panel-body">
                        <p class="pad-btm">
                            Sign In to your account
                        </p>
                        <div >
                             <div id="divMsg" runat="server" class="MessageMediumStyle">
                        </div>
                        <div class="form-group" >
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-bars"></i>
                                </div>
                                <asp:DropDownList ID="drpDomain" runat="server" CssClass="form-control" TabIndex="5">
                                </asp:DropDownList>
                                <!-- <select class="selectpicker">
													<option>Choose one..</option>
                                                    <option>Super Admin</option>
													<option>Admin</option>
													<option>Customer</option>
													<option>Client</option>
				           </select>-->
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-user"></i>
                                </div>
                                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Username"
                                    TabIndex="1"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-asterisk"></i>
                                </div>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Password"
                                    TextMode="Password" TabIndex="2"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <div class="input-group-addon" style="width: 65%; padding: 3px; background: #fff;
                                    border-right: 1px solid #999;">
                                    <asp:Image ID="imgCaptcha" runat="server" Style="vertical-align: middle" />
                                </div>
                                <asp:ImageButton ID="btnRefreshddg" OnClick="btnRefresh_Click" ImageUrl="../Images/refresh.png"
                                    Width="40" Height="" runat="server" />
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <%--   <asp:Label ID="lblcaptcha" runat="server" Text="Captcha" ToolTip="Captcha" Style="color: black; font-weight: bold;"></asp:Label>--%>
                                <div class="input-group-addon">
                                    <i class="fa fa-asterisk"></i>
                                </div>
                                <asp:TextBox ID="txtCaptcha" runat="server" CssClass="form-control" TabIndex="2"
                                    placeholder="Captcha" autocomplete="off"></asp:TextBox>
                            </div>
                        </div>
                        <div class="clearfix">
                        </div>
                        <div class="form-group" style="display: none;">
                            <div class="input-group">
                                Active Directory
                                <asp:CheckBox ID="chkDomainUser" runat="server" Checked="true" onclick="return checkdomain();"
                                    TabIndex="4" Style="margin-left: 20px;" />
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <a href="forgotPassword.aspx" class="btn-link">Forgot password ? </a>
                            </div>
                            <div class="clearfix">
                            </div>
                            <div class="col-md-2 col-md-offset-2">
                                <input type="button" id="btnValidate" value="LOGIN" class="btn login-btn btn-success fa fa-sign-in"
                                    onclick="ValidateUser();return false;" />
                            </div>
                        </div>
                    </div>
                    <div class="row login-footer" style="min-height: 0px;">
                    </div>
                </div>
                <asp:HiddenField ID="hdnLoginOrgCode" runat="server" Value="" />
                <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                <asp:HiddenField ID="hdnCapta" runat="server" Value="" />
                <asp:HiddenField ID="hdnmessage" runat="server" Value="" />
                <asp:Button ID="btnSubmit" Style="display: none" runat="server" Text="Login" OnClick="btnSubmit_Click"
                    TabIndex="20" />
                <asp:Button ID="btnrefreshcapta" runat="server" class="HiddenButton" Text="capta"
                    OnClick="btnrefreshcapta_Click" Style="display: none" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <!--===================================================-->
</asp:Content>
