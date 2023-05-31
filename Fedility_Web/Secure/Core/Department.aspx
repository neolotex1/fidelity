<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master"  AutoEventWireup="true"
    CodeBehind="Department.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.DocumentTypes" %>

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
            var DeptName = $.trim($("#<%= txtCustomerName.ClientID %>").val());
            var createdDateFrom = $("#<%= txtCreatedDateFrom.ClientID %>").val();
            var createDateTo = $("#<%= txtCreatedDateTo.ClientID %>").val();
            var currentPageId = $("#" + pageIdContorlID).val();
            var params = DeptName + '|' + createdDateFrom + '|' + createDateTo + '|' + currentPageId + '|' + deletItemId + '|' + deletItemName;
            document.getElementById("<%=hdnSearchString.ClientID %>").value = DeptName + '|' + createdDateFrom + '|' + createDateTo;
            if (ValidateInputData(msgControl, action, DeptName, createdDateFrom, createDateTo)) {
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
            if (action == "SearchDepartmentsForDeptPage" || action == "DeleteDepartmentAndSearch") {
                //                
                return true;
            }
        }
        //********************************************************
        //ClearData Function clears the form
        //********************************************************

        function ClearData() {
            document.getElementById("<%= txtCustomerName.ClientID %>").value = "";
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

        function DeleteDept(id, name) {
            if (confirm("Do you want to delete the details of the Department - " + name + "?") == true) {
                var currentPageId = $("#<%= hdnPageId.ClientID %>").val();
                var action = "DeleteDepartmentAndSearch";
                Search(action, id, name);
            }
        }

        //********************************************************
        //Search Customer Function 
        //********************************************************

        function SearchOrgs() {
            var currentPageId = $("#<%= hdnPageId.ClientID %>").val();
            var action = "SearchDepartmentsForDeptPage";
            Search(action, 0, '');

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
                document.getElementById("<%= txtCustomerName.ClientID %>").value = Seararry[0];
                document.getElementById("<%= txtCreatedDateFrom.ClientID %>").value = Seararry[1];
                document.getElementById("<%= txtCreatedDateTo.ClientID %>").value = Seararry[2];
                document.getElementById("<%=hdnSearchString.ClientID %>").value = SearchCriteria;
                return CallPostScalar(msgControl, "SearchDepartmentsForDeptPage", SearchCriteria);

            }
        }

        function Redirect(DepartmentId, DepartmentName) {
            window.location.href = "DepartmentAddNew.aspx?action=edit&id=" + DepartmentId + '&dpname=' + DepartmentName + '&Search=' + document.getElementById("<%=hdnSearchString.ClientID %>").value;
        }
         
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Search Departments </h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Search Departments </li>
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
                                    <asp:Label ID="lblUserName" runat="server" CssClass="control-label" Text="Department Name"></asp:Label>
                           
                                    <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control" ></asp:TextBox>
                                </div>
                                </div>
                                </div><br /><br />

            <div class="row">
                <div class="col-sm-6">
                    <div class="form-group">
                                    <asp:Label ID="Label1" runat="server" CssClass="control-label" Text="Created Date From"></asp:Label>
                                    <div id="calendarComponentFrom">
                            <div class="input-group date">
                                    <asp:TextBox ID="txtCreatedDateFrom"  CssClass="form-control" runat="server" ToolTip="Date Format - mm/dd/yyyy"    placeholder="Created Date From"></asp:TextBox>
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
                                    <asp:TextBox ID="txtCreatedDateTo" CssClass="form-control"  runat="server" ToolTip="Date Format - mm/dd/yyyy" placeholder="Created Date To"></asp:TextBox>
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
                             
                                    <%--<asp:RadioButton ID="rdbLast1Week" runat="server" CssClass="RadioButtonStlye" Text="Last 1 week"
                                        GroupName="Period" onclick="PopulateDatePeriod('Last 1 week');" />
                                    <asp:RadioButton ID="rdbLast1Month" runat="server" CssClass="RadioButtonStlye" Text="Last 1 month"
                                        GroupName="Period" onclick="PopulateDatePeriod('Last 1 month');" />
                                    <asp:RadioButton ID="rdbLast6Months" runat="server" CssClass="RadioButtonStlye" Text="Last 6 months"
                                        GroupName="Period" onclick="PopulateDatePeriod('Last 6 months');" />--%>
                             </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-6">
                    <div class="pad-ver">

<%--                    <input type="button" value="Search" onclick="SearchOrgs();" tagname="Read" class="btn btn-primary btn-rounded" />--%>
                     <%--   <asp:Button ID="btnAdd" runat="server" Text="Add New" tagname="Add" CssClass="btn btn-primary btn-rounded"
                            OnClick="btnAdd_Click" />--%>
                          <button name="btnSearch" class="white btn btn-primary btn-labeled fa fa-search" onclick="SearchOrgs();return false;" tagname="Read">Search</button>
                           <button id="Button1" name="btnAdd" runat="server" class="btn btn-primary white btn-labeled fa fa-plus"
                            onserverclick="btnAdd_Click" tagname="Read">
                            Add New</button>
                  
                          <%-- <button name="btnSearch" ID="btnAdd"  class="btn btn-default btn-labeled fa fa-search" onclick="return SearchOrgs();" tagname="Read">Search</button>--%>
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnAction" runat="server" Value="" />
                        <asp:HiddenField ID="hdnCurrentTemplateId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                        <asp:HiddenField ID="hdnSearchString" runat="server" Value="" />
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
</asp:Content>
