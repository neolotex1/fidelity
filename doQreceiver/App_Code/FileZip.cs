using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Ionic.Zip;
using System.IO;
using doQRouter;

public static class FileZip
{
    /// <summary>
    /// Zip the file in same location where the original file is exist.
    /// </summary>
    /// <param name="FilePath"></param>
    /// <param name="DeleteSource">Delete source file. Default value is false.</param>
    /// <returns></returns>
    public static bool Zip(string FilePath, bool DeleteSource = false)
    {
        bool Status = false;
        try
        {
            using (ZipFile zip = new ZipFile())
            {
                if (File.Exists(FilePath))
                {
                    zip.AddFile(FilePath, "");
                    zip.Save(IOUtility.beforedot(FilePath) + ".zip");
                    if (DeleteSource)
                        File.Delete(FilePath);
                }
            }
            Status = true;
        }
        catch
        {
            throw;
        }
        return Status;
    }

    /// <summary>
    /// Unzip the file in same location where the zipped file is exist.
    /// </summary>
    /// <param name="FilePath">Zipped file path</param>
    public static bool Unzip(string FilePath, bool DeleteSource = false)
    {
        bool Status = false;
        try
        {
            string ExtractFolderPath = FilePath.Replace(Path.GetFileName(FilePath), string.Empty);
            using (ZipFile zip = ZipFile.Read((Stream)new FileEncryptDecrypt().DecryptFile(FilePath)))
            {
                zip.ExtractAll(ExtractFolderPath, ExtractExistingFileAction.DoNotOverwrite);
            }

            //using (ZipFile zip = ZipFile.Read(FilePath))
            //{
            //    zip.ExtractAll(ExtractFolderPath, ExtractExistingFileAction.DoNotOverwrite);
            //}
            if (DeleteSource)
                File.Delete(FilePath);
            Status = true;
        }
        catch
        {
            throw;
        }
        return Status;
    }

    public static string ZipDirectory(string FilePath)
    {
        bool Status = false;
        string path = string.Empty;
        try
        {
            //using (ZipFile zip = new ZipFile())
            //{
            //    zip.AddDirectory(FilePath, foldername);
            //    zip.Save(FilePath);
            //    //zip.CreateFromDirectory(@"D:\Folder", @"Folder.zip");
            //}
            var directories = Directory.GetFiles(FilePath);

            using (ZipFile zip = new ZipFile())
            {

                foreach (var item in directories)
                {
                    if (File.Exists(item))
                    {
                        zip.AddFile(item, "");
                        

                    }
                }
                if (zip.Count > 0)
                {
                    path = FilePath + ".zip";
                    zip.Save(path);
                    
                }


            }
            Status = true;
        }
        catch
        {
            throw;
        }
        return path;
    }

   
  
}
