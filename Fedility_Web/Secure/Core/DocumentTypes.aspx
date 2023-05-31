<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="DocumentTypes.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.DocumentTypes1" %>

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
            pageRightsContorlId = "<%= hdnPageRights.ClientID %>";
            $('#calendarComponentFrom .input-group.date').datepicker({ autoclose: true });
            $('#calendarComponentTo .input-group.date').datepicker({ autoclose: true });
        });

        function Search(action, deletItemId, deletItemName) {
            var msgControl = "#<%= divMsg.ClientID %>";
            var documentTypeName = $("#<%= txtDocumentTypeName.ClientID %>").val();
            var createdDateFrom = $("#<%= txtCreatedDateFrom.ClientID %>").val();
            var createDateTo = $("#<%= txtCreatedDateTo.ClientID %>").val();
            var currentPageId = $("#" + pageIdContorlID).val();
            var params = documentTypeName + '|' + createdDateFrom + '|' + createDateTo + '|'
                + currentPageId + '|' + deletItemId + '|' + deletItemName;
            document.getElementById("<%=hdnSearchString.ClientID %>").value = params;

            return CallPostScalar(msgControl, action, params);
        }

        //********************************************************
        //ClearData Function clears the form
        //********************************************************

        function ClearData() {
            document.getElementById("<%= txtDocumentTypeName.ClientID %>").value = "0";
            document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = "";
            document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = "";
        }

        //********************************************************
        //Delete User Function 
        //********************************************************

        function DeleteDocumentType(id, name) {
            if (confirm("Do you want to delete the details of the DocumentType - " + name + "?") == true) {
                var action = "DeleteDocumentTypeAndSearch";
                Search(action, id, name);
            }
        }

        //********************************************************
        //Search User Function 
        //********************************************************

        function SearchDocumentTypes() {
            var action = "SearchDocumentTypes";
            Search(action, 0, '');
        }

        //********************************************************
        //Export User Function
        //********************************************************

        function ExportDocumentType(id, name, exportType, tempid) {
            var action = "ExportDocumentType";
            document.getElementById('<%=hdnCurrentDocTypeID.ClientID %>').value = id;
            document.getElementById('<%=hdnDocName.ClientID %>').value = name;
            document.getElementById('<%=hdnExportType.ClientID %>').value = exportType;
            document.getElementById('<%=hdnTemplateId.ClientID %>').value = tempid;

            (document.getElementById('<%=btnExport.ClientID %>')).click();
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
                document.getElementById("<%= txtDocumentTypeName.ClientID %>").value = Seararry[0];
                document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = Seararry[1];
                document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = Seararry[2];
                var loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
                var loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
                var pageIdContorlID = "<%= hdnPageId.ClientID %>";
                document.getElementById("<%=hdnSearchString.ClientID %>").value = SearchCriteria;
                return CallPostScalar(msgControl, "SearchDocumentTypes", SearchCriteria);

            }
        }
        function Redirect(DocumentTypeId, DocumentTypeName) {
            window.location.href = "ManageDocumentType.aspx?action=edit&id=" + DocumentTypeId + '&doctyp' + DocumentTypeName + '&Search=' + document.getElementById("<%=hdnSearchString.ClientID %>").value;
        }
             
         
    </script>
    <style type="text/css">
        .ButtonStyle
        {
            height: 26px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Search ProjectType</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Search ProjectType</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%-- <asp:Label ID="lblCurrentPath" runat="server" CssClass="CurrentPath" Text="Configure  &gt;  Project Types"></asp:Label>
    <asp:Label ID="lblPageHeader" runat="server" CssClass="PageHeadings" Text="Search Project Types"></asp:Label>--%>
  <div id="page-content">
    <div class="panel">
        <div class="panel-body">
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
                        <asp:Label ID="lblSubHeading" CssClass="control-label" runat="server" Text="Search Filters"></asp:Label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                        <asp:Label ID="lblDocumentTypeName" runat="server" CssClass="control-label" Text="Project Type"></asp:Label>
                        <asp:TextBox ID="txtDocumentTypeName" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>
            </div><br /><br />
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
                    <div class="pad-ver">
                        <label class="form-radio form-normal form-primary form-text">
                            <input id="rdbLast1Week" type="radio" name="cl-rd" onclick="PopulateDatePeriod('Last 1 week');" />
                            Last 1 week</label>
                        <label class="form-radio form-normal form-primary form-text">
                            <input id="rdbLast1Month" type="radio" name="cl-rd" onclick="PopulateDatePeriod('Last 1 month');" />
                            Last 1 month</label>
                        <label class="form-radio form-normal form-primary form-text">
                            <input id="rdbLast6Months" type="radio" name="cl-rd" onclick="PopulateDatePeriod('Last 6 months');" />
                            Last 6 months</label>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="pad-ver">
                        <button name="btnSearch" class="white btn btn-primary btn-labeled fa fa-search" onclick="SearchDocumentTypes();return false;"
                            tagname="Read">
                            Search</button>
                        <button id="Button1" name="btnAdd" runat="server" class="btn btn-primary white btn-labeled fa fa-plus"
                            onserverclick="btnAdd_Click" tagname="Read">
                            Add New</button>
                        <%--  <asp:Button ID="btnSearch" runat="server" Text="Search" OnClientClick="SearchDocumentTypes();return false;"
                            CssClass="btn btn-primary btn-rounded" TagName="Read" />--%>
                        <%--  <asp:Button ID="btnAdd" runat="server" Text="Add New" tagname="Add" CssClass="btn btn-primary btn-rounded"
                            Width="90px" OnClick="btnAdd_Click" />--%>
                        <asp:Button ID="btnExport" runat="server" Style="visibility: hidden" TagName="Read"
                            OnClick="btnExport_Click" />
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnAction" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                        <asp:HiddenField ID="hdnCurrentDocTypeID" runat="server" Value="" />
                        <asp:HiddenField ID="hdnDocName" runat="server" Value="" />
                        <asp:HiddenField ID="hdnExportType" runat="server" Value="" />
                        <asp:HiddenField ID="hdnTemplateId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnSearchString" runat="server" Value="" />
                        <asp:GridView ID="GridView2" runat="server">
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div id="div1" runat="server" style="color: Red">
                        &nbsp;
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-11 table-toolbar-right" id="divRecordCountText">
                </div>
            </div>
            <div class="row">
            <div class="col-sm-12">
            	<div class="table-responsive">
                <div id="divSearchResults" >
                </div>
                </div>
            </div>
            </div>
            <div class="row">
                <div class="col-sm-11 table-toolbar-right" id="divPagingText">
                </div>
            </div>
        </div>
    </div>
  </div>
</asp:Content>
