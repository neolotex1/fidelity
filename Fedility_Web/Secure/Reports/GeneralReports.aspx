<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GeneralReports.aspx.cs" MasterPageFile="~/doQman.Master" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Reports.GeneralReports" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../../Scripts/jquery-1.10.2.js" type="text/javascript"></script>
    <script type="text/javascript">


        $(document).ready(function () {

            AttachCalander();
        });
        function AttachCalander() {
            $('#calendarComponentFrom .input-group.date').datepicker({ autoclose: true });
            $('#calendarComponentTo .input-group.date').datepicker({ autoclose: true });
        }
        function ValidateSearch() {
            var fromDate = document.getElementById("<%= txtCreatedDateFrom.ClientID %>");
            var toDate = document.getElementById("<%= txtCreatedDateTo.ClientID %>");
            var lblMsg = document.getElementById("<%= lblMessage.ClientID %>");

            lblMsg.innerHTML = "";
            var x = new Date(fromDate.value);
            var y = new Date(toDate.value);
            if (fromDate.value == "" || fromDate.value == undefined) {
                lblMsg.innerHTML = (GetAlertMessages("Please enter the Created Date From"));
                return false;
            }
            else if (toDate.value == "" || toDate.value == undefined) {
                lblMsg.innerHTML = (GetAlertMessages("Please enter the Created Date To"));
                return false;
            }
            else if (x > y) {
                lblMsg.innerHTML = (GetAlertMessages("To date should be greater than From date"));
                return false;
            }

        }
        window.onload = function () {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
        }
        function endRequestHandler(sender, args) {
            init();
        }
        function init() {
            var action = getUrlParameter('Action');
            if (action == "doQscanReports") {

                document.getElementById("Landiv").style.display = "block";
                document.getElementById("divhub").style.display = "none";
            }
            else {
                document.getElementById("Landiv").style.display = "none";
                document.getElementById("divhub").style.display = "block";

            }
        }
        $(function () { // DOM ready
            init();
        });
        function getUrlParameter(name) {
            name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
            var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
            var results = regex.exec(location.search);
            return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
        };

        
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
           <%=Module %> Report</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active"> <%=Module %> Report</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="page-content">
    <div class="panel">
        <div class="panel-body">
         <div class="row">
                        <div id="lblMessage" runat="server">
                    </div>
                    </div>
            <asp:UpdatePanel ID="UpdatePanel8" runat="server" UpdateMode="Always">
                <ContentTemplate>
                 <div class="row">
                   <div id="lblmsg" runat="server"></div>
                   </div>
                   <br /><br /><br /><br />
                  
                    <div class="row" style="display:none;">
                        <div class="col-sm-2">
                            <div class="form-group">
                                <asp:Label ID="Label2" runat="server" CssClass="control-label" Text="State"></asp:Label>
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
                    <div class="row" id="divhub" style="display:none;">
                        <div class="col-sm-2">
                            <div class="form-group">
                                <asp:Label ID="lblHub" runat="server" CssClass="control-label" Text="Hub"></asp:Label>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group">
                                <asp:DropDownList ID="ddlHub" CssClass="form-control input-sm" runat="server" AutoPostBack="True"
                                    OnSelectedIndexChanged="ddlHub_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="divbranch" style="display:none;">
                        <div class="col-sm-2">
                            <div class="form-group">
                                <asp:Label ID="lblBranch" runat="server" CssClass="control-label" Text="Branch"></asp:Label>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group">
                                <asp:DropDownList ID="ddlbrach" CssClass="form-control input-sm" runat="server">
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                      <div class="row" id="workflowdiv" runat="server" style="display:none">
                        <div class="col-sm-2">
                            <div class="form-group">
                                <asp:Label ID="lblworkflow" runat="server" CssClass="control-label" Text="WorkFlow"></asp:Label>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group">
                                <asp:DropDownList ID="ddlworkflow" CssClass="form-control input-sm" runat="server">
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="Landiv">
                        <div class="col-sm-2">
                            <div class="form-group">
                                <asp:Label ID="Label4" runat="server" CssClass="control-label" Text="Employee code"></asp:Label>
                            </div>
                        </div>
                        <div class="col-sm-3">
                            <div class="form-group">
                                <asp:TextBox ID="txtlan" Text="" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div class="row">
                <div class="col-sm-2">
                    <div class="form-group">
                        <asp:Label ID="Label1" runat="server" CssClass="control-label" Text="From Date"></asp:Label>
                         <span style="color: Red">*</span>
                    </div>
                </div>
                <div class="col-sm-3">
                    <div class="form-group">
                        <div id="calendarComponentFrom">
                            <div class="input-group date">
                                <asp:TextBox ID="txtCreatedDateFrom" CssClass="form-control" runat="server" ToolTip="Date Format - mm/dd/yyyy"
                                    placeholder="Created Date From"></asp:TextBox>
                                <span class="input-group-addon"><i class="fa fa-calendar fa-lg"></i></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
               <div class="col-sm-2">
                    <div class="form-group">
                       <asp:Label ID="Label3" runat="server" CssClass="control-label" Text="TO Date"></asp:Label>
                        <span style="color: Red">*</span>
                    </div>
                    </div>
                <div class="col-sm-3">
                    <div class="form-group">
                     
                        <div id="calendarComponentTo">
                            <div class="input-group date">
                                <asp:TextBox ID="txtCreatedDateTo" CssClass="form-control" runat="server" ToolTip="Date Format - mm/dd/yyyy"
                                    placeholder="Created Date To"></asp:TextBox>
                                <span class="input-group-addon"><i class="fa fa-calendar fa-lg"></i></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
                <ContentTemplate>
                    <div class="row">
                        <div class="col-sm-6">
                            <div style="float:left; padding-right:3px">
                            <i class="fa fa-search btn-style btn-primary white">
                                <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary"
                                    TagName="Read" OnClick="btnSearch_Click" OnClientClick="return ValidateSearch();"/></i></div>
                                    <div id="idDownload" runat="server">
                                    <i class="fa fa-download btn-style btn-primary white">
                                <asp:LinkButton ID="lnkdownload" runat="server" OnClick="lnkdownload_Click" CssClass="btn btn-primary ">Download</asp:LinkButton></i></div>
                            
                        </div>
                    </div>
                    <br />
                    <div class="row">
                        <div class="table-responsive">
                        
                            <div class="form-group">
                                <asp:GridView ID="gridreport" runat="server" DataKeyNames="Id#" AllowPaging="True"
                                    PageSize="10" CssClass="table table-striped table-bordered" PagerStyle-CssClass="pgr"
                                    OnPageIndexChanging="gridreport_PageIndexChanging">
                                    <AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
                                    <PagerSettings FirstPageText="<<" LastPageText=">>" Mode="NumericFirstLast" NextPageText=" "
                                        PageButtonCount="5" PreviousPageText=" " />
                                    <PagerStyle CssClass="pagination-ys" />
                                </asp:GridView>
                                <asp:GridView ID="GridView1" runat="server" Style="display: none;">
                                </asp:GridView>
                            </div>
                       </div>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
 </div>
</asp:Content>