<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="UserMapping.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Core.UserMapping" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
<script language="javascript" type="text/javascript">

    function ValidateDropdown(ddl) {
        if (ddl.value <= 0) {

            var divmsg = document.getElementById("<%= divmsg.ClientID %>");
            divmsg.innerHTML = GetAlertMessages("Please select one from " + ddl.id.replace("ctl00_ContentPlaceHolder1_ddl", ""));

            return false;
        }
        return true;
    }
    function validateUserMapping() {
        var isValid = true;
        var UserName = document.getElementById("ctl00_ContentPlaceHolder1_ddlUserName");
        var UserType = document.getElementById("ctl00_ContentPlaceHolder1_ddlUserType");
        var State = document.getElementById("ctl00_ContentPlaceHolder1_ddlstate");
        var Hub = document.getElementById("ctl00_ContentPlaceHolder1_ddlhub");
        var Cluster = document.getElementById("ctl00_ContentPlaceHolder1_ddlcluster");
        var Branch = document.getElementById("ctl00_ContentPlaceHolder1_ddlbranch");
        isValid = isValid ? ValidateDropdown(UserName) : false;
        isValid = isValid ? ValidateDropdown(UserType) : false;
        if (!isValid) {
            return isValid;
        }
        switch (UserType.value) {
            // branch users 
            case "1043":
                isValid = isValid ? ValidateDropdown(Hub) : false;
                //isValid = isValid ? ValidateDropdown(ddlcluster) : false;
                isValid = isValid ? ValidateDropdown(Branch) : false;
                break;
            // hub user 
            case "1044":
                isValid = isValid ? ValidateDropdown(Hub) : false;
                break;
            // audit user 
            case "1045":
                //  isValid = isValid ? ValidateDropdown(Hub) : false;
                break;
            //  ho user 
            case "1046":
                //isValid = isValid ? ValidateDropdown(ddlstate) : false;
                break;
            // CopsUser 
            case "1074":
                //isValid = isValid ? ValidateDropdown(ddlstate) : false;
                break;
            //Cluster User 
            case "1075":
                isValid = isValid ? ValidateDropdown(State) : false;
                //isValid = isValid ? ValidateDropdown(ddlhub) : false;
                isValid = isValid ? ValidateDropdown(Cluster) : false;
                isValid = isValid ? ValidateDropdown(Branch) : false;
                break;
            //Branch Manager 
            case "1076":
                isValid = isValid ? ValidateDropdown(Hub) : false;
                //isValid = isValid ? ValidateDropdown(ddlcluster) : false;
                isValid = isValid ? ValidateDropdown(Branch) : false;
                break;
            //Cluster Manager 
            case "1077":
            case "1097":
            case "1099":
                // isValid = isValid ? ValidateDropdown(State) : false;
                //isValid = isValid ? ValidateDropdown(ddlhub) : false;
                isValid = isValid ? ValidateDropdown(Cluster) : false;
                //  isValid = isValid ? ValidateDropdown(Branch) : false;
                break;
            //AM User 
            case "1111":
         
                divstate.setAttribute("style", "display:block");
                divhub.setAttribute("style", "display:block");
                break;
            // Hub Manager 
            case "1078":
                isValid = isValid ? ValidateDropdown(Hub) : false;
                break;
            //State User 
            case "1079":
                isValid = isValid ? ValidateDropdown(State) : false;
                break;
            //State Manager 
            case "1080":
            case "1098":
                isValid = isValid ? ValidateDropdown(State) : false;
                break;
            default:
                break;
        }

        return isValid;

    }

    function HandleControls() {
        var divstate = document.getElementById("ctl00_ContentPlaceHolder1_divstate");
        var divhub = document.getElementById("ctl00_ContentPlaceHolder1_divhub");
        var divCluster = document.getElementById("ctl00_ContentPlaceHolder1_divCluster");
        var divBranch = document.getElementById("ctl00_ContentPlaceHolder1_divBranch");

        var UserType = document.getElementById("ctl00_ContentPlaceHolder1_ddlUserType");

        divstate.setAttribute("style", "display:none");
        divhub.setAttribute("style", "display:none");
        divCluster.setAttribute("style", "display:none");
        divBranch.setAttribute("style", "display:none");
        switch (UserType.value) {
        
            // branch users  
            case "1043":
            case "1112":
                divstate.setAttribute("style", "display:block");
                divhub.setAttribute("style", "display:block");
                divBranch.setAttribute("style", "display:block");
                break;
            // hub user  
            case "1044":
                divhub.setAttribute("style", "display:block");
                break;
            // audit user  
            case "1045":
                // divhub.setAttribute("style", "display:block");
                break;
            //AM User  
            case "1111":
            case "1113":
                divstate.setAttribute("style", "display:block");
                divhub.setAttribute("style", "display:block");
                break;
            //  ho user  
            case "1046":
                divstate.setAttribute("style", "display:block");
                break;
            // CopsUser  
            case "1074":
                divstate.setAttribute("style", "display:block");
                break;
            //Cluster User  
            case "1075":
                divstate.setAttribute("style", "display:block");
                divCluster.setAttribute("style", "display:block");
                divBranch.setAttribute("style", "display:block");
                break;
            //Branch Manager  
            case "1076":
                divhub.setAttribute("style", "display:block");
                divBranch.setAttribute("style", "display:block");
                break;
            //Cluster Manager  
            case "1077":
            case "1097":
            case "1099":
                //   divstate.setAttribute("style", "display:block");
                divCluster.setAttribute("style", "display:block");
                //   divBranch.setAttribute("style", "display:block");
                break;
            // Hub Manager  
            case "1078":
                divhub.setAttribute("style", "display:block");
                break;
            //State User  
            case "1079":
                divstate.setAttribute("style", "display:block");
                break;
            //State Manager  
            case "1080":
            case "1098":
                divstate.setAttribute("style", "display:block");
                break;
            case "1109":
            case "1110":
                divstate.setAttribute("style", "display:block");
                divhub.setAttribute("style", "display:block");
                divBranch.setAttribute("style", "display:block");
                break;
            default:
                break;
        }
    }
    window.onload = function () {
        Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
    }
    function endRequestHandler(sender, args) {
        init();
    }

    function init() {
        HandleControls();
    }
    $(function () { // DOM ready
        init();
    });
