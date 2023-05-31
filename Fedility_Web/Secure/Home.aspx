<%@ Page Title="" Language="C#" MasterPageFile="~/doQman.Master" AutoEventWireup="true"
    CodeBehind="Home.aspx.cs" Inherits="Lotex.EnterpriseSolutions.WebUI.Home" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
    $(document).ready(function () {
    LoadDashBoards();

    });
  function LoadDashBoards() {
     //alert(1);
       $.ajax({
                    type: "POST",
                    url: "Home.aspx/ConvertDataTabletoString",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    data: "{}",
                    async: "true",
                    success: function (response) {
                        var obj = $.parseJSON(response.d);
                        var myTable= "<div class='row'>";
                        var myTableclose="</div>";
                        var divbody='';
                        for (i=0; i < obj.length; i++){
                            var renderTable='';
                            var finalrender='';
                            var canv = document.createElement('canvas');
                            canv.id = i;
                            if (obj[i].legents!= '') {
                            var Xlabels=obj[i].labels.split(',');
                            var legents=obj[i].legents.split(',');
                            var str = '<ul style="list-style-type:disc">';
                            var div='';
                            for(legent=0;legent<Xlabels.length;legent++){
                               str += '<li style="font-size: 15px;color: black;"><a  style="color: black;"><b>'+Xlabels[legent]+":"+legents[legent]+'</b></a></li>';
                            }

                            str += '</ul>';
                            div="<div id='container1'><div class='bubble'><div class='rectangle'><h2>Legend</h2></div><div class='triangle-l'></div><div class='triangle-r'></div><div class='info'><p>"+str+"</p></div></div></div>"
                            }
                            else {
                                str='';
                                div='';
                                }
                            

                          
                            var tablestructure="<div class='col-md-6' ><canvas id='"+canv.id+"'></canvas></div>";
                            if (i%2==0) {
                         
                            renderTable=myTable+tablestructure;
                            finalrender=renderTable;
                            if (i==0) {
                            divbody=finalrender
                            }
                            else {
                            divbody =divbody+finalrender;
                            }  
                            
                           
                            
                                                        }
                                                        else {
                                                      
                                                        finalrender=divbody+tablestructure+myTableclose;
                                                        divbody =finalrender;
 
                                                        }
                                                       
                                                     
                            
                    
                        }
                        document.getElementById('tablePrint').innerHTML=divbody
                         dashboardline(obj);
                       
                        },
                    failure: function (response) {
                        alert(response.d);
                        
                    }
                });
                }

   
                
                
        function dashboardline(obj) {
          for (i=0; i < obj.length; i++){
          var labelnames=obj[i].label;
          var Xvalues=obj[i].labels;
          var Yvalues=obj[i].data;
          var type=obj[i].type;
          var colors=obj[i].Color;
        
          
           var SplitedYvalues=Yvalues.split('|');
           var SplitedXvalues=Xvalues.split(',');
           var labelname=labelnames.split('|');
           var dashboardcolor=colors.split('|');
           var color = Chart.helpers.color;
         
            var barChartData={
            labels:[],
             datasets: []
            };
             for (var index = 0; index < SplitedXvalues.length; ++index) {
           
                barChartData['labels'][index]=SplitedXvalues[index];
             
                }
            for (var indexy = 0; indexy < SplitedYvalues.length; ++indexy) {
            var chartcolor=dashboardcolor[indexy];
            barChartData['datasets'].push({"label":labelname[indexy],"backgroundColor":dashboardcolor[indexy],"borderColor":dashboardcolor[indexy],"borderWidth": 1,"data": []});
                        //barChartData['datasets'][indexy]="{label:"+labelname[indexy]+",backgroundColor:color(window.chartColors."+dashboardcolor[indexy]+").alpha(0.5).rgbString(),borderColor:window.chartColors."+dashboardcolor[indexy]+",borderWidth: 1,data: []}";
            var Ycoordinates=SplitedYvalues[indexy].split(',');
            
            for (var indexvalues = 0; indexvalues < Ycoordinates.length; indexvalues++) {
                
                barChartData['datasets'][indexy]['data'][indexvalues]=Ycoordinates[indexvalues]; 
            
                 } 
             }   
            var ctx = document.getElementById(i).getContext("2d");
            window.myBar = new Chart(ctx, {
                type: type,
                data: barChartData,
                options: {
                    responsive: true,
                    legend: {
                        position: 'top',
                    },
                    title: {
                        display: true
                    }
                }
            });
            }
        }
            </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder0" runat="server">
    <!--Page Title-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <div id="page-title">
        <h1 class="page-header text-overflow">
            Document Management System</h1>
    </div>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End page title-->
    <!--Breadcrumb-->
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <ol class="breadcrumb">
        <li><a href="#">Home</a></li>
        <li class="active">DMS</li>
    </ol>
    <!--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-->
    <!--End breadcrumb-->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    
     <div id="page-content">
        <div class="panel">
            <div class="panel-body">
   				 <div class="panel">
        <div class="panel-body">
            <div class="GVDiv" style=" padding-left: 50px; padding-right: 50px;">
                <h3>
                    <asp:Label ID="lblMessageHeader" runat="server" Text="Document Management System" ></asp:Label></h3>
              
                <asp:UpdatePanel ID="UpdatePanel5" runat="server" UpdateMode="Always" RenderMode="Inline">
                    <ContentTemplate>
                        <asp:HiddenField ID="hdnLoginOrgId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnPageRights" runat="server" Value="" />
                        <asp:HiddenField ID="hdnLoginToken" runat="server" Value="" />
                        <asp:HiddenField ID="hdnProcessId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnWorkflowId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnProcessName" runat="server" Value="" />
                        <asp:HiddenField ID="hdnWorkFlowName" runat="server" Value="" />
                        <asp:HiddenField ID="hdnStageName" runat="server" Value="" />
                        <asp:HiddenField ID="hdnStageId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnDataId" runat="server" Value="" />
                        <asp:HiddenField ID="hdnDataEntryType" runat="server" Value="" />
                        <asp:HiddenField ID="hdnAction" runat="server" Value="" />
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
    		</div>
        </div>
     </div>
    
</asp:Content>
