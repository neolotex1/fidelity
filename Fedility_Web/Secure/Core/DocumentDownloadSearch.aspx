<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="DocumentDownloadSearch.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Secure.Core.DocumentDownloadSearch" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Head" runat="server">
    <!-- Script for hiding table cells/columns -->
    <script type="text/javascript" language="javascript">        
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
    </script>
    <!-- Script for paging -->
    <script type="text/javascript" language="javascript">

        function createPagingIndexes() {
            //*/
            //Dropdown binding

            var indexCountObj = document.getElementById("<%= hdnTotalRowCount.ClientID%>")

            if (indexCountObj != null) {
                var indexCount = indexCountObj.value;

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

                var DivText = document.getElementById("<%=divRecordCountText.ClientID%>").innerHTML;
                $("<%=divRecordCountText.ClientID %>").html(DivText + " Record(s)");

                //Hide unnecessary columns- 1:TotalRows, 3:MainTag, 4:SubTag, 6:ProcessId, 11: Deleted
                hideColumn_BS('1,3,4,6,11');
            }

            var indexCountObjOCR = document.getElementById("<%= hdnTotalRowCount_OCR.ClientID%>")
            if (indexCountObjOCR != null) {
                var indexCountocr = indexCountObjOCR.value;

                var rowsPerPageocr = document.getElementById("<%= hdnRowsPerPage_OCR.ClientID%>").value
                // var MaxPages = indexCount / rowsPerPage + (indexCount % rowsPerPage);
                var MaxPagesocr = indexCountocr / rowsPerPageocr;
                MaxPagesocr = Math.ceil(MaxPagesocr)

                var minocr = 1,
                maxocr = MaxPagesocr,
                selectOcr = document.getElementById("<%= CurrentPage_OCR.ClientID%>");

                //for ocr paging
                $(selectOcr).empty();
                for (var i = minocr; i <= maxocr; i++) {
                    var optOcr = document.createElement('option');
                    optOcr.value = i;
                    optOcr.innerHTML = i;
                    if (document.getElementById("<%= hdnPageNo_OCR.ClientID%>").value == i)
                        optOcr.setAttribute('selected', 'selected');
                    //select.add(option, 0);
                    selectOcr.appendChild(optOcr);
                }


                var TotalPagesOcr = document.getElementById("<%= TotalPages_OCR.ClientID%>");

                TotalPagesOcr.innerHTML = MaxPagesocr;

                var DivTextOCR = document.getElementById("<%=divRecordCountText_OCR.ClientID%>").innerHTML;
                $("<%=divRecordCountText_OCR.ClientID %>").html(DivTextOCR + " Record(s)");


            }


        }





        function OnPageIndexChange() {

            var DocumentType = $("#<%= cmbDocumentType.ClientID %>").val();
            var Department = $("#<%= cmbDepartment.ClientID %>").val();
            if (DocumentType != "0" && Department != "0") {
                OnPagingIndexClick(document.getElementById("<%= CurrentPage.ClientID%>").value);
            }

            var DocumentTypeocr = $("#<%= cmbDocumentType_OCR.ClientID %>").val();
            var Departmentocr = $("#<%= cmbDepartment_OCR.ClientID %>").val();
            if (DocumentTypeocr != "0" && Departmentocr != "0") {
                OnPagingIndexClick(document.getElementById("<%= CurrentPage_OCR.ClientID%>").value);
            }


        }


        function OnPagingIndexClick(index) {

            var DocumentType = $("#<%= cmbDocumentType.ClientID %>").val();
            var Department = $("#<%= cmbDepartment.ClientID %>").val();

            if (DocumentType != "0" && Department != "0") {
                document.getElementById("<%= hdnPageNo.ClientID%>").value = index;
                RowsPerPage = document.getElementById("<%= RowsPerPage.ClientID %>").value;
                document.getElementById("<%= hdnRowsPerPage.ClientID %>").value = RowsPerPage;
                document.getElementById('<%=btnSearch.ClientID %>').click();
            }

            var DocumentTypeocr = $("#<%= cmbDocumentType_OCR.ClientID %>").val();
            var Departmentocr = $("#<%= cmbDepartment_OCR.ClientID %>").val();

            if (DocumentTypeocr != "0" && Departmentocr != "0") {
                document.getElementById("<%= hdnPageNo_OCR.ClientID%>").value = index;
                RowsPerPage_OCR = document.getElementById("<%= RowsPerPage_OCR.ClientID %>").value;
                document.getElementById("<%= hdnRowsPerPage_OCR.ClientID %>").value = RowsPerPage_OCR;
                document.getElementById('<%=btnSearchOCR.ClientID %>').click();
            }



        }

        function SetPageIndex(index) {
            return ValidateInputData();
            document.getElementById("<%= hdnPageNo.ClientID %>").value = index;
            document.getElementById("<%= hdnPageNo_OCR.ClientID %>").value = index;

        }


        function SetPageIndexRemove(index) {
            document.getElementById("<%= hdnPageNo.ClientID %>").value = index;
            document.getElementById("<%= hdnPageNo_OCR.ClientID %>").value = index;
        }
       
    </script>
    <!-- Script for document viewer -->
    <script type="text/javascript" language="javascript">


        var getAcrobatInfo = function () {

            var getBrowserName = function () {
                return this.name = this.name || function () {
                    var userAgent = navigator ? navigator.userAgent.toLowerCase() : "other";

                    if (userAgent.indexOf("chrome") > -1) return "chrome";
                    else if (userAgent.indexOf("safari") > -1) return "safari";
                    else if (userAgent.indexOf("msie") > -1) return "ie";
                    else if (userAgent.indexOf("firefox") > -1) return "firefox";
                    return userAgent;
                } ();
            };

            var getActiveXObject = function (name) {
                try { return new ActiveXObject(name); } catch (e) { }
            };

            var getNavigatorPlugin = function (name) {
                for (key in navigator.plugins) {
                    var plugin = navigator.plugins[key];
                    if (plugin.name == name) return plugin;
                }
            };

            var getPDFPlugin = function () {
                return this.plugin = this.plugin || function () {
                    if (getBrowserName() == 'ie') {
                        //
                        // load the activeX control
                        // AcroPDF.PDF is used by version 7 and later
                        // PDF.PdfCtrl is used by version 6 and earlier
                        return getActiveXObject('AcroPDF.PDF') || getActiveXObject('PDF.PdfCtrl');
                    }
                    else {
                        return getNavigatorPlugin('Adobe Acrobat') || getNavigatorPlugin('Chrome PDF Viewer') || getNavigatorPlugin('WebKit built-in PDF');
                    }
                } ();
            };

            var isAcrobatInstalled = function () {
                return !!getPDFPlugin();
            };

            var getAcrobatVersion = function () {
                try {
                    var plugin = getPDFPlugin();

                    if (getBrowserName() == 'ie') {
                        var versions = plugin.GetVersions().split(',');
                        var latest = versions[0].split('=');
                        return parseFloat(latest[1]);
                    }

                    if (plugin.version) return parseInt(plugin.version);
                    return plugin.name

                }
                catch (e) {
                    return null;
                }
            }

            //
            // The returned object
            // 
            return {
                browser: getBrowserName(),
                acrobat: isAcrobatInstalled() ? 'installed' : false,
                acrobatVersion: getAcrobatVersion()
            };
        };

        //Newcode
        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

        //        function pageLoad() {
        //            var msgControl = "#<%= divMsg.ClientID %>";
        //            var SearchCriteria = getParameterByName("Search");
        //            if (SearchCriteria != null && SearchCriteria.length > 0 && document.getElementById("<%=hdnSearchString.ClientID %>").value.length == 0) {
        //                document.getElementById("<%=hdnSearchString.ClientID %>").value = SearchCriteria;
        //                loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
        //                loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
        //                pageIdContorlID = "<%= hdnPageId.ClientID %>";
        //                document.getElementById('<%=btnSearchAgain.ClientID%>').click();
        //            }
        //        }
    </script>
    <script type="text/javascript" language="javascript">

        function FillcontrolValue(ucControl, ucValues) {
            var Value = "";
            var strControlNames = "";
            var ctlHiddenControlValus = ucValues;
            var row1 = "";
            var controlVal = "";
            strControlNames = ucControl.value.split("#||#");

            for (var i = 0; i < strControlNames.length; i++) {

                row = strControlNames[i].split("#|#");

                controlVal += document.getElementById(row[0]).value + "#|#" +
                    document.getElementById(row[1]).value + "#|#" +
                    document.getElementById(row[2]).value + "#|#";
                if (document.getElementById(row[3]) != null) {
                    controlVal += document.getElementById(row[3]).value + "#|##||#";
                }
                else {
                    controlVal += "#|#" + document.getElementById(row[4]).value + "#||#";
                }

            }

            ucValues.value = controlVal.substring(0, controlVal.length - 4);
            return true;
        }
    </script>
    <script language="javascript" type="text/javascript">

        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
            pageIdContorlID = "<%= hdnPageId.ClientID %>";
            btnFilterRow = "<%= btnFilterRow.ClientID %>";
            hdnTotalRowCount = "<%= hdnTotalRowCount.ClientID %>";
            hdnTotalRowCountOCR = "<%= hdnTotalRowCount_OCR.ClientID %>";




        });



        var RedirectRequired = 'No'; //DMS04-3406M
        function SetHiddenVal(param) {
            if (param == "Dynamic") {
                document.getElementById("<%= hdnDynamicControlIndexChange.ClientID %>").value = "1";
            }
            else {
                document.getElementById("<%= hdnDynamicControlIndexChange.ClientID %>").value = "0";
            }
            return true;
        };

        function ValidateInputData() {

            var DocumentType = document.getElementById("<%= cmbDocumentType.ClientID %>").value;

            var Department = document.getElementById("<%= cmbDepartment.ClientID %>").value;
            
            var msg = document.getElementById("<%= lblMsg.ClientID %>");


            if (document.getElementById("<%= cmbDocumentType.ClientID  %>").value == 0) {
                msg.innerHTML = GetAlertMessages("Please Select Project Type!");
                Scrolltop();
                msg.setAttribute("display", "block");
                return false;
            }
            else if (document.getElementById("<%= cmbDepartment.ClientID  %>").value == 0) {
                msg.innerHTML = GetAlertMessages("Please Select Department!");
                Scrolltop();
                msg.setAttribute("display", "block");
                return false;
            }
            /* DMS04-3396 BS */
            else if (!ValidateSpaceInText()) {
                msg.innerHTML = GetAlertMessages("Please remove space from the text and try!");
                Scrolltop();
                msg.setAttribute("display", "block");
                return false;
            }
        

            /* DMS04-3396 BE */
        }

    </script>
    <script language="javascript" type="text/javascript">

        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId_BS.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken_BS.ClientID %>";
            pageIdContorlID = "<%= hdnPageId_BS.ClientID %>";
            CountControlsID = "<%=hdnCountControls_BS.ClientID %>";
            btnFilterRow_BS = "<%=btnFilterRow_BS.ClientID %>";
            hdnTotalRowCount_BS = "<%=hdnTotalRowCount_BS.ClientID %>";

            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function (s, e) {
                HandleTabCount();
            });

        });
        //added by aswin for default button click on enter key press
        $(document).keypress(function (e) {

            if (e.which == 13) {
                OnPagingIndexClick_BS(1);
                return false;
            }
        });



        function hideColumn_BS(col) {

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



        function SetHiddenVal_BS(param) {
            if (param == "Dynamic") {
                document.getElementById("<%= hdnDynamicControlIndexChange_BS.ClientID %>").value = "1";
            }
            else {
                document.getElementById("<%= hdnDynamicControlIndexChange_BS.ClientID %>").value = "0";
            }
            return true;
        }

        //Newcode
        function createPagingIndexes_BS() {
            //*/
            //Dropdown binding

            var indexCount = document.getElementById("<%= hdnTotalRowCount_BS.ClientID%>").value;

            var rowsPerPage = document.getElementById("<%= hdnRowsPerPage_BS.ClientID%>").value
            // var MaxPages = indexCount / rowsPerPage + (indexCount % rowsPerPage);
            var MaxPages = indexCount / rowsPerPage;
            MaxPages = Math.ceil(MaxPages)

            var min = 1,
                max = MaxPages,
                select = document.getElementById("<%= CurrentPage_BS.ClientID%>");

            $(select).empty();
            for (var i = min; i <= max; i++) {
                var opt = document.createElement('option');
                opt.value = i;
                opt.innerHTML = i;
                if (document.getElementById("<%= hdnPageNo_BS.ClientID%>").value == i)
                    opt.setAttribute('selected', 'selected');
                //select.add(option, 0);
                select.appendChild(opt);
            }

            var TotalPages = document.getElementById("<%= TotalPages_BS.ClientID%>");

            TotalPages.innerHTML = MaxPages;
            var DivText = document.getElementById("divRecordCountText_BS").innerHTML;
            $("#divRecordCountText_BS").html(DivText + " Record(s)");

            //Hide unnecessary columns- 1:TotalRows, 3:MainTag, 4:SubTag, 6:ProcessId, 11: Deleted
            hideColumn_BS('1,3,4,6,11');

        }

        function OnPageIndexChange_BS() {
            OnPagingIndexClick_BS(document.getElementById("<%= CurrentPage_BS.ClientID%>").value);
        }

        function OnPagingIndexClick_BS(index) {
            document.getElementById("<%= hdnPageNo_BS.ClientID%>").value = index;
            RowsPerPage = document.getElementById("<%= RowsPerPage_BS.ClientID%>").value;
            document.getElementById("<%= hdnRowsPerPage_BS.ClientID%>").value = RowsPerPage;
            SearchDocuments_BS();
        }
        function onclicksubmit() {
            document.getElementById("<%= hdnPageNo_BS.ClientID%>").value = index;

        }
        //Newcode
        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }
        function RearrangingControlnames_BS() {

            var Controlnames = $("#<%=hdnControlNames_BS.ClientID %>").val();


            rightsArray = new Array();
            var dataArray = Controlnames.split("#");
            if (dataArray != null) {
                if (dataArray.length > 0) {

                    for (var i = 0, j = dataArray.length; i < j; i++) {
                        var data = dataArray[i];
                        subitemArray = data.split("|")
                        //Removes this condition while debugging
                        //                        if (subitemArray.length > 6) {
                        //                            subitemArray[6] = subitemArray[6].split(",");
                        //                        }
                        rightsArray.push(subitemArray);

                    }
                }
            }


        }



        function pageLoad() {

            var msgControl = "#<%= divMsg_BS.ClientID %>";
            var SearchCriteria = getParameterByName("Search");

            if (SearchCriteria != null && SearchCriteria.length > 0) {
                //if search critearea is not a advanced search, load data
                if (!(SearchCriteria.indexOf('AdvancedSearch') >= 0)) {
                    document.getElementById("<%=hdnSearchString_BS.ClientID %>").value = SearchCriteria;
                    loginOrgIdControlID = "<%= hdnLoginOrgId_BS.ClientID %>";
                    loginTokenControlID = "<%= hdnLoginToken_BS.ClientID %>";
                    pageIdContorlID = "<%= hdnPageId_BS.ClientID %>";
                    return CallPostScalar(msgControl, "SearchDocuments", SearchCriteria);
                }
            }
        }

        function GetDBMappingCol_BS(tmpDBCols, fieldName) {
            var DBMappingCol = "";
            for (var i = 0; i < tmpDBCols.length; i++) {
                tmpRows = tmpDBCols[i].split("|");
                if (fieldName == tmpRows[0]) {
                    DBMappingCol = tmpRows[1];
                    break;
                }
            }
            return DBMappingCol;
        }


        var WhereClause = "";
        function construct_SearchByIndexValue_Query_BS(DbField, IndexValue, SearchCondition) {

            WhereClause += " AND ( "; //( LEN('" + IndexValue + "') = 0 OR ";

            switch (SearchCondition.toUpperCase()) {
                case "ANYWHERE":
                    WhereClause += DbField + " like '%" + IndexValue + "%' ) ";
                    break;
                case "STARTS WITH":
                    WhereClause += DbField + " like '" + IndexValue + "%' ) ";
                    break;
                case "ENDS WITH":
                    WhereClause += DbField + " like '%" + IndexValue + "' ) ";
                    break;
                case "NOWHERE":
                    WhereClause += DbField + " not like '%" + IndexValue + "%' ) ";
                    break;
                case "WHOLE WORD":
                    WhereClause += DbField + " = '" + IndexValue + "' ) ";
                    break;
                case "SOUNDS LIKE":
                    WhereClause += "SOUNDEX(" + DbField + ") = SOUNDEX('" + IndexValue + "') ) ";
                    break;
                default:
                    break;

            }
        }
        function Redirect_D() {
            RedirectRequired = 'Yes' //DMS04-3406M
            SearchDocuments_BS();
        }
        function SearchDocuments_BS() {


            //clear previous search querystring data
            $("[id$=hdnSearchString]").val("");

            RearrangingControlnames_BS();
            var msgControl = "#<%= divMsg_BS.ClientID %>";

            var DocumentType = $("#<%= cmbDocumentType_BS.ClientID %>").val();
            var Department = $("#<%= cmbDepartment_BS.ClientID %>").val();
            var Refid = $("#<%= txtRefid_BS.ClientID %>").val();
            var Keywords = $("#<%= txtKeyword_BS.ClientID %>").val();
            var count = $("#<%=hdnCountControls_BS.ClientID %>").val();
            var archive = document.getElementById("<%=chkArchive_BS.ClientID %>").checked;
            var e = document.getElementById("<%=cmbMainTag_BS.ClientID %>");
            var MainTagID = e.options[e.selectedIndex].value;
            e = document.getElementById("<%=cmbSubTag_BS.ClientID %>");
            var SubTagID = e.options[e.selectedIndex].value;
            e = document.getElementById("<%=cmbSearchOption_BS.ClientID %>");
            var SearchOption = e.options[e.selectedIndex].value;
            var PageNo = document.getElementById("<%= hdnPageNo_BS.ClientID%>").value;
            var RowsPerPage = document.getElementById("<%= hdnRowsPerPage_BS.ClientID%>").value


            var check;
            if (archive == true) {
                check = 0;
            }
            else {
                check = 1;
            }



            var params = SearchOption + '|' + DocumentType + '|' + Department + '|' + Refid + '|' + Keywords + '|' + check + '|' + MainTagID + '|' + SubTagID + '|' + PageNo + '|' + RowsPerPage;

            //Loop through dynamic index controls and construct SQL where clause

            WhereClause = "";
            var arrayDBCols = document.getElementById("<%= hdnDBCOLMapping_BS.ClientID%>").value.split("$");



            var data = rightsArray[0];

            for (var i = 0; i < arrayDBCols.length; i++) {

                var controlname = data[i];


                //var controlname = 'ctl00_ContentPlaceHolder2_ContentPlaceHolder1_Search_NormalSearch_' + controlname;
                var controlname = 'ctl00_ContentPlaceHolder1_' + controlname.replace(/\s+/g, '');
                var fields = document.getElementById(controlname);
                try {

                    if (fields != null && fields.type == "text") {

                        var FieldValue = fields.value;
                        if (FieldValue == "") {

                            //Nothing
                        }
                        else {

                            // var DbField = GetDBMappingCol_BS(arrayDBCols, controlname.replace("ctl00_ContentPlaceHolder2_ContentPlaceHolder1_Search_NormalSearch_", ""));
                            var DbField = GetDBMappingCol_BS(arrayDBCols, controlname.replace("ctl00_ContentPlaceHolder1_", ""));

                            //Call method to construct query for SQL where condition from dynamic controls
                            construct_SearchByIndexValue_Query_BS(DbField, FieldValue, SearchOption);
                        }
                    }

                    else if (fields != null && fields.type == "select-one") {
                        if (fields.options[fields.selectedIndex].text == "--Select--") {
                            //Nothing
                        }
                        else {
                            // var DbField = GetDBMappingCol_BS(arrayDBCols, controlname.replace("ctl00_ContentPlaceHolder2_ContentPlaceHolder1_Search_NormalSearch_", ""));
                            var DbField = GetDBMappingCol_BS(arrayDBCols, controlname.replace("ctl00_ContentPlaceHolder1_", ""));
                            var FieldValue = fields.options[fields.selectedIndex].text;
                            //Call method to construct query for SQL where condition from dynamic controls
                            construct_SearchByIndexValue_Query_BS(DbField, FieldValue, SearchOption);
                        }
                    }
                }
                catch (ex) {
                }

            }

            // Append dynamic fields whereclause to data
            params += "|" + WhereClause;

            if (ValidateInputData_BS(msgControl, "SearchDocuments_BS")) {
                $("#divSearchResults_BS").html("");
                document.getElementById("<%=hdnSearchString.ClientID %>").value = params;
                if (RedirectRequired != 'Yes') { //DMS04-3406M
                    return CallPostScalar(msgControl, "SearchDocuments", params);
                }
                else {
                    RedirectRequired = 'No'; //DMS04-3406M
                    window.location.href = "DigitalSignature.aspx?Action=" + 'SearchDocuments' + '&parms=' + params;
                }
            }
        }

        //PDFDownload
        function ValidatePDFDropdown() {

            var msg = document.getElementById("<%= div_MesgDwn.ClientID %>");

            if (document.getElementById('<%=cmbDocumentType_BS_PDF.ClientID%>').selectedIndex == '0') {
                $(msg).html(GetAlertMessages("Please Select Project Type!"));
                Scrolltop();
                return false;

            }
            else if (document.getElementById('<%=cmbDepartment_BS_PDF.ClientID%>').selectedIndex == '0') {
                $(msg).html(GetAlertMessages("Please Select Department!"));
                Scrolltop();
                return false;
            }
        }
        //PDFDownload

        //Document Search
       
        //Document Search


        function ValidateInputData_BS(msgControl, action) {
            $(msgControl).html("");
            var retval = true;
            var DocumentType = $("#<%= cmbDocumentType_BS.ClientID %>").val();
            var Department = $("#<%= cmbDepartment_BS.ClientID %>").val();
        
         
            if (action == "SearchDocuments_BS") {
                if (document.getElementById("<%= cmbDocumentType_BS.ClientID  %>").value == 0) {
                   $(msgControl).html(GetAlertMessages("Please Select Project Type!"));
                    Scrolltop();
                    retval = false;
                }
                else if (document.getElementById("<%= cmbDepartment_BS.ClientID  %>").value == 0) {
                   $(msgControl).html(GetAlertMessages("Please Select Department!"));
                    Scrolltop();
                    retval = false;
                }

                return retval;
            }
        }


        function ValidateOCR() {
            var msgControl = "#<%= divMsg_OCR.ClientID %>";
            var cmbDocumentType_BS_PDF1 = $("#<%= cmbDocumentType_BS_PDF.ClientID %>").val();
            var Department = $("#<%= cmbDepartment_OCR.ClientID %>").val();
            if (cmbDocumentType_BS_PDF1 == 0) {
                $(msgControl).html(GetAlertMessages("Please Select Project Type!"));
                Scrolltop();
                return false;
            }
            else if (Department == 0) {
                $(msgControl).html(GetAlertMessages("Please Select Department!"));
                Scrolltop();
                return false;
            }


        }


        function LoadSub_BS(ID) {
            var e = document.getElementById(ID.id);
            var drop = e.options[e.selectedIndex].value;
            if (drop != "0" && drop != "<Select>") {
                var drpID = document.getElementById("<%=hdnSubDrpID_BS.ClientID %>");
                drpID.value = drop;
                (document.getElementById('<%=btnCommonSubmitSub_BS.ClientID%>')).click();
            }
            else {
                var seconddroplst = ID.id.substring(ID.id.length - 1, ID.id.length);
                var seconddroplast = ID.id.substring(0, ID.id.length - 1);
                // document.getElementById(seconddroplst + "drp_" + seconddroplast).options.length = 1;
            }
            return false;
        }

        function LoadSubTag_BS(ID) {
            var e = document.getElementById(ID.id);
            var drop = e.options[e.selectedIndex].value;
            if (drop != "0" && drop != "<Select>") {
                (document.getElementById('<%=btnCommonSubmitSub2_BS.ClientID%>')).click();
            }
            return false;
        }

        /* DMS04-3396 BS */
        function CheckSpace(evt) {
            var charCode = (evt.which) ? evt.which : event.keyCode
            if ((charCode == 32)) {

                return false;
            }
        }
        function ValidateSpaceInText() {
            var isvalidate = true
            if (document.getElementById("<%= cbxFullText.ClientID %>").checked == true) {
                var txtId = document.getElementById("<%= hdnSearchTextboxId.ClientID %>").value;
                var dataArray = txtId.split("|");
                if (dataArray != null) {
                    if (dataArray.length > 0) {

                        for (var i = 0, j = dataArray.length; i < j; i++) {
                            var data = dataArray[i];
                            var controlname = 'ctl00_ContentPlaceHolder1_' + data;
                            var Index = document.getElementById(controlname);
                            if (Index != null && Index.value.match(/\s/g)) {

                                isvalidate = false;
                            }
                        }

                    }

                }



            }
            return isvalidate;
        }

        /* DMS04-3396 BE */
        function Redirect(ProcessID, DocId, DepID, Active, PageNo, MainTagId, SubTagId, SlicingStatus, Watermark) {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var info = getAcrobatInfo();
            if (true) {//parseInt(info.acrobatVersion, 10) > 10) {
                if (SlicingStatus == 'Uploaded') {
                    window.location.href = "DocumentDownloadDetails.aspx?id=" + ProcessID + '&docid=' + DocId + '&depid=' + DepID + '&active=' + Active + '&PageNo=' + PageNo + '&MainTagId=' + MainTagId + '&SubTagId=' + SubTagId + '&Search=' + document.getElementById("<%=hdnSearchString.ClientID %>").value + '&Page=DocumentDownloadSearch' + '&Watermark=' + Watermark;
                }
                else {

                    $(msgControl).html("Kindly Wait For Few Minutes Document Activity is Pending!");
                    document.getElementById('<%=divMsg.ClientID%>').style.color = 'Red';
                    return false;
                }
            }
            else {
                var MsgAdobeDownload = '<%= ConfigurationManager.AppSettings["MsgAdobeDownload"].ToString() %>';
                var LinkAdobeDownload = '<%= ConfigurationManager.AppSettings["LinkAdobeDownload"].ToString() %>';
                var IsConfirm = window.confirm(MsgAdobeDownload);
                if (IsConfirm == true) {
                    window.open(LinkAdobeDownload);
                }
                return false;
            }
        }

        function UpdateTabcount(Count) {
            Tabcount = Count;
        }
        var Tabcount = 1
        function HandleTabCount() {

            if (Tabcount == 1) {
                document.getElementById("LIBASIC").className = "active";
                document.getElementById("LIADVAN").className = "";
                document.getElementById("LIOCR").className = "";
                document.getElementById("demo-tabs-box-1").className = "tab-pane fade in active";
                document.getElementById("demo-tabs-box-2").className = "tab-pane fade in";
                document.getElementById("demo-tabs-box-3").className = "tab-pane fade in";
            }
            else if (Tabcount == 2) {
                document.getElementById("LIBASIC").className = "";
                document.getElementById("LIADVAN").className = "active";
                document.getElementById("LIOCR").className = "";
                document.getElementById("demo-tabs-box-1").className = "tab-pane fade in";
                document.getElementById("demo-tabs-box-2").className = "tab-pane fade in active";
                document.getElementById("demo-tabs-box-3").className = "tab-pane fade in";
            }
            else if (Tabcount == 3) {
                document.getElementById("LIBASIC").className = "";
                document.getElementById("LIADVAN").className = "";
                document.getElementById("LIOCR").className = "active";
                document.getElementById("demo-tabs-box-1").className = "tab-pane fade in";
                document.getElementById("demo-tabs-box-2").className = "tab-pane fade in";
                document.getElementById("demo-tabs-box-3").className = "tab-pane fade in active";
            }
            else if (Tabcount == 4) {
                document.getElementById("LIBASIC").className = "";
                document.getElementById("LIADVAN").className = "";
                document.getElementById("LIOCR").className = "";
                document.getElementById("LITEMDOWNLOAD").className = "active";
                document.getElementById("demo-tabs-box-1").className = "tab-pane fade in";
                document.getElementById("demo-tabs-box-2").className = "tab-pane fade in";
                document.getElementById("demo-tabs-box-3").className = "tab-pane fade in";
                document.getElementById("demo-tabs-box-4").className = "tab-pane fade in active";
            }
        }




        //function Search_BS_onclick() {

        //}

