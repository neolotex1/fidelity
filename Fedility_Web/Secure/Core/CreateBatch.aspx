<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="CreateBatch.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Core.CreateBatch"
    EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
    <link href="../../App_Themes/common/common.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/GridRowSelection.js" type="text/javascript"></script>
    <script type="text/javascript">
        function validate() {
            var msgControl = "#<%= divMsg.ClientID %>";
            var cmbBatchName = $("#<%= cmbBatchName.ClientID %>").val();
            var txtBatchName = $.trim($("#<%= txtBatchName.ClientID %>").val());
            if (cmbBatchName == "0" && txtBatchName.length == 0) {
                $(msgControl).html(GetAlertMessages("Please enter Batch Name!"));
                return false;
            }
            return true;
        }
        function BrowserIdentification() {
            var Browser;
            var isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0;
            // Opera 8.0+ (UA detection to detect Blink/v8-powered Opera)
            var isFirefox = typeof InstallTrigger !== 'undefined';   // Firefox 1.0+
            var isSafari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0;
            // At least Safari 3+: "[object HTMLElementConstructor]"
            var isChrome = !!window.chrome && !isOpera;              // Chrome 1+
            var isIE = /*@cc_on!@*/false || !!document.documentMode; // At least IE6

            if (isOpera) {
                Browser = "opera";
            }
            else if (isFirefox) {
                Browser = "firefox";
            }
            else if (isSafari) {
                Browser = "safari";
            }
            else if (isChrome) {
                Browser = "chrome";
            }
            else if (isIE) {
                Browser = "ie";
            }
            return Browser;
        }
        function InstallApp() {
            var OrgID = $("#<%= hdnLoginOrgId.ClientID %>").val();
            var LoginToken = $("#<%= hdnLoginToken.ClientID %>").val();
            var ClickOnceLink = '<%= ConfigurationManager.AppSettings["ClickOnceLink"].ToString() %>' + '?OrgID=' + OrgID + '&LoginToken=' + LoginToken;
            var browser = BrowserIdentification();
            if (browser != "chrome") {
                window.open(ClickOnceLink);
            }
            else {
                alert("This feature is not supported in Google Chrome! Please use IE or Mozilla Firefox.");
            }
            return false;
        }

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Create Batch</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Create Batch</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="page-content"> 
    <div class="panel">
        <div class="panel-body">
            <fieldset>
          
                <asp:UpdatePanel ID="UpdatePanel2" runat="server" UpdateMode="Always" RenderMode="Block">
                    <ContentTemplate>
                        <div class="row">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:Label ID="Label3" runat="server" CssClass="control-label" Text="Project Type"></asp:Label>
                                    <span style="color: Red">*</span>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="cmbDocumentType" runat="server" AutoPostBack="True" CssClass="form-control input-sm"
                                        OnSelectedIndexChanged="cmbDocumentType_SelectedIndexChanged">
                                        <asp:ListItem Value="0">--Select--</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:Label ID="Label2" runat="server" CssClass="control-label" Text="Department"></asp:Label>
                                    <span style="color: Red">*</span>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="cmbDepartment" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbDepartment_SelectedIndexChanged"
                                        CssClass="form-control input-sm">
                                        <asp:ListItem Value="0">--Select--</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:Label ID="Label1" runat="server" CssClass="control-label" Text="Batch Name"></asp:Label>
                                    <span style="color: Red">*</span>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="cmbBatchName" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbBatchName_SelectedIndexChanged"
                                        CssClass="form-control input-sm">
                                        <asp:ListItem Value="0">--Select--</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <asp:Panel ID="Statuspanel" runat="server">
                            <div class="row">
                                <div class="col-sm-3">
                                    <div class="form-group">
                                        <asp:Label ID="lblSearchbyStatus" runat="server" CssClass="LabelStyle" Text="Status"></asp:Label>
                                        <span style="color: Red">*</span>
                                    </div>
                                </div>
                                <div class="col-sm-3">
                                    <div class="form-group">
                                        <asp:DropDownList ID="ddlstatus" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlstatus_SelectedIndexChanged"
                                            CssClass="form-control input-sm">
                                            <asp:ListItem>All</asp:ListItem>
                                            <asp:ListItem>Uploaded</asp:ListItem>
                                            <asp:ListItem>Pending</asp:ListItem>
                                            <asp:ListItem>NotUploaded</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                
                                <div class="col-sm-3">
                                    <div class="form-group">
                                   
                                        <label class="">
                                            <asp:CheckBox ID="chkDisplaySelected" runat="server" AutoPostBack="true" OnCheckedChanged="chkDisplaySelected_CheckedChanged" />
                                        Display Only Selected</label>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                <i class="fa fa-upload btn-style btn-success white">
                                    <asp:Button ID="btnRun" runat="server" Text="Bulk Upload" 
                                         CssClass="btn btn-success"  OnClientClick="return InstallApp();return false;" /></i>
                                </div>
                            </div>
                        </div>
                        <br />
                        <div class="row form-group">
                            <div class="col-sm-3">
                                <asp:Label ID="lblBatchName" runat="server" CssClass="LabelStyle" Text="New Batch Name"></asp:Label>
                            </div>
                            <div class="col-sm-3">
                                <asp:TextBox ID="txtBatchName" CssClass="form-control" runat="server"></asp:TextBox>
                            </div>
                            <div class="col-sm-2">
                                <asp:Button ID="btnProcess" runat="server" Text="Create" Style="margin-left: 104px;"
                                    CssClass="btn btn-primary" OnClick="btnProcess_Click" OnClientClick="return validate();" />
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-3">
                                <div class="form-group">
                                   
                                </div>
                            </div>
                        </div>
                        <asp:Button ID="btnDelete" runat="server" Text="Delete" OnClick="btnDelete_Click"
                            CssClass="btn" />
                        <asp:CheckBox ID="chkSelectPage" runat="server" AutoPostBack="true" Text="Select Page Wise"
                            OnCheckedChanged="chkSelectPage_CheckedChanged" />
                        <asp:CheckBox ID="chkSelectAll" runat="server" AutoPostBack="true" Text="Select All"
                            OnCheckedChanged="chkSelectAll_CheckedChanged" />
                    </ContentTemplate>
                </asp:UpdatePanel>
                <div id="Grid">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always" RenderMode="Block">
                        <ContentTemplate>
                            <div id="divMsg" runat="server" style="color: Red">
                            </div>
                            <div id="customGridDiv">
                                <asp:GridView ID="grdView" runat="server" CssClass="table table-striped table-bordered" PagerStyle-CssClass="pgr"
                                    EmptyDataText="No record found." OnRowDataBound="grdView_RowDataBound" AllowSorting="True"
                                    OnSorting="grdView_Sorting" AlternatingRowStyle-CssClass="alt" CellPadding="10"
                                    CellSpacing="5">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Select">
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelected" runat="server" AutoPostBack="true" OnCheckedChanged="chkSelected_CheckedChanged" />
                                            </ItemTemplate>
                                            <HeaderStyle CssClass="GridItem1" />
                                        </asp:TemplateField>
                                    </Columns>
                                    <AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
                                    <PagerSettings FirstPageText="<<" LastPageText=">>" Mode="NumericFirstLast" NextPageText=" "
                                        PageButtonCount="5" PreviousPageText=" " />
                                      <PagerStyle CssClass="pagination-ys" />
                                </asp:GridView>
                            </div>
                            <div class="row ">
                            <div class="col-md-6 col-md-offset-3">
                            <div class="PagingTD" id="PageDiv" runat="server">
                                <div class="PagingControl">
                                    
                                        
                                    <div class="row">
                                        <div class="pagination" style="font-size: 10pt;" >
                                       
                                            Rows per page
                                            <asp:DropDownList ID="ddlRows" Width="50px" Height="30px" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlRows_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        <i class="fa fa-fast-backward btn-style btn-primary white">
                                            <asp:Button ID="lnkbtnFirst" CssClass="btn-primary" ToolTip="First" CommandName="First"
                                                 runat="server" OnCommand="GetPageIndex"></asp:Button></i>
                                      <i class="fa fa-step-backward btn-style btn-primary white">
                                            <asp:Button ID="lnkbtnPre" CssClass="btn-primary" ToolTip="Previous"
                                                CommandName="Previous" runat="server" OnCommand="GetPageIndex"></asp:Button></i>
                                        
                                            Page
                                            <asp:DropDownList ID="ddlPage" runat="server" AutoPostBack="True" Width="50px" Height="30px" OnSelectedIndexChanged="ddlPage_SelectedIndexChanged">
                                            </asp:DropDownList>
                                            of
                                            <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                                        <i class="fa fa-step-forward btn-style btn-primary white">
                                            <asp:Button ID="lnkbtnNext" CssClass="btn-primary"
                                                ToolTip="Next" runat="server"  CommandName="Next" OnCommand="GetPageIndex">
                                            </asp:Button></i>
                                       <i class="fa fa-fast-forward btn-style btn-primary white">
                                            <asp:Button ID="lnkbtnLast" CssClass="btn-primary" ToolTip="Last" runat="server"
                                                CommandName="Last" OnCommand="GetPageIndex"></asp:Button></i>
                                        </div>
                                    </div>
                                        
                                    <asp:Label ID="lblMessage" runat="server" EnableViewState="false"></asp:Label>
                                </div>
                            </div>
                            </div>
                            </div>
                            
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </fieldset>
        </div>
    </div>
    </div>
    <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
    <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
    <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
    <asp:HiddenField ID="hdnAction" runat="server" Value="" />
    <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
    <asp:HiddenField ID="hdnBatchatcion" runat="server" Value="" />
</asp:Content>
