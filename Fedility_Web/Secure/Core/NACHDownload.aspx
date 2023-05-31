<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/doQman.Master" CodeBehind="NACHDownload.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Core.NACHDownload" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>

<asp:Content ID="Content2" ContentPlaceHolderID="Head" runat="server">
  <style type="text/css">
     .rbl input[type="radio"]
        {
           margin-left: 5px;
           margin-right: 1px;
        }

  </style>
<script language="javascript" type="text/javascript">
    $(document).ready(function () {
//        getINDUSUploadData();
    });
    var msgControl = "#<%= lblMessage.ClientID %>";

    function uploadStart(sender, args) {
        var result;
        var filename = args.get_fileName();
        var filext = filename.substring(filename.lastIndexOf(".") + 1);

        if (filext == 'xls' || filext == 'xlsx' || filext == 'csv' || filext == 'txt') {
            return true;
        }
        else {
            var err = new Error();
            err.name = 'My API Input Error';
            err.message = 'File format not supported! (Supported format xls,xlsx,csv,txt)';
            throw (err);
            return false;
        }
    }
    function clearContents() {
        var AsyncFileUpload = $get("<%=AsyncFileUpload1.ClientID%>");
        var txts = AsyncFileUpload.getElementsByTagName("input");
        for (var i = 0; i < txts.length; i++) {
            if (txts[i].type == "text") {
                txts[i].value = "";
                txts[i].style.backgroundColor = "white";
            }
        }
    }
    function ErrorUpload() {
        //clearContents();
        $(msgControl).html(GetAlertMessages("<%= hdnUploadError.ClientID %>!"));
        document.getElementById("<%= hdnUploadStatus.ClientID %>").value = 0;
       // getINDUSUploadData();
    }
    function success() {
        //clearContents();
        //   $(msgControl).html(GetAlertSuccessMessages("Uploaded successfully!"));
        document.getElementById("<%= hdnUploadStatus.ClientID %>").value = 1;
        document.getElementById('<%=btnSubmit.ClientID%>').click();
        //getINDUSUploadData();
    }
    function clearContents() {
        var span = $get("<%=AsyncFileUpload1.ClientID%>");
        var txts = span.getElementsByTagName("input");
        for (var i = 0; i < txts.length; i++) {
            if (txts[i].type == "text") {
                txts[i].value = "";
            }
            if (txts[i].type == "file") {
                txts[i].value = "";
            }
        }
    }
    function Check_Click(objRef) {
        //Get the Row based on checkbox
        var row = objRef.parentNode.parentNode;
        if (objRef.checked) {
            
            //If checked change color to Aqua
            //  row.style.backgroundColor = "aqua";
            
        }
        else {
          //  document.getElementById("chkAll").checked = false;
            //If not checked change back to original color
            if (row.rowIndex % 2 == 0) {
                //Alternating Row Color
                //  row.style.backgroundColor = "#C2D69B";
            }
            else {
                ///  row.style.backgroundColor = "white";
            }
        }
    }
    function checkAll(objRef) {
        var GridView = objRef.parentNode.parentNode.parentNode;
        var inputList = GridView.getElementsByTagName("input");
        for (var i = 0; i < inputList.length; i++) {
            //Get the Cell To find out ColumnIndex             
            var row = inputList[i].parentNode.parentNode;
            if (inputList[i].type == "checkbox" && objRef != inputList[i]) {
                if (objRef.checked) {
                    //If the header checkbox is checked
                    //check all checkboxes
                    //and highlight all rows
                    //  row.style.backgroundColor = "aqua";
                    inputList[i].checked = true;
                }
                else {
                    //If the header checkbox is checked
                    //uncheck all checkboxes
                    //and change rowcolor back to original
                    if (row.rowIndex % 2 == 0) {
                        //Alternating Row Color
                        //     row.style.backgroundColor = "#C2D69B";
                    }
                    else {
                        //    row.style.backgroundColor = "white";
                    }
                    inputList[i].checked = false;
                }
            }
        }
    }
    


