<%@ Page Theme=""  ValidateRequest="false"  Language="C#" AutoEventWireup="true" CodeFile="PatientPartograph.aspx.cs" Inherits="HIMS_Inpatients_Inpatients_Reports_PatientPartograph" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="TraceBizCommon.Configuration" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<!DOCTYPE html>
<html>
<head>
    <title>Patient Partograph </title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
     <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.7.0/chart.min.js"></script>

    <style>
        .container {
    display: flex;
    flex-direction: column;
    justify-content: space-between; 
    align-items: stretch; 
    height: 100%; 
}

.container > div {
    flex: 2; 
    margin: 20px;
}
#gridContainer {
    display: flex;
    margin-left: 2px;
    height: 40px;
    overflow: hidden;
    padding-left: 20px; 
    margin-left: -20px;
}

#gridTitle {
    font-size: 15px;
    margin-left: 1px;
    align-self: center;
    white-space: nowrap; 
    writing-mode: vertical-rl; 
    transform: rotate(180deg); 
    transform-origin: center; 
}

#leftLabels {
    display: flex;
    flex-direction: column;
    align-items: flex-end;
    justify-content: space-between;
    margin-left: 20px; 
}
#ContractionCanvas {
    margin-left: 60px; 
}
#leftLabels div {
    font-size: 14px;
}
#legendContainer {
    display: flex;
    align-items: center;
}


#legendLabels div {
    font-size: 20px; 
    margin-top: 0px; 
}
#fetalHeartRateChart{
    margin-left : 60px
}
#cervicalDescentChart{
    margin-left : 60px
}
#gridCanvas{
    margin-left : -10px
}
#VitalsChart{
    margin-left : 60px
}
#UrineCanvas{
    margin-left : -10px
}
#OxytocinCanvas{
    margin-left : -10px
}
#KeyCanvas{
    margin-left: 150px
}

    </style>
