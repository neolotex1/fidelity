<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="BatchUpload.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Core.ManageSoftData"  %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <script language="javascript" type="text/javascript">

        hdnTotalRowCount = "<%= hdnTotalRowCount.ClientID %>";
        btnFilterRow = "<%= btnFilterRow.ClientID %>";
        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
            pageIdContorlID = "<%= hdnPageId.ClientID %>";

            btnFilterRow = "<%= btnFilterRow.ClientID %>";
            hdnTotalRowCount = "<%= hdnTotalRowCount.ClientID %>";
        });

        function validate() {
            var msgControl = "#<%= divMsg.ClientID %>";
            if (document.getElementById("<%= cmbDocumentType.ClientID  %>").value == 0) {
                $(msgControl).html(GetAlertMessages("Please Select Project Type!"));

              return false;
            }
            else if (document.getElementById("<%= cmbDepartment.ClientID  %>").value == 0) {
                $(msgControl).html(GetAlertMessages("Please Select Department!"));
                return false;
            }
            return true;
        }
        function ValidateDownloadTemplate() {
            var lblMsg = document.getElementById("<%= lblMessage.ClientID %>");
            var ddlProject = document.getElementById("<%= cmbDocumentType.ClientID %>");
            var ddlDepartment = document.getElementById("<%= cmbDepartment.ClientID %>");
            if (ddlProject.value == "0" || ddlProject.value == undefined) {
                lblMsg.innerHTML = GetAlertMessages("Please select the Project Type.");
                return false;
            }
            else if (ddlDepartment.value == "0" || ddlDepartment.value == undefined) {
                lblMsg.innerHTML = GetAlertMessages("Please select the Department.");
                return false;
            }
            return true;
        }
        function uploadStart(sender, args) {
            var result;
            var msgControl = "#<%= divMsg.ClientID %>";
            var filename = args.get_fileName();
            var filext = filename.substring(filename.lastIndexOf(".") + 1);

            if (document.getElementById("<%= cmbDocumentType.ClientID  %>").value == 0) {
                var err = new Error();
                err.name = 'My API Input Error';
                err.message = 'Please Select Project Type!';
                //alert("Please Select Project Type!");
                throw (err);
                return false;
            }

            if (filext == 'xls' || filext == 'xlsx' || filext == 'csv' || filext == 'txt') {
                return true;
            }
            else {
                var err = new Error();
                err.name = 'My API Input Error';
                err.message = 'Upload File should be with "xls or xlsx" format!';
                alert("Upload File should be with(xls or xlsx) format!");
                
                return false;
                //throw (err);
                return false;
            }
        }

        function getBatchUploadData(Action) {
            //
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
            pageIdContorlID = "<%= hdnPageId.ClientID %>";
            //
            var msgControl = "#<%= divMsg.ClientID %>";
            var DocumentType = $("#<%= cmbDocumentType.ClientID %>").val();
            var DepartmentID = $("#<%= cmbDepartment.ClientID %>").val();
            var Filter = $("#<%= cmbFilter.ClientID %>").val();
            var PageNo = document.getElementById("<%= hdnPageNo.ClientID%>").value;
            var RowsPerPage = document.getElementById("<%= hdnRowsPerPage.ClientID%>").value

            var params = DocumentType + '|' + Filter + '|' + DepartmentID + '|' + '0' + '|' + PageNo + '|' + RowsPerPage;
            if (validate()) {
                $("#divSearchResults").html("");
               
                return CallPostScalar(msgControl, "GetBatchUploadData", params);
            }
        }

//        function ReloadDataOnUpload() {

//            return false;
        //        }
        function clearContents() {
            var AsyncFileUpload = $get("<%=AsyncFileUpload1.ClientID%>");
            var txts = AsyncFileUpload.getElementsByTagName("input");
            for (var i = 0; i < txts.length; i++) {
                if (txts[i].type == "text") {
                    txts[i].value = "";
                }
                if (txts[i].type == "file") {
                    txts[i].value = "";
                }
            }
        }
        function success() {
            clearContents();
            document.getElementById('<%= btnSub.ClientID%>').click();
        }
        // Clear AsyncFileUploadControl content/Path
