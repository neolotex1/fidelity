﻿<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="ManageTemplate.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.ManageTemplate"
    EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Templates</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">Templates</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" language="javascript">
        var rightsArray = new Array();
        var objid = 0;
        var rightsIdentity = 0;
        var editArray = new Array();
        var edit = "required";
        var SelectedRowId = "";
        var rowcount = 0;
        var lastrowid = "";
        var SortOrder = 0;
        var ManageOrder = "";
        var HasChild = 0;
    </script>
    <script language="javascript" type="text/javascript">

        $(document).ready(function () {
            loginOrgIdControlID = "<%= hdnLoginOrgId.ClientID %>";
            loginTokenControlID = "<%= hdnLoginToken.ClientID %>";
            pageIdContorlID = "<%= hdnPageId.ClientID %>";
            pageRightsContorlId = "<%= hdnPageRights.ClientID %>";
            btnSubmitControlID = "<%= btnClearAll.ClientID %>";


            document.getElementById("<%= lstDataType.ClientID %>").disabled = true;
            document.getElementById("<%= txtMinLength.ClientID %>").disabled = true;
            document.getElementById("<%= txtMaxLength.ClientID %>").disabled = true;
            document.getElementById("<%= lstValue.ClientID %>").disabled = true;
            document.getElementById("<%= ListValueSub.ClientID %>").disabled = true;
            document.getElementById("<%= txtValue1.ClientID %>").disabled = true;
            document.getElementById("<%= btnAdd.ClientID %>").disabled = true;
            document.getElementById("<%= btnAdd0.ClientID %>").disabled = true;
            document.getElementById("<%= txtSubValue.ClientID %>").disabled = true;
            document.getElementById("<%= btnAddSub.ClientID %>").disabled = true;
            document.getElementById("<%= btnRemoveSub.ClientID %>").disabled = true;

        });

        ///function to deode the values 
        function DecodeXML(EncodedValues) {

            var Decodedv = Encoder.htmlDecode(EncodedValues);

            Decodedv = Decodedv.replace(/\s+/g, '');
            return Decodedv;

        }

        //DMS5-4343 BS
        function Scrolltop() {
            $("html, body").animate({ scrollTop: 0 }, 600);
            //$("[id$=divMsg]").show("slow").delay(3000).hide("slow");
        }
        //DMS5-4343 BE

        function Submit() {
            var msgControl = "#<%= divMsg.ClientID %>"; 
            var action = $("#<%= hdnAction.ClientID %>").val();
            var templateName = $("#<%= txtTemplateName.ClientID %>").val();
            var currentTemplateId = $("#<%= hdnCurrentTemplateId.ClientID %>").val();
            var Seperator = document.getElementById("<%= cmbSeperator.ClientID %>");
            var Active = document.getElementById("<%= ChkindexActive.ClientID %>").checked;
            var isActive = false;
            if (action == "EditTemplate") {
                var display = confirm("Already documents may be uploaded using this template, which may get affected. Do you wish to continue?");
                if (display == true) {
                    if ($("#<%= chkActive.ClientID %>").is(':checked')) isActive = true;
                    var SeperatorSymbol = Seperator.options[Seperator.selectedIndex].text;
                    if (SeperatorSymbol == '--select--') {
                        SeperatorSymbol = '';
                    }
                    var params = templateName + '|' + isActive + '|' + currentTemplateId + '|' + SeperatorSymbol + '|' + document.getElementById("<%= txtFileName.ClientID %>").value;
                    if (ValidateSubmit(msgControl, action)) {
                        var data = GetIndexFiledsText();
                        ResetControlsAfterSubmit();
                        $("#divGrid").html('');
                        document.getElementById("<%= txtTemplateName.ClientID %>").value = "";
                        return CallPostTable(msgControl, action, params, data);


                    }
                    else {
                        return false;
                    }
                }
            }
            else if (action == "AddTemplate") {
                if ($("#<%= chkActive.ClientID %>").is(':checked')) isActive = true;
                var SeperatorSymbol = Seperator.options[Seperator.selectedIndex].text;
                if (SeperatorSymbol == '--select--') {
                    SeperatorSymbol = '';
                }
                var params = templateName + '|' + isActive + '|' + currentTemplateId + '|' + SeperatorSymbol + '|' + document.getElementById("<%= txtFileName.ClientID %>").value;
                if (ValidateSubmit(msgControl, action)) {
                    var data = GetIndexFiledsText();
                    ResetControlsAfterSubmit();
                    Encoder.EncodeType = "entity";
                    $("#divGrid").html('');
                    document.getElementById("<%= txtTemplateName.ClientID %>").value = "";

                    return CallPostTable(msgControl, action, params, data);


                }
                else {
                    return false;


                }

            }
        }
        //********************************************************
        //ValidateInputData Function returns true or false with message to user on contorl specified
        //********************************************************
        function AfterEditShowTable() {

            if (typeof rightsArray !== 'undefined' && rightsArray.length > 0) {

                ShowRightsTable();

            }

        }

        function filename() {

            var txtFileName = document.getElementById("<%= txtFileName.ClientID %>");
            var filename = txtFileName.value;
            var lastchar = filename.slice(-1);
            if (txtFileName.value.length != 0) {
                if (lastchar == "#" || lastchar == "-") {

                    return false;
                }
            }
            return true;
        }

        function ValidateSubmit(msgControl, action) {
            var firstListBox = document.getElementById('<%= lstMainTag.ClientID %>');
            //            var secondListBox = document.getElementById('<%= lstSubTag.ClientID %>');

            var txtFileName = document.getElementById("<%= txtFileName.ClientID %>");

            if (document.getElementById("<%= txtTemplateName.ClientID %>").value.length < 2) {
                $(msgControl).html(GetAlertMessages("Template Name Should Contain Atleast Two Characters!"));
                Scrolltop();
                return false;
            }
            if (rightsArray.length == 0) {
                $(msgControl).html(GetAlertMessages("Please Create Atleast One Index Field!"));
                Scrolltop();
                return false;
            }
            if (document.getElementById('<%= lstMainTag.ClientID %>').length == "0") {
                $(msgControl).html(GetAlertMessages("Please Enter Main Tag Value."));
                Scrolltop();
                return false;
            }

            if (!filename()) {
                $(msgControl).html(GetAlertMessages("File name should not end with any special charachter"));
                Scrolltop();
                return false;

            }

            return true;

        }
        function ValidateIndexData(msgControl, action) {
            $(msgControl).html("");
            if (action == "AddTemplate" || action == "EditTemplate") {
                $(msgControl).html("");
                var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
                var SpecialCharachter = /[^a-zA-Z0-9 ]/;
                var retval;


                if (document.getElementById("<%= txtTemplateName.ClientID %>").value.length < 2) {
                    $(msgControl).html(GetAlertMessages("Template Name Should Contain Atleast Two Characters!"));
                    Scrolltop();
                    return false;
                }
                if (SpecialCharachter.test(document.getElementById("<%= txtIndexFieldName.ClientID %>").value.trim())) {
                    $(msgControl).html(GetAlertMessages("Index Field Name Should Not Contain Special Characters!"));
                    Scrolltop();
                    document.getElementById("<%= txtIndexFieldName.ClientID %>").focus();
                    return false;
                }

                if (document.getElementById("<%= txtIndexFieldName.ClientID %>").value.trim().length < 2) {
                    $(msgControl).html(GetAlertMessages("Index Field Name Should Contain Atleast Two Characters!"));
                    Scrolltop();
                    return false;
                }
                if (document.getElementById("<%= txtIndexFieldName.ClientID %>").value.trim() == document.getElementById("<%= txtTemplateName.ClientID %>").value.trim()) {
                    $(msgControl).html(GetAlertMessages("Template Name and Index Name should not be same!"));
                    Scrolltop();
                    document.getElementById("<%= txtIndexFieldName.ClientID %>").focus();
                    return false;
                }
                if (document.getElementById("<%= rbtEntryFields.ClientID %>").checked == false && document.getElementById("<%= rbtMultipleField.ClientID %>").checked == false) {
                    $(msgControl).html(GetAlertMessages("Please Select Index Type!"));
                    Scrolltop();
                    return false;
                }
                if (document.getElementById("<%= rbtMultipleField.ClientID %>").checked == true) {
                    var MultiValue = document.getElementById("<%= lstValue.ClientID %>");
                    if (MultiValue.options.length == 0) {
                        $(msgControl).html(GetAlertMessages("Please Enter Atleast One MultiValue Entry!"));
                        Scrolltop();
                        return false;
                    }
                }
                if (document.getElementById("<%= rbtEntryFields.ClientID %>").checked == true) {
                    var DataType = document.getElementById("<%= lstDataType.ClientID %>");
                    var result = false;
                    if (DataType.options.length != 0) {
                        var listLength = DataType.options.length;
                        for (var i = 0; i < listLength; i++) {
                            if (DataType.options[i].selected) {
                                result = true;
                            }
                        }
                    }
                    if (result == false) {
                        $(msgControl).html(GetAlertMessages("Please Select Data Type!"));
                        $("html, body").animate({ scrollTop: 0 }, 600);
                        return false;
                    }
                }
                var MinLength = document.getElementById("<%= txtMinLength.ClientID %>");
                var MaxLength = document.getElementById("<%= txtMaxLength.ClientID %>");
                if (parseInt(MinLength.value) > parseInt(MaxLength.value)) {
                    $(msgControl).html(GetAlertMessages("Min Length cannot be greater than Max Length!"));
                    Scrolltop();
                    return false;
                }
                var countDisplay = 0;
                if (rightsArray.length > 0) {
                    for (i = 0; i < rightsArray.length; i++) {
                        var data = rightsArray[i];
                        if (data[7] == "true" || data[7] == true) {
                            countDisplay += 1;
                        }
                    }

                }
                if ((countDisplay >= 5) && (document.getElementById("<%= chkDisplay.ClientID %>").checked == true) && (editindexitem == "-0")) {
                    $(msgControl).html(GetAlertMessages("You can only select maximum of 5 index field for displaying in search result!"));
                    Scrolltop();
                    return false;
                }
                else if ((document.getElementById("<%= chkDisplay.ClientID %>").checked == true) && (countDisplay >= 5)) {
                    for (i = 0; i < rightsArray.length; i++) {
                        var data = rightsArray[i];
                        if ((data[1] == editindexitem) && (data[7] == "true" || data[7] == true)) {
                            return true;
                        }
                    }
                    $(msgControl).html(GetAlertMessages("You can only select maximum of 5 index field for displaying in search result!"));
                    Scrolltop();
                    return false;
                }

                return true;
            }
        }

        function Datatype() {
            //var DataType = document.getElementById("<%= lstDataType.ClientID %>").value;
            if (document.getElementById("<%= lstDataType.ClientID %>").value == "String") {
                document.getElementById("<%= txtMinLength.ClientID %>").disabled = false;
                document.getElementById("<%= txtMaxLength.ClientID %>").disabled = false;
            }
            else if (document.getElementById("<%= lstDataType.ClientID %>").value == "Integer") {
                document.getElementById("<%= txtMinLength.ClientID %>").disabled = false;
                document.getElementById("<%= txtMaxLength.ClientID %>").disabled = false;
            }
            else if (document.getElementById("<%= lstDataType.ClientID %>").value == "DateTime") {
                document.getElementById("<%= txtMinLength.ClientID %>").disabled = true;
                document.getElementById("<%= txtMaxLength.ClientID %>").disabled = true;
                document.getElementById("<%= txtMaxLength.ClientID %>").value = "";
                document.getElementById("<%= txtMinLength.ClientID %>").value = "";

            }
            else if (document.getElementById("<%= lstDataType.ClientID %>").value == "Boolen") {
                document.getElementById("<%= txtMinLength.ClientID %>").disabled = true;
                document.getElementById("<%= txtMaxLength.ClientID %>").disabled = true;
                document.getElementById("<%= txtMaxLength.ClientID %>").value = "";
                document.getElementById("<%= txtMinLength.ClientID %>").value = "";
            }
        }
        //********************************************************
        //ClearData Function clears the form
        //********************************************************

        function ClearData() {
            document.getElementById("<%= txtTemplateName.ClientID %>").value = "";
            var rightsArray = new Array();

        }
        //        function Rearrange() {
        //            var dataarray = new Array(rightsArray);
        //            if (rightsArray != null) {
        //                for (var i = 0, j = rightsArray.length; i < j; i++) {
        //                    var data = rightsArray[i];
        //                     

        //                }
        //                 

        //            }

        //        }
        function ConvertToBit(Data) {
            var Data1 = '1';
            if (Data == true || Data == 'true') {
                Data1 = '1';
            }
            else {
                Data1 = '0';
            }
            return Data1;
        }
        function GetIndexFiledsText() {
            var rightsData = "";
            if (rightsArray != null) {
                if (rightsArray.length > 0) {

                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        if (rightsData != "") {
                            rightsData = rightsData + "#"
                        }

                        rightsData = rightsData + data[0] + "|" + data[1] + "|" + data[2] + "|" + data[3] + "|" + data[4] + "|" + data[5] + "|" + ConvertToBit(data[6]) + "|" + ConvertToBit(data[7]) + "|" + ConvertToBit(data[8]) + "|" + data[9] + "|" + data[10] + "|" + data[11]; //MD -Nodified
                    }
                }
            }
            var Decodedindexval = DecodeXML(document.getElementById("<%= hdnIndexListValues.ClientID %>").value);
            var DecodeTagval = DecodeXML(document.getElementById("<%= HdnTagdetails.ClientID %>").value);
            rightsData = rightsData + '!' + Decodedindexval + '!' + DecodeTagval;
            return rightsData;
        }
        //********************************************************
        //ClearData Function 
        //********************************************************
        function ResetControlsAfterAddOrUpdate() {
            document.getElementById('<%= txtIndexFieldName.ClientID %>').disabled = false;
            var firstlst = document.getElementById("<%= lstValue.ClientID %>");
            var secondlst = document.getElementById("<%= ListValueSub.ClientID %>");
            for (var i = firstlst.options.length - 1; i >= 0; i--) {
                firstlst.remove(i);
            }
            for (var i = secondlst.options.length - 1; i >= 0; i--) {
                secondlst.remove(i);
            }
            document.getElementById("<%= txtIndexFieldName.ClientID %>").value = "";
            document.getElementById("<%= txtMinLength.ClientID %>").value = "";
            document.getElementById("<%= txtMaxLength.ClientID %>").value = "";
            document.getElementById("<%= btnAddIndex.ClientID %>").value = "Add";
            document.getElementById("<%= rbtEntryFields.ClientID %>").disabled = false; //1662
            document.getElementById("<%= rbtMultipleField.ClientID %>").disabled = false; //1662
            document.getElementById("<%= chkMandatory.ClientID %>").checked = true; //MD -Nodified
            document.getElementById("<%= chkDisplay.ClientID %>").checked = false; //MD -Nodified
        }

        function ResetControlsAfterSubmit() {
            var rightsArray = new Array();
            document.getElementById('<%= txtTemplateName.ClientID %>').disabled = false;
            document.getElementById('<%= txtIndexFieldName.ClientID %>').disabled = false;
            var firstlst = document.getElementById("<%= lstValue.ClientID %>");
            var secondlst = document.getElementById("<%= ListValueSub.ClientID %>");
            var firstlst1 = document.getElementById("<%= lstMainTag.ClientID %>");
            var secondlst1 = document.getElementById("<%= lstSubTag.ClientID %>");
            for (var i = firstlst.options.length - 1; i >= 0; i--) {
                firstlst.remove(i);
            }
            for (var i = secondlst.options.length - 1; i >= 0; i--) {
                secondlst.remove(i);
            }
            for (var i = firstlst1.options.length - 1; i >= 0; i--) {
                firstlst1.remove(i);
            }
            for (var i = secondlst1.options.length - 1; i >= 0; i--) {
                secondlst1.remove(i);
            }
            document.getElementById("<%= txtIndexFieldName.ClientID %>").value = "";
            document.getElementById("<%= txtMinLength.ClientID %>").value = "";
            document.getElementById("<%= txtMaxLength.ClientID %>").value = "";
            document.getElementById("<%= btnAddIndex.ClientID %>").value = "Add";
            document.getElementById("<%= cmbIndexNames.ClientID %>").options.length = 1;
            document.getElementById("<%= cmbSeperator.ClientID %>").disabled = false;
            document.getElementById("<%= cmbSeperator.ClientID %>").selectedIndex = 0;
            document.getElementById("<%= txtFileName.ClientID %>").value = "";
        }
        function ValidateSaveContinue(msgControl, action, TabType) {
            var firstListBox = document.getElementById('<%= lstMainTag.ClientID %>');
            //            var secondListBox = document.getElementById('<%= lstSubTag.ClientID %>');

            var txtFileName = document.getElementById("<%= txtFileName.ClientID %>");

            if (document.getElementById("<%= txtTemplateName.ClientID %>").value.length < 2) {
                $(msgControl).html(GetAlertMessages("Template Name Should Contain Atleast Two Characters!"));
                Scrolltop();
                return false;
            }
            if (rightsArray.length == 0 && TabType == "TIndex") {
                $(msgControl).html(GetAlertMessages("Please Create Atleast One Index Field!"));
                Scrolltop();
                return false;
            }
            if (document.getElementById('<%= lstMainTag.ClientID %>').length == "0" && TabType == "Tags") {
                $(msgControl).html(GetAlertMessages("Please Enter Main Category Value."));
                Scrolltop();
                return false;
            }

            if (!(TabType)) {
                $(msgControl).html(GetAlertMessages("File name should not end with any special charachter"));
                Scrolltop();
                return false;

            }
            //            else if (document.getElementById('<%= lstSubTag.ClientID %>').length == "0") {
            //                $(msgControl).html("Please Enter Sub Tag Value.");
            //                $("html, body").animate({ scrollTop: 0 }, 600);
            //                return false;
            //            }
            return true;

        }
        function Validatefilename(TabType) {

            var txtFileName = document.getElementById("<%= txtFileName.ClientID %>");
            var filename = txtFileName.value;
            var lastchar = filename.slice(-1);
            if (txtFileName.value.length != 0 && TabType == "TFileName") {
                if (lastchar == "#" || lastchar == "-") {

                    return false;
                }
            }
            return true;
        }



        //***************************************************************************
        //Main function to handle Add index, check duplicate index and update index
        //***************************************************************************
        function AddIndex() {
            var msgControl = "#<%= divMsg.ClientID %>";

            $(msgControl).html("");
            var indexName = document.getElementById("<%= txtIndexFieldName.ClientID %>").value.trim();
            var action = $("#<%= hdnAction.ClientID %>").val();
            if (ValidateIndexData(msgControl, action)) {
                if (editindexitem == "-0") {
                    editindexitem = indexName;
                }
                if (CheckFieldIndexExists(editindexitem)) {
                    editindexitem = "-0";
                    return false;
                }
                else {
                    AddIndexField();
                    editindexitem = "-0";
                    ResetControlsAfterAddOrUpdate();
                }

            }
        }

        // Add index field to table
        function AddIndexField() {
            var msgControl = "#<%= divMsg.ClientID %>";
            HasChild = document.getElementById("<%= hdnHaschild.ClientID %>").value;
            $(msgControl).html("");
            // Add new field
            var dataArray = rightsArray;
            if (dataArray.length > 49) {
                $(msgControl).html(GetAlertMessages("Maximum allowed Index field Count is 50"));
            }
            else {
                if (dataArray == null) {
                    var dataArray = new Array();
                }
                var indexName = document.getElementById("<%= txtIndexFieldName.ClientID %>").value.trim();
                var entryType = '';
                if (document.getElementById("<%= rbtEntryFields.ClientID %>").checked) {
                    entryType = "Entry Fields";
                    HasChild = '0';
                }
                else { // added
                    entryType = "Multiple Field Selection";
                }
                var dataType = document.getElementById("<%= lstDataType.ClientID %>").value;
                var minLength = document.getElementById("<%= txtMinLength.ClientID %>").value;
                var maxLenth = document.getElementById("<%= txtMaxLength.ClientID %>").value;
                var Mandatory = document.getElementById("<%= chkMandatory.ClientID %>").checked;
                var Display = document.getElementById("<%= chkDisplay.ClientID %>").checked;
                var Active = document.getElementById("<%= ChkindexActive.ClientID %>").checked;

                rightsIdentity = rightsIdentity + 1;

                SortOrder = SortOrder + 1;
                var item = [rightsIdentity, indexName, entryType, dataType, minLength, maxLenth, Mandatory, Display, Active, SortOrder, 0, HasChild, "delete"]; //MD -Modified
                HasChild = 0;
                dataArray.push(item);
                rightsArray = dataArray;
                ShowRightsTable();

                rightsArray = dataArray;
                dataType.selectedIndex = -1;
                document.getElementById("<%= hdnHaschild.ClientID %>").value = '0';

            }
        }

        function AddEditIndexField(identity, text, OrgOrder, IndexId) {
            HasChild = document.getElementById("<%= hdnHaschild.ClientID %>").value;
            var dataArray = new Array();
            var indexName = document.getElementById("<%= txtIndexFieldName.ClientID %>").value.trim();
            var entryType = '';
            if (document.getElementById("<%= rbtEntryFields.ClientID %>").checked) {
                entryType = "Entry Fields";
                HasChild = '0';
            }
            else {
                entryType = "Multiple Field Selection";
            }
            var dataType = document.getElementById("<%= lstDataType.ClientID %>").value;
            var minLength = document.getElementById("<%= txtMinLength.ClientID %>").value;
            var maxLenth = document.getElementById("<%= txtMaxLength.ClientID %>").value;
            var Mandatory = document.getElementById("<%= chkMandatory.ClientID %>").checked;
            var Display = document.getElementById("<%= chkDisplay.ClientID %>").checked;
            var Active = document.getElementById("<%= ChkindexActive.ClientID %>").checked;
            //501
            var item = [identity, indexName, entryType, dataType, minLength, maxLenth, Mandatory, Display, Active, OrgOrder, IndexId, HasChild, text]; //MD -Modified

            if (rightsArray != null) {
                if (rightsArray.length > 0) {

                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        if (data[0] != identity) {
                            dataArray.push(data);
                        }
                        else {
                            dataArray.push(item);
                        }
                    }
                    rightsArray = dataArray;

                    ShowRightsTable();
                }
            }
            dataType.selectedIndex = -1;
        }
        function ManageDelete(id) {//501
            var Temparray = new Array();
            var z = 0;
            id = parseInt(id) + 1;
            if (rightsArray != null) {
                for (var i = 0, j = rightsArray.length; i < j; i++) {

                    var data = rightsArray[i];
                    z = parseInt(z) + 1
                    if (data[0] == data[9]) {
                        data[0] = z;
                        data[9] = z;
                    }

                    else if (data[0] != data[9] && data[9] == id) {

                        data[9] = parseInt(id) - 1;
                        id = parseInt(id) + 1;

                    }
                    else {
                        data[0] = z;

                    }
                    Temparray.push(data);

                }
                rightsArray = Temparray;
            }

        }
        function CheckFieldIndexExists(indexFieldName) {
            var msgControl = "#<%= divMsg.ClientID %>";

            if (rightsArray != null) {
                if (rightsArray.length > 0) {

                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        //DMS5-4101M removed space inorder to avoid duplicate fields with and without space
                        if (data[1].toUpperCase().replace(/\s/g, '') == indexFieldName.toUpperCase().replace(/\s/g, '')) {
                            //update the index field
                            if (document.getElementById("<%= btnAddIndex.ClientID %>").value == "Save") {
                                //Delete and Add Index field to update
                                //DeleteIndexField(data[0]);
                                //AddIndexField(); VIJAY
                                AddEditIndexField(i + 1, data[12], data[9], data[10]);
                                ResetControlsAfterAddOrUpdate();
                                ShowRightsTable();
                            }
                            else {
                                $(msgControl).html(GetAlertMessages("Index Field is already added to the selected list."));
                                Scrolltop();
                            }
                            return true;
                        }
                    }
                }
            }
            return false;
        }

        function ShowRightsTable() {
            enablebtn();
            dataArray = rightsArray;
            if (document.getElementById("<%= hdnClearFileName.ClientID %>").value != "1") {
                document.getElementById("<%= txtFileName.ClientID %>").value = "";
                document.getElementById("<%= cmbSeperator.ClientID %>").disabled = false;
                document.getElementById("<%= hdnClearFileName.ClientID %>").value = "0";
            }
            document.getElementById("<%= cmbIndexNames.ClientID %>").options.length = 0;
            var option = document.createElement('option');
            option.text = "--select--";
            option.value = "0";
            document.getElementById("<%= cmbIndexNames.ClientID %>").add(option, 0);
            // editArray = dataArray;
            $("#divGrid").html("");
            var table = "";
            if (dataArray.length > 0) {
                // Table Creation from Json Collection
                table = '<table border= \"1\" class=\"table table-striped table-bordered dataTable no-footer dtr-inline\" AlternatingRowStyle-CssClass=\"alt\"  summary=\"Index Fields\" id="tblIndex"><tr>';
                table += '<th>Edit</th>';
                table += '<th>Delete</th>';
                table += '<th>Index Name</th>';
                table += '<th>Input Type</th>';
                table += '<th>Data Type</th>';
                table += '<th>Min. Length</th>';
                table += '<th>Max. Length</th>';
                table += '<th>Mandatory</th>';
                table += '<th>Display</th>';
                table += '<th>Active</th></tr>';

                for (var i = 0, j = dataArray.length; i < j; i++) {
                    var data = dataArray[i];
                    var option = document.createElement('option');
                    option.text = option.value = data[1];
                    if (data[2] == "Entry Fields" && (data[6] == true || data[6] == "true")) {
                        document.getElementById("<%= cmbIndexNames.ClientID %>").add(option, i + 1);
                    }
                    //check
                    if (editArray != null) {
                        if (editArray != null) {
                            if (dataArray[i][12] == "NoDelete") {
                                table += '<tr id = "tr' + data[0] + '" onclick = "RowColor(this.id)"> <td>&nbsp;' + '<a href=\"javascript:void(0)\" onclick=\"EditIndexField(\'' + data[0] + '\')\" ><img border=\"0\" src = \"' + authority + '\\Assets\\Skin\\Images\\edit.gif\" alt=\"edit\" /> </a>'
                                            + '<td>&nbsp;' + ''
                                            + '</td><td>&nbsp;' + data[1]
                                            + '</td><td>&nbsp;' + data[2]
                                            + '</td><td>&nbsp;' + data[3]
                                            + '</td><td>&nbsp;' + data[4]
                                            + '</td><td>&nbsp;' + data[5]
                                            + '</td><td>&nbsp;' + data[6]
                                            + '</td><td>&nbsp;' + data[7]//MD -Modified
                                            + '</td><td>&nbsp;' + data[8]//MD -Modified
                                            + '</td></tr>';
                            }
                            else {
                                table += '<tr id = "tr' + data[0] + '" onclick = "RowColor(this.id)"><td>&nbsp;' + '<a href=\"javascript:void(0)\" onclick=\"EditIndexField(\'' + data[0] + '\')\" ><img border=\"0\" src = \"' + authority + '\\Assets\\Skin\\Images\\edit.gif\" alt=\"edit\" /> </a>'
                                            + '<td>&nbsp;' + '<a href=\"javascript:void(0)\" onclick=\"DeleteIndexField(\'' + data[0] + '\')\"><img border=\"0\" src = \"' + authority + '\\Assets\\Skin\\Images\\del.gif\" alt=\"delete\" /> </a>'
                                            + '</td><td>&nbsp;' + data[1]
                                            + '</td><td>&nbsp;' + data[2]
                                            + '</td><td>&nbsp;' + data[3]
                                            + '</td><td>&nbsp;' + data[4]
                                            + '</td><td>&nbsp;' + data[5]
                                            + '</td><td>&nbsp;' + data[6]//MD -Modified
                                            + '</td><td>&nbsp;' + data[7]
                                            + '</td><td>&nbsp;' + data[8]//MD -Modified
                                            + '</td></tr>';
                            }
                        }
                        else {
                            table += '<tr id = "tr' + data[0] + '" onclick = "RowColor(this.id)"><td>&nbsp;' + '<a href=\"javascript:void(0)\" onclick=\"EditIndexField(\'' + data[0] + '\')\" ><img border=\"0\" src = \"' + authority + '\\Assets\\Skin\\Images\\edit.gif\" alt=\"edit\" /> </a>'
                                            + '<td>&nbsp;' + '<a href=\"javascript:void(0)\" onclick=\"DeleteIndexField(\'' + data[0] + '\')\"><img border=\"0\" src = \"' + authority + '\\Assets\\Skin\\Images\\del.gif\" alt=\"delete\" /> </a>'
                                            + '</td><td>&nbsp;' + data[1]
                                            + '</td><td>&nbsp;' + data[2]
                                            + '</td><td>&nbsp;' + data[3]
                                            + '</td><td>&nbsp;' + data[4]
                                            + '</td><td>&nbsp;' + data[5]
                                            + '</td><td>&nbsp;' + data[6]//MD -Modified
                                            + '</td><td>&nbsp;' + data[7]
                                            + '</td><td>&nbsp;' + data[8]//MD -Modified
                                            + '</td></tr>';
                        }
                    }
                    else {
                        table += '<tr id = "tr' + data[0] + '" onclick = "RowColor(this.id)"><td>&nbsp;' + '<a href=\"javascript:void(0)\" onclick=\"EditIndexField(\'' + data[0] + '\')\" ><img border=\"0\" src = \"' + authority + '\\Assets\\Skin\\Images\\edit.gif\" alt=\"edit\" /> </a>'
                                            + '<td>&nbsp;' + '<a href=\"javascript:void(0)\" onclick=\"DeleteIndexField(\'' + data[0] + '\')\"><img border=\"0\" src = \"' + authority + '\\Assets\\Skin\\Images\\del.gif\" alt=\"delete\" /> </a>'
                                            + '</td><td>&nbsp;' + data[1]
                                            + '</td><td>&nbsp;' + data[2]
                                            + '</td><td>&nbsp;' + data[3]
                                            + '</td><td>&nbsp;' + data[4]
                                            + '</td><td>&nbsp;' + data[5]
                                            + '</td><td>&nbsp;' + data[6]//MD -Modified
                                            + '</td><td>&nbsp;' + data[7]
                                            + '</td><td>&nbsp;' + data[8]//MD -Modified
                                            + '</td></tr>';
                    }
                }
                table += '</table>';
            }
            /* insert the html string*/
            $("#divGrid").html(table);
        }

        function MoveUp() {

            var obj = objid;
            var msgControl = "#<%= divMsg.ClientID %>";
            if (obj != "tr1") {

                sort(obj, "UP");
            }
            else {
                $(msgControl).html("Not a valid Choice.");
                $("html, body").animate({ scrollTop: 0 }, 600);
            }



        }
        function MoveDown() {
            var obj = objid;
            var msgControl = "#<%= divMsg.ClientID %>";
            if (obj != lastrowid) {
                sort(obj, "Down");

            }
            else {
                $(msgControl).html(GetAlertMessages("Not a valid Choice."));
                Scrolltop();
            }

        }
        function sort(obj, action) {
            var msgControl = "#<%= divMsg.ClientID %>";
            if (obj != '') {
                var TargetOrder = 0;
                var CurrentOrder = obj.substring(2, obj.length);
                var Temparray = new Array();
                if (action == "UP") {
                    TargetOrder = CurrentOrder - 1;
                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        if (data[0] != TargetOrder && data[0] != CurrentOrder) {
                            Temparray.push(data);

                        }
                        else if (data[0] == TargetOrder) {
                            var data1 = rightsArray[parseInt(CurrentOrder) - 1];
                            data1[0] = parseInt(CurrentOrder) - 1;
                            data[0] = parseInt(TargetOrder) + 1;
                            Temparray.push(data1);
                            Temparray.push(data);
                            i++;
                        }
                    }


                }
                else if (action == "Down") {
                    TargetOrder = parseInt(CurrentOrder) + 1;
                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        if (data[0] != TargetOrder && data[0] != CurrentOrder) {
                            Temparray.push(data);

                        }
                        else if (data[0] == CurrentOrder) {
                            var data1 = rightsArray[parseInt(TargetOrder) - 1];
                            data1[0] = parseInt(TargetOrder) - 1;
                            data[0] = parseInt(CurrentOrder) + 1;
                            Temparray.push(data1);
                            Temparray.push(data);
                            i++;
                        }
                    }


                }

                rightsArray = Temparray;

                ShowRightsTable();
                objid = "";
                $(msgControl).html("");
            }
            else {
                $(msgControl).html(GetAlertMessages("Not a valid Choice."));
                Scrolltop();
            }
        }

        //Table row color change
        function RowColor(obj) {
            if (ManageOrder == "") {
                objid = obj;
                var tbl = document.getElementById("tblIndex");
                rlen = tbl.rows.length
                var tr = document.getElementById(obj);
                var clen = tr.cells.length;
                var color = "#ffffff";
                for (j = 1; j < rlen; j++) {
                    trTemp = tbl.rows[j];
                    if (trTemp.id == obj) {
                        color = "#ffffff"
                    }
                    else {
                        color = "#F5DEB3"
                    }
                    for (i = 0; i < clen; i++) {
                        trTemp.cells[i].style.backgroundColor = color;

                    }

                    lastrowid = (trTemp.id);
                }
            }
            else {
                ManageOrder = "";
            }

        }


        //Radio button onchange function start
        function IndexDisplay() {

            if (document.getElementById("<%= ChkindexActive.ClientID %>").checked != true) {

                document.getElementById("<%= chkDisplay.ClientID %>").checked = false;
                document.getElementById("<%= chkMandatory.ClientID %>").checked = false;
                document.getElementById("<%= chkDisplay.ClientID %>").disabled = true;
                document.getElementById("<%= chkMandatory.ClientID %>").disabled = true;

            }
            else if (document.getElementById("<%= ChkindexActive.ClientID %>").checked == true) {
                //                document.getElementById("<%= chkDisplay.ClientID %>").checked = true;
                //                document.getElementById("<%= chkMandatory.ClientID %>").checked = true;
                document.getElementById("<%= chkDisplay.ClientID %>").disabled = false;
                document.getElementById("<%= chkMandatory.ClientID %>").disabled = false;

            }

        }
        function radioonchage() {
            if (document.getElementById("<%= rbtEntryFields.ClientID %>").checked == true) {
                document.getElementById("<%= txtMinLength.ClientID %>").value = "";
                document.getElementById("<%= txtMaxLength.ClientID %>").value = "";
                document.getElementById("<%= lstDataType.ClientID %>").selectedIndex = -1;
                document.getElementById("<%= lstDataType.ClientID %>").disabled = false;
                document.getElementById("<%= txtMinLength.ClientID %>").disabled = false;
                document.getElementById("<%= txtMaxLength.ClientID %>").disabled = false;
                document.getElementById("<%= txtValue1.ClientID %>").disabled = true;
                document.getElementById("<%= btnAdd.ClientID %>").disabled = true;
                document.getElementById("<%= btnAdd0.ClientID %>").disabled = true;
                document.getElementById("<%= txtSubValue.ClientID %>").disabled = true;
                document.getElementById("<%= btnAddSub.ClientID %>").disabled = true;
                document.getElementById("<%= btnRemoveSub.ClientID %>").disabled = true;
                document.getElementById("<%= txtIndexFieldName.ClientID %>").disabled = false;

                var firstlst = document.getElementById("<%= lstValue.ClientID %>");
                var secondlst = document.getElementById("<%= ListValueSub.ClientID %>");
                for (var i = firstlst.options.length - 1; i >= 0; i--) {
                    firstlst.remove(i);
                }
                for (var i = secondlst.options.length - 1; i >= 0; i--) {
                    secondlst.remove(i);
                }
                return true;
                //                var DataType = document.getElementById("<%= lstDataType.ClientID %>");
                //                if (DataType.options.selectedItem = "DateTime") {
                //                    document.getElementById("<%= txtMinLength.ClientID %>").disabled = true;
                //                    document.getElementById("<%= txtMaxLength.ClientID %>").disabled = true;
                //                }

            }
            else if (document.getElementById("<%= rbtMultipleField.ClientID %>").checked == true) {
                document.getElementById("<%= txtMinLength.ClientID %>").value = "";
                document.getElementById("<%= txtMaxLength.ClientID %>").value = "";
                document.getElementById("<%= lstDataType.ClientID %>").selectedIndex = -1;
                document.getElementById("<%= lstDataType.ClientID %>").disabled = true;
                document.getElementById("<%= txtMinLength.ClientID %>").disabled = true;
                document.getElementById("<%= txtMaxLength.ClientID %>").disabled = true;
                document.getElementById("<%= txtValue1.ClientID %>").disabled = false;
                document.getElementById("<%= btnAdd.ClientID %>").disabled = false;
                document.getElementById("<%= btnAdd0.ClientID %>").disabled = false;
                document.getElementById("<%= txtSubValue.ClientID %>").disabled = false;
                document.getElementById("<%= btnAddSub.ClientID %>").disabled = false;
                document.getElementById("<%= btnRemoveSub.ClientID %>").disabled = false;
                document.getElementById("<%= lstValue.ClientID %>").disabled = false;
                document.getElementById("<%= ListValueSub.ClientID %>").disabled = false;
                document.getElementById("<%= txtIndexFieldName.ClientID %>").disabled = false;
                return true;
            }
        }

        function EdittemplateCheck() {

            var BoolEnable = true;
            var editid = document.getElementById("<%= hdnEditIndex.ClientID %>").value;
            if (editArray != null) {
                if (editArray.length > 0) {
                    for (var i = 0, j = editArray.length; i < j; i++) {
                        var data = editArray[i];
                        if (data[0] == editid) {
                            document.getElementById("<%= rbtEntryFields.ClientID %>").disabled = true; //1662
                            document.getElementById("<%= rbtMultipleField.ClientID %>").disabled = true; //1662
                            BoolEnable = false;
                        }
                    }
                    if (BoolEnable == true) {
                        document.getElementById("<%= rbtEntryFields.ClientID %>").disabled = false; //1662
                        document.getElementById("<%= rbtMultipleField.ClientID %>").disabled = false; //1662
                    }
                }
            }
        }
        //Radio button onchange function end -- EDIT NEED TO WORK
        var editindexitem = "-0";
        function EditIndexField(id) {
            // HasChild = document.getElementById("<%= hdnHaschild.ClientID %>").value;
            ManageOrder = "check";
            document.getElementById("<%= hdnEditIndex.ClientID %>").value = id;
            var lstValue = document.getElementById("<%= lstValue.ClientID %>");
            var lstValue2 = document.getElementById("<%= ListValueSub.ClientID %>");
            document.getElementById("<%= btnAddIndex.ClientID %>").value = "Save";
            if (rightsArray != null) {
                if (rightsArray.length > 0) {

                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        if (data[0] == id) {
                            document.getElementById("<%= txtIndexFieldName.ClientID %>").value = data[1];
                            editindexitem = document.getElementById("<%= txtIndexFieldName.ClientID %>").value;
                            if (data[2] == "Entry Fields") {
                                document.getElementById("<%= rbtEntryFields.ClientID %>").checked = true;
                                EdittemplateCheck();

                                radioonchage();
                                //document.getElementById("<%= lstDataType.ClientID %>").disabled = true;
                            }
                            else {
                                document.getElementById("<%= rbtMultipleField.ClientID %>").checked = true;
                                document.getElementById("<%= txtIndexFieldName.ClientID %>").disabled = true;
                                radioonchage();
                                document.getElementById("<%= hdnIndexName.ClientID %>").value = data[1];
                                // Bind listboxes
                                document.getElementById("<%= hdnListAction.ClientID %>").value = "LoadMainCategory";
                                (document.getElementById("<%= btnManageList.ClientID %>")).click();
                                EdittemplateCheck();
                            }
                            document.getElementById("<%= lstDataType.ClientID %>").value = data[3];
                            document.getElementById("<%= txtMinLength.ClientID %>").value = data[4];
                            document.getElementById("<%= txtMaxLength.ClientID %>").value = data[5];
                            if (data[6] == "true" || data[6] == true) {//MD -Modified
                                document.getElementById("<%= chkMandatory.ClientID %>").checked = true;
                            }
                            else {
                                document.getElementById("<%= chkMandatory.ClientID %>").checked = false;
                            }
                            if (data[7] == "true" || data[7] == true) {
                                document.getElementById("<%= chkDisplay.ClientID %>").checked = true;
                            }
                            else {
                                document.getElementById("<%= chkDisplay.ClientID %>").checked = false;
                            }
                            if (data[8] == "true" || data[8] == true) {
                                document.getElementById("<%= ChkindexActive.ClientID %>").checked = true;
                            }
                            else {
                                document.getElementById("<%= ChkindexActive.ClientID %>").checked = false;
                            }

                        }
                    }
                    rightsArray = dataArray;
                    ShowRightsTable();
                }
            }
            return false;
        }

        function DeleteIndexField(id) {

            var dataArray = new Array();

            if (rightsArray != null) {
                if (rightsArray.length > 0) {

                    for (var i = 0, j = rightsArray.length; i < j; i++) {
                        var data = rightsArray[i];
                        if (data[0] != id) {
                            dataArray.push(data);
                        }
                    }
                    rightsArray = dataArray;
                    ManageDelete(id); //501
                    rightsIdentity = rightsIdentity - 1;
                    SortOrder = SortOrder - 1;
                    ManageOrder = "check";
                    ShowRightsTable();
                }
            }
            document.getElementById("<%= hdnListAction.ClientID %>").value = "DeleteIndexItem";
            document.getElementById("<%= btnManageList.ClientID %>").click();
            ResetControlsAfterAddOrUpdate();
        }
        function ShowTemplateFieldList(rightText) {
            rightsArray = new Array();
            var dataArray = rightText.split("#");
            if (dataArray != null) {
                if (dataArray.length > 0) {

                    for (var i = 0, j = dataArray.length; i < j; i++) {
                        var data = dataArray[i];
                        subitemArray = data.split("|")
                        if (subitemArray.length > 6) {
                            subitemArray[6] = subitemArray[6].split(",");
                        }
                        rightsArray.push(subitemArray);
                        editArray.push(subitemArray);
                    }
                }
            }
            rightsIdentity = i;
            SortOrder = i;
            ShowRightsTable();
            return true;
        }

        function AddMainList() {
            var Value = $.trim($("#<%= txtValue1.ClientID %>").val());
            var IndexName = $.trim($("#<%= txtIndexFieldName.ClientID %>").val().trim());


            var firstListBox = document.getElementById('<%= lstValue.ClientID %>');
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var isFound = true;
            if (IndexName.length > 0) {
                document.getElementById('<%= txtIndexFieldName.ClientID %>').disabled = true;
                if (Value.length > 0) {
                    for (var i = 0; i < firstListBox.options.length; i++) {
                        if (firstListBox.options[i].text.toLowerCase() == Value.toLowerCase()) {
                            isFound = false;
                            break;
                        }
                    }
                    if (!isFound) {
                        $(msgControl).html(GetAlertMessages("Duplicate! The value has been already added to the list."));
                        Scrolltop();
                    }
                    else {
                        document.getElementById("<%= hdnListAction.ClientID %>").value = "AddMainList";
                        (document.getElementById("<%= btnManageList.ClientID %>")).click();
                    }
                }
                else {
                    $(msgControl).html(GetAlertMessages("Please enter value."));
                    Scrolltop();
                }
            }
            else {
                $(msgControl).html(GetAlertMessages("Please enter index field name."));
                Scrolltop();
            }
        }
        function DeleteMainItem() {
            var firstListBox = document.getElementById('<%= lstValue.ClientID %>');
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var selected = true;
            //Code for listbox validation
            for (var i = 0; i < firstListBox.options.length; i++) {
                if (firstListBox.options[i].selected) {
                    selected = false;
                    break;
                }
            }
            if (selected) {
                $(msgControl).html(GetAlertMessages("Please select Value."));
                Scrolltop();
            }
            else {
                document.getElementById("<%= hdnListAction.ClientID %>").value = "DeleteMainItem";
                (document.getElementById("<%= btnManageList.ClientID %>")).click();
            }
            return false;
        }
        function DeleteSubItem() {
            var secondListBox = document.getElementById('<%= ListValueSub.ClientID %>');
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var selected = true;
            for (var i = 0; i < secondListBox.options.length; i++) {
                if (secondListBox.options[i].selected) {
                    selected = false;
                    break;
                }
            }
            if (selected) {
                $(msgControl).html(GetAlertMessages("Please select Value."));
                Scrolltop();
            }
            else {
                document.getElementById("<%= hdnListAction.ClientID %>").value = "DeleteSubItem";
                (document.getElementById("<%= btnManageList.ClientID %>")).click();
            }
            return false;
        }
        function AddSubList() {

            var Value = $.trim($("#<%= txtSubValue.ClientID %>").val());
            var firstListBox = document.getElementById('<%= lstValue.ClientID %>');
            var secondListBox = document.getElementById('<%= ListValueSub.ClientID %>');
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var selected = true;
            var isFound = true;

            if (Value.length > 0) {
                //Code for listbox validation
                for (var i = 0; i < firstListBox.options.length; i++) {
                    if (firstListBox.options[i].selected) {
                        selected = false;
                        break;
                    }
                }
                if (selected) {
                    $(msgControl).html(GetAlertMessages("Please select Main Value."));
                    Scrolltop();
                }
                else {
                    for (var i = 0; i < secondListBox.options.length; i++) {
                        if (secondListBox.options[i].text.toLowerCase() == Value.toLowerCase()) {
                            isFound = false;
                            break;
                        }
                    }
                    if (!isFound) {
                        $(msgControl).html(GetAlertMessages("Duplicate! The value has been already added to the list."));
                        Scrolltop();
                    }
                    else {
                        document.getElementById("<%= hdnListAction.ClientID %>").value = "AddSubList";
                        (document.getElementById("<%= btnManageList.ClientID %>")).click();
                    }
                }
            }
            else {
                $(msgControl).html(GetAlertMessages("Please enter value."));
                Scrolltop();
            }
            return false;
        }

        function OnMainListIndexChange() {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            document.getElementById("<%= hdnListAction.ClientID %>").value = "LoadSubCategory";
            (document.getElementById("<%= btnManageList.ClientID %>")).click();
            return true;
        }


        /* Tagging Details */
        function AddMainTag() {
            var Value = $.trim($("#<%= txtMainTagValue.ClientID %>").val());
            var IndexName = $.trim($("#<%= txtTemplateName.ClientID %>").val());

            var firstListBox = document.getElementById('<%= lstMainTag.ClientID %>');
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var isFound = true;
            if (IndexName.length > 0) {
                if (Value.length > 0) {
                    for (var i = 0; i < firstListBox.options.length; i++) {
                        if (firstListBox.options[i].text.toLowerCase() == Value.toLowerCase()) {
                            isFound = false;
                            break;
                        }
                    }
                    if (!isFound) {
                        $(msgControl).html(GetAlertMessages("Duplicate! The value has been already added to the list."));
                        Scrolltop();
                    }
                    else {
                        document.getElementById("<%= hdnTagAction.ClientID %>").value = "AddMainTag";
                        (document.getElementById("<%= btnManageList.ClientID %>")).click();
                    }
                }
                else {
                    $(msgControl).html(GetAlertMessages("Please enter value."));
                    Scrolltop();
                }
            }
            else {
                $(msgControl).html(GetAlertMessages("Please enter template name."));
                Scrolltop();
            }

        }

        function DisabletemplateName() {
            var firstListBox = document.getElementById('<%= lstMainTag.ClientID %>');

            if (firstListBox.options.length > 0) {
                document.getElementById('<%= txtTemplateName.ClientID %>').disabled = true;
            }
            else {
                document.getElementById('<%= txtTemplateName.ClientID %>').disabled = false;
            }
        }

        function DeleteMainTag() {
            var firstListBox = document.getElementById('<%= lstMainTag.ClientID %>');
            var secondListBox = document.getElementById('<%= lstSubTag.ClientID %>');
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var selected = true;
            //Code for listbox validation
            for (var i = 0; i < firstListBox.options.length; i++) {
                if (firstListBox.options[i].selected) {
                    selected = false;
                    break;
                }
            }
            if (selected) {
                $(msgControl).html(GetAlertMessages("Please select Value."));
                Scrolltop();
            }
            else {
                if (secondListBox.options.length > 0) {
                    if (confirm("Do you want to delete the selected main category and associated sub categories? ") == true) {
                        document.getElementById("<%= hdnTagAction.ClientID %>").value = "DeleteMainTag";
                        (document.getElementById("<%= btnManageTag.ClientID %>")).click();
                    }
                }
                else {
                    document.getElementById("<%= hdnTagAction.ClientID %>").value = "DeleteMainTag";
                    (document.getElementById("<%= btnManageTag.ClientID %>")).click();
                }
            }
            if (firstListBox.options.length > 0) {
                document.getElementById('<%= txtTemplateName.ClientID %>').disabled = true;
            }
            else {
                document.getElementById('<%= txtTemplateName.ClientID %>').disabled = false;
            }
            return false;
        }
        function DeleteSubTag() {
            var secondListBox = document.getElementById('<%= lstSubTag.ClientID %>');
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var selected = true;
            for (var i = 0; i < secondListBox.options.length; i++) {
                if (secondListBox.options[i].selected) {
                    selected = false;
                    break;
                }
            }
            if (selected) {
                $(msgControl).html(GetAlertMessages("Please select Value."));
                Scrolltop();
            }
            else {
                document.getElementById("<%= hdnTagAction.ClientID %>").value = "DeleteSubTag";
                (document.getElementById("<%= btnManageTag.ClientID %>")).click();
            }
            return false;
        }
        function AddSubTag() {
            var Value = $.trim($("#<%= txtSubTagValue.ClientID %>").val());
            var firstListBox = document.getElementById('<%= lstMainTag.ClientID %>');
            var secondListBox = document.getElementById('<%= lstSubTag.ClientID %>');
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var selected = true;
            var isFound = true;

            if (Value.length > 0) {
                //Code for listbox validation
                for (var i = 0; i < firstListBox.options.length; i++) {
                    if (firstListBox.options[i].selected) {
                        selected = false;
                        break;
                    }
                }
                if (selected) {
                    $(msgControl).html(GetAlertMessages("Please select Main Value."));
                    Scrolltop();

                }
                else {
                    for (var i = 0; i < secondListBox.options.length; i++) {
                        if (secondListBox.options[i].text.toLowerCase() == Value.toLowerCase()) {
                            isFound = false;
                            break;
                        }
                    }
                    if (!isFound) {
                        $(msgControl).html(GetAlertMessages("Duplicate! The value has been already added to the list."));
                        Scrolltop();
                    }
                    else {
                        document.getElementById("<%= hdnTagAction.ClientID %>").value = "AddSubTag";
                        (document.getElementById("<%= btnManageList.ClientID %>")).click();
                    }
                }
            }
            else {
                $(msgControl).html(GetAlertMessages("Please enter value."));
                Scrolltop();
            }
            return false;
        }
        function enablebtn() {


            var controlUp = (document.getElementById("<%= btnUP.ClientID %>"));
            var controlDown = (document.getElementById("<%= btnDown.ClientID %>"));
            if (rightsArray.length > 0) {

                controlUp.style.visibility = "visible";
                controlDown.style.visibility = "visible";

            }

            else {

                controlUp.style.visibility = "hidden";
                controlDown.style.visibility = "hidden";
            }


        }

        function OnMainSubTagDropIndexChange() {

            var ddlmain = document.getElementById("<%= ddlsubtag.ClientID %>");
            var selectedtext = ddlmain.options[ddlmain.selectedIndex].text;

            if (selectedtext != '--Select--') {
                document.getElementById("<%= txtsubtag.ClientID %>").value = selectedtext;

            }
            else {
                document.getElementById("<%= txtsubtag.ClientID %>").value = '';

            }

            return true;

        }
        function OnMainTagDropIndexChange() {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            var ddlmain = document.getElementById("<%= ddlMaintag.ClientID %>");
            var selectedtext = ddlmain.options[ddlmain.selectedIndex].text;
            if (selectedtext != '--Select--') {
                document.getElementById("<%= hdnTagAction.ClientID %>").value = "LoadSubTagForTagNameChange";
                document.getElementById("<%= txtsubtag.ClientID %>").value = '';
                document.getElementById("<%= txtmaintag.ClientID %>").value = selectedtext;
                (document.getElementById("<%= btnManageTag.ClientID %>")).click();
            }
            else {
                document.getElementById("<%= txtsubtag.ClientID %>").value = '';
                document.getElementById("<%= txtmaintag.ClientID %>").value = '';
                var select = document.getElementById("<%= ddlsubtag.ClientID %>");
                var i;
                for (i = select.options.length - 1; i > 0; i--) {
                    select.remove(i);
                }
            }

            return true;
        }

        function OnMainTagIndexChange() {
            var msgControl = "#<%= divMsg.ClientID %>";
            $(msgControl).html("");
            document.getElementById("<%= hdnTagAction.ClientID %>").value = "LoadSubTag";
            (document.getElementById("<%= btnManageTag.ClientID %>")).click();
            return true;
        }

        function AddIndexNametotxt() {
            var msgControl = "#<%= divMsg.ClientID %>";
            var IndexName = document.getElementById("<%= cmbIndexNames.ClientID %>");
            var txtFileName = document.getElementById("<%= txtFileName.ClientID %>");
            var Seperator = document.getElementById("<%= cmbSeperator.ClientID %>");
            if (IndexName.options[IndexName.selectedIndex].text == "--select--") {
                $(msgControl).html(GetAlertMessages("Please select index name to add."));
                Scrolltop();
                return false;
            }
            if (txtFileName.value.length == 0) {
                txtFileName.value = IndexName.options[IndexName.selectedIndex].text;
                return false;
            }

            for (var i = 0; i < Seperator.options.length; i++) {
                if (txtFileName.value.substr(txtFileName.value.length - 1).indexOf(Seperator.options[i].text) != -1) {
                    txtFileName.value = txtFileName.value + IndexName.options[IndexName.selectedIndex].text;
                    return false;
                }

            }

            $(msgControl).html(GetAlertMessages("Please add a seperator before adding another index name."));
            Scrolltop();
            return false;

        }

        function AddSeperatortotxt() {
            var msgControl = "#<%= divMsg.ClientID %>";
            var txtFileName = document.getElementById("<%= txtFileName.ClientID %>");
            var Seperator = document.getElementById("<%= cmbSeperator.ClientID %>");
            if (Seperator.options[Seperator.selectedIndex].text == "--select--") {
                $(msgControl).html(GetAlertMessages("Please select seperator to add."));
                Scrolltop();
                return false;
            }
            if (txtFileName.value.length == 0) {
                $(msgControl).html(GetAlertMessages("Please add index name before adding seperator."));
                Scrolltop();
                return false;
            }

            for (var i = 0; i < Seperator.options.length; i++) {
                if (txtFileName.value.substr(txtFileName.value.length - 1).indexOf(Seperator.options[i].text) != -1) {
                    $(msgControl).html(GetAlertMessages("Only one seperator allowed between index names."));
                    Scrolltop();
                    return false;
                }

            }

            txtFileName.value = txtFileName.value + Seperator.options[Seperator.selectedIndex].text;
            document.getElementById("<%= cmbSeperator.ClientID %>").disabled = true;

        }

        function CleartxtFileName() {
            document.getElementById("<%= cmbSeperator.ClientID %>").disabled = false;
            document.getElementById("<%= txtFileName.ClientID %>").value = "";
        }

  
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%-- Newly Added Enhacement --%>
    <div id="page-content">
    <div class="panel">
        <div class="panel-body">
            <div class="row">
                <div class="col-sm-12">
                    <asp:Label CssClass="PageHeadings" ID="lblHeading" runat="server" Text="Add New Document Template"></asp:Label>
                    <br />
                    <div id="divMsg" runat="server" >
                    </div>
                    <br />
                </div>
            </div>
            
            <div class="row form-group">
                <div class="col-md-2">
                    

                        <asp:Label ID="lblHeading0" runat="server" CssClass="label-style" Text="Template Name"></asp:Label>
                         <asp:Label ID="lblHeading01" runat="server" CssClass="label-style" Text="*" ForeColor="red"></asp:Label>
                         </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="txtTemplateName" CssClass="form-control" runat="server" MaxLength="50" />
                        </div>
                    
                
                <div class="col-md-1">
                    <div class="form-group">
                        <label class="">
                            <asp:CheckBox ID="chkActive" runat="server" Checked="true" />
                            Active</label>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
             <div id="page-content">
            
                <div class="panel panel-success">
                    <!--Panel heading-->
                    <div class="panel-heading">
                        <div class="panel-control">
                            <!--Nav tabs-->
                            <ul class="nav nav-tabs">
                                <li class="active"><a data-toggle="tab" href="#demo-lft-tab-1">Manage Index </a>
                                </li>
                                <li><a data-toggle="tab" href="#demo-lft-tab-2">Manage Tag</a> </li>
                                <li><a data-toggle="tab" href="#demo-lft-tab-3">Manage FileName</a> </li>
                                <li><a data-toggle="tab" href="#demo-lft-tab-4">Edit Tag Name</a> </li>
                            </ul>
                        </div>
                        <h3 class="panel-title">
                            Manage Templates</h3>
                    </div>
                    <!--Panel body-->
                    <div class="panel-body">
                        <!--Tabs content-->
                        <div class="tab-content">
                            <div id="demo-lft-tab-1" class="tab-pane fade active in">
                                <div class="row">
                                    <h4>Index Field Information</h4>
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label class="control-label">
                                                    Index Field Name</label>
                                                    <asp:Label ID="lblindex" runat="server" CssClass="control-label" Text="*" ForeColor="red"></asp:Label>
                                                <asp:TextBox ID="txtIndexFieldName" CssClass="form-control" runat="server" MaxLength="15"></asp:TextBox>
                                            </div>
                                            <div class="form-group">
                                                <label class="control-label">Type</label>
                                                <span class="AstrickStyle" style="color:red">&nbsp;*</span>
                                                <div class="row">
                                                  <div class="col-sm-6">
                                                <asp:RadioButton ID="rbtEntryFields" runat="server" CssClass="RadioButtonStlye" Text="Entry Fields"
                                                    GroupName="DataType" onclick="radioonchage();" TagName="Read" />
                                          
                                              </div>
                                              <div class="col-sm-6">
                                                
                                                <asp:RadioButton ID="rbtMultipleField" runat="server" CssClass="RadioButtonStlye"
                                                    GroupName="DataType" onclick="radioonchage();" Text="Multiple Field Selection"
                                                    TagName="Read" />
                                                    </div>
                                                    </div>
                                                   
                                            </div>
                                            
                                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                            <ContentTemplate>
                                                <div class="row">
                                                 <div class="col-sm-6">
                                                    <div class="form-group form-inline">
                                                        <asp:TextBox ID="txtValue1" runat="server" CssClass="form-control" placeholder="Main Values"></asp:TextBox>
                                                        <asp:Button ID="btnAdd" runat="server" CssClass="btn white btn-success btn-icon icon-lg fa fa-plus"
                                                            Text="+" OnClientClick="AddMainList();return false;" UseSubmitBehavior="false"
                                                            CausesValidation="false" TagName="Read" />
                                                        <asp:Button ID="btnAdd0" CssClass="btn white btn-danger btn-icon icon-lg fa fa-minus" Text="-"
                                                            runat="server" OnClientClick="DeleteMainItem();return false;" TagName="Read" />
                                                    </div>
                                                    <asp:ListBox ID="lstValue" runat="server" CssClass="form-control"></asp:ListBox>
                                                    </div>
                                                    <div class="col-sm-6">
                                                   
                                               
                                                    <div class="form-inline form-group ">
                                                        <asp:TextBox ID="txtSubValue" runat="server" CssClass="form-control" placeholder="Sub Values"></asp:TextBox>
                                                        
                                                        <asp:Button ID="btnAddSub" runat="server" OnClientClick="AddSubList();return false;"
                                                            Text="+" CssClass="btn white btn-success btn-icon icon-lg fa fa-plus" TagName="Read" />
                                                        <asp:Button ID="btnRemoveSub" runat="server" OnClientClick="DeleteSubItem();return false;"
                                                            CssClass="btn btn-danger white btn-icon icon-lg fa fa-minus" Text="-" TagName="Read" />
                                                    </div>
                                                    <asp:ListBox ID="ListValueSub" runat="server" CssClass="form-control"></asp:ListBox>
                                               </div>
                                               </div>
                                               <div class="form-group">
                                                <label class="control-label">
                                                    Data Type</label>
                                                    <span class="AstrickStyle" style="color:red">&nbsp;*</span>
                                                <asp:ListBox ID="lstDataType" runat="server" CssClass="form-control"></asp:ListBox>
                                            </div>
                                            
                                               <div class="form-group">
                                                <label class="control-label">
                                                    Min Length</label>
                                                <asp:TextBox ID="txtMinLength" runat="server" CssClass="form-control" OnKeyPress="return CheckNumericKey(event)"
                                                    MaxLength="2"></asp:TextBox>
                                            </div>
                                               
                                               <div class="form-group">
                                                <label class="control-label">
                                                    Max Length</label>
                                                <asp:TextBox ID="txtMaxLength" runat="server" CssClass="form-control" OnKeyPress="return CheckNumericKey(event)"
                                                    MaxLength="2"></asp:TextBox>
                                            </div>
                                            
                                               <div class="form-group">
                                                <label class="">
                                                    <asp:CheckBox ID="chkMandatory" runat="server" Checked="True" OnClick="IndexDisplay();" />
                                                    Mandatory
                                                </label>
                                                <label class="">
                                                    <asp:CheckBox ID="chkDisplay" runat="server" Text="" OnClick="IndexDisplay();" />
                                                    Display
                                                </label>
                                                <label class="">
                                                    <asp:CheckBox ID="ChkindexActive" runat="server" Text="" Checked="True" OnClick="IndexDisplay();" />Active
                                                </label>
                                            </div>
                                               
                                            
                                            
                                                <asp:Button ID="btnManageList" runat="server" TagName="Read" Style="visibility: hidden"
                                                    OnClick="btnManageList_Click" CausesValidation="False" UseSubmitBehavior="False" /><asp:HiddenField
                                                        ID="hdnListAction" runat="server" Value="" />
                                                <asp:HiddenField ID="hdnIndexListValues" runat="server" Value="" />
                                                <asp:HiddenField ID="hdnHaschild" runat="server" Value="0" />
                                            </ContentTemplate>
                                        </asp:UpdatePanel>
                                        </div>
                                       
                                        <div class="col-sm-6">
                                        <div class="pull-right">
                                        <div class="row">
                                        <div class="col-sm">
                                         
                                         <i class="fa fa-arrow-circle-up btn-primary white btn-style"><asp:Button ID="btnUP" runat="server" CssClass="btn btn-success btn-icon icon-lg "
                                                        OnClientClick="MoveUp();return false;" Style="visibility: hidden" /></i>
                                        </div>
                                        <div class="col-sm">
                                          <i class="fa fa-arrow-circle-down btn-primary white btn-style"><asp:Button ID="btnDown" runat="server" CssClass="btn btn-success btn-icon icon-lg fa fa-plus"
                                                        OnClientClick="MoveDown();return false;" Style="visibility: hidden" /></i>
                                        </div>
                                         
                                        </div>                

                                               </div>
                                           
                                                 <div class="table-responsive">
                                                    <div id="divGrid">
                                                    </div>
                                               
                                                
                                                
                                            </div>
                                        </div>
                                      
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-9 col-sm-offset-3">
                                            <asp:Button ID="btnAddIndex" runat="server" Text="Add" CssClass="btn btn-primary"
                                                OnClientClick="AddIndex();
                  return false;" TagName="Read" />
                                        </div>
                                    </div>
                                    <div class="row">
                                        
                                    </div>
                                </div>
                            </div>
                            <div id="demo-lft-tab-2" class="tab-pane fade">
                                <div class="row">
                                    <h4>
                                        Tag Details <span class="AstrickStyle" style="color:red">&nbsp;*</span></h4>
                                        
                                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                        <ContentTemplate>
                                            <div class="col-sm-6">
                                                <div class="form-inline form-group ">
                                                    <asp:TextBox ID="txtMainTagValue" runat="server" CssClass="form-control" placeholder="Main Tag"></asp:TextBox>
                                                    <asp:Button ID="btnAddMainTag" runat="server" CssClass="btn btn-success white btn-icon icon-lg fa fa-plus"
                                                        Text="+" OnClientClick="AddMainTag();return false;" TagName="Read" /><asp:Button
                                                            ID="btnRemoveMainTag" runat="server" CssClass="btn btn-danger white btn-icon icon-lg fa fa-minus"
                                                            Text="-" OnClientClick="DeleteMainTag();return false;" TagName="Read" />
                                                </div>
                                                <asp:ListBox ID="lstMainTag" runat="server" CssClass="form-control"></asp:ListBox>
                                            </div>
                                            <div class="col-sm-6">
                                                <div class="form-inline form-group ">
                                                    <asp:TextBox ID="txtSubTagValue" runat="server" CssClass="form-control" placeholder="Sub Tag"></asp:TextBox>
                                                    <asp:Button ID="btnAddSubTag" runat="server" Text="+" CssClass="btn btn-success white btn-icon icon-lg fa fa-plus"
                                                        OnClientClick="AddSubTag();return false;" TagName="Read" /><asp:Button ID="btnRemoveSubTag"
                                                            runat="server" CssClass="btn btn-danger white btn-icon icon-lg fa fa-minus" Text="-"
                                                            OnClientClick="DeleteSubTag();return false;" TagName="Read" />
                                                </div>
                                                <asp:ListBox ID="lstSubTag" runat="server" CssClass="form-control"></asp:ListBox>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <div class="form-group">
                                                        <asp:Button ID="btnManageTag" runat="server" TagName="Read" Style="visibility: hidden"
                                                            OnClick="btnManageList_Click" CausesValidation="False" UseSubmitBehavior="False" /><asp:HiddenField
                                                                ID="hdnTagAction" runat="server" Value="" />
                                                        <asp:HiddenField ID="hdnIsCopied" runat="server" Value="" />
                                                        <asp:HiddenField ID="HdnTagdetails" runat="server" Value="" />
                                                    </div>
                                                </div>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                            <div id="demo-lft-tab-3" class="tab-pane fade">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <label class="col-lg-6 control-label">
                                                Upload File Name Format (for bulk upload)
                                            </label>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-inline form-group ">
                                            <label class="col-lg-3 control-label">
                                                Field</label>
                                            <asp:DropDownList ID="cmbIndexNames" runat="server" Width="20%" CssClass="form-control input-md">
                                                <asp:ListItem Value="0">--select--</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:Button ID="btnAddIndexName" runat="server" Width="5%" CssClass="btn btn-success white btn-icon icon-lg fa fa-plus"
                                                Text="+" TagName="Read" OnClientClick="AddIndexNametotxt();  return false;" />
                                        </div>
                                        <div class="form-inline form-group ">
                                            <label class="col-lg-3 control-label">
                                                Separator</label>
                                            <asp:DropDownList ID="cmbSeperator" runat="server" Width="20%" CssClass="form-control input-md">
                                                <asp:ListItem Value="0">--select--</asp:ListItem>
                                                <asp:ListItem>-</asp:ListItem>
                                                <asp:ListItem>#</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:Button ID="btnAddSeperator" runat="server" Width="5%"  CssClass="btn btn-success  white btn-icon icon-lg fa fa-plus"
                                                Text="+" TagName="Read" OnClientClick="AddSeperatortotxt();   return false;" />
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group form-inline">
                                            <label class="col-lg-3 control-label">
                                                File Name will look like</label>
                                            <asp:TextBox ID="txtFileName" runat="server" Width="20%" CssClass="form-control"></asp:TextBox>
                                            <asp:Button ID="btnCleartxtFileName" runat="server" Width="5%" Text="Clear" CssClass="btn btn-primary"
                                                TagName="Read" OnClientClick="CleartxtFileName(); return false;" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="demo-lft-tab-4" class="tab-pane fade">
                                <div class="row">
                                    <asp:UpdatePanel ID="tageditpanel" runat="server">
                                        <ContentTemplate>
                                            <div id="Divtag" runat="server" style="color: Green; font-family: Calibri; font-size: small">
                                                &nbsp;</div>
                                            <div class="col-sm-12">
                                                <div class="form-group">
                                                    <asp:Label ID="lblmaintag" CssClass="col-lg-2 control-label" runat="server" Text="Main Tag Name"></asp:Label>
                                                    <div class="col-sm-3">
                                                        <asp:DropDownList ID="ddlMaintag" runat="server" CssClass="form-control">
                                                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <asp:TextBox ID="txtmaintag" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <i class="fa fa-save btn-style white btn-success"><asp:Button ID="btntagnamesave" runat="server" CssClass="btn btn-success white btn-icon icon-lg fa fa-plus"
                                                            Text="Save" OnClick="btntagnamesave_Click" /></i>
                                                    </div>
                                                </div>
                                            </div>
                                            <br /><br /><br />
                                            <div class="col-sm-12">
                                                <div class="form-group ">
                                                    <asp:Label ID="lblsubtag" CssClass="col-lg-2 control-label" runat="server" Text="Sub Tag Name"></asp:Label>
                                                    <div class="col-sm-3">
                                                        <asp:DropDownList ID="ddlsubtag" runat="server" CssClass="form-control">
                                                            <asp:ListItem Value="0">--Select--</asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <asp:TextBox ID="txtsubtag" runat="server" CssClass="form-control"></asp:TextBox>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <i class="fa fa-save btn-style white btn-success"><asp:Button ID="btnsubtagsave" runat="server" CssClass="btn btn-success white btn-icon icon-lg fa fa-plus"
                                                            Text="Save" OnClick="btnsubtagsave_Click" /></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </div>
                <!--Default Tabs (Left Aligned)-->
                <!--===================================================-->
                <!--===================================================-->
            </div>
        </div>
    </div>
   </div>
    <div class="panel-footer">
     <div class="row">
                
                <div class="col-md-6" >
    <div style="float:left; padding-right:3px">
    <i class="fa fa-save btn-success btn-style white"> 
        <asp:Button ID="btnsubmit" 
            runat="server" Text="Submit" CssClass="btn btn-primary"
            OnClientClick="Submit(); return false;" TagName="Edit" /></i>
            
        <i class="fa fa-close btn-style white btn-danger"><asp:Button ID="btncancel" runat="server" Text="Cancel" CssClass="btn btn-danger"
            OnClick="btnCancel_Click" TagName="Read" /></i>
      </div>
            <div style="float:left;" id="divhide" runat="server">
                            <i class="fa fa-search btn-style btn-primary white ">
        <asp:Button ID="btnsearchagain" runat="server" Text="Search Again" CssClass="btn btn-primary"
            TagName="Read" OnClick="btnsearchagain_Click" /></i>
            </div>
              <asp:Button ID="btnClearAll" runat="server" TagName="Read" Style="visibility: hidden"
            CausesValidation="False" UseSubmitBehavior="False" OnClick="btnClearAll_Click" />
            </div>
            </div>
        
       
        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
        <asp:HiddenField ID="hdnPageId" runat="server" Value="" />
        <asp:HiddenField ID="hdnAction" runat="server" Value="" />
        <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
        <asp:HiddenField ID="hdnCurrentTemplateId" runat="server" Value="" />
        <asp:HiddenField ID="hdnIndexName" runat="server" Value="" />
        <asp:HiddenField ID="hdnEditIndex" runat="server" Value="" />
        <asp:HiddenField ID="hdnClearFileName" runat="server" Value="" />
    </div>
</asp:Content>