</head>
<body>
       <div class="detail-header">
        <h1>Patient Partograph</h1>
        <p> <span id="PatientNumber"></span> &nbsp &nbsp &nbsp &nbsp <span id ="Name"></span> &nbsp &nbsp &nbsp &nbsp <span id ="Age"></span></p>
        <p> <span id = "EDD"></span> &nbsp &nbsp &nbsp &nbsp <span id="Presentation"></span> &nbsp &nbsp &nbsp &nbsp <span id="Lie"></span></p>
        <p> <span id = "RupturedHrs"></span> &nbsp &nbsp &nbsp &nbsp <span id = "Hrs"></span></p>
    </div>
    <div class="container">
        <div>
            <canvas id="fetalHeartRateChart" width="700" height="300"></canvas>
        </div>
        <div>
            <canvas id="gridCanvas" ></canvas>
        </div>
        <div>
            <canvas id="cervicalDescentChart" width="700" height="300"></canvas>
        </div>
          <div>
            <canvas id="TimeCanvas"></canvas>
        </div>
       <div id="gridContainer"> 
        <div id="gridTitle">(Contractions per 10 minutes)</div>
        <div id="leftLabels">
        <div>5</div>
        <div>4</div>
        <div>3</div>
        <div>2</div>
        <div>1</div>
         </div>
          <canvas id="ContractionCanvas"></canvas>
        </div>
        <div>
            <canvas id="KeyCanvas"></canvas>
        </div>
        <div>
            <canvas id="OxytocinCanvas" ></canvas>
        </div>
        <div>
            <canvas id="VitalsChart" width="700" height="300"></canvas>
        </div>
        <div>
            <canvas id="UrineCanvas" ></canvas>
        </div>

          <div class="SummaryOfLabour">
            <h1>Summary Of Labour</h1>
            <div id="patientSummaryData">

            </div>
            </div>
          </div>
    <input type="hidden" id="partographDataHiddenField" runat="server" />
    <input type="hidden" id="labourSummaryHiddenField" runat="server" />

     <script>
        var labels = ['0h', '1h', '2h', '3h', '4h', '5h', '6h', '7h', '8h', '9h', '10h', '11h', '12h'];

     
         var hiddenField = document.getElementById('<%= partographDataHiddenField.ClientID %>');

         var HiddenF = document.getElementById('<%= labourSummaryHiddenField.ClientID %>');

         var laboursummary = HiddenF.value;
         var parsedlabourSummary = JSON.parse(laboursummary)
         console.log(laboursummary)

         function populateCharts() {
             var partographData = hiddenField.value;
             var parsedPartographData = JSON.parse(partographData);
             console.log(parsedPartographData)

             var FetalHeartRateData = JSON.parse(parsedPartographData.fetalHeartRateData);
             var CervicalDilationData = JSON.parse(parsedPartographData.cervicalDilationData);
             var HeadDescentData = JSON.parse(parsedPartographData.headDescentData);
             var TempData = JSON.parse(parsedPartographData.TempData);
             var PulseData = JSON.parse(parsedPartographData.PulseData);
             var Contractions = JSON.parse(parsedPartographData.Contractions);
             var ContractionType = JSON.parse(parsedPartographData.ContractionType);
             var Age = JSON.parse(parsedPartographData.Age);
             var PatientName = JSON.parse(parsedPartographData.PatientName);
             var Membranes = JSON.parse(parsedPartographData.Membranes);
             var PatientNumber = JSON.parse(parsedPartographData.PatientNumber);
             var Edd = JSON.parse(parsedPartographData.EDD);
             var ActionTs = JSON.parse(parsedPartographData.ActionTs);
             var ProteinData = JSON.parse(parsedPartographData.Protein);
             var AcetoneData = JSON.parse(parsedPartographData.Acetone);
             var VolumeData = JSON.parse(parsedPartographData.Volume);
             var OxytocinData = JSON.parse(parsedPartographData.Oxytocin);
             var Lie = JSON.parse(parsedPartographData.Lie);
             var Presentation = JSON.parse(parsedPartographData.Presentation);
             var MotherDiastolic = JSON.parse(parsedPartographData.MotherDiastolic);
             var MotherSystolic = JSON.parse(parsedPartographData.MotherSystolic);
             var Rupture = JSON.parse(parsedPartographData.Ruptured);
             var DropsData = JSON.parse(parsedPartographData.Drops);

             console.log(Rupture);
             let pn = document.getElementById("Name");
             pn.innerText = "Patient Name: " + PatientName
             let Ag = document.getElementById("Age");
             Ag.innerText = "Age: " + Age 
             let Lil = document.getElementById("Lie");
             Lil.innerText = "Lie: " + Lie
             let Pr = document.getElementById("Presentation");
             Pr.innerText = "Presentation: " + Presentation
             let RH = document.getElementById("RupturedHrs");
             RH.innerText = "Ruptured Membranes: " + Membranes
             let Hrs = document.getElementById("Hrs");
             Hrs.innerText = "Hrs: " + Rupture          
             //let Adm = document.getElementById("Adm")
             //Adm.innerText = "Admission Date:" + AdmDate
             //let Gravda = document.getElementById("Gravida")
             //Gravda.innerText = "Gravida:" + Gravida
             let EDD = document.getElementById("EDD")
             EDD.innerText = "EDD:" + Edd
             let PatientNo = document.getElementById("PatientNumber")
             PatientNo.innerText = "PatientNumber: " + PatientNumber
             var formattedTimeArray = [];

             for (var i = 0; i < ActionTs.length; i++) {
                 var inputDate = ActionTs[i];
                 var date = new Date(inputDate);
                 var hours = date.getHours();
                 var minutes = date.getMinutes();
                 var formattedTime = hours.toString().padStart(2, '0') + ":" + minutes.toString().padStart(2, '0');
                 formattedTimeArray.push(formattedTime);
             }
             console.log(formattedTimeArray);

             for (let i = 0; i < FetalHeartRateData.length; i++) {
                 if (FetalHeartRateData[i] === "") {
                     FetalHeartRateData[i] = NaN;
                 }
             }

             for (let i = 1; i < FetalHeartRateData.length; i++) {
                 if (isNaN(FetalHeartRateData[i]) && !isNaN(FetalHeartRateData[i - 1])) {
                     FetalHeartRateData[i] = NaN;
                 }
             }

             new Chart(document.getElementById('fetalHeartRateChart').getContext('2d'), {
                 type: 'line',
                 data: {
                     labels: formattedTimeArray,
                     datasets: [{
                         label: 'Fetal Heart Rate',
                         data: FetalHeartRateData,
                         borderColor: 'rgba(75, 192, 192, 1)',
                         fill: false
                     }]
                 },
                 options: {
                     responsive: false,
                     maintainAspectRatio: false,
                     title: {
                         display: true,
                         text: 'Fetal Heart Rate Chart',
                         position: 'top'
                     },
                     spanGaps: true, 
                 }
             });



             for (let i = 0; i < CervicalDilationData.length; i++) {
                 if (CervicalDilationData[i] === "") {
                     CervicalDilationData[i] = NaN;
                 }
             }

             for (let i = 0; i < HeadDescentData.length; i++) {
                 if (HeadDescentData[i] === "") {
                     HeadDescentData[i] = NaN;
                 }
             }
             
             var CervixTime = formattedTimeArray.slice();
             const findStartingPoint = function (CervicalDilationData,CervixTime, HeadDescentData,marker) {

                 lowerBound = marker[0].y 
                 upperBount = marker[1].y
                 let range = [];
                 for (let i = lowerBound; i <= upperBount; i++) {
                     range.push(i);
                 }

                 const elementToMatch = CervicalDilationData[0];
                 const matchIndex = range.findIndex(element => element === parseInt(elementToMatch));
                 for (let i = 0; i < matchIndex; i++) {
                     CervicalDilationData.unshift(NaN);
                     HeadDescentData.unshift(NaN);
                     CervixTime.unshift(0);
                 }   
                 return CervicalDilationData
                 return HeadDescentData
                 return CervixTime
             }

             let marker = [
                 { x: '4h', y: 4 },
                 { x: '10h', y: 10 }
             ]

             findStartingPoint(CervicalDilationData,CervixTime, HeadDescentData,marker)

             new Chart(document.getElementById('cervicalDescentChart').getContext('2d'), {
                 type: 'line',
                 data: {
                     labels: labels,
                     datasets: [
                         {
                             label: 'Cervical Dilation',
                             data: CervicalDilationData,
                             borderColor: 'rgba(255, 99, 132, 1)',
                             fill: false,
                             usePointStyle: true,
                             pointStyle: 'circle',
                             pointRadius: 5,
                         },
                         {
                             label: 'Head Descent',
                             data: HeadDescentData,
                             borderColor: 'black',
                             fill: false,
                             usePointStyle: true,
                             pointStyle: 'crossRot',
                             pointRadius: 5,
                         },
                         {
                             label: 'Alert Line',
                             data: [
                                 { x: '0h', y:4 },
                                 { x: '6h', y: 10 }
                             ],
                             borderColor: 'red',
                             borderWidth: 2,
                             borderDash: [5],
                             fill: false
                         },
                         {
                             label: 'Action Line',
                             data: [
                                 { x: '4h', y: 4 },
                                 { x: '10h', y: 10 }
                             ],
                             borderColor: 'rgba(0, 255, 0, 1)',
                             borderWidth: 2,
                             borderDash: [5],
                             fill: false
                         }
                     ]
                 },
                 options: {
                     responsive: false,
                     maintainAspectRatio: false,
                     scales: {
                         y: {
                             min: 0,
                             max: 10,
                             ticks: {
                                 stepSize: 1 
                             }
                         }
                     },
                     plugins: {
                         legend: {
                             labels: {
                                 usePointStyle: true
                             }
                         },
                     },
                     elements: {
                         line: {
                             tension: 0
                         },
                     },
                     spanGaps: true, 
                 },
             });


             for (let i = 0; i < TempData.length; i++) {
                 if (TempData[i] === "") {
                     TempData[i] = NaN;
                 }
             }

             for (let i = 0; i < PulseData.length; i++) {
                 if (PulseData[i] === "") {
                     PulseData[i] = NaN;
                 }
             }

             for (let i = 0; i < MotherDiastolic.length; i++) {
                 if (MotherDiastolic[i] === "") {
                     MotherDiastolic[i] = NaN;
                 }
             }
             for (let i = 0; i < MotherSystolic.length; i++) {
                 if (MotherSystolic[i] === "") {
                     MotherSystolic[i] = NaN;
                 }
             }

             new Chart(document.getElementById('VitalsChart').getContext('2d'), {
                 type: 'line',
                 data: {
                     labels: formattedTimeArray,
                     datasets: [
                         {
                             label: 'Mother Temperature',
                             data: TempData,
                             borderColor: 'rgba(255, 99, 132, 1)',
                             fill: false
                         },
                         {
                             label: 'Mother Pulse',
                             data: PulseData,
                             borderColor: 'rgba(54, 162, 235, 1)',
                             fill: false
                         },
                        {
                             label: 'Mother Diastolic',
                             data: MotherDiastolic,
                             borderColor: 'green',
                             fill: false
                         },
                        {
                             label: 'Mother Systolic',
                             data: MotherSystolic,
                             borderColor: 'black',
                             fill: false
                         }
                     ]
                 },
                 options: {
                     responsive: false,
                     maintainAspectRatio: false,
                     spanGaps: true, 
                 }
             });



             const ctx = document.getElementById('ContractionCanvas').getContext('2d');
             const cellSize = 42;
             const numRows = 5;
             const numCols = 16;      
             var Contractions = JSON.parse(parsedPartographData.Contractions);
             var ContractionType = JSON.parse(parsedPartographData.ContractionType);
             ctx.canvas.width = numCols * cellSize;
             ctx.canvas.height = numRows * cellSize;

             for (let i = 0; i < numRows; i++) {
                 for (let j = 0; j < numCols; j++) {
                     const x = j * cellSize;
                     const y = (numRows - 1 - i) * cellSize;

                     ctx.strokeStyle = 'black';
                     ctx.strokeRect(x, y, cellSize, cellSize);

                     const contractionValue = Contractions[j];
                     const adjustedContractionValue = contractionValue - 1;
                     const shadingType = ContractionType[j];
                     const shouldShade = adjustedContractionValue >= i;

                     if (shouldShade) {
                         if (shadingType === 'Shaded') {
                             ctx.fillStyle = 'black';
                             ctx.fillRect(x, y, cellSize, cellSize);
                         } else if (shadingType === 'Dotted') {
                             ctx.fillStyle = 'black';
                             ctx.fillRect(x + cellSize / 2 - 2, y + cellSize / 2 - 2, 4, 4);
                         } else if (shadingType === 'Striped') {
                             ctx.fillStyle = 'black';
                             for (let k = 0; k < cellSize; k += 5)
                             {
                                 ctx.fillRect(x + k, y, 2, cellSize);
                             }
                         }
                     }
                 }
             }

             const canvas = document.getElementById("gridCanvas");
             const con = canvas.getContext("2d");
             canvas.width = 750;
             canvas.height = 75;
             var MouldingData = JSON.parse(parsedPartographData.Moulding);
             var LiquorData = JSON.parse(parsedPartographData.Liquor);
             const timeData = formattedTimeArray;
             const NumRows = 3;
             const NumCols = 10;
             const labelWidth = 100;
             const cellWidth = (canvas.width - labelWidth) / NumCols;
             const cellHeight = canvas.height / NumRows;
             const rowLabels = ["Moulding", "Liquor","Time"];

             con.font = "16px Arial";
             con.fillStyle = "black";

             for (let row = 0; row < NumRows; row++) {
                 const label = rowLabels[row];
                 const x = 10;
                 const y = row * cellHeight + cellHeight / 2;

                 con.fillText(label, x, y);
             }

             con.strokeStyle = "black";
             con.lineWidth = 1;
             const gridXOffset = labelWidth;

             for (let row = 0; row < NumRows; row++) {
                 for (let col = 0; col < NumCols; col++) {
                     const x = col * cellWidth + gridXOffset;
                     const y = row * cellHeight;

                     con.strokeRect(x, y, cellWidth, cellHeight);

                     if (row === 0 && col < MouldingData.length) {
                         con.fillText(`${MouldingData[col]}`, x + 5, y + 20);
                     } else if (row === 1 && col < LiquorData.length) {
                         con.fillText(LiquorData[col], x + 5, y + 20);
                     }
                     else if (row === 2) {                        
                         if (col < timeData.length) {
                             con.fillText(timeData[col], x + 5, y + 20);
                         }
                     }
                 }
             }

             const canvas2 = document.getElementById("UrineCanvas");
             const cons = canvas2.getContext("2d"); 
             canvas2.width = 750;
             canvas2.height = 100;
             var ProteinData = ProteinData;
             var AcetoneData = AcetoneData;
             var VolumeData = VolumeData;
             const TimeData = formattedTimeArray;
             const NumRowss = 4;
             const NumColss = 12;
             const LabelWidth = 100; 
             const CellWidth = (canvas2.width - LabelWidth) / NumColss; 
             const CellHeight = canvas2.height / NumRowss; 
             const RowLabels = ["Time", "Protein", "Acetone", "Volume"]; 

             cons.font = "14px Arial";
             cons.fillStyle = "black";

             for (let row = 0; row < NumRowss; row++) {
                 const label = RowLabels[row]; 
                 const x = 10;
                 const y = row * CellHeight + CellHeight / 2;

                 cons.fillText(label, x, y);
             }

             cons.strokeStyle = "black";
             cons.lineWidth = 1;
             const gridxOffset = LabelWidth; 

             for (let row = 0; row < NumRowss; row++) {
                 for (let col = 0; col < NumColss; col++) {
                     const x = col * CellWidth + gridxOffset; 
                     const y = row * CellHeight;

                     cons.strokeRect(x, y, CellWidth, CellHeight);

                     if (row === 0 && col < TimeData.length) {
                         cons.fillText(TimeData[col], x + 5, y + 20);
                     } else if (row === 1 && col < ProteinData.length) {
                         cons.fillText(ProteinData[col], x + 5, y + 20);
                     } else if (row === 2 && col < AcetoneData.length) {
                         cons.fillText(AcetoneData[col], x + 5, y + 20);
                     } else if (row === 3 && col < VolumeData.length) {
                         cons.fillText(VolumeData[col], x + 5, y + 20);
                     }
                 }
             }

             var canva = document.getElementById("KeyCanvas");
             var context = canva.getContext("2d");
             canva.width = 200;
             canva.height = 50; 
             var rows = 2;
             var columns = 3;
             var CellsWidth1 = canva.width / columns;
             var CellsHeight1 = canva.height / rows;

             const shadingSequence = ['dotted', 'striped', 'shaded'];
             var shadingIndex = 0;
             context.fillStyle = 'black';
             context.font = 'bold 16px Arial';
             for (var row = 0; row < rows; row++) {
                 for (var col = 0; col < columns; col++) {
                     var x = col * CellsWidth1;
                     var y = row * CellsHeight1;
                     context.strokeRect(x, y, CellsWidth1, CellsHeight1);

                     if (row === 0) {
                         var text = "";
                         if (col === 0) {
                             text = "< 20 S";
                         } else if (col === 1) {
                             text = "20-40 S";
                         } else if (col === 2) {
                             text = "> 40 S";
                         }
                         context.fillText(text, x + 5, y + 20); 
                     } else if (row === 1) { 
                         if (shadingSequence[shadingIndex] === 'dotted') {
                             context.fillStyle = 'black';
                             context.fillRect(x + CellsWidth1 / 2 - 2, y + CellsHeight1 / 2 - 2, 4, 4);
                         } else if (shadingSequence[shadingIndex] === 'striped') {
                             context.fillStyle = 'black';
                             for (let k = 0; k < CellsWidth1; k += 5) {
                                 context.fillRect(x + k, y, 2, CellsHeight1);
                             }
                         } else if (shadingSequence[shadingIndex] === 'shaded') {
                             context.fillStyle = 'black';
                             context.fillRect(x, y, CellsWidth1, CellsHeight1);
                         }

                         shadingIndex = (shadingIndex + 1) % shadingSequence.length;
                     }
                 }
             }

             const canvas3 = document.getElementById("OxytocinCanvas");
             const cons1 = canvas3.getContext("2d");
             canvas3.width = 750;
             canvas3.height = 50;
             var OxytocinData = OxytocinData;
             var DropsData = DropsData;
             const numRowss = 2;
             const numColss = 12;
             const LabelsWidth = 100; 
             const CellsWidth = (canvas3.width - LabelsWidth) / numColss; 
             const CellsHeight = canvas3.height / numRowss; 
             const Rowlabels = ["Oxytocin U/L","Drops/min"];

             cons1.font = "14px Arial";
             cons1.fillStyle = "black";

             for (let row = 0; row < numRowss; row++) {
                 const label = Rowlabels[row];
                 const x = 10;
                 const y = row * CellsHeight + CellsHeight / 2;

                 cons1.fillText(label, x, y);
             }

             cons1.strokeStyle = "black";
             cons1.lineWidth = 1;
             const GridxOffset = LabelsWidth; 

             for (let row = 0; row < numRowss; row++) {
                 for (let col = 0; col < numColss; col++) {
                     const x = col * CellsWidth + GridxOffset;
                     const y = row * CellsHeight;

                     cons1.strokeRect(x, y, CellsWidth, CellsHeight);

                     if (row === 0 && col < OxytocinData.length) {
                         cons1.fillText(OxytocinData[col], x + 5, y + 20);
                     }else if (row === 1 && col < DropsData.length) {
                         cons1.fillText(DropsData[col], x + 5, y + 20);
                     }
                 }
             }
             const cnv = document.getElementById("TimeCanvas");
             const cn = cnv.getContext("2d");
             cnv.width = 750;
             cnv.height = 25;
             var TimesData = CervixTime;
             var NR = 1;
             var NC = 12;
             var LW = 80;
             var CW = (cnv.width - LW) / NC;
             var CH = cnv.height / NR;
             var RW = ["Time"];

             cn.font = "16px Arial";
             cn.fillStyle = "black";

             for (let row = 0; row < NR; row++) {
                 const label = RW[row];
                 const x = 10;
                 const y = row * CH + CH / 2;

                 cn.fillText(label, x, y);
             }

             cn.strokeStyle = "black";
             cn.lineWidth = 1;
             const gridXOffsets = LW;

             for (let row = 0; row < NR; row++) {
                 for (let col = 0; col < NC; col++) {
                     const x = col * CW + gridXOffsets;
                     const y = row * CH;

                     cn.strokeRect(x, y, CW, CH);

                     if (row === 0 && col < TimesData.length) {
                         cn.fillText(`${TimesData[col]}`, x + 5, y + 20);
                     }
                 }
             }

         }


         var patientSummaryData = parsedlabourSummary;

         
         for (var field in patientSummaryData) {
             if (typeof patientSummaryData[field] === 'string') {
                 patientSummaryData[field] = patientSummaryData[field].replace(/"/g, '');
             }
         }

         function populatePatientSummary() {
             var summaryDataDiv = document.getElementById("patientSummaryData");
             var summaryHTML = "<ul>";

             for (var field in patientSummaryData) {
                 summaryHTML += "<li><b>" + field + ":</b> " + patientSummaryData[field] + "</li>";
             }

             summaryHTML += "</ul";

             summaryDataDiv.innerHTML = summaryHTML;
         }

         populatePatientSummary();

         document.addEventListener("DOMContentLoaded", function ()
         {
             populateCharts();
         });

     </script>
</body>
</html>