//        function success() {
//            //            $('input[type="file"]').each(function () {

//            //                $("#" + this.id).replaceWith($("#" + this.id).clone(true));
//            //            });
//            //            //For other browsers
//            //            $('input[type="file"]').each(function () { $("#" + this.id).val(""); });
//         
//            getBatchUploadData();
//            $(".k-upload-files.k-reset").find("li").remove();
//        }

        function DeleteData(ProcessID) {
            var display = confirm("Are you sure you want to delete the selected record?");
            if (display == true) {
                //
                loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
                loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
                pageIdContorlID = "<%= hdnPageId.ClientID %>";
                //
                var msgControl = "#<%= divMsg.ClientID %>";
                var DocumentType = $("#<%= cmbDocumentType.ClientID %>").val();
                var DepartmentID = $("#<%= cmbDepartment.ClientID %>").val();
                var Filter = $("#<%= cmbFilter.ClientID %>").val();
                var PageNo = document.getElementById("<%= hdnPageNo.ClientID%>").value;
                var RowsPerPage = document.getElementById("<%= hdnRowsPerPage.ClientID%>").value;
                var DeleteID = ProcessID;
                var params = DocumentType + '|' + Filter + '|' + DepartmentID + '|' + ProcessID + '|' + PageNo + '|' + RowsPerPage;
                if (validate()) {
                    $("#divSearchResults").html("");
                    return CallPostScalar(msgControl, "GetBatchUploadData", params);
                }
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
          Employee Data upload
        </h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Employee Data upload</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
                        <asp:HiddenField ID="hdnAction" runat="server" Value="" />
    <div id="page-content">
        <div class="panel">
            <div class="panel-body">
             <div id="lblMessage" runat="server">
                </div>
                <fieldset>
                    <div class="DivInlineBlock">
                        <asp:UpdatePanel ID="DocumentPanel" runat="server" UpdateMode="Conditional" RenderMode="Inline">
                            <ContentTemplate>
                                <div id="divMsg" runat="server" style="color: Red">
                                    &nbsp;</div>
                                <div class="row">
                                    <div class="col-md-2 form-group">
                                        <asp:Label ID="Label3" runat="server" CssClass="control-label" Text="Project Type"></asp:Label>
                                        <span style="color: Red">*</span>
                                    </div>
                                    <div class="col-md-3 form-group">
                                        <asp:DropDownList ID="cmbDocumentType" runat="server" CssClass="form-control" AutoPostBack="True"
                                            OnSelectedIndexChanged="cmbDocumentType_SelectedIndexChanged">
                                            <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-2 form-group">
                                        <asp:Label ID="Label2" runat="server" CssClass="control-label" Text="Department"></asp:Label>
                                        <span style="color: Red">*</span>
                                    </div>
                                    <div class="col-md-3 form-group">
                                        <asp:DropDownList ID="cmbDepartment" runat="server" AutoPostBack="True" CssClass="form-control">
                                            <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <div class="row" style="display:none">
                                    <div class="col-md-2 form-group">
                                        <asp:Label ID="Label1" runat="server" CssClass="control-label" Text="Filter"></asp:Label>
                                        <span style="color: Red">*</span>
                                    </div>
                                    <div class="col-md-3 form-group">
                                        <asp:DropDownList ID="cmbFilter" runat="server" AutoPostBack="True" CssClass="form-control">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                 
                            </ContentTemplate>
                            
                        </asp:UpdatePanel>
                    </div>
                  
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <asp:Label ID="Label6" runat="server" CssClass="LabelStyle" Text="Select File (xls,xlsx)">
                            </asp:Label>
                            <asp:Label ID="Label7" runat="server" CssClass="MandratoryFieldMarkStyle" Text="*"></asp:Label>
                        </div>
                    </div>
                   
                    <div class="row">
                     
                        <div class="col-md-2">
                            <asp:AsyncFileUpload ID="AsyncFileUpload1"  runat="server" CssClass="LabelStyle" Width="160px"
                                CompleteBackColor="Lime" ErrorBackColor="Red"  ThrobberID="Throbber" 
                                OnUploadedComplete="AsyncFileUpload1_UploadedComplete" UploadingBackColor="#66CCFF"
                                OnClientUploadComplete="success" />
                            <asp:Label ID="Throbber" runat="server" Style="display: none">
                            <img alt="Loading..." src="<%= Page.ResolveClientUrl("~/Images/indicator.gif")%>" /></asp:Label>
                        </div>
                        <div class="col-md-6">
                            <div style="float: left;padding-right: 3px;" >
                            <i class="fa fa-arrow-down btn-style btn-primary white">
                                                        <asp:Button ID="btnExportTemplate" 
                                    CssClass="btn btn-primary" runat="server" OnClientClick="return ValidateDownloadTemplate();" Text="Download Upload Template"
                                                            TagName="Read" 
                                    onclick="btnExportTemplate_Click"  />
                            </i>
                            </div>
                             <div  id="divSubmit" runat="server"  style="float: left; padding-right: 3px; ">
                                                <i class="fa fa-floppy-o btn-style btn-primary white">
                                                    <asp:Button ID="btnSubmit" CssClass="btn btn-primary" runat="server" 
                                                    Text="Submit" TagName="Read" onclick="btnSubmit_Click" 
                                                        />
                                                </i>
                                            </div>
                                            <div id="divCancel" runat="server"  style="float: left; padding-right: 3px; ">
                                                <i class="fa fa-refresh btn-primary btn-style white"> 
                                                    <asp:Button CssClass="btn btn-primary"  ID="btnrefresh" 
                          Text="Refresh" runat="server" onclick="btnrefresh_Click"  />
                                                </i>
                                            </div>
                        </div>
                        <div class="row">
                                        <asp:Button ID="btnSub" Style="visibility: hidden"  runat="server" 
                                            onclick="btnSub_Click"  />
                                        <asp:Button ID="btnReloadGrid" runat="server" Style="visibility: hidden;" />
                                    </div>

                                 
                    </div>
                   
                    <div class="row form-group">
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
                       <%-- <asp:Button ID="btnReloadGrid" runat="server" Style="visibility: hidden;" OnClientClick="getBatchUploadData();return false;" />--%>
                    </div>
                    <div class="row">
                                <div class="table-responsive">
                                    <div class="col-md-12">
                                        <div class="form-group">
                                        
                                            <asp:GridView ID="GridPendingList" runat="server"  AutoGenerateColumns="true" CssClass="table table-striped table-bordered"
                                                PagerStyle-CssClass="pgr" AlternatingRowStyle-CssClass="alt" EmptyDataText="No list are found"
                                                CellPadding="10" CellSpacing="5" PageSize="10">
                                                <AlternatingRowStyle CssClass="alt"></AlternatingRowStyle>
                                                <PagerSettings FirstPageText="<<" LastPageText=">>" Mode="NumericFirstLast" NextPageText=" " />
                                            </asp:GridView>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                    <div class="DivInlineBlock">
                        <div style="width: inherit; height: inherit;">
                            <div class="row">
                            
                                <div class="col-md-2">
                                    <div id="divPagingText">
                                        &nbsp;</div>
                                </div>
                                <div class="col-md-6">
                                </div>
                                <div class="col-md-push-right-6">
                                    <div id="paging" style="visibility: hidden;">
                                        <a>Rows per page
                                            <select name="RowsPerPage" id="RowsPerPage" runat="server" cssclass="form-control input-sm"
                                                onchange="OnPagingIndexClick(1);" style="width: 50px;">
                                                <option>5</option>
                                                <option selected="selected">10</option>
                                                <option>25</option>
                                                <option>50</option>
                                                <option>100</option>
                                            </select>
                                            Current Page
                                            <select name="CurrentPage" id="CurrentPage" runat="server" cssclass="form-control input-sm"
                                                onchange="OnPageIndexChange();" style="width: 50px;">
                                            </select>
                                            of
                                            <asp:Label ID="TotalPages" runat="server" CssClass="LabelStyle" Text=""></asp:Label>
                                            <asp:HiddenField ID="hdnPageNo" Value="1" runat="server" />
                                            <asp:HiddenField ID="hdnSortColumn" Value="ASC" runat="server" />
                                            <asp:HiddenField ID="hdnSortOrder" runat="server" />
                                            <asp:HiddenField ID="hdnTotalRowCount" runat="server" />
                                            <asp:HiddenField ID="hdnRowsPerPage" Value="10" runat="server" />
                                            <asp:Button ID="btnFilterRow" runat="server" Height="25px" class="HiddenButton" Text="&lt;&lt; Remove"
                                                OnClientClick="createPagingIndexes(); return false;" TagName="Read" />
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div id="divSearchResults">
                                    &nbsp;</div>
                            </div>
                            <div class="row">
                                <div class="col-md-12">
                                    <div id="divRecordCountText">
                                        &nbsp;</div>
                                      

                                </div>
                            </div>
                        </div>
                    </div>
                </fieldset>
            </div>
        </div>
    
    <script language="javascript" type="text/javascript">

        function hideColumn(col) {

            if (col == "") {
                alert("Invalid Column");
                return;
            }

            var tbl = document.getElementById("tblData");
            if (tbl != null) {

                for (var i = 0; i < tbl.rows.length; i++) {
                    for (var j = 0; j < tbl.rows[i].cells.length; j++) {
                        // tbl.rows[i].cells[j].style.display = "";

                        if (col.indexOf(j) >= 0)
                            tbl.rows[i].cells[j].style.display = "none";
                    }
                }
            }
        }

        function createPagingIndexes() {
            //*/
            //Dropdown binding

            var indexCount = document.getElementById("<%= hdnTotalRowCount.ClientID%>").value;

            var rowsPerPage = document.getElementById("<%= hdnRowsPerPage.ClientID%>").value
            // var MaxPages = indexCount / rowsPerPage + (indexCount % rowsPerPage);
            var MaxPages = indexCount / rowsPerPage;
            MaxPages = Math.ceil(MaxPages)

            var min = 1,
                max = MaxPages,
                select = document.getElementById("<%= CurrentPage.ClientID%>");
            $(select).empty();
            for (var i = min; i <= max; i++) {
                var opt = document.createElement('option');
                opt.value = i;
                opt.innerHTML = i;
                if (document.getElementById("<%= hdnPageNo.ClientID%>").value == i)
                    opt.setAttribute('selected', 'selected');
                //select.add(option, 0);
                select.appendChild(opt);
            }
            var TotalPages = document.getElementById("<%= TotalPages.ClientID%>");
            //document.getElementById("<%= TotalPages.ClientID%>").value = MaxPages;
            //MaxPages = Math.round(MaxPages);
            TotalPages.innerHTML = MaxPages;

            //Hide unnecessary columns
            hideColumn('1');
        }

        function OnPageIndexChange() {
            OnPagingIndexClick(document.getElementById("<%= CurrentPage.ClientID%>").value);
        }

        function OnPagingIndexClick(index) {
            document.getElementById("<%= hdnPageNo.ClientID%>").value = index;
            RowsPerPage = document.getElementById("<%= RowsPerPage.ClientID%>").value;
            document.getElementById("<%= hdnRowsPerPage.ClientID%>").value = RowsPerPage;
            getBatchUploadData();
        }
    </script>
    </div>
</asp:Content>
