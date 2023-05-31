using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Security.Cryptography;

namespace doQRouter
{
    public class FileEncryptDecrypt
    {
        ///<summary>
        /// Steve Lydford - 12/05/2008.
        ///
        /// Encrypts a file using Rijndael algorithm.
        ///</summary>
        ///<param name="inputFile"></param>
        ///<param name="outputFile"></param>
        public MemoryStream EncryptFile(string SourcePath)
        {
            byte[] FileBytes = File.ReadAllBytes(SourcePath);

            DESCryptoServiceProvider cryptic = new DESCryptoServiceProvider();
            cryptic.Key = ASCIIEncoding.ASCII.GetBytes("!#$a54?3");
            cryptic.IV = ASCIIEncoding.ASCII.GetBytes("WINTEROF");
            MemoryStream memoryStream = new MemoryStream();

            var cryptoStream = new CryptoStream(memoryStream, cryptic.CreateEncryptor(), CryptoStreamMode.Write);
            cryptoStream.Write(FileBytes, 0, FileBytes.Length);
            cryptoStream.FlushFinalBlock();
            return memoryStream;
        }
        ///<summary>
        /// Steve Lydford - 12/05/2008.
        ///
        /// Decrypts a file using Rijndael algorithm.
        ///</summary>
        ///<param name="inputFile"></param>
        ///<param name="outputFile"></param>
        public MemoryStream DecryptFile(string SourcePath)
        {
            DESCryptoServiceProvider cryptic = new DESCryptoServiceProvider();
            cryptic.Key = ASCIIEncoding.ASCII.GetBytes("!#$a54?3");
            cryptic.IV = ASCIIEncoding.ASCII.GetBytes("WINTEROF");
            MemoryStream memoryStream = new MemoryStream();

            byte[] FileBytes = File.ReadAllBytes(SourcePath);

            var cryptoStream = new CryptoStream(memoryStream, cryptic.CreateDecryptor(), CryptoStreamMode.Write);
            cryptoStream.Write(FileBytes, 0, FileBytes.Length);
            cryptoStream.FlushFinalBlock();
            memoryStream.Seek(0, SeekOrigin.Begin);
            return memoryStream;

        }

        ///<summary>
        /// Steve Lydford - 12/05/2008.
        ///
        /// Decrypts a file using Rijndael algorithm.
        ///</summary>
        ///<param name="inputFile"></param>
        ///<param name="outputFile"></param>
        public MemoryStream DecryptFileFromStream(MemoryStream srcStream)
        {
            string password = @"QAZWSXEDCRFV909"; // Your Key Here

            UnicodeEncoding UE = new UnicodeEncoding();
            byte[] key = UE.GetBytes(password);

            byte[] FileBytes = srcStream.ToArray();

            RijndaelManaged RMCrypto = new RijndaelManaged();

            using (var memoryStream = new MemoryStream())
            {
                using (var cryptoStream = new CryptoStream(memoryStream, RMCrypto.CreateDecryptor(key, key), CryptoStreamMode.Write))
                {
                    cryptoStream.Write(FileBytes, 0, FileBytes.Length);
                    cryptoStream.FlushFinalBlock();
                    return memoryStream;
                }
            }

        }

        public string CalculateMD5(MemoryStream ms)
        {
            using (var md5 = MD5.Create())
            {
                using (var stream = ms)
                {
                    var hash = md5.ComputeHash(stream);
                    return BitConverter.ToString(hash).Replace("-", "").ToLowerInvariant();
                }
            }
        }

        public string CalculateMD5(string filename)
        {
            using (var md5 = MD5.Create())
            {
                using (var stream = File.OpenRead(filename))
                {
                    var hash = md5.ComputeHash(stream);
                    return BitConverter.ToString(hash).Replace("-", "").ToLowerInvariant();
                }
            }
        }
    }
}
