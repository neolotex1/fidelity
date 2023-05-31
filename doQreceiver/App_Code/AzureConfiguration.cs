using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

namespace doQrecevier
{
    public class AzureConfiguration
    {

        public static string AzureConnection;
        public string GetConfiguration()
        {
            string KVURL = ConfigurationManager.AppSettings["KvURL"];
            string TenantId = ConfigurationManager.AppSettings["TenantId"];
            string ClientId = ConfigurationManager.AppSettings["ClientId"];
            string ClientSecret = ConfigurationManager.AppSettings["ClientSecret"];
            string AzureKeyVault = ConfigurationManager.AppSettings["AzureKeyVault"];
            string SecretName = ConfigurationManager.AppSettings["SecretName"];



            if (AzureKeyVault == "True")
            {
                var Credential = new ClientSecretCredential(TenantId, ClientId, ClientSecret);

                var Client = new SecretClient(new Uri(KVURL), Credential);

                var Secret = Client.GetSecret(SecretName).Value;
                string GlobalConnectionString = Secret.Value.ToString();

                AzureConnection = GlobalConnectionString;

                return GlobalConnectionString;
            }
            else
            {
                return ConfigurationManager.ConnectionStrings["doQscan_ConnectionStirng"].ConnectionString;
            }
        }
    }
}