</script>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
<!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            NACH Download
        </h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">NACH Download</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<asp:HiddenField ID="hdnAction" runat="server" Value="" />
    <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
    <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
    <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
    <asp:HiddenField ID="hdnUploadStatus" runat="server" Value="" />
    <asp:HiddenField ID="hdnUploadError" runat="server" Value="" />
    <div id="page-content">
        <div class="panel">
            <div class="panel-body">
              <div id="lblMessage1" runat="server">
                </div>
                 <div class="clearfix">
                            </div>
                 <fieldset>
                <div class="DivInlineBlock">
                 <asp:UpdatePanel ID="DocumentPanel" runat="server" RenderMode="Inline" UpdateMode ="Conditional">
                            <ContentTemplate>
                            <div id="lblMessage" runat="server">
                                </div>
              <div class="row">
                  <div class="col-md-3">
                   <i class="fa fa-download btn-primary btn-style white">   
                      <asp:Button CssClass="btn btn-primary" ID="btnDownloadTemplate" 
                          Text="Download Template" runat="server" onclick="btnDownloadTemplate_Click"  /></i>
                  </div>
                  <div class="col-md-2">
                  <asp:Label ID="Label6" runat="server" CssClass="LabelStyle" Text="Select File (xls,xlsx)">
                                            </asp:Label>
                                            <asp:Label ID="Label7" runat="server" ForeColor="red" CssClass="MandratoryFieldMarkStyle" Text="*"></asp:Label>
                                            <br />
                                            <!--Changed the width from 283px to 160px to make compatible with firefox and chrome--->
                                            <ajax:AsyncFileUpload ID="AsyncFileUpload1" runat="server" CssClass="LabelStyle" Width="160px"
                                                CompleteBackColor="Lime" ErrorBackColor="Red" ThrobberID="Throbber" OnClientUploadStarted="uploadStart"
                                                 OnUploadedComplete="AsyncFileUpload1_UploadedComplete" UploadingBackColor="#66CCFF"
                                                OnClientUploadComplete="success" OnClientUploadError="ErrorUpload" />
                                            <asp:Label ID="Throbber" runat="server" Style="display: none">
                            <img alt="Loading..." src="<%= Page.ResolveClientUrl("~/Images/indicator.gif")%>" /></asp:Label>
                  </div>
                  <div class="col-md-3">
                   <i class="fa fa-refresh btn-primary btn-style white">   
                      <asp:Button CssClass="btn btn-primary" ID="btnrefresh" 
                          Text="Clear" runat="server" onclick="btnrefresh_Click"   /></i>
                  </div>
                 
                  
                  <div class="col-md-3">
                  <i class="fa fa-download btn-primary btn-style white">   
                      <asp:Button CssClass="btn btn-primary" ID="btnDownloadNACH" 
                          Text="Download NACH" runat="server" onclick="btnDownloadNACH_Click"   /></i>
                          <br />
                     
                      <asp:RadioButtonList
                          ID="Radiobtnformat" CssClass="rbl" runat="server" 
                          RepeatDirection="Horizontal">
                          <asp:ListItem Value="1">JPG</asp:ListItem>
                          <asp:ListItem Value="2" Selected="True">PDF</asp:ListItem>
                          <asp:ListItem Value="3">TIF</asp:ListItem>
                      </asp:RadioButtonList>
                  </div>
                 
              </div>
              <div class="row">
                                     
                                        <asp:Button ID="btnSubmit" Style="visibility: hidden" runat="server" Text="" TagName="Read"
                                        OnClick="btnSubmit_Click" />
                                            <asp:Button ID="btnReloadGrid" runat="server" Style="visibility: hidden;" />
                                        
                                   </div>

                 <div class="row">
                 <div class="col-md-4">
                     <div class="table-responsive">
                        
                            <div class="form-group">
                                <asp:GridView ID="grdViewNACH" runat="server" AutoGenerateColumns="true" EmptyDataText="No record found."
                                   CssClass="table table-striped table-bordered"
                                    PagerStyle-CssClass="pgr" AlternatingRowStyle-CssClass="alt" CellPadding="10"
                                    CellSpacing="5"  AllowSorting="True" >
                                   
                                    <AlternatingRowStyle CssClass="alt" />
                                    <Columns>
                                    <asp:TemplateField>
                                    <HeaderTemplate>
                                                <asp:CheckBox ID="chkAll" runat="server" onclick="checkAll(this);" Text="SelectAll"
                                                    AutoPostBack="True" OnCheckedChanged="chkSelect_CheckedChanged" />
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:CheckBox ID="chkSelect" runat="server" onclick="Check_Click(this)" Text="" ToolTip="Edit"
                                                    data-target="#demo-default-modal" data-toggle="modal" TagName="Read" 
                                                    CommandArgument='' AutoPostBack="True" 
                                                    oncheckedchanged="chkSelect_CheckedChanged"  />
                                            </ItemTemplate>
                                            </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                    </div>
                
            
                    </ContentTemplate>
              <Triggers>
                             <asp:PostBackTrigger ControlID="btnDownloadTemplate" />
                             <asp:PostBackTrigger ControlID="btnDownloadNACH" />
                               <asp:AsyncPostBackTrigger ControlID="AsyncFileUpload1" EventName="UploadedComplete" />
                            </Triggers>
              </asp:UpdatePanel>
              
              </div>
              </fieldset>
            </div>
        </div>
    </div>
   
</asp:Content>