function Search_BS_onclick() {

}

function Search_BS_onclick() {

}

function Search_BS_onclick() {

}

function Search_BS_onclick() {

}

function Search_BS_onclick() {

}

function Search_BS_onclick() {

}

    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Document Search</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Document Search</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1"   runat="server">
    <!--<asp:Label ID="lblCurrentPath" runat="server" CssClass="CurrentPath" Text="Home  &gt;  Document Download Search"></asp:Label>-->
    <div id="page-content">
        <div class="panel">
            <div class="panel-body">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="GVDiv">
                            <div class="panel panel-success">
                                <!--Panel heading-->
                                <div class="panel-heading">
                                    <div class="panel-control">
                                        <!--Nav tabs-->
                                        <ul class="nav nav-tabs">
                                            <li class="active" onclick="UpdateTabcount(1);" id="LIBASIC" style="visibility:visible"><a data-toggle="tab" href="#demo-tabs-box-1">Basic Search</a></li>
                                            <li id="LITEMDOWNLOAD" onclick="UpdateTabcount(4);" style="visibility:visible"><a data-toggle="tab" href="#demo-tabs-box-4">PDF Download</a></li>
                                        </ul>                                        
                                       <ul class="nav nav-tabs">
                                            <li ID="LIADVAN" onclick="UpdateTabcount(2);" style="visibility:hidden"><a data-toggle="tab" href="#demo-tabs-box-2">Advanced Search</a> </li>
                                            <li ID="LIOCR" onclick="UpdateTabcount(3);" style="visibility: hidden">
                                                <a data-toggle="tab" href="#demo-tabs-box-3">OCR Status</a> </li>
                                        </ul>
                                    </div>
                                    <h3 class="panel-title">
                                        Document Search</h3>
                                </div>
                                <!--Panel body-->
                                <div class="panel-body">
                                    <!--Tabs content-->
                                    <div class="tab-content">
                                        <div id="demo-tabs-box-1" class="tab-pane fade in active">
                                            
                                                    <asp:UpdatePanel ID="UpdatePanel2_BS" runat="server">
                                                        <ContentTemplate>
                                                            <div id="divMsg_BS" runat="server"  style="color: Red;">
                                                                &nbsp;</div>
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                    <div class="row">
                                                <div class="col-sm-3">
                                                    <div class="DivInlineBlock">
                                                        <asp:UpdatePanel ID="UpdatePanel1_BS" runat="server">
                                                            <ContentTemplate>
                                                              
                                                                <div class="form-group">
                                                                <asp:Label ID="Label3_BS" runat="server" CssClass="LabelStyle" Text="Project"></asp:Label>
                                                                    <asp:Label CssClass="MandratoryFieldMarkStyle" ForeColor="red" ID="lblPageDescription1_BS"
                                                                        runat="server" Text="*"></asp:Label>
                                                                    <asp:DropDownList ID="cmbDocumentType_BS" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbDocumentType_SelectedIndexChanged_BS"
                                                                        CssClass="form-control">
                                                                        <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    <asp:Label ID="Label5_BS" runat="server" CssClass="LabelStyle" Text="Department"></asp:Label>
                                                                    <asp:Label CssClass="MandratoryFieldMarkStyle" ID="Label1_BS" ForeColor="red" runat="server"
                                                                        Text="*"></asp:Label>
                                                                    <asp:DropDownList ID="cmbDepartment_BS" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbDepartment_SelectedIndexChanged_BS"
                                                                        CssClass="form-control">
                                                                        <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                     <div>
                                                                        <asp:UpdatePanel ID="Indexupdatepanel_BS" runat="server" >
                                                                            <ContentTemplate>
                                                                                <div class="table resposive">
                                                                                
                                                                                <asp:Panel ID="pnlIndexpro_BS" runat="server">
                                                                                </asp:Panel>
                                                                                </div>
                                                                                <asp:Button ID="btnCommonSubmitSub_BS" runat="server" Text="Button" OnClick="btnCommonSubmitSub_Click_BS"
                                                                                    CausesValidation="False" Style="display: none" />
                                                                                <asp:Button ID="btnCommonSubmitSub2_BS" runat="server" Text="Button" OnClick="btnCommonSubmitSub2_Click_BS"
                                                                                    CausesValidation="False" Style="display: none" />
                                                                            <!-- sample index pr-->
                                                                          <%--  <div class="table-responsive">

