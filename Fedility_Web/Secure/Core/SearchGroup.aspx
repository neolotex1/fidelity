<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="SearchGroup.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.SearchGroup" %>

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
            var groupName = $.trim($("#<%= txtGroupName.ClientID %>").val());
            var createdDateFrom = $("#<%= txtCreatedDateFrom.ClientID %>").val();
            var createDateTo = $("#<%= txtCreatedDateTo.ClientID %>").val();
            var currentPageId = $("#" + pageIdContorlID).val();
            var params = groupName + '|' + createdDateFrom + '|' + createDateTo + '|' + currentPageId + '|' + deletItemId + '|' + deletItemName;
            if (ValidateInputData(msgControl, action, groupName, createdDateFrom, createDateTo)) {
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

        function ValidateInputData(msgControl, action, groupName, createdDateFrom, createDateTo) {
            $(msgControl).html("");
            if (action == "SearchGroups" || action == "DeleteGroupAndSearch") {
                //                
                return true;
            }
        }
        //********************************************************
        //ClearData Function clears the form
        //********************************************************

        function ClearData() {
            document.getElementById("<%= txtGroupName.ClientID %>").value = "";
            document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = "";
            document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = "";
            document.getElementById("<%= txtGroupName.ClientID %>").focus();
        }
        //********************************************************
        //AddNew Function navigate to naviage to Create new page
        //********************************************************

        function AddNew() {
            location.href = "ManageGroup.aspx?action=add";
        }

        //********************************************************
        //Delete Group Function 
        //********************************************************

        function DeleteGroup(id, name) {
            if (confirm("Do you want to delete the details of the role - " + name + "?") == true) {
                var currentPageId = $("#<%= hdnPageId.ClientID %>").val();
                var action = "DeleteGroupAndSearch";
                Search(action, id, name);
            }
        }

        //********************************************************
        //Search Group Function 
        //********************************************************

        function SearchGroups() {
            var currentPageId = $("#<%= hdnPageId.ClientID %>").val();
            var action = "SearchGroups";
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
                document.getElementById("<%= txtGroupName.ClientID %>").value = Seararry[0];
                document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = Seararry[1];
                document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = Seararry[2];
                document.getElementById("<%=hdnSearchString.ClientID %>").value = SearchCriteria;
                var loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
                var loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
                var pageIdContorlID = "<%= hdnPageId.ClientID %>";
                return CallPostScalar(msgControl, "SearchGroups", SearchCriteria);

            }
        }



        function Redirect(GroupId, GroupName) {
            window.location.href = "ManageGroup.aspx?action=edit&id=" + GroupId + '&groupname=' + GroupName + '&Search=' + document.getElementById("<%=hdnSearchString.ClientID %>").value;
        }

         
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Search Groups</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Search Groups</li>
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
            			<div id="divMsg" runat="server" style="color: Red"></div>
            			<div class="panel">
                <div class="panel-heading">
                    <h3 class="panel-title">
                        Search Filters</h3>
                </div>
                <div class="panel-body">
                    <div class="row">
                        <div class="col-sm-6">
                            <div class="form-group">
                                <asp:Label ID="lblUserName3" runat="server" CssClass="control-label" Text="Role Name"></asp:Label>
                                <asp:TextBox ID="txtGroupName" runat="server" CssClass="form-control" Style="margin-left: 0px"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-sm-6">
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
                    </div><br />

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

                                     <button name="btnSearch" class="white btn btn-primary btn-labeled fa fa-search" onclick="return SearchGroups();" tagname="Read">Search</button>

                                     <button name="btnAdd" runat="server" class="btn btn-primary white btn-labeled fa fa-plus" onserverclick="btnAdd_Click" tagname="Read">Add New</button>

                                <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                                <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                                <asp:HiddenField ID="HiddenField1" runat="server" Value="" />
                                <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                                <asp:HiddenField ID="hdnSearchString" runat="server" Value="" />
                                <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-6">
                            <div id="div1" runat="server" style="color: Red">
                                &nbsp;</div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-11 table-toolbar-left" id="divRecordCountText">
                        </div>
                    </div>
                    <div class="row">
                        <div id="divSearchResults" class="col-sm-12">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-11 table-toolbar-left" id="divPagingText">
                        </div>
                    </div>
                </div>
            </div>
            		</div>
           	    </div>
           </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
