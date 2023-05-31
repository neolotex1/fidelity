<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="SearchOrg.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.SearchOrg" %>

<%@ Register Assembly="RJS.Web.WebControl.PopCalendar" Namespace="RJS.Web.WebControl"
    TagPrefix="rjs" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <script language="javascript" type="text/javascript">
        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
            pageIdContorlID = "<%= hdnPageId.ClientID %>";
            FromDateControlId = "#<%= txtCreatedDateFrom.ClientID %>";
            ToDateControlId = "#<%= txtCreatedDateTo.ClientID %>";
            pageRightsContorlId = "<%= hdnPageRights.ClientID %>"
            $('#calendarComponentFrom .input-group.date').datepicker({ autoclose: true });
            $('#calendarComponentTo .input-group.date').datepicker({ autoclose: true });
        });
        function Search(action, deletItemId, deletItemName) {
            var msgControl = "#<%= divMsg.ClientID %>";
            var customerName = $.trim($("#<%= txtCustomerName.ClientID %>").val());
            var orgEmail = $("#<%= txtOrgEmail.ClientID %>").val();
            var createdDateFrom = $(FromDateControlId).val();
            var createDateTo = $(ToDateControlId).val();
            var currentPageId = $("#" + pageIdContorlID).val();
            var params = customerName + '|' + orgEmail + '|' + createdDateFrom + '|' + createDateTo + '|' + currentPageId + '|' + deletItemId + '|' + deletItemName;
            //             var array[4] = param.split('|');
            if (ValidateInputData(msgControl, action, customerName, orgEmail, createdDateFrom, createDateTo)) {
                document.getElementById("<%=hdnSearchString.ClientID %>").value = params;
                $("#divSearchResults").html("");
                return CallPostScalar(msgControl, action, params);
            }
            else {
                return false;
            }
        }
        //********************************************************
        //ValidateInputData Function returns true or false with message to user on contorl specified
        //********************************************************
        function ValidateInputData(msgControl, action, customerName, orgEmail, createdDateFrom, createDateTo) {
            $(msgControl).html("");
            if (action == "SearchOrgs" || action == "DeleteOrgAndSearch") {
                //                
                return true;
            }
        }
        //********************************************************
        //ClearData Function clears the form
        //********************************************************
        function ClearData() {
            document.getElementById("<%= txtCustomerName.ClientID %>").value = "";
            document.getElementById("<%= txtOrgEmail.ClientID %>").value = "";
            document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = "";
            document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = "";
            document.getElementById("<%= txtCustomerName.ClientID %>").focus();
            var otable = document.getElementById("ResultTable");
            while (otable.rows.length > 0)
                otable.deleteRow(otable.rows.length - 1);
        }
        //********************************************************
        //AddNew Function navigate to naviage to Create new page
        //********************************************************
        function AddNew() {
            location.href = "ManageOrg.aspx?action=add";
        }
        //********************************************************
        //Delete Customer Function 
        //********************************************************
        function DeleteOrg(id, name) {
            if (confirm("Do you want to delete the details of the customer - " + name + "?") == true) {
                var currentPageId = $("#<%= hdnPageId.ClientID %>").val();
                var action = "DeleteOrgAndSearch";
                Search(action, id, name);
            }
        }
        //********************************************************
        //Search Customer Function 
        //********************************************************
        function SearchOrgs() {

            var currentPageId = $("#<%= hdnPageId.ClientID %>").val();
            var action = "SearchOrgs";
            Search(action, 0, '');
            return false;
        }
        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }
        function pageLoad() {
            var msgControl = "#<%= divMsg.ClientID %>";

            var SearchCriteria = getParameterByName("Search");
            if (SearchCriteria.length > 0) {
                var Seararry = SearchCriteria.split('|');
                var loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
                var loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
                var pageIdContorlID = "<%= hdnPageId.ClientID %>";
                document.getElementById("<%= txtCustomerName.ClientID %>").value = Seararry[0];
                document.getElementById("<%= txtOrgEmail.ClientID %>").value = Seararry[1];
                document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = Seararry[2];
                document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = Seararry[3];
                document.getElementById("<%=hdnSearchString.ClientID %>").value = SearchCriteria;
                return CallPostScalar(msgControl, "SearchOrgs", SearchCriteria);

            }
        }

        function Redirect(OrgId) {
            window.location.href = "ManageOrg.aspx?action=edit&id=" + OrgId + '&Search=' + document.getElementById("<%=hdnSearchString.ClientID %>").value;
        }
             
        
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
   
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Search Customers</h1>
    </div>
     <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Search Customers</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="page-content">
        <div class="panel">
            <div class="panel-body">
                <asp:UpdatePanel ID="LogoUpdatePanel" RenderMode="Block" UpdateMode="Always" runat="server">
                    <ContentTemplate>
                        <div id="divMsg" runat="server">
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="lblUserName" runat="server" CssClass="control-label" Text="Customer Name"></asp:Label>
                                    <asp:TextBox ID="txtCustomerName" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="lblHead2" runat="server" CssClass="control-label" Text="Email"></asp:Label>
                                    <asp:TextBox ID="txtOrgEmail" CssClass="form-control" runat="server"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="Label1" runat="server" CssClass="control-label" Text="Created Date From"></asp:Label>
                                    <div id="calendarComponentFrom">
                                        <div class="input-group date">
                                            <asp:TextBox ID="txtCreatedDateFrom" runat="server" ToolTip="Date Format - mm/dd/yyyy"
                                                CssClass="form-control" placeholder="Created Date From"></asp:TextBox>
                                            <span class="input-group-addon"><i class="fa fa-calendar fa-lg"></i></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="Label3" runat="server" CssClass="control-label" Text="To"></asp:Label>
                                    <div id="calendarComponentTo">
                                        <div class="input-group date">
                                            <asp:TextBox ID="txtCreatedDateTo" runat="server" ToolTip="Date Format - mm/dd/yyyy"
                                                CssClass="form-control" placeholder="Created Date To"></asp:TextBox>
                                            <span class="input-group-addon"><i class="fa fa-calendar fa-lg"></i></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <div class="pad-ver">
                                        <label class="form-radio form-normal form-primary form-text">
                                            <input id="rdbLast1Week" type="radio" name="cl-rd" onclick="PopulateDatePeriod('Last 1 week');">
                                            Last 1 week</label>
                                        <label class="form-radio form-normal form-primary form-text">
                                            <input id="rdbLast1Month" type="radio" name="cl-rd" onclick="PopulateDatePeriod('Last 1 month');">
                                            Last 1 month</label>
                                        <label class="form-radio form-normal form-primary form-text">
                                            <input id="rdbLast6Months" type="radio" name="cl-rd" onclick="PopulateDatePeriod('Last 6 months');">
                                            Last 6 months</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <button class="white btn btn-primary btn-labeled fa fa-search " onclick="return SearchOrgs();"
                            tagname="Read">
                            SEARCH</button>
                          <button name="btnAdd" runat="server" class="white btn btn-primary btn-labeled fa fa-plus " onserverclick="btnAdd_Click" tagname="Read">ADD NEW</button>
                        <%--   <asp:Button ID="btnAdd" runat="server" Text="ADD NEW" OnClick="btnAdd_Click" tagname="Add"
                            CssClass="btn btn-primary" UseSubmitBehavior="False" />--%>
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnAction" runat="server" Value="" />
                        <asp:HiddenField ID="hdnSearchString" runat="server" Value="" />
                        <asp:HiddenField ID="hdnCurrentTemplateId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                        <div class="row">
                            <div class="col-sm-6">
                                <div id="div1" runat="server" style="color: Red">
                                    &nbsp;</div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-11 table-toolbar-right" id="divRecordCountText">
                            </div>
                        </div>
                        <div class="row">
                        <div class="col-sm-12">
                            <div class="table-responsive">
                                <div id="divSearchResults"></div>
                            </div>
                          </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-11 table-toolbar-right" id="divPagingText">
                            </div>
                        </div>
                        
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
        </div>
</asp:Content>
