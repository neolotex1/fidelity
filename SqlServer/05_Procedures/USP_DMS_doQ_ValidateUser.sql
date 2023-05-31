IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE type = 'P' AND name = 'USP_DMS_doQ_ValidateUser')
BEGIN
 
EXEC('CREATE PROCEDURE USP_DMS_doQ_ValidateUser AS ')

PRINT ('USP_DMS_doQ_ValidateUser Procedure has been created');
END
GO
/****** Object:  StoredProcedure [dbo].[USP_DMS_doQ_ValidateUser]    Script Date: 05-05-2023 10:55:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- [USP_ValidateUser] 'SuperAdmin','admin@123','global','59fc6507-5965-4bb3-886b-42e98d89d12','ValidateUser' 
-- Execute dbo.USP_USERSARCHIVE 1, 'UserName Expired'
ALTER PROCEDURE [dbo].[USP_DMS_doQ_ValidateUser]             
(               
	@in_vUserName		varchar(30),  
	@in_bDomainUser		bit = null,     
	@in_iDomainID		INT = null,         
	@in_vPassword		varchar(30) = null,
	@in_vLoginOrgCode   varchar(300),
	@in_vLoginToken		varchar(100),
	@in_vAction			varchar(30)	
)          
AS                 
BEGIN              
	SET  XACT_ABORT  ON               
	SET  NOCOUNT  ON      
	
	DECLARE @vStatus_Var varchar(30)           
                 
	DECLARE @iUserId_Var int = 0 
	DECLARE @iLogInOrgId_Var int = 0
	DECLARE @vNewPassword_Var varchar(10)
	
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
	-----------------------
	-- User Validation
	----------------------- 
	IF @in_vAction = 'ValidateUser'      
	BEGIN  
	
	    IF(@in_bDomainUser = 1)
	    BEGIN
		print 1;
	            SELECT @iUserId_Var = ISNULL(MAX([USERS_iId]),0),
					@iLogInOrgId_Var = ISNULL(MAX(ORG.[ORGS_iId]),0)
				FROM DMS_doQ_USERS USR WITH (NOLOCK) 
				JOIN DMS_doQ_ORGS ORG WITH (NOLOCK) 
					ON USR.USERS_iOrgId = [ORGS_iId]       
					WHERE UPPER([USERS_vUserName]) = UPPER(@in_vUserName)            
					AND LOWER(ORG.ORGS_vCode) = LOWER(@in_vLoginOrgCode)
					AND USR.USERS_bIsDeleted = 0
					AND ORG.ORGS_bIsDeleted = 0
					--AND USR.USERS_bActive = 1
					AND ORG.ORGS_bActive = 1
					AND USR.USERS_bIsDomain = 1
					AND USR.USERS_iDomainID = @in_iDomainID
	    END
	    ELSE
	    BEGIN
			-- Check User Credentials          
			OPEN SYMMETRIC KEY PWD_Key_01 DECRYPTION BY CERTIFICATE DMS_InfoSearch_04ZIAB
				SELECT @iUserId_Var = ISNULL(MAX([USERS_iId]),0),
					@iLogInOrgId_Var = ISNULL(MAX(ORG.[ORGS_iId]),0) 
				FROM DMS_doQ_USERS USR WITH (NOLOCK) 
				JOIN DMS_doQ_ORGS ORG WITH (NOLOCK) 
					ON USR.USERS_iOrgId = [ORGS_iId]       
					WHERE ([USERS_vUserName]) = (@in_vUserName)  COLLATE Latin1_General_CS_AS           
					AND CONVERT(varchar, DecryptByKey(USERS_vPassword)) = @in_vPassword COLLATE Latin1_General_CS_AS 
					AND LOWER(ORG.ORGS_vCode) = LOWER(@in_vLoginOrgCode)
					AND USR.USERS_bIsDeleted = 0
					AND ORG.ORGS_bIsDeleted = 0
					--AND USR.USERS_bActive = 1
					AND ORG.ORGS_bActive = 1
					AND USR.USERS_bIsDomain = 0
			CLOSE SYMMETRIC KEY PWD_Key_01     
		END
		IF (@iUserId_Var > 0 AND  @iLogInOrgId_Var >0) --Username & Password are correct
		BEGIN   
		print @iUserId_Var;
		print @iLogInOrgId_Var;
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

			print @iPassExpPeriod_Var;

			-- Check user name expired
			IF  convert(date,DATEADD(DAY, @UserNameExpiryPeriod, @dLastReActivatedOn_Var))< convert(date,GETDATE()) AND @UserNameExpiryPeriod<>0
				AND @UserName <> 'Administrator' AND @UserName <> 'SuperAdmin'
			begin
				-- Execute dbo.USP_USERSARCHIVE @iUserId_Var, 'UserName Expired'
				update DMS_doQ_USERS set USERS_bActive=0 where USERS_iId = @iUserId_Var
				SET @vStatus_Var = 'USERNAME_EXPIRED' 
				SELECT  @vStatus_Var AS UserStatus   
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
			IF @vStatus_Var = 'SUCCESS' OR @vStatus_Var = 'EXPAIRED' -- Valid user in all aspects/Valid user have password expired       
			BEGIN   
			print 'SUCCESS/EXPAIRED';
				-- reset invalid attempts of the user to 0
				UPDATE DMS_doQ_USERS SET USERS_iInvalidAttempts = 0 WHERE  USERS_iId = @iUserId_Var
				print 'UPDATE DMS_doQ_USERS'
				BEGIN TRY 
					-- Close all the pervious sessons of the user
					UPDATE DMS_doQ_USERLOG SET USERLOG_dEndTime = GETDATE() 
						WHERE ISNULL(USERLOG_dEndTime,'') = ''
						--AND USERLOG_iOrgId = @iOrgId_Var -- Commented since users are able to login to differnet organisation(s) if the user belongs to Writer Employee or SuperAdmin
						AND DMS_doQ_USERLOG.USERLOG_iUserId = @iUserId_Var

						print 'UPDATE DMS_doQ_USERLOG'
						print @in_vLoginToken
						print @iLogInOrgId_Var
						print @iUserId_Var
					

					INSERT INTO DMS_doQ_USERLOG (USERLOG_vGuid,USERLOG_iOrgId,USERLOG_iUserId,USERLOG_dStartTime,USERLOG_dEndTime)
						VALUES(@in_vLoginToken,@iLogInOrgId_Var,@iUserId_Var,GETDATE(),NULL)

						print 'insert DMS_doQ_USERLOG'
				END TRY
				BEGIN CATCH
				
					SET @vStatus_Var = 'ERROR'
					SELECT  @vStatus_Var AS UserStatus 

	print error_message();

				END CATCH
				IF @vStatus_Var = 'SUCCESS' OR @vStatus_Var = 'EXPAIRED'
				BEGIN
					SELECT  @vStatus_Var AS UserStatus
					,@iUserId_Var As UserId
					,@iLogInOrgId_Var AS LoginOrgId
					,@in_vLoginToken AS LoginToken
					,@iLanguageID AS LanguageID					
				END       
			END
			ELSE
			BEGIN
				SELECT  @vStatus_Var AS UserStatus
			END			
		END   
		ELSE     -- Password is wrong     
		BEGIN   
			--To check wether the username exist or not for the selected Organisation
			SELECT @iUserId_Var = ISNULL(MAX([USERS_iId]),0),
				@iLogInOrgId_Var = ISNULL(MAX(ORG.[ORGS_iId]),0) 
			FROM DMS_doQ_USERS USR WITH (NOLOCK) 
			JOIN DMS_doQ_ORGS ORG WITH (NOLOCK) 
				ON USR.USERS_iOrgId = [ORGS_iId]       
			WHERE UPPER([USERS_vUserName]) = UPPER(@in_vUserName)
			AND ORG.ORGS_vCode = @in_vLoginOrgCode  
			AND USR.USERS_bIsDeleted = 0
			AND ORG.ORGS_bIsDeleted = 0
			AND USR.USERS_bActive = 1
			AND ORG.ORGS_bActive = 1
			
			IF @iUserId_Var > 0 AND  @iLogInOrgId_Var > 0-- Only Organisation, Username are correct         
			BEGIN   
				UPDATE DMS_doQ_USERS             
				SET USERS_iInvalidAttempts = USERS_iInvalidAttempts + 1                
				WHERE USERS_iId = @iUserId_Var	
				SET @vStatus_Var = 'INVALIDPASS'
			END
			ELSE
				SET @vStatus_Var = 'INVALIDUSER'			
			SELECT  @vStatus_Var AS UserStatus      
		END
	END	
	-------------------------------------     
    -- Validate User Explicitly
    -------------------------------------
	ELSE IF @in_vAction = 'ValidateUserExplicitly'      
	BEGIN   
		SELECT @iUserId_Var = ISNULL(MAX([USERS_iId]),0)
			FROM DMS_doQ_USERS USR WITH (NOLOCK) 
			JOIN DMS_doQ_ORGS ORG WITH (NOLOCK) 
				ON USR.USERS_iOrgId = [ORGS_iId] 
				AND dbo.FN_doQMan_GetParentOrgId(USR.USERS_iOrgId) = 0      
			WHERE UPPER([USERS_vUserName]) = UPPER(@in_vUserName)			
			AND USR.USERS_bIsDeleted = 0
			AND ORG.ORGS_bIsDeleted = 0
			AND USR.USERS_bActive = 1
			AND ORG.ORGS_bActive = 1
			
		SELECT
			@iLogInOrgId_Var = ISNULL(MAX(ORG.[ORGS_iId]),0) 
			FROM DMS_doQ_ORGS ORG WITH (NOLOCK) 
			WHERE ORG.ORGS_vCode = @in_vLoginOrgCode  
			
		IF @iUserId_Var > 0 AND  @iLogInOrgId_Var > 0-- Valid user for ValidateUserExplicitly         
		BEGIN
			BEGIN TRY 
				-- Close all the pervious sessons of the user
				UPDATE DMS_doQ_USERLOG SET USERLOG_dEndTime = GETDATE() 
					WHERE ISNULL(USERLOG_dEndTime,'') = ''
					--AND USERLOG_iOrgId = @iOrgId_Var -- Commented since usera are able to login to differnet organisation(s) if the user belongs to Writer Employee or SuperAdmin
					AND DMS_doQ_USERLOG.USERLOG_iUserId = @iUserId_Var
				INSERT INTO DMS_doQ_USERLOG (USERLOG_vGuid,USERLOG_iOrgId,USERLOG_iUserId,USERLOG_dStartTime,USERLOG_dEndTime)
					VALUES(@in_vLoginToken,@iLogInOrgId_Var,@iUserId_Var,GETDATE(),NULL)
			END TRY
			BEGIN CATCH
				SET @vStatus_Var = 'ERROR'
			END CATCH
		END
		ELSE
		BEGIN
			SET @vStatus_Var = 'ERROR'
		END
		SELECT  @vStatus_Var AS UserStatus
		,@iUserId_Var As UserId
		,@iLogInOrgId_Var AS LoginOrgId
		,@in_vLoginToken AS LoginToken
		,@iLanguageID AS LanguageID	  
	END   
	-------------------------------------     
    -- Forgot Password
    -------------------------------------
	IF @in_vAction = 'ForgotPassword'       
	BEGIN        
		SELECT @iUserId_Var = ISNULL(MAX([USERS_iId]),0),
				@iLogInOrgId_Var = ISNULL(MAX(ORG.[ORGS_iId]),0)				
			FROM DMS_doQ_USERS USR WITH (NOLOCK) 
			JOIN DMS_doQ_ORGS ORG WITH (NOLOCK) 
				ON USR.USERS_iOrgId = [ORGS_iId]       
			WHERE UPPER([USERS_vUserName]) = UPPER(@in_vUserName) 
			AND ORG.ORGS_vCode = @in_vLoginOrgCode
			AND USR.USERS_bIsDeleted = 0
			AND ORG.ORGS_bIsDeleted = 0
			AND USR.USERS_bActive = 1
			AND ORG.ORGS_bActive = 1
			AND USR.USERS_bIsDomain = 0
		IF @iUserId_Var > 0 AND  @iLogInOrgId_Var > 0-- Organisation, Username & Password are correct         
		BEGIN  	
			-- Construct New Password
				SET @vNewPassword_Var = [dbo].[FN_doQMan_GeneratePassword]()
			-- Update New Password
			OPEN SYMMETRIC KEY PWD_Key_01 DECRYPTION BY CERTIFICATE DMS_InfoSearch_04ZIAB
			UPDATE DMS_doQ_USERS     
				SET USERS_vPassword = EncryptByKey(Key_GUID('PWD_Key_01'), @vNewPassword_Var) 
				,USERS_dDateOfLastPasswordChange = null
				,USERS_dUpdateDate = GETDATE()
				,USERS_iUpdateBy = @iUserId_Var
			WHERE UPPER([USERS_vUserName]) = UPPER(@in_vUserName)
				AND DMS_doQ_USERS.USERS_iId = @iUserId_Var
			
				
            
			
			IF @@ROWCOUNT > 0
			BEGIN
			--DMS_doQ_Audit
			SET @USERNAME  =  (SELECT USERS_vUserName FROM DMS_doQ_USERS WHERE USERS_iId = @iUserId_Var)
			DECLARE @message varchar(500) = 'Password has been reset for the user ' + @USERNAME +'.'
            EXEC USP_DMS_doQ_AuditTrack @iUserId_Var,@message,'User',@iUserId_Var
            --audit
            
			END 
			ELSE
			BEGIN
				SET @vStatus_Var = 'FAILED'	
		    END
			CLOSE SYMMETRIC KEY PWD_Key_01
			
			
			
			
		END
		ELSE
		BEGIN
			SET @vStatus_Var = 'FAILED'
		END
		SELECT  @vStatus_Var AS UserStatus, @iLogInOrgId_Var as LoginOrgId		
	END   
END 

IF NOT EXISTS (SELECT 1 FROM sysobjects WHERE type = 'P' AND name = 'USP_DMS_doQ_ValidateUser')
BEGIN
 
EXEC('CREATE USP_DMS_doQ_ValidateUser AS ')

PRINT ('USP_DMS_doQ_ValidateUser Procedure has been created');
END
GO
IF EXISTS (SELECT 1 FROM sysobjects WHERE type = 'P' AND name = 'USP_DMS_doQ_ValidateUser')
BEGIN
  
PRINT ('USP_DMS_doQ_ValidateUser Procedure has been altered');

END
GO




