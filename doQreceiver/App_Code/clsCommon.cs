//artf10001 -Renjith.M.K - The system cannot find the file specified
using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Xml;
using System.Text;
using System.Security.Cryptography;
using Ionic.Zip;
using OfficeConverter;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using doQrecevier;

namespace doQRouter
{
    public class 

        clsCommon
    {
        private string mstrDestFolder = "";
        private string mComputerName = "";
        private string mdoQRouterVersion="";
        private string mSUSPath = "";
        private string mVirtualPath = "";
        public static string AzureConnection;
        public clsCommon()
        {
            //mstrConnectionString=DecryptConString(ConfigurationSettings.AppSettings["ConnectionString"].ToString());
        }
        public string CreateFolder()
        {
            var now = DateTime.Now;
            var monthname = now.ToString("MMMM");
            var yearname = now.ToString("yyyy");
            //var dayname = now.ToString("dd-MM-yyyy");

            var Folder = monthname + "-" + yearname;

            if (!Directory.Exists(Folder))
            {
                DirectoryInfo di = Directory.CreateDirectory(mstrDestFolder + "//" + Folder);


            }

            return Folder;
        }

        #region Extract, Decode & Save
        public string ExtractFiles(Stream strSourceXml)
        {
            mstrDestFolder = ConfigurationManager.AppSettings.Get("DestinationFolder").ToString();
            string pathh = mstrDestFolder + "\\" + CreateFolder();
            string FolderName = CreateFolder();
            string FolderNameMerge = "FolderNameMerge" + CreateFolder();
            //mstrDestFolder = ConfigurationSettings.AppSettings.Get("DestinationFolder").ToString();
            mdoQRouterVersion = ConfigurationManager.AppSettings.Get("doQRouterVersion").ToString();
            mSUSPath = ConfigurationManager.AppSettings.Get("SUSPath").ToString();
            mVirtualPath = ConfigurationManager.AppSettings.Get("gVirtualPath").ToString() + FolderName;
            Byte[] btImage;
 
            string strTxtName = "";
            string strImgName = "", strImgContent = "";
            string strDate = "";
            string strAck = "";
            string strImagePath = "";

            try
            {
                XmlDocument xmdocInput = new XmlDocument();
                xmdocInput.Load(strSourceXml);
                XmlNode xmlImage = xmdocInput.DocumentElement.ChildNodes[0];
                mComputerName = xmlImage.ChildNodes[6].InnerText;
                Trace("Start Post Application");
                Trace("Reading Data from XML Tag");

                strImgName = xmlImage.ChildNodes[0].InnerText; //@in_vImgName
                strDate = xmlImage.ChildNodes[1].InnerText;
                string strReferenceID = xmlImage.ChildNodes[2].InnerText;
                string strLANNumber = xmlImage.ChildNodes[3].InnerText;
                string strUploadId = xmlImage.ChildNodes[4].InnerText;
                string strUserId = xmlImage.ChildNodes[5].InnerText;
                string strMachine = xmlImage.ChildNodes[6].InnerText;
                string strOrgId = xmlImage.ChildNodes[7].InnerText;
                strImgContent = xmlImage.ChildNodes[8].InnerText;

                

                string strProductType = string.Empty;

                Trace("Passing parameter");

                Trace(strImgName + "," + strDate + "," + strReferenceID + "," + strLANNumber + "," + strUploadId + "," + strUserId + "," + strProductType + "," + strMachine + "," + strOrgId);


                Trace("Sucessfully Completed Reading data from " + strImgName.ToString());
                if (strImgName== "#####!!!!")
                {
                    Trace("Checking Token String");
                    int i = 0;
                    int mCounter = 0;
                    int token=0;
                    System.Data.SqlClient.SqlConnection objCentralCon = new SqlConnection();

                    objCentralCon.ConnectionString = GetConnectionString();

                    //objCentralCon.ConnectionString = ConfigurationManager.AppSettings.Get("CentralDBConnection").ToString();
                    DataSet dSet = new DataSet();
                    SqlDataAdapter Adpt = new SqlDataAdapter();
                    objCentralCon.Open();
                    System.Data.SqlClient.SqlCommand objCentralCmd = new SqlCommand();
                    objCentralCmd.Connection = objCentralCon;
                    objCentralCmd.CommandText = "SELECT Sys FROM RKEY";
                    Adpt.SelectCommand = objCentralCmd;
                    Adpt.Fill(dSet);
                    mCounter = dSet.Tables[0].Rows.Count - 1;
                    while (i <= mCounter)
                    {
                        if (dSet.Tables[0].Rows[i]["Sys"].ToString()!="")
                        {
                            
                            if (DecryptData(dSet.Tables[0].Rows[i]["Sys"].ToString()) == strImgContent.ToString())
                            {
                                token = 1;
                                break;
                            }
                        }
                        else
                        {
                            token = 0;
                        }
                        i++;
                    }
                    if (token == 1)
                    {
                        Trace("Creating Acknowledgment XML with 'Sucess' Status");
                        strAck = GenerateTokenAck("AI");
                        Trace("Sucessfully Created Acknowledgment XML with 'Sucess' Status");
                    }
                    else
                    {
                        Trace("Creating Acknowledgment XML with 'Failed' Status");
                        strAck = GenerateTokenAck("UI");
                        Trace("Sucessfully Created Acknowledgment XML with 'Failed' Status");
                    }
                    objCentralCon.Close();
                }
                else if (strImgName.Substring(0, 6) == "REGKEY")
                {
                    Trace("Enterd in Registration Check Block");
                    int i = 0;
                    int mCounter = 0;
                    int keyFound=0;
                    System.Data.SqlClient.SqlConnection objCentralCon = new SqlConnection();


                    objCentralCon.ConnectionString = GetConnectionString();
                    //objCentralCon.ConnectionString = ConfigurationManager.AppSettings.Get("CentralDBConnection").ToString();
                    objCentralCon.Open();
                    System.Data.SqlClient.SqlCommand objCentralCmd = new SqlCommand();
                    System.Data.SqlClient.SqlCommand cmd = new SqlCommand();
                    DataSet dSet = new DataSet();
                    SqlDataAdapter Adpt = new SqlDataAdapter();
                    objCentralCmd.Connection = objCentralCon;
                    cmd.Connection = objCentralCon;
                    objCentralCmd.CommandText = "SELECT RValue,Stat,ID FROM RKEY"; //+ EncryptData(strImgName.Substring(6, strImgName.Length - 6).Trim().ToString()) + "'";
                    Adpt.SelectCommand = objCentralCmd;
                  //  Adpt.Fill(dSet); for DMS
                    mCounter = dSet.Tables[0].Rows.Count - 1;
                    while (i <= mCounter)
                    {
                        if (DecryptData(dSet.Tables[0].Rows[i]["RValue"].ToString()) == strImgName.Substring(6, strImgName.Length - 6).Trim().ToString())
                        {
                            keyFound = 1;
                            if (DecryptData(dSet.Tables[0].Rows[i]["STAT"].ToString()) != "N")
                            {
                                strAck = GenerateTokenAck("KU");
                                Trace("Failed to Register since the key " + strImgName.Substring(6, strImgName.Length - 6).Trim().ToString() + " already used"); 
                                break;
                            }
                            else
                            {
                                cmd.CommandText = "UPDATE RKEY SET Sys='" + EncryptData(strImgContent) + "',Stat='" + EncryptData("A") + "' WHERE ID=" + dSet.Tables[0].Rows[i]["ID"];
                                cmd.ExecuteNonQuery();
                                Trace("Sucessfully Registerd doQRouter with the key " + strImgName.Substring(6, strImgName.Length - 6).Trim().ToString());
                                Trace("Creating Acknowledgment XML with 'Sucess' Tag");
                                strAck = GenerateTokenAck("SR");
                                break;
                            }
                        }
                        else
                        {
                            keyFound =0;
                        }
                        i++;
                    }
                   
                    if (keyFound==0)
                    {
                        Trace("Creating Acknowledgment XML with 'Inavlid' Tag");
                        strAck = GenerateTokenAck("IK");
                    }
                    objCentralCon.Close();
                }
                else
                {
                    Trace("Start Processing " + strImgName);
                    btImage = Convert.FromBase64String(strImgContent);
                    Trace("Found Hub Value as " + strOrgId.ToString());
                    //if (IsHubUpload == "1")
                    //{
                    //    mstrDestFolder = mstrDestFolder + @"\\" + DateTime.Now.ToString("yyyyMMdd");
                    //    if (File.Exists(mstrDestFolder) == false)
                    //    {
                    //        Trace("Creating Director with " + mstrDestFolder.ToString());
                    //        System.IO.Directory.CreateDirectory(mstrDestFolder);
                    //    }
                    //}
                    //Check Duplicates

                    DataSet dSet = new DataSet();
                    SqlDataAdapter Adpt = new SqlDataAdapter();
                    System.Data.SqlClient.SqlConnection objCentralCon = new SqlConnection();

                    objCentralCon.ConnectionString = GetConnectionString();
                    //objCentralCon.ConnectionString = ConfigurationManager.AppSettings.Get("CentralDBConnection").ToString();
                    objCentralCon.Open();
                    System.Data.SqlClient.SqlCommand objCentralCmd = new SqlCommand();
                    objCentralCmd.Connection = objCentralCon;
                    objCentralCmd.CommandType = CommandType.StoredProcedure;
                    objCentralCmd.CommandText = "USP_DMS_doQ_ManageDoQScan";
                    objCentralCmd.Parameters.Add("@in_vReferenceID", SqlDbType.VarChar, 250).Value = strReferenceID;
                    objCentralCmd.Parameters.Add("@in_vAction", SqlDbType.VarChar, 250).Value = "CheckDuplicateFile";
                    objCentralCmd.Parameters.Add("@in_iLoginOrgId", SqlDbType.Int).Value =strOrgId;
                    objCentralCmd.Parameters.Add("@in_iUserId", SqlDbType.Int).Value = strUserId;
                    objCentralCmd.Parameters.Add("@in_iUploadedId", SqlDbType.Int).Value = Convert.ToInt32(strUploadId);
                    Trace("User Id " + strImagePath);
                        
                    Adpt.SelectCommand = objCentralCmd;
                    Adpt.Fill(dSet); 
                    if (0 == 0)
                    {
                        string name=string.Empty;
                        if (dSet.Tables != null && dSet.Tables[0].Rows.Count > 0)
                        {
                            mstrDestFolder = string.Empty;
                            mstrDestFolder = ConfigurationManager.AppSettings.Get("MergeDestinationFolder").ToString();
                            //strImagePath = dSet.Tables[0].Rows[0][1].ToString();
                            name = string.Format(@"\kodak\788\{0}",DateTime.Today.ToString("yyyy-MM-dd"));
                            strImagePath = mstrDestFolder + name; 
                            if (!Directory.Exists(strImagePath))
                            {
                                Directory.CreateDirectory(strImagePath);
                            }
                            strImagePath = strImagePath + @"\" + Encryptdata(strReferenceID) + strImgName.Substring(strImgName.LastIndexOf('.'));
                        }
                        else
                        {
                            //strImagePath = pathh + @"\" + strImgName.Replace("#_#", "_");
                            name = string.Format(@"\kodak\788\{0}",DateTime.Today.ToString("yyyy-MM-dd"));
                            strImagePath = mstrDestFolder + name; 
                            if (!Directory.Exists(strImagePath))
                            {
                                Directory.CreateDirectory(strImagePath);
                            }
                            strImagePath = strImagePath + @"\" + Encryptdata(strReferenceID) + strImgName.Substring(strImgName.LastIndexOf('.'));

                        }
                  
                        string mNewFile;
                        //mNewFile= mstrDestFolder + @"\" + strBranchCode +"#" + strProductvalue +"#" + strImgName;
                        mNewFile = strImagePath.ToString();
                        FileStream fstImgOutput = new FileStream(mNewFile, FileMode.Create, FileAccess.Write);
                        BinaryWriter bwImgOutput = new BinaryWriter(fstImgOutput);
                        Trace("Writing Binary Image File " + strImagePath);
                        bwImgOutput.Write(btImage);
                        Trace("Sucessfully Created Image File " + strImagePath);
                        bwImgOutput.Close();
                        fstImgOutput.Close();

                        //-----------Saving Orginal XML
                        //xmdocInput.Save(strImagePath.ToUpper().Replace(".TIF",".XML"));
                        //---------
                        if (dSet.Tables != null && dSet.Tables[0].Rows.Count > 0)
                        {
                            DataTable dt = new DataTable();
                            Trace("Inserting Data into Table");
                            objCentralCmd.Dispose();
                            objCentralCmd = new SqlCommand();
                            objCentralCmd.Connection = objCentralCon;
                            objCentralCmd.CommandType = CommandType.StoredProcedure;
                            objCentralCmd.CommandText = "USP_DMS_doQ_ManageDoQScan";
                            objCentralCmd.Parameters.Add("@in_vAction", SqlDbType.VarChar, 100).Value = "MergeScannedDocuments";
                            objCentralCmd.Parameters.Add("@in_vImgName", SqlDbType.VarChar, 250).Value = strImgName.ToString();
                            objCentralCmd.Parameters.Add("@in_vImgVirPath", SqlDbType.VarChar, 800).Value = mVirtualPath + "/" + strImgName.ToString();
                            objCentralCmd.Parameters.Add("@in_vImgPhyPath", SqlDbType.VarChar, 800).Value = mNewFile.ToString();
                            objCentralCmd.Parameters.Add("@in_vImgMimeType", SqlDbType.VarChar, 250).Value = "application/pdf";
                            objCentralCmd.Parameters.Add("@in_iSize", SqlDbType.SmallInt).Value = 0;
                            objCentralCmd.Parameters.Add("@in_iLoginOrgId", SqlDbType.Int).Value = strOrgId;
                            objCentralCmd.Parameters.Add("@in_vVersion", SqlDbType.VarChar, 20).Value = "1.0";
                            objCentralCmd.Parameters.Add("@in_iUserId", SqlDbType.Int).Value = strUserId;
                            objCentralCmd.Parameters.Add("@in_vReferenceID", SqlDbType.VarChar, 1000).Value = strReferenceID;
                            objCentralCmd.Parameters.Add("@in_vLANnumber", SqlDbType.VarChar, 1000).Value = strLANNumber;// strLANNumber;
                            objCentralCmd.Parameters.Add("@in_iUploadedId", SqlDbType.VarChar, 1000).Value = strUploadId;// strUploadId;



                            Trace(string.Format("{0} - {1} - {2} - {3} - {4}", strReferenceID, strLANNumber, strUserId, strMachine, strOrgId));

                            //objCentralCmd.Parameters.Add("@GroupID", SqlDbType.Int).Value = strUserId;
                            //objCentralCmd.Parameters.Add("@CreatedDate", SqlDbType.DateTime).Value = DateTime.Now; --Commented by praveen to introduce next line to save scna date.
                            // objCentralCmd.Parameters.Add("@CreatedDate", SqlDbType.DateTime).Value =Convert.ToDateTime(strDate);
                            //  objCentralCmd.Parameters.Add("@ModifiedDate", SqlDbType.DateTime).Value = DateTime.Now;
                            //  objCentralCmd.Parameters.Add("@CatID", SqlDbType.Int).Value = 1001;
                            //   objCentralCmd.Parameters.Add("@Priority", SqlDbType.Int).Value = 1;
                            //   objCentralCmd.Parameters.Add("@", SqlDbType.Int).Value = 1;

                           

                            Trace("Executing : " + objCentralCmd.CommandText.ToString());
                            objCentralCmd.ExecuteNonQuery();
                            Trace("Sucessfully Inserted Record in database");
                            Adpt.SelectCommand = objCentralCmd;
                            Adpt.Fill(dt);
                            if (dt.Rows.Count>0)
                            {
                                int count = 0;
                                string physicalpath = dt.Rows[0]["Destination"].ToString();
                                int index = physicalpath.LastIndexOf("\\");
                                string ExtractPath = physicalpath.Substring(0, index) + "\\";

                                string DocumentId = dt.Rows[0]["DocumentId"].ToString();
                                string refId = dt.Rows[0]["RefID"].ToString();
                                string DocName = dt.Rows[0]["DocName"].ToString();
                                DocName = DocName.Substring(0, DocName.LastIndexOf("."));
                                string TempLocation = dt.Rows[0]["TempLocation"].ToString();
                                string physicalpathzip = physicalpath.Substring(0, physicalpath.LastIndexOf("\\"));
                           //     string splittedpath = ConfigurationManager.AppSettings.Get("splitedDestinationFolder").ToString();

                                Trace("Executing : File Processing Started " + DocumentId);
                                string extractTempLocation = TempLocation.Substring(0, TempLocation.LastIndexOf("\\"));
                               
                               // Unzip(extractTempLocation, DocName+".zip");


                                count = new Image2Pdf().ExtractPages(TempLocation);
                                Trace("Executing : File Temp file split completed " + extractTempLocation + "For lan - " + DocumentId + " With count-" + count);

                                string pathfolder = TempLocation.ToLower().Replace(".pdf", "");
                                Unzip(physicalpathzip, DocName);
                                Trace("Executing : File Temp zip extraction completed " + physicalpathzip + "For lan - " + DocumentId);
                                Trace("Executing : Original file moving to BackUp folder " + physicalpathzip + "For lan - " + DocumentId);
                                string path = physicalpath.Substring(0, physicalpath.LastIndexOf("\\") + 1);
                                string bakpath = Path.Combine(path, "BackUp");
                                string sourcefile = string.Empty;
                                if (!Directory.Exists(bakpath))
                                {
                                    Directory.CreateDirectory(bakpath);
                                }
                                sourcefile = physicalpath.Insert(physicalpath.LastIndexOf("\\"), "\\BackUp");
                                File.Copy(physicalpath, sourcefile, true);
                                Trace("Executing : File Movement completed " + physicalpathzip + "For lan - " + DocumentId);
                                for (int i = 0; i < dt.Rows.Count; i++)
                                {
                                    string mergepage = pathfolder + "\\" + dt.Rows[i]["PageOrder"].ToString() + ".pdf";
                                    int Position = Convert.ToInt32(dt.Rows[i]["PageNumber"].ToString());
                                    string[] source = new string[] { physicalpath, mergepage };
                                    PDFCopy.MergeFiles(physicalpath, source, Position, "add");
                                   
                                }
                                Trace("Executing : File Merge completed " + physicalpath + "For lan " + DocumentId);
                                if (File.Exists(physicalpath.Replace(".pdf", "")))
                                {
                                    File.Delete(physicalpath.Replace(".pdf", ""));
                                   
                                }
                                if (File.Exists(physicalpath.Replace(".pdf", "") + ".zip"))
                                {
                                
                                    File.Delete(physicalpath.Replace(".pdf", "") + ".zip");
                                   
                                }
                                count = new Image2Pdf().ExtractPages(physicalpath);
                                FileZip.Zip(physicalpath, true);
                                Trace("Executing : File Merge completed " + physicalpath + "For lan " + DocumentId);

                            }
                        }
                        else if (strOrgId != "0")
                        {
                            //====================================Database Side Coding
                            Trace("Inserting Data into Table");
                            objCentralCmd.Dispose();
                            objCentralCmd = new SqlCommand();
                            objCentralCmd.Connection = objCentralCon;
                            objCentralCmd.CommandType = CommandType.StoredProcedure;
                            objCentralCmd.CommandText = "USP_DMS_doQ_ManageDoQScan";
                            objCentralCmd.Parameters.Add("@in_vAction", SqlDbType.VarChar,100).Value = "UploadScannedDocuments";
                            objCentralCmd.Parameters.Add("@in_vImgName", SqlDbType.VarChar, 250).Value = strImgName.ToString();
                            objCentralCmd.Parameters.Add("@in_vImgVirPath", SqlDbType.VarChar, 800).Value = mVirtualPath + "/" + strImgName.ToString();
                            objCentralCmd.Parameters.Add("@in_vImgPhyPath", SqlDbType.VarChar, 800).Value = mNewFile.ToString();
                            objCentralCmd.Parameters.Add("@in_vImgMimeType", SqlDbType.VarChar, 250).Value = "application/pdf";
                            objCentralCmd.Parameters.Add("@in_iSize", SqlDbType.SmallInt).Value = 0;
                            objCentralCmd.Parameters.Add("@in_iLoginOrgId", SqlDbType.Int).Value = strOrgId;
                            objCentralCmd.Parameters.Add("@in_vVersion", SqlDbType.VarChar, 20).Value = "1.0";
                            objCentralCmd.Parameters.Add("@in_iUserId", SqlDbType.Int).Value =strUserId  ;
                            objCentralCmd.Parameters.Add("@in_vReferenceID", SqlDbType.VarChar, 1000).Value = strReferenceID;
                            objCentralCmd.Parameters.Add("@in_vLANnumber", SqlDbType.VarChar, 1000).Value = strLANNumber;// strLANNumber;
                            objCentralCmd.Parameters.Add("@in_iUploadedId", SqlDbType.VarChar, 1000).Value = strUploadId;// strUploadId;
                            


                            Trace(string.Format("{0} - {1} - {2} - {3} - {4}", strReferenceID, strLANNumber, strUserId, strMachine, strOrgId));            
                          
                            //objCentralCmd.Parameters.Add("@GroupID", SqlDbType.Int).Value = strUserId;
                           //objCentralCmd.Parameters.Add("@CreatedDate", SqlDbType.DateTime).Value = DateTime.Now; --Commented by praveen to introduce next line to save scna date.
                           // objCentralCmd.Parameters.Add("@CreatedDate", SqlDbType.DateTime).Value =Convert.ToDateTime(strDate);
                          //  objCentralCmd.Parameters.Add("@ModifiedDate", SqlDbType.DateTime).Value = DateTime.Now;
                          //  objCentralCmd.Parameters.Add("@CatID", SqlDbType.Int).Value = 1001;
                         //   objCentralCmd.Parameters.Add("@Priority", SqlDbType.Int).Value = 1;
                         //   objCentralCmd.Parameters.Add("@", SqlDbType.Int).Value = 1;


                            Trace("Executing : " + objCentralCmd.CommandText.ToString());
                            objCentralCmd.ExecuteNonQuery();
                            Trace("Sucessfully Inserted Record in database");
                        }
                        Trace("Creating Acknowledgment XML with 'Sucess' Tag for Image file Creation");
                        strAck = GenerateAck(true, "", strTxtName, strImgName);
                        Trace("Sucessfully Completed processing " + strImagePath);
                    }
                    else
                    {
                        Trace("Creating Acknowledgment XML with 'Sucess' Tag for Image file Creation");
                        strAck = GenerateAck(true, "", strTxtName, strImgName);
                        Trace("Sucessfully Completed processing " + strImagePath);
                    }
                    objCentralCon.Close();
                    objCentralCmd.Dispose();
                    Adpt.Dispose();
                    dSet.Dispose();
                }

            }
            catch (Exception exe)
            {
                WriteErrorToFIle(exe);
                Trace("Error : " + exe.Message.ToString());
                Trace("Error : " + exe.Source.ToString());
                strAck = GenerateAck(false, exe.Message + "--" + strDate, "", "");
            }
            finally
            {

            }

            return strAck;
        }

        public string Encryptdata(string password)
        {
            string strmsg = string.Empty;
            byte[] encode = new
            byte[password.Length];
            encode = Encoding.UTF8.GetBytes(password);
            strmsg = Convert.ToBase64String(encode);
            return strmsg;
        }

        public static string GetConnectionString()
        {
            string AzureKeyVault = ConfigurationManager.AppSettings["AzureKeyVault"];
            string ConnectionString = string.Empty;

            if (AzureKeyVault == "True")
            {
                if (AzureConfiguration.AzureConnection == null)
                {
                    AzureConfiguration AzConfiguration = new AzureConfiguration();

                    string res = AzConfiguration.GetConfiguration();

                    ConnectionString = AzureConfiguration.AzureConnection;
                }
                else
                {
                    ConnectionString = AzureConfiguration.AzureConnection;
                }

            }
            else
            {
                ConnectionString = ConfigurationManager.AppSettings["doQscan_ConnectionStirng"];
            }


            return ConnectionString;


        }

        #endregion
        #region Error Logging
        public void WriteErrorToFIle(string strMessage)
        {
            string strErrorFile = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "ErrorFile.txt";
            StreamWriter sw;
            if (File.Exists(strErrorFile))
            {
                sw = File.AppendText(strErrorFile);
            }
            else
            {
                sw = File.CreateText(strErrorFile);
            }
            sw.WriteLine(" ");
            sw.WriteLine("********************************");
            sw.WriteLine("Event Time : " + DateTime.Now.ToString());
            sw.WriteLine("Error Description : " + strMessage);
            sw.WriteLine("********************************");
            sw.WriteLine("user	 : " + Environment.UserName);
            sw.WriteLine(" ");
            sw.Close();
        }
        public void WriteErrorToFIle(Exception exe)
        {
            string strErrorFile = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "ErrorFile.txt";
            StreamWriter sw;
            if (File.Exists(strErrorFile))
            {
                sw = File.AppendText(strErrorFile);
            }
            else
            {
                sw = File.CreateText(strErrorFile);
            }
            sw.WriteLine(" ");
            sw.WriteLine("********************************");
            sw.WriteLine("Event Time : " + DateTime.Now.ToString());
            sw.WriteLine("Error Description : " + exe.Message);
            sw.WriteLine("Error Line Number : " + exe.StackTrace);
            sw.WriteLine("Error Source		 : " + exe.Source);
            sw.WriteLine("user	 : " + Environment.UserName);
            sw.WriteLine("********************************");
            sw.WriteLine(" ");
            sw.Close();
        }
        # endregion
        
        public string GenerateAck(bool pblnSuccess, string pstrMessage, string strTextFileName, string strImageFileName)
       { 
            StringBuilder sbAck = new StringBuilder();
            sbAck.Append("<?xml version = \"1.0\" ?>");
           
            if (pblnSuccess)
            {
                //sbMISAck.Append("<response><status>SUCCESS</status></response>");
                sbAck.Append("<Ack>");
                //sbAck.Append("<Ack_code>1000</Ack_code>");
                sbAck.Append("<Ack_Status>OK</Ack_Status>");
                sbAck.Append("<Ack_Msg>" + pstrMessage + "</Ack_Msg>");
                sbAck.Append("<Ack_ImageFileName>" + strImageFileName + "</Ack_ImageFileName>");
                sbAck.Append("</Ack>");
            }
            else
            {
                sbAck.Append("<Ack>");
                //sbAck.Append("<Ack_code>1210</Ack_code>");
                sbAck.Append("<Ack_Status>ERROR</Ack_Status>");
                sbAck.Append("<Ack_Msg>" + pstrMessage + "</Ack_Msg>");
                sbAck.Append("<Ack_ImageFileName>" + strImageFileName + "</Ack_ImageFileName>");
                sbAck.Append("</Ack>");
                
            }
            return sbAck.ToString();
        }
        public string GenerateTokenAck(string TokenString)
        {
            StringBuilder sbAck = new StringBuilder();
            sbAck.Append("<?xml version = \"1.0\" ?>");
            sbAck.Append("<Ack>");
            sbAck.Append("<Ack_Status>" + TokenString + "</Ack_Status>");
            sbAck.Append("<Ack_Msg>" + mdoQRouterVersion + "</Ack_Msg>");
            sbAck.Append("<Ack_Path>" + mSUSPath + "</Ack_Path>");
            sbAck.Append("</Ack>");
            return sbAck.ToString();
           
        }
        public static string EncryptData(string strTextToEncrypt)
        {
            
            string strEncodingKey = "";
            RSACryptoServiceProvider RSACrypto;
            byte[] bHash, bEncryptedData;
            StringBuilder sbEncryptedData = new StringBuilder();
                strEncodingKey = @"<RSAKeyValue><Modulus>kgjZ3OWr1f7QlVbb+jHeB7uyXLa/N2PQVfc37T/8XscCyDH+JsMvbXaM5n2p7c0pi6b+VY+u9/HDJQEZGQXolhJ2zm9rCdJL6nzAVBtcBVfkurKNUhpp8+ENNlzVETaC18PqSztcrjBR00juAswHmfoszCFoeg+DkVSi5btV9hJMvgA7k3LPyaKYJMgrfAbAU0Uh6ruFMuWBhLJLKIzOnAzRsK+LB0EFvnLit4Nv/I7GIv4tBdq3Ujhb2Lb8Yh7p9t4mKJKe8QkK9mkfrFBaksjvOFzZ27nuOiWzg8+99IvLwtt8ApKtp+zxk/b5hpMKCZICsdJnLSCEruuO4DRoaw==</Modulus><Exponent>AQAB</Exponent></RSAKeyValue>";
                sbEncryptedData = new StringBuilder();
                RSACrypto = new RSACryptoServiceProvider();
                bHash = System.Text.Encoding.Unicode.GetBytes(strTextToEncrypt.ToCharArray(), 0, strTextToEncrypt.ToCharArray().Length);
                RSACrypto.FromXmlString(strEncodingKey);
                bEncryptedData = RSACrypto.Encrypt(bHash, false);
                foreach (byte b in bEncryptedData)
                sbEncryptedData.Append(String.Format("{0:X2}", b));
            return sbEncryptedData.ToString();
        }
        public static string DecryptData(string strEncryptedData)
        {
            byte[] bEncryptedData, bDecryptedData;
            string strHex, strDecodingKey = "", strDecryptedString = "";
            int intCounter, intPos = 0;
            CspParameters RSAParams = new CspParameters();//artf10001A
            RSAParams.Flags = CspProviderFlags.UseMachineKeyStore;//artf10001A
            RSACryptoServiceProvider RSACrypto = new RSACryptoServiceProvider(1024, RSAParams);//artf10001C
            bEncryptedData = new byte[strEncryptedData.Length / 2];
            for (intCounter = 0; intCounter < bEncryptedData.Length; intCounter++)
            {
                strHex = new String(new char[] { strEncryptedData[intPos], strEncryptedData[intPos + 1] });
                bEncryptedData[intCounter] = byte.Parse(strHex, System.Globalization.NumberStyles.HexNumber);
                intPos += 2;
            }

            // RSACrypto = new RSACryptoServiceProvider();//artf10001D
            strDecodingKey = @"<RSAKeyValue><Modulus>kgjZ3OWr1f7QlVbb+jHeB7uyXLa/N2PQVfc37T/8XscCyDH+JsMvbXaM5n2p7c0pi6b+VY+u9/HDJQEZGQXolhJ2zm9rCdJL6nzAVBtcBVfkurKNUhpp8+ENNlzVETaC18PqSztcrjBR00juAswHmfoszCFoeg+DkVSi5btV9hJMvgA7k3LPyaKYJMgrfAbAU0Uh6ruFMuWBhLJLKIzOnAzRsK+LB0EFvnLit4Nv/I7GIv4tBdq3Ujhb2Lb8Yh7p9t4mKJKe8QkK9mkfrFBaksjvOFzZ27nuOiWzg8+99IvLwtt8ApKtp+zxk/b5hpMKCZICsdJnLSCEruuO4DRoaw==</Modulus><Exponent>AQAB</Exponent><P>w5O+ATGw5zqP6YRWuWybuXIxQ0hvXY4WGRxE451edYMqQ7roIs5Pqmrvtaa/lVMAFuvbjBRt8CC5oLBbx4pqwQ/4Ski7mDMCNATueNAumq/59DJLV/D5lkuUzSF+h2+dK8qOGWzH07UUbHkv9ZlPW76pxvgES6OZx+4eNFPwrFE=</P><Q>vybF3/ldYXYVwbd9Scthsh1aJdpHZyqsa0LGWvtM9cL7ZK7JGYoJ7iWeeLgw/ThWLxBHXd4sRzKZZm6dE9DZeJUh4wp/2Y3bCL2x2JoIgSznKV5UncbCRtXzR1rqfY5CsrydJreuz46fpjxJubEx3D3ZgQGYnBpYvmhOewzn5fs=</Q><DP>r2vyTiHi+dQGRz8jhpfLKdAqLZ5n/XM3kPhRNhPuKNsoaq3YD3gb7tCSB830I5zaBLUzLHcakPrZZS8qc1VNIbQQUZjhYsfF3yDZQVYBp0/Wk9kUyWFkjRFn+4Jielp7kE7TnCx9JABUvGMKyHDlxHXE1KmbOLkac0C6qNbtlbE=</DP><DQ>sDfNWXJonM2gtwoyLVKaiPo4PgchpkEX3HYdqIhdZX9QBHyBldLE3s+9bSrYtsg144NNV4LXLPe/pUe59SenJFvPdqAaRvRYhZFjH/y4dGVx4Zg9x4oRVf4tHY35+K+qW144PhY9yMiB811G1jI9df1qw1w2VUqQn1BHcXbvXfs=</DQ><InverseQ>vCyZn/yXxUrfuZZZegCoVGles8zNE5kRiW4A5SY3JoiHnOt23YiJqapZxint/cv305qLTU1G/H6g0a5hDvrblTLvocuCj1+KnqlIcJasY0P6XC5hcBAmc00ETBgkiqu9PGE6HJpFgbh1KK3TpIkDMPiCUecyYabr3YGZajQt9Y0=</InverseQ><D>M2AJxTzHhzFuEBvOp+aDRhUyWouwGbxzvsqKUl0AXBeHUwbDcr+YH9plF3F+JrrWstq8/zzdQT08efg47CS3/pPgWB+6eGoTaxsYTn6RkQ+q2EOYlBnWzIWQMF/YVYXn4iB6fJ0VrfIx1zMBCNrekb0BpY7bQpXSo34zEL8nLroZV8CXzcIQBSp17j53K/hcab8c0sFZNZ65kFWEhdm1KLN6Qg+VftLMBik/iSmh3gMSkpjwsAUxAmuLswzAcbjd7uYS1Hsm2puOn4k1hut6tGQpzekWGdN4EEDjgacRyzYQ777AURNsVHXtcjiBtUBPtWhJKCUp/+MeZ+O6nQOiAQ==</D></RSAKeyValue>";
            RSACrypto.FromXmlString(strDecodingKey);
            bDecryptedData = RSACrypto.Decrypt(bEncryptedData, false);
            strDecryptedString = System.Text.Encoding.Unicode.GetString(bDecryptedData, 0, bDecryptedData.Length);
            return strDecryptedString;
            
        }
        public void Trace(string msgStr)
        {
            string strErrorFile = "";
            string foldername = System.AppDomain.CurrentDomain.BaseDirectory.ToString() + "Logs\\" + mComputerName + "\\" ;
            strErrorFile = DateTime.Now.ToString("yyyyMMdd");
            strErrorFile = foldername + strErrorFile + ".Log";
            if (File.Exists(foldername)==false)
            {
                System.IO.Directory.CreateDirectory(@foldername); 
            }
            StreamWriter sw;
            if (File.Exists(strErrorFile))
            {
                sw = File.AppendText(strErrorFile);
            }
            else
            {
                sw = File.CreateText(strErrorFile);
            }
            sw.WriteLine(DateTime.Now.ToString() + ": " + msgStr);
            sw.Close();
        }
        public void Unzip(string ExtractFilePath, string FileName)
        {
            try
            {
                string path = Path.Combine(ExtractFilePath , FileName + ".zip");

                using (ZipFile zip = ZipFile.Read(new FileEncryptDecrypt().DecryptFile(path)))
                {
                    zip.ExtractAll(ExtractFilePath, ExtractExistingFileAction.DoNotOverwrite);
                }


            }
            catch (Exception)
            {
               // Logger.Trace("Error while unzipping.", "TraceStatus");

            }
        }
    }
}
