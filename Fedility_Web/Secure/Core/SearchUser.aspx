<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="SearchUser.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.SearchUser" %>

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
            var userName = $.trim($("#<%= txtUserName.ClientID %>").val());
            var userEmailId = $.trim($("#<%= txtUserEmailId.ClientID %>").val());
            var firstName = $.trim($("#<%= txtFirstName.ClientID %>").val());
            var lastName = $.trim($("#<%= txtLastName.ClientID %>").val());
            var createdDateFrom = $("#<%= txtCreatedDateFrom.ClientID %>").val();
            var createDateTo = $("#<%= txtCreatedDateTo.ClientID %>").val();
            var currentPageId = $("#" + pageIdContorlID).val();
            var params = userName + '|' + userEmailId + '|'
                + firstName + '|' + lastName + '|'
                + createdDateFrom + '|' + createDateTo + '|'
                + currentPageId + '|' + deletItemId + '|' + deletItemName;
            if (ValidateInputData(msgControl, action, userName, userEmailId, firstName, lastName, createdDateFrom, createDateTo)) {
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

        function ValidateInputData(msgControl, action, userName, userEmailId, firstName, lastName, createdDateFrom, createDateTo) {
            $(msgControl).html("");
            if (action == "SearchUsers" || action == "DeleteUserAndSearch") {
                //                
                return true;
            }
        }
        //********************************************************
        //ClearData Function clears the form
        //********************************************************

        function ClearData() {
            document.getElementById("<%= txtUserName.ClientID %>").value = "";
            document.getElementById("<%= txtUserEmailId.ClientID %>").value = "";
            document.getElementById("<%= txtFirstName.ClientID  %>").value = "";
            document.getElementById("<%= txtLastName.ClientID  %>").value = "";
            document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = "";
            document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = "";
        }
        //********************************************************
        //AddNew Function navigate to naviage to Create new item
        //********************************************************

        function AddNew() {
            location.href = "ManageUser.aspx?action=add";
        }

        //********************************************************
        //Delete User Function 
        //********************************************************

        function DeleteUser(id, name) {
            if (confirm("Do you want to delete the user - " + name + "?") == true) {
                var action = "DeleteUserAndSearch";
                Search(action, id, name);
            }
        }

        //********************************************************
        //Search User Function 
        //********************************************************

        function SearchUsers() {
            var action = "SearchUsers";
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

                document.getElementById("<%= txtUserName.ClientID %>").value = Seararry[0]; ;
                document.getElementById("<%= txtUserEmailId.ClientID %>").value = Seararry[1];
                document.getElementById("<%= txtFirstName.ClientID  %>").value = Seararry[2];
                document.getElementById("<%= txtLastName.ClientID  %>").value = Seararry[3];
                document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = Seararry[4];
                document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = Seararry[5];
                document.getElementById("<%=hdnSearchString.ClientID %>").value = SearchCriteria;
                var loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
                var loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
                var pageIdContorlID = "<%= hdnPageId.ClientID %>";
                return CallPostScalar(msgControl, "SearchUsers", SearchCriteria);

            }
        }
        function Redirect(UserId, UserName) {
            window.location.href = "ManageUser.aspx?action=edit&id=" + UserId + '&username=' + UserName + '&Search=' + document.getElementById("<%=hdnSearchString.ClientID %>").value;
        }

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Search Users</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Search Users</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="page-content">
        <div class="panel">
            <div class="panel-body">
                <div id="divMsg" runat="server">
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="form-group">
                            <asp:Label ID="lblUserName" runat="server" CssClass="control-label" Text="User Name"></asp:Label>
                            <asp:TextBox ID="txtUserName" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="form-group">
                            <asp:Label ID="lblHead2" runat="server" CssClass="control-label" Text="Email"></asp:Label>
                            <asp:TextBox ID="txtUserEmailId" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="form-group">
                            <asp:Label ID="lblHead" runat="server" CssClass="control-label" Text="First Name"></asp:Label>
                            <asp:TextBox ID="txtFirstName" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="form-group">
                            <asp:Label ID="lblHead1" runat="server" CssClass="control-label" Text="Last Name"></asp:Label>
                            <asp:TextBox ID="txtLastName" CssClass="form-control" runat="server"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-6">
                        <div class="form-group">
                            <asp:Label ID="Label1" runat="server" CssClass="control-label" Text="Created Date From"></asp:Label>
                            <div id="calendarComponentFrom">
                                <div class="input-group date">
                                    <asp:TextBox ID="txtCreatedDateFrom" CssClass="form-control" runat="server" ToolTip="Date Format - mm/dd/yyyy"
                                        placeholder="Created Date From"></asp:TextBox>
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
                                    <asp:TextBox ID="txtCreatedDateTo" CssClass="form-control" runat="server" ToolTip="Date Format - mm/dd/yyyy"
                                        placeholder="Created Date To"></asp:TextBox>
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
              <%--  <asp:Button ID="btnSearch" runat="server" Text="Search" OnClientClick="return SearchUsers();"
                    CssClass="btnsearch" TagName="Read" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" OnClientClick="return ClearData();"
                    CssClass="btnclear" TagName="Read" />--%>

                      <button name="btnSearch" class="white btn btn-primary btn-labeled fa fa-search" onclick="return SearchUsers();" tagname="Read">Search</button>
                        <button id="btnadd" name="btnAdd" runat="server" class="btn btn-primary white btn-labeled fa fa-plus" onserverclick="btnAdd_Click" tagname="Read">Add New</button>
                          <button id="btnBulkUser"  name="btnBulkUser" runat="server" class="btn btn-primary white  btn-labeled fa fa-users" onserverclick="btnBulkUser_Click" tagname="Read">Add Bulk User</button>
                      <button  name="btnClear" runat="server" class="btn btn-danger white btn-labeled fa fa-times pull-right" onclick="return ClearData();" tagname="Read">Clear</button>

                      
                     <%--   <asp:Button ID="btnBulkUser" runat="server" Text="Add Bulk User" tagname="Add" CssClass="btn btn-primary btn-rounded"
                                    Width="110px" OnClick="btnBulkUser_Click" />>--%>

                <%--  <button class="btn btn-default btn-labeled fa fa-search" onclick="SearchUsers();"  ID="btnSearch" tagname="Read">Search</button>--%>
                <%--            <button id="btnClear" name="btnAdd" runat="server" class="btn btn-purple btn-labeled fa fa-plus" onserverclick="btnAdd_Click" tagname="Read">Add New</button>--%>
                <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                <asp:HiddenField ID="HiddenField1" runat="server" Value="" />
                <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                <asp:HiddenField ID="hdnSearchString" runat="server" Value="" />
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
                <div class="table-responsive">
                    <div id="divSearchResults" >
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
