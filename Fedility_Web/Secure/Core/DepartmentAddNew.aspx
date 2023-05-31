<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DepartmentAddNew.aspx.cs"
    Inherits="Lotex.EnterpriseSolutions.WebUI.DptAddNew" MasterPageFile="~/doQman.Master"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <%-- <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Scripts/jquery-1.7-vsdoc.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Scripts/jquery-1.7.min.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Scripts/jquery-1.7.js") %>"></script>
    <script type="text/javascript" language="javascript" src="<%=Page.ResolveClientUrl("~/Assets/Scripts/AjaxPostScripts.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Assets/Scripts/master.js") %>"></script>--%>
    <script type="text/javascript">
        //Department_Add Final Validation
        function DeptAddValidate() {

            var Deptname = document.getElementById('<%= txtDptName.ClientID %>');
            if (Deptname.value.length < 2) {
                var msgControl = "#<%= divMsg.ClientID %>";
                $(msgControl).html(GetAlertMessages("Department Name should contain atleast two character!"));
                return false;
            }
            else {
                return true;
            }
        }

        //texbox validation - Only Characters and '-' Symbol
        function CheckNumericKeyInfo(event) {
            var char1 = (event.keyCode ? event.keyCode : event.which);
            if ((char1 >= 65 && char1 <= 90) || (char1 >= 97 && char1 <= 122) || char1 == 45 || char1 == 32 || char1 == 8 || char1 == 46) {
                RetVal = true;
            }
            else {
                RetVal = false;
            }
            return RetVal;
        }

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Manage Departments</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Manage Departments</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="page-content">
    <div class="panel">
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label  CssClass="control-label" ID="lblHeading" runat="server" Text="Add New Department"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label  CssClass="control-label" ID="lblPageDescription" runat="server"
                            Text="*" ForeColor="red"></asp:Label>
                        <asp:Label  CssClass="control-label" ID="lblPageDescription0" runat="server" Text=" Indicates mandatory fields"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="row">
                
                    <div class="form-group">
                        <div id="divMsg" runat="server" style="color: Red; font-family: Calibri; font-size: small;">
                        </div>
                    </div>
               
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblDprtmntName" runat="server"  CssClass="control-label" Text="Department Name "></asp:Label>
                        <asp:Label  CssClass="control-label" ID="lblPageDescription1" runat="server"
                            Text="*" ForeColor="red"></asp:Label>
                        <asp:TextBox ID="txtDptName" runat="server" OnKeyPress="return CheckNumericKeyInfo(event)" CssClass="form-control"
                            MaxLength="20"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblDescription" runat="server"  CssClass="control-label" Text="Description"></asp:Label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" MaxLength="1000" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblHead" runat="server"  CssClass="control-label" Text="Head "></asp:Label>
                        <asp:TextBox ID="txtHead" runat="server" CssClass="form-control" OnKeyPress="return CheckNumericKeyInfo(event)"
                            MaxLength="20"></asp:TextBox>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <div visible="false">
                            <asp:TextBox ID="FreeText1" runat="server" Visible="false"></asp:TextBox></div>
                        <div visible="false">
                            <asp:TextBox ID="FreeText2" runat="server" Visible="false"></asp:TextBox></div>
                        <div visible="false">
                            <asp:TextBox ID="FreeText3" runat="server" Visible="false"></asp:TextBox></div>
                        <div visible="false">
                            <asp:TextBox ID="FreeText4" runat="server" Visible="false"></asp:TextBox></div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                      <div style="float:left; padding-right:3px">
                      
                            <i class="fa fa-floppy-o btn-style white btn-primary">
                        <asp:Button ID="btnSubmit" runat="server" Text="Submit" class="btn btn-primary" OnClick="btnSubmit_Click"
                            TagName="Add" /></i>
                            <i class="fa fa-ban btn-style white btn-danger">
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" class="btn btn-danger" OnClick="btnCancel_Click"
                            TagName="Add" /></i></div>
                             <div style="float:left" id="divhide" visible="false" runat="server">
                            <i class="fa fa-search btn-style btn-primary white ">
                            <asp:Button ID="btnsearchagain" runat="server" Text="Search Again" CssClass="btn btn-primary "
                            TagName="Read"  OnClick="btnsearchagain_Click" /></i>
                            </div>
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                        <asp:HiddenField ID="HiddenField1" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
</asp:Content>
