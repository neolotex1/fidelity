IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE type = 'P' AND name = 'USP_doQscan_doQ_Authentication')
BEGIN
 
EXEC('CREATE PROCEDURE USP_doQscan_doQ_Authentication AS ')

PRINT ('USP_doQscan_doQ_Authentication Procedure has been created');
END
GO
/****** Object:  StoredProcedure [dbo].[USP_doQscan_doQ_Authentication]    Script Date: 11-04-2023 19:21:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*=============================================================================        
** File				: [USP_doQscan_doQ_Authentication]     
** Author			:   
** Creation Date	: 
** Description		: 
** Version			:         
** Build			:         
** Bugs count		: 
** Check SP			: 

OPEN SYMMETRIC KEY PWD_Key_01 DECRYPTION BY CERTIFICATE doQman_04ZIAB
EncryptByKey(Key_GUID('PWD_Key_01'), USERS_vPassword)

*/

 ALTER PROCEDURE [dbo].[USP_doQscan_doQ_Authentication]  
 -- Add the parameters for the stored procedure here  
                                                (                                              
                                                 @in_vLocation                 VARCHAR(50) = NULL, --NTR
												 @in_vBranchCode               VARCHAR(50) = NULL,--NTR	
												 @in_vEmpCode                  VARCHAR(50) = NULL,
                                                 @in_vSerialKey                VARCHAR(50) = NULL,  
                                                 @in_vSystemKey                VARCHAR(50) = NULL,  
                                                 @in_vApplication              VARCHAR(50) = NULL, 
                                                 @in_vAppVersion			   CHAR(10)	   = NULL,	
												 @in_vUserName				   VARCHAR(30)=NULL,
												 @in_vPassword				   VARCHAR(30)=NULL,
												 @in_vDomainFlag               VARCHAR(30)=NULL,
												 @in_vDomainName            VARCHAR(30)=NULL,
                                                 ----commen SP parametres
                                                 @in_vAction                   VARCHAR(30) = NULL ,
                                                 @in_vFreetext1                VARCHAR(50) = NULL,  
                                                 @in_vFreetext2                VARCHAR(50) = NULL,  
                                                 @in_vFreetext3                VARCHAR(50) = NULL,  
                                                 @in_vFreetext4                INT=0, 
                                                 @in_iLoginOrgId		       VARCHAR(50)	= NULL,	
                                                 @in_vLoginToken	           VARCHAR(100)		= NULL,
												 @out_iErrorState			   int = 0 OUTPUT,
												 @out_iErrorSeverity		   int = 0 OUTPUT,
												 @out_vMessage				   nvarchar(250) = '' OUTPUT) 
                                                               
                                                     
                                                 
  AS                                                 
                                                                    
  BEGIN 
	SET NOCOUNT ON;
	DECLARE @vStatus_Var varchar(30)
	DECLARE @iUserId_Var int = 0 
	DECLARE @iLogInOrgId_Var int = 0
	DECLARE @vNewPassword_Var varchar(10)
	DECLARE @vLoginOrgCode_Var varchar(100)
	
	DECLARE @dLastReActivatedOn_Var date
	DECLARE @UserNameExpiryPeriod int
	DECLARE @UserName VARCHAR(100)
	DECLARE @iPassExpPeriod_Var int               
	DECLARE @iInvalidAttemptAllowed_Var int         
	DECLARE @iConfAgreeRenewPeriod_Var  int           
	DECLARE @iDefaultCodeSetId_Var int        
          
	DECLARE @iInvalidAttempts_Var int         
	DECLARE @dDateOfConfidentialityAgreement_Var datetime              
	DECLARE @dPasswordChangedDate_Var datetime         
	DECLARE @bActive_Var BIT  
    DECLARE @iLanguageID int=0
	-- Initialising        
	SET @vStatus_Var = 'SUCCESS'	

	IF @in_vAction = 'Authenticate_user'
		BEGIN  
		
			declare @iGroupid_Var int,@vEmpCode_Var varchar(10) = '', @iDocumentTypeId int,@iDepartmentId int
			SET @vLoginOrgCode_Var=	(SELECT ORGS_vCode FROM DMS_doQ_ORGS WHERE ORGS_iId=@in_iLoginOrgId)

			IF(@in_vDomainFlag = 'True')
			BEGIN
			print @vLoginOrgCode_Var
	            SELECT @iUserId_Var = ISNULL(MAX([USERS_iId]),0),
					@iLogInOrgId_Var = ISNULL(MAX(ORG.[ORGS_iId]),0)
					,@iGroupid_Var = ISNULL(MAX(USERS_iGroupId),0)
				FROM DMS_doQ_USERS USR WITH (NOLOCK) 
				JOIN DMS_doQ_ORGS ORG WITH (NOLOCK) 
					ON USR.USERS_iOrgId = [ORGS_iId]       
					WHERE UPPER([USERS_vUserName]) = UPPER(@in_vUserName)            
					AND LOWER(ORG.ORGS_vCode) = LOWER(@vLoginOrgCode_Var)
					AND USR.USERS_bIsDeleted = 0
					AND ORG.ORGS_bIsDeleted = 0
					--AND USR.USERS_bActive = 1
					AND ORG.ORGS_bActive = 1
					AND USR.USERS_bIsDomain = 1
					AND USR.USERS_iDomainID =(SELECT DOMAINMASTER_iID FROM DMS_doQ_DOMAINMASTER WHERE DOMAINMASTER_vName like '%'+@in_vDomainName +'%')
					print @iUserId_Var
			END

			ELSE
			BEGIN
			-- Check User Credentials          
			OPEN SYMMETRIC KEY PWD_Key_01 DECRYPTION BY CERTIFICATE DMS_InfoSearch_04ZIAB
				SELECT @iUserId_Var = ISNULL(MAX([USERS_iId]),0),
					@iLogInOrgId_Var = ISNULL(MAX(ORG.[ORGS_iId]),0) 
					,@iGroupid_Var = ISNULL(MAX(USERS_iGroupId),0)
				FROM DMS_doQ_USERS USR WITH (NOLOCK) 
				JOIN DMS_doQ_ORGS ORG WITH (NOLOCK) 
					ON USR.USERS_iOrgId = [ORGS_iId]       
					WHERE ([USERS_vUserName]) = @in_vUserName COLLATE Latin1_General_CS_AS          
					AND CONVERT(varchar, DecryptByKey(USERS_vPassword)) = @in_vPassword COLLATE Latin1_General_CS_AS
					AND LOWER(ORG.ORGS_vCode) = LOWER(@vLoginOrgCode_Var)
					AND USR.USERS_bIsDeleted = 0
					AND ORG.ORGS_bIsDeleted = 0
					--AND USR.USERS_bActive = 1
					AND ORG.ORGS_bActive = 1
					--AND USR.USERS_bIsDomain = 0
			CLOSE SYMMETRIC KEY PWD_Key_01  
			--END
			END
			
			
		IF (@iUserId_Var > 0 AND  @iLogInOrgId_Var >0) --Username & Password are correct
		BEGIN  
	    print @iUserId_Var
			print @iLogInOrgId_Var
			--Get Security Info from user organisation      
			SELECT @iPassExpPeriod_Var = ORG.ORGS_iPasswordExpiryPeriod
				,@iInvalidAttemptAllowed_Var = ORG.ORGS_iInvalidAttemptsAllowed
				,@iConfAgreeRenewPeriod_Var = ORG.ORGS_iConfidentialityAgreementPeriod 
				,@UserNameExpiryPeriod = Isnull(ORG.ORGS_iUserNameExpiryPeriod,0)      
			FROM DMS_doQ_USERS USR WITH (NOLOCK) 
			JOIN DMS_doQ_ORGS ORG WITH (NOLOCK) 
				ON USR.USERS_iOrgId = [ORGS_iId]
				WHERE USR.USERS_iId = @iUserId_Var   
			-- Get User specific Data        
			SELECT @iInvalidAttempts_Var =  ISNULL(USERS_iInvalidAttempts,0)     
				,@dDateOfConfidentialityAgreement_Var = ISNULL(USERS_dDateOfConfidentialityAgreement,DATEADD(DAY,-10000,GETDATE()))       
				,@bActive_Var = USERS_bActive        
				,@dPasswordChangedDate_Var = ISNULL(USERS_dDateOfLastPasswordChange,DATEADD(DAY,-10000,GETDATE()))  
				,@dLastReActivatedOn_Var = convert(date,USERS_dLastReActivatedDate)
				,@UserName = USERS_vUserName
				,@iLanguageID = ISNULL(USERS_iLanguageID,0)
			FROM DMS_doQ_USERS  WITH (NOLOCK)   
			WHERE USERS_iId = @iUserId_Var
			
			-- Check user name expired
			IF  convert(date,DATEADD(DAY, @UserNameExpiryPeriod, @dLastReActivatedOn_Var))< convert(date,GETDATE()) AND @UserNameExpiryPeriod<>0
				AND @UserName <> 'Administrator' AND @UserName <> 'SuperAdmin'
			begin
			
				-- Execute dbo.USP_USERSARCHIVE @iUserId_Var, 'UserName Expired'
				update DMS_doQ_USERS set USERS_bActive=0 where USERS_iId = @iUserId_Var
				SELECT @out_vMessage = 'User is expired ',
				@out_iErrorSeverity = 0,
				@out_iErrorState = -1
				return       
			end			
			
			-- Chekc for Inactive User        
			IF @bActive_Var = 0        
				SET @vStatus_Var = 'INACTIVE'        
			-- Check for Invalid Attempts   
			ELSE 
			BEGIN
				IF @iInvalidAttemptAllowed_Var > 0 
				BEGIN   
					-- Check for User Lock. 
					IF @iInvalidAttempts_Var > @iInvalidAttemptAllowed_Var
						SET @vStatus_Var = 'LOCKED'      
					ELSE
					BEGIN 
						-- Check for Password Expiry.         
						IF DATEDIFF(DAY,@dPasswordChangedDate_Var,GETDATE()) > @iPassExpPeriod_Var 
							SET @vStatus_Var = 'EXPAIRED'        
						ELSE
						BEGIN
							-- Check for Confidentiality Agrement Renewal          
							IF @iConfAgreeRenewPeriod_Var <> 0 AND DATEDIFF(DAY,@dDateOfConfidentialityAgreement_Var,GETDATE()) > @iConfAgreeRenewPeriod_Var        
								UPDATE DMS_doQ_USERS SET USERS_bConfidentialityAgreement = 0 WHERE  USERS_iId = @iUserId_Var        
						END
					END
				END
			END
			IF @vStatus_Var = 'SUCCESS' OR @vStatus_Var = 'EXPAIRED' 
			BEGIN
				SELECT TOP 1 @vEmpCode_Var = USERS_vUserName FROM DMS_doQ_USERS WHERE USERS_iId = @iUserId_Var

				
				IF (@in_vEmpCode is not null AND @vEmpCode_Var is not null AND @in_vEmpCode = @vEmpCode_Var)
				BEGIN
				print 1
					IF EXISTS (SELECT TOP 1 DOCTYPESUB_iID  FROM DMS_doQ_DOCTYPESUB WHERE DOCTYPESUB_iDOCTYPEMASTERID = (SELECT TOP 1 DOCTYPEMASTER_iID FROM DMS_doQ_DOCTYPEMASTER WHERE DOCTYPEMASTER_vName LIKE 'DoQman_HR' AND DOCTYPEMASTER_iOrgID = @in_iLoginOrgId) )
					BEGIN
						
						--SELECT TOP 1 @iDocumentTypeId= DOCTYPESUB_iID  FROM DMS_doQ_DOCTYPESUB WHERE DOCTYPESUB_iDOCTYPEMASTERID = (SELECT TOP 1 DOCTYPEMASTER_iID FROM DMS_doQ_DOCTYPEMASTER WHERE DOCTYPEMASTER_vName LIKE 'VistaarDocUpload' AND DOCTYPEMASTER_iOrgID = @in_iLoginOrgId)
						SELECT TOP 1 @iDocumentTypeId= DOCTYPEMASTER_iID FROM DMS_doQ_DOCTYPEMASTER WHERE DOCTYPEMASTER_vName LIKE 'DoQman_HR' AND DOCTYPEMASTER_iOrgID = @in_iLoginOrgId
						SELECT TOP 1 @iDepartmentId = DocTypeMapping_iDepartmentId FROM  DMS_doQ_DocTypeMapping WHERE DocTypeMapping_iDocTypeMasterId = @iDocumentTypeId 
						
					END
					ELSE
					BEGIN
					print 2
						SET @vStatus_Var = 'INACTIVE'
					END
				END
				ELSE
				BEGIN
					--SELECT @out_vMessage = 'User Branch Code is not matching or user not mapped to any branch',
					SELECT @out_vMessage = 'Enter the valid user name',
					@out_iErrorSeverity = 0,
					@out_iErrorState = -1
				return    
				END
				

			IF @vStatus_Var = 'SUCCESS' OR @vStatus_Var = 'EXPAIRED' -- Valid user in all aspects/Valid user have password expired       
			BEGIN  
			
			
				-- reset invalid attempts of the user to 0
				UPDATE DMS_doQ_USERS SET USERS_iInvalidAttempts = 0 WHERE  USERS_iId = @iUserId_Var
				BEGIN TRY 
				
					-- Close all the pervious sessons of the user
					UPDATE doQscan_doQ_UserLog SET UserLog_dEndTime = GETDATE() 
						WHERE ISNULL(UserLog_dEndTime,'') = ''
						--AND USERLOG_iOrgId = @iOrgId_Var -- Commented since users are able to login to differnet organisation(s) if the user belongs to Writer Employee or SuperAdmin
						AND doQscan_doQ_UserLog.UserLog_iUserId = @iUserId_Var
					INSERT INTO doQscan_doQ_UserLog (UserLog_vGuid,UserLog_iOrgId,UserLog_iUserId,UserLog_dStartTime,UserLog_dEndTime)
						VALUES(@in_vLoginToken,@iLogInOrgId_Var,@iUserId_Var,GETDATE(),NULL)
				END TRY
				BEGIN CATCH
					
					SET @vStatus_Var = 'ERROR'
					SELECT  @vStatus_Var AS UserStatus   
				END CATCH
				
				IF @vStatus_Var = 'SUCCESS' OR @vStatus_Var = 'EXPAIRED'
				BEGIN
				print 1
					SELECT @iUserId_Var As UserId
					,@iLogInOrgId_Var AS LoginOrgId
					,@in_vLoginToken AS LoginToken
					,@iLanguageID AS LanguageID		
					,@iDepartmentId AS DepartmentID
					,@iDocumentTypeId AS ProjectID
					,(SELECT TOP 1 GEN_vExtraText FROM DMS_doQ_GEN WHERE GEN_cType='DOP' AND GEN_vDescription='OCR Pages') AS OCRPages
					,(SELECT TOP 1 GEN_iRefID FROM DMS_doQ_GEN WHERE GEN_cType='OES' AND GEN_vDescription='OCR Enable Status') AS OCREnable
					
					SELECT @out_vMessage = 'User logged in Succesfully',
					@out_iErrorSeverity = 0,
					@out_iErrorState = 0			
				END 
				ELSE
				BEGIN
					SELECT @out_vMessage = 'USER Unable to login due to mapping or Creating Session Error',
					@out_iErrorSeverity = 0,
					@out_iErrorState = -1
				END      
			END
			END
			ELSE
			BEGIN
				SELECT  @vStatus_Var AS UserStatus
			END			
		END   
		ELSE     -- Password is wrong     
		BEGIN   
		print 3
			--To check wether the username exist or not for the selected Organisation
			SELECT @iUserId_Var = ISNULL(MAX([USERS_iId]),0),
				@iLogInOrgId_Var = ISNULL(MAX(ORG.[ORGS_iId]),0) 
			FROM DMS_doQ_USERS USR WITH (NOLOCK) 
			JOIN DMS_doQ_ORGS ORG WITH (NOLOCK) 
				ON USR.USERS_iOrgId = [ORGS_iId]       
			WHERE UPPER([USERS_vUserName]) = UPPER(@in_vUserName)
			AND ORG.ORGS_vCode = @vLoginOrgCode_Var  
			AND USR.USERS_bIsDeleted = 0
			AND ORG.ORGS_bIsDeleted = 0
			AND USR.USERS_bActive = 1
			AND ORG.ORGS_bActive = 1
			
			IF @iUserId_Var > 0 AND  @iLogInOrgId_Var > 0-- Only Organisation, Username are correct         
			BEGIN   
			print 4
				UPDATE DMS_doQ_USERS             
				SET USERS_iInvalidAttempts = USERS_iInvalidAttempts + 1                
				WHERE USERS_iId = @iUserId_Var	
				SELECT @out_vMessage = 'User Password not matching ',
			@out_iErrorSeverity = 0,
			@out_iErrorState = -1
			END
			ELSE
			
				SELECT @out_vMessage = 'Invalid Username and Password',
			@out_iErrorSeverity = 0,
			@out_iErrorState = -1   
		END
	END	
	-- Get System Key	LBS_SHD-7534 BS A
	else IF @in_vAction = 'GetSystemKey'
	BEGIN
		DECLARE @vSystemKey VARCHAR(100)
		SET @vSystemKey = (SELECT [Registration_vSystemKey] FROM doQscan_doQ_Registration WHERE [Registration_vBranchCode] = @in_vEmpCode)
		SELECT @vSystemKey AS [SystemKey]

		SELECT @out_vMessage = '',
			@out_iErrorSeverity = 0,
			@out_iErrorState = 0
	END
	-- Get System Key	LBS_SHD-7534 BE A
	--if  @out_iErrorState=-1 not mandatory updation,@out_iErrorState=-2 madatory updation
	-- Check for application version on application start
	else if @in_vAction = 'CheckVersion'
	begin
		-- Check for application version
		if exists(select GEN_vRemarks from DMS_doQ_GEN where GEN_cType='VR' 
					and GEN_vDescription=@in_vApplication and GEN_vRemarks = @in_vAppVersion)
		begin
			-- If message empty application will work normally
			select 0 [CloseAppOnVersionMismatch]
			select @out_vMessage = '', @out_iErrorSeverity=0, @out_iErrorState=0	
			return
		end
		else begin
			select GEN_iRefID [CloseAppOnVersionMismatch] from DMS_doQ_GEN where GEN_cType='VR' and GEN_vDescription=@in_vApplication
			select @out_vMessage = 'New version of doQscan is available. Please download new version.', @out_iErrorSeverity=0, @out_iErrorState=-1
			return
		end				
	end
		
	-- Check for registration on application start
	else if @in_vAction = 'CheckRegistration'
	begin
		return
	end
	else -- Do the registration
	begin
		---- Location already exist.
		--IF EXISTS (SELECT 1 FROM GEN(NOLOCK) WHERE GEN_vDescription = @in_vLocation AND GEN_cType = 'LO' )
		--BEGIN		
		--	SELECT @out_vMessage = 'Registration failed! Location already exist, Please use different name.', @out_iErrorSeverity=0, @out_iErrorState=0
		--	RETURN
		--END
			
		-- Serial key already used.
		IF EXISTS (SELECT 1 FROM doQscan_doQ_Registration(NOLOCK) WHERE [Registration_vSerialKey] = @in_vSerialKey AND [Registration_bIsUsed] =1 )
		BEGIN		
			SELECT @out_vMessage = 'Registration failed! Serial key already used.', @out_iErrorSeverity=0, @out_iErrorState=0
			RETURN
		END
		
		-- Serial key is expired.
		IF EXISTS (SELECT 1 FROM doQscan_doQ_Registration(NOLOCK) WHERE [Registration_vSerialKey] = @in_vSerialKey AND CONVERT(DATE,[Registration_dExpireOn]) < CONVERT(DATE,GETDATE())  )
	BEGIN		
		SELECT @out_vMessage = 'Registration failed! Serial key is expired.', @out_iErrorSeverity=0, @out_iErrorState=0
		RETURN
	END	
	
	ELSE IF EXISTS (SELECT 1 FROM doQscan_doQ_Registration(NOLOCK) WHERE [Registration_vSerialKey] = @in_vSerialKey AND [Registration_bIsUsed] =0)
	BEGIN
	-- Register Application
		UPDATE doQscan_doQ_Registration
		SET	 [Registration_vBranchCode]		= @in_vEmpCode
			,[Registration_vApplication]	= @in_vApplication
			,[Registration_vAppVersion]	= @in_vAppVersion
			,[Registration_vSystemKey]		= @in_vSystemKey
			,[Registration_dRegisteredOn]	= GETDATE()
			,[Registration_bIsUsed]		= 1
		WHERE 
			[Registration_vSerialKey]		= @in_vSerialKey
			
		-- Add Location if not exists
		--IF NOT EXISTS (SELECT 1 FROM [DMS_doQ_GEN] (NOLOCK) WHERE GEN_vDescription = @in_vLocation AND GEN_cType = 'LO' )
		--BEGIN
		--BEGIN TRY
		--BEGIN TRAN
		--	INSERT INTO [DMS_doQ_GEN](
		--		 GEN_vDescription
		--		,GEN_vExtraText
		--		,GEN_vRemarks
		--		,GEN_cType
		--		,GEN_iCreatedID
		--		,GEN_dCreatedDate
		--	) 
		--	SELECT
		--		 @in_vLocation
		--		,'Location - Scanning Centre'
		--		,'Location created at the time of registration'
		--		,'LO'
		--		,999
		--		,GETDATE()

		--COMMIT TRAN
		--END TRY
		--BEGIN CATCH				
		--	ROLLBACK TRAN				
		--END CATCH
		--END	
		SELECT @out_vMessage = 'Registration success. Thanks for registering '+@in_vApplication+'.', @out_iErrorSeverity=0, @out_iErrorState=0
		SELECT 
			 [EmpCode]	= Registration_vBranchCode
			,[ScannerId]	= 1			
			,[SerialKey]	= [Registration_vSerialKey]
			,[SystemKey]	= [Registration_vSystemKey]
			,[AppVersion]	= [Registration_vAppVersion]
			,[RegisteredOn]	= [Registration_dRegisteredOn]
			,[ExpireOn]		= [Registration_dExpireOn]
			,[UserName]		= USERS_vUserName
		FROM 
			[doQscan_doQ_Registration] r 
			--INNER JOIN doQscan_doQ_ScannerSettings s (NOLOCK) 
			INNER JOIN DMS_doQ_USERS b ON b.USERS_vUserName=r.Registration_vBranchCode
			 
		WHERE 
			[Registration_vSerialKey]	= @in_vSerialKey AND	  
			[Registration_vBranchCode]	= @in_vEmpCode  AND
			[Registration_vAppVersion]	= @in_vAppVersion
		-- The above set of information will be stored in application (xml) for future reference		 			
	END
	
	ELSE BEGIN
			SELECT @out_vMessage = 'Registration failed. Invalid serial key.', @out_iErrorSeverity=0, @out_iErrorState=0
	END
	end
	
	SET NOCOUNT OFF;
  END

  IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE type = 'P' AND name = 'USP_doQscan_doQ_Authentication')
BEGIN
 
EXEC('CREATE USP_doQscan_doQ_Authentication AS ')

PRINT ('USP_doQscan_doQ_Authentication Procedure has been created');
END
GO
IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'P' AND name = 'USP_doQscan_doQ_Authentication')
BEGIN
  
PRINT ('USP_doQscan_doQ_Authentication Procedure has been altered');

END
GO

