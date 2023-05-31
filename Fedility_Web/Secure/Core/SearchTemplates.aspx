<%@ Page Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true" CodeBehind="SearchTemplates.aspx.cs"
    Inherits="Lotex.EnterpriseSolutions.WebUI.SearchTemplates" %>

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
            var templateName = $.trim($("#<%= txtTemplateName.ClientID %>").val());
            var createdDateFrom = $("#<%= txtCreatedDateFrom.ClientID %>").val();
            var createDateTo = $("#<%= txtCreatedDateTo.ClientID %>").val();
            var currentPageId = $("#" + pageIdContorlID).val();
            var params = templateName + '|' + createdDateFrom + '|' + createDateTo + '|'
                + currentPageId + '|' + deletItemId + '|' + deletItemName;
            document.getElementById("<%=hdnSearchString.ClientID %>").value = params;

            return CallPostScalar(msgControl, action, params);
        }

        //********************************************************
        //ClearData Function clears the form
        //********************************************************

        function ClearData() {
            document.getElementById("<%= txtTemplateName.ClientID %>").value = "";
            document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = "";
            document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = "";
        }
        //********************************************************
        //AddNew Function navigate to naviage to Create new item
        //********************************************************

        function AddNew() {
            location.href = "AddNewDocumentTemplate.aspx?action=add";
        }

        //********************************************************
        //Delete User Function 
        //********************************************************

        function DeleteTemplate(id, name) {
            if (confirm("Do you want to delete the details of the template - " + name + "?") == true) {
                var action = "DeleteTemplateAndSearch";
                Search(action, id, name);
            }
        }
        //********************************************************
        //Search User Function 
        //********************************************************

        function SearchTemplates() {
            var action = "SearchTemplates";
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
                document.getElementById("<%= txtTemplateName.ClientID %>").value = Seararry[0];
                document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = Seararry[1];
                document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = Seararry[2];
                document.getElementById("<%=hdnSearchString.ClientID %>").value = SearchCriteria;
                var loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
                var loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
                var pageIdContorlID = "<%= hdnPageId.ClientID %>";
                return CallPostScalar(msgControl, "SearchTemplates", SearchCriteria);

            }
        }


        function Redirect(TemplateId, TemplateName) {
            window.location.href = "ManageTemplate.aspx?action=edit&id=" + TemplateId + '&tname' + TemplateName + '&Search=' + document.getElementById("<%=hdnSearchString.ClientID %>").value;
        }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Search Template</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Search Template</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        	<div id="page-content">
            	<div class="panel">
                <div class="panel-body">
                    <div id="divMsg" runat="server" style="color: Red">
                    </div>
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <asp:Label ID="lblSubHeading" CssClass="control-label" runat="server" Text="Search Filters"></asp:Label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <asp:Label ID="lblTemplateName" runat="server" CssClass="control-label" Text="Template Name"></asp:Label>
                                <asp:TextBox ID="txtTemplateName" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                    </div><br /><br />
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <asp:Label ID="Label1" runat="server" CssClass="LabelStyle" Text="Created Date From"></asp:Label>
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
                                <asp:Label ID="Label3" runat="server" CssClass="LabelStyle" Text="To"></asp:Label>
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
                            <div class="pad-ver">
                                <label class="form-radio form-normal form-primary form-text">
                                    <input id="rdbLast1Week" type="radio" name="cl-rd" tagname="Read" onclick="PopulateDatePeriod('Last 1 week');">
                                    Last 1 week</label>
                                <label class="form-radio form-normal form-primary form-text">
                                    <input id="rdbLast1Month" type="radio" name="cl-rd" tagname="Read" onclick="PopulateDatePeriod('Last 1 month');">
                                    Last 1 month</label>
                                <label class="form-radio form-normal form-primary form-text">
                                    <input id="rdbLast6Months" type="radio" name="cl-rd" tagname="Read" onclick="PopulateDatePeriod('Last 6 months');">
                                    Last 6 months</label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6">
                        <i class="fa fa-search btn-style btn-primary white">
                            <asp:Button ID="Search" runat="server" Text="Search" tagname="Add" CssClass="btn btn-primary"
                                OnClientClick="return SearchTemplates();" /></i>
                                <i class="fa fa-plus btn-style btn-primary white">
                            <asp:Button ID="btnAdd" runat="server" Text="Add New" tagname="Add" CssClass="btn btn-primary"
                                OnClick="btnAdd_Click" /></i>
                            <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                            <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                            <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                            <asp:HiddenField ID="hdnAction" runat="server" Value="" />
                            <asp:HiddenField ID="hdnCurrentTemplateId" runat="server" Value="" />
                            <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                            <asp:HiddenField ID="hdnSearchString" runat="server" Value="" />
                        </div>
                    </div>
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
                        <div id="divSearchResults" >
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-11 table-toolbar-right" id="divPagingText">
                        </div>
                    </div>
                </div>
            </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
