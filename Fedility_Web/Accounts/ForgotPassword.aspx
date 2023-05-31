<%@ Page Title="" Language="C#" MasterPageFile="~/Default.Master" AutoEventWireup="true"
    CodeBehind="ForgotPassword.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.ForgotPassword" %>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">

  <script language="javascript" type="text/javascript">

      ///check for keyDownFunction()
      $(document).ready(function () {
          loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
          loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
          btnSubmitControlID = "<%= btnSubmit.ClientID %>";
          hdnOrglinkControlID = "<%= hdnOrglink.ClientID %>";
          btnRequestPasswordControlID = "<%= btnRequestPassword.ClientID %>";
      });

      function ForgotPasswordRequest() {
          var msgControl = "#<%= divMsg.ClientID %>";
          var action = "ForgotPassword";
          var loginOrgName = $("#<%= hdnLoginOrgName.ClientID %>").val();
          var username = $("#<%= txtUsername.ClientID %>").val();
          var params = loginOrgName + '|' + username;
          if (ValidateInputData(msgControl, action, username)) {

              document.getElementById("<%= btnRequestPassword.ClientID %>").disabled = true;

              return CallPostScalar(msgControl, action, params);
          }
          else {

              return false;
          }
      }
      //********************************************************
      //ValidateInputData Function returns true or false with message to user on contorl specified
      //********************************************************

      function ValidateInputData(msgControl, action, username) {
          $(msgControl).html("");
          if (action == "ForgotPassword") {
              if (username == "") {
                  $(msgControl).html("Username cannot be blank.");
                  document.getElementById("<%= txtUsername.ClientID %>").focus();
                  return false;
              }
              return true;
          }
      }
      //********************************************************
      //ClearData Function clears the form
      //********************************************************

      function ClearData() {
          document.getElementById("<%= txtUsername.ClientID %>").value = "";
          document.getElementById("<%= txtUsername.ClientID %>").focus();
          document.getElementById("<%= btnRequestPassword.ClientID %>").disabled = false;
      }
      //********************************************************
      //ClearData Function navigate to Homepage
      //********************************************************

            

    </script>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="sm1" runat="server" AsyncPostBackTimeout="1600" />
    <!--===================================================-->
    <!-- LOGIN FORM -->
    <!--===================================================-->
    <div class="cls-content">
    <div align="center" class="CenterBaseDiv">
    <div class="col-md-4 col-md-offset-4 panel login-box">
        <div class="LoginPanel">
        <div class="panel-body">
                        <p class="pad-btm"></p>



                        <div class="style5">
                            <div class="row">
                                <div class="col-md-6 form-group">
                                    <div id="divMsg" runat="server" class="MessageMediumStyle">
                            &nbsp;</div>
                                </div>
                            </div>
                            <div class="row form-group">
                                <div class="col-md-4">
                                    <asp:Label ID="Label5" runat="server" CssClass="LabelMediumStyle" Text="User ID"
                            Style="color: black; font-weight: bold;"></asp:Label>
                                </div>
                                <div class="col-md-6">
                                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" Width="192px"
                            MaxLength="50"></asp:TextBox>
                                </div>
                                </div>

                            </div><br />
            <div class="row form-group">
                <div class="col-md-6">
                    <asp:HiddenField ID="hdnLoginOrgName" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                        <asp:HiddenField ID="hdnOrglink" runat="server" Value="" />
                        </div>
            </div>
            <div class="row form-group">
            
            
                        <%--                        <input type="button" class="ButtonStyle" id="btnRequestPassword" value="Submit" onclick="ForgotPasswordRequest();"
                            style="color: #000000; background-color: #f5deb3; font-weight: bold;" />--%>
                            <i class="fa fa-floppy-o btn-style btn-primary white">
                        <asp:Button ID="btnRequestPassword" class="btnlogin" CssClass="btn btn-primary" runat="server" Text="Submit"
                            OnClientClick="ForgotPasswordRequest();return false;" /></i>
                            <i class="fa fa-eraser btn-style btn-danger white">
                        <input type="button" class="btn btn-danger"  id="btnClear" value="Clear" onclick="ClearData();"/></i>
                        <i class="fa fa-close btn-style btn-pink white">
                        <asp:Button ID="btnClose" runat="server" Text="Close" CssClass="btn btn-pink" OnClick="btnClose_Click"/></i>
                <div style="visibility:hidden">
                
                        <asp:Button ID="btnSubmit" class="HiddenButton" runat="server" Text="Login" OnClick="btnSubmit_Click"
                            BackColor="Wheat" Font-Bold="True" />
                            </div>
                </div>

                        </div>
        
            </div>
        </div>
        </div>
    </div>
    </div>
    <!--===================================================-->
    
</asp:Content>
