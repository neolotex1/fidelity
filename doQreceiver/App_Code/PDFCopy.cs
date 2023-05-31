using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.IO;

/// <summary>
/// Summary description for PDFCopy
/// </summary>
public class PDFCopy
{
    public static void MergeFiles(string destinationFile, string[] sourceFiles, int position, string action)
    {
        try
        {
            if (sourceFiles.Count() < 2)
            {
                return;
            }
            if (sourceFiles[0].ToLower().Equals(destinationFile.ToLower()))
            {
                string path = destinationFile.Substring(0, destinationFile.LastIndexOf("\\") + 1);
                //  path = ConfigurationManager.AppSettings.Get("TempFolder").ToString(); 

                path = Path.Combine(path, "Temp");

                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }

                sourceFiles[0] = destinationFile.Insert(destinationFile.LastIndexOf("\\"), "\\Temp");
                File.Copy(destinationFile, sourceFiles[0], true);

            }
            using (Document document = new Document())
            {
                using (PdfCopy copy = new PdfCopy(document, new System.IO.FileStream(destinationFile,
                                                      System.IO.FileMode.OpenOrCreate,
                                                      System.IO.FileAccess.Write)))
                {
                    document.Open();
                    // reader for document 1
                    PdfReader reader1 = new PdfReader(sourceFiles[0]);
                    int n1 = reader1.NumberOfPages;
                    //int file1count = CountPageNo(sourceFiles[0]);
                    // reader for document 2
                    PdfReader reader2 = new PdfReader(sourceFiles[1]);
                    int n2 = reader2.NumberOfPages;
                    // initializations
                    PdfImportedPage page;
                    PdfCopy.PageStamp stamp;
                    // Loop over the pages of document 1
                    for (int i = 1; i <= n1; i++)
                    {
                        if (n1 <= position)
                        {
                            page = copy.GetImportedPage(reader1, i);
                            stamp = copy.CreatePageStamp(page);
                            // add page numbers
                            //ColumnText.ShowTextAligned(
                            //  stamp.GetUnderContent(), Element.ALIGN_CENTER,
                            //  new Phrase(string.Format("page {0} of {1}", i, n1 + n2)),
                            //  297.5f, 28, 0
                            //);
                            stamp.AlterContents();
                            copy.AddPage(page);
                            int lastposition = position - 1;
                            if (i == lastposition)
                            {
                                for (int j = 1; j <= n2; j++)
                                {
                                    page = copy.GetImportedPage(reader2, j);
                                    stamp = copy.CreatePageStamp(page);
                                    // add page numbers
                                    //ColumnText.ShowTextAligned(
                                    //  stamp.GetUnderContent(), Element.ALIGN_CENTER,
                                    //  new Phrase(string.Format("page {0} of {1}", n1 + i, n1 + n2)),
                                    //  297.5f, 28, 0
                                    //);
                                    stamp.AlterContents();
                                    copy.AddPage(page);
                                }
                            }
                        }
                        if (i == position)
                        {
                            for (int j = 1; j <= n2; j++)
                            {
                                page = copy.GetImportedPage(reader2, j);
                                stamp = copy.CreatePageStamp(page);
                                // add page numbers
                                //ColumnText.ShowTextAligned(
                                //  stamp.GetUnderContent(), Element.ALIGN_CENTER,
                                //  new Phrase(string.Format("page {0} of {1}", n1 + i, n1 + n2)),
                                //  297.5f, 28, 0
                                //);
                                stamp.AlterContents();
                                copy.AddPage(page);
                            }
                        }
                        if (n1 > position)
                        {
                            page = copy.GetImportedPage(reader1, i);
                            stamp = copy.CreatePageStamp(page);
                            // add page numbers
                            //ColumnText.ShowTextAligned(
                            //  stamp.GetUnderContent(), Element.ALIGN_CENTER,
                            //  new Phrase(string.Format("page {0} of {1}", i, n1 + n2)),
                            //  297.5f, 28, 0
                            //);
                            stamp.AlterContents();
                            copy.AddPage(page);
                        }


                    }

                    // Loop over the pages of document 2

                }
            }
        }
        catch (Exception e)
        {
            throw;
        }



    }

    public static int CountPageNo(string strFileName)
    {
        // we create a reader for a certain document
        PdfReader reader = new PdfReader(strFileName);
        // we retrieve the total number of pages
        reader.Close();

        return reader.NumberOfPages;
    }
}