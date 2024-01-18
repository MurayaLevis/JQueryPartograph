using DevExpress.UnitConversion;
using DevExpress.Utils;
using DevExpress.XtraReports.Templates;
using DevExpress.XtraScheduler.iCalendar.Components;
using Newtonsoft.Json;
using RestSharp.Extensions;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Security.AccessControl;
using TraceBizCommon.Data;

public partial class HIMS_Inpatients_Inpatients_Reports_PatientPartograph : System.Web.UI.Page
{
    protected string CompanyID;
    protected string BranchID;
    protected string DepartmentID;
    protected string EmployeeID;
    protected string ConnectionString;
    string ServiceReference = "";
    public class PartographData
    {
        public string fetalHeartRateData { get; set; }
        public string cervicalDilationData { get; set; }
        public string headDescentData { get; set; }
        public string TempData { get; set; }
        public string PulseData { get; set; }
        public string Moulding { get; set; }
        public string Liquor { get; set; }
        public string ContractionType { get; set; }
        public string Contractions { get; set; }
        public string ActionTs { get; set; }
        public string PatientName { get; set; }
        public string Age { get; set; }
        public string Membranes { get; set; }
        public string Acetone { get; set; }
        public string Protein { get; set; }
        public string Volume { get; set; }
        public string Oxytocin { get; set; }
        public string Drops { get; set; }
        public string PatientNumber { get; set; }
        public string EDD { get; set; }
        public string Lie { get; set; }
        public string Presentation { get; set; }
        public string formattedTimeIntervals { get; set; }
        public string MotherDiastolic { get; set; }
        public string MotherSystolic { get; set; }
        public string Ruptured { get; set; }
    }

