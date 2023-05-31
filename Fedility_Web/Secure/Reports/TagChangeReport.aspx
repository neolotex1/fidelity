<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="TagChangeReport.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Reports.TagChangeReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
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
            $('#calendarComponentFrom .input-group.date').datepicker({ autoclose: true });
            $('#calendarComponentTo .input-group.date').datepicker({ autoclose: true });
        });

        function validate() {

            var msgControl = "#<%= divMsg.ClientID %>";
            var result = true;

            if (document.getElementById("<%= txtCreatedDateFrom.ClientID  %>").value == "") {
                $(msgControl).html(GetAlertMessages("Please Select Report From Date!"));
                result = false;
            }
            else if (document.getElementById("<%= txtCreatedDateTo.ClientID  %>").value == "") {
                $(msgControl).html(GetAlertMessages("Please Select Report To Date!"));
                result = false;
            }
            else {
                var fromDate = document.getElementById("<%= txtCreatedDateFrom.ClientID  %>").value;
                var throughDate = document.getElementById("<%= txtCreatedDateTo.ClientID  %>").value;
                if (fromDate > throughDate) {
                    $(msgControl).html(GetAlertMessages("From Date should be less than To Date!"));
                    result = false;
                }
            }
            return result;
        }

       
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
   
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Tag Change Report</h1>
    </div>
     <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Tag Change Report</li>
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
            <div class="col-md-6 ">
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
            <div class="clearfix">
            </div>
            <div class="col-md-6">
                <div class="col-md-6">
                <i class="fa fa-search btn-style btn-success white">
                    <asp:Button ID="btnsearchSub" runat="server" Text="Search" OnClick="btnsearchSub_Click"  CssClass="btn btn-success" /></i>
                    <i class="fa fa-eraser btn-style btn-danger white">
                                <asp:Button ID="btnclear" runat="server" Text="Clear" OnClick="btnclear_Click"  CssClass="btn btn-danger" /></i>
                </div>
            </div>
            </fieldset>
            <div class="col-md-6">
                <div class="col-md-4">
                    <center>
                        <div id="pnlMainDiv" style="overflow:auto">
                            <asp:Panel ID="pnlSub" runat="server" Visible="false">
                                <rsweb:ReportViewer ID="ReportViewerMain" runat="server" Font-Names="Calibri" Font-Size="Small"
                                    Height="615px" InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Calibri"
                                    WaitMessageFont-Size="Small" Width="1000px" Visible="False" PageCountMode="Actual">
                                    <LocalReport ReportPath="Secure\Reports\TagChangeReport.rdlc">
                                    </LocalReport>
                                </rsweb:ReportViewer>
                            </asp:Panel>
                        </div>
                    </center>
                </div>
            </div>
            </div>
             <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
        <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
        <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
    </div>
    </div>
    </div>
    </div>
</asp:Content>
               





        
       