</div>--%>
																	<!-- End sample index pr-->
                                                                            </ContentTemplate>
                                                                            
                                                                            
                                                                        </asp:UpdatePanel>
                                                                       
                                                                    </div>
                                                                    <asp:Label ID="Label15_BS" runat="server" CssClass="LabelStyle" Text="Category"></asp:Label>
                                                                    <asp:DropDownList ID="cmbMainTag_BS" runat="server" CssClass="form-control" AutoPostBack="false">
                                                                        <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    <asp:Label ID="Label16_BS" style="display:none" runat="server" CssClass="LabelStyle" Text="Subcategory"></asp:Label>
                                                                    <asp:DropDownList ID="cmbSubTag_BS" style="display:none" runat="server" CssClass="form-control" AutoPostBack="false">
                                                                        <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    <asp:Label ID="lblSearchType_BS" runat="server" CssClass="LabelStyle" Text="Search Option"></asp:Label>
                                                                    <asp:DropDownList ID="cmbSearchOption_BS" runat="server" CssClass="form-control"
                                                                        AutoPostBack="false">
                                                                        <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    
                                                                    <asp:Label ID="Label9_BS"  runat="server" CssClass="LabelStyle" Text="Ref ID"></asp:Label>
                                                                    <asp:TextBox ID="txtRefid_BS"  runat="server"  CssClass="form-control" Style="margin-left: 0px;"></asp:TextBox>
                                                                    <asp:Label ID="Label12_BS" runat="server"  CssClass="LabelStyle" Style="display:none;" Text="Keywords "></asp:Label>
                                                                    <asp:TextBox ID="txtKeyword_BS" runat="server"  CssClass="form-control" Style="margin-left: 0px;display:none;"></asp:TextBox>
                                                                   
                                                 
                                                                    <asp:Label ID="lblIndexProprties_BS" runat="server"  CssClass="LabelStyle" Text=""></asp:Label>
                                                                   
                                                                    <asp:Label ID="lblArchive_BS" runat="server" CssClass="LabelStyle" style="display:none" Text="Include deleted documents"></asp:Label>
                                                                    <asp:CheckBox ID="chkArchive_BS" CssClass="LabelStyle" runat="server" style="display:none" TagName="Read" /><br />
                                                                    <div class="row">
                                                                        <div class="col-md-6">
                                                                            <i class="fa fa-search btn-labeled green btn btn-primary white ">
                                                                                <input type="button" id="Search_BS" value="Search" class="btn btn-primary" onclick="OnPagingIndexClick_BS(1);" /></i>
                                                                                  
                                                                                   
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <i class="fa fa-sign-in  btn-labeled white btn btn-success " style="display:none">
                                                                                <input type="button" id="btnDigtialSignature" value="Digital Signature" class="btn success" style="display:none"
                                                                                    onclick="Redirect_D();" tagname="Read" /></i>
                                                                        </div>
                                                                    </div>
                                                                    <asp:HiddenField ID="hdnLoginOrgId_BS" runat="server" Value="" />
                                                                    <asp:HiddenField ID="hdnLoginToken_BS" runat="server" Value="" />
                                                                    <asp:HiddenField ID="hdnPageId_BS" runat="server" Value="" />
                                                                    <asp:HiddenField ID="hdnAction_BS" runat="server" Value="" />
                                                                    <asp:HiddenField ID="hdnCountControls_BS" runat="server" Value="" />
                                                                    <asp:HiddenField ID="hdnSearchString_BS" runat="server" Value="" />
                                                                    <asp:HiddenField ID="hdnDBCOLMapping_BS" runat="server" Value="" />
                                                                    <asp:UpdatePanel ID="UpdatePanel8_BS" runat="server">
                                                                        <ContentTemplate>
                                                                            <asp:HiddenField ID="hdnIndexNames_BS" runat="server" Value="" />
                                                                            <asp:HiddenField ID="hdnIndexMinLen_BS" runat="server" Value="" />
                                                                            <asp:HiddenField ID="hdnIndexType_BS" runat="server" Value="" />
                                                                            <asp:HiddenField ID="hdnIndexDataType_BS" runat="server" Value="" />
                                                                            <asp:HiddenField ID="hdnSubDrpID_BS" runat="server" Value="" />
                                                                            <asp:HiddenField ID="hdnControlNames_BS" runat="server" Value="" />
                                                                        </ContentTemplate>
                                                                    </asp:UpdatePanel>
                                                                </div>
                                                            </ContentTemplate>
                                                        </asp:UpdatePanel>
                                                        <asp:HiddenField ID="hdnDynamicControlIndexChange_BS" runat="server" Value="0" />
                                                    </div>
                                                    
                                                </div>
                                                <div class="col-sm-8 pull-right" >
                                                    <!-- right side -->
                                                    <div class="DivInlineBlock">
                                                        <div id="divRecordCountText_BS" style="color: green; visibility: hidden;">
                                                        </div>
                                                        <div id="paging_BS" style="visibility: hidden;">
                                                            <a>Rows per page
                                                                <select id="RowsPerPage_BS" runat="server" style="width: 50px" onchange="OnPagingIndexClick_BS(1);">
                                                                    <option>5</option>
                                                                    <option selected="selected">10</option>
                                                                    <option>25</option>
                                                                    <option>50</option>
                                                                    <option>100</option>
                                                                </select>
                                                                Current Page
                                                                <select id="CurrentPage_BS" runat="server" style="width: 50px" onchange="OnPageIndexChange_BS();">
                                                                </select>
                                                                of
                                                                <asp:Label ID="TotalPages_BS" runat="server" CssClass="LabelStyle"></asp:Label>
                                                                <asp:HiddenField ID="hdnPageNo_BS" Value="1" runat="server" />
                                                                <asp:HiddenField ID="hdnSortColumn_BS" Value="ASC" runat="server" />
                                                                <asp:HiddenField ID="hdnSortOrder_BS" runat="server" />
                                                                <asp:HiddenField ID="hdnTotalRowCount_BS" runat="server" />
                                                                <asp:HiddenField ID="hdnRowsPerPage_BS" Value="10" runat="server" />
                                                                <asp:Button ID="btnFilterRow_BS" runat="server" Height="25px" class="HiddenButton"
                                                                    Text="&lt;&lt; Remove" OnClientClick="createPagingIndexes_BS(); return false;"
                                                                    TagName="Read" />
                                                            </a>
                                                        </div>
                                                    </div>
                                                    <br/>
                                                    <div id="divPagingText_BS">
                                                    </div>
                                                 
                                                   
                                                    <div class="table-responsive" style="height:500px;"  >
                                                        <div id="divSearchResults_BS">
                                                        </div>
                                                    </div>
                                                   
                                                    
                                                    <!-- sample index proper -->
                                                    <!-- sample end-->
                                                    
                                                </div>
                                                <!-- right side end -->
                                            </div>
                                        </div>
                                        <div id="demo-tabs-box-2" class="tab-pane fade in">
                                        <asp:Label ID="lblMsg" ForeColor="Red" runat="server"></asp:Label>
                                            <div class="row">
                                                
                                                    <div id="divResultMsg">
                                                    </div>
                                                    <div id="divMsg" runat="server" style="color: red;">
                                                    </div>

                                                    <div class="form-group">
                                                        
                                                    </div>
                                                    
                                                <div class="clearfix">
                                                </div>
                                                    <div class="row form-group">
                                                        <div class="col-md-2">
                                                        
                                                        <asp:Label ID="Label3" runat="server" CssClass="LabelStyle" Text="Project Type"></asp:Label>
                                                        &nbsp;<asp:Label CssClass="MandratoryFieldMarkStyle" ID="lblPageDescription1" runat="server"
                                                            Text="*" ForeColor="red"></asp:Label>
                                                            </div>
                                                        <div class="col-md-3">
                                                        
                                                        <asp:DropDownList ID="cmbDocumentType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbDocumentType_SelectedIndexChanged"
                                                            CssClass="form-control">
                                                            <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                        </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                    <div class="row form-group">
                                                        <div class="col-md-2">
                                                        
                                                        <asp:Label ID="Label5" runat="server" CssClass="LabelStyle" Text="Department"></asp:Label>
                                                        <asp:Label CssClass="MandratoryFieldMarkStyle" ID="Label1" runat="server" Text="*"
                                                            ForeColor="red"></asp:Label>
                                                            </div>
                                                        <div class="col-md-3">
                                                        
                                                        <asp:DropDownList ID="cmbDepartment" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbDepartment_SelectedIndexChanged"
                                                            CssClass="form-control">
                                                            <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                        </asp:DropDownList>
                                                        </div>
                                                    </div>
                                                    <div class="row form-group">
                                                        <asp:Panel ID="pnlQuery" runat="server">
                                                            
                                                            <div class="col-md-2">
                                                             <asp:Label ID="lblQuery" runat="server" CssClass="LabelStyle" Text="Query"></asp:Label>
                                                            </div>
                                                            <div class="col-md-3">
                                                           
                                                            <asp:DropDownList ID="dropQueries" runat="server" AutoPostBack="True" OnSelectedIndexChanged="dropQueries_SelectedIndexChanged"
                                                                CssClass="form-control">
                                                                <asp:ListItem Value="0">--Select--</asp:ListItem>
                                                            </asp:DropDownList>
                                                            </div>
                                                            <div class="col-md-2">
                                                           <%-- <asp:Label ID="lblQuery1" runat="server" CssClass="LabelStyle" Text="&nbsp;&nbsp;&nbsp;&nbsp;"></asp:Label>--%>
                                                            <i class="fa fa-trash btn-style white btn-danger">
                                                                <asp:Button ID="btnDeleteQuery" runat="server" class="clearbutton" Width="100px"
                                                                    OnClientClick="return confirm('Are you sure you want to delete selected query?')"
                                                                    meta:resourcekey="btnDeleteQuery" CssClass="btn btn-danger" OnClick="DeleteQuery"
                                                                    Text="Delete Query" /></i>
                                                                    </div>
                                                           <br/>
                                                            <div class="clearfix">
                                                            </div>
                                                            <div class="row form-group">
                                                                <div class="col-md-4">
                                                                
                                                            <asp:Label ID="Label4" runat="server" CssClass="LabelStyle" Text="Enable Full Text"></asp:Label>
                                                            <asp:CheckBox ID="cbxFullText" runat="server" OnCheckedChanged="AddQuery" AutoPostBack="True" />
                                                            </div>
                                                            <asp:Button Text="Edit Query" class="" runat="server" ID="EditQueryButton" CssClass="fa fa-pencil-square-o btn-labeled btn btn-danger"
                                                                OnClick="EditQuery" Visible="False" />
                                                            <asp:Label ID="lblError" ForeColor="Red" EnableViewState="False" runat="server" />
                                                            
                                                            </div>
                                                            <asp:Panel ID="Results" runat="server">

                                                                <asp:Literal ID="Literal1" runat="server" meta:resourcekey="Results" /></h1>
                                                            </asp:Panel>
                                                        </asp:Panel>
                                                    </div>
                                                    <div class="row form-group">
                                                        <asp:Panel ID="pnlIndexDropdown" runat="server">
                                                            <div class="col-md-2">
                                                            
                                                            <asp:Label ID="lblIndexProprties" runat="server" CssClass="LabelStyle" Text="Search Criteria"></asp:Label>
                                                            </div>
                                                            <div class="clearfix">
                                                            </div>
                                                            <asp:Panel ID="pnlIndexpro" runat="server">
                                                                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                                                    <ContentTemplate>
                                                                        <asp:PlaceHolder ID="plhClauses" runat="Server" />
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                                <div class="row form-group">
                                                                
                                                                <div class="col-md-2">
                                                                <i class="fa fa-plus btn-style white btn-primary">
                                                                    <asp:Button ID="btnAddClause" Text="Add Clause" meta:resourcekey="btnAddClause" class="btnadd"
                                                                         runat="server" OnClick="btnAddClauseClick" CssClass="btn btn-primary"
                                                                        OnClientClick="return SetPageIndex(1);" /></i>
                                                                </div>
                                                                <div class="col-md-2">
                                                                <i class="fa fa-minus btn-style white btn-primary">
                                                                            <asp:Button ID="btnRemoveClause" Text="Remove Clause" class="removebutton" meta:resourcekey="btnRemoveClause"
                                                                                 runat="server" OnClick="btnRemoveClauseClick" CssClass="btn btn-primary"
                                                                                OnClientClick="return SetPageIndex(1);" /></i>
                                                                </div>
                                                                </div>
                                                                <div class="row form-group">
                                                                    
                                                                    
                                                                <asp:Panel ID="SaveQuery" runat="server">
                                                                <div class="col-md-2">
                                                                    <asp:Label ID="Label2" runat="server" Text="Query Name" CssClass="LabelStyle" AssociatedControlID="txtQueryName" />
                                                                    </div>
                                                                    <div class="col-md-3">
                                                                    <asp:TextBox ID="txtQueryName" runat="server" CssClass="form-control" />
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                    <i class="fa fa-floppy-o btn-style white btn-primary ">
                                                                        <asp:Button ID="btnSaveQuery" runat="server" class="btnsave" CssClass="btn btn-primary"
                                                                            meta:resourcekey="btnSaveQuery" Width="100px" OnClick="btnSaveQueryClick" Text="Save Query" /></i>
                                                                            </div>
                                                                    <div class="clearfix">
                                                                    </div>
                                                                    <div class="col-md-2">
                                                                    
                                                                    <asp:Label ID="Label7" runat="server" CssClass="LabelStyle" Text="Public Query:"
                                                                        meta:resourcekey="chkGlobalQuery" AssociatedControlID="chkGlobalQuery" />
                                                                    <asp:CheckBox ID="chkGlobalQuery" runat="server" />
                                                                    </div>
                                                                </asp:Panel>
                                                                </div>
                                                                <br/>
                                                                <asp:Button ID="btnPerformQuery" Text="Search" meta:resourcekey="btnPerformQuery"
                                                                    class="btnsearch" runat="server" OnClick="btnPerformQueryClick" Visible="False" />
                                                            </asp:Panel>
                                                            <asp:Button ID="btnCommonSubmitSub" runat="server" Text="Button" CausesValidation="False"
                                                                Style="visibility: hidden" />
                                                        </asp:Panel>
                                                        <div class="row">
                                                        <!-- new -->
                                                        <div class="col-md-2">
                                                                <i class="fa fa-eraser btn-style white btn-success">
                                                                    <asp:Button ID="btnAddQuery" runat="server" class="btnadd" meta:resourcekey="btnAddQuery"
                                                                         OnClick="AddQuery" CssClass="btn btn-success" Text="New / Clear"
                                                                        ToolTip="New or clear query" OnClientClick="return SetPageIndex(1);" /></i>
                                                                </div>
                                                        <div class="col-md-2">
                                                                <i class="fa fa-search btn-style btn-primary white">
                                                                                    <asp:Button ID="btnSearch" runat="server" class="btnsearch" CssClass="btn btn-primary"
                                                                                        OnClick="btnPerformQueryClick"  OnClientClick="return ValidateInputData();"
                                                                                        Text="Search" /></i>
                                                                </div>
                                                        </div>
                                                    </div>
                                                    
                                                <div class="clearfix">
                                                </div>
                                                    <div id="divRecordCountText" runat="server">
                                                    </div>
                                               
                                                <!-- right side -->
                                                <div class="row" >
                                                    <div id="paging" runat="server" style="visibility: hidden;">
                                                        <a>Rows per page
                                                            <select id="RowsPerPage" runat="server" class="input-mini" onchange="OnPagingIndexClick(1);"
                                                                style="width: 50px;">
                                                                <option>5</option>
                                                                <option selected="selected">10</option>
                                                                <option>25</option>
                                                                <option>50</option>
                                                                <option>100</option>
                                                            </select>
                                                            Current Page
                                                            <select id="CurrentPage" runat="server" class="input-mini" onchange="OnPageIndexChange();"
                                                                style="width: 50px;">
                                                            </select>
                                                            of
                                                            <asp:Label ID="TotalPages" runat="server" CssClass="LabelStyle"></asp:Label>
                                                            <asp:HiddenField ID="hdnPageNo" Value="1" runat="server" />
                                                            <asp:HiddenField ID="hdnSortColumn" Value="ASC" runat="server" />
                                                            <asp:HiddenField ID="hdnSortOrder" runat="server" />
                                                            <asp:HiddenField ID="hdnTotalRowCount" runat="server" />
                                                            <asp:HiddenField ID="hdnRowsPerPage" Value="10" runat="server" />
                                                            <asp:Button ID="btnFilterRow" runat="server" Height="25px" class="HiddenButton" Text="&lt;&lt; Remove"
                                                                TagName="Read" />
                                                        </a>
                                                    </div>
                                                    <div id="divSearchResultsOuter">
                                                        <div class="table-responsive">
                                                            <div id="divSearchResults" runat="server">
                                                                
                                                            </div>
                                                            
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="col-md-6">
                                                            <div id="divPagingText" runat="server">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="col-md-6">
                                                            <asp:Button ID="btnSearchAgain" runat="server" Text="SearchAgain" class="HiddenButton"
                                                                OnClick="btnSearchAgain_Click" />
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="col-md-6">
                                                            <asp:HiddenField ID="hdnUCControlValues" runat="server" />
                                                            <asp:HiddenField ID="hdnUCControlNames" runat="server" />
                                                        </div>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <div class="col-md-6">
                                                            <br />
                                                            <asp:HiddenField ID="hdnLoginOrgId" runat="server" />
                                                            <asp:HiddenField ID="hdnLoginToken" runat="server" />
                                                            <asp:HiddenField ID="hdnPageId" runat="server" />
                                                            <asp:HiddenField ID="hdnAction" runat="server" />
                                                            <asp:HiddenField ID="hdnSearchString" runat="server" />
                                                            <asp:HiddenField ID="hdnDBCOLMapping" runat="server" />
                                                            <asp:HiddenField ID="hdnIndexNames" runat="server" />
                                                            <asp:HiddenField ID="hdnIndexMinLen" runat="server" />
                                                            <asp:HiddenField ID="hdnIndexType" runat="server" />
                                                            <asp:HiddenField ID="hdnIndexDataType" runat="server" />
                                                            <asp:HiddenField ID="hdnSubDrpID" runat="server" />
                                                            <asp:HiddenField ID="hdnSearchTextboxId" runat="server" />
                                                        </div>
                                                    </div>
                                                    <asp:HiddenField ID="hdnDynamicControlIndexChange" runat="server" Value="0" />
                                                </div>
                                            </div>
                                            <!-- row end -->
                                        </div>
                                        <div id="demo-tabs-box-3" class="tab-pane fade">
                                           <asp:UpdatePanel ID="UpdatePanel2_OCR" runat="server">
                                                <ContentTemplate>
                                                    <div id="divMsg_OCR" runat="server" style="color: Red">
                                                        &nbsp;</div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                           <div class="row">
                                           		<div class="col-md-3">
                                                <asp:UpdatePanel ID="UpdatePanel1_OCR" runat="server" aria-expanded="false">
                                                    <ContentTemplate>
                                                        <div class="form-group">
                                                           
                                                                <asp:Label ID="Label3_OCR" runat="server" CssClass="LabelStyle" Text="Project Type"></asp:Label>
                                                                <asp:Label CssClass="MandratoryFieldMarkStyle" ID="lblPageDescription1_OCR" runat="server"
                                                                    Text="*" ForeColor="red"></asp:Label>
                                                           
                                                                <asp:DropDownList ID="cmbDocumentType_OCR" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbDocumentType_SelectedIndexChanged_BS"
                                                                    CssClass="form-control">
                                                                    <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                </asp:DropDownList>
                                                           
                                                        </div>
                                                       
                                                        <div class="form-group">
                                                           
                                                                <asp:Label ID="Label5_OCR" runat="server" CssClass="LabelStyle" Text="Department"></asp:Label>
                                                                <asp:Label CssClass="MandratoryFieldMarkStyle" ID="Label1_OCR" runat="server" Text="*"
                                                                    ForeColor="red"></asp:Label>
                                                           
                                                                <asp:DropDownList ID="cmbDepartment_OCR" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbDepartment_SelectedIndexChanged_BS"
                                                                    CssClass="form-control">
                                                                    <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                </asp:DropDownList>
                                                          
                                                        </div>
                                                        
                                                        <div class="form-group" >
                                                            
                                                                <asp:Label ID="Label9_OCR" runat="server" CssClass="LabelStyle" Visible="false" Text="Ref ID"></asp:Label>
                                                            
                                                                <asp:TextBox ID="txtRefid_OCR" runat="server" CssClass="form-control"   Visible="false" Style="margin-left: 0px;"></asp:TextBox>
                                                           
                                                        </div>
                                                      
                                                        <div class="form-group">
                                                           
                                                                <asp:Label ID="Label12_OCR" runat="server" CssClass="LabelStyle" Text="Keywords "></asp:Label>
                                                           
                                                                <asp:TextBox ID="txtKeyword_OCR" runat="server" CssClass="form-control" Style="margin-left: 0px;"></asp:TextBox>
                                                            
                                                        </div>
                                                        
                                                        <div class="form-group">
                                                           
                                                                <asp:Label ID="Label15_OCR" runat="server" CssClass="LabelStyle" Text="Main Tags"></asp:Label>
                                                            
                                                                <asp:DropDownList ID="cmbMainTag_OCR" runat="server" CssClass="form-control" AutoPostBack="false">
                                                                    <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                </asp:DropDownList>
                                                            
                                                        </div>
                                                       
                                                        <div class="form-group">
                                                           
                                                                <asp:Label ID="Label16_OCR" runat="server" CssClass="LabelStyle" Text="Sub Tags"></asp:Label>
                                                           
                                                                <asp:DropDownList ID="cmbSubTag_OCR" runat="server" CssClass="form-control" AutoPostBack="false">
                                                                    <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                </asp:DropDownList>
                                                           
                                                        </div>
                                                        
                                                        <div class="form-group">
                                                           
                                                                <asp:Label ID="lblSearchType_OCR" runat="server" CssClass="LabelStyle" Text="Search Option"></asp:Label>
                                                            
                                                                <asp:DropDownList ID="cmbSearchOption_OCR" runat="server" CssClass="form-control"
                                                                    AutoPostBack="false">
                                                                    <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                </asp:DropDownList>
                                                           
                                                        </div>
                                                       
                                                        <div class="form-group">
                                                           
                                                                <asp:Label ID="lblIndexProprties_OCR" runat="server" CssClass="LabelStyle" Text="Index Properties"></asp:Label>
                                                           
                                                       
                                                       
                                                       
                                                                <asp:UpdatePanel ID="Indexupdatepanel_OCR" runat="server" >
                                                                    <ContentTemplate>
                                                                        <asp:Panel ID="pnlIndexpro_OCR" runat="server" >
                                                                        </asp:Panel>
                                                                        <asp:Button ID="btnCommonSubmitSub_OCR" runat="server" Text="Button" OnClick="btnCommonSubmitSub_Click_BS"
                                                                            CausesValidation="False" Style="visibility: hidden" />
                                                                        <asp:Button ID="btnCommonSubmitSub2_OCR" runat="server" Text="Button" OnClick="btnCommonSubmitSub2_Click_BS"
                                                                            CausesValidation="False" Style="visibility: hidden" />
                                                                    </ContentTemplate>
                                                                </asp:UpdatePanel>
                                                              
                                                            
                                                        </div>
                                                        
                                                       
                                                       <div class="form-group">
                                                            
                                                                <asp:Label ID="lblArchive_OCR" runat="server" CssClass="LabelStyle" Text="Include deleted documents"></asp:Label>
                                                           
                                                                <asp:CheckBox ID="chkArchive_OCR" CssClass="LabelStyle" runat="server" TagName="Read" />
                                                           
                                                              
                                                                <i class="fa fa-search btn-labeled btn btn-primary white">
                                                                    <asp:Button ID="btnSearchOCR" runat="server" class="btnsearch" CssClass="btn btn-primary"
                                                                        OnClick="btnPerformQueryClick" OnClientClick="return ValidateOCR();" Text="Search" /></i>
                                                                <i class="fa fa-sign-in btn-labeled white btn btn-success" style="display:none">
                                                                    <input type="button" id="Button1" value="Digital Signature" class="btn success" onclick="Redirect_D();" style="display:none"
                                                                        tagname="Read" /></i>
                                                           
                                                        </div>
                                                        
                                                      
                                                        <%--    <asp:HiddenField ID="HiddenField1" runat="server" Value="" />
                                                    <asp:HiddenField ID="HiddenField2" runat="server" Value="" />
                                                    <asp:HiddenField ID="HiddenField3" runat="server" Value="" />
                                                    <asp:HiddenField ID="HiddenField4" runat="server" Value="" />
                                                    <asp:HiddenField ID="HiddenField5" runat="server" Value="" />
                                                    <asp:HiddenField ID="HiddenField6" runat="server" Value="" />
                                                    <asp:HiddenField ID="HiddenField7" runat="server" Value="" />
                                                   <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                                                        <ContentTemplate>
                                                            <asp:HiddenField ID="HiddenField8" runat="server" Value="" />
                                                            <asp:HiddenField ID="HiddenField9" runat="server" Value="" />
                                                            <asp:HiddenField ID="HiddenField10" runat="server" Value="" />
                                                            <asp:HiddenField ID="HiddenField11" runat="server" Value="" />
                                                            <asp:HiddenField ID="HiddenField12" runat="server" Value="" />
                                                            <asp:HiddenField ID="HiddenField13" runat="server" Value="" />
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>--%>
                                                </ContentTemplate>
                                                </asp:UpdatePanel>
                                            
                                            	<asp:HiddenField ID="hdnDynamicControlIndexChange_OCR" runat="server" Value="0" />
                                                </div>
                                            <!-- right side -->
                                            <div class="col-md-8 pull-right">
                                                <div  runat="server" id="OCRGridContents">
                                                    <div class="generalBox">
                                                        
                                                                <div id="DivRecordsOCR">
                                                                    <center>
                                                                        <div id="divRecordCountText_OCR" runat="server" style="width: 550px; overflow: auto;">
                                                                            &nbsp;</div>
                                                                    </center>
                                                              
                                                        </div>
                                                        
                                                                <div id="paging_OCR" runat="server" style="visibility: hidden;">
                                                                    <a>Rows per page
                                                                        <select id="RowsPerPage_OCR" runat="server" style="width: 50px" onchange="OnPagingIndexClick(1);">
                                                                            <option>5</option>
                                                                            <option selected="selected">10</option>
                                                                            <option>25</option>
                                                                            <option>50</option>
                                                                            <option>100</option>
                                                                        </select>
                                                                        Current Page
                                                                        <select id="CurrentPage_OCR" runat="server" style="width: 50px" class="input-mini"
                                                                            onchange="OnPageIndexChange();">
                                                                        </select>
                                                                        of
                                                                        <asp:Label ID="TotalPages_OCR" runat="server" CssClass="LabelStyle"></asp:Label>
                                                                        <asp:HiddenField ID="hdnPageNo_OCR" Value="1" runat="server" />
                                                                        <asp:HiddenField ID="hdnSortColumn_OCR" Value="ASC" runat="server" />
                                                                        <asp:HiddenField ID="hdnSortOrder_OCR" runat="server" />
                                                                        <asp:HiddenField ID="hdnTotalRowCount_OCR" runat="server" />
                                                                        <asp:HiddenField ID="hdnRowsPerPage_OCR" Value="10" runat="server" />
                                                                        <asp:Button ID="btnFilterRow_OCR" runat="server" Height="25px" class="HiddenButton"
                                                                            Text="&lt;&lt; Remove" TagName="Read" />
                                                                    </a>
                                                                </div>
                                                                
                                                                <div class="table-responsive">
                                                                <asp:GridView ID="GridOCR" runat="server" CssClass="table table-striped table-bordered"
                                                                        PagerStyle-CssClass="pgr" OnRowDataBound="GridOCR_RowDataBound" AlternatingRowStyle-CssClass="alt"
                                                                        EmptyDataText="No records are found" >
                                                                        <Columns>
                                                                            <asp:TemplateField HeaderText="View">
                                                                                <ItemTemplate>
                                                                                    <asp:ImageButton ID="imgOCRView" ImageUrl="../../Assets/Skin/Images/view.png" runat="server"
                                                                                        OnClick="OCRView" />
                                                                                </ItemTemplate>
                                                                            </asp:TemplateField>
                                                                        </Columns>
                                                                        <PagerStyle CssClass="pagination-ys" />
                                                                    </asp:GridView>
                                                                </div>
                                                                    <!--<div id="divSearchResults_OCR" runat="server">
                                                        &nbsp;</div>-->
                                                               
                                                        
                                                        <div class="col-md-6">
                                                            <div class="col-md-6">
                                                                <div id="divPagingText_OCR" runat="server">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                             <!-- end right side-->
                                            </div>
                                        </div>


                                              <!--Search-->
                                              <div id="demo-tabs-box-4" class="tab-pane fade">
                                                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                                <ContentTemplate>
                                                    <div id="div_MesgDwn" runat="server" style="color: Red">
                                                        &nbsp;</div>
                                                </ContentTemplate>
                                                

                                            </asp:UpdatePanel>
                                            <div class="row">
                                            <div class="col-md-3">
                                            <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                                            <Triggers>
                                                <asp:PostBackTrigger ControlID="download" />
                                            </Triggers>
                                            <ContentTemplate>
                                               <div class="form-group" style="margin-left: 40px">
                                                    <asp:Label ID="lblProject" runat="server" CssClass="LabelStyle" Text="Project"></asp:Label>
                                                                    <asp:Label CssClass="MandratoryFieldMarkStyle" ForeColor="red" ID="lblProjectMandratory_BS"
                                                                        runat="server" Text="*"></asp:Label>
                                                                    <asp:DropDownList ID="cmbDocumentType_BS_PDF" runat="server" AutoPostBack="True"
                                                                        CssClass="form-control" 
                                                        onselectedindexchanged="cmbDocumentType_SelectedIndexChanged_BS_PDF">
                                                                        <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                     <asp:Label ID="Label6" runat="server" CssClass="LabelStyle" Text="Department"></asp:Label>
                                                                    <asp:Label CssClass="MandratoryFieldMarkStyle" ID="Label9" ForeColor="red" runat="server"
                                                                        Text="*"></asp:Label>
                                                                    <asp:DropDownList ID="cmbDepartment_BS_PDF" runat="server" AutoPostBack="True" OnSelectedIndexChanged="cmbDepartment_SelectedIndexChanged_BS_PDF"
                                                                        CssClass="form-control">
                                                                        <asp:ListItem Value="0">&lt;Select&gt;</asp:ListItem>
                                                                    </asp:DropDownList>
                                                                    <asp:Label ID="Label8" runat="server" CssClass="LabelStyle" Text="Category"></asp:Label>
                                                                    <asp:DropDownList ID="cmbMainTag_BS_PDF" runat="server" CssClass="form-control" AutoPostBack="false">
                                                                        <asp:ListItem Value="0">&lt;All&gt;</asp:ListItem>
                                                                    </asp:DropDownList>

                                                                    <div>
                                                                        <asp:UpdatePanel ID="UpdatePanel5" runat="server" >
                                                                            <ContentTemplate>
                                                                                <div class="table resposive">
                                                                                
                                                                                <asp:Panel ID="Panel1" runat="server">
                                                                                </asp:Panel>
                                                                                </div>
                                                                                <asp:Button ID="download" runat="server" class="btnsearch" CssClass="btn btn-primary"
                                                                        OnClick="btnDownloadClick" Text="Tag download" OnClientClick="return ValidatePDFDropdown()" />
                                                                            <!-- sample index pr-->
                                                                          <%--  <div class="table-responsive">

</div>--%>
																	<!-- End sample index pr-->
                                                                            </ContentTemplate>
                                                                            
                                                                            
                                                                        </asp:UpdatePanel>
                                                                       
                                                                    </div>

                                                                    
                                              </div>
                                              
                                                        
                                            </ContentTemplate>
                                            </asp:UpdatePanel>
                                            </div>
                                            </div>
                                              </div>
                                            <!--Search-->

                                                                          
                                    </div>
                                </div>
                            </div>
                        </div>
                        <asp:HiddenField ID="hdnPageRights" Value="10" runat="server" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
</asp:Content>