    public class LabourSummary
    {
        public string Induction { get; set; }
        public string DeliveryType { get; set; }
        public string DeliveryTime { get; set; }
        public string AMTSL { get; set; }
        public string Uterotocin { get; set; }
        public string Placenta { get; set; }
        public string Placentaweight { get; set; }
        public string Bloodloss { get; set; }
        public string Temp { get; set; }
        public string BP { get; set; }
        public string Pulse { get; set; }
        public string RR { get; set; }
        public string Babystatus { get; set; }
        public string BirthWeightInGrams{ get; set; }
        public string Sex { get; set; }
        public string Apgar { get; set; }
        public string ApgarScore5 { get; set; }
        public string Resuscitation { get; set; }
        public string DrugsGiven { get; set; }
        public string Deliveredby { get; set; }
      
    }

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);

        Hashtable SessionKey = (Hashtable)Session["SessionKey"];

        if (!Page.IsPostBack)
        {
            ViewState["ReferrerUrl"] = Request.UrlReferrer.ToString();
        }
        ServiceReference = Request.QueryString["OccupancyID"];
        CompanyID = SessionKey["CompanyID"].ToString();
        BranchID = SessionKey["BranchID"].ToString();
        DepartmentID = SessionKey["DepartmentID"].ToString();
        EmployeeID = SessionKey["EmployeeID"].ToString();
        ConnectionString = TraceBizCommon.Configuration.ConfigSettings.ConnectionString;

        PartographData partographData = LoadPartograph();
        string partographDataJSON = JsonConvert.SerializeObject(partographData);
        partographDataHiddenField.Value = partographDataJSON;
        Page.ClientScript.RegisterStartupScript(this.GetType(), "partographData", "var partographData = " + partographDataJSON + ";", true);

        LabourSummary labourSummary = LoadLabourSummary();
        string labourSummaryJSON = JsonConvert.SerializeObject(labourSummary);
        labourSummaryHiddenField.Value = labourSummaryJSON;
        Page.ClientScript.RegisterStartupScript(this.GetType(), "labourSummary", "var labourSummary = " + labourSummaryJSON + ";", true);
    }

    protected PartographData LoadPartograph()
    {
        string connectionString = TraceBizCommon.Configuration.ConfigSettings.ConnectionString;
        List<string> fetalHeartRateData = new List<string>();
        List<string> cervicalDilationData = new List<string>();
        List<string> headDescentData = new List<string>();
        List<string> TempData = new List<string>();
        List<string> PulseData = new List<string>();
        List<string> Liquor = new List<string>();
        List<string> Moulding = new List<string>();
        List<string> Contractions = new List<string>();
        List<string> ContractionType = new List<string>();
        List<string> ActionTs = new List<string>();
        List<string> Protein= new List<string>();
        List<string> Acetone = new List<string>();
        List<string> Volume = new List<string>();
        List<string> Oxytocin = new List<string>();
        List<string> Drops = new List<string>();
        List<string> MotherDiastolic = new List<string>();
        List<string> MotherSystolic = new List<string>();
        List<string> formattedTimeIntervals = new List<string>();
        String PatientName = "";
        String membranes = "";
        String Age = "";
        String PatientNumber = "";
        String EDD = "";
        String Lie = "";
        String Presentation = "";
        String Ruptured = "";

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand command = new SqlCommand("enterprise.PatientPartograph", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@CompanyID", SqlDbType.NVarChar).Value = CompanyID;
                command.Parameters.Add("@BranchID", SqlDbType.NVarChar).Value = BranchID;
                command.Parameters.Add("@DepartmentID", SqlDbType.NVarChar).Value = DepartmentID;
                command.Parameters.Add("@OccupancyID", SqlDbType.NVarChar).Value = ServiceReference;
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        fetalHeartRateData.Add(reader["FetalPulse"].ToString());
                        cervicalDilationData.Add(reader["Cervix"].ToString());
                        headDescentData.Add(reader["HeadDescent"].ToString());
                        TempData.Add(reader["Temp"].ToString());
                        PulseData.Add(reader["PT_Pulse"].ToString());
                        Liquor.Add(reader["Liquor"].ToString());
                        Moulding.Add(reader["Moulding"].ToString());
                        Contractions.Add(reader["ContractionsPer10Mins"].ToString());
                        ContractionType.Add(reader["ContractionType"].ToString()); ;
                        ActionTs.Add(reader["Time_Interval"].ToString());
                        Protein.Add(reader["Urine_Protein"].ToString());
                        Acetone.Add(reader["Urine_Acetone"].ToString());
                        Volume.Add(reader["Urine_Volume"].ToString());
                        Oxytocin.Add(reader["Oxytocin"].ToString());
                        Drops.Add(reader["FetalHeart_S"].ToString());
                        MotherDiastolic.Add(reader["PT_Heart_D"].ToString());
                        MotherSystolic.Add(reader["PT_Heart_S"].ToString());
                        PatientName = reader["PatientName"] == DBNull.Value ? "" : reader["PatientName"].ToString();
                        Age = reader["Age"] == DBNull.Value ? "" : reader["Age"].ToString();
                        membranes = reader["Membranes"] == DBNull.Value ? "" : reader["Membranes"].ToString();
                        PatientNumber = reader["PatientNumber"] == DBNull.Value ? "" : reader["PatientNumber"].ToString();
                        EDD = reader["ProcedureDate"] == DBNull.Value ? "" : reader["ProcedureDate"].ToString();
                        Lie = reader["Lie"] == DBNull.Value ? "" : reader["Lie"].ToString();
                        Presentation = reader["Presentation"] == DBNull.Value ? "" : reader["Presentation"].ToString();
                        Ruptured = reader["RupturedHrs"] == DBNull.Value ? "" : reader["RupturedHrs"].ToString();
                    }
                }

            }
        }

        return new PartographData
        {
            fetalHeartRateData = JsonConvert.SerializeObject(fetalHeartRateData),
            cervicalDilationData = JsonConvert.SerializeObject(cervicalDilationData),
            headDescentData = JsonConvert.SerializeObject(headDescentData),
            TempData = JsonConvert.SerializeObject(TempData),
            PulseData = JsonConvert.SerializeObject(PulseData),
            Liquor = JsonConvert.SerializeObject(Liquor),
            Moulding = JsonConvert.SerializeObject(Moulding),
            Contractions = JsonConvert.SerializeObject(Contractions),
            ContractionType = JsonConvert.SerializeObject(ContractionType),
            ActionTs = JsonConvert.SerializeObject(ActionTs),
            PatientName = JsonConvert.SerializeObject(PatientName),
            Age = JsonConvert.SerializeObject(Age),
            Membranes = JsonConvert.SerializeObject(membranes),
            Protein = JsonConvert.SerializeObject(Protein),
            Acetone = JsonConvert.SerializeObject(Acetone),
            Volume = JsonConvert.SerializeObject(Volume),
            Oxytocin = JsonConvert.SerializeObject(Oxytocin),
            PatientNumber = JsonConvert.SerializeObject(PatientNumber),
            EDD = JsonConvert.SerializeObject(EDD),
            Lie = JsonConvert.SerializeObject(Lie),
            Presentation = JsonConvert.SerializeObject(Presentation),
            formattedTimeIntervals = JsonConvert.SerializeObject(formattedTimeIntervals),
            MotherDiastolic = JsonConvert.SerializeObject(MotherDiastolic),
            MotherSystolic = JsonConvert.SerializeObject(MotherSystolic),
            Ruptured = JsonConvert.SerializeObject(Ruptured),
            Drops = JsonConvert.SerializeObject(Drops)
        };
    }

    protected LabourSummary LoadLabourSummary()
    {
        string connectionString = TraceBizCommon.Configuration.ConfigSettings.ConnectionString;
        String Induction = "";
        String DeliveryType = "";
        String DeliveryTime = "";
        String AMTSL = "";
        String Uterotocin = "";
        String Placenta = "";
        String PlacentaWeight = "";
        String BloodLoss = "";
        String Temp = "";
        String BP = "";
        String Pulse = "";
        String RR = "";
        String BabyStatus = "";
        String BirthWeight = "";
        String Sex = "";
        String Apgar = "";
        String ApgarScore5 = "";
        String Resuscitation = "";
        String DrugsGiven = "";
        String DeliveredBy = "";

        using (SqlConnection connection = new SqlConnection(connectionString))
        {
            using (SqlCommand command = new SqlCommand("enterprise.PatientPartograph", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@CompanyID", SqlDbType.NVarChar).Value = CompanyID;
                command.Parameters.Add("@BranchID", SqlDbType.NVarChar).Value = BranchID;
                command.Parameters.Add("@DepartmentID", SqlDbType.NVarChar).Value = DepartmentID;
                command.Parameters.Add("@OccupancyID", SqlDbType.NVarChar).Value = ServiceReference;
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        Induction = reader["Induction"] == DBNull.Value ? "" : reader["Induction"].ToString();
                        DeliveryTime = reader["Date"] == DBNull.Value ? "" : reader["Date"].ToString();
                        DeliveryType = reader["DeliveryType"] == DBNull.Value ? "" : reader["DeliveryType"].ToString();
                        AMTSL = reader["AMTSL"] == DBNull.Value ? "" : reader["AMTSL"].ToString();
                        Uterotocin = reader["Uterotocin"] == DBNull.Value ? "" : reader["Uterotocin"].ToString();
                        Placenta = reader["Placenta"] == DBNull.Value ? "" : reader["Placenta"].ToString();
                        PlacentaWeight = reader["PlacentaWeight"] == DBNull.Value ? "" : reader["PlacentaWeight"].ToString();
                        BloodLoss = reader["BloodLoss"] == DBNull.Value ? "" : reader["BloodLoss"].ToString();
                        Temp = reader["Temp"] == DBNull.Value ? "" : reader["Temp"].ToString();
                        BP = reader["BP"] == DBNull.Value ? "" : reader["BP"].ToString();
                        Pulse = reader["Pulse"] == DBNull.Value ? "" : reader["Pulse"].ToString();
                        RR = reader["RR"] == DBNull.Value ? "" : reader["RR"].ToString();
                        BabyStatus = reader["BabyStatus"] == DBNull.Value ? "" : reader["BabyStatus"].ToString();
                        BirthWeight = reader["BirthWeight"] == DBNull.Value ? "" : reader["BirthWeight"].ToString();
                        Sex = reader["Sex"] == DBNull.Value ? "" : reader["Sex"].ToString();
                        Apgar = reader["ApgarScore"] == DBNull.Value ? "" : reader["ApgarScore"].ToString();
                        ApgarScore5 = reader["ApgarScore_5"] == DBNull.Value ? "" : reader["ApgarScore_5"].ToString();
                        Resuscitation = reader["RescuscitationDone"] == DBNull.Value ? "" : reader["RescuscitationDone"].ToString();
                        DrugsGiven = reader["Drugs_Baby"] == DBNull.Value ? "" : reader["Drugs_Baby"].ToString();
                        DeliveredBy = reader["DeliveryConductedBy"] == DBNull.Value ? "" : reader["DeliveryConductedBy"].ToString();                      
                    }
                }

            }
        }

        return new LabourSummary
        {
            Induction = JsonConvert.SerializeObject(Induction),
            DeliveryTime = JsonConvert.SerializeObject(DeliveryTime),
            DeliveryType = JsonConvert.SerializeObject(DeliveryType),
            AMTSL = JsonConvert.SerializeObject(AMTSL),
            Uterotocin = JsonConvert.SerializeObject(Uterotocin),
            Placenta = JsonConvert.SerializeObject(Placenta),
            Placentaweight = JsonConvert.SerializeObject(PlacentaWeight),
            Bloodloss = JsonConvert.SerializeObject(BloodLoss),
            Temp = JsonConvert.SerializeObject(Temp),
            BP = JsonConvert.SerializeObject(BP),
            Pulse = JsonConvert.SerializeObject(Pulse),
            RR = JsonConvert.SerializeObject(RR),
            Babystatus = JsonConvert.SerializeObject(BabyStatus),
            BirthWeightInGrams = JsonConvert.SerializeObject(BirthWeight),
            Sex = JsonConvert.SerializeObject(Sex),
            Apgar = JsonConvert.SerializeObject(Apgar),
            ApgarScore5 = JsonConvert.SerializeObject(ApgarScore5),
            Resuscitation = JsonConvert.SerializeObject(Resuscitation),
            DrugsGiven = JsonConvert.SerializeObject(DrugsGiven),
            Deliveredby = JsonConvert.SerializeObject(DeliveredBy)
        };
    }
}