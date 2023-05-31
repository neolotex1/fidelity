<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="BulkUploadUsers.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Core.BulkUploadUsers"
    EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <link href="../../App_Themes/common/common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/GridRowSelection.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
        });

        function uploadStart(sender, args) {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var result;
            var filename = args.get_fileName();
            var filext = filename.substring(filename.lastIndexOf(".") + 1);

            if (filext == 'xlsx') {
                return true;
            }
            else {
                var err = new Error();
                err.name = 'My API Input Error';
                err.message = 'File format not supported! (Supported format xlsx)';
                throw (err);
                return false;
            }
        }

        function processExcelData() {
           
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");

            document.getElementById('<%=hdnBtnAction.ClientID%>').value = "ReadExcelData";            
            document.getElementById('<%=btnSubmit.ClientID%>').click();
           
        }

        function deleteuser(UserID) {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            if (confirm("Do you want to delete this user?") == true) {
                document.getElementById('<%=hdnBtnAction.ClientID%>').value = "DeleteUser";
                document.getElementById('<%=hdnUserID.ClientID%>').value = UserID;
                document.getElementById('<%=btnSubmitSave.ClientID%>').click();
            }
        }

        function deleteall() {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            if (confirm("Do you want to discard these users?") == true) {
                document.getElementById('<%=hdnBtnAction.ClientID%>').value = "DiscardUsers";
                document.getElementById('<%=btnSubmitSave.ClientID%>').click();
                return false;
            }
            return false;
        }

        function commitusers() {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            if (confirm("Do you want to commit these users?") == true) {
                document.getElementById('<%=hdnBtnAction.ClientID%>').value = "CommitUsers";
                document.getElementById('<%=btnSubmitSave.ClientID%>').click();
                return false;
            }
            else {
                return false;
            }
        }
        

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Bulk Upload User</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Bulk Upload User</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

                              <asp:HiddenField ID="hdnBtnAction" runat="server" Value="" />
<div id="page-content">
    <div class="panel">
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblFileUpload" runat="server" Text="Choose a file to upload : "></asp:Label>
                        <asp:AsyncFileUpload ID="UsersAsyncFileUpload" runat="server" AsyncPostBackTimeout="1600"
                            CompleteBackColor="Lime" OnUploadedComplete="UsersAsyncFileUpload_UploadedComplete"
                            ErrorBackColor="Red" ThrobberID="Throbber" OnClientUploadStarted="uploadStart"
                            OnClientUploadComplete="processExcelData" UploadingBackColor="#66CCFF" Width="160px"
                            CssClass="ServerControl3" />
                        <asp:Label ID="Throbber" runat="server" Style="display: none">
        <img alt="Loading..." src="<%= Page.ResolveClientUrl("~/Images/indicator.gif")%>" /></asp:Label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                    <i class="fa fa-download btn-style white btn-success">
                        <asp:Button ID="btnDownloadTemplate" runat="server" CssClass="btn btn-success"
                            Text="Download Template" TagName="Read" OnClick="btnDownloadTemplate_Click" /></i>
                        <asp:UpdatePanel ID="UpdatePanel4" runat="server" UpdateMode="Always" RenderMode="Inline">
                            <ContentTemplate>
                                <asp:Button ID="btnSubmit" Style="visibility: hidden" runat="server" Text="ProcessExcel"
                                    TagName="Read" OnClick="btnSubmit_Click" />
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </div>
            </div>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always" RenderMode="Block">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <div id="divMsg" runat="server" style="color: Red">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <asp:Button ID="btnDiscard" runat="server" Text="Discard Users" OnClientClick="return deleteall();return false;"
                                    Class="btn btn-primary btn-rounded" TagName="Read" Style="margin: 15px 15px 15px 2px;" />
                                <asp:Button ID="btnCommit" runat="server" Text="Commit Users" OnClientClick="return commitusers();return false;"
                                    Class="btn btn-primary btn-rounded" TagName="Read" Style="margin: 15px 15px 15px 15px;" />
                            </div>
                        </div>
                    </div>
                   
                    
                    <div class="row">
                     <div class="table-responsive">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <asp:GridView ID="grdView" runat="server" AutoGenerateColumns="true" EmptyDataText="No record found."
                                   CssClass="table table-striped table-bordered"
                                    PagerStyle-CssClass="pgr" AlternatingRowStyle-CssClass="alt" CellPadding="10"
                                    CellSpacing="5" OnRowDataBound="grdView_RowDataBound" AllowSorting="True" OnSorting="grdView_Sorting">
                                    <PagerStyle CssClass="pagination-ys" />
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                    </div>
                    <div id="PageDiv" runat="server">
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    Rows per page
                                    <asp:DropDownList ID="ddlRows" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlRows_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    <asp:Button ID="lnkbtnFirst" Text="First" Class="btn btn-primary btn-rounded" ToolTip="First"
                                        CommandName="First" runat="server" OnCommand="GetPageIndex"></asp:Button>
                                    <asp:Button ID="lnkbtnPre" ToolTip="Previous" Class="btn btn-primary btn-rounded"
                                        CommandName="Previous" Text="Previous  " runat="server" OnCommand="GetPageIndex">
                                    </asp:Button>
                                    Page
                                    <asp:DropDownList ID="ddlPage" runat="server" AutoPostBack="True" Style="width: 50px;"
                                        OnSelectedIndexChanged="ddlPage_SelectedIndexChanged">
                                    </asp:DropDownList>
                                    of
                                    <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                                    <asp:Button ID="lnkbtnNext" Text="Next" ToolTip="Next" runat="server" Class="btn btn-primary btn-rounded"
                                        CommandName="Next" OnCommand="GetPageIndex"></asp:Button>
                                    <asp:Button ID="lnkbtnLast" Text="Last" ToolTip="Last" runat="server" Class="btn btn-primary btn-rounded"
                                        CommandName="Last" OnCommand="GetPageIndex"></asp:Button>
                                    <asp:Label ID="lblMessage" runat="server" EnableViewState="false"></asp:Label>
                                    <asp:Button ID="btnSubmitSave" Style="visibility: hidden" runat="server" Text="Submit"
                                        TagName="Read" OnClick="btnSubmit_Click" />
                                    <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                                    <asp:HiddenField ID="hdnUserID" runat="server" Value="" />
                                </div>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    </div>
</asp:Content>
