<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="MISReport.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Reports.MISReport" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Assembly="RJS.Web.WebControl.PopCalendar" Namespace="RJS.Web.WebControl"
    TagPrefix="rjs" %>


<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <link href="../../App_Themes/common/common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/GridRowSelection.js" type="text/javascript"></script>
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

            if (document.getElementById("<%= cmbDocumentType.ClientID  %>").value == "0") {
                $(msgControl).html(GetAlertMessages("Please Select Project Type!"));
                result = false;
            }
            else if (document.getElementById("<%= cmbDepartment.ClientID  %>").value == "0") {
                $(msgControl).html(GetAlertMessages("Please Select Department!"));
                result = false;
            }
            else if (document.getElementById("<%= txtCreatedDateFrom.ClientID  %>").value == "") {
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
            MISReport</h1>
    </div>
     <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">MISReport</li>
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
                        <div id="divGrid" style="width: 300px;">
                            &nbsp;</div>
                        <fieldset>
                            <div class="col-md-6 form-group">
                                <div class="col-md-4">
                                    <asp:Label ID="Label4" runat="server" CssClass="LabelStyle" Text="Project Type"></asp:Label>
                                    <asp:Label ID="Label5" runat="server" CssClass="MandratoryFieldMarkStyle" Text="*"></asp:Label>
                                </div>
                                <asp:UpdatePanel ID="DocumentPanel" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                                    <ContentTemplate>
                                        <div class="col-md-6">
                                            <asp:DropDownList ID="cmbDocumentType" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="cmbDocumentType_SelectedIndexChanged">
                                                <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="clearfix">
                            </div>
                            <div class="col-md-6 form-group">
                                <div class="col-md-4">
                                    <asp:Label ID="Label6" runat="server" CssClass="LabelStyle" Text="Department"></asp:Label>
                                    <asp:Label ID="Label7" runat="server" CssClass="MandratoryFieldMarkStyle" Text="*"></asp:Label>
                                </div>
                                <div class="col-md-6">
                                    <asp:DropDownList ID="cmbDepartment"  runat="server" CssClass="form-control" AutoPostBack="True">
                                        <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                    </asp:DropDownList>
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
                            <div class="col-md-4 form-group">
                            <i class="fa fa-search btn-style btn-primary white">
                                <asp:Button ID="btnsearchSub" runat="server" Text="Search" OnClick="btnsearchSub_Click"
                                    CssClass="btn btn-primary" /></i>
                                    <i class="fa fa-eraser btn-style btn-danger white">
                                <asp:Button ID="btnclear" runat="server" Text="Clear" OnClick="btnclear_Click" CssClass="btn btn-danger" /></i>
                            </div>
                        </fieldset>
                        
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                        <div class="row form-group">
                            <div style="overflow: auto;">
                                <asp:GridView ID="grdView" runat="server" AutoGenerateColumns="true" UseAccessibleHeader="true"
                                    AlternatingRowStyle-CssClass="alt" EmptyDataText="No record found for selected criteria."
                                    CssClass="mGrid" PagerStyle-CssClass="pgr" OnRowDataBound="grdView_RowDataBound"
                                    AllowSorting="True" OnSorting="grdView_Sorting">
                                    <AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
                                    <PagerSettings FirstPageText="<<" LastPageText=">>" Mode="NumericFirstLast" NextPageText=" "
                                        PageButtonCount="5" PreviousPageText=" " />
                                    <PagerStyle CssClass="pgr" BorderStyle="None"></PagerStyle>
                                </asp:GridView>
                            </div>
                        </div>
                        <div class="row " >
                            <div class="col-md-6 col-md-offset-3">
                            
                            <div class="PagingTD" >
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
                                                        <asp:DropDownList ID="ddlPage" runat="server" AutoPostBack="True" Width="50px" OnSelectedIndexChanged="ddlPage_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                        of
                                                        <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                                                    
                                                    <i class="fa fa-step-forward btn-style btn-primary white">
                                                        <asp:Button ID="lnkbtnNext" CssClass="btn btn-primary" ToolTip="Next" runat="server"
                                                            CommandName="Next" OnCommand="GetPageIndex"></asp:Button></i>
                                                   
                                                    <i class="fa fa-fast-backward btn-style btn-primary white">
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
                        <div class="col-md-6 ">
                            <div class="col-md-4">
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
            
            










        
    

