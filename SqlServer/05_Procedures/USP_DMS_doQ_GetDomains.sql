IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE type = 'P' AND name = 'USP_DMS_doQ_GetDomains')
BEGIN
 
EXEC('CREATE PROCEDURE USP_DMS_doQ_GetDomains AS ')

PRINT ('USP_DMS_doQ_GetDomains Procedure has been created');
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DMS_doQ_GetDomains]    Script Date: 05-05-2023 10:53:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pratheesh A
-- Create date: 15 Nov 2013
-- Description:	TO get the domain names from DMS_doQ_DOMAINMASTER
-- =============================================
ALTER PROCEDURE [dbo].[USP_DMS_doQ_GetDomains]
(
    @in_iOrgID      INT,
    @in_vOrgCode     varchar(60) = null,
	@in_vAction		varchar(60), 
	-- session data
	@in_vLoginToken   varchar(100)= null,
	@in_iLoginOrgId       int = null 
)
AS
BEGIN
	SET  XACT_ABORT  ON               
	SET  NOCOUNT  ON 
	
   DECLARE @iUserId_Var int = 0 

   IF @in_vAction = 'GetDomainNamewithUserID'
   BEGIN
 	    	IF ISNULL(@in_vLoginToken,'') <> '' AND @in_iLoginOrgId > 0
			BEGIN
				SET @iUserId_Var = dbo.[FN_doQMan_CheckUserSession](@in_vLoginToken,null,@in_iLoginOrgId)
			END
			     
			IF @iUserId_Var > 0 -- Authenticated
 			BEGIN
 			   SELECT 0 AS [ValueField],
 					  '--Select--' AS [TextField]
 			   UNION ALL
 			   SELECT DOMAINMASTER_iID AS [ValueField],
 					  DOMAINMASTER_vName AS [TextField]
 			   FROM DMS_doQ_DOMAINMASTER WITH(NOLOCK)
 			   WHERE DOMAINMASTER_iOrgID = (SELECT USERS_iOrgId FROM DMS_doQ_USERS WITH(NOLOCK) WHERE USERS_iId = @iUserId_Var)
 			END
	END
	ELSE IF @in_vAction = 'GetDomainNamewithOrgCode'
	BEGIN
	
	   SELECT 0 AS [ValueField],
 					  '--Select--' AS [TextField]
	   UNION ALL
	   SELECT DOMAINMASTER_iID AS [ValueField],
			  DOMAINMASTER_vName AS [TextField]
	   FROM DMS_doQ_DOMAINMASTER WITH(NOLOCK)
	   WHERE DOMAINMASTER_iOrgID = (	    SELECT ORGS_iId FROM DMS_doQ_ORGS WITH(NOLOCK) WHERE ORGS_vCode = @in_vOrgCode)

	END
	ELSE IF @in_vAction = 'GetDomainNamewithOrgID'
	BEGIN
	   SELECT 0           AS [ValueField],
 			 '--Select--' AS [TextField],
 			 (SELECT ORGS_vCode FROM DMS_doQ_ORGS WITH(NOLOCK) WHERE ORGS_iId = @in_iLoginOrgId) AS [OrgName]
 	   UNION ALL	
	   SELECT DOMAINMASTER_iID AS [ValueField],
			  DOMAINMASTER_vName AS [TextField],
			  (SELECT ORGS_vName FROM DMS_doQ_ORGS WITH(NOLOCK) WHERE ORGS_iId = @in_iLoginOrgId) AS [OrgName]
	   FROM DMS_doQ_DOMAINMASTER WITH(NOLOCK)
	   WHERE DOMAINMASTER_iOrgID = @in_iLoginOrgId
   


	END

END

IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE type = 'P' AND name = 'USP_DMS_doQ_GetDomains')
BEGIN
 
EXEC('CREATE USP_DMS_doQ_GetDomains AS ')

PRINT ('USP_DMS_doQ_GetDomains Procedure has been created');
END
GO
IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'P' AND name = 'USP_DMS_doQ_GetDomains')
BEGIN
  
PRINT ('USP_DMS_doQ_GetDomains Procedure has been altered');

END
GO