</script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Manage User Mapping</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Manage User Mapping</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="page-content">
        <div class="panel">
            <div class="panel-body">
            <div class="row">
                            <div id="divmsg" runat="server">
                            </div>
                        </div>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
                    <ContentTemplate>
                        
                        <div class="row">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:Label ID="lblHead4" runat="server" CssClass="control-label" Text="User Name"></asp:Label>
                                    <asp:Label CssClass="control-label" ID="Label6" runat="server" Text="*"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlUserName" CssClass="form-control input-sm" runat="server"
                                        AutoPostBack="True" OnSelectedIndexChanged="ddlUserName_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:Label ID="Label1" runat="server" CssClass="control-label" Text="User Type"></asp:Label>
                                    <asp:Label CssClass="control-label" ID="Label2" runat="server" Text="*"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlUserType" CssClass="form-control input-sm" runat="server"
                                        AutoPostBack="True" OnSelectedIndexChanged="ddlUserType_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="divstate" runat="server">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:Label ID="Label3" runat="server" CssClass="control-label" Text="State"></asp:Label>
                                    <asp:Label CssClass="control-label" ID="Label4" runat="server" Text="*"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlstate" CssClass="form-control input-sm" runat="server" AutoPostBack="True"
                                        OnSelectedIndexChanged="ddlstate_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="divhub" runat="server">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:Label ID="Label8" runat="server" CssClass="control-label" Text="Hub"></asp:Label>
                                    <asp:Label CssClass="control-label" ID="Label9" runat="server" Text="*"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlhub" CssClass="form-control input-sm" runat="server" AutoPostBack="True"
                                        OnSelectedIndexChanged="ddlhub_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="divCluster" runat="server">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:Label ID="Label10" runat="server" CssClass="control-label" Text="Cluster"></asp:Label>
                                    <asp:Label CssClass="control-label" ID="Label11" runat="server" Text="*"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlcluster" CssClass="form-control input-sm" runat="server"
                                        AutoPostBack="True" OnSelectedIndexChanged="ddlcluster_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="divBranch" runat="server">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:Label ID="Label5" runat="server" CssClass="control-label" Text="Branch"></asp:Label>
                                    <asp:Label CssClass="control-label" ID="Label7" runat="server" Text="*"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="ddlbranch" CssClass="form-control input-sm" runat="server">
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3">
                                <div class="form-group">
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <i class="fa fa-floppy-o btn-style btn-primary white">
                                        <asp:Button ID="btnsubmit" runat="server" Text="Submit" CssClass="btn btn-primary"
                                            TagName="Read" OnClick="btnsubmit_Click" OnClientClick="return validateUserMapping();" /></i> <i class="fa fa-ban btn-style btn-danger white">
                                                <asp:Button ID="btncancel" runat="server" Text="Cancel" CssClass="btn btn-danger"
                                                    TagName="Read" OnClick="btncancel_Click" /></i>
                                    <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnselectedUserId" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnIsRequiredCluster" runat="server" Value="" />
                                </div>
                            </div>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
</asp:Content>
