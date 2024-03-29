USE [SmartCare_EMR_DEV]
GO
/****** Object:  StoredProcedure [enterprise].[PatientPartograph]    Script Date: 10/30/2023 10:43:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [enterprise].[PatientPartograph]
(
    @CompanyID NVARCHAR(72),
    @BranchID NVARCHAR(36),
    @DepartmentID NVARCHAR(36),
	@PatientNumber NVARCHAR(36) = NULL,
	@OccupancyID NVARCHAR(36)= NULL
)
AS
------------------------------------------
DECLARE @Labour_Start_Time DATETIME = NULL
DECLARE @Labour_End_Time DATETIME = NULL
DECLARE @Start_Hour SMALLINT = 1
DECLARE @PatientName NVARCHAR(100) 
DECLARE @Age NVARCHAR(36)
DECLARE @RupturedHrs NVARCHAR(72)
DECLARE @Lie NVARCHAR(20)
DECLARE @Presentation NVARCHAR(20)
DECLARE @Induction NVARCHAR (72)
DECLARE @DeliveryMode NVARCHAR (20)
DECLARE @AMTSL NVARCHAR (36)
DECLARE @Uterotocin NVARCHAR (72)
DECLARE @Placenta NVARCHAR (72)
DECLARE @PlacentaWeight NVARCHAR (72)
DECLARE @BloodLoss NVARCHAR (20)
DECLARE @BP NVARCHAR (36)
DECLARE @Pulse NVARCHAR (36)
DECLARE @RR NVARCHAR (72)
DECLARE @BabyStatus NVARCHAR (36)
DECLARE @BirthWeight NVARCHAR (36)
DECLARE @Sex NVARCHAR (36)
DECLARE @Apgar NVARCHAR (36)
DECLARE @ApgarScore5 NVARCHAR (36)
DECLARE @Resuscitation NVARCHAR (36)
DECLARE @DrugsGiven NVARCHAR (72)
DECLARE @DeliveredBy NVARCHAR (36)
DECLARE @DeliveryTime NVARCHAR (36)
DECLARE @EDD DATETIME
DECLARE @AdmissionDate DATETIME


SELECT TOP 1 
	@PatientNumber = BO.CustomerID,
	@PatientName = PT.PatientName,
	@Age = Age,
	@AdmissionDate= BO.ActualAdmissionDate,
	@EDD = PT.ANC_EDD
FROM 
	dbo.BedOccupancy BO with(nolock) LEFT JOIN CustomerInformation PT with(nolock) ON
	BO.CompanyID = PT.CompanyID
	AND BO.CustomerID = PT.CustomerID
WHERE
	BO.CompanyID=@CompanyID AND BO.BranchID=@BranchID AND BO.DepartmentID=@DepartmentID
	AND ISNULL(BO.OccupancyID,'')=@OccupancyID

SELECT TOP 1 
     @Induction = InductionOfLabour,
     @DeliveryMode = DeliveryType,
     @AMTSL = AMTSL,
     @Uterotocin = Uterotocin,
	 @Placenta = Placenta,
	 @PlacentaWeight = PlacentaWeight,
	 @BloodLoss = Bloodloss,
	 @BP = BP,
	 @Pulse = Pulse,
	 @RR = RR,
	 @BabyStatus = Fate,
	 @BirthWeight = Weight,
	 @Sex = Sex,
	 @Apgar = ApgarScore,
	 @ApgarScore5 = ApgarScore_5,
	 @Resuscitation = RescuscitationDone,
	 @DrugsGiven = Drugs_Baby,
	 @DeliveredBy = DeliveryConductedBy,
	 @DeliveryTime = Date 
FROM
     [dbo].PatientObstetricHistory PH
 WHERE
	PH.CompanyID=@CompanyID AND PH.BranchID=@BranchID AND PH.DepartmentID=@DepartmentID
	AND ISNULL(AdmissionNo,'') = @OccupancyID

SELECT 
	TOP 1 
	@Labour_Start_Time = EntryDate,
	@Lie = Lie,
	@Presentation = Presentation, 
	@RupturedHrs = Raptured_Hrs
FROM 
	dbo.Patient_Partograph PP with(nolock)
WHERE
	PP.CompanyID=@CompanyID AND PP.BranchID=@BranchID AND PP.DepartmentID=@DepartmentID
	AND ISNULL(AdmissionNo,'') = @OccupancyID
	AND IIF(TRY_CAST(Cervix AS DECIMAL(18, 2)) IS NOT NULL, CAST(Cervix AS DECIMAL(18, 2)),0.00) > 0.00
ORDER BY 
	EntryDate ASC

IF (@Labour_Start_Time IS NOT NULL)
BEGIN
	--SET @Labour_Start_Time = @Labour_Start_Time
	SET @Labour_End_Time = DATEADD(HH,24,@Labour_Start_Time)
END
ELSE BEGIN
	SET @Labour_Start_Time = CAST(CONVERT(NVARCHAR(20),GETDATE(),112) AS DATETIME)
	SET @Labour_End_Time = DATEADD(HH,24,@Labour_Start_Time)
END

BEGIN
SELECT
    @PatientNumber As PatientNumber,
	@PatientName As PatientName,
	@Age As Age,
	@AdmissionDate As AdmissionDate,
	@EDD As ProcedureDate,
	@Lie As Lie,
	@Presentation As Presentation,
	@Induction As Induction,
	@DeliveryMode As DeliveryType,
     @AMTSL As AMTSL,
     @Uterotocin As Uterotocin,
	 @Placenta As Placenta,
	 @PlacentaWeight As PlacentaWeight,
	 @BloodLoss as Bloodloss,
	 @BP as BP,
	 @Pulse As Pulse,
	 @RR As RR,
	 @BabyStatus As Babystatus,
	 @BirthWeight As BirthWeight,
	 @Sex As Sex,
	 @Apgar As ApgarScore,
	 @ApgarScore5 As ApgarScore_5,
	 @Resuscitation As RescuscitationDone,
	 @DrugsGiven As Drugs_Baby,
	 @DeliveredBy As DeliveryConductedBy,
	 @DeliveryTime As Date,
	 @RupturedHrs As RupturedHrs,
	Time_Interval,
    MAX(FetalPulse) AS FetalPulse,
    MAX(FetalHeart_S) as FetalHeart_S,
    MAX(Membranes) as Membranes,
    MAX(Liquor) as Liquor,
    MAX(Moulding) as Moulding,
    MAX(Cervix) as Cervix,
    MAX(HeadDescent) as HeadDescent,
    MAX(ContractionsPer10Mins) as ContractionsPer10Mins,
    MAX(ContractionType) as ContractionType,
    MAX(Oxytocin) as Oxytocin,
    MAX(DrugsGiven) as DrugsGiven,
    MAX(PT_Heart_D) as PT_Heart_D,
    MAX(PT_Heart_S) as PT_Heart_S,
    MAX(PT_Pulse) as PT_Pulse,
    MAX(Temp) as Temp,
    MAX(Urine_Acetone) as Urine_Acetone,
    MAX(Urine_Protein) as Urine_Protein,
    MAX(Urine_Volume) as Urine_Volume
FROM    
   ( SELECT
    @Labour_Start_Time AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume

	UNION ALL

   SELECT
    DATEADD(HOUR, 1, @Labour_Start_Time) AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume

	UNION ALL
SELECT
    DATEADD(HOUR, 2, @Labour_Start_Time) AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume

	UNION ALL
SELECT
    DATEADD(HOUR, 3, @Labour_Start_Time) AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume

UNION ALL
SELECT
    DATEADD(HOUR, 4, @Labour_Start_Time) AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume
UNION ALL
SELECT
    DATEADD(HOUR, 5, @Labour_Start_Time) AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume

	UNION ALL
SELECT
    DATEADD(HOUR, 6, @Labour_Start_Time) AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume

	UNION ALL
SELECT
    DATEADD(HOUR, 7, @Labour_Start_Time) AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume

		UNION ALL
SELECT
    DATEADD(HOUR, 8, @Labour_Start_Time) AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume

		UNION ALL
SELECT
    DATEADD(HOUR, 9, @Labour_Start_Time) AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume

		UNION ALL
SELECT
    DATEADD(HOUR, 10, @Labour_Start_Time) AS Time_Interval,
    NULL AS FetalPulse,
    NULL AS FetalHeart_S,
    NULL AS Membranes,
    NULL AS Liquor,
    NULL AS Moulding,
    NULL AS Cervix,
    NULL AS HeadDescent,
    NULL AS ContractionsPer10Mins,
    NULL AS ContractionType,
    NULL AS Oxytocin,
    NULL AS DrugsGiven,
    NULL AS PT_Heart_D,
    NULL AS PT_Heart_S,
    NULL AS PT_Pulse,
    NULL AS Temp,
    NULL AS Urine_Acetone,
    NULL AS Urine_Protein,
    NULL AS Urine_Volume
  
  UNION ALL
  SELECT
  	Entrydate as Time_Interval,
    CASE WHEN FetalPulse = '' THEN NULL ELSE FetalPulse END AS FetalPulse,
    CASE WHEN FetalHeart_S = '' THEN NULL ELSE FetalHeart_S END AS FetalHeart_S,
    CASE WHEN Raptured_Hrs = 1 THEN 'Ruptured' ELSE 'Not Ruptured' END AS Membranes,
    CASE WHEN AmnioticFluid = '' THEN NULL ELSE AmnioticFluid END AS Liquor,
    CASE WHEN Moulding = '' THEN NULL ELSE Moulding END AS Moulding,
    CASE WHEN Cervix = '' THEN NULL ELSE Cervix END AS Cervix,
    CASE WHEN HeadDescent = '' THEN NULL ELSE HeadDescent END AS HeadDescent,
    CASE WHEN ContractionsPer10Mins = '' THEN NULL ELSE ContractionsPer10Mins END AS ContractionsPer10Mins,
    CASE
        WHEN FetalHeart_D < 20 THEN 'Dotted'
        WHEN FetalHeart_D >= 20 AND FetalHeart_D < 40 THEN 'Striped'
        ELSE 'Shaded'
    END AS ContractionType,
    CASE WHEN Oxytocin = '' THEN NULL ELSE Oxytocin END AS Oxytocin,
    CASE WHEN DrugsGiven = '' THEN NULL ELSE DrugsGiven END AS DrugsGiven,
    CASE WHEN PT_Heart_D = '' THEN NULL ELSE PT_Heart_D END AS PT_Heart_D,
    CASE WHEN PT_Heart_S = '' THEN NULL ELSE PT_Heart_S END AS PT_Heart_S,
    CASE WHEN PT_Pulse = '' THEN NULL ELSE PT_Pulse END AS PT_Pulse,
    CASE WHEN Temp = '' THEN NULL ELSE Temp END AS Temp,
    CASE WHEN Urine_Acetone = '' THEN NULL ELSE Urine_Acetone END AS Urine_Acetone,
    CASE WHEN Urine_Protein = '' THEN NULL ELSE Urine_Protein END AS Urine_Protein,
    CASE WHEN Urine_Volume = '' THEN NULL ELSE Urine_Volume END AS Urine_Volume
	FROM 
		dbo.Patient_Partograph PP with(nolock)
	WHERE
		PP.CompanyID=@CompanyID AND PP.BranchID=@BranchID AND PP.DepartmentID=@DepartmentID
		AND ISNULL(AdmissionNo,'')=@OccupancyID
		--AND CAST(ISNULL(Cervix,0.00) AS FLOAT) > 0.00
		AND (EntryDate BETWEEN @Labour_Start_Time AND @Labour_End_Time)
	) As PGH
GROUP BY
	PGH.Time_Interval
END