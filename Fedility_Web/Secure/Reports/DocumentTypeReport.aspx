﻿<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="DocumentTypeReport.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Reports.DocumentTypeReport" %>

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
          if (document.getElementById("<%= drpOrg.ClientID  %>").value == "0") {
              $(msgControl).html(GetAlertMessages("Please Select Customer!"));
              result = false;
          }
          else if (document.getElementById("<%= drpDocType.ClientID  %>").value == "-1") {
              $(msgControl).html(GetAlertMessages("Please Select Project Type!"));
              result = false;
          }
          else if (document.getElementById("<%= drpAction.ClientID  %>").value == "0") {
              $(msgControl).html(GetAlertMessages("Please Select Action Type!"));
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
          $('#pnlMainDiv').hide();

          return result;

      }
    </script>  
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
   
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Document Type Report</h1>
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
    
        <div class="row form-group">
            
                <div id="divMsg" runat="server" style="color: Red; font-family: Calibri; font-size: small">
           
        </div>
        </div>
        
            <div class="col-md-6 form-group">
                <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" OldValuesParameterFormatString="original_{0}"
                        SelectMethod="GetData" TypeName="Lotex.EnterpriseSolutions.WebUI.Secure.Reports.MainReportDataSetTableAdapters.USP_DMS_doQ_CustTypeDocTypeReportTableAdapter">
                        <SelectParameters>
                            <asp:Parameter Name="in_iOrgID" Type="Int32" />
                            <asp:Parameter Name="in_iDocTypeId" Type="Int32" />
                            <asp:Parameter Name="in_dStartDate" Type="DateTime" />
                            <asp:Parameter Name="in_dEndDate" Type="DateTime" />
                            <asp:Parameter Name="in_vLoginToken" Type="String" />
                            <asp:Parameter Name="in_iLoginOrgId" Type="Int32" />
                        </SelectParameters>
                    </asp:ObjectDataSource>
               
            </div>
            <div class="clearfix">
        </div>
        <div class="col-md-6 form-group">
            <div class="col-md-4">
           
            <asp:Label ID="lblSubHeading" CssClass="SubHeadings" runat="server" Text="Report Filters"></asp:Label>
             </div>
        </div>
        <div class="clearfix">
        </div>
        
            <fieldset>
            
             <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                <div class="col-md-6 form-group">
                    <div class="col-md-4">
                        <asp:Label ID="lblOrgName" runat="server" CssClass="LabelStyle" Text="Customer Name"></asp:Label>
                    </div>
                    <div class="col-md-6">
                       <asp:DropDownList ID="drpOrg" runat="server" CssClass="form-control" OnSelectedIndexChanged="drpOrg_SelectedIndexChanged"
                                            AutoPostBack="True">
                                            <asp:ListItem Value="0">&lt;select&gt;</asp:ListItem>
                                        </asp:DropDownList> 
                    </div>
                    

                </div>
                                <div class="clearfix">
                                </div>
                                <div class="col-md-6 form-group">
                                    <div class="col-md-4">
                                       <asp:Label ID="lblDoctType" runat="server" CssClass="LabelStyle" Text="Project Type"></asp:Label> 
                                    </div>
                                    <div class="col-md-6">
                                         <asp:DropDownList ID="drpDocType" CssClass="form-control" runat="server" >
                                            <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix">
                                </div>
                                <div class="col-md-6 form-group">
                                    <div class="col-md-4">
                                       <asp:Label ID="lblAction" runat="server" CssClass="LabelStyle" Text="Action Type"></asp:Label> 
                                    </div>
                                    <div class="col-md-6">
                                        <asp:DropDownList ID="drpAction" CssClass="form-control" runat="server" >
                                            <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                            <asp:ListItem Value="1000">Upload</asp:ListItem>
                                            <asp:ListItem Value="1001">Download</asp:ListItem>
                                            <asp:ListItem Value="1004">Viewed</asp:ListItem>
                                            <asp:ListItem Value="1011">Printed</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="clearfix">
                                </div>
                                <div class="col-md-6 form-group">
                                    <div class="col-md-12">
                                        <asp:Label ID="Label1" runat="server" CssClass="LabelStyle" Text="Upload/Download Date :"></asp:Label>
                                    </div>
                                </div>
                                <div class="clearfix">
                                </div>
                                <div class="row ">
                                    <div class="col-sm-6">
                                <div class="form-group">
                                    <asp:Label ID="Label2" runat="server" CssClass="control-label" Text="Created Date From"></asp:Label>
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
                                </div><br />
                                <div class="col-md-6 form-group">
                                    <div class="col-md-6">
                                    <i class="fa fa-flag btn-style btn-primary white">
                                        <asp:Button ID="btnGenerate" runat="server"  Text="Generate Report"   CssClass="btn btn-primary"
                                    OnClick="btnGenerate_Click" /></i>
                                    </div>
                                </div>
                                 </ContentTemplate>
                        </asp:UpdatePanel>
                        
                                                </fieldset>
        <div class="clearfix">
        </div>
        <div class="col-md-6 form-group">
             <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                    <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                    <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                    <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
        </div>
        <div class="clearfix">
        </div>
        <div class="col-md-6 form-group">
         <center>
                                    <div id="pnlMainDiv" style=" background-color: rgb(234, 235, 229);overflow:auto; ">
                                        <rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Names="Calibri" Font-Size="Small"
                                            Height="616px" InteractiveDeviceInfos="(Collection)" WaitMessageFont-Names="Calibri"
                                            WaitMessageFont-Size="Small" Width="1000px" Visible="False" PageCountMode="Actual"
                                            AsyncRendering="False">
                                            <LocalReport ReportPath="Secure\Reports\CustTypeDocTypeReport.rdlc">
                                            </LocalReport>
                                        </rsweb:ReportViewer>
                                    </div>
                                </center>
           
        </div>


        
        
        </div>
        </div>
        </div>
        
    </div>
</asp:Content>
