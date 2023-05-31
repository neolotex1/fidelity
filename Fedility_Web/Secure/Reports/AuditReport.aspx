﻿<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="AuditReport.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Reports.AuditReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
 <link href="../../App_Themes/common/common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/GridRowSelection.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
    <%@ Register Assembly="RJS.Web.WebControl.PopCalendar" Namespace="RJS.Web.WebControl"
    TagPrefix="rjs" %>


        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
            pageIdContorlID = "<%= hdnPageId.ClientID %>";
            $('#calendarComponentFrom .input-group.date').datepicker({ autoclose: true });
            $('#calendarComponentTo .input-group.date').datepicker({ autoclose: true });
        });


        function validation() {
            var txtsearch = document.getElementById("<%= txtsearch.ClientID  %>");
            var msgControl = "#<%= divMsg.ClientID %>";
            if (document.getElementById("<%= chkUser.ClientID  %>").checked == true) {

                var result = validateuser();
                if (result == false) {
                    return false;
                }

            }
            else if (document.getElementById("<%= chkDoc.ClientID  %>").checked == true) {

                var result = validateDoc();
                if (result == false) {
                    return false;
                }

            }


            else if (txtsearch.value.length > 0 && document.getElementById("<%= drpOrg.ClientID  %>").value == "0") {

                $(msgControl).html(GetAlertMessages("Please Select Customer!"));
                Scrolltop();
                return false;

            }

            else if (txtsearch.value.length > 0 && document.getElementById("<%= drpOrg.ClientID  %>").value != "0") {

                var fromDate = document.getElementById("<%= txtCreatedDateFrom.ClientID  %>").value;
                var throughDate = document.getElementById("<%= txtCreatedDateTo.ClientID  %>").value;
                if (fromDate > throughDate) {
                    $(msgControl).html(GetAlertMessages("From Date should be less than To Date!"));
                    Scrolltop();
                    return false;

                }
            }
            else if (txtsearch.value.length == 0 && document.getElementById("<%= drpOrg.ClientID  %>").value == "0") {

                $(msgControl).html(GetAlertMessages("Please Select Customer!"));
                Scrolltop();
                return false;

            }
            else if (txtsearch.value.length == 0 && document.getElementById("<%= drpOrg.ClientID  %>").value != "0") {

                $(msgControl).html(GetAlertMessages("Please Select user related / Document related!"));
                Scrolltop();
                return false;

            }

        }

        function validateDoc() {
            var msgControl = "#<%= divMsg.ClientID %>";
            var result = true;
            if (document.getElementById("<%= drpOrg.ClientID  %>").value == "0") {
                $(msgControl).html(GetAlertMessages("Please Select Customer!"));
                Scrolltop();
                result = false;
            }
            else if (document.getElementById("<%= cmbDocumentType.ClientID  %>").value == "0") {
                $(msgControl).html(GetAlertMessages("Please Select Project Type!"));
                Scrolltop();
                result = false;
            }
            else if (document.getElementById("<%= txtCreatedDateFrom.ClientID  %>").value == "") {
                $(msgControl).html(GetAlertMessages("Please Select Report From Date!"));
                Scrolltop();
                result = false;
            }
            else if (document.getElementById("<%= txtCreatedDateTo.ClientID  %>").value == "") {
                $(msgControl).html(GetAlertMessages("Please Select Report To Date!"));
                Scrolltop();
                result = false;
            }
            else {
                var fromDate = document.getElementById("<%= txtCreatedDateFrom.ClientID  %>").value;
                var throughDate = document.getElementById("<%= txtCreatedDateTo.ClientID  %>").value;
                if (fromDate > throughDate) {
                    $(msgControl).html(GetAlertMessages("From Date should be less than To Date!"));
                    Scrolltop();
                    result = false;
                }
            }
            return result;

        }
        function validateuser() {

            var msgControl = "#<%= divMsg.ClientID %>";
            var result = true;
            if (document.getElementById("<%= drpOrg.ClientID  %>").value == "0") {
                $(msgControl).html("Please Select Customer!");
                result = false;
            }

            else if (document.getElementById("<%= txtCreatedDateFrom.ClientID  %>").value == "") {
                $(msgControl).html("Please Select Report From Date!");
                result = false;
            }
            else if (document.getElementById("<%= txtCreatedDateTo.ClientID  %>").value == "") {
                $(msgControl).html("Please Select Report To Date!");
                result = false;
            }
            else {
                var fromDate = document.getElementById("<%= txtCreatedDateFrom.ClientID  %>").value;
                var throughDate = document.getElementById("<%= txtCreatedDateTo.ClientID  %>").value;
                if (fromDate > throughDate) {
                    $(msgControl).html("From Date should be less than To Date!");
                    result = false;
                }
            }
            return result;

        }

        function searchfilter(Type) {
            document.getElementById("<%= txtsearch.ClientID  %>").value = "";
            var chkuser = document.getElementById("<%= chkUser.ClientID  %>");
            var chkdoc = document.getElementById("<%= chkDoc.ClientID  %>");

            if (Type == 'USER' && chkuser.checked == true) {


                document.getElementById("<%= ddlusername.ClientID  %>").disabled = false;
                document.getElementById("<%= lbluser.ClientID  %>").disabled = false;
                document.getElementById("<%= lblproject.ClientID  %>").disabled = true;
                document.getElementById("<%= lblprojectp.ClientID  %>").disabled = true;
                document.getElementById("<%= cmbDocumentType.ClientID  %>").selectedIndex = 0;
                document.getElementById("<%= cmbDocumentType.ClientID  %>").disabled = true;


            }
            else if (Type == 'DOC' && chkdoc.checked === true) {
                document.getElementById("<%= ddlusername.ClientID  %>").selectedIndex = 0;
                document.getElementById("<%= ddlusername.ClientID  %>").disabled = true;
                document.getElementById("<%= lbluser.ClientID  %>").disabled = true;
                document.getElementById("<%= lblproject.ClientID  %>").disabled = false;
                document.getElementById("<%= lblprojectp.ClientID  %>").disabled = false;
                document.getElementById("<%= cmbDocumentType.ClientID  %>").disabled = false;

            }
            else {


                document.getElementById("<%= ddlusername.ClientID  %>").selectedIndex = 0;
                document.getElementById("<%= ddlusername.ClientID  %>").disabled = true;
                document.getElementById("<%= lbluser.ClientID  %>").disabled = true;
                document.getElementById("<%= lblproject.ClientID  %>").disabled = true;
                document.getElementById("<%= lblprojectp.ClientID  %>").disabled = true;
                document.getElementById("<%= cmbDocumentType.ClientID  %>").selectedIndex = 0;
                document.getElementById("<%= cmbDocumentType.ClientID  %>").disabled = true;

            }


        }

       
      
    </script>   
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
   
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Audit Report</h1> 
    </div>
     <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Audit Report</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:SiteMapPath ID="SiteMapPath1" runat="server" Font-Size="Small" BorderStyle="None">
        <CurrentNodeStyle ForeColor="#666666" />
        <PathSeparatorTemplate>
            <asp:Image ID="Image4" runat="server" ImageUrl="~/Images/list_arrow.gif" />
        </PathSeparatorTemplate>
    </asp:SiteMapPath>
    <div id="page-content">
        <div class="panel">
            <div class="panel-body">
                <div class="GVDiv">
                    <div>
                        <div class="row">
                            <div id="divMsg" runat="server" style="color: Red; font-family: Calibri; font-size: small">
                                &nbsp;<asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                                    SelectMethod="GetData" TypeName="Lotex.EnterpriseSolutions.WebUI.Secure.Reports.MainReportDataSetTableAdapters.USP_DMS_doQ_MainReportTableAdapter">
                                    <SelectParameters>
                                        <asp:Parameter Name="in_iOrgID" Type="Int32" />
                                        <asp:Parameter Name="in_dStartDate" Type="DateTime" />
                                        <asp:Parameter Name="in_dEndDate" Type="DateTime" />
                                        <asp:Parameter Name="in_vLoginToken" Type="String" />
                                        <asp:Parameter Name="in_iLoginOrgId" Type="Int32" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                                <asp:ObjectDataSource ID="ObjectDataSource2" runat="server" OldValuesParameterFormatString="original_{0}"
                                    SelectMethod="GetData" TypeName="Lotex.EnterpriseSolutions.WebUI.Secure.Reports.MainReportDataSetTableAdapters.USP_DMS_doQ_SubMainReportTableAdapter">
                                    <SelectParameters>
                                        <asp:Parameter Name="in_iOrgID" Type="Int32" />
                                        <asp:Parameter Name="in_dStartDate" Type="DateTime" />
                                        <asp:Parameter Name="in_dEndDate" Type="DateTime" />
                                        <asp:Parameter Name="in_vLoginToken" Type="String" />
                                        <asp:Parameter Name="in_iLoginOrgId" Type="Int32" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </div>
                        </div>
                        <div class="col-md-6 form-group">
                            <div class="col-md-4">
                                <asp:Label ID="lblSubHeading" CssClass="SubHeadings" runat="server" Text="Report Filters"></asp:Label>
                            </div>
                        </div>
                        <div class="clearfix">
                        </div>
                        <fieldset>
                            <asp:UpdatePanel ID="DocumentPanel" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                <ContentTemplate>
                                    <div class="col-md-6">
                                        <div class="col-md-4">
                                            <asp:Label ID="lbltext" runat="server" CssClass="LabelStyle" Text="Remarks Search"></asp:Label>
                                        </div>
                                        <div class="col-md-6">
                                            <asp:TextBox ID="txtsearch" runat="server" CssClass="form-control"></asp:TextBox><br />
                                            
                                            <asp:CheckBox ID="chkUser" runat="server" Text="User Related" />
                                            <asp:MutuallyExclusiveCheckBoxExtender ID="mecbe1" runat="server" TargetControlID="chkUser"
                                                Key="YesNo" />
                                            <br />
                                            <asp:CheckBox ID="chkDoc" runat="server" Text="Document Related" />
                                            <asp:MutuallyExclusiveCheckBoxExtender ID="mecbe2" runat="server" TargetControlID="chkDoc"
                                                Key="YesNo" />
                                        </div>
                                    </div>
                                    <div class="clearfix">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <div class="col-md-4">
                                            <asp:Label ID="lblorg" runat="server" CssClass="LabelStyle" Text="Organization"></asp:Label>
                                            <asp:Label ID="lbltextm" runat="server" CssClass="MandratoryFieldMarkStyle" Text="*"></asp:Label>
                                        </div>
                                        <div class="col-md-6">
                                            <asp:DropDownList ID="drpOrg" CssClass="form-control" runat="server" AutoPostBack="True"
                                                OnSelectedIndexChanged="drpOrg_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clearfix">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <div class="col-md-4">
                                            <asp:Label ID="lbluser" runat="server" CssClass="LabelStyle" Text="User Name"></asp:Label>
                                        </div>
                                        <div class="col-md-6">
                                            <asp:DropDownList ID="ddlusername" runat="server" CssClass="form-control" AutoPostBack="True"
                                                OnSelectedIndexChanged="ddlusername_SelectedIndexChanged">
                                                <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clearfix ">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <div class="col-md-4">
                                            <asp:Label ID="lblproject" runat="server" CssClass="LabelStyle" Text="Document Search Using "></asp:Label>
                                            <asp:Label ID="lblprojectp" runat="server" CssClass="LabelStyle" Text="Project Type"></asp:Label>
                                        </div>
                                        <div class="col-md-6">
                                            <asp:DropDownList ID="cmbDocumentType" runat="server" CssClass="form-control" AutoPostBack="True">
                                                <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="clearfix">
                                    </div>
                                    <div class="col-md-6">
                                        <div class="col-md-4">
                                            <asp:Label ID="Label1" runat="server" CssClass="LabelStyle" Text="Select Period"></asp:Label>
                                        </div>
                                    </div>
                                    <div class="clearfix">
                                    </div>
                                    <div class="row form-group">
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <asp:Label ID="Label2" runat="server" CssClass="control-label" Text="From"></asp:Label>
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
                                    <div class="col-md-6">
                                        <div class="col-md-6">
                                        <i class="fa fa-search btn-style btn-primary white">
                                            <asp:Button ID="btnsearchSub" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="btnsearchSub_Click" /></i>
                                            <i class="fa fa-eraser btn-style btn-danger white">
                                            <asp:Button ID="btnclear" runat="server" Text="Clear" CssClass="btn btn-danger" OnClick="btnclear_Click" /></i>
                                        </div>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </fieldset>
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                        <br />
                        <div class="row form-group">
                            <div style="overflow: auto;">
                                <div>
                                    <asp:GridView ID="grdView" runat="server" AutoGenerateColumns="true" UseAccessibleHeader="true"
                                        EmptyDataText="No record found for selected criteria." CssClass="table table-striped table-bordered"
                                        PagerStyle-CssClass="pgr" CellPadding="10" CellSpacing="5" AlternatingRowStyle-CssClass="alt"
                                        AllowSorting="True" OnRowDataBound="grdView_RowDataBound" OnSorting="grdView_Sorting">
                                        <AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
                                        <PagerSettings FirstPageText="<<" LastPageText=">>" Mode="NumericFirstLast" NextPageText=" "
                                            PageButtonCount="5" PreviousPageText=" " />
                                        <PagerStyle CssClass="pagination-ys" />
                                    </asp:GridView>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 col-md-offset-3">
                                    <div class="PagingTD">
                                        <div class="PagingControl">
                                               
                                    <div class="row">
                                        <div class="pagination" style="font-size: 10pt;" >
                                                                Rows per page
                                                                <asp:DropDownList ID="ddlRows" runat="server" AutoPostBack="True" Width="50px" OnSelectedIndexChanged="ddlRows_SelectedIndexChanged">
                                                                </asp:DropDownList>
                                                           <i class="fa fa-fast-backward btn-style btn-primary white">
                                                                <asp:Button ID="lnkbtnFirst" CssClass="btn btn-primary" ToolTip="First" CommandName="First"
                                                                    runat="server" OnCommand="GetPageIndex"></asp:Button></i>
                                                           <i class="fa fa-step-backward btn-style btn-primary white">
                                                                <asp:Button ID="lnkbtnPre" CssClass="btn btn-primary" ToolTip="Previous"
                                                                    CommandName="Previous" runat="server" OnCommand="GetPageIndex"></asp:Button></i>
                                                           
                                                                Page
                                                                <asp:DropDownList ID="ddlPage" runat="server" Width="50px" AutoPostBack="True" OnSelectedIndexChanged="ddlPage_SelectedIndexChanged">
                                                                </asp:DropDownList>
                                                                of
                                                                <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                                                           <i class="fa fa-step-forward btn-style btn-primary white">
                                                                <asp:Button ID="lnkbtnNext" CssClass="btn btn-primary" ToolTip="Next" runat="server"
                                                                    CommandName="Next" OnCommand="GetPageIndex"></asp:Button></i>
                                                        <i class="fa fa-fast-forward btn-style btn-primary white">
                                                                <asp:Button ID="lnkbtnLast" CssClass="btn btn-primary" ToolTip="Last" runat="server"
                                                                    CommandName="Last" OnCommand="GetPageIndex"></asp:Button></i>
                                                                     <i class="fa fa-share-square-o  btn-style btn-primary white">
                                                    <asp:Button ID="lnkbtnExport" CssClass="btn btn-primary" ToolTip="Export" runat="server" OnClick="lnkbtnExport_Click">
                                                    </asp:Button></i>
                                              </div>
                                              </div>
                                              
                                    </div>
                                </div>
                            </div>
                            <br />
                            <div class="col-md-6">
                                <asp:Label ID="lblMessage" runat="server" EnableViewState="false"></asp:Label>
                            </div>
                        </div>
                        
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
</asp:Content>